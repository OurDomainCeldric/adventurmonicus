extends AbilityData

var arrow_count: int = 3
var spread_angle: float = 30.0

func activate(player: Player) -> bool:
	if not can_use(player):
		return false
	
	# Get direction player is looking
	var direction = player.look_direction
	var base_angle = direction.angle()
	
	# Fire multiple arrows in a spread
	for i in range(arrow_count):
		var angle_offset = 0.0
		if arrow_count > 1:
			angle_offset = -spread_angle/2 + (spread_angle / (arrow_count - 1)) * i
		var arrow_angle = base_angle + deg_to_rad(angle_offset)
		var arrow_direction = Vector2(cos(arrow_angle), sin(arrow_angle))
		
		# Create arrow projectile
		var arrow = preload("res://Scenes/Weapons/arrow.tscn").instantiate()
		player.get_parent().add_child(arrow)
		arrow.global_position = player.global_position + (arrow_direction * 20)
		arrow.global_rotation = arrow_angle
		arrow.initialize(player)
		
		# Scale damage with agility
		if player.agility > 0:
			arrow.damage = int(arrow.damage * (1.0 + player.agility * 0.03))
	
	print("Multi-Shot fired ", arrow_count, " arrows!")
	return true
