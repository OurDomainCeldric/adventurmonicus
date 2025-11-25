extends AbilityData

func activate(player: Player) -> bool:
	if not can_use(player):
		return false
	
	# Get direction player is looking (towards mouse)
	var direction = player.look_direction
	
	# Create fireball projectile
	var fireball = preload("res://Scenes/Weapons/fireball_projectile.tscn").instantiate()
	player.get_parent().add_child(fireball)
	# Spawn in front of player (20 units forward)
	fireball.global_position = player.global_position + (direction * 20)
	
	# Initialize projectile with player as owner
	fireball.initialize(player)
	
	# Scale damage with intelligence
	if player.magic_damage_multiplier > 0:
		fireball.damage = int(fireball.damage * player.magic_damage_multiplier)
	
	# Set fireball properties
	if fireball.has_method("set_direction"):
		fireball.set_direction(direction)
	
	print("Fireball launched!")
	
	return true
