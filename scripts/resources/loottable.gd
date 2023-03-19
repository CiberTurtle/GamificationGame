class_name Loottable extends Resource

@export var scenes: Array[PackedScene] = []

func pick() -> PackedScene:
	return scenes.pick_random()
