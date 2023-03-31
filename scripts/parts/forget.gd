extends Node2D

@export var hitbox: Hitbox

func trigger() -> void:
	hitbox.forget_hits()
