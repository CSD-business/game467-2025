extends Control
const PASSWORD = "32 180 1835"
var pointer = 0
var can_print = true
var text = "XX XXX XXXX"
var selected_text 

# This whole thing gonna be on screen for like
# Maybe 1 minute
# And yet I spent 1-2 hours on it
# That's game dev :fire:

func _process(delta):
	#Hard-coded breaks for the 3 parts of the code
	if pointer == 2:
		pointer = 3
	if pointer == 6:
		pointer = 7
	if pointer == 11:
		can_print = false
	#If the thing isn't red at the start make it red
	if $VBoxContainer/MarginContainer/Label.text == "XX XXX XXXX":
		$VBoxContainer/MarginContainer/Label.text = "[color=red]X[/color]X XXX XXXX"

#On a given key press (signal)
#Make the pointer's X change into a digit
#And then format the next digit into being red
func key_press(digit):
	if can_print:
		text[pointer] = str(digit)
		pointer += 1
		selected_text = format_text(text)
		$VBoxContainer/MarginContainer/Label.text = selected_text

#Make the next X red to indicate it's next
func format_text(text):
	var new_text = text
	var first_x_index = new_text.find("X")
	if first_x_index > -1:
		new_text[first_x_index] = ""
		new_text = new_text.insert(first_x_index,"[color=red]X[/color]")
	return new_text
	
#signals for digit buttons
func _on_button_pressed(): key_press(1)
func _on_button_2_pressed(): key_press(2)
func _on_button_3_pressed(): key_press(3)
func _on_button_4_pressed(): key_press(4)
func _on_button_5_pressed(): key_press(5)
func _on_button_6_pressed(): key_press(6)
func _on_button_7_pressed(): key_press(7)
func _on_button_8_pressed(): key_press(8)
func _on_button_9_pressed(): key_press(9)
#clear button signal resets everything
func _on_button_clear_pressed():
	$VBoxContainer/MarginContainer/Label.text = "XX XXX XXXX"
	text = "XX XXX XXXX"
	pointer = 0
	can_print = true
#number 0 is down here sorry guys
func _on_button_0_pressed(): key_press(0)
#enter button checks if the code is right
func _on_button_enter_pressed():
	if text == PASSWORD:
		$VBoxContainer/MarginContainer/Label.modulate = Color(0,1,0)
		await get_tree().create_timer(1).timeout
		$VBoxContainer/MarginContainer/Label.modulate = Color(1,1,1)
		$"../Safe".switch_resource(load("res://Resources/safe_unlocked.tres"))
		#$"../Safe".switch_resource(load("res://Resources/safe_unlockedtake.tres"))
		$"../Mark".switch_resource(load("res://Resources/markusefancywine.tres"))
		$"../Mark".switch_resource(load("res://Resources/marktalkpostsafeunlock.tres"))
		SignalBus.emit_signal("display_conversation", Cutscenes.unlock_safe, Cutscenes.unlock_safe_speaker, Cutscenes.unlock_safe_key)
		print("yay")
		#signal something
		Global.in_menu = false
		hide()
	else:
		print($VBoxContainer/MarginContainer/Label.text.find("1835"))
		if $VBoxContainer/MarginContainer/Label.text.find("32")==0:
			$VBoxContainer/MarginContainer/Label.text = $VBoxContainer/MarginContainer/Label.text.replace("32 ", "[color=green]32 [color=red]")
		if $VBoxContainer/MarginContainer/Label.text.find("180")>4:
			$VBoxContainer/MarginContainer/Label.text = $VBoxContainer/MarginContainer/Label.text.replace("180 ", "[color=green]180 [color=red]")
		if $VBoxContainer/MarginContainer/Label.text.find("1835")>7:
			$VBoxContainer/MarginContainer/Label.text = $VBoxContainer/MarginContainer/Label.text.replace("1835", "[color=green]1835[/color]")
		else:$VBoxContainer/MarginContainer/Label.text = "[color=red]" + $VBoxContainer/MarginContainer/Label.text
			
			
		await get_tree().create_timer(1).timeout
		$VBoxContainer/MarginContainer/Label.text
		var regex = RegEx.new()
		regex.compile("\\[.*?\\]")
		var text_without_tags = regex.sub($VBoxContainer/MarginContainer/Label.text, "", true)
		$VBoxContainer/MarginContainer/Label.text = text_without_tags
#close ui when you hit the done button
func _on_done_pressed():
	Global.in_menu = false
	hide()
