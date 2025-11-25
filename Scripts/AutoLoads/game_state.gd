extends Node

var selected_class: PlayerClass = null

func set_selected_class(player_class: PlayerClass) -> void:
	selected_class = player_class

func get_selected_class() -> PlayerClass:
	return selected_class

func has_selected_class() -> bool:
	return selected_class != null
