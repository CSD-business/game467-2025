extends Node



func _on_load_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_cutscene.tscn")
	
