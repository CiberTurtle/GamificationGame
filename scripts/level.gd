class_name Level extends Node2D

@export_range(1, 10, 1) var size := 3
@export var music: AudioStreamOggVorbis

@onready var width := 1920/size
@onready var height := 1080/size

var damage_source: PlayerData = null
