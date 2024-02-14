extends StaticBody2D

var energy: float = 0.0
var max_energy = 8.0
var is_generating = false

func start():
	if is_generating:
		return
	is_generating = true
	if $cell.item:
		if $cell.item.is_fuel:
			add_energy($cell.item.fuel_value)
			$cell.get_item(1)
			$image.rotation = 0
			await get_tree().create_tween().tween_property($image, "rotation", 12*PI, 2).finished
		else :
			is_generating = false
			return
	else :
		is_generating = false
		return
	is_generating = false
	start()

func add_energy(value):
	energy += value
	$energy.value = energy

func _ready():
	$cell.connect("new_item", start)

func ch_state():
	$cell.visible = !$cell.visible
	$cell.monitorable = !$cell.monitorable
