extends Node2D

@export var scene: PackedScene
@export_range(0, 10, 1, 'or_greater', 'suffix:count') var count := 1
#@export var spread: Range

func trigger() -> void:
	for i in count:
		spawn()

func spawn() -> void:
	var proj = scene.instantiate() as Node2D
	proj.transform = global_transform
	proj.damage_source = owner.player
	Globals.world.add_child(proj)
