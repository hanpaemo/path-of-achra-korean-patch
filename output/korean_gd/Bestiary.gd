extends Node2D





var button_selected = null
var scene_disabled = false
var button_hovered = null

var buttons = []

var ability_buttons = []


var auto_buffer = 0
var auto_buffer_max = 15

func _process(_delta):
	if Input.is_action_pressed("tab"):
		auto_buffer += 1
		if auto_buffer >= auto_buffer_max:
			auto_buffer = 0
			if Input.is_action_pressed("alt") == false and Input.is_action_pressed("shift") == false:
				if buttons.size() > 0:
					cycle_selection()
	else:
		auto_buffer = 0

func _ready():
	if Global.universal.last_scene_label != "game":
		Global.bestiary_selected = "none"
	
	if Global.bestiary_selected != "none":
		$RichTextLabel3.bbcode_text = "[color=#c0c0c0]보이는 적..."
	create_buttons()
	print(str(buttons.size()) + " total buttons")
	
	setup_deckbuttons()
	update_selected()




func update_selected():
	var to_erase = []
	for button in ability_buttons:
		to_erase.append(button)
	for button in to_erase:
		ability_buttons.erase(button)
		button.queue_free()
	ability_buttons = []
		
	
	
	$Node2D / Selection.position = button_selected.position
	
	if button_hovered == null:
		if button_selected != null:
			write_button(button_selected)
	else:
		write_button(button_hovered)
	
	for button in buttons:
		if button != button_selected and button != button_hovered:
			button.modulate = Color(0.5, 0.5, 0.5, 1)
			
		else:
			button.modulate = Color(1, 1, 1, 1)
	print(str(ability_buttons.size()) + " total ability buttons")
	update_deck_ability_buttons()

func write_button(button):
	$Sprite2.texture = load(button.enemy_data.sprite)
	if button_hovered == null:
		if button_selected != null:
			$Sprite.texture = load(button_selected.enemy_data.sprite)
	else:
		$Sprite.texture = load(button_hovered.enemy_data.sprite)
	if button.type == "unit":
		$Sprite2.texture = null
		write_unit(button.enemy_data)
		create_ability_buttons(button.enemy_data)
	elif button.type == "ability":
		write_ability(button.enemy_data)
	

func create_ability_buttons(data):
	var y = 0
	var abilities = data.abilities
	for key in abilities:
		if key != "none":
			var ability = cloner.clone_dict(LTraitsGeneric.trait_data[key])
			var b = Global.ButtonBeast.instance()
			get_node("Node2D2").add_child(b)
			b.get_node("Sprite").texture = load(ability.sprite)
			b.position = Vector2(0, y)
			b.enemy_data = ability
			b.context = self
			ability_buttons.append(b)
			
			b.type = "ability"
		
			y += 32
	

