extends Node2D

@export var x_knockback := 100.
@export var apply_x_outward := false
@export var y_knockback := 0.

func _ready():
	get_parent().attack.connect(attack)

func attack(node: Node2D) -> void:
	var x := x_knockback
	if apply_x_outward:
		x *= sign(node.global_position.x - global_position.x)
	else:
		x *= global_transform.basis_xform(Vector2.RIGHT).x
	
	if node is Player:
		node.speed_extra += x
		node.speed_vertical += y_knockback
	else:
		node.velocity.x += x
		node.velocity.y += y_knockback
