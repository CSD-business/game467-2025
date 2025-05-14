extends Node

var save_path := "user://save_data.save"

# Texture filename mapping
var key_to_filename = {
	"bone": "bone.png",
	"walkie": "walkie.png",
	"saloon_key": "key.png",
	"note": "note.png",
	"markbad": "bottleslice.png",
	"record": "record.png",
	"markgood": "bottle.png",
	"casino_key": "key.png",
	"cards": "deckofcards.png",
	"coin": "coin.png",
	"main_key": "key.png",
	"skibidi rizz": "record.png",
	"ladder": "ladder.png"
}

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
		"saloon_key_used": StoryFlags.saloon_key_used,
		"casino_key_used": StoryFlags.casino_key_used,
		"coin_used": StoryFlags.coin_used,
		"main_key_used": StoryFlags.main_key_used,
		"final_room_open": StoryFlags.final_room_open,
		"inventory_data": Global.inventory_data,
		"year_code": Global.year_code,
		"name_code": Global.name_code,
		"symbol_code": Global.symbol_code,
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

	# Restore room
	if save_data.has("current_room"):
		var room = save_data["current_room"]
		if room != "":
			SignalBus.emit_signal("enter", room)

	# Restore story flags
	StoryFlags.has_listened_to_walkie = save_data.get("has_listened_to_walkie", false)
	StoryFlags.bone_used = save_data.get("bone_used", false)
	StoryFlags.has_checked_safe = save_data.get("has_checked_safe", false)
	StoryFlags.has_won_gambling = save_data.get("has_won_gambling", false)
	StoryFlags.saloon_unlocked = save_data.get("saloon_unlocked", false)
	StoryFlags.stout_used = save_data.get("stout_used", false)
	StoryFlags.tall_used = save_data.get("tall_used", false)
	StoryFlags.casino_unlocked = save_data.get("casino_unlocked", false)
	StoryFlags.coin_taken = save_data.get("coin_taken", false)
	StoryFlags.saloon_key_used = save_data.get("saloon_key_used", false)
	StoryFlags.casino_key_used = save_data.get("casino_key_used", false)
	StoryFlags.coin_used = save_data.get("coin_used", false)
	StoryFlags.main_key_used = save_data.get("main_key_used", false)
	StoryFlags.final_room_open = save_data.get("final_room_open", false)

	# Puzzle values
	Global.year_code = save_data.get("year_code", "")
	Global.name_code = save_data.get("name_code", "")
	Global.symbol_code = save_data.get("symbol_code", "")

	# Restore inventory
	Global.inventory_data = save_data.get("inventory_data", [])
	Global.inventory_keys.clear()

	var inventory_ui = get_tree().get_root().get_node("Main/Inventory_UI")
	var grid = inventory_ui.get_node("GridContainer")

	# Clear all slots
	for slot in grid.get_children():
		slot.set_item(null)

	for data in Global.inventory_data:
		var item_key = data.get("key", "")
		var slot_index = data.get("slot", -1)

		if item_key == "bone" and StoryFlags.bone_used:
			print("Skipping bone - already used")
			continue
		if item_key == "saloon_key" and StoryFlags.saloon_key_used:
			print("Skipping saloon key - already used")
			continue
		if item_key == "markbad" and StoryFlags.stout_used:
			print("Skipping stout - already used")
			continue
		if item_key == "casino_key" and StoryFlags.casino_key_used:
			print("Skipping casino key - already used")
			continue
		if item_key == "coin" and StoryFlags.coin_used:
			print("Skipping coin - already used")
			continue
		if item_key == "main_key" and StoryFlags.main_key_used:
			print("Skipping main key - already used")
			continue

		print("Restoring item:", item_key, "to slot", slot_index)
		if item_key != "" and slot_index >= 0 and slot_index < grid.get_child_count():
			var slot = grid.get_child(slot_index)
			var item_instance = Takeable.new()
			item_instance.key = item_key
			item_instance.inspect_text = "Restored item: " + item_key

			var filename = key_to_filename.get(item_key, item_key + ".png")
			var texture_path = "res://Assets/Images/" + filename
			if not ResourceLoader.exists(texture_path):
				print("⚠️ Warning: Missing texture for item_key:", item_key, "→", texture_path)
			item_instance.texture = load(texture_path)

			slot.set_item(item_instance)
			Global.inventory_keys.append(item_key)

			# Hide world instance
			match item_key:
				"bone":
					SignalBus.emit_signal("hide", "Manor_Prehist/Bone")
				"saloon_key":
					SignalBus.emit_signal("hide", "Manor_Prehist/Cave Key Takeable")
				"walkie":
					SignalBus.emit_signal("hide", "Manor_Prehist/Walkie")
				"note":
					SignalBus.emit_signal("hide", "Manor_Prehist/Search Warrant")
				"markbad":
					SignalBus.emit_signal("hide", "Manor_Saloon/Stout Bottle")
				"record":
					pass
				"markgood":
					SignalBus.emit_signal("hide", "Manor_Saloon/Tall Bottle")
				"cards":
					SignalBus.emit_signal("hide", "Manor_Casino/Deck of Cards")
				"coin":
					SignalBus.emit_signal("hide", "Manor_Casino/Coin")
				"casino_key":
					SignalBus.emit_signal("hide", "Manor_Saloon/Saloon Key")
				"main_key":
					SignalBus.emit_signal("hide", "Manor_Final/Main Key Takeable")
				"skibidi rizz":
					pass
				"Ladder":SignalBus.emit_signal("hide", "Manor/Ladder")
					

	# Extra world visibility logic
	if StoryFlags.bone_used:
		SignalBus.emit_signal("hide", "Manor_Prehist/Bone")
		SignalBus.emit_signal("hide", "Manor_Prehist/Cave Key Default")
	if StoryFlags.saloon_unlocked:
		SignalBus.emit_signal("hide", "Manor_Prehist/Cave Key Takeable")
	if StoryFlags.main_key_used:
		SignalBus.emit_signal("hide", "Manor_Final/Main Key Takeable")

	# Show items if not used and not in inventory
	if not StoryFlags.bone_used and not Global.inventory_keys.has("bone"):
		print("Bone not in inventory and not used — showing in world")
		SignalBus.emit_signal("show", "Manor_Prehist/Bone")
	if not StoryFlags.saloon_key_used and not Global.inventory_keys.has("saloon_key"):
		print("Saloon Key not in inventory and not used — showing in world")
		SignalBus.emit_signal("show", "Manor_Prehist/Cave Key Takeable")
	if not StoryFlags.stout_used and not Global.inventory_keys.has("markbad"):
		print("Stout not in inventory and not used — showing in world")
		SignalBus.emit_signal("show", "Manor_Saloon/Stout Bottle")
	if not StoryFlags.casino_key_used and not Global.inventory_keys.has("casino_key"):
		print("Casino Key not in inventory and not used — showing in world")
		SignalBus.emit_signal("show", "Manor_Saloon/Saloon Key")
	if not StoryFlags.coin_used and not Global.inventory_keys.has("coin"):
		print("Coin not in inventory and not used — showing in world")
		SignalBus.emit_signal("show", "Manor_Casino/Coin")
	if not StoryFlags.main_key_used and not Global.inventory_keys.has("main_key"):
		print("Main Key not in inventory and not used — showing in world")
		SignalBus.emit_signal("show", "Manor_Final/Main Key Takeable")

	get_tree().current_scene.call_deferred("update_visibility_from_flags")
