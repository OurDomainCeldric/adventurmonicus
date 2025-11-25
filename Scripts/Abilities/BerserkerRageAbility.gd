extends AbilityData

var rage_duration: float = 8.0
var damage_boost: float = 0.5
var speed_boost: float = 0.3

func activate(player: Player) -> bool:
	if not can_use(player):
		return false
	
	# Apply berserker rage buff
	_apply_rage(player)
	
	# Visual feedback
	_create_activation_effect(player)
	print("Berserker Rage activated!")
	
	return true

func _apply_rage(player: Player) -> void:
	# Create visual rage effect - red aura
	var rage_visual = Node2D.new()
	rage_visual.name = "BerserkerRageVisual"
	player.add_child(rage_visual)
	
	# Create pulsing red particles
	var particles = CPUParticles2D.new()
	rage_visual.add_child(particles)
	particles.amount = 20
	particles.lifetime = 0.8
	particles.preprocess = 0.3
	particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
	particles.emission_sphere_radius = 15.0
	particles.direction = Vector2(0, -1)
	particles.spread = 45.0
	particles.gravity = Vector2.ZERO
	particles.initial_velocity_min = 20
	particles.initial_velocity_max = 40
	particles.scale_amount_min = 2.0
	particles.scale_amount_max = 4.0
	particles.color = Color(1.0, 0.2, 0.1, 0.8)
	particles.emitting = true
	
	# Create buff node
	var rage_node = Node.new()
	rage_node.name = "BerserkerRage"
	rage_node.set_meta("damage_boost", damage_boost)
	rage_node.set_meta("speed_boost", speed_boost)
	player.add_child(rage_node)
	
	# Temporarily boost player speed
	var original_speed = player.move_speed
	player.move_speed *= (1.0 + speed_boost)
	
	# Tint player red
	player.modulate = Color(1.3, 0.8, 0.8)
	
	# Remove after duration
	await player.get_tree().create_timer(rage_duration).timeout
	if rage_visual and is_instance_valid(rage_visual):
		rage_visual.queue_free()
	if rage_node and is_instance_valid(rage_node):
		rage_node.queue_free()
	player.move_speed = original_speed
	player.modulate = Color.WHITE
	print("Berserker Rage expired")
