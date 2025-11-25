extends AbilityData

var bonus_damage: int = 15

func activate(player: Player) -> bool:
	if not can_use(player):
		return false
	
	# Get direction and check for enemies in melee range
	var direction = player.look_direction
	var strike_range = 30.0
	var strike_position = player.global_position + (direction * strike_range)
	
	# Create visual strike effect
	_create_strike_effect(strike_position, player)
	
	# Check for enemies in range
	var space_state = player.get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 25.0
	query.shape = shape
	query.transform = Transform2D(0, strike_position)
	query.collision_mask = 4  # Enemy layer
	
	var results = space_state.intersect_shape(query)
	for result in results:
		var enemy = result.collider
		if enemy.has_method("take_damage"):
			# Scale with strength
			var actual_damage = bonus_damage + int(player.strength * 0.5)
			var knockback = direction * 200
			enemy.take_damage(actual_damage, knockback)
			print("Holy Strike hit for ", actual_damage, " damage!")
	
	return true

func _create_strike_effect(pos: Vector2, player: Player) -> void:
	var effect = Node2D.new()
	effect.set_script(preload("res://Scripts/Effects/AbilityEffect.gd"))
	effect.global_position = pos
	effect.set("color", Color.YELLOW)
	effect.set("duration", 0.3)
	player.get_parent().add_child(effect)
