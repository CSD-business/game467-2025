extends Control

var selected_text
var printed = ""
var current_speaker = ""
@export var text_speed = .1
@onready var text_label = $TextLabel
@onready var background = $Background
@onready var speaker_text_label = $Speaker
@onready var speaker_background = $SpeakerBackground

signal next_message()

func _ready():
	background.visible = false
	SignalBus.connect("display_dialogue",on_display_dialogue)
	SignalBus.connect("display_conversation",on_display_conversation)
func _process(delta):
	text_label.text = printed
	speaker_text_label.text = current_speaker
	#code to make the window scroll faster if the text is not done
	#or close the window/go to the next message if it is

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if Global.reading_in_progress: 
				text_speed = .01
				next_message.emit()
			else:
				printed = ""
				current_speaker = ""
				background.visible = false
				speaker_background.visible = false

func on_display_dialogue(new_message):
	print_message(new_message)
func on_display_conversation(new_message,speaker):	
	print_dialogue(new_message,speaker)


func print_message(message):
	text_label.text = ""
	printed = ""
	background.visible = true
	Global.reading_in_progress = true
	text_speed = .1
	#for length of message, print out a letter
	for i in len(message):
		printed += message[i]
		AudioPlayer.get_node("TalkSound").play()
		await get_tree().create_timer(text_speed).timeout 
	Global.reading_in_progress = false
	#flag the printing as done so objects can be interacted
	
	
func print_dialogue(message,speaker):
	text_speed = .1
	printed = ""
	current_speaker = ""
	background.visible = true
	speaker_background. visible = true
	Global.reading_in_progress = true
	var counter = 0
	for line in message:
		current_speaker = speaker[counter]
		text_speed = .1
		printed = ""
		for i in len(line):
			printed += line[i]
			AudioPlayer.get_node("TalkSound").play()
			await get_tree().create_timer(text_speed).timeout
		if line == message[-1]: break 
		await self.next_message
		counter += 1
	Global.reading_in_progress = false
	
	
func _on_mouse_entered():
	Global.Selected_Object = self

func _on_mouse_exited():
	Global.Selected_Object = null
