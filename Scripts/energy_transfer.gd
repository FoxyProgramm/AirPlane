extends StaticBody2D

@export var energy_from:Node
@export var energy_to:Array[NodePath]
var energy_for_tick = 0.01
var radius = 10

func _ready():
	if !energy_from and energy_to.size() > 0:
		set_physics_process(false)
	else :
		var temp = []
		var temp_2 = 0
		for i in range(2 + (energy_to.size() * 2)):
			temp.append(Vector2())
		$Line2D.set_points( PackedVector2Array( temp ) )
		$Line2D.points[0] = (to_local(energy_from.global_position))
		$Line2D.points[1] = Vector2(0, 0)
		for i in range(2, temp.size(),2):
			$Line2D.points[i] = (to_local(get_node(energy_to[temp_2]).global_position))
			$Line2D.points[i+1] = (Vector2(0, 0))
			temp_2 += 1

func _physics_process(delta):
	if (energy_from.energy > 0):
		for to in energy_to:
			if not (get_node(to).energy >= get_node(to).max_energy):
				energy_from.add_energy(-energy_for_tick)
				get_node(to).add_energy(energy_for_tick)
