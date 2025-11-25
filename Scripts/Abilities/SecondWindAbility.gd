extends AbilityData

var heal_amount: int = 40

func activate(player: Player) -> bool:
	if not can_use(player):
		return false
	
	# Heal percentage of max HP
	var heal_value = int(player.max_hp * 0.3)
	player.heal(heal_value)
	
	# Visual feedback - green healing particles
	var effect = Node2D.new()
	effect.set_script(preload("res://Scripts/Effects/AbilityEffect.gd"))
	effect.global_position = player.global_position
	effect.set("color", Color.GREEN)
	effect.set("duration", 0.6)
	player.get_parent().add_child(effect)
	
	print("Second Wind - Healed for ", heal_value)
	return true
