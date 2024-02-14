extends CharacterBody2D

signal pick_up(id)

@onready var cursor = get_tree().current_scene.get_node("cursor")
@onready var path_to_inventory = $inventory
@onready var cam = $Camera2D

var player_speed: int = 140
var item_scene = preload("res://scenes/item.tscn")

# variables for mouse cursor
var is_handle_item: bool
var handle_obj: RigidBody2D
var item = null
var count_item: int = 0

func _physics_process(delta):
	look_at(get_global_mouse_position())
	var dir = Input.get_vector( "left", "right", "up", "down" )
	velocity = (dir * player_speed)
	move_and_slide()
	if get_slide_collision_count() > 0:
		for i in range(get_slide_collision_count()):
			var col = get_slide_collision(i)
			var colider = col.get_collider()
			if colider is RigidBody2D:
				colider.linear_velocity = -col.get_normal() * 60

func _process(delta):
	path_to_inventory.global_rotation = 0
	path_to_inventory.global_position = global_position + cam.offset
	path_to_inventory.scale = Vector2(1, 1) / cam.zoom
	if Input.is_action_pressed("tz_click") and handle_obj != null:
		$line.points[1] = to_local(handle_obj.global_position)
	else :
		$line.points[1] = Vector2(0, 0)

func item_to_machine(object, method):
	if object.have_item:
		return
	object.have_item = true
	if method == "_melt":
		object.item = handle_obj.res.result_of_melt
	elif method == "_press":
		if object.mode == 0:
			object.item = handle_obj.res.result_press_plate
			print("plate")
		elif object.mode == 1:
			object.item = handle_obj.res.result_press_wire
			print("wire")
		
	object.call(method)
	if count_item == 1:
		handle_obj.queue_free()
	else:
		handle_obj.count -= 1
		handle_obj.init_count()

func _input(event):
	if event.is_action_pressed("tz_inventory"):
		path_to_inventory.visible = !path_to_inventory.visible
		path_to_inventory.ch_inventory_state()
		get_tree().current_scene.is_inventory_open = path_to_inventory.visible
	
	if event.is_action_released("tz_click"):
		if not is_handle_item:
			return
		
		if not handle_obj:
			return
		
		for i in get_tree().current_scene.cursor_collider:
			var groups = i.get_groups()
			if ("furnace" in groups) and (handle_obj.res.can_melt):
				item_to_machine(i.get_parent(), "_melt")
				break
			if ("press" in groups) and (handle_obj.res.can_press_wire or handle_obj.res.can_press_plate):
				item_to_machine(i.get_parent(), "_press")
				break
			if ("cell" in groups):
				if i.add_item(item, count_item) == 0:
					handle_obj.queue_free()
			is_handle_item = false
		
		if not handle_obj:
			return
		
		handle_obj._release()
		handle_obj = null
	
	elif event.is_action_pressed("tz_click"):
		for i in get_tree().current_scene.cursor_collider:
			if ("cell" in i.get_groups()):
				i.remove_item(true)

# Ебануться функция
func take_dammage():
	pass
#	print("taken")
