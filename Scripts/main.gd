extends Node2D

var currently_used_item
# Called when the node enters the scene tree for the first time.
func _ready():
	#Connect Signals
	SignalBus.connect("usability_trigger",on_usability_trigger)
	SignalBus.connect("enter",on_enter_room)
	SignalBus.connect("item_chosen",on_choose_item)
	SignalBus.connect("hide", on_hide)
	# Detect which room is currently visible and store it
	SignalBus.connect("inspect_show",on_inspect_show)
	randomizecodes()
	#$BlackBackground.modulate = Color(1,1,1,1)
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
		update_visibility_from_flags()

#Triggers when "Use" is selected from Clickable Options
#It turns off some click functionality so the game doesn't get confused
func on_usability_trigger(key):
	Global.using_item = true
	var targetkey = key.key
	print(key.key)
	#Stall until item is selected
	await SignalBus.item_chosen
	if currently_used_item == targetkey:
		cause_change(targetkey)
		$Inventory_UI.remove_item(targetkey)
		$Inventory_UI.check_inventory()
		#spend the item and change something
	elif targetkey == "coin" and currently_used_item == "record":
		cause_change("recordfail")
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

		StoryFlags.saloon_unlocked = true
		StoryFlags.saloon_key_used = true  # ✅ ADDED
		Global.inventory_keys.erase("saloon_key")  # ✅ ADDED
		SignalBus.emit_signal("hide", "Manor_Prehist/Cave Key Takeable")  # ✅ Optional: Hide physical node if it's still there

		SaveManager.save_game()

		
	if key == "casino_key":
		$"Manor/Right Door".switch_resource(load("res://Resources/casino_unlocked_enterable.tres"))
		$"Manor/Right Door".switch_resource(load("res://Resources/casino_unlocked_inspectable.tres"))
		$"Manor/Right Door".switch_resource(load("res://Resources/usable.tres"))
		SignalBus.emit_signal("display_dialogue", Cutscenes.unlock_casino_door)

		StoryFlags.casino_unlocked = true
		StoryFlags.casino_key_used = true  # ✅ ADDED
		Global.inventory_keys.erase("casino_key")  # ✅ ADDED
		SignalBus.emit_signal("hide", "Manor_Saloon/Saloon Key")  # ✅ Optional: Hide physical node if it's still there

		SaveManager.save_game()
	
	if key == "bone":
		SignalBus.emit_signal("display_dialogue", Cutscenes.give_dog_bone)
		$"Manor_Prehist/Cave Key Default".hide()
		$"Manor_Prehist/Grug Default".hide()

	# ✅ Only show the takeable key if it hasn't been taken yet
		if not Global.inventory_keys.has("saloon_key"):
			$"Manor_Prehist/Cave Key Takeable".show()

		$"Manor_Prehist/Grug Happy".show()
		$Manor_Prehist/Dog.hide()
		$Manor_Prehist/DogNoUse.show()

		StoryFlags.bone_used = true
		SaveManager.save_game()
		
	if key == "markbad":
		$Manor/Alcohol.switch_resource(load("res://Resources/alcoholbad.tres"))
		SignalBus.emit_signal("display_conversation", Cutscenes.markhaterarc, Cutscenes.markhaterarcspeaker)
		StoryFlags.stout_used = true
		if $Manor_Saloon.has_node("Stout Bottle"):
			$Manor_Saloon/"Stout Bottle".hide()
		SaveManager.save_game()
	if key == "markgood":
		SignalBus.emit_signal("display_conversation", Cutscenes.markgivekey, Cutscenes.markgivekeyspeaker, Cutscenes.markgivekeykey)
		$Manor_Saloon/Mark.switch_resource(load("res://Resources/marktalkpostsafeunlock.tres"))
		$Manor_Saloon/Mark.switch_resource(load("res://Resources/usable.tres"))
		StoryFlags.tall_used = true
		if $Manor_Saloon.has_node("Tall Bottle"):
			$Manor_Saloon/"Tall Bottle".hide()
		SaveManager.save_game()
	
	if key == "nothing":
		SignalBus.emit_signal("display_dialogue", Cutscenes.nothing)
	if key == "record":
		SignalBus.emit_signal("display_conversation", Cutscenes.jukebox, Cutscenes.jukeboxspeaker, Cutscenes.jukeboxkey)
		$"Manor_Casino/Dealer Standing".show()
		$Manor_Casino/Dealer.hide()
		$Manor_Casino/Curly.switch_resource(load("res://Resources/curlypostjukebox.tres"))
	if key == "recordfail":
		SignalBus.emit_signal("display_conversation", Cutscenes.recordfail, Cutscenes.recordfailspeaker)
		
	
	
	if key == "coin":
		print("coin taken")
		SignalBus.emit_signal("display_dialogue", "The coin fits in the slot, and whirrs gently. I should be able to use the record now.")
		$Manor_Casino/Jukebox.switch_resource(load("res://Resources/jukeboxready.tres"))
		$Manor_Casino/Jukebox.switch_resource(load("res://Resources/jukeboxreadyuse.tres"))
		StoryFlags.coin_taken = true
		Global.inventory_keys.erase("coin")
		SignalBus.emit_signal("hide", "$Manor_Casino/Coin")  # ✅ Optional: Hide physical node if it's still there
		SaveManager.save_game()
	if key == "main_key":
		SignalBus.emit_signal("display_dialogue", "You and Curly both put your keys in, and a panel opens. Better get a closer look, this looks tough...")
		$"Manor/Main Doors".switch_resource(load("res://Resources/main_door_haspanel.tres"))
		$"Manor/Main Doors".switch_resource(load("res://Resources/usable.tres"))
		StoryFlags.final_room_open = true
		StoryFlags.main_key_used = true
		Global.inventory_keys.erase("main_key")
		SaveManager.save_game()


	if key == "ladder":
		SignalBus.emit_signal("display_dialogue", "We should be able to go down safely now.")
		$Manor/Trapdoor.switch_resource(load("res://Resources/trapdoorenterable.tres"))
		$Manor/Trapdoor.switch_resource(load("res://Resources/usable.tres"))
