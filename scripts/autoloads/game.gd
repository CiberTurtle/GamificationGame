extends Node

var player_datas: Array[PlayerData] = []

var inputs: Array[DeviceInput] = [
	DeviceInput.new(-1)
]

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
			var player_data := PlayerData.new()
			player_data.input = input
			player_datas.append(player_data)

func joy_connection_changed(device: int, connected: bool) -> void:
	prints('joy changed', device, Input.get_joy_name(device), connected)
	
	if connected:
		inputs.append(DeviceInput.new(device))
		return
	
