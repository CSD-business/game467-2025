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
	for i in range(grid_container.get_child_count()):
		var slot = grid_container.get_child(i)
		if slot.item == null:
			slot.set_item(Global.added_item)

			# Save the added item to Global.inventory_data with slot index
			Global.inventory_data.append({
				"key": Global.added_item.key,
				"slot": i
			})

			Global.added_item = null
			break
	check_inventory()

	
#redundant?
func _on_inventory_pressed():
	if visible == false: 
		show() 
	elif visible == true: hide()

#Check inventory and return their keys
func check_inventory():
	Global.inventory_keys = []
	for slot in $GridContainer.get_children():
		Global.inventory_keys.append(slot.key)

#Remove a given item if it has been used 
#EX: if its key matched something
func remove_item(itemkey):
	for slot in $GridContainer.get_children():
		if !null: 
			if slot.item.key == itemkey:
				slot.remove_item()
				break
