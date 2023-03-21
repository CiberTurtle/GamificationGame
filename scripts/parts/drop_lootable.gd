extends Node2D

@export var loottable: Loottable

func trigger() -> void:
	var scene := loottable.pick()
	var node := scene.instantiate() as Node2D
	node.transform = global_transform
	if node is CharacterBody2D:
		node.velocity = owner.velocity
	Globals.world.add_child.call_deferred(node)
