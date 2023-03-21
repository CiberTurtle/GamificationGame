extends Node2D

@export var sound := ''

func trigger() -> void:
	SoundBank.play(sound, position)
