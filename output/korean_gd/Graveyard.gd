extends Node2D


onready var sprites = [$Control / Sprite, $Control / Sprite2, $Control / Sprite3, $Control / Sprite4]

var scene_disabled = false
var graveyard_var = graveyard.loadData()

var invokes_data = loader.load_data("res://Data/Table_Invokes.json")

var button_selected = null
var button_hovered = null
var buttons = []

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
	update_title()
	
	
	draw_buttons()
	if button_selected != null:
		$Control / Sprite.visible = true
		update_selected(button_selected.data)
	else:
		$Control / Sprite.visible = false

	StateWorld.continent.delete()
	StateWorld.type = "none"
	gencont.generate("dust")
	
	setup_deckbuttons()


func update_title():
	if graveyard_var.EXISTS == false:
		$Control / RichTextLabel.bbcode_text = "[color=#c0c0c0]아직 아무도 길을 걷지 않았습니다...[/color]"
		$Control / RichTextLabel.rect_position.x = 210
		$Control / RichTextLabel.rect_position.y = 220
		$Delete.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$Delete.visible = false
		$Start.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$Start / StartLabel.modulate = Color(0.2, 0.2, 0.2, 1)
	else:
		$Control / RichTextLabel.bbcode_text = "[color=#c0c0c0]순례자여, 영광 속에 쉬어라...[/color]"
		var count = 0
		for key in graveyard_var:
			if key != "EXISTS":
				count += 1
		
		$Control / RichTextLabel.bbcode_text += "  [color=#a0a000]" + str(count) + "[/color] [color=#707070]/100"

func update_selected(data):
	var no_loadable = true
	for button in buttons:
		if button != button_selected and button != button_hovered:
			button.modulate = Color(0.5, 0.1, 0.1, 1)
			if button.data.has("loadable"):
				
				button.modulate = Color(0.5, 0.5, 0.5, 1)
				
				no_loadable = false
				if button.data.has("viewed"):
					if button.data.viewed == false:
						button.modulate = Color(0.1, 0.5, 0.5, 1)
				
				
		else:
			button.modulate = Color(1, 1, 1, 1)
			if button.data.has("viewed"):
				if button.data.viewed == false:
					button.data.viewed = true
					graveyard.view_key(button.data.title_name)
	
	if no_loadable == true:
		pass
	
	if data.has("loadable"):
			set_player_sheet(data)
			
			$Start.mouse_filter = Control.MOUSE_FILTER_STOP
			$Start / StartLabel.modulate = Color(1, 1, 1, 1)
			
	else:
			
			$Start.mouse_filter = Control.MOUSE_FILTER_IGNORE
			$Start / StartLabel.modulate = Color(0.2, 0.2, 0.2, 1)
			
	update_highlight()
	draw_body_with_index(data)
		


func draw_buttons():
	var columns = 12
	var x = 0
	var y = 0
	var first = true
	
	if graveyard_var.EXISTS != false:
		for key in graveyard_var:
			if key != "EXISTS":
				pass
				var data = cloner.clone_dict(graveyard_var[key])
				var b = Global.ButtonMaqbara.instance()
				get_node("Buttons").add_child(b)
				b.data = data
				b.position = Vector2(x * 32, y * 32)
				b.context = self
				buttons.append(b)
				b.index_x = x
				
		
				b.draw_body()
			
				if first == true:
					button_selected = b
					first = false
				
				if data.title_name == Global.selected_maqbara:
					button_selected = b
				
				
				x += 1
				if x >= columns:
					x = 0
					y += 1







	
		
		
			
			
				
					
					
					

func draw_body_with_index(data):
	var node = $Control / Sprite
	node.visible = true
	node.get_node("god").texture = load(data.God.sprite)
	node.texture = load(data.sprite_skin)
	draw_equipment(data, "weapon_main", node, "weapon_main")
	draw_equipment(data, "weapon_off", node, "weapon_off")
	draw_equipment(data, "armor_head", node, "armor_head")
	draw_equipment(data, "armor_hands", node, "armor_hand")
	draw_equipment(data, "armor_legs", node, "armor_leg")
	draw_equipment(data, "armor_chest", node, "armor_chest")
	write_description(data)

	
	
	pass

func draw_equipment(data, key, node, path):
	if data[key] != null:
		node.get_node(path).texture = load(data[key].sprite)
	else:
		node.get_node(path).texture = null


func write_description(data):
	var node = $Control / Sprite
	var stringa = get_character_description(data)
	node.get_node("RichTextLabel").bbcode_text = stringa
	
	
	
	
	
	stringa = ""
	if data.has("dust"):
		stringa = "[color=#a0a0a0][color=#a08060]먼지[/color]에 도달함 [color=#ffff50]" + str(data.dust) + "[/color]"
		
	elif data.has("loadable"):
		stringa = "[color=#a0a0a0][color=#a08060]먼지의 길[/color]을 걸어라..."
	else:
		stringa = "[color=#a08080]오 고대의 망자여..."
	$Start / ButtonLabel.bbcode_text = stringa
	
		
