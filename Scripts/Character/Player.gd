class_name Player
extends Character

@onready var inventory:Inventory = $Inventory
@onready var ability_manager: AbilityManager = $AbilityManager

func _ready() -> void:
	_apply_selected_class()

func _unhandled_input(event: InputEvent) -> void:
	# Handle ability hotkeys
	if event.is_action_pressed("ability_1"):
		_use_ability(0)
	elif event.is_action_pressed("ability_2"):
		_use_ability(1)
	elif event.is_action_pressed("ability_3"):
		_use_ability(2)
	elif event.is_action_pressed("ability_4"):
		_use_ability(3)
	elif event.is_action_pressed("ability_5"):
		_use_ability(4)

func _use_ability(index: int) -> void:
	print("Trying to use ability ", index)
	if ability_manager:
		var success = ability_manager.use_ability(index, self)
		print("Ability use result: ", success)
	else:
		print("No ability manager found!")

func _apply_selected_class() -> void:
	if not GameState.has_selected_class():
		return
	
	var player_class: PlayerClass = GameState.get_selected_class()
	
	# Apply core stats
	strength = player_class.strength
	agility = player_class.agility
	intelligence = player_class.intelligence
	stamina_stat = player_class.stamina
	
	# Calculate derived stats from core stats
	calculate_stats()
	
	# Set current values to starting values
	cur_hp = player_class.starting_hp
	cur_mana = player_class.starting_mana
	cur_stamina = max_stamina
	
	# Apply other properties
	move_speed = player_class.move_speed
	
	# Equip starting weapon
	if player_class.starting_weapon and weapons:
		weapons.equip_weapon(player_class.starting_weapon)
	
	# Equip starting shield
	if player_class.starting_shield and weapons:
		weapons.equip_shield(player_class.starting_shield)
	
	# Add additional starting items to inventory
	for item in player_class.additional_items:
		var quantity = player_class.additional_items[item]
		for i in range(quantity):
			inventory.add_item(item)
	
	# Set up abilities
	if ability_manager and player_class.abilities.size() > 0:
		ability_manager.set_abilities(player_class.abilities)
	
	OnHealthChange.emit()

func _process(_delta: float) -> void:
	move_input = Input.get_vector("move_left","move_right","move_up","move_down")
	
	# Handle sprint
	is_sprinting = Input.is_action_pressed("sprint") and move_input.length() > 0
	
	var mouse_pos: Vector2 = get_global_mouse_position()
	look_direction = global_position.direction_to(mouse_pos)


func _die():
	get_tree().reload_current_scene()
