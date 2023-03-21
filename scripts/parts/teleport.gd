extends Node

func trigger():
	if not is_instance_valid(owner.damage_source.player):
		queue_free()
		return
	owner.damage_source.player.global_position = self.global_position
