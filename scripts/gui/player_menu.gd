class_name PlayerMenu extends Control

var player_data: PlayerData
var is_ready := false

@onready var ready_node: Control = %Ready
@onready var controller_name: Button = %ControllerName

func _ready() -> void:
	if player_data:
		controller_name.text = player_data.input.get_name()
		%Panel.modulate = player_data.color

func _process(delta: float) -> void:
	if not Game.player_datas.has(player_data):
		queue_free()
		return
	
	if not is_visible_in_tree(): return

	if is_ready:
		if player_data.input.is_action_just_pressed('back'):
			unready()
	else:
		if player_data.input.is_action_just_pressed('ok'):
			ready()
			return
		if player_data.input.is_action_just_pressed('back'):
			leave()
			return
	
	ready_node.visible = is_ready

func ready() -> void:
	is_ready = true

func unready() -> void:
	is_ready = false

func leave() -> void:
	Game.player_datas.erase(player_data)
	queue_free()
