# Base file for all characters within the game
class_name Character
extends CharacterBody2D

signal OnTakeDamage(direction: Vector2)
signal OnHealthChange
signal OnManaChange
signal OnStaminaChange

# Core Stats
@export var strength: int = 10
@export var agility: int = 10
@export var intelligence: int = 10
@export var stamina_stat: int = 10

# Derived Stats
@export var cur_hp: int = 10
@export var max_hp: int = 10
@export var cur_mana: int = 0
@export var max_mana: int = 0
@export var cur_stamina: int = 100
@export var max_stamina: int = 100
@export var mana_regen_rate: float = 5.0
@export var stamina_regen_rate: float = 10.0
@export var move_speed: float = 20
@export var sprint_speed_multiplier: float = 1.3
@export var sprint_stamina_cost: float = 15.0
@export var force_drag: float = 5
@export var weight_limit: float = 100.0
@export var crit_chance: float = 0.05
@export var hit_chance: float = 0.95
@export var magic_damage_multiplier: float = 1.0
@export var weapons : CharacterWeapons
@export var damaged_sound:AudioStream

var move_input: Vector2
var look_direction: Vector2
var external_force: Vector2
var is_sprinting: bool = false


func _physics_process(delta):
	_move(delta)
	_regenerate_mana(delta)
	_regenerate_stamina(delta)


func _move(delta: float):
	external_force = external_force.lerp(Vector2.ZERO, force_drag * delta)

	var current_speed = move_speed
	
	# Apply sprint if sprinting and has stamina
	if is_sprinting and cur_stamina > 0:
		current_speed *= sprint_speed_multiplier
		use_stamina(sprint_stamina_cost * delta)
	
	velocity = move_input * current_speed
	velocity += external_force

	move_and_slide()


func take_damage(damage: int, force: Vector2):
	if weapons.try_block_direction(force.normalized()):
		return
	
	# Check for shield buffs (Divine Shield, Mana Shield)
	var actual_damage = damage
	if has_node("DivineShield"):
		var shield = get_node("DivineShield")
		var reduction = shield.get_meta("damage_reduction", 0.0)
		actual_damage = int(damage * (1.0 - reduction))
		print("Divine Shield reduced damage from ", damage, " to ", actual_damage)
	elif has_node("ManaShield"):
		var shield = get_node("ManaShield")
		var reduction = shield.get_meta("damage_reduction", 0.0)
		actual_damage = int(damage * (1.0 - reduction))
		print("Mana Shield reduced damage from ", damage, " to ", actual_damage)
	
	cur_hp -= actual_damage
	add_force(force)
	AudioManager.play(damaged_sound)
	
	if cur_hp <= 0:
		_die()
	else:
		OnTakeDamage.emit(force)
		OnHealthChange.emit()


func _die():
	pass


func heal(amount: int):
	cur_hp += amount
	
	if cur_hp > max_hp:
		cur_hp = max_hp
	
	OnHealthChange.emit()


func has_mana(amount: int) -> bool:
	return max_mana > 0 and cur_mana >= amount


func use_mana(amount: int) -> bool:
	if not has_mana(amount):
		return false
	
	cur_mana -= amount
	OnManaChange.emit()
	return true


func restore_mana(amount: int):
	if max_mana == 0:
		return
	
	cur_mana += amount
	
	if cur_mana > max_mana:
		cur_mana = max_mana
	
	OnManaChange.emit()


func add_force(force: Vector2):
	# Weight is based on stamina stat
	var weight = 1.0 + (stamina_stat * 0.05)
	external_force += force / weight


func _regenerate_mana(delta: float):
	if max_mana > 0 and cur_mana < max_mana:
		restore_mana(int(mana_regen_rate * delta))


func has_stamina(amount: float) -> bool:
	return cur_stamina >= amount


func use_stamina(amount: float) -> bool:
	if cur_stamina <= 0:
		return false
	
	cur_stamina -= int(amount)
	if cur_stamina < 0:
		cur_stamina = 0
	
	OnStaminaChange.emit()
	return true


func restore_stamina(amount: int):
	cur_stamina += amount
	
	if cur_stamina > max_stamina:
		cur_stamina = max_stamina
	
	OnStaminaChange.emit()


func _regenerate_stamina(delta: float):
	# Don't regenerate while sprinting
	if is_sprinting:
		return
	
	if cur_stamina < max_stamina:
		restore_stamina(int(stamina_regen_rate * delta))


# Calculate derived stats from core stats
func calculate_stats():
	# Strength: +5 HP per point
	max_hp = 50 + (strength * 5)
	
	# Intelligence: +10 Mana per point, +5% magic damage per point
	max_mana = intelligence * 10
	mana_regen_rate = 5.0 + (intelligence * 0.5)
	magic_damage_multiplier = 1.0 + (intelligence * 0.05)
	
	# Stamina: +10 max stamina per point, +10 weight limit per point
	max_stamina = 50 + (stamina_stat * 10)
	stamina_regen_rate = 10.0 + (stamina_stat * 1.0)
	weight_limit = 50.0 + (stamina_stat * 10.0)
	
	# Agility: +2% crit chance per point, +1% hit chance per point
	crit_chance = 0.05 + (agility * 0.02)
	hit_chance = 0.85 + (agility * 0.01)
	if hit_chance > 1.0:
		hit_chance = 1.0
	
	# Ensure current values don't exceed new maximums
	if cur_hp > max_hp:
		cur_hp = max_hp
	if cur_mana > max_mana:
		cur_mana = max_mana
	if cur_stamina > max_stamina:
		cur_stamina = max_stamina
	
	OnHealthChange.emit()
	OnManaChange.emit()
	OnStaminaChange.emit()
