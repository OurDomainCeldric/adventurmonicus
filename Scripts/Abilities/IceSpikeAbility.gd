extends AbilityData

func activate(player: Player) -> bool:
	if not can_use(player):
		return false
	
	# Get direction player is looking
	var direction = player.look_direction
	
	# Create ice spike projectile
	var ice_spike = preload("res://Scenes/Weapons/ice_spike_projectile.tscn").instantiate()
	player.get_parent().add_child(ice_spike)
	# Spawn in front of player (20 units forward)
	ice_spike.global_position = player.global_position + (direction * 20)
	
	# Initialize projectile with player as owner
	ice_spike.initialize(player)
	
	# Scale damage with intelligence
	if player.magic_damage_multiplier > 0:
		ice_spike.damage = int(ice_spike.damage * player.magic_damage_multiplier)
	
	# Set ice spike properties
	if ice_spike.has_method("set_direction"):
		ice_spike.set_direction(direction)
	
	print("Ice Spike launched!")
	
	return true
