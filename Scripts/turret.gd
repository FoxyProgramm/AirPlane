extends CharacterBody2D

var fire_rate = 0.4
var bullet_speed = 700
var can_fire = true
var punch = preload("res://scenes/bullet.tscn")

func _process(delta):
	
	$gun_run2.look_at(get_global_mouse_position())
	
#	if Input.is_action_just_pressed("active") and can_fire:
#		var bullet_instance = punch.instantiate()
#		bullet_instance.position = $gun_run2/gun_run/bull_out.get_global_position()
#		bullet_instance.rotation = $gun_run2.rotation
#		#bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
#		get_tree().get_root().add_child(bullet_instance)
#		$gun_run2/gun_run.position.x -= 12
#		can_fire = false
#		await get_tree().create_timer(0.8).timeout
#		can_fire = true
#	else:
#		$gun_run2/gun_run.position.x = move_toward($gun_run2/gun_run.position.x, 0, 0.38)

#func _shot(delta):
	#var bullet = punch.instance
	
	
