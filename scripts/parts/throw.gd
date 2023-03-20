extends Node2D

@export var velocity := Vector2(128., -256.)

func trigger() -> void:
	owner.player.try_drop_item()
	owner.velocity.x = global_transform.basis_xform(Vector2.RIGHT).x * velocity.x
	owner.velocity.y = velocity.y
