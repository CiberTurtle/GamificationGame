class_name Main extends Node

@export var player_scene: PackedScene

@onready var game_viewport: SubViewport = %GameViewport
@onready var load_level_dialog: FileDialog = %LoadLevelDialog
@onready var spawn_item_dialog: FileDialog = %SpawnItemDialog

func _enter_tree() -> void:
	Globals.main = self
	Globals.world = %World

func _ready() -> void:
	load_level_dialog.title = "Pick a level to load - Press 'L' to open this again"
	spawn_item_dialog.title = "Pick an item then click to spawn it - Press 'I' to open this again"
	
	Console.register('load', func(): load_level_dialog.popup_centered(); Console.close())
	Console.register('spawn', func(): spawn_item_dialog.popup_centered(); Console.close())
	
	load_level_dialog.popup_centered()

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_L and event.is_pressed():
		get_viewport().set_input_as_handled()
		load_level_dialog.popup_centered()
		return
	
	if event is InputEventKey and event.keycode == KEY_I and event.is_pressed():
		get_viewport().set_input_as_handled()
		spawn_item_dialog.popup_centered()
		return

var next_item_spawn: PackedScene
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if next_item_spawn:
				spawn_item()
				next_item_spawn = null

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

func spawn_item() -> void:
	var item := next_item_spawn.instantiate() as Item
	Globals.world.add_child(item)
	item.position = item.get_global_mouse_position()

func _on_load_level_dialog_file_selected(path: String) -> void:
	load_level(load(path))

func _on_spawn_item_dialog_file_selected(path: String) -> void:
	next_item_spawn = load(path)
