extends AbilityData

var cleave_range: float = 40.0
var cleave_damage: int = 20

func activate(player: Player) -> bool:
	if not can_use(player):
		return false
	
	# Get direction player is looking
	var direction = player.look_direction
	var cleave_position = player.global_position + (direction * 25)
	
	# Create visual cleave effect
	_create_cleave_effect(cleave_position, player)
	
	# Check for enemies in cleave area
	var space_state = player.get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var shape = CircleShape2D.new()
	shape.radius = cleave_range
	query.shape = shape
	query.transform = Transform2D(0, cleave_position)
	query.collision_mask = 2  # Enemy layer
	
	var results = space_state.intersect_shape(query)
	var hit_count = 0
	for result in results:
		var enemy = result.collider
		if enemy != player and enemy.has_method("take_damage"):
			# Scale with strength
			var actual_damage = cleave_damage + int(player.strength * 1.0)
			var knockback = direction * 150
			enemy.take_damage(actual_damage, knockback)
			hit_count += 1
	
	print("Cleave hit ", hit_count, " enemies!")
	return true

func _create_cleave_effect(pos: Vector2, player: Player) -> void:
	var effect = Node2D.new()
	effect.set_script(preload("res://Scripts/Effects/AbilityEffect.gd"))
	effect.global_position = pos
	effect.set("color", Color.ORANGE)
	effect.set("duration", 0.4)
	player.get_parent().add_child(effect)
