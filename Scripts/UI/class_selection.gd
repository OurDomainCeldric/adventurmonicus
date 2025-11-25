extends Control

@export var paladin_class: PlayerClass
@export var wizard_class: PlayerClass
@export var warrior_class: PlayerClass
@export var ranger_class: PlayerClass

@onready var class_description: Label = $MarginContainer/VBoxContainer/ClassDescription
@onready var class_stats: Label = $MarginContainer/VBoxContainer/ClassStats
@onready var class_abilities: Label = $MarginContainer/VBoxContainer/ClassAbilities

var selected_class: PlayerClass

func _ready() -> void:
	# Connect buttons
	$MarginContainer/VBoxContainer/ClassButtons/PaladinButton.pressed.connect(_on_class_selected.bind(paladin_class))
	$MarginContainer/VBoxContainer/ClassButtons/WizardButton.pressed.connect(_on_class_selected.bind(wizard_class))
	$MarginContainer/VBoxContainer/ClassButtons/WarriorButton.pressed.connect(_on_class_selected.bind(warrior_class))
	$MarginContainer/VBoxContainer/ClassButtons/RangerButton.pressed.connect(_on_class_selected.bind(ranger_class))
	$MarginContainer/VBoxContainer/ConfirmButton.pressed.connect(_on_confirm_pressed)
	
	# Setup hover events for preview
	$MarginContainer/VBoxContainer/ClassButtons/PaladinButton.mouse_entered.connect(_on_class_hover.bind(paladin_class))
	$MarginContainer/VBoxContainer/ClassButtons/WizardButton.mouse_entered.connect(_on_class_hover.bind(wizard_class))
	$MarginContainer/VBoxContainer/ClassButtons/WarriorButton.mouse_entered.connect(_on_class_hover.bind(warrior_class))
	$MarginContainer/VBoxContainer/ClassButtons/RangerButton.mouse_entered.connect(_on_class_hover.bind(ranger_class))
	
	$MarginContainer/VBoxContainer/ConfirmButton.disabled = true

func _on_class_hover(player_class: PlayerClass) -> void:
	if player_class:
		_display_class_info(player_class)

func _on_class_selected(player_class: PlayerClass) -> void:
	selected_class = player_class
	_display_class_info(player_class)
	$MarginContainer/VBoxContainer/ConfirmButton.disabled = false

func _display_class_info(player_class: PlayerClass) -> void:
	if not player_class:
		return
	
	class_description.text = player_class.player_class_name + "\n" + player_class.description
	
	class_stats.text = "Stats:\n"
	class_stats.text += "HP: %d/%d\n" % [player_class.starting_hp, player_class.max_hp]
	class_stats.text += "Mana: %d\n" % player_class.max_mana
	class_stats.text += "Stamina: %d\n" % player_class.max_stamina
	class_stats.text += "Speed: %.1f\n" % player_class.move_speed
	class_stats.text += "\nSTR: %d  AGI: %d\n" % [player_class.strength, player_class.agility]
	class_stats.text += "INT: %d  STA: %d" % [player_class.intelligence, player_class.stamina]
	
	if player_class.ability_descriptions.size() > 0:
		class_abilities.text = "Abilities:\n" + "\n".join(player_class.ability_descriptions)
	else:
		class_abilities.text = "Abilities:\nNone"

func _on_confirm_pressed() -> void:
	if selected_class:
		GameState.set_selected_class(selected_class)
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
