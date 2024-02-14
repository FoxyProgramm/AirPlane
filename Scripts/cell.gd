extends Area2D

signal new_item

var item = null
var item_count = 0
@export var bg:bool = false

func _ready():
	if !bg:
		$bg.visible = false

func init_res():
	if item == null:
		$texture.texture = null
		$count.text = ""
	else :
		$texture.texture = item.texture
		$count.text = str(item_count)

func get_item(count):
	item_count -= count
	if item_count <= 0:
		item = null
	init_res()

func remove_item(attract_to_cursor:bool = false):
	if item == null:
		return
	var count = 1
	if Input.is_action_pressed("tz_shift"):
		count = item_count
	elif Input.is_action_pressed("tz_ctrl"):
		count = ceili(item_count/2.0)
	Items._create_item(item, count, get_global_mouse_position(), false, true)
	item_count -= count
	if item_count <= 0:
		item = null
	init_res()

func add_item(res, count):
	if item == null:
		item = res
		item_count = count
		emit_signal("new_item")
		init_res()
		return 0
	if item.name == res.name:
		item_count += count
		init_res()
		return 0
	return -1
