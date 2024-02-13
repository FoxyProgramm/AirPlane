extends Node

var item_path = "res://Textures/Items/"
var item = load("res://scenes/item.tscn")

func _ready():
	for i in range(5):
		cursors.append(load(cursor_path + str(i+1) + ".png" ))
	DisplayServer.cursor_set_custom_image(cursors[randi()%5], DisplayServer.CURSOR_ARROW, Vector2(16, 16))

var cursor_path = "res://cursors/white/"

var cursors = [
	
]

var blocks = [
	["furnace"]
]

var tipa_items = [
]

var items = [
	# image                                 name            description   Это блять что? Категория или кого блять это вообще?
	[load(item_path + "copper.png"),       "Copper",       "description", ["melt", 2] ],
	[load(item_path + "crystal.png"),      "Crystal",      "description", ["fuel", 1] ],
	[load(item_path + "melt_copper.png"),  "Copper_ingot", "sdf",         ["press", 3, 4] ],
	[load(item_path + "copper_plate.png"), "Copper_plate", "if",          ["material"]],
	[load(item_path + "copper_wire.png"),  "Copper_wire",  "sifjd",       ["material"]]
]

func _create_item(id, count, pos, need_this_child:bool = false):
	var new_item = item.instantiate()
	new_item.id = id
	new_item.count = count
	new_item.position = pos
	get_tree().current_scene.get_node("items").add_child(new_item)
	if need_this_child:
		return new_item
