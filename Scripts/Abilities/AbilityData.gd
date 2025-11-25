class_name AbilityData
extends Resource

@export var ability_name: String
@export var description: String
@export var icon: Texture2D
@export var cooldown: float = 1.0
@export var mana_cost: int = 0
@export var ability_type: AbilityType = AbilityType.INSTANT

enum AbilityType {
	INSTANT,      # Cast immediately
	PROJECTILE,   # Shoot a projectile
	AREA,         # Area of effect
	BUFF,         # Self buff
	SUMMON        # Summon entity
}

# Override this in specific ability scripts
func activate(player: Player) -> bool:
	if not can_use(player):
		return false
	
	# Use mana
	if mana_cost > 0:
		player.use_mana(mana_cost)
	
	# Default activation - show visual feedback
	_create_activation_effect(player)
	print("Activated: ", ability_name)
	return true

func can_use(player: Player) -> bool:
	# Check mana cost
	if mana_cost > 0 and not player.has_mana(mana_cost):
		return false
	return true

func _create_activation_effect(player: Player) -> void:
	# Create a simple flash effect on the player
	if not player:
		return
	
	# Flash the player sprite
	var flash_color = Color(1.5, 1.5, 1.5, 1.0)
	var original_modulate = player.modulate
	player.modulate = flash_color
	
	# Create particle effect
	var effect = Node2D.new()
	effect.set_script(preload("res://Scripts/Effects/AbilityEffect.gd"))
	effect.global_position = player.global_position
	
	# Color based on ability type
	var particle_color = Color.YELLOW
	match ability_type:
		AbilityType.PROJECTILE:
			particle_color = Color.ORANGE_RED
		AbilityType.AREA:
			particle_color = Color.PURPLE
		AbilityType.BUFF:
			particle_color = Color.CYAN
		AbilityType.SUMMON:
			particle_color = Color.GREEN
	
	effect.set("color", particle_color)
	player.get_parent().add_child(effect)
	
	# Reset player color
	await player.get_tree().create_timer(0.1).timeout
	player.modulate = original_modulate
