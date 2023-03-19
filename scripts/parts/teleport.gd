extends Node

@export var to_move :Node2D

func trigger():
	to_move.global_position = self.global_position
