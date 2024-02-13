extends Node

var music = [
	load("res://space.ogg")
]

func _play(id):
	$player.stream = music[id]
	$player.play()

func _stop():
	pass

func _ready():
	_play(0)
