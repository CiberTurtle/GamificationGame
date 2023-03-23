extends Node

signal start()
signal end()
signal player_died(player: Player)

var player_turn_index := 0
var player_datas: Array[PlayerData] = []

func join_player(input: DeviceInput) -> PlayerData:
	var player_data := PlayerData.new()
	
	player_data.input = input
	if unassigned_inputs.has(input.device):
		unassigned_inputs.erase(input.device)
	
	player_datas.append(player_data)
	return player_data

func leave_player(player_data: PlayerData) -> void:
	player_datas.erase(player_data)
	player_turn_index = player_turn_index%player_datas.size()
	
	if player_data.input.is_device_connected():
		unassigned_inputs.append(player_data.input.device)

var inputs: Array[DeviceInput] = [
	DeviceInput.new(-1)
]

var unassigned_inputs: Array[int] = []

var next_player_color_index := 0
func get_next_player_color() -> Color:
	next_player_color_index = next_player_color_index%Consts.player_colors.size()
	var color := Consts.player_colors[next_player_color_index]
	next_player_color_index += 1
	return color

func _enter_tree() -> void:
	for joy in Input.get_connected_joypads():
		prints('joy pre exist', joy)
		inputs.append(DeviceInput.new(joy))
	Input.joy_connection_changed.connect(joy_connection_changed)
	
	if OS.is_debug_build():
		print('auto seting up all players since in debug mode')
		for input in inputs:
			join_player(input)

func joy_connection_changed(device: int, connected: bool) -> void:
	prints('joy changed', device, Input.get_joy_name(device), connected)
	
	if connected:
		inputs.append(DeviceInput.new(device))
		return
	else:
		return
		var inputs := inputs.filter(func(i: DeviceInput): return i.device == device)
		assert(inputs.size() == 1)
		inputs.erase(inputs[0])
		for player_data in player_datas:
			if player_data.input.is_device_connected():
				Game.set_pause()

var pause_locks := 0
func update_pause() -> void:
	assert(pause_locks >= 0)
	get_tree().paused = pause_locks > 0

func set_pause() -> void:
	pause_locks += 1
	update_pause()

func unset_pause() -> void:
	pause_locks -= 1
	update_pause()
