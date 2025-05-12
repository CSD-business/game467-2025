extends Control

@onready var icon = $InnerBorder/Itemicon
@onready var quantity_label = $InnerBorder/ItemQuantity
@onready var details_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ItemName
@onready var usage_panel = $UsagePanel

var item = null
var key = null

func set_item(new_item):
	item = new_item
	key = item.key
	$Sprite2D.texture = item.texture  # <- correctly uses the visible Itemicon node
	print("Item set in slot:", key)

func remove_item():
	key = null
	item = null
	item_name = null
	$Sprite2D.texture = null

func _on_check_button_pressed():
	$UsagePanel.hide()

func _on_use_button_pressed():
	$UsagePanel.hide()

#Check for use cases of items in situations
func _on_item_button_pressed():
	if item != null and Global.reading_in_progress == false:
		if item.key == "walkie" and Global.current_room == "manor" and !Global.using_item:
			SignalBus.emit_signal("display_conversation", Cutscenes.manorwalkie, Cutscenes.manorwalkiespeaker)
			StoryFlags.has_listened_to_walkie = true
			return
		elif Global.using_item == true:
			SignalBus.emit_signal("item_chosen",key)
		elif item != null: 
			SignalBus.emit_signal("display_dialogue", item.inspect_text)
	elif item == null and Global.using_item == true:
		SignalBus.emit_signal("item_chosen",null)
	
		#if $UsagePanel.visible == false and item != null:
		#	$UsagePanel.show()
		#elif $UsagePanel.visible == true:
		#	$UsagePanel.hide()
