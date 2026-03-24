extends Node2D


var button_selected = null
var scene_disabled = false
var button_hovered = null

var buttons = []


var type = "powers"

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
	create_buttons()
	setup_deckbuttons()
	update_selected()


func update_selected():
	if button_hovered == null:
		if button_selected != null:
			write_button(button_selected)
	else:
		write_button(button_hovered)
	
	
	update_highlight()

func update_highlight():
	for button in buttons:
		if button != button_selected and button != button_hovered:
			button.modulate = Color(0.5, 0.5, 0.5, 1)
		else:
			button.modulate = Color(1, 1, 1, 1)
		
		if button.type == "power":
			if $TextEdit.text != "" and $TextEdit.text != "검색...":
		
		
				var abuff = {
				"description": ""
			}
				if button.data.reference != "none":
					abuff = LBuffs.buff_data[button.data.reference]
				
				if $TextEdit.text in textstrip.strip_bbcode(button.data.Description).to_lower():
					pass
				elif $TextEdit.text in textstrip.strip_bbcode(abuff.description).to_lower() and abuff.description != "":
					pass
				elif $TextEdit.text in textstrip.strip_bbcode(button.data.Name).to_lower():
					pass
				elif $TextEdit.text in textstrip.strip_bbcode(translate.element(button.data.Element)).to_lower():
					pass
				else:
					button.modulate = Color(0.2, 0.1, 0.1, 1)
		
		if button.type == "prestige":
			if $TextEdit.text != "" and $TextEdit.text != "검색...":
		
		
				var abuff = {
				"description": ""
			}
				if button.data.reference != "none":
					abuff = LBuffs.buff_data[button.data.reference]
				
				if $TextEdit.text in textstrip.strip_bbcode(button.data.Description).to_lower():
					pass
				elif $TextEdit.text in textstrip.strip_bbcode(abuff.description).to_lower() and abuff.description != "":
					pass
				elif $TextEdit.text in textstrip.strip_bbcode(button.data.Name).to_lower():
					pass
				elif $TextEdit.text in textstrip.strip_bbcode(prestige.trans_prestige_to_requirement_text(button.data)).to_lower():
					pass
				else:
					button.modulate = Color(0.2, 0.1, 0.1, 1)
		


func write_button(button):
	var data = button.data
	
	var stringa = "[color=#c0c0c0]" + data.Name
	if ToolSettings.settings_data.feats.has(data.title):
			stringa += "   "
			stringa += "[color=#707070]~승리~[/color]"
	
	stringa += "\n"
	
	stringa += "\n[img]" + data.sprite + "[/img]"

	if button.type == "power":
		stringa += "\n\n비용 [color=#ffff50]" + str(data.cost) + "[/color], "
		stringa += translate.element(data.Element)
	else:
		stringa += "\n\n" + prestige.trans_prestige_to_requirement_text(data)

	
	stringa += "\n\n" + data.Description
	
	if data.reference != "none":
		stringa += "\n\n"
		var abuff = LBuffs.buff_data[data.reference]
		stringa += "[color=#707070]효과[/color]\n" + abuff.color + abuff.name + ": [/color]" + abuff.description
	
	
	
	
	$RichTextLabel.bbcode_text = stringa



func create_buttons():
	var powers = cloner.clone_dict(LTraits.trait_data)
	var x = 0
	var y = 0
	var columns = 0
	var columns_max = 12
	var first = true
	
	if type == "powers":
		for key in powers:
			var power = powers[key]
			if power.ready == true:
			
		
				var b = Global.ButtonAbilityBook.instance()
				get_node("Node2D").add_child(b)
				b.get_node("Sprite").texture = load(power.sprite)
				b.position = Vector2(x, y)
				b.data = power
				b.context = self
				buttons.append(b)
				b.index_x = columns
				b.type = "power"
		
				x += 32
				columns += 1
				if columns > columns_max:
					columns = 0
					x = 0
					y += 32
			
				if first == true:
					button_selected = b
					first = false
	columns = 0
	x = 0
	y += 64
	if type == "powers":
		powers = LTraitsGeneric.prestige_list
		for element in powers:
			var power = cloner.clone_dict(element)
		
			
		
			var b = Global.ButtonAbilityBook.instance()
			get_node("Node2D").add_child(b)
			b.get_node("Sprite").texture = load(power.sprite)
			b.position = Vector2(x, y)
			b.data = power
			b.context = self
			buttons.append(b)
			b.index_x = columns
			if ToolSettings.settings_data.feats.has(power.title) and ToolSettings.settings_data.victory_markers == true:
				
				b.get_node("victory").visible = true
		
		
				
				
			b.type = "prestige"
		
			x += 32
			columns += 1
			if columns > columns_max:
				columns = 0
				x = 0
				y += 32
			
			if first == true:
				button_selected = b
				first = false



func quit():
	if scene_disabled == false:
		scene_disabled = true
		Global.universal.transition("start")

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


func _on_TextEdit_text_changed(_new_text):
	var caret_location = $TextEdit.caret_position
	$TextEdit.text = $TextEdit.text.to_lower()
	$TextEdit.caret_position = caret_location
	update_highlight()
func _on_TextEdit_focus_entered():
	$TextEdit.text = ""

func _on_Quit_mouse_entered():
	Global.sound.new_sound("Hover")




func setup_deckbuttons():
	if Global.universal.deck.allowed == true:
		Global.universal.deck.deckbuttons = [[], [], [], [], [], [], [], [], [], [], [], [], [], 
	[$Quit]]
		Global.universal.deck.deckbutton_selected = null
		var n = 0
		for button in buttons:
			n += 1
			if n == 90:
				Global.universal.deck.deckbuttons[button.index_x + 1].append(null)
			Global.universal.deck.deckbuttons[button.index_x].append(button)
	
	
		Global.universal.deck.index_x = 0
		Global.universal.deck.index_y = 0
		Global.universal.deck.set_first_button()
