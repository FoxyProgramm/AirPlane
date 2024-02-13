extends StaticBody2D

var have_item = false
var item = null

func _ready():
#	$CanvasLayer/Window.popup(Rect2i(9, 40, 144, 79))
	pass

func _melt():
	$image.rotation = 0
	await get_tree().create_tween().tween_property($image, "rotation", 2*PI*6, 1).finished
	Items._create_item(item, 1, global_position + Vector2(0, 8))
	have_item = false
