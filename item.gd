extends RigidBody2D

@onready var cam = get_viewport().get_camera_2d()
@onready var player = get_tree().current_scene.get_node("player")

@export var id = 0
@export var count = 1

var world_id = 0
var can_move = false
var need_pos # Что за n_pos? Хоть бы переменные называли так, чтобы было понятно

func _ready():
	$Icon.texture = Items.items[id][0]
	_init_count()

func _process(delta):
#	$handle_cound.global_position = global_position P.s. Ostavlu poka
	$handle_cound.global_rotation = 0

func _physics_process(delta):
	if can_move:
		need_pos = get_global_mouse_position() - global_position
		linear_velocity = need_pos * 7
		call_deferred("set", "scale", Vector2(1, 1) / cam.zoom)
	$touch.position = Vector2(0, 0)
	var bodies = get_colliding_bodies()
	# Это пиздец, избавиться от вложенности ОБЯЗАТЕЛЬНО
	if bodies.size() > 0:
		for body in bodies:
			if "item" in body.get_groups() and body.id == id and get_index() > body.get_index():
				count += body.count
				body.queue_free()
				_init_count()

func _init_count():
	if count == 1:
		$handle_cound/count.text = ""
	else:
		$handle_cound/count.text = str(count)

func _press(is_required: bool = false):
	if get_tree().current_scene.is_inventory_open:
		if not is_required:
			if get_tree().current_scene.in_inventory != 0:
				return
	
	z_index = 11 # globals.ITEM_Z_INDEX
	player.is_handle_item = true
	player.handle_obj = $"."
	player.id_item = id
	player.count_item = count
	$col.call_deferred("set", "disabled", true) # call deferred - huynya
	can_move = true

func _release():
	z_index = 0 # globals.ITEM_RELASE_Z_INDEX
	can_move = false
	$col.call_deferred("set", "disabled", false) # call deferred - huynya
	call_deferred("set", "scale", Vector2(1, 1))
