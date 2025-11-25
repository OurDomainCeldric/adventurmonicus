extends AbilityData

func activate(player: Player) -> bool:
	if not can_use(player):
		return false
	
	# Get blink direction (towards mouse)
	var direction = player.look_direction
	var blink_distance = 100.0
	
	# Calculate new position
	var new_position = player.global_position + (direction * blink_distance)
	
	# Check if position is valid (not in walls)
	var space_state = player.get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(player.global_position, new_position)
	query.collision_mask = 1  # Terrain layer
	var result = space_state.intersect_ray(query)
	
	# If hit wall, blink to just before wall
	if result:
		new_position = result.position - (direction * 10)
	
	# Create blink effect at start position
	_create_blink_effect(player.global_position, player)
	
	# Teleport player
	player.global_position = new_position
	
	# Create blink effect at end position
	_create_blink_effect(new_position, player)
	
	print("Blinked!")
	return true

func _create_blink_effect(pos: Vector2, player: Player) -> void:
	var effect = Node2D.new()
	effect.set_script(preload("res://Scripts/Effects/AbilityEffect.gd"))
	effect.global_position = pos
	effect.set("color", Color.CYAN)
	effect.set("duration", 0.3)
	player.get_parent().add_child(effect)
