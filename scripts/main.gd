class_name Main extends Node

func _enter_tree() -> void:
	Globals.main = self
	Globals.world = %World
