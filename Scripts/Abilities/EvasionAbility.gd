extends AbilityData

var evasion_duration: float = 3.0
var dodge_chance: float = 0.75

func activate(player: Player) -> bool:
	if not can_use(player):
		return false
	
	# Apply evasion buff
	_apply_evasion(player)
	
	# Visual feedback
	_create_activation_effect(player)
	print("Evasion activated!")
	
	return true

func _apply_evasion(player: Player) -> void:
	# Create visual evasion effect
	var evasion_visual = Node2D.new()
	evasion_visual.name = "EvasionVisual"
	player.add_child(evasion_visual)
	
	# Create shimmer effect
	var tween = player.create_tween()
	tween.set_loops()
	tween.tween_property(player, "modulate:a", 0.4, 0.2)
	tween.tween_property(player, "modulate:a", 0.8, 0.2)
	
	# Create buff node
	var evasion_node = Node.new()
	evasion_node.name = "Evasion"
	evasion_node.set_meta("dodge_chance", dodge_chance)
	player.add_child(evasion_node)
	
	# Remove after duration
	await player.get_tree().create_timer(evasion_duration).timeout
	if evasion_visual and is_instance_valid(evasion_visual):
		evasion_visual.queue_free()
	if evasion_node and is_instance_valid(evasion_node):
		evasion_node.queue_free()
	if tween and is_instance_valid(tween):
		tween.kill()
	player.modulate.a = 1.0
	print("Evasion expired")
