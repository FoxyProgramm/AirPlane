extends Node

var cursor_path = "res://cursors/white/"
var cursors = []
var tipa_items = []
var item_path = "res://Textures/Items/"
var item = load("res://scenes/item.tscn")

func _ready():
	for i in range(5):
		cursors.append(load(cursor_path + str(i+1) + ".png" ))
	DisplayServer.cursor_set_custom_image(cursors[randi()%5], DisplayServer.CURSOR_ARROW, Vector2(16, 16))


var blocks = {
	"furnace": [ [0], [2] ],
	"press_plate": [ [2], [3] ],
	"press_wire": [ [2], [4] ]
}


var items = [
	# image                                 name               description  
	[load(item_path + "copper.png"),       "Copper",          "description"],
	[load(item_path + "crystal.png"),      "Crystal",         "description"],
	[load(item_path + "melt_copper.png"),  "Copper_ingot",    "sdf",       ],
	[load(item_path + "copper_plate.png"), "Copper_plate",    "if",        ],
	[load(item_path + "copper_wire.png"),  "Copper_wire",     "sifjd",     ]
]

func _create_item(res, count, pos, need_this_child:bool = false):
	var new_item = item.instantiate()
	new_item._resourse = res
	new_item.count = count
	new_item.position = pos
	get_tree().current_scene.get_node("items").add_child(new_item)
	if need_this_child:
		return new_item
