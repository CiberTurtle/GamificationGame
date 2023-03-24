extends Node2D

func trigger():
	SoundBank.play('teleport', global_position)
	if not is_instance_valid(owner.damage_source.player):
		owner.queue_free()
		return
	owner.damage_source.player.global_position = self.global_position
