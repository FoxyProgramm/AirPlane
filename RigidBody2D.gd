extends item

# TODO: delete this nahuy

var item = ""

var hit_points = 100


func set_item(item_name):
	$sprite.texture = load("res://sprites/items/%s.png % item_name")
	item = item_name

func destroy():
	queue_free()

func _physics_process(delta):



