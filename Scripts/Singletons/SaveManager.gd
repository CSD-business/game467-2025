extends Node

var save_path := "user://save_data.save"

func save_game():
	var save_data = {
		"current_room": Global.current_room,
		"has_listened_to_walkie": StoryFlags.has_listened_to_walkie,
		"bone_used": StoryFlags.bone_used,
		"has_checked_safe": StoryFlags.has_checked_safe,
		"has_won_gambling": StoryFlags.has_won_gambling,
		"saloon_unlocked": StoryFlags.saloon_unlocked,
		"stout_used": StoryFlags.stout_used,
		"tall_used": StoryFlags.tall_used,
		"casino_unlocked": StoryFlags.casino_unlocked,
		"coin_taken": StoryFlags.coin_taken,






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

	# Restore current room first
	if save_data.has("current_room"):
		var room = save_data["current_room"]
		SignalBus.emit_signal("enter", room)

	# Restore story flags
	StoryFlags.has_listened_to_walkie = save_data.get("has_listened_to_walkie", false)
	StoryFlags.bone_used = save_data.get("bone_used", false)
	StoryFlags.has_checked_safe = save_data.get("has_checked_safe", false)
	StoryFlags.has_won_gambling = save_data.get("has_won_gambling", false)
	StoryFlags.intro_played = save_data.get("intro_played", false)
	StoryFlags.saloon_unlocked = save_data.get("saloon_unlocked", false)
	StoryFlags.stout_used = save_data.get("stout_used", false)
	StoryFlags.tall_used = save_data.get("tall_used", false)
	StoryFlags.casino_unlocked = save_data.get("casino_unlocked", false)
	StoryFlags.coin_taken = save_data.get("coin_taken", false)






	# Emit hide signals based on flags
	if StoryFlags.bone_used:
		SignalBus.emit_signal("hide", "Manor_Prehist/Bone")


	# Hide BlackBackground
	SignalBus.emit_signal("hide", "BlackBackground")

	# Update other visibility logic (e.g., character states, items, etc.)
	get_tree().current_scene.call_deferred("update_visibility_from_flags")
