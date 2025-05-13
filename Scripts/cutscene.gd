extends Node2D

func _ready():
	print("background")
	$BlackBackground.show()
	SignalBus.emit_signal("display_conversation", Cutscenes.intro, Cutscenes.introspeaker, "introcutscene")
	
