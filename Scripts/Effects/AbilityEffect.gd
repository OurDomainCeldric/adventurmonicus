extends Node2D

@export var color: Color = Color.WHITE
@export var duration: float = 0.5

func _ready() -> void:
	# Create a simple flash circle
	var particles = CPUParticles2D.new()
	add_child(particles)
	
	particles.emitting = true
	particles.one_shot = true
	particles.amount = 12
	particles.lifetime = 0.25
	particles.explosiveness = 0.9
	particles.spread = 360
	particles.gravity = Vector2.ZERO
	particles.initial_velocity_min = 30
	particles.initial_velocity_max = 60
	particles.scale_amount_min = 1.5
	particles.scale_amount_max = 3
	particles.color = color
	
	# Auto-delete after effect
	await get_tree().create_timer(duration + 0.1).timeout
	queue_free()
