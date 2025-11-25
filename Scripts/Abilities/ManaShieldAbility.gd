extends AbilityData

var shield_duration: float = 5.0
var damage_reduction: float = 0.5

func activate(player: Player) -> bool:
	if not can_use(player):
		return false
	
	# Apply mana shield buff
	_apply_shield(player)
	
	# Visual feedback
	_create_activation_effect(player)
	print("Mana Shield activated!")
	
	return true

func _apply_shield(player: Player) -> void:
	# Create visual shield effect with rotating particles
	var shield_visual = Node2D.new()
	shield_visual.name = "ManaShieldVisual"
	player.add_child(shield_visual)
	
	# Create circular particle ring
	var particles = CPUParticles2D.new()
	shield_visual.add_child(particles)
	particles.amount = 24
	particles.lifetime = 1.0
	particles.preprocess = 0.5
	particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
	particles.emission_sphere_radius = 20.0
	particles.direction = Vector2(0, 0)
	particles.spread = 0
	particles.gravity = Vector2.ZERO
	particles.initial_velocity_min = 0
	particles.initial_velocity_max = 0
	particles.scale_amount_min = 2.0
	particles.scale_amount_max = 3.0
	particles.color = Color(0.3, 0.6, 1.0, 0.6)
	particles.emitting = true
	
	# Add rotating animation
	var tween = player.create_tween()
	tween.set_loops()
	tween.tween_property(shield_visual, "rotation", TAU, 3.0)
	
	# Pulse animation
	var pulse_tween = player.create_tween()
	pulse_tween.set_loops()
	pulse_tween.tween_property(particles, "scale_amount_min", 2.5, 0.5)
	pulse_tween.tween_property(particles, "scale_amount_min", 2.0, 0.5)
	
	# Create a shield node to track the buff
	var shield_node = Node.new()
	shield_node.name = "ManaShield"
	shield_node.set_meta("damage_reduction", damage_reduction)
	player.add_child(shield_node)
	
	# Remove shield after duration
	await player.get_tree().create_timer(shield_duration).timeout
	if shield_visual and is_instance_valid(shield_visual):
		shield_visual.queue_free()
	if shield_node and is_instance_valid(shield_node):
		shield_node.queue_free()
	print("Mana Shield expired")
