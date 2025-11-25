extends CanvasLayer

@onready var spell_bar: SpellBarUI = $SpellBar
@onready var full_inventory: FullInventoryUI = $FullInventory

var player: Player

func _ready() -> void:
	# Find player in parent
	await get_tree().process_frame
	player = get_parent() as Player
	
	if player:
		setup_hud()

func setup_hud() -> void:
	if spell_bar:
		spell_bar.setup(player)
	
	if full_inventory:
		full_inventory.setup(player)
