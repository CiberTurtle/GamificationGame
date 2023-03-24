extends Node2D

@export var scene: PackedScene

func trigger() -> void:
	var node := scene.instantiate() as Node2D
	node.global_transform = global_transform
	Globals.world.add_child(node)
