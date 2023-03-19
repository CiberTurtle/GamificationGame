extends Node


@export var turns_per_second:=2.0
@export var node:Node2D
@export var length:=60.
var active:=false
var age:=0.
func trigger():
	active = true
	age = 0.

func _process(delta):
	if active:
		node.rotate(turns_per_second * 2 * PI * delta)
		age += delta
		if age > length / 60.:
			node.rotation = 0.
			active = false