func get_character_description(data):
	var stringa = "[color=#c0c0c0]"
	
	
	
	if data.has("title_god") == false:
		data.title_god = data.God.name
	stringa += "[color=#ffff50]" + data.title_name + "[/color]"
	stringa += " " + data.title_race + "\n" + get_base_classe(data) + " " + data.title_god
	stringa += "\n\n"
	
	stringa += "[color=#ffa000]영광 " + str(int(data.level)) + "[/color]"
	
	stringa += "\n\n"
	
	stringa = stringa + "[color=#ff8080]체력[/color] " + "[color=#ffff50]" + str(int(data.HP_max)) + "[/color]"
	stringa = stringa + "  [color=#20ff20]속도[/color] " + "[color=#ffff50]" + str(int(data.SPEED + (data.DEX * 2))) + "[/color]"
	stringa = stringa + "\n\n[color=#ff7050]힘[/color] " + "[color=#ffff50]" + str(int(data.STR)) + "[/color]"
	stringa = stringa + "  [color=#50ff70]민첩[/color] " + "[color=#ffff50]" + str(int(data.DEX)) + "[/color]"
	stringa = stringa + "  [color=#c050ff]의지[/color] " + "[color=#ffff50]" + str(int(data.WIL)) + "[/color]"
	
	stringa += "\n\n"
	
	stringa += write_equipment(data, "weapon_main")
	stringa += write_equipment(data, "weapon_off")
	stringa += write_equipment(data, "armor_head")
	stringa += write_equipment(data, "armor_chest")
	stringa += write_equipment(data, "armor_hands")
	stringa += write_equipment(data, "armor_legs")
	
	stringa += "\n"
	for key in data.abilities:
		var trait = data.abilities[key]
		if trait.generic == false:
			stringa += trait.Name + " " + str(trait.Level)
			stringa += "\n"
		
	stringa += "\n"
	stringa += write_death(data.score_data)
	
	stringa += "[/color]"
	
	
	return stringa

func get_base_classe(data):
	var stringa = "nomad"
	for key in data.abilities:
		var trait = data.abilities[key]
		if trait.generic == true:
			if trait.organize == "class":
				stringa = trait.Name
	for key in data.abilities:
		var trait = data.abilities[key]
		if trait.generic == true:
			if trait.organize == "prestige":
				stringa += " " + trait.Name
	return stringa


func write_equipment(data, key):
	var stringa = ""
	if data[key] != null:
		
		stringa += data[key].name
		
		stringa += "\n"
	return stringa


func write_death(data):
	var stringa = ""
	
	if data.has("cycle") == false:
		stringa += cycler.int_to_cycle_name(1)
	else:
		stringa += cycler.int_to_cycle_name(data.cycle)
	stringa += "\n\n"
	
	if data.condition == "death":
		stringa += "사인: " + data.killer_name + "..."
	
		stringa += "\n\n[img]" + data.killer_sprite + "[/img]"
	
	elif data.condition == "victory":
		stringa += "[color=#ff3000]승리![/color]"
		stringa += "\n\n[img]res://Ham_Sprite/Environment/AstrolithExit.png[/img]"
	return stringa


func delete_selected():
	if graveyard_var.EXISTS == true:
		var target = button_selected
		if button_hovered != null:
			target = button_hovered
	
		if target != null:
		
		
			if buttons.size() > 1:
				var index = buttons.find(target)
				if target == buttons[buttons.size() - 1]:
					button_selected = buttons[0]
				else:
					button_selected = buttons[index + 1]
			else:
				button_selected = null
				button_hovered = null
				
		
			Global.sound.new_sound("Click")
			var key = target.data.title_name
			graveyard.erase_key(key)
			graveyard_var = graveyard.loadData()
			print(key + " erased from choices")
			buttons.erase(target)
			target.queue_free()
		
			update_title()
			update_deckbuttons()
	
		if button_selected != null:
			$Control / Sprite.visible = true
			update_selected(button_selected.data)
		else:
			$Control / Sprite.visible = false
		



