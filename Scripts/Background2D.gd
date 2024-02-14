extends Node2D

var is_inventory_open = false # Оно тут вообще не нужно, нужно
var in_inventory = false # Что это за переменная, ебейшая
var cursor_collider = [] 

func _physics_process(delta):
	$cursor.global_position = get_global_mouse_position()

func _area_enter(area):
	cursor_collider.append(area)
	if area.name == "inventory_area":
		in_inventory = true

func _area_exit(area):
	cursor_collider.erase(area)
	if area.name == "inventory_area":
		in_inventory = false
