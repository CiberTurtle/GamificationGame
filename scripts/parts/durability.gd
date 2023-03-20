extends Node

@export var uses:=1
func trigger() -> void:
	uses -= 1
	if uses <= 0:
		owner.die()
