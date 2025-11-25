extends AbilityData

var heal_amount: int = 30

func activate(player: Player) -> bool:
	if not can_use(player):
		return false
	
	# Heal the player
	player.heal(heal_amount)
	
	# Visual feedback - golden particles
	var effect = Node2D.new()
	effect.set_script(preload("res://Scripts/Effects/AbilityEffect.gd"))
	effect.global_position = player.global_position
	effect.set("color", Color.GOLD)
	effect.set("duration", 0.5)
	player.get_parent().add_child(effect)
	
	print("Lay on Hands - Healed for ", heal_amount)
	return true
