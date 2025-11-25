class_name DraggableItem
extends Control

var item_data: ItemData
var quantity: int = 1
var source_slot: Control

@onready var icon: TextureRect = $Icon

func _ready() -> void:
	if item_data:
		icon.texture = item_data.icon

func _get_drag_data(_at_position: Vector2) -> Variant:
	# Create preview
	var preview = TextureRect.new()
	preview.texture = icon.texture
	preview.custom_minimum_size = Vector2(32, 32)
	preview.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.modulate = Color(1, 1, 1, 0.7)
	
	set_drag_preview(preview)
	
	return {"item": item_data, "quantity": quantity, "source": source_slot}

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		if not get_viewport().gui_is_drag_successful():
			# Drag was cancelled, do nothing
			pass
