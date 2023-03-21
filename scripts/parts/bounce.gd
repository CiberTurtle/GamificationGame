extends Node2D

func _ready():
	get_parent().attack.connect(attack)

func attack(node: Node2D) -> void:
	owner.velocity.x = -owner.velocity.x
	owner.velocity.y = abs(owner.velocity.y)
