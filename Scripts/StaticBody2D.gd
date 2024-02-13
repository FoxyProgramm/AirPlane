extends StaticBody2D

# TODO: delete this naxuy

var item

var hit_points = 100



func destroy():
	queue_free()

func _physics_process(delta):
	var movement = RIGHT.rotated(rotation) * SPEED * delta
	global_position += movement 

