extends Node2D

@export var velocity := Vector2(128., -256.)

func trigger() -> void:
	SoundBank.play('throw.' + owner.item_name, global_position)
	owner.player.try_drop_item()
	owner.velocity.x = global_transform.basis_xform(Vector2.RIGHT).x * velocity.x
	owner.velocity.y = velocity.y
