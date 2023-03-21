extends Node


@export var health:=0.0
@export var max_health:=0.0
@export var move_speed_modifier:=1.0
@export var jump_height_modifier:=1.0
@export var climb_speed_modifier:=1.0
@export var perma:=false
@export var duration:=600.0

func trigger():
	"""
	get_owner().player.reset_modifiers()
	get_owner().player.is_mod_perma = perma
	if !perma:
		get_owner().player.current_mod_duration = duration
	get_owner().player.base_health_mod = max_health
	get_owner().player.move_speed_mod = move_speed_modifier
	get_owner().player.jump_height_mod = jump_height_modifier
	get_owner().player.climb_speed_mod = climb_speed_modifier
	"""
