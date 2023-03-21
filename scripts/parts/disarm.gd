extends Node2D

func _ready():
	get_parent().attack.connect(attack)

func attack(node: Node2D) -> void:
	if node is Player:
		node.try_drop_item()
