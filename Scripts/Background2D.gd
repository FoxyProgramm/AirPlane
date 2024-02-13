extends Node2D

var is_inventory_open = false # Оно тут вообще не нужно, нужно
var in_inventory = 0 # Что это за переменная, ебейшая
var cursor_collider = [] # Почему это массив?, покачену ajdfkajsdlf
@export var t = Resource
func _physics_process(delta):
	$cursor.global_position = get_global_mouse_position()

func _area_enter(area):
	cursor_collider.append(area)
	if "inventory" in area.get_groups():
		in_inventory += 1

func _area_exit(area):
	cursor_collider.erase(area)
	if "inventory" in area.get_groups():
		in_inventory -= 1
