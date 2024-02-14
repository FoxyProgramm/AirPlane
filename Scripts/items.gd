extends Node

var cursor_path = "res://cursors/white/"
var cursors: Array
var item = load("res://scenes/item.tscn")

func _ready():
	for i in range(5):
		cursors.append( load(cursor_path + str( i + 1 ) + ".png" ))
	DisplayServer.cursor_set_custom_image(cursors[randi() % 5], DisplayServer.CURSOR_ARROW, Vector2(16, 16))

func _create_item(res, count, pos, need_this_child: bool = false, attract_to_pointer:bool = false):
	var new_item = item.instantiate()
	new_item._resourse = res
	new_item.count = count
	new_item.position = pos
	get_tree().current_scene.get_node("items").add_child(new_item)
	if attract_to_pointer:
		new_item._press(true)
	if need_this_child:
		return new_item
		
