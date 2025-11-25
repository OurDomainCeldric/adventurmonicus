extends AbilityData

var shield_duration: float = 4.0
var damage_reduction: float = 0.7

func activate(player: Player) -> bool:
	if not can_use(player):
		return false
	
	# Apply divine shield
	_apply_shield(player)
	
	# Visual feedback
	_create_activation_effect(player)
	print("Divine Shield activated!")
	
	return true

func _apply_shield(player: Player) -> void:
	# Create visual shield effect
	var shield_sprite = Sprite2D.new()
	shield_sprite.modulate = Color(1.0, 0.9, 0.3, 0.6)
	shield_sprite.scale = Vector2(2.5, 2.5)
	player.add_child(shield_sprite)
	
	# Create a shield node to track the buff
	var shield_node = Node.new()
	shield_node.name = "DivineShield"
	shield_node.set_meta("damage_reduction", damage_reduction)
	player.add_child(shield_node)
	
	# Animate shield
	var tween = player.create_tween()
	tween.set_loops(int(shield_duration * 4))
	tween.tween_property(shield_sprite, "modulate:a", 0.4, 0.25)
	tween.tween_property(shield_sprite, "modulate:a", 0.7, 0.25)
	
	# Remove shield after duration
	await player.get_tree().create_timer(shield_duration).timeout
	if shield_sprite and is_instance_valid(shield_sprite):
		shield_sprite.queue_free()
	if shield_node and is_instance_valid(shield_node):
		shield_node.queue_free()
	print("Divine Shield expired")
