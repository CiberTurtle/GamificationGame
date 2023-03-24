extends Node

const PLAYER_SPAWN_SCENE: PackedScene = preload('res://scenes/fx/spawn_location.tscn')

var timer: float
var is_running := false

@onready var timer_label: Label = %TimerLabel
@onready var countdown_label: Label = %CountdownLabel

func _ready() -> void:
	Game.start.connect(_game_start)
	Game.end.connect(_game_end)
	Game.player_died.connect(_player_died)

func _physics_process(delta: float) -> void:
	if is_running:
		run(delta)

func _process(delta: float) -> void:
	countdown_label.visible = timer <= 10.
	countdown_label.text = str(ceil(timer))
	var s: float = lerp(.5, 1., ease(fmod(timer/1., 1.), .1))
	countdown_label.scale = Vector2(s, s)

func _game_start() -> void:
	is_running = true
	timer = 3.*60
	#timer = 15.
	
	for player_data in Game.player_datas:
		spawn_player(player_data)
		player_data.kills = 0
		player_data.deaths = 0

func _game_end() -> void:
	is_running = false

func run(delta: float) -> void:
	timer_label.text = Calc.convert_m_ss(ceil(timer))
	timer -= delta
	if timer < 0.:
		is_running = false
		Game.end.emit()

func _player_died(player: Player) -> void:
	player.player_data.deaths += 1
	if is_instance_valid(player.last_damage_source) and is_instance_valid(player.last_damage_source.player):
		player.last_damage_source.kills += 1
		player.last_damage_source.player.health = max(player.last_damage_source.player.health + 50, player.last_damage_source.player.base_health)
		player.last_damage_source.player.update_health_bar()
	
	player.queue_free()
	spawn_player(player.player_data)

func spawn_player(player_data: PlayerData) -> void:
	var spawn := PLAYER_SPAWN_SCENE.instantiate()
	spawn.player_data = player_data
	
	var spawns_node := Globals.level.find_child('PlayerSpawns')
	var best_spawn_point := Vector2.ZERO
	var best_spawn_point_score := -1.
	
	# find the spawn point that is the furthest away from all players
	for spawn_point in spawns_node.get_children():
		var score := 0.
		for pd in Game.player_datas:
			if not is_instance_valid(pd.player): continue
			score += pd.player.position.distance_squared_to(spawn_point.position)
		
		score += randi_range(-300, 300)
		
		if score > best_spawn_point_score:
			best_spawn_point_score = score
			best_spawn_point = spawn_point.position
	spawn.global_position = best_spawn_point
	
	Globals.world.add_child(spawn)
