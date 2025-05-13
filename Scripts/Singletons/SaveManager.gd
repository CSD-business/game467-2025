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
}

signal save_loaded  # ✅ New signal

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
		"inventory_data": Global.inventory_data,
		"year_code": Global.year_code,
		"name_code": Global.name_code,
		"symbol_code": Global.symbol_code,
		"saloon_key_used": StoryFlags.saloon_key_used,
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
	if save_data.is_empty():
		return

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

	# Puzzle values
	Global.year_code = save_data.get("year_code", "")
	Global.name_code = save_data.get("name_code", "")
	Global.symbol_code = save_data.get("symbol_code", "")

	# Restore inventory
	Global.inventory_data = save_data.get("inventory_data", [])
	Global.inventory_keys.clear()

	var inventory_ui = get_tree().get_root().get_node("Main/Inventory_UI")
	var grid = inventory_ui.get_node("GridContainer")

	# ✅ Clear all slots first to avoid residual items from earlier play
	for slot in grid.get_children():
		slot.set_item(null)

	for data in Global.inventory_data:
		var item_key = data.get("key", "")
		var slot_index = data.get("slot", -1)

		# Skip restoring Bone if it was already used
		if item_key == "bone" and StoryFlags.bone_used:
			print("Skipping bone - already used")
			continue

		# Skip restoring Cave Key if it was already used
		if item_key == "saloon_key" and StoryFlags.saloon_key_used:
			print("Skipping cave key - already used")
			continue
			
		if item_key == "markbad" and StoryFlags.stout_used:
			print("Skipping stout - already used")
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

			# Hide items from world if in inventory
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
					pass  # No explicit hiding
				"markgood":
					SignalBus.emit_signal("hide", "Manor_Saloon/Tall Bottle")
				"cards":
					SignalBus.emit_signal("hide", "Manor_Casino/Deck of Cards")
				"coin":
					SignalBus.emit_signal("hide", "Manor_Casino/Coin")
				"casino_key":
					SignalBus.emit_signal("hide", "Manor_Saloon/Saloon Key")
				"main_key", "skibidi rizz":
					pass

	# Extra visibility logic
	if StoryFlags.bone_used:
		SignalBus.emit_signal("hide", "Manor_Prehist/Bone")
	if StoryFlags.saloon_unlocked:
		SignalBus.emit_signal("hide", "Manor_Prehist/Cave Key Takeable")

	# ✅ Defer scene update and emit post-load signal
		
		# After inventory and flags restored

# Ensure visibility is correct for Bone and Saloon Key if not in inventory and not used
	if not StoryFlags.bone_used and not Global.inventory_keys.has("bone"):
		print("Bone not in inventory and not used — showing in world")
		SignalBus.emit_signal("show", "Manor_Prehist/Bone")

	if not StoryFlags.saloon_key_used and not Global.inventory_keys.has("saloon_key"):
		print("Saloon Key not in inventory and not used — showing in world")
		SignalBus.emit_signal("show", "Manor_Prehist/Cave Key Takeable")

	if not StoryFlags.stout_used and not Global.inventory_keys.has("markbad"):
		print("Saloon Key not in inventory and not used — showing in world")
		SignalBus.emit_signal("show", "Manor_Saloon/Stout Bottle")
