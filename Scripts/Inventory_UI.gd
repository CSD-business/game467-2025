extends Control

@onready var grid_container = $GridContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	if Global.added_item != null:
		update_inventory()

# Update inventory UI
func update_inventory():
	for slot in $GridContainer.get_children():
		if slot.item == null:
			slot.set_item(Global.added_item)
			Global.added_item = null
			break
	check_inventory()
	

func _on_inventory_pressed():
	if visible == false: 
		show() 
	elif visible == true: hide()

func check_inventory():
	Global.inventory_keys = []
	for slot in $GridContainer.get_children():
		Global.inventory_keys.append(slot.key)
	print(Global.inventory_keys)

func remove_item(itemkey):
	for slot in $GridContainer.get_children():
		if slot.item.key == itemkey:
			slot.remove_item()
			break
