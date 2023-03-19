extends Node2D

@export var scene: PackedScene
@export var distance:= 10.0
@export_range(0, 10, 1, 'or_greater', 'suffix:count') var count := 1
#@export var spread: Range

func trigger() -> void:
	for i in count:
		spawn()

func spawn() -> void:
	var proj = scene.instantiate() as Node2D
	proj.position += Vector2(distance * global_scale.x, 0.)
	proj.damage_source = owner.player
	get_owner().add_child(proj)
