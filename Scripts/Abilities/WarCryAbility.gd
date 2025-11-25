extends AbilityData

var stun_duration: float = 2.0
var stun_radius: float = 60.0

func activate(player: Player) -> bool:
	if not can_use(player):
		return false
	
	# Create visual war cry effect
	_create_warcry_effect(player)
	
	# Find enemies in radius
	var space_state = player.get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var shape = CircleShape2D.new()
	shape.radius = stun_radius
	query.shape = shape
	query.transform = Transform2D(0, player.global_position)
	query.collision_mask = 2  # Enemy layer
	
	var results = space_state.intersect_shape(query)
	for result in results:
		var enemy = result.collider
		if enemy != player and enemy.has_method("set"):
			# Stun enemy by disabling movement
			if not enemy.has_node("WarCryStun"):
				var stun_node = Node.new()
				stun_node.name = "WarCryStun"
				enemy.add_child(stun_node)
				
				# Store original speed and disable
				stun_node.set_meta("original_speed", enemy.move_speed if enemy.has("move_speed") else 0)
				if enemy.has("move_speed"):
					enemy.move_speed = 0
				
				# Remove stun after duration
				await player.get_tree().create_timer(stun_duration).timeout
				if stun_node and is_instance_valid(stun_node):
					if enemy and is_instance_valid(enemy) and enemy.has("move_speed"):
						enemy.move_speed = stun_node.get_meta("original_speed")
					stun_node.queue_free()
	
	print("War Cry stunned nearby enemies!")
	return true

func _create_warcry_effect(player: Player) -> void:
	# Create expanding ring effect
	var ring = CPUParticles2D.new()
	player.add_child(ring)
	ring.amount = 30
	ring.lifetime = 0.5
	ring.one_shot = true
	ring.explosiveness = 0.9
	ring.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
	ring.emission_sphere_radius = 10.0
	ring.direction = Vector2.ZERO
	ring.spread = 180
	ring.gravity = Vector2.ZERO
	ring.initial_velocity_min = 80
	ring.initial_velocity_max = 120
	ring.scale_amount_min = 3.0
	ring.scale_amount_max = 5.0
	ring.color = Color.YELLOW
	
	await player.get_tree().create_timer(0.6).timeout
	if ring and is_instance_valid(ring):
		ring.queue_free()
