extends Node2D

@export var scene: PackedScene

func trigger() -> void:
	var node := scene.instantiate() as Node2D
	node.global_position = global_position
	Globals.world.add_child(node)
