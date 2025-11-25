extends Projectile

var direction: Vector2 = Vector2.RIGHT

func set_direction(dir: Vector2) -> void:
	direction = dir.normalized()
	rotation = direction.angle()

func _process(delta: float) -> void:
	translate(direction * speed * delta)
