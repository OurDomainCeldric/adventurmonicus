extends AbilityData

var mark_duration: float = 10.0
var damage_bonus: float = 0.5

func activate(player: Player) -> bool:
	if not can_use(player):
		return false
	
	# Find closest enemy
	var closest_enemy = null
	var closest_distance = 300.0  # Max range
	
	var space_state = player.get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 300.0
	query.shape = shape
	query.transform = Transform2D(0, player.global_position)
	query.collision_mask = 2  # Enemy layer
	
	var results = space_state.intersect_shape(query)
	for result in results:
		var enemy = result.collider
		if enemy != player:
			var distance = player.global_position.distance_to(enemy.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_enemy = enemy
	
	if closest_enemy:
		_apply_mark(closest_enemy, player)
		print("Hunter's Mark applied!")
		return true
	else:
		print("No enemies in range!")
		return false

func _apply_mark(enemy: Node2D, player: Player) -> void:
	# Create visual mark effect
	var mark_sprite = Sprite2D.new()
	mark_sprite.name = "HuntersMarkVisual"
	mark_sprite.modulate = Color(1.0, 0.8, 0.0, 0.8)
	mark_sprite.scale = Vector2(2.0, 2.0)
	mark_sprite.z_index = 10
	enemy.add_child(mark_sprite)
	
	# Pulse animation
	var tween = enemy.create_tween()
	tween.set_loops()
	tween.tween_property(mark_sprite, "scale", Vector2(2.3, 2.3), 0.5)
	tween.tween_property(mark_sprite, "scale", Vector2(2.0, 2.0), 0.5)
	
	# Create mark buff node
	var mark_node = Node.new()
	mark_node.name = "HuntersMark"
	mark_node.set_meta("damage_bonus", damage_bonus)
	mark_node.set_meta("marked_by", player)
	enemy.add_child(mark_node)
	
	# Remove after duration
	await player.get_tree().create_timer(mark_duration).timeout
	if mark_sprite and is_instance_valid(mark_sprite):
		mark_sprite.queue_free()
	if mark_node and is_instance_valid(mark_node):
		mark_node.queue_free()
	if tween and is_instance_valid(tween):
		tween.kill()
