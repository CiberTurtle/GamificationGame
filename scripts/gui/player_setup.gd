class_name PlayerSetup extends Control

signal finish

var level_index := 0
var picked_level := ''

@onready var cursor: Control = %Cursor
@onready var turn_label: Label = %TurnLabel
@onready var player_list: Control = %PlayerList
@onready var level_list: Control = %LevelList

var player_menu: Control
var level_button: Control

func _ready() -> void:
	player_menu = player_list.get_child(0)
	player_list.remove_child(player_menu)
	
	level_button = level_list.get_child(0)
	level_list.remove_child(level_button)
	
	for player_data in Game.player_datas:
		add_player_menu(player_data)
	
	for i in LevelDB.level_paths.size():
		var level_name = LevelDB.level_names[i]
		var level_thumbnail = LevelDB.level_thumbnails[i]
		
		var btn := level_button.duplicate()
		btn.find_child('ThumbnailSprite', true, false).texture = level_thumbnail
		btn.find_child('NameLabel', true, false).text = level_name
		level_list.add_child(btn)
	
	var rand_btn := level_button.duplicate()
	rand_btn.find_child('ThumbnailSprite', true, false).texture = preload('res://content/thumbnails/random.png')
	rand_btn.find_child('NameLabel', true, false).text = "Random?"
	level_list.add_child(rand_btn)
	
	update()
	
	if OS.has_feature('web'):
		%FullscreenButton.hide()
		%WebWarnLabel.show()
	else:
		await get_tree().process_frame
		update_window_button()

func open() -> void:
	show()
	picked_level = ''
	for player_data in Game.player_datas:
		player_data.is_ready = false
	for menu in player_list.get_children():
		menu.update()
		menu.no_say()
	update()
	level_list.propagate_call('show')

func update() -> void:
	var color := Consts.player_colors[Game.player_turn_index]
	turn_label.modulate = color
	turn_label.text = "Player %s's turn" % [Game.player_turn_index + 1]
	cursor.modulate = color

var time := 0.
func _process(delta: float) -> void:
	if not visible: return
	update()
	time += delta
	
	var target_control := level_list.get_child(level_index) as Control
	var target_position := target_control.position
	cursor.size = cursor.size.lerp(target_control.size, .5)
	cursor.position = cursor.position.lerp(target_position + level_list.position, .5)
	cursor.pivot_offset = cursor.size/2.
	cursor.rotation = sin(time*PI*2*2)*0.075
	
	for input in Game.inputs:
		if not Game.player_datas.any(func(pd: PlayerData): return pd.input.device == input.device):
			if input.is_action_just_pressed('ok'):
				SoundBank.play_ui('ui_join')
				var player_data := PlayerData.new()
				player_data.input = input
				Game.player_datas.append(player_data)
				add_player_menu(player_data)
	
	var unready_players := Game.player_datas.filter(func(pd: PlayerData): return not pd.is_ready)
	
	if Game.player_datas.size() >= 1 and unready_players.size() == 0 and picked_level.length() > 0:
		finish.emit()
		var level := load(picked_level)
		Globals.main.load_level(level)
		hide()
		return
	
	%JoinPrompt.visible = Game.player_datas.size() < 4
	
	if Game.player_datas.size() == 0: return
	
	Game.player_turn_index = Game.player_turn_index%Game.player_datas.size()
	var picking_player := Game.player_datas[Game.player_turn_index]
	if  picking_player and picking_player.is_ready and picked_level.is_empty():
		if not picking_player.input.is_device_connected(): return
		
		if picking_player.input.is_action_just_pressed('left'):
			SoundBank.play_ui('ui_select')
			level_index -= 1
		if picking_player.input.is_action_just_pressed('right'):
			SoundBank.play_ui('ui_select')
			level_index += 1
		if picking_player.input.is_action_just_pressed('up'):
			SoundBank.play_ui('ui_select')
			level_index -= level_list.columns
		if picking_player.input.is_action_just_pressed('down'):
			SoundBank.play_ui('ui_select')
			level_index += level_list.columns
		
		level_index = level_index%(LevelDB.level_paths.size() + 1)
		
		if picking_player.input.is_action_just_pressed('ok'):
			SoundBank.play_ui('ui_pick')
			
			if level_index == LevelDB.level_paths.size():
				picked_level = LevelDB.level_paths[randi()%LevelDB.level_paths.size()]
			else:
				picked_level = LevelDB.level_paths[level_index]
			
			for child in level_list.get_children():
				child.hide()
			level_list.get_child(level_index).show()
	
	cursor.visible = picking_player and picking_player.is_ready and picked_level.is_empty()

func add_player_menu(player_data: PlayerData) -> void:
	var menu := player_menu.duplicate()
	menu.player_data = player_data
	player_list.add_child(menu)

func _on_fullscreen_button_pressed() -> void:
	if get_window().mode != Window.MODE_FULLSCREEN:
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED
	
	update_window_button()

func update_window_button() -> void:
	if get_window().mode == Window.MODE_FULLSCREEN:
		%FullscreenButton.text = 'Go windowed'
	else:
		%FullscreenButton.text = 'Go fullscreen'

func _on_kick_button_pressed() -> void:
	#var unready_players := Game.player_datas.filter(func(pd: PlayerData): return not pd.is_ready)
	for player_data in Game.player_datas.duplicate():
		Game.player_datas.erase(player_data)
