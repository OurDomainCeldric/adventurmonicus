extends ProgressBar

var player: Player

func _ready() -> void:
	# Get player reference
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("Player")
	if player:
		player.OnManaChange.connect(_update_mana_bar)
		_update_mana_bar()
		
		# Hide if player has no mana
		if player.max_mana == 0:
			visible = false

func _update_mana_bar() -> void:
	if not player:
		return
	
	# Hide bar if player has no mana
	if player.max_mana <= 0:
		get_parent().visible = false
		return
	
	get_parent().visible = true
	max_value = player.max_mana
	value = player.cur_mana
