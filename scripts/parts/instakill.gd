extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.has_method('die'):
		body.call('die')
	body.queue_free()
