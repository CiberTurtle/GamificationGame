class_name Main extends Node

@export var player_scene: PackedScene

@onready var scaler_node: CanvasItem = %Scaler
@onready var game_viewport_container: SubViewportContainer = %GameViewportContainer
@onready var game_viewport: SubViewport = %GameViewport

@onready var player_setup: PlayerSetup = %PlayerSetup

@onready var load_level_dialog: FileDialog = %LoadLevelDialog
@onready var spawn_item_dialog: FileDialog = %SpawnItemDialog

func _enter_tree() -> void:
	Globals.main = self
	Globals.world = %World

func _ready() -> void:
	load_level_dialog.title = "Pick a level to load - Press 'L' to open this again"
	spawn_item_dialog.title = "Pick an item then click to spawn it - Press 'I' to open this again"
	#load_level_dialog.popup_centered()
	
	Console.register('load', func(): load_level_dialog.popup_centered(); Console.close())
	Console.register('spawn', func(): spawn_item_dialog.popup_centered(); Console.close())
	Console.register('setup', func(): player_setup.show(); Console.close())
	
	get_viewport().size_changed.connect(update_viewport)
	update_viewport()
	
	Input.add_joy_mapping('0300fb2d6f0e00008101000011010000,Faceoff Deluxe,a:b1,b:b2,x:b0,y:b3,back:b8,guide:b12,start:b9,leftstick:b10,rightstick:b11,leftshoulder:b4,rightshoulder:b5,dpup:h0.1,dpdown:h0.4,dpleft:h0.8,dpright:h0.2,leftx:a0,lefty:a1,rightx:a2,righty:a3,lefttrigger:b6,righttrigger:b7,platform:Linux', true)

func _process(delta: float) -> void:
	update_viewport()

func update_viewport() -> void:
	var inner := Vector2(1920, 1080)
	var outer := Vector2(get_viewport().size)
	var inner_ratio := inner.x/inner.y
	var outer_ratio := outer.x/outer.y
	
	var s := 1.0
	if inner_ratio >= outer_ratio:
		s = outer.x/inner.x
	else:
		s = outer.y/inner.y
	
	scaler_node.scale = Vector2(s, s)
	scaler_node.global_position = (outer - inner*s)/2.

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_L and event.is_pressed():
		get_viewport().set_input_as_handled()
		load_level_dialog.popup_centered()
		return
	
	if event is InputEventKey and event.keycode == KEY_I and event.is_pressed():
		get_viewport().set_input_as_handled()
		spawn_item_dialog.popup_centered()
		return
	
	if event is InputEventKey and event.keycode == KEY_P and event.is_pressed():
		get_viewport().set_input_as_handled()
		player_setup.show()
		player_setup.update()
		return

var next_item_spawn: PackedScene
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if next_item_spawn:
				spawn_item()
				next_item_spawn = null

func load_level(scene: PackedScene) -> void:
	# remove previous level and actors
	for child in Globals.world.get_children():
		child.queue_free()
	
	# spawn new level
	var level := scene.instantiate() as Level
	Globals.world.add_child(level)
	Globals.level = level
	game_viewport.size.x = level.width
	game_viewport.size.y = level.height
	game_viewport_container.scale = Vector2(level.size, level.size)
	
	Game.start.emit()
	
	%Music.stream = level.music
	%Music.play()
	player_setup.hide()

func spawn_item() -> void:
	var item := next_item_spawn.instantiate() as Item
	Globals.world.add_child(item)
	item.position = item.get_global_mouse_position()

func _on_load_level_dialog_file_selected(path: String) -> void:
	load_level(load(path))

func _on_spawn_item_dialog_file_selected(path: String) -> void:
	next_item_spawn = load(path)
