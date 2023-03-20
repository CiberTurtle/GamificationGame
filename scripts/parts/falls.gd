extends Node

@export var gravity:=0.0
@export var max_fall_speed:=0.0
@export var grounded_dec:=0.0

func _process(delta):
	owner.velocity.y += gravity*delta
	if owner.velocity.y > max_fall_speed:
		owner.velocity.y = max_fall_speed
	
	if owner.is_on_wall():
		owner.velocity.x = 0.
	if owner.is_on_ceiling() and owner.velocity.y < 0.:
		owner.velocity.y = 0.
	if owner.is_on_floor():
		owner.velocity.x = move_toward(owner.velocity.x, 0., grounded_dec*delta)
		if owner.velocity.y > 0.:
			owner.velocity.y = 0.
	
	owner.move_and_slide()
