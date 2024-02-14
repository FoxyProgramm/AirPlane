extends StaticBody2D

var have_item = false
var item = null
var need_energy = 0.2
var energy = 0.0
var max_energy = 2.0

func _ready():
#	$CanvasLayer/Window.popup(Rect2i(9, 40, 144, 79))
	pass

func add_energy(value):
	energy += value
	$energy.value = energy

func _melt():
	if energy < need_energy:
		if have_item:
			await get_tree().create_timer(1).timeout
			_melt()
		return
	add_energy(-need_energy)
	$image.rotation = 0
	await get_tree().create_tween().tween_property($image, "rotation", PI*12, 1).finished
	Items._create_item(item, 1, global_position + Vector2(0, 8))
	have_item = false
