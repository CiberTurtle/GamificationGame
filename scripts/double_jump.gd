extends Area2D

@export var time:=0.0
@export var cooldown := 0.0
@onready var remaining := cooldown
func _on_body_entered(body):
	if remaining < 0 && body is Player:
		remaining = cooldown
		body.coyote_timer = time

func _process(delta):
	remaining -= delta