#Function for changing between all of the rooms in the game
#Hardcoded because it's a small game haha
func on_enter_room(destination):
	#$BlackBackground.fade_transition()
	#await get_tree().create_timer(1)
	$BlackBackground/AnimationPlayer.play("Fade2Black")
	await get_tree().create_timer(1).timeout
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
	if destination == "powercore":
		$Manor.hide()
		$Manor_Powercore.show()
		Global.current_room = "powercore"
		await get_tree().create_timer(1).timeout
		SignalBus.emit_signal("display_conversation", Cutscenes.endcutscenepart1, Cutscenes.endcutscenepart1speaker, "endcutscenepart1key")
	await get_tree().create_timer(0.5).timeout
	$BlackBackground/AnimationPlayer.play("Fade2Clear")


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
	if show_key == "main_doors":
		Global.in_menu = true
		await get_tree().create_timer(1.3).timeout 
		$Manor/FinalKeypad.show()
	if show_key == "rug":
		print("lala")
		$Manor/Rug.hide()
		$Manor/Trapdoor.show()
		
#Function to trigger cutscenes/change item resoureces
func check_story_flags():
	if StoryFlags.has_listened_to_walkie == true:
		$"Manor_Prehist/Grug Happy".switch_resource(load("res://Resources/grugidentity.tres"))
	if StoryFlags.has_checked_safe == true:
		$Manor_Saloon/Mark.switch_resource(load("res://Resources/markhascheckedsafe.tres"))
	if StoryFlags.has_won_gambling == true and Global.current_room == "manor":
		StoryFlags.has_won_gambling = false
		SignalBus.emit_signal("display_conversation", Cutscenes.curlythankyou, Cutscenes.curlythankyouspeaker, "curlythankyou")