func write_unit(data):
	
	var stringa = ""
	stringa += data.name_color
	
	stringa += "[color=#c0c0c0]\n\n"
	stringa += data.description
	stringa += "\n" + translate_tier(data.tier, data.boss)
	
	$RichTextLabel2.bbcode_text = stringa
	
	
	
	
	stringa = "     "
	stringa += "[color=#ff8080]" + str(data.hp) + "[/color] 체력"
	if data.cycle.has("hp"): stringa += " [color=#af40af]+ 순환[/color]"
	
	stringa += "\n"
	stringa += "     "
	stringa += "[color=#20ff20]" + str(data.speed) + "[/color] 속도, " + str(data.speedmin) + " 최소"
	if data.cycle.has("speed"): stringa += " [color=#af40af]+ 순환[/color]"
	
	
	stringa += "\n     [color=#b0b0b0]" + str(data.range_attack) + "[/color] 사거리"
	stringa += ", " + translate.damage_type(data.dmgtype) + " 피해"
	
	stringa += "\n"
	stringa += "     "
	stringa += "[color=#ffa050]" + str(data.accuracy[0] * 10) + "[/color] 명중률"
	if data.cycle.has("accuracy"): stringa += " [color=#af40af]+ 순환[/color]"
	
	
	
	stringa += "\n"
	stringa += "     "
	stringa += "[color=#ff8030]" + str(data.damage[0] * 10) + "[/color] 피해"
	if data.cycle.has("hit"): stringa += " [color=#af40af]+ 순환[/color]"
	
	stringa += "\n"
	stringa += "     "
	stringa += "[color=#50ffff]" + str(data.dodge[0] * 10) + "[/color] 회피"
	if data.cycle.has("dodge"): stringa += " [color=#af40af]+ 순환[/color]"
	
	stringa += "\n"
	stringa += "     "
	stringa += "[color=#5050ff]" + str(data.deflect[2]) + "[/color] 방어"
	if data.cycle.has("block"): stringa += " [color=#af40af]+ 순환[/color]"
	
	stringa += "\n"
	stringa += "     "
	stringa += "[color=#5050ff]" + str(data.arm) + "[/color] 방어력"
	if data.cycle.has("armor"): stringa += " [color=#af40af]+ 순환[/color]"
	
	stringa += "\n\n[color=#707070]저항:[/color]"
	stringa += "\n\n"
	var typelist = ["slash", "blunt", "pierce", "fire", "ice", "poison", "lightning", "death", "psychic", "astral", "blood"]
	
	for label in typelist:
		var resist = data["resist_" + label]
		if resist != 0:
			
				
				
				
				stringa += "     "
				stringa += translate.value_to_color(resist)
				stringa += str(resist) + "% "
				stringa += "[/color]"
				stringa += translate.damage_type(label)
				
				stringa += "\n"
	
	$RichTextLabel.bbcode_text = "[color=#c0c0c0]" + stringa

func write_ability(data):
	var stringa = "[color=#c0c0c0]"
	stringa += data.Name
	
	stringa += "\n\n"
	stringa += data.Description_Unit
	
	if data.reference != "none":
		stringa += "\n\n"
		var buff = LBuffs.buff_data[data.reference]
		stringa += "[color=#707070]효과[/color]\n" + buff.color + buff.name + ": [/color]"
		stringa += buff.description
	
	$RichTextLabel2.bbcode_text = stringa
	$RichTextLabel.bbcode_text = ""
	

func create_buttons():
	var enemies = cloner.clone_dict(LEnemies.enemy_data)
	var x = 0
	var y = 0
	var columns = 0
	var columns_max = 10
	var first = true
	
	for key in enemies:
		var enemy = enemies[key]
		if enemy.tier > 0 and check_if_visible(enemy.title):
			
		
			var b = Global.ButtonBeast.instance()
			get_node("Node2D").add_child(b)
			b.get_node("Sprite").texture = load(enemy.sprite)
			b.position = Vector2(x, y)
			b.enemy_data = enemy
			b.context = self
			b.index_x = columns
			buttons.append(b)
			
			b.type = "unit"
		
			x += 32
			columns += 1
			if columns > columns_max:
				columns = 0
				x = 0
				y += 32
			
			if first == true:
				button_selected = b
				first = false
			if Global.bestiary_selected != "none":
				if enemy.title == Global.bestiary_selected:
					button_selected = b

func check_if_visible(title):
	var boola = true
	var visible_once = false
	if Global.bestiary_selected != "none":
		boola = false
		
		
		for tile in Global.continent.get_next_tiles():
			for enemy in tile.enemies:
				
					if title == enemy.title:
						boola = true
						if enemy.has("map_hidden"):
							if enemy.map_hidden == true:
								boola = true
							else:
								visible_once = true
						else:
							visible_once = true
			var enemy = tile.boss
			if enemy != null:
				if title == enemy.title:
					boola = true
	
	if visible_once == true:
		boola = true
	
	return boola

