extends Camera2D

var first_grab_pos: Vector2
var first_grab = true

func _process(delta):
	offset = (get_global_mouse_position() - global_position) * 0.2

func _input(event):
	if event.is_action_pressed("tz_zoom_in"):
		zoom.x = clamp(zoom.x * 0.8, 0.1, 4.0)
		zoom.y = clamp(zoom.y * 0.8, 0.1, 4.0)
	elif event.is_action_pressed("tz_zoom_out"):
		zoom.x = clamp(zoom.x * 1.2, 0.1, 4.0)
		zoom.y = clamp(zoom.y * 1.2, 0.1, 4.0)
