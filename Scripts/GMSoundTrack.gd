extends Node

var music = [
	load("res://Audio/Music/space.ogg"),
	load("res://Audio/Music/space_2.ogg")
]

func _play(id):
	$player.stream = music[id]
	$player.play()

func _stop():
	pass

func _ready():
	_play(1)
