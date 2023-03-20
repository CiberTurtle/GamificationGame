extends Node

func trigger():
	owner.damage_source.global_position = self.global_position
