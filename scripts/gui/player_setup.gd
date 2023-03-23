class_name PlayerSetup extends Control

signal finish

@export var ready_delay_before_finish := 1.
var all_ready_timer := 0.
@onready var player_list: Control = %PlayerList

var player_menu: Control

func _ready() -> void:
	player_menu = player_list.get_child(0)
	player_list.remove_child(player_menu)
	
	for player_data in Game.player_datas:
		add_player_menu(player_data)

func _process(delta: float) -> void:
	if not visible: return
	
	for input in Game.inputs:
		if not Game.player_datas.any(func(pd: PlayerData): return pd.input.device == input.device):
			if input.is_action_just_pressed('ok'):
				var player_data := PlayerData.new()
				player_data.input = input
				Game.player_datas.append(player_data)
				add_player_menu(player_data)
	
	if Game.player_datas.size() >= 1 and player_list.get_children().all(func(pm): return pm.is_ready):
		all_ready_timer += delta
		if all_ready_timer > ready_delay_before_finish:
			all_ready_timer = 0.
			for menu in player_list.get_children():
				menu.is_ready = false
				menu.update_ready()
			finish.emit()
			hide()
			return
	else:
		all_ready_timer = 0.

func add_player_menu(player_data: PlayerData) -> void:
	print('add')
	var menu := player_menu.duplicate()
	menu.player_data = player_data
	player_list.add_child(menu)
