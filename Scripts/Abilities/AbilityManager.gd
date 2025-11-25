class_name AbilityManager
extends Node

var abilities: Array[AbilityData] = []
var cooldowns: Dictionary = {} # ability_name -> time_remaining

signal ability_used(ability: AbilityData)
signal cooldown_updated(ability_index: int, time_remaining: float)

func _process(delta: float) -> void:
	# Update cooldowns
	for ability_name in cooldowns.keys():
		cooldowns[ability_name] -= delta
		if cooldowns[ability_name] <= 0:
			cooldowns.erase(ability_name)
			# Find ability index and emit
			for i in range(abilities.size()):
				if abilities[i] and abilities[i].ability_name == ability_name:
					cooldown_updated.emit(i, 0)
		else:
			for i in range(abilities.size()):
				if abilities[i] and abilities[i].ability_name == ability_name:
					cooldown_updated.emit(i, cooldowns[ability_name])

func set_abilities(new_abilities: Array[AbilityData]) -> void:
	abilities = new_abilities
	cooldowns.clear()

func use_ability(index: int, player: Player) -> bool:
	if index < 0 or index >= abilities.size():
		return false
	
	var ability = abilities[index]
	if not ability:
		return false
	
	# Check if on cooldown
	if cooldowns.has(ability.ability_name):
		return false
	
	# Check if can use
	if not ability.can_use(player):
		return false
	
	# Activate ability
	if ability.activate(player):
		cooldowns[ability.ability_name] = ability.cooldown
		ability_used.emit(ability)
		return true
	
	return false

func get_cooldown_remaining(index: int) -> float:
	if index < 0 or index >= abilities.size():
		return 0.0
	
	var ability = abilities[index]
	if not ability:
		return 0.0
	
	if cooldowns.has(ability.ability_name):
		return cooldowns[ability.ability_name]
	
	return 0.0

func is_on_cooldown(index: int) -> bool:
	return get_cooldown_remaining(index) > 0