func set_player_sheet(data):
	var saved_game = cloner.clone_dict(data)
	
	StatePlayerSheet.POINTS = saved_game.POINTS
	StatePlayerSheet.POINTS_TRAITS = saved_game.POINTS_TRAITS
	StatePlayerSheet.xp = saved_game.xp
	StatePlayerSheet.xp_needed = saved_game.xp_needed
	StatePlayerSheet.level = saved_game.level
	StatePlayerSheet.God = saved_game.God
	StatePlayerSheet.ELEMENTS = saved_game.ELEMENTS
	
	StatePlayerSheet.score_data = saved_game.score_data
	
	StatePlayerSheet.title_name = saved_game.title_name
	StatePlayerSheet.RACE = saved_game.RACE
	StatePlayerSheet.sprite_skin = saved_game.sprite_skin
	StatePlayerSheet.HP_max = float(saved_game.HP_max)
	StatePlayerSheet.HP = StatePlayerSheet.HP_max
	StatePlayerSheet.STR = float(saved_game.STR)
	StatePlayerSheet.DEX = float(saved_game.DEX)
	StatePlayerSheet.WIL = float(saved_game.WIL)
	StatePlayerSheet.SPEED = float(saved_game.SPEED)
	StatePlayerSheet.title_race = saved_game.title_race
	StatePlayerSheet.title_class = saved_game.title_class
	
	StatePlayerSheet.bag = []
	for item in saved_game.bag:
		StatePlayerSheet.bag.append(cloner.clone_dict(item))
	
	StatePlayerSheet.abilities = {
		
	}
	
	for key in saved_game.abilities:
		StatePlayerSheet.abilities[key] = cloner.clone_dict(saved_game.abilities[key])
	
	StatePlayerSheet.invokes = {}
	for key in saved_game.invokes:
		StatePlayerSheet.invokes[key] = cloner.clone_dict(saved_game.invokes[key])
	
	
	StatePlayerSheet.weapon_main = equip("weapon_main", saved_game)
	StatePlayerSheet.weapon_off = equip("weapon_off", saved_game)
	StatePlayerSheet.armor_chest = equip("armor_chest", saved_game)
	StatePlayerSheet.armor_hands = equip("armor_hands", saved_game)
	StatePlayerSheet.armor_head = equip("armor_head", saved_game)
	StatePlayerSheet.armor_legs = equip("armor_legs", saved_game)

	


func equip(label, dict):
	var item = null
	if dict[label] != null:
			item = cloner.clone_dict(dict[label])
	
	return item

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
		if event.is_action_pressed("enter"):
			if button_selected != null:
				if button_selected.data.has("loadable"):
					start()
		
				
					
						
						
		if event.is_action_pressed("gamepad_b"):
				if ToolSettings.settings_data.gamepad_mode == "full":
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
	update_selected(button_selected.data)

func quit():
	if scene_disabled == false:
		scene_disabled = true
		StateWorld.continent.delete()
		StateWorld.type = "none"
		Global.universal.transition("first")

func start():
	if scene_disabled == false and graveyard_var.EXISTS == true:
		if button_selected.data.has("loadable"):
			scene_disabled = true
			Global.selected_maqbara = button_selected.data.title_name
			StateWorld.restart()
			Global.sound.new_sound("Wave")
			Global.universal.transition("game")

func _on_Quit_pressed():
	quit()


func _on_Quit_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Delete_pressed():
	delete_selected()


func _on_Start_pressed():
	start()


func update_highlight():
	
	for button in buttons:
		if button != button_selected and button != button_hovered:
			button.modulate = Color(0.5, 0.1, 0.1, 1)
			if button.data.has("loadable"):
				button.modulate = Color(0.5, 0.5, 0.5, 1)
				if button.data.has("viewed"):
					if button.data.viewed == false:
						button.modulate = Color(0.1, 0.5, 0.5, 1)
		else:
			button.modulate = Color(1, 1, 1, 1)
		
		if $TextEdit.text != "" and $TextEdit.text != "검색...":
			var data = button.data
			var searched_text = get_character_description(data)
			if $TextEdit.text in textstrip.strip_bbcode(translate.element(searched_text)).to_lower():
					pass
			else:
					button.modulate = Color(0.2, 0.1, 0.1, 1)

func _on_TextEdit_text_changed(_new_text):
	var caret_location = $TextEdit.caret_position
	$TextEdit.text = $TextEdit.text.to_lower()
	$TextEdit.caret_position = caret_location
	update_highlight()


func _on_TextEdit_focus_entered():
	$TextEdit.text = ""

func setup_deckbuttons():
	update_deckbuttons()
	Global.universal.deck.deckbutton_selected = null
	Global.universal.deck.index_x = 0
	Global.universal.deck.index_y = 0
	Global.universal.deck.set_first_button()

func update_deckbuttons():
	Global.universal.deck.deckbuttons = []
	for button in buttons:
		while button.index_x >= Global.universal.deck.deckbuttons.size():
			Global.universal.deck.deckbuttons.append([])
		Global.universal.deck.deckbuttons[button.index_x].append(button)
	
	Global.universal.deck.deckbuttons.append([$Start, $Delete, $Quit])

