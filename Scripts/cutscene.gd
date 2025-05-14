extends Node2D

func _ready():
	print("background")
	$BlackBackground.modulate = Color(1,1,1,1)
	SignalBus.emit_signal("display_conversation", Cutscenes.intro, Cutscenes.introspeaker, "introcutscene")
