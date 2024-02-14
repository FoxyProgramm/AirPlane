extends Node2D

@export var inventory_cells:Array[NodePath] = []

func update_cell(cell):
	pass
	
func ch_inventory_state():
	for cell in inventory_cells:
		get_node(cell).monitorable = visible


#func _ready():
#	for cell in range(inventory_cells.size()):
#		get_node(inventory_cells[cell]).connect("new_item", update_cell, cell)