func translate_tier(tier, boss):
	var stringa = "[color=#707070]...을 떠돌고 있다 "
	if boss == true:
		if tier < 5:
			stringa = "[color=#707070]...에 서식한다 [/color]"
		else:
			stringa = "[color=#707070]...을 지배한다 [/color]"
	match str(tier):
		"1":
			if boss == true: stringa += "[color=#00ff70]초록 탑[/color]"
			else: stringa += "[color=#00ff70]초반[/color] 땅"
		"2":
			if boss == true: stringa += "[color=#8000af]보라 탑[/color]"
			else: stringa += "[color=#8000af]중반[/color] 땅"
		"3":
			if boss == true: stringa += "[color=#ff5030]빨강 탑[/color]"
			else: stringa += "[color=#ff5030]후반[/color] 땅"
		"4":
			if boss == true: stringa += "[color=#ff90a0]오벨리스크[/color]"
			else: stringa += "[color=#ff90a0]최종[/color] 땅"
		"5":
			if boss == true: stringa += "[color=#8030ff]성석[/color]"
			else: stringa += "[color=#9000a0]공허[/color]"
		"6":
			if boss == true: stringa += "[color=#ffff80]정신 미로[/color]"
			else: stringa += "[color=#ffff80]정신 미로[/color]"
		"7":
			if boss == true: stringa += "[color=#ff2020]혈공[/color]"
			else: stringa += "[color=#ff2020]혈공[/color]"
		"8":
			if boss == true: stringa += "[color=#30af50]금단의 길[/color]"
			else: stringa += "[color=#30af50]금단의 길[/color]"
		"9":
			if boss == true: stringa += "[color=#5070ff]파랑 탑[/color]"
			else: stringa += "[color=#5070ff]파랑 탑[/color]"
		"10":
			if boss == true: stringa += "[color=#ff00a0]성계 늪[/color]"
			else: stringa += "[color=#ff00a0]성계 늪[/color]"
		"11":
			if boss == true: stringa += "[color=#B0E0E6]삼켜진 별[/color]"
			else: stringa += "[color=#B0E0E6]삼켜진 별[/color]"
		
		"99":
			stringa = "[color=#a070ff]소환[/color]"
				
	return stringa

func _input(event):
	if scene_disabled == false:
		if event.is_action_pressed("escape"):
			quit()
		if event.is_action_pressed("gamepad_y"):
				if ToolSettings.settings_data.gamepad_mode == "full":
					quit()
		if event.is_action_pressed("tab"):
			if Input.is_action_pressed("alt") == false and Input.is_action_pressed("shift") == false:
				if buttons.size() > 0:
					cycle_selection()
		Global.universal.deck.input_handler(event)
func cycle_selection():
	
	var index = 0
	for n in buttons.size():
		if buttons[n] == button_selected:
			if n == buttons.size() - 1:
				index = 0
			else:
				index = n + 1
	button_selected = buttons[index]
	Global.sound.new_sound("Hover")
	update_selected()


func quit():
	if scene_disabled == false:
		scene_disabled = true
		Global.universal.transition(Global.universal.last_scene_label)


func _on_Quit_pressed():
	quit()


func _on_Quit_mouse_entered():
	Global.sound.new_sound("Hover")

func setup_deckbuttons():
	Global.universal.deck.deckbuttons = []
	var columns = 11
	if columns > buttons.size(): columns = buttons.size()
	for n in columns: Global.universal.deck.deckbuttons.append([])

	
	for button in buttons:
		Global.universal.deck.deckbuttons[button.index_x].append(button)
	Global.universal.deck.deckbuttons.append([$Quit])
	Global.universal.deck.index_x = 0
	Global.universal.deck.index_y = 0
	Global.universal.deck.set_first_button()
	print(str(Global.universal.deck.deckbuttons.size()) + " mapped deckbuttons for bestiary")
	

func update_deck_ability_buttons():
	if Global.universal.deck.allowed == true:
		Global.universal.deck.deckbuttons[Global.universal.deck.deckbuttons.size() - 1] = [$Quit]
	
		if ability_buttons.size():
			for button in ability_buttons:
				Global.universal.deck.deckbuttons[Global.universal.deck.deckbuttons.size() - 1].append(button)
	
		print(str(Global.universal.deck.deckbuttons[Global.universal.deck.deckbuttons.size() - 1].size() - 2) + " mapped deck ability buttons")
		var check_map = Global.universal.deck.deckbuttons[Global.universal.deck.deckbuttons.size() - 1]
		for button in check_map:
			if button == $Quit:
				print("Quit")
			else:
				print(button.enemy_data.Name)
		Global.universal.deck.reset_current_selected()

	
