extends Node2D

var currently_used_item
# Called when the node enters the scene tree for the first time.
func _ready():
	#Connect Signals
	SignalBus.connect("usability_trigger",on_usability_trigger)
	SignalBus.connect("enter",on_enter_room)
	SignalBus.connect("item_chosen",on_choose_item)
	
	# Detect which room is currently visible and store it
	SignalBus.connect("inspect_show",on_inspect_show)

	
	#$BlackBackground.show()
	#SignalBus.emit_signal("display_conversation", Cutscenes.intro, Cutscenes.introspeaker, "introcutscene")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#This is to trigger cutscenes/change item resoureces
	check_story_flags()
	
func _input(event):
	if event.is_action_pressed("save_game"):
		SaveManager.save_game()
	elif event.is_action_pressed("load_game"):
		SaveManager.apply_save_data()
	for child in get_children():
		if child is Node2D and child.visible:
			match child.name:
				"Manor":
					on_enter_room("manor")
				"Manor_Prehist":
					on_enter_room("prehistoric")
				"Manor_Saloon":
					on_enter_room("saloon")
				"Manor_Casino":
					on_enter_room("casino")
			break

#Triggers when "Use" is selected from Clickable Options
#It turns off some click functionality so the game doesn't get confused
func on_usability_trigger(key):
	Global.using_item = true
	var targetkey = key.key
	#Stall until item is selected
	await SignalBus.item_chosen
	if currently_used_item == targetkey:
		cause_change(targetkey)
		$Inventory_UI.remove_item(targetkey)
		$Inventory_UI.check_inventory()
		#spend the item and change something
	else: 
		cause_change("nothing")
	Global.using_item = false

#Function for changing all of the things in the game
#Triggers off of usability trigger
func cause_change(key):
	if key == "left_door_key":
		pass
	if key == "saloon_key":
		$"Manor/Middle Door".switch_resource(load("res://Resources/saloon_unlocked_enterable.tres"))
		$"Manor/Middle Door".switch_resource(load("res://Resources/saloon_unlocked_inspectable.tres"))
		$"Manor/Middle Door".switch_resource(load("res://Resources/usable.tres"))
		SignalBus.emit_signal("display_dialogue", Cutscenes.unlock_saloon_door)
	if key == "casino_key":
		$"Manor/Right Door".switch_resource(load("res://Resources/casino_unlocked_enterable.tres"))
		$"Manor/Right Door".switch_resource(load("res://Resources/casino_unlocked_inspectable.tres"))
		$"Manor/Right Door".switch_resource(load("res://Resources/usable.tres"))
		SignalBus.emit_signal("display_dialogue", Cutscenes.unlock_casino_door)	
	if key == "bone":
		SignalBus.emit_signal("display_dialogue", Cutscenes.give_dog_bone)
		$"Manor_Prehist/Cave Key Default".hide()
		$"Manor_Prehist/Grug Default".hide()
		$"Manor_Prehist/Cave Key Takeable".show()
		$"Manor_Prehist/Grug Happy".show()
		$Manor_Prehist/Dog.hide()
		$Manor_Prehist/DogNoUse.show()
		
		StoryFlags.bone_used = true
		SaveManager.save_game()  # Save after flag change
		
	if key == "markbad":
		$Manor/Alcohol.switch_resource(load("res://Resources/alcoholbad.tres"))
		SignalBus.emit_signal("display_conversation", Cutscenes.markhaterarc,Cutscenes.markhaterarcspeaker)
	if key == "markgood":
		SignalBus.emit_signal("display_conversation", Cutscenes.markgivekey, Cutscenes.markgivekeyspeaker, Cutscenes.markgivekeykey)
		$Manor_Saloon/Mark.switch_resource(load("res://Resources/marktalkpostsafeunlock.tres"))
	if key == "nothing":
		SignalBus.emit_signal("display_dialogue", Cutscenes.nothing)
	if key == "record":
		SignalBus.emit_signal("display_conversation", Cutscenes.jukebox, Cutscenes.jukeboxspeaker, Cutscenes.jukeboxkey)
		$"Manor_Casino/Dealer Standing".show()
		$Manor_Casino/Dealer.hide()
		$Manor_Casino/Curly.switch_resource(load("res://Resources/curlypostjukebox.tres"))

#Function for changing between all of the rooms in the game
#Hardcoded because it's a small game haha
func on_enter_room(destination):
	#$BlackBackground.fade_transition()
	#await get_tree().create_timer(1)
	if destination == "prehistoric":
		$Manor.hide()
		$Manor_Saloon.hide()
		$Manor_Prehist.show()
		$Manor_Casino.hide()
		Global.current_room = "prehistoric"
		AudioPlayer.fade_out_music(AudioPlayer.get_node("DefaultMusic"))
		AudioPlayer.fade_in_music(AudioPlayer.get_node("CaveMusic"))
	if destination == "manor":
		$Manor.show()
		$Manor_Saloon.hide()
		$Manor_Prehist.hide()
		$Manor_Casino.hide()
		if Global.current_room == "prehistoric":
			AudioPlayer.fade_out_music(AudioPlayer.get_node("CaveMusic"))
		if Global.current_room == "saloon":
			AudioPlayer.fade_out_music(AudioPlayer.get_node("SaloonMusic"))
		Global.current_room = "manor"
		AudioPlayer.fade_in_music(AudioPlayer.get_node("DefaultMusic"))
	if destination == "saloon":
		$Manor.hide()
		$Manor_Prehist.hide()
		$Manor_Saloon.show()
		$Manor_Casino.hide()
		Global.current_room = "saloon"
		AudioPlayer.fade_out_music(AudioPlayer.get_node("DefaultMusic"))
		AudioPlayer.fade_in_music(AudioPlayer.get_node("SaloonMusic"))
	if destination == "casino":
		$Manor.hide()
		$Manor_Prehist.hide()
		$Manor_Saloon.hide()
		$Manor_Casino.show()
		Global.current_room = "casino"


func on_choose_item(itemkey):
	currently_used_item = itemkey

func on_inspect_show(show_key):
	if show_key == "safe":
		Global.in_menu = true
		await get_tree().create_timer(1.3).timeout 
		$Manor_Saloon/Keypad.show()
	if show_key == "dartsinstruction":
		Global.in_menu = true
		await get_tree().create_timer(1.3).timeout 
		$Manor_Saloon/DartsInstructions.show()
		
#Function to trigger cutscenes/change item resoureces
func check_story_flags():
	if StoryFlags.has_listened_to_walkie == true:
		$"Manor_Prehist/Grug Happy".switch_resource(load("res://Resources/grugidentity.tres"))
	if StoryFlags.has_checked_safe == true:
		$Manor_Saloon/Mark.switch_resource(load("res://Resources/markhascheckedsafe.tres"))
	if StoryFlags.has_won_gambling == true and Global.current_room == "manor":
		StoryFlags.has_won_gambling = false
		SignalBus.emit_signal("display_conversation", Cutscenes.playtest, Cutscenes.playtestspeaker)
