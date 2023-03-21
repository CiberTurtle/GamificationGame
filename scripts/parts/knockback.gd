extends Node2D

@export var x_knockback := 100.
@export var y_knockback := 0.

func _ready():
	get_parent().attack.connect(attack)

func attack(node: Node2D) -> void:
	if node is Player:
		node.speed_extra += x_knockback*global_transform.basis_xform(Vector2.RIGHT).x
		node.speed_vertical += y_knockback
	else:
		node.velocity.x += x_knockback*global_transform.basis_xform(Vector2.RIGHT).x
		node.velocity.y += y_knockback
