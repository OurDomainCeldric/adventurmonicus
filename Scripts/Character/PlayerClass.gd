class_name PlayerClass
extends Resource

@export var player_class_name: String
@export var description: String

# Core Stats
@export_group("Core Stats")
@export var strength: int = 10
@export var agility: int = 10
@export var intelligence: int = 10
@export var stamina: int = 10

# Derived Stats (set by class, not manually)
@export_group("Derived Stats")
@export var starting_hp: int = 10
@export var max_hp: int = 10
@export var starting_mana: int = 0
@export var max_mana: int = 0
@export var mana_regen_rate: float = 5.0
@export var move_speed: float = 20
@export var weight_limit: float = 100.0
@export var max_stamina: int = 100
@export var stamina_regen_rate: float = 10.0
@export var starting_weapon: WeaponItemData
@export var starting_shield: ShieldItemData
@export var additional_items: Dictionary[ItemData, int] = {}
@export var icon: Texture2D
@export var ability_descriptions: Array[String] = []
@export var abilities: Array[AbilityData] = []
