extends StaticBody2D

var machines = ["furnace", "press"]
var item_id = 0
var item_count = 0
var machine = ""
var machine_obj = null

func init_machine():
	if $ray.is_colliding():
		var collider = $ray.get_collider()
		if collider.name in machines:
			machine = collider.name
			machine_obj = collider
			
			
func start():
	await get_tree().create_timer(0.5).timeout
	if item_count > 0:
		start()

func _ready():
	init_machine()

func ch_loader():
	$handler.visible = !$handler.visible
	$handler/loader.monitoring = !$handler/loader.monitoring
