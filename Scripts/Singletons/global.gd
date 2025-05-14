extends Node

# Inventory system
var inventory = []
@export var inventory_keys : Array = []
var inventory_data : Array = [] # Stores { "key": key, "slot": slot_index }

# Other gameplay variables
@export var Selected_Object : Node
@export var added_item : Takeable
@export var reading_in_progress : bool
@export var current_room : String
@export var using_item : bool
@export var in_menu : bool

# Puzzle codes
@export var year_code   : String
@export var name_code   : String
@export var symbol_code : String
@export var mark_resource_path : String = "res://Resources/markhascheckedsafe.tres"


func find_first_empty_inventory_slot() -> int:
	var inventory_ui = get_tree().get_root().get_node("Main/CanvasLayer/Inventory_UI")
	var grid = inventory_ui.get_node("GridContainer")
	for i in range(grid.get_child_count()):
		var slot = grid.get_child(i)
		if not slot.has_item(): # Assuming your slot script has a method like `has_item()`
			return i
	return -1 # No empty slots found
