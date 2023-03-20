extends Node
@export var speed:=300.0

func trigger() -> void:
	owner.player.try_drop_item()
	owner.velocity.x = speed

func _process(delta: float) -> void:
	pass
