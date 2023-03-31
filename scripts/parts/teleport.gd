extends Node2D

func trigger():
	if not is_instance_valid(owner.damage_source.player):
		owner.queue_free()
		return
	SoundBank.play('teleport', global_position)
	owner.damage_source.player.global_position = self.global_position
	owner.damage_source.player.speed_vertical = 0.
	owner.damage_source.player.coyote_timer = .2