func update_visibility_from_flags():
	if StoryFlags.bone_used:
		if $Manor_Prehist.has_node("Dog"):
			$Manor_Prehist/Dog.hide()
		if $Manor_Prehist.has_node("DogNoUse"):
			$Manor_Prehist/DogNoUse.show()
		if $Manor_Prehist.has_node("Cave Key Default"):
			$Manor_Prehist/"Cave Key Default".hide()
		if $Manor_Prehist.has_node("Grug Default"):
			$Manor_Prehist/"Grug Default".hide()
		if $Manor_Prehist.has_node("Cave Key Takeable") and not Global.inventory_keys.has("saloon_key"):
			$Manor_Prehist/"Cave Key Takeable".show()

		if $Manor_Prehist.has_node("Grug Happy"):
			$Manor_Prehist/"Grug Happy".show()
	if StoryFlags.has_checked_safe:
		if $Manor_Saloon.has_node("Mark"):
			print("func")
			$Manor_Saloon/Mark.switch_resource(load("res://Resources/markhascheckedsafe.tres"))
	if StoryFlags.has_listened_to_walkie:
		if $Manor_Prehist.has_node("Grug Happy"):
			$"Manor_Prehist/Grug Happy".switch_resource(load("res://Resources/grugidentity.tres"))
	if StoryFlags.saloon_unlocked:
		if $Manor.has_node("Middle Door"):
			$"Manor/Middle Door".switch_resource(load("res://Resources/saloon_unlocked_enterable.tres"))
			$"Manor/Middle Door".switch_resource(load("res://Resources/saloon_unlocked_inspectable.tres"))
			$"Manor/Middle Door".switch_resource(load("res://Resources/usable.tres"))
		if $Manor_Prehist.has_node("Cave Key Takeable"):
			$Manor_Prehist/"Cave Key Takeable".hide()
	if StoryFlags.stout_used:
		if $Manor_Saloon.has_node("Stout Bottle"):
			$Manor_Saloon/"Stout Bottle".hide()
	if StoryFlags.tall_used:
		if $Manor_Saloon.has_node("Tall Bottle"):
			$Manor_Saloon/"Tall Bottle".hide()
	if StoryFlags.casino_unlocked:
		if $Manor.has_node("Right Door"):
			$"Manor/Right Door".switch_resource(load("res://Resources/casino_unlocked_enterable.tres"))
			$"Manor/Right Door".switch_resource(load("res://Resources/casino_unlocked_inspectable.tres"))
			$"Manor/Right Door".switch_resource(load("res://Resources/usable.tres"))
		if $Manor_Saloon.has_node("Saloon Key"):
			$Manor_Saloon/"Saloon Key".hide()
	if StoryFlags.record_used:
		if $Manor_Casino.has_node("Record"):
			$Manor_Casino/Record.hide()

# Show Bone if not in inventory and not used
	if not StoryFlags.bone_used and not Global.inventory_keys.has("bone"):
		if $Manor_Prehist.has_node("Bone"):
			$Manor_Prehist/Bone.show()
	else:
		if $Manor_Prehist.has_node("Bone"):
			$Manor_Prehist/Bone.hide()


func on_hide(node_path: String):
	var node = get_node_or_null(node_path)
	if node:
		if node is CanvasItem:
			node.visible = false
		else:
			print("Node is not a visual element, skipping:", node_path)
	else:
		print("Warning: Node not found to hide:", node_path)

func randomizecodes():
	Global.year_code = Years[randi_range(0,14)]
	Global.name_code = Names[randi_range(0,14)]
	Global.symbol_code = Symbols[randi_range(0,3)]
	print("Solution is " + Global.year_code + " " + Global.name_code + " " + Global.symbol_code )
	

#code indexes
var Years = [
	"2008",
	"2001",
	"2025",
	"1921",
	"1945",
	"2021",
	"2024",
	"1999",
	"2020",
	"2005",
	"2002",
	"2004",
	"2007",
	"2013",
	"2016"
]

var Names = [
	"hunter",
	"mullen",
	"fulton",
	"decker",
	"foster",
	"madden",
	"oliver",
	"dawson",
	"ramsey",
	"barker",
	"tucker",
	"hooper",
	"fisher",
	"conley",
	"wright"
]

var Symbols = [
	"♠",
	"♥",
	"♣",
	"♦"
]


func _on_final_keypad_on_pad_solve():
	$"Manor/Main Doors".hide()
	$Manor/OpenDoor.show()
	$Manor/Ladder.show()
	$Manor/Rug.switch_resource(load("res://Resources/rugopenable.tres"))
