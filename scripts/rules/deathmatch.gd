extends Node

const PLAYER_SCENE: PackedScene = preload('res://scenes/player.tscn')

func _ready() -> void:
	Game.start.connect(_game_start)
	Game.player_died.connect(_player_died)

func _game_start() -> void:
	for player_data in Game.player_datas:
		spawn_player(player_data)

func _player_died(player: Player) -> void:
	player.queue_free()
	var tween := create_tween()
	tween.tween_callback(func(): spawn_player(player.player_data))

func spawn_player(player_data: PlayerData) -> void:
	var player := PLAYER_SCENE.instantiate() as Player
	player.player_data = player_data
	player_data.player = player
	
	var spawns_node := Globals.level.find_child('PlayerSpawns')
	var best_spawn_point := Vector2.ZERO
	var best_spawn_point_score := -1.
	
	# find the spawn point that is the furthest away from all players
	for spawn_point in spawns_node.get_children():
		var score := 0.
		for pd in Game.player_datas:
			if not is_instance_valid(pd.player): continue
			score += pd.player.position.distance_squared_to(spawn_point.position)
		
		if score > best_spawn_point_score:
			best_spawn_point_score = score
			best_spawn_point = spawn_point.position
	player.global_position = best_spawn_point
	
	Globals.world.add_child(player)
