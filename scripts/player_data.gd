class_name PlayerData extends RefCounted

var guid: int
var player: Player
var input: DeviceInput
var color: Color
var color_index: int
var skin_index: int

var is_ready := false
var is_leader := false

var kills := 0
var deaths := 0

func _init() -> void:
	guid = randi()
	color = Game.get_next_player_color()
	color_index = Game.next_player_color_index - 1
	skin_index = randi()%SkinDB.skins.size()
