extends CharacterBody2D

signal pick_up(id)

@onready var cursor = get_tree().current_scene.get_node("cursor")
@onready var path_to_inventory = $inventory
@onready var cam = $Camera2D

var player_speed: int = 140

# Такое количество переменных об инвентаре говорит о том, что нужно сделать для инвентаря отдельный класс
var item_scene = preload("res://scenes/item.tscn")

# variables for mouse cursor
var is_handle_item: bool
var handle_obj: RigidBody2D
var item = null
var count_item: int = 0

# inventory
var inventory_res: Array
var inventory_counts: Array[int]


func _ready():
	for i in range(8):
		inventory_res.append(null)
		inventory_counts.append(0)
	init_inventory()
	connect("pick_up", _pick_up)

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
		get_tree().current_scene.is_inventory_open = path_to_inventory.visible
	
	if event.is_action_released("tz_click"):
		if not is_handle_item:
			return
		
		if not handle_obj:
			return
		
		for i in get_tree().current_scene.cursor_collider:
			var groups = i.get_groups()
			if ("inventory" in groups) and path_to_inventory.visible:
				_pick_up(item, count_item, int(String(i.get_parent().name)))
				break
			if ("furnace" in groups) and (handle_obj.res.can_melt):
				item_to_machine(i.get_parent(), "_melt")
				break
			if ("press" in groups) and (handle_obj.res.can_press_wire or handle_obj.res.can_press_plane):
				item_to_machine(i.get_parent(), "_press")
				break
			if ("loader" in groups):
				var machine = i.get_node("../../")
				machine.init_machine()
				break
			
			is_handle_item = false
		
		if not handle_obj:
			return
		
		handle_obj._release()
		handle_obj = null
	
	elif event.is_action_pressed("tz_click"):
		for i in get_tree().current_scene.cursor_collider:
			if ("inventory" in i.get_groups()) and path_to_inventory.visible:
				if Input.is_action_pressed("tz_shift"):
					throw_item(int(String(i.get_parent().name)), 2)
				elif Input.is_action_pressed("tz_ctrl"):
					throw_item(int(String(i.get_parent().name)), 1)
				else:
					throw_item(int(String(i.get_parent().name)), 0)
				
				break

func create_item(res, count, pos, connect_to_pointer: bool = true):
	var inst_item = item_scene.instantiate()
	inst_item._resourse = res
	inst_item.position = pos
	inst_item.count = count
	get_tree().current_scene.get_node("items").add_child(inst_item)
	if connect_to_pointer:
		inst_item._press(true)

# 0 - one item, 1 - half of all items, 2 - all items
func throw_item(cell, method:int = 0):
	if inventory_res[cell] == null:
		return
	
	if inventory_res[cell].id != -1:
		return
	
	if method == 0:
		create_item(inventory_res[cell], 1, get_global_mouse_position())
		inventory_counts[cell] -= 1
		if inventory_counts[cell] == 0:
			inventory_res[cell] = null
	elif method == 1:
		var items_to_throw = ceil(inventory_counts[cell]/2.0)
		create_item(inventory_res[cell], items_to_throw, get_global_mouse_position())
		inventory_counts[cell] -= int(items_to_throw)
		if inventory_counts[cell] == 0:
			inventory_res[cell] = null
	elif method == 2:
		create_item(inventory_res[cell], inventory_counts[cell], get_global_mouse_position())
		inventory_res[cell] = null
		inventory_counts[cell] = 0
	init_inventory()

# Ебануться функция
func take_dammage():
	print("taken")

func init_inventory():
	for i in range(inventory_res.size()):
		if inventory_res[i] == null:
			path_to_inventory.get_node("Slot" + str(i) + "/count").text = ""
			path_to_inventory.get_node("Slot" + str(i) + "/Sprite2D").texture = null
			continue
		
		if inventory_res[i].id != -1:
			var cell = path_to_inventory.get_node("Slot" + str(i))
			var cell_sprite = cell.get_node("Sprite2D")
			cell_sprite.texture = inventory_res[i].texture
			cell.get_node("count").text = str(inventory_counts[i])

func _pick_up(id, count, cell = -1):
	if cell == -1:
		if id in inventory_res:
			var place = inventory_res.find(id, 0)
			inventory_counts[place] += count
		else :
			if inventory_res.size() < 8:
				inventory_res.append(id)
				inventory_counts.append(count)
	else :
		print("sdf")
		if (inventory_res[cell] == id) or (inventory_res[cell] == null):
			print("hi bash")
			inventory_res[cell] = id
			inventory_counts[cell] += count
			handle_obj.queue_free()
	init_inventory()
