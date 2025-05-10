extends Node

var save_path := "user://save_data.save"

func save_game():
	var save_data = {
		"current_room": Global.current_room,
		"has_listened_to_walkie": StoryFlags.has_listened_to_walkie,
		"bone_used": StoryFlags.bone_used,
		"has_checked_safe": StoryFlags.has_checked_safe,
		"has_won_gambling": StoryFlags.has_won_gambling,
		"intro_played": StoryFlags.intro_played,
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

	# Emit hide signals based on flags
	if StoryFlags.bone_used:
		SignalBus.emit_signal("hide", "Manor_Prehist/Bone")

	# Hide DialoguePlayer and its children
	var dialogue_nodes := [
		"DialoguePlayer",
		"DialoguePlayer/TextLabel",
		"DialoguePlayer/Speaker",
		"DialoguePlayer/Background",
		"DialoguePlayer/SpeakerLabel",
		"DialoguePlayer/SpeakerBackground",
		"DialoguePlayer/TextTimer"
	]
	for path in dialogue_nodes:
		SignalBus.emit_signal("hide", path)

	# Hide BlackBackground
	SignalBus.emit_signal("hide", "BlackBackground")

	# Update other visibility logic (e.g., character states, items, etc.)
	get_tree().current_scene.call_deferred("update_visibility_from_flags")
