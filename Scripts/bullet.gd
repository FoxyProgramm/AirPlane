extends Area2D

var RIGHT = Vector2.RIGHT
var SPEED: int = 200

func _physics_process(delta):
	var movement = RIGHT.rotated(rotation) * SPEED * delta
	global_position += movement


func destroy():
	queue_free()

func _on_body_entered(g_point):
	#обязательно писать именно как зарегистрированно
	if g_point.is_in_group("shipment_body"):
		destroy()
		g_point.take_dammage()


