class_name InventorySlotUI
extends GameButton

@onready var item_icon : TextureRect = $ItemIcon
@onready var quantity_text : Label = $QuantityText
@onready var equipped : TextureRect = $Equipped

var item_slot : Inventory.ItemSlot
var player : Player
var slot_index: int = -1

func set_item_slot (item_slot:Inventory.ItemSlot,player:Player):
	self.item_slot = item_slot
	self.player = player
	var is_equipped : bool = false
	
	if player.weapons.weapon_inventory_slot == item_slot:
		is_equipped = true
	elif player.weapons.shield_inventory_slot == item_slot:
		is_equipped = true
	
	equipped.visible = is_equipped
	
	#set icon
	if item_slot.item:
		item_icon.texture = item_slot.item.icon
	else:
		item_icon.texture = null
		quantity_text.text = ""
		return
	
	#set quantity text if > 1
	if item_slot.quantity > 1:
		quantity_text.text =str(item_slot.quantity)
	else: 
		quantity_text.text = ""

func _on_pressed():
	super._on_pressed()
	
	# return if no item
	if not item_slot or not item_slot.item:
		return
	
	# Click on the item and then trigger whatever it does
	item_slot.item._select_in_inventory(player, item_slot)

# Drag and drop support
func _get_drag_data(_at_position: Vector2) -> Variant:
	if not item_slot or not item_slot.item:
		return null
	
	# Create drag preview
	var preview = TextureRect.new()
	preview.texture = item_icon.texture
	preview.custom_minimum_size = Vector2(48, 48)
	preview.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.modulate = Color(1, 1, 1, 0.8)
	
	set_drag_preview(preview)
	
	return {
		"item": item_slot.item,
		"quantity": item_slot.quantity,
		"source_slot": self,
		"source_index": slot_index
	}

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	# Can always drop items into inventory slots
	if data is Dictionary and data.has("item"):
		return true
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if not data is Dictionary or not data.has("item"):
		return
	
	var source = data.get("source_slot")
	
	# Swap items
	if source is InventorySlotUI:
		_swap_slots(source)

func _swap_slots(source_slot: InventorySlotUI) -> void:
	if not player or not player.inventory:
		return
	
	var source_item = source_slot.item_slot.item
	var source_quantity = source_slot.item_slot.quantity
	var target_item = item_slot.item
	var target_quantity = item_slot.quantity
	
	# Swap the items
	source_slot.item_slot.item = target_item
	source_slot.item_slot.quantity = target_quantity
	item_slot.item = source_item
	item_slot.quantity = source_quantity
	
	# Update UI
	player.inventory.UpdatedInventory.emit()
