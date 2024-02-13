extends CharacterBody2D

signal pick_up(id)

@onready var cursor = get_tree().current_scene.get_node("cursor")
@onready var path_inven = $inventory
@onready var cam = $Camera2D


var player_speed: int = 140

# Такое количество переменных об инвентаре говорит о том, что нужно сделать для инвентаря отдельный класс
var item_scene = preload("res://scenes/item.tscn")
var is_handle_item: bool
var handle_obj: RigidBody2D
var id_item: int = 0
var count_item: int = 0
var inventory_ids: Array[int] = [-1, -1, -1, -1, -1, -1, -1, -1]
var inventory_counts: Array[int] = [0, 0, 0, 0, 0, 0, 0, 0]

# Бля, мне тут даже комментировать нечего

# TODO: избавиться от вложенности по максимуму 

func _ready():
	id_item = 0
	_init_inventory() # Нахуя это здесь? -- что-бы инвентарб был, ну типа
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
	path_inven.global_rotation = 0
	path_inven.global_position = global_position + cam.offset
	path_inven.scale = Vector2(1, 1) / cam.zoom
	if Input.is_action_pressed("tz_click") and handle_obj != null:
		$line.points[1] = to_local(handle_obj.global_position)
	else :
		$line.points[1] = Vector2(0, 0)

# Что такое s? items to ass? сделать нормально 
func _item_to_machine(object, method):
	if object.have_item:
		return
	
	object.have_item = true
	object.item_id = id_item
	object.call(method)
	if count_item == 1:
		handle_obj.queue_free()
	else:
		handle_obj.count -= 1
		handle_obj._init_count()

func _input(event):
	if event.is_action_pressed("tz_inventory"):
		path_inven.visible = !path_inven.visible
		get_tree().current_scene.is_inventory_open = path_inven.visible
		
	if event.is_action_released("tz_click"):
		if is_handle_item:
			for i in get_tree().current_scene.cursor_collider:
				var groups = i.get_groups()
				if ("inventory" in groups) and path_inven.visible:
					_pick_up(id_item, count_item, int(String(i.get_parent().name)))
					break
				if ("furnace" in groups) and Items.items[id_item][3][0] == "melt":
					_item_to_machine(i.get_parent(), "_melt")
					break
				if ("press" in groups) and Items.items[id_item][3][0] == "press":
					_item_to_machine(i.get_parent(), "_press")
					break
			is_handle_item = false
		if handle_obj != null:
			handle_obj._release()
			handle_obj = null
		
	elif event.is_action_pressed("tz_click"):
		for i in get_tree().current_scene.cursor_collider:
			if ("inventory" in i.get_groups()) and path_inven.visible:
				if Input.is_action_pressed("tz_shift"):
					_fuck_item(int(String(i.get_parent().name)), true)
				else :
					_fuck_item(int(String(i.get_parent().name)))
				break

func _create_item(id, count, pos, connect_to_pointer: bool = true):
	var inst_item = item_scene.instantiate()
	inst_item.id = id
	inst_item.position = pos
	inst_item.count = count
	get_tree().current_scene.get_node("items").add_child(inst_item)
	if connect_to_pointer:
		inst_item._press(true)
#		is_handle_item = true
#		handle_obj = inst_item
#		id_item = id

# Трахнуть предмет, серёзно?
func _fuck_item(cell, all:bool = false):
	if inventory_ids[cell] != -1:
		if !all:
			_create_item(inventory_ids[cell], 1, get_global_mouse_position())
			inventory_counts[cell] -= 1
			if inventory_counts[cell] == 0:
				inventory_ids[cell] = -1
		else:
			_create_item(inventory_ids[cell], inventory_counts[cell], get_global_mouse_position())
			inventory_ids[cell] = -1
			inventory_counts[cell] = 0
	_init_inventory()

# Ебануться функция
func take_dammage():
	print("taken")

func _init_inventory():
	for i in range(inventory_ids.size()):
		if inventory_ids[i] != -1:
			var cell = path_inven.get_node(str(i))
			cell.texture = Items.items[inventory_ids[i]][0]
			cell.get_node("count").text = str(inventory_counts[i])
		else :
			path_inven.get_node(str(i) + "/count").text = ""
			path_inven.get_node(str(i)).texture = null

func _pick_up(id, count, cell = -1):
	if cell == -1:
		if id in inventory_ids:
			var place = inventory_ids.find(id, 0)
			inventory_counts[place] += count
		else :
			if inventory_ids.size() < 8:
				inventory_ids.append(id)
				inventory_counts.append(count)
	else :
		if (inventory_ids[cell] == id) or (inventory_ids[cell] == -1):
			inventory_ids[cell] = id
			inventory_counts[cell] += count
			handle_obj.queue_free()
	_init_inventory()
