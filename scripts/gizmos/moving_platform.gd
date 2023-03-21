extends StaticBody2D

@onready var previous_position := position

func _physics_process(delta: float) -> void:
	var motion := position - previous_position
	previous_position = position
	constant_linear_velocity = motion
