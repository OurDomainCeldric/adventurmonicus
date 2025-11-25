class_name FullInventoryUI
extends Control

@onready var inventory_grid: GridContainer = $MainPanel/MarginContainer/HBoxContainer/LeftSide/InventoryGrid
@onready var weapon_slot: EquipmentSlotUI = $MainPanel/MarginContainer/HBoxContainer/RightSide/WeaponSlot
@onready var shield_slot: EquipmentSlotUI = $MainPanel/MarginContainer/HBoxContainer/RightSide/ShieldSlot
@onready var info_panel: Panel = $InfoPanel
@onready var item_name_label: Label = $InfoPanel/MarginContainer/VBoxContainer/ItemName
@onready var item_description_label: Label = $InfoPanel/MarginContainer/VBoxContainer/ItemDescription

var equipment_slots: Array[EquipmentSlotUI] = []
var inventory: Inventory
var player: Player

var inventory_slots: Array[InventorySlotUI] = []
var is_open: bool = false

func _ready() -> void:
	visible = false
	
func setup(p: Player) -> void:
	player = p
	inventory = player.inventory
	
	# Setup equipment slots array
	equipment_slots = [weapon_slot, shield_slot]
	
	# Create inventory slots
	_create_inventory_slots()
	
	# Setup equipment slots
	for equip_slot in equipment_slots:
		if equip_slot:
			equip_slot.setup(player)
	
	# Connect signals
	if inventory:
		inventory.UpdatedInventory.connect(_update_ui)
		_update_ui()

func _create_inventory_slots() -> void:
	if not inventory_grid:
		return
	
	# Clear existing
	for child in inventory_grid.get_children():
		child.queue_free()
	inventory_slots.clear()
	
	# Create slots based on inventory size
	for i in range(inventory.size):
		# Create a BaseButton (compatible with InventorySlotUI)
		var slot = BaseButton.new()
		slot.custom_minimum_size = Vector2(64, 64)
		
		# Create style for slot
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.15, 0.15, 0.2, 0.8)
		style.border_width_left = 2
		style.border_width_top = 2
		style.border_width_right = 2
		style.border_width_bottom = 2
		style.border_color = Color(0.4, 0.4, 0.5, 1)
		style.corner_radius_top_left = 4
		style.corner_radius_top_right = 4
		style.corner_radius_bottom_right = 4
		style.corner_radius_bottom_left = 4
		slot.add_theme_stylebox_override("normal", style)
		slot.add_theme_stylebox_override("hover", style)
		slot.add_theme_stylebox_override("pressed", style)
		slot.add_theme_stylebox_override("focus", style)
		
		# Apply InventorySlotUI script
		slot.set_script(preload("res://Scripts/UI/InventorySlotUI.gd"))
		
		# Add required children for slot
		var item_icon = TextureRect.new()
		item_icon.name = "ItemIcon"
		item_icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		item_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		item_icon.anchor_left = 0
		item_icon.anchor_top = 0
		item_icon.anchor_right = 1
		item_icon.anchor_bottom = 1
		item_icon.offset_left = 4
		item_icon.offset_top = 4
		item_icon.offset_right = -4
		item_icon.offset_bottom = -4
		item_icon.grow_horizontal = Control.GROW_DIRECTION_BOTH
		item_icon.grow_vertical = Control.GROW_DIRECTION_BOTH
		item_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		slot.add_child(item_icon)
		
		var quantity_text = Label.new()
		quantity_text.name = "QuantityText"
		quantity_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		quantity_text.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		quantity_text.anchor_left = 0
		quantity_text.anchor_top = 0
		quantity_text.anchor_right = 1
		quantity_text.anchor_bottom = 1
		quantity_text.grow_horizontal = Control.GROW_DIRECTION_BOTH
		quantity_text.grow_vertical = Control.GROW_DIRECTION_BOTH
		quantity_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
		slot.add_child(quantity_text)
		
		var equipped = TextureRect.new()
		equipped.name = "Equipped"
		equipped.visible = false
		equipped.mouse_filter = Control.MOUSE_FILTER_IGNORE
		slot.add_child(equipped)
		
		inventory_grid.add_child(slot)
		
		# Cast to InventorySlotUI after adding to tree
		var slot_ui = slot as InventorySlotUI
		slot_ui.slot_index = i
		inventory_slots.append(slot_ui)
		
		# Connect hover events
		if info_panel:
			slot.mouse_entered.connect(_show_item_info.bind(slot_ui))
			slot.mouse_exited.connect(_hide_item_info)

func _update_ui() -> void:
	if not inventory:
		return
	
	for i in range(inventory_slots.size()):
		if i < inventory.item_slots.size():
			inventory_slots[i].set_item_slot(inventory.item_slots[i], player)
	
	# Update equipment display
	_update_equipment_display()

func _update_equipment_display() -> void:
	if not player or not player.weapons:
		return
	
	# Update weapon slot
	if weapon_slot:
		if player.weapons.current_weapon:
			weapon_slot.set_item(player.weapons.weapon_to_equip)
		else:
			weapon_slot.set_item(null)
	
	# Update shield slot
	if shield_slot:
		if player.weapons.current_shield:
			shield_slot.set_item(player.weapons.shield_to_equip)
		else:
			shield_slot.set_item(null)

func toggle() -> void:
	is_open = not is_open
	visible = is_open
	
	# Note: Pausing disabled for now to avoid input issues
	# Enable this after setting proper process_mode on nodes
	# if is_open:
	# 	get_tree().paused = true
	# else:
	# 	get_tree().paused = false

func open() -> void:
	if not is_open:
		toggle()

func close() -> void:
	if is_open:
		toggle()

func _show_item_info(slot: InventorySlotUI) -> void:
	if not info_panel or not slot.item_slot or not slot.item_slot.item:
		return
	
	var item = slot.item_slot.item
	info_panel.visible = true
	item_name_label.text = item.display_name
	item_description_label.text = item.description
	
	# Position info panel near mouse
	var mouse_pos = get_viewport().get_mouse_position()
	info_panel.global_position = mouse_pos + Vector2(10, 10)

func _hide_item_info() -> void:
	if info_panel:
		info_panel.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		print("Toggling inventory!")
		toggle()
		get_viewport().set_input_as_handled()
