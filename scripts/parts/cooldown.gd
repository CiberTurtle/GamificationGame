extends Node2D

const TPS := 60.

@export_range(0, 60, 1, 'or_greater', 'suffix:ticks') var ticks := 30.

func trigger() -> void:
	owner.cooldown = ticks/TPS
