class_name PlayerData extends RefCounted

var guid: int
var player: Player
var input: DeviceInput
var color: Color

var is_ready := false

func _init() -> void:
	guid = randi()
	color = Game.get_next_player_color()
