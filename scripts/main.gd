class_name Main extends Node

@export var player_scene: PackedScene

@onready var game_viewport: SubViewport = %GameViewport
@onready var load_level_dialog: FileDialog = %LoadLevelDialog

func _enter_tree() -> void:
	Globals.main = self
	Globals.world = %World

func _ready() -> void:
	Console.register('load', func(): load_level_dialog.show(); Console.close())
	load_level_dialog.popup_centered()
	load_level_dialog.title = "Pick a level to load - Press 'L' to open this again"

func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_L):
		load_level_dialog.show()

var current_level: Level
func load_level(scene: PackedScene) -> void:
	# remove previous level and actors
	for child in Globals.world.get_children():
		child.queue_free()
	
	# spawn new level
	var level := scene.instantiate() as Level
	Globals.world.add_child(level)
	current_level = level
	game_viewport.size_2d_override.x = current_level.width
	game_viewport.size_2d_override.y = current_level.height
	
	spawn_players()

func spawn_players() -> void:
	var player := player_scene.instantiate() as Player
	player.global_position = current_level.find_child('PlayerSpawns').get_child(0).position
	Globals.world.add_child(player)

func _on_load_level_dialog_file_selected(path: String) -> void:
	load_level(load(path))
