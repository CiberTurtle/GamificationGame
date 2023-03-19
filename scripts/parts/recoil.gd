extends Node2D

@export var velocity := Vector2(-64., -64.)
@export var add_to_x := true
@export var zero_out_move := false
@export var add_to_y_if_up := false
@export var add_to_y_if_down := true

func trigger() -> void:
	var player: Player = owner.player
	var direction := global_transform.basis_xform(Vector2.RIGHT).x
	if add_to_x:
		player.speed_extra += direction*velocity.x
	else:
		player.speed_extra = direction*velocity.x
	
	if velocity.y < 0.:
		if add_to_y_if_up:
			player.speed_vertical += velocity.y
		else:
			player.speed_vertical = velocity.y
	else:
		if add_to_y_if_down:
			player.speed_vertical += velocity.y
		else:
			player.speed_vertical = velocity.y
	
	if zero_out_move:
		player.speed_move = 0.
