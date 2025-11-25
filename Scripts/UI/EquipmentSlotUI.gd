class_name EquipmentSlotUI
extends Panel

enum SlotType {
	WEAPON,
	SHIELD,
	HELMET,
	CHEST,
	LEGS,
	BOOTS,
	ACCESSORY
}

@export var slot_type: SlotType = SlotType.WEAPON
@onready var icon: TextureRect = $Icon
@onready var slot_label: Label = $SlotLabel

var equipped_item: ItemData
var player: Player

func _ready() -> void:
	_update_label()

func _update_label() -> void:
	match slot_type:
		SlotType.WEAPON:
			slot_label.text = "Weapon"
		SlotType.SHIELD:
			slot_label.text = "Shield"
		SlotType.HELMET:
			slot_label.text = "Helmet"
		SlotType.CHEST:
			slot_label.text = "Chest"
		SlotType.LEGS:
			slot_label.text = "Legs"
		SlotType.BOOTS:
			slot_label.text = "Boots"
		SlotType.ACCESSORY:
			slot_label.text = "Accessory"

func setup(p: Player) -> void:
	player = p
	update_display()

func set_item(item: ItemData) -> void:
	equipped_item = item
	update_display()

func update_display() -> void:
	if equipped_item:
		icon.texture = equipped_item.icon
		icon.visible = true
	else:
		icon.texture = null
		icon.visible = false

# Drag and drop support
func _get_drag_data(_at_position: Vector2) -> Variant:
	if not equipped_item:
		return null
	
	# Create drag preview
	var preview = TextureRect.new()
	preview.texture = icon.texture
	preview.custom_minimum_size = Vector2(48, 48)
	preview.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.modulate = Color(1, 1, 1, 0.8)
	
	set_drag_preview(preview)
	
	return {
		"item": equipped_item,
		"quantity": 1,
		"source_slot": self,
		"slot_type": slot_type
	}

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if not data is Dictionary or not data.has("item"):
		return false
	
	var item = data.get("item")
	
	# Check if item type matches slot type
	match slot_type:
		SlotType.WEAPON:
			return item is WeaponItemData
		SlotType.SHIELD:
			return item is ShieldItemData
	
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if not data is Dictionary or not data.has("item"):
		return
	
	var item = data.get("item")
	var source = data.get("source_slot")
	
	if source is InventorySlotUI:
		# Equip from inventory
		_equip_from_inventory(item, source)
	elif source is EquipmentSlotUI and source != self:
		# Swap equipment between slots (if same type)
		if source.slot_type == slot_type:
			_swap_equipment(source)

func _equip_from_inventory(item: ItemData, source_slot: InventorySlotUI) -> void:
	if not player:
		return
	
	# Unequip current item back to inventory if there is one
	if equipped_item:
		# Try to add to the source slot or find an empty slot
		source_slot.item_slot.item = equipped_item
		source_slot.item_slot.quantity = 1
	else:
		# Clear the source slot
		source_slot.item_slot.item = null
		source_slot.item_slot.quantity = 0
	
	# Equip new item
	if item is WeaponItemData and slot_type == SlotType.WEAPON:
		player.weapons.equip_weapon(item)
		player.weapons.weapon_inventory_slot = source_slot.item_slot
	elif item is ShieldItemData and slot_type == SlotType.SHIELD:
		player.weapons.equip_shield(item)
		player.weapons.shield_inventory_slot = source_slot.item_slot
	
	set_item(item)
	player.inventory.UpdatedInventory.emit()

func _swap_equipment(source_slot: EquipmentSlotUI) -> void:
	var temp_item = equipped_item
	set_item(source_slot.equipped_item)
	source_slot.set_item(temp_item)
	
	# Update player equipment
	if player:
		if slot_type == SlotType.WEAPON:
			if equipped_item is WeaponItemData:
				player.weapons.equip_weapon(equipped_item)
		elif slot_type == SlotType.SHIELD:
			if equipped_item is ShieldItemData:
				player.weapons.equip_shield(equipped_item)
