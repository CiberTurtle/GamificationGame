class_name Main extends Node

@onready var sub_viewport_container: SubViewportContainer = %SubViewportContainer

func _enter_tree() -> void:
	Globals.main = self
	Globals.world = %World

var current_level: Level
func load_level(scene: PackedScene) -> void:
	# remove previous level
	if is_instance_valid(current_level):
		current_level.queue_free()
	
	# spawn new level
	var level := scene.instantiate() as Level
	sub_viewport_container.stretch_shrink = level.size
