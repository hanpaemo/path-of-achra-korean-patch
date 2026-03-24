extends Node2D






var width = 11

var x = 0
var y = 0

var button_selected = null
var scene_disabled = false
var button_hovered = null

var buttons = []
onready var class_data = loader.load_data("res://Data/Table_Classes.json")


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
		Global.armory_selected = "none"
	
	
	if Global.armory_selected != "none":
		$RichTextLabel3.bbcode_text = "[color=#c0c0c0]보이는 보물..."
	
	create_buttons()
	setup_deckbuttons()
	update_selected()


func create_buttons():
	
	var list_array = compose_lists()


	for list in list_array:
		spawn_button(list)
		
		

	
	if Global.armory_selected == "none":
		button_selected = buttons[0]





func update_selected():
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
	
	update_highlight()



func write_button(button):
	$Sprite.texture = load(button.data.sprite)
	
	if button.type == "weapon":
		write_weapon(button.data)
		
	elif button.type == "armor":
		write_armor(button.data)

func write_weapon(data):
	var stringa = data.name
	var weapon = data
	stringa += "\n\n"
	stringa += "[color=#707070]"
	stringa += data.rumor
	stringa += ".."
	
	if data.rarity >= 2:
		stringa += "에서 발견: [color=#9000a0]공허[/color]"
	
	stringa += "[/color]"
	
	
	
	stringa += "\n\n[color=#ffa050]" + str(weapon.acc * 10) + " [color=#a0a0a0]명중률[/color][/color]"
	stringa += "\n[color=#ff8030]" + str(weapon.dmg * 10) + " [color=#a0a0a0]명중[/color][/color]"
	stringa += " " + translate.damage_type(weapon["dmgtype"])
	stringa = stringa + "\n[color=#5050ff]" + str(weapon.arm) + " [color=#a0a0a0]방어[/color][/color]"
	stringa += "\n"
	if weapon != null:
		if translate.is_bare_fist(weapon) == true:
	
			stringa += translate.get_bare_fist_text()
			stringa += "\n"
	
	
	
	
	stringa = stringa + "\n[color=#c0c0c0]" + str(weapon.range) + "[/color] [color=#a0a0a0]사거리[/color] "
	
	
	
	stringa = stringa + "\n"
	

		
	stringa = stringa + "\n[color=#ff0000]" + str(weapon.weight) + " [/color][color=#a0a0a0]하중[/color]"
	stringa = stringa + "\n[color=#ff0000]" + str(weapon.size) + " [/color][color=#a0a0a0]무기 크기[/color]"
	

	stringa += "\n"
	var typelist = ["slash", "blunt", "pierce", "fire", "ice", "poison", "lightning", "death", "psychic", "astral", "blood"]
	for label in typelist:
		var resist = weapon["resist_" + label]
		if resist != 0:
				stringa += "\n"
				stringa += translate.damage_type_to_color(label)
				stringa += "저항 "
				stringa += "[/color]"
				stringa += translate.damage_type(label)
				stringa += translate.value_to_color(resist)
				stringa += " " + str(resist) + "%"
				stringa += "[/color]"
	
	stringa += translate.get_shield_or_aoe_text(weapon)
	
		
			
			
			
	

		
		
		
	
	stringa = stringa + "\n"

	
		
	for trait in weapon.abilities:
			if trait != "none":
				var traitreal = LTraitsGeneric.trait_data[trait]
				
				stringa = stringa + "\n[img]" + traitreal.sprite + "[/img]"
			
				stringa = stringa + "\n[color=#c0c0c0]" + traitreal.Description
				
				if traitreal.reference != "none":
					stringa += "\n\n"
					var abuff = LBuffs.buff_data[traitreal.reference]
					stringa += "[color=#707070]효과[/color]\n" + abuff.color + abuff.name + ": [/color]" + abuff.description
				
				
				
				stringa = stringa + "\n"
		
		
	
	if data.has("tile_name"):
		stringa += "\n...in " + data.tile_name + "  [img]" + data.tile_sprite + "[/img]"
	
	$RichTextLabel.bbcode_text = stringa
	

func write_armor(data):
	var stringa = data.name
	var armor = data

	stringa += "\n\n"
	stringa += "[color=#707070]"
	stringa += data.rumor
	stringa += ".."
	
	if data.rarity >= 2:
		stringa += "에서 발견: [color=#9000a0]공허[/color]"
	stringa += "[/color]"
	
	
	stringa += "\n\n[color=#5050ff]" + "+" + str(armor.arm) + " [color=#a0a0a0]방어력[/color][/color]\n"
	stringa += "\n[color=#ff0000]" + "+" + str(armor.weight) + " [color=#a0a0a0]하중[/color][/color]"
		
		
		
	if armor.inflex > 0:
			stringa = stringa + "\n[color=#ff0000]" + "+" + str(armor.inflex) + " [color=#a0a0a0]경직[/color][/color]"
			
	else:
			stringa = stringa + "\n[color=#50ff50]" + str(armor.inflex) + "[/color] [color=#a0a0a0]경직[/color]"
		
	stringa = stringa + "\n"
		
	var typelist = ["slash", "blunt", "pierce", "fire", "ice", "poison", "lightning", "death", "psychic", "astral", "blood"]
	for label in typelist:
			var resist = armor["resist_" + label]
			if resist != 0:
				stringa += "\n"
				stringa += translate.damage_type_to_color(label)
				stringa += "저항 "
				stringa += "[/color]"
				stringa += translate.damage_type(label)
				stringa += translate.value_to_color(resist)
				stringa += " " + str(resist) + "%"
				stringa += "[/color]"
				
		
		
	stringa += "\n[color=#c0c0c0]"
	for trait in armor.abilities:
			if trait != "none":
				var traitreal = LTraitsGeneric.trait_data[trait]
				
				stringa = stringa + "\n[img]" + traitreal.sprite + "[/img]"
				
				stringa = stringa + "\n" + traitreal.Description
				
				if traitreal.reference != "none":
					stringa += "\n\n"
					var abuff = LBuffs.buff_data[traitreal.reference]
					stringa += "[color=#707070]효과[/color]\n" + abuff.color + abuff.name + ": [/color]" + abuff.description
			
			stringa = stringa + "\n"
				
				
				
	
	if data.has("tile_name"):
		stringa += "\n...in " + data.tile_name + "  [img]" + data.tile_sprite + "[/img]"
	
	$RichTextLabel.bbcode_text = stringa
	pass



