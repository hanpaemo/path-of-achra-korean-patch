extends Node2D


var verses
var scene_disabled = false
var verse_data

func _ready():
	
	verse_data = loader.load_data("res://Data/Table_Verses.json")
	verses = []
	for key in verse_data:
		
			verses.append(verse_data[key])
	
	var verse = verses[Global.rng.randi_range(0, verses.size() - 1)]
	var chosen_verse = verse.text
	
	var stringa = chosen_verse.replace("(d)", StatePlayerSheet.God.name)
	stringa = stringa.replace("(n)", "[color=#ffff50]" + StatePlayerSheet.title_name + "[/color]")
	
	if verse.book == "achra":
		stringa += "\n\n\n\n[color=#707070]~ 아크라의 시편, 단편 ~[/color]"
	elif verse.book == "king":
		stringa += "\n\n\n\n[color=#707070]~ 왕의 현상학, 단편 ~[/color]"
	elif verse.book == "prayer":
		stringa += "\n\n\n\n[color=#707070]~ 잃어버린 기도문, 단편 ~[/color]"
	elif verse.book == "history":
		stringa += "\n\n\n\n[color=#707070]~ 황폐한 역사서, 단편 ~[/color]"
	elif verse.book == "dune":
		stringa += "\n\n\n\n[color=#707070]~ 모래바다의 권고, 단편 ~[/color]"
	elif verse.book == "imp":
		stringa += "\n\n\n\n[color=#707070]~ 재상 임프의 서판, 단편 ~[/color]"
	
	$verse.bbcode_text = "[color=#a0a0a0]" + stringa
	
	setup_deckbuttons()
	
	draw_margin($Margin)
	
	
func start():
	if scene_disabled == false:
		scene_disabled = true
		Global.universal.transition("game")
	
func draw_margin(margin_node):
	var y = margin_node.position.y
	var x = margin_node.position.x
	
	for n in 13:
		var s = Sprite.new()
		add_child(s)
		s.position.y = y
		s.position.x = x + Global.rng.randi_range( - 15, 15)
		s.texture = load("res://Ham_Sprite/World/Sea2.png")
		y += 32


func _input(event):
	if scene_disabled == false:
		if event.is_action_pressed("enter"):
			start()
		elif event.is_action_pressed("tab"):
			start()
		elif event.is_action_pressed("escape"):
			start()
		elif event.is_action_pressed("pass"):
			start()
		Global.universal.deck.input_handler(event)

func _on_Button_pressed():
	start()

func setup_deckbuttons():
	if Global.universal.deck.allowed == true:
		Global.universal.deck.deckbuttons = [[$Button]]
		Global.universal.deck.index_x = 0
		Global.universal.deck.index_y = 0
		Global.universal.deck.set_first_button()
