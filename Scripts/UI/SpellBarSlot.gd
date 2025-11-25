class_name SpellBarSlot
extends Panel

@onready var icon: TextureRect = $Icon
@onready var cooldown_overlay: ColorRect = $CooldownOverlay
@onready var cooldown_text: Label = $CooldownText
@onready var hotkey_label: Label = $HotkeyLabel

var ability: AbilityData
var slot_index: int

var tooltip_label: Label

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func set_ability(new_ability: AbilityData, index: int) -> void:
	ability = new_ability
	slot_index = index
	
	# Set hotkey label (1-5)
	hotkey_label.text = str(index + 1)
	
	if ability:
		icon.texture = ability.icon
		icon.visible = true
		tooltip_text = ability.ability_name + "\n" + ability.description + "\nCooldown: " + str(ability.cooldown) + "s"
	else:
		icon.texture = null
		icon.visible = false
		tooltip_text = ""
	
	update_cooldown(0)

func _on_mouse_entered() -> void:
	if ability:
		modulate = Color(1.2, 1.2, 1.2)
		_show_tooltip()

func _on_mouse_exited() -> void:
	modulate = Color(1, 1, 1)
	_hide_tooltip()

func _show_tooltip() -> void:
	if not ability or tooltip_text.is_empty():
		return
	
	# Create tooltip label if it doesn't exist
	if not tooltip_label:
		tooltip_label = Label.new()
		tooltip_label.name = "TooltipLabel"
		tooltip_label.add_theme_color_override("font_color", Color.WHITE)
		tooltip_label.add_theme_color_override("font_shadow_color", Color.BLACK)
		tooltip_label.add_theme_constant_override("shadow_offset_x", 1)
		tooltip_label.add_theme_constant_override("shadow_offset_y", 1)
		tooltip_label.add_theme_font_size_override("font_size", 12)
		
		# Create background panel
		var panel = Panel.new()
		panel.name = "TooltipPanel"
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.1, 0.1, 0.15, 0.95)
		style.border_color = Color(0.4, 0.4, 0.5, 1)
		style.set_border_width_all(1)
		style.set_corner_radius_all(4)
		style.content_margin_left = 8
		style.content_margin_right = 8
		style.content_margin_top = 6
		style.content_margin_bottom = 6
		panel.add_theme_stylebox_override("panel", style)
		
		get_tree().root.add_child(panel)
		panel.add_child(tooltip_label)
		panel.z_index = 100
	
	tooltip_label.text = tooltip_text
	tooltip_label.get_parent().visible = true
	
	# Position tooltip above the slot
	var tooltip_panel = tooltip_label.get_parent()
	await get_tree().process_frame
	var slot_pos = global_position
	tooltip_panel.global_position = slot_pos + Vector2(-tooltip_panel.size.x / 2 + size.x / 2, -tooltip_panel.size.y - 5)

func _hide_tooltip() -> void:
	if tooltip_label and tooltip_label.get_parent():
		tooltip_label.get_parent().visible = false

func update_cooldown(time_remaining: float) -> void:
	if time_remaining > 0:
		cooldown_overlay.visible = true
		cooldown_text.visible = true
		cooldown_text.text = "%.1f" % time_remaining
		
		# Calculate overlay height based on cooldown percentage
		if ability:
			var percentage = time_remaining / ability.cooldown
			cooldown_overlay.size.y = size.y * percentage
	else:
		cooldown_overlay.visible = false
		cooldown_text.visible = false

func flash_ready() -> void:
	# Visual feedback when ability comes off cooldown
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.5, 1.5, 1.5), 0.2)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.2)
