class_name SpellBarUI
extends HBoxContainer

@export var slot_scene: PackedScene
@export var num_slots: int = 5

var slots: Array[SpellBarSlot] = []
var player: Player
var ability_manager: AbilityManager

func _ready() -> void:
	# Create slots
	for i in range(num_slots):
		var slot: SpellBarSlot
		if slot_scene:
			slot = slot_scene.instantiate()
		else:
			slot = _create_default_slot()
		
		add_child(slot)
		slots.append(slot)
		slot.set_ability(null, i)

func setup(p: Player) -> void:
	player = p
	ability_manager = player.get_node("AbilityManager")
	
	if ability_manager:
		ability_manager.cooldown_updated.connect(_on_cooldown_updated)
		ability_manager.ability_used.connect(_on_ability_used)
		_update_abilities()

func _update_abilities() -> void:
	if not ability_manager:
		return
	
	for i in range(slots.size()):
		if i < ability_manager.abilities.size():
			slots[i].set_ability(ability_manager.abilities[i], i)
		else:
			slots[i].set_ability(null, i)

func _on_cooldown_updated(ability_index: int, time_remaining: float) -> void:
	if ability_index >= 0 and ability_index < slots.size():
		var was_on_cooldown = slots[ability_index].cooldown_overlay.visible
		slots[ability_index].update_cooldown(time_remaining)
		
		# Flash when coming off cooldown
		if was_on_cooldown and time_remaining <= 0:
			slots[ability_index].flash_ready()

func _on_ability_used(ability: AbilityData) -> void:
	# Find which slot this ability is in and trigger visual feedback
	for i in range(slots.size()):
		if slots[i].ability == ability:
			_flash_ability_use(slots[i])
			break

func _flash_ability_use(slot: SpellBarSlot) -> void:
	# Quick flash effect when ability is used
	var tween = create_tween()
	tween.tween_property(slot, "modulate", Color(2, 2, 2), 0.05)
	tween.tween_property(slot, "modulate", Color(1, 1, 1), 0.15)

func _create_default_slot() -> SpellBarSlot:
	var slot = Panel.new()
	slot.custom_minimum_size = Vector2(64, 64)
	
	var icon = TextureRect.new()
	icon.name = "Icon"
	icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.anchors_preset = Control.PRESET_FULL_RECT
	slot.add_child(icon)
	
	var cooldown_overlay = ColorRect.new()
	cooldown_overlay.name = "CooldownOverlay"
	cooldown_overlay.color = Color(0, 0, 0, 0.7)
	cooldown_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cooldown_overlay.visible = false
	cooldown_overlay.anchors_preset = Control.PRESET_BOTTOM_LEFT
	cooldown_overlay.anchor_top = 0
	cooldown_overlay.anchor_bottom = 1
	cooldown_overlay.grow_vertical = Control.GROW_DIRECTION_BEGIN
	slot.add_child(cooldown_overlay)
	
	var cooldown_text = Label.new()
	cooldown_text.name = "CooldownText"
	cooldown_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cooldown_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	cooldown_text.anchors_preset = Control.PRESET_FULL_RECT
	cooldown_text.visible = false
	slot.add_child(cooldown_text)
	
	var hotkey_label = Label.new()
	hotkey_label.name = "HotkeyLabel"
	hotkey_label.position = Vector2(4, 4)
	hotkey_label.add_theme_font_size_override("font_size", 12)
	slot.add_child(hotkey_label)
	
	slot.set_script(load("res://Scripts/UI/SpellBarSlot.gd"))
	
	return slot
