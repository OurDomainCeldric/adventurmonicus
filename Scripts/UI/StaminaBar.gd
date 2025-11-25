extends ProgressBar

var player: Player

func _ready() -> void:
	# Get player reference
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("Player")
	
	if player:
		player.OnStaminaChange.connect(_update_stamina_bar)
		_update_stamina_bar()

func _update_stamina_bar() -> void:
	if not player:
		return
	
	max_value = player.max_stamina
	value = player.cur_stamina
