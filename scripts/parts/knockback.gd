extends Node

@export var x_knockback:=100.0
@export var y_knockback:=0.0
func _ready():
	get_parent().attack.connect(attack)
func attack(victim: Node2D) -> void:
	if victim is Player:
		victim.speed_extra += x_knockback
		victim.speed_vertical += y_knockback
	else:
		victim.velocity += Vector2(x_knockback, y_knockback)
