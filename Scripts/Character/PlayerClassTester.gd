extends Node

# This script helps test the game by setting a default class if none is selected
# Useful for quick testing without going through class selection every time

@export var default_test_class: PlayerClass

func _ready() -> void:
	# If no class is selected and we have a default test class, use it
	if not GameState.has_selected_class() and default_test_class:
		GameState.set_selected_class(default_test_class)
		print("Test mode: Using default class - ", default_test_class.player_class_name)
