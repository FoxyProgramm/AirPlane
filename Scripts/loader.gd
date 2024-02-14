extends StaticBody2D

var machines = ["furnace", "press"]
var machine = ""
var machine_obj = null
var can_push_item = false
var method = ""

func init_machine():
	if $ray.is_colliding():
		var collider = $ray.get_collider()
		if collider.name in machines:
			machine = collider.name
			machine_obj = collider.get_parent()

func init_item():
	can_push_item = false
	if machine == "furnace" and $cell.item.can_melt:
		can_push_item = true
		method = "_melt"
	elif machine == "press" and ($cell.item.can_press_plate or $cell.item.can_press_wire):
		can_push_item = true
		method = "_press"
		
func start():
	$ray.enabled = true
	init_machine()
	init_item()
	if can_push_item and !machine_obj.have_item:
		machine_obj.have_item = true
		machine_obj.item = $cell.item.result_of_melt
		machine_obj.call(method)
		$cell.item_count -= 1
		$cell.init_res()
		if $cell.item_count <= 0:
			$cell.item = null
			$ray.enabled = false
			$cell.init_res()
	await get_tree().create_timer(0.5).timeout
	if $cell.item_count > 0:
		start()

func _ready():
	$cell.connect("new_item", start)
	pass

func ch_loader():
	$cell.visible = !$cell.visible
	$cell.monitorable = !$cell.monitorable
