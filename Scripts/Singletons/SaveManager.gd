extends Node

var save_path := "user://save_data.save"

func save_game():
	var save_data = {
		"current_room": Global.current_room,
		"has_listened_to_walkie": StoryFlags.has_listened_to_walkie,
		"bone_used": StoryFlags.bone_used,
		"has_checked_safe": StoryFlags.has_checked_safe,
		"has_won_gambling": StoryFlags.has_won_gambling,
	}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(save_data)
	print("Game saved: ", save_data)

func load_game_data() -> Dictionary:
	if not FileAccess.file_exists(save_path):
		print("No save file found.")
		return {}
	var file = FileAccess.open(save_path, FileAccess.READ)
	var save_data = file.get_var()
	print("Game loaded: ", save_data)
	return save_data

func apply_save_data():
	var save_data = load_game_data()
	if save_data.has("current_room"):
		var room = save_data["current_room"]
		SignalBus.emit_signal("enter", room)

	# Restore story flags
	StoryFlags.has_listened_to_walkie = save_data.get("has_listened_to_walkie", false)
	StoryFlags.bone_used = save_data.get("bone_used", false)
	StoryFlags.has_checked_safe = save_data.get("has_checked_safe", false)
	StoryFlags.has_won_gambling = save_data.get("has_won_gambling", false)

	# Emit signal to hide Bone if used
	if StoryFlags.bone_used:
		SignalBus.emit_signal("hide", "Manor_Prehist/Bone")



	# Update item visibility after all state is loaded
	get_tree().current_scene.call_deferred("update_visibility_from_flags")
