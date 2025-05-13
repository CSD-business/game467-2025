extends Control

@onready var yeartext = $VBoxContainer/Texts/HBoxContainer/Year/Label.text
@onready var nametext = $VBoxContainer/Texts/HBoxContainer/Name/Label.text
@onready var symboltext = $VBoxContainer/Texts/HBoxContainer/Symbol/Label.text
signal on_pad_solve
# Called when the node enters the scene tree for the first time.
func key_press(section, digit, direction):
	if section == "year"    :
		yeartext[digit] = iterate_number(yeartext[digit], direction)
		$VBoxContainer/Texts/HBoxContainer/Year/Label.text = str(yeartext[0] + yeartext[1] + yeartext[2] + yeartext[3])
	elif section == "name"  :
		nametext[digit] = iterate_alphabet(nametext[digit], direction)
		$VBoxContainer/Texts/HBoxContainer/Name/Label.text = str(nametext[0] + nametext[1] + nametext[2] + nametext[3] + nametext[4] + nametext[5])
	elif section == "symbol":
		symboltext = iterate_symbol(symboltext[digit], direction)
		$VBoxContainer/Texts/HBoxContainer/Symbol/Label.text = str(symboltext[0])
		
func iterate_alphabet(letter, direction):
	var id = Letters.find(letter)
	if direction == "up":
		id += 1
	if direction == "down":
		id -= 1
	if id < 0:
		id = 25
	if id > 25:
		id = 0
	return Letters[id]
func iterate_number(number, direction):
	var id = Numbers.find(number) 
	if direction == "up":
		id += 1
	if direction == "down":
		id -= 1
	if id < 0:
		id = 9
	if id > 9:
		id = 0
	return Numbers[id]
func iterate_symbol(number, direction):
	var id = Symbols.find(number)
	if direction == "up":
		id += 1
	if direction == "down":
		id -= 1
	if id < 0:
		id = 3
	if id > 3:
		id = 0
	return Symbols[id]

func check_code():
	if yeartext == Global.year_code:
		$VBoxContainer/Texts/HBoxContainer/Year/Label.modulate = Color(0,1,0)
	else:
		$VBoxContainer/Texts/HBoxContainer/Year/Label.modulate = Color(1,0,0)
	if nametext == Global.name_code:
		$VBoxContainer/Texts/HBoxContainer/Name/Label.modulate = Color(0,1,0)
	else:
		$VBoxContainer/Texts/HBoxContainer/Name/Label.modulate = Color(1,0,0)
	if symboltext == Global.symbol_code:
		$VBoxContainer/Texts/HBoxContainer/Symbol/Label.modulate = Color(0,1,0)
	else:
		$VBoxContainer/Texts/HBoxContainer/Symbol/Label.modulate = Color(1,0,0)
	await get_tree().create_timer(1).timeout 
	if yeartext == Global.year_code and nametext == Global.name_code and symboltext == Global.symbol_code:
		print("yay")
		Global.in_menu = false
		SignalBus.emit_signal("display_conversation", Cutscenes.unlockfinalkeypad, Cutscenes.unlockfinalkeypadspeaker, Cutscenes.unlockfinalkeypadkey)
		on_pad_solve.emit()
		hide()
	$VBoxContainer/Texts/HBoxContainer/Name/Label.modulate = Color(1,1,1)
	$VBoxContainer/Texts/HBoxContainer/Year/Label.modulate = Color(1,1,1)
	$VBoxContainer/Texts/HBoxContainer/Symbol/Label.modulate = Color(1,1,1)
var Letters = [
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z"
]
var Numbers = [
	"0",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9"
]
var Symbols = [
	"♠",
	"♥",
	"♣",
	"♦"
]

func _on_date_1u_pressed(): key_press("year",0,"up")
func _on_date_2u_pressed(): key_press("year",1,"up")
func _on_date_3u_pressed(): key_press("year",2,"up")
func _on_date_4u_pressed(): key_press("year",3,"up")
func _on_date_1d_pressed(): key_press("year",0,"down")
func _on_date_2d_pressed(): key_press("year",1,"down")
func _on_date_3d_pressed(): key_press("year",2,"down")
func _on_date_4d_pressed(): key_press("year",3,"down")
func _on_done_pressed(): 
	Global.in_menu = false
	hide()
func _on_name_1u_pressed(): key_press("name",0,"up")
func _on_name_2u_pressed(): key_press("name",1,"up")
func _on_name_3u_pressed(): key_press("name",2,"up")
func _on_name_4u_pressed(): key_press("name",3,"up")
func _on_name_5u_pressed(): key_press("name",4,"up")
func _on_name_6u_pressed(): key_press("name",5,"up")
func _on_name_1d_pressed(): key_press("name",0,"down")
func _on_name_2d_pressed(): key_press("name",1,"down")
func _on_name_3d_pressed(): key_press("name",2,"down")
func _on_name_4d_pressed(): key_press("name",3,"down")
func _on_name_5d_pressed(): key_press("name",4,"down")
func _on_name_6d_pressed(): key_press("name",5,"down")
func _on_symbol_u_pressed(): key_press("symbol",0,"up")
func _on_symbol_d_pressed(): key_press("symbol",0,"down")
func _on_enter_pressed(): check_code()
