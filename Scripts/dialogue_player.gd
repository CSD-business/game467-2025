extends Control

var selected_text
var printed = ""
var current_speaker = ""
var rushing_text
@export var text_speed = .03
@onready var text_label = $TextLabel
@onready var background = $Background
@onready var speaker_text_label = $Speaker
@onready var speaker_background = $SpeakerBackground

signal next_message()

#Connect signals on ready
func _ready():
	background.visible = false
	SignalBus.connect("display_dialogue",on_display_dialogue)
	SignalBus.connect("display_conversation",on_display_conversation)
#Update labels every frame
func _process(delta):
	text_label.text = printed
	speaker_text_label.text = current_speaker
	#code to make the window scroll faster if the text is not done
	#or close the window/go to the next message if it is

# If clicking, make the text go faster or go to next dialogue
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if Global.reading_in_progress: 
				rushing_text = true
				next_message.emit()
			elif Global.using_item == false:
				clear_text()
	if event.is_action("debug"): 
		text_speed = 0
		next_message.emit()

#Signal busses for one/many dialogues
func on_display_dialogue(new_message):
	print_message(new_message)
func on_display_conversation(new_message,speaker, key = null):	
	print_dialogue(new_message,speaker,key)

#Message is for ONE box of text and no speaker. most things tbh
func print_message(message):
	rushing_text = false
	text_label.text = ""
	if message.contains("[procyear]"):
		message = "The paper looks like a search warrant for the mansion that somone was task to investigate. It was issued on the year " + Global.year_code + "."
	if message.contains("[procname]"):
		message = "After being played, the name ''" + Global.name_code + "'' is inscribed on it. Neat."
	if message.contains("[symbol]"):
		message = "The blue card in this otherwise all red deck has a " + Global.symbol_code + " symbol on it."
	printed = message
	background.visible = true
	Global.reading_in_progress = true
	text_speed = .03
	text_label.visible_ratio = 0
	#for length of message, print out a letter
	for i in len(message):
		var length : float = len(message)
		text_label.visible_ratio = i/length
		if AudioPlayer.get_node("TalkSound").playing == false:
			AudioPlayer.get_node("TalkSound").play()
		if !rushing_text: await get_tree().create_timer(text_speed).timeout 
	text_label.visible_ratio = 1
	Global.reading_in_progress = false
	#flag the printing as done so objects can be interacted
	
#For N>1 dialogue boxes. Holds a speaker and key as well
#Key is to trigger some things *after* dialogue finishes
#Like sounds or something
func print_dialogue(message,speaker,key):
	text_speed = .03
	printed = ""
	current_speaker = ""
	background.visible = true
	speaker_background.visible = true
	Global.reading_in_progress = true
	var counter = 0
	for line in message:
		rushing_text = false
		current_speaker = speaker[counter]
		if speaker[counter].length() <1:
			$SpeakerBackground.hide()
		else:
			$SpeakerBackground.show()
			#print(speaker[counter])
		text_speed = .03
		printed = line
		text_label.visible_ratio = 0
		for i in len(line):
			var length : float = len(line)
			text_label.visible_ratio = float(i/length)
			if AudioPlayer.get_node("TalkSound").playing == false:
				AudioPlayer.get_node("TalkSound").play()
			if !rushing_text: await get_tree().create_timer(text_speed).timeout
		text_label.visible_ratio = 1
		if line == message[-1]: break 
		await self.next_message
		counter += 1
	Global.reading_in_progress = false
	if key == "introcutscene":
		print("intro over")
		$"../BlackBackground".modulate = Color(1,1,1,0)
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
		#AudioPlayer.get_node("DefaultMusic").play()
		AudioPlayer.fade_in_music(AudioPlayer.get_node("DefaultMusic"))
	if key == "markgivekeykey":
		$"../Manor_Saloon/Saloon Key".show()
	if key == "unlocksafekey":
		load("res://Resources/record.tres").take_item()
		await get_tree().create_timer(.2).timeout
		load("res://Resources/safe_unlockedtake.tres").take_item()
	if key == "jukeboxkey":
		SignalBus.emit_signal("display_conversation", Cutscenes.jukebox2, Cutscenes.jukeboxspeaker2, Cutscenes.jukeboxkey2)
		$"../Manor_Casino/Dealer Standing".hide()
		$"../Manor_Casino/Dealer".show()
		StoryFlags.has_won_gambling = true
	if key == "jukeboxkey2":
		load("res://Resources/recordleftover.tres").take_item()
	if key == "curlythankyou":
		load("res://Resources/main_door_key.tres").take_item()
	if key == "endcutscenepart1key":
		SignalBus.emit_signal("display_conversation", Cutscenes.endcutscenepart2, Cutscenes.endcutscenepart2speaker, "endcutscenepart2key")
		$"../Manor_Powercore/PowerOff".hide()
		$"../Manor_Powercore/PowerOn".show()
	if key == "endcutscenepart2key":
		Global.in_menu = true
		$"../BlackBackground/AnimationPlayer".play("Fade2Black") 
		await get_tree().create_timer(2).timeout
		print("thank you!!!")
		$"../ThankYou/AnimationPlayer".play("Fade2Black") 
func _on_mouse_entered():
	Global.Selected_Object = self

func _on_mouse_exited():
	Global.Selected_Object = null

#Clears the text boxes and hides them
func clear_text():
	printed = ""
	current_speaker = ""
	background.visible = false
	speaker_background.visible = false
