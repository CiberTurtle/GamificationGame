extends Node2D

@export var scene: PackedScene
@export_range(0, 10, 1, 'or_greater', 'suffix:count') var count := 1
@export var delay:=.1
@export var durability:=1
var til_spawn = 0.0
var shots_left = 0
#@export var spread: Range

func trigger() -> void:
	if shots_left <= 0:
		til_spawn = 0.0
		shots_left = count
		durability -= 1
	else:
		owner.cooldown = -1.0

func spawn() -> void:
	var proj = scene.instantiate() as Node2D
	proj.transform = global_transform
	proj.damage_source = owner.player
	Globals.world.add_child(proj)

func _process(delta):
	til_spawn -= delta
	if shots_left && shots_left > 0 && til_spawn < 0:
		spawn()
		til_spawn = delay
		shots_left -= 1
		if shots_left <= 0 && durability <= 0:
			owner.die()
