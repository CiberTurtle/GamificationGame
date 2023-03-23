class_name PlayerData extends RefCounted

var guid: int
var player: Player
var input: DeviceInput
var color: Color
var skin_index: int

var is_ready := false
var is_leader := false

func _init() -> void:
	guid = randi()
	color = Game.get_next_player_color()
	skin_index = randi()%SkinDB.skins.size()