func quit():
	if scene_disabled == false:
		scene_disabled = true
		Global.universal.transition(Global.universal.last_scene_label)



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


func _on_Quit_pressed():
	quit()


func _on_Quit_mouse_entered():
	Global.sound.new_sound("Hover")



func spawn_button(list):

	var columns = x / 32
	var columns_max = width
	
	
	for item in list:
			
		
			var b = Global.ButtonArmory.instance()
			get_node("Node2D").add_child(b)
			b.get_node("Sprite").texture = load(item.sprite)
			b.position = Vector2(x, y)
			b.data = item
			b.context = self
			buttons.append(b)
			
			
			if Global.armory_selected != "none":
				var tile = assign_tile(b.data.title)
				
				b.data["tile_name"] = tile.Name
				b.data["tile_sprite"] = tile.data.sprite
				b.get_node("Sprite2").texture = load(b.data.tile_sprite)
			
				
			b.index_x = columns
			b.type = item.type
			
			if item.rarity >= 2:
				b.get_node("Body").modulate = Color(0.2, 0, 0.3)
			
			
		
			x += 32
			columns += 1
			if columns > columns_max:
				columns = 0
				x = 0
				y += 32
			
			
				
				
			
			if Global.armory_selected == item.title:
				button_selected = b



func compose_lists():
	var list_armor = cloner.clone_array(LArm.armors)
	var list_weapon = cloner.clone_array(LWep.weapons)

	var to_erase = []
	
	for item in list_weapon:
		if item.rarity == 0 or check_if_visible(item.title) == false:
			to_erase.append(item)
	for item in to_erase: list_weapon.erase(item)
	
	for item in list_armor:
		if item.rarity == 0 or check_if_visible(item.title) == false:
			to_erase.append(item)
	for item in to_erase: list_armor.erase(item)
	


	var list = [list_weapon, list_armor]
	
			
	return list

func update_highlight():
	for button in buttons:
		if button != button_selected and button != button_hovered:
			button.modulate = Color(0.5, 0.5, 0.5, 1)
		else:
			button.modulate = Color(1, 1, 1, 1)
		
		
		var abuff = {
				"description": ""
			}
		var atrait = {
				"Description": "", 
				"reference": "none"
			}
		
		for trait in button.data.abilities:
			if trait != "none":
					atrait = LTraitsGeneric.trait_data[trait]
		
		if atrait.reference != "none":
			abuff = LBuffs.buff_data[atrait.reference]
		
		if $TextEdit.text != "" and $TextEdit.text != "검색...":
				if $TextEdit.text in textstrip.strip_bbcode(atrait.Description).to_lower():
					pass
				elif $TextEdit.text in textstrip.strip_bbcode(abuff.description).to_lower() and abuff.description != "":
					pass
				elif $TextEdit.text in textstrip.strip_bbcode(button.data.name).to_lower():
					pass
				elif $TextEdit.text in textstrip.strip_bbcode(button.data.type).to_lower():
					pass
				elif button.data.type == "weapon":
					if $TextEdit.text in textstrip.strip_bbcode(button.data.dmgtype).to_lower():
						pass
					elif $TextEdit.text in textstrip.strip_bbcode(translate.get_shield_or_aoe_text(button.data)).to_lower():
						pass
					elif translate.is_bare_fist(button.data) == true and $TextEdit.text in textstrip.strip_bbcode(translate.get_bare_fist_text()).to_lower():
						pass
					
					else:
						button.modulate = Color(0.1, 0.1, 0.1, 1)
				
				
				
				else:
					button.modulate = Color(0.1, 0.1, 0.1, 1)

func assign_tile(title):
	var assigned_tile = null
	if Global.armory_selected != "none":
		for tile in Global.continent.get_next_tiles():
			for item in tile.items:
				if title == item.title:
					assigned_tile = tile
	
	return assigned_tile
	
	
func check_if_visible(title):
	var boola = true
	if Global.armory_selected != "none":
		boola = false
		for tile in Global.continent.get_next_tiles():
			for item in tile.items:
				if title == item.title:
					boola = true
				
	return boola


func _on_TextEdit_text_changed(_new_text):
	var caret_location = $TextEdit.caret_position
	$TextEdit.text = $TextEdit.text.to_lower()
	$TextEdit.caret_position = caret_location
	update_highlight()




func _on_TextEdit_focus_entered():
	$TextEdit.text = ""


func _on_TextEdit_focus_exited():
	pass

func setup_deckbuttons():
	if Global.universal.deck.allowed == true:
		Global.universal.deck.deckbuttons = [[], [], [], [], [], [], [], [], [], [], [], [], 
	[$Quit]]
		Global.universal.deck.deckbutton_selected = null
		for button in buttons:
			Global.universal.deck.deckbuttons[button.index_x].append(button)
	
	
		Global.universal.deck.index_x = 0
		Global.universal.deck.index_y = 0
		Global.universal.deck.set_first_button()
