class_name JItem
extends Resource

#@export var id = -1
@export var name = ""
@export var texture = Texture2D
@export var description = ""
@export var can_merge = false
@export var merge_with : Resource
@export var merge_result : Resource
@export var is_fuel = false
@export var fuel_value:float = 0
@export var can_melt = false
@export var result_of_melt :Resource
@export var can_press_plate = false
@export var result_press_plate : Resource
@export var can_press_wire = false
@export var result_press_wire : Resource
