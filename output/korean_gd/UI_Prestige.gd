extends Node2D

onready var game = Global.game
onready var ui = game.get_node("UI")



var buttons_all = []
var button_hovered = null
var button_selected = null

var is_typing = false

var unlocked = []
var all = []
var buttons_tab = []

var popup_visible = false


var auto_buffer = 0
var auto_buffer_max = 15

func _process(_delta):
	if Input.is_action_pressed("tab"):
		auto_buffer += 1
		if auto_buffer >= auto_buffer_max:
			auto_buffer = 0
			if Input.is_action_pressed("alt") == false and Input.is_action_pressed("shift") == false:
				if buttons_all.size() > 0:
					cycle_selection()
	else:
		auto_buffer = 0

func cycle_selection():
	var index = 0
	for n in buttons_all.size():
		if buttons_all[n] == button_selected:
			if n == buttons_all.size() - 1:
				index = 0
			else:
				index = n + 1
	button_selected = buttons_all[index]
	button_hovered = button_selected
	Global.sound.new_sound("Hover")
	highlight()
	write_description(button_selected.trait, button_selected)


func _ready():
	pass

func initiate():
	$Control / RichTextLabel2.bbcode_text = write_elements()
	for window in ui.get_open_windows():
		window.close()
	ui.window_prestige = get_node(".")
	create_buttons()
	if unlocked.size() > 0:
		button_selected = unlocked[0]
	else:
		button_selected = all[0]
	highlight()
	write_description(button_selected.trait, button_selected)
	setup_deckbuttons()


func create_buttons():

	var available_keys = []
	for trait in prestige.look_for_prestige(Global.Player.get_traits()):
		available_keys.append(trait.title)
	
	var pos = $Control / Generic.global_position
	var index_x = 1
	for key in LTraitsGeneric.trait_data:
		var trait = LTraitsGeneric.trait_data[key]
		if trait.organize == "prestige":
			var b = Global.ButtonTraitNode.instance()
			add_child(b)
			b.global_position = pos
			b.trait = trait
			b.context = get_node(".")
			b.for_prestige_ui = true
			b.index_x = index_x
			
			
			if ToolSettings.settings_data.feats.has(trait.title):
				pass
				
				
			
			buttons_all.append(b)
			b.create()
			
			buttons_tab.append(b)
			all.append(b)
			if available_keys.has(trait.title) == false:
				
				b.modulate = Color(0.3, 0.3, 0.3, 1)
			else:
				unlocked.append(b)
			
			pos.x += 32
			index_x += 1
			if pos.x > 320:
				index_x = 1
				pos.x = 64
				pos.y += 32
				

func highlight():
	if button_selected != null:
		$Select.position = button_selected.get_node("Button").get_global_position()
	for button in all:
		button.get_node("Button").mouse_filter = Control.MOUSE_FILTER_STOP
		if ToolSettings.settings_data.feats.has(button.trait.title) and ToolSettings.settings_data.victory_markers == true:
			button.get_node("victory").visible = true
		else:
			button.get_node("victory").visible = false
	if popup_visible == true:
		show_popup(button_selected)
		for button in all:
			if button != button_selected:
				button.get_node("Button").mouse_filter = Control.MOUSE_FILTER_IGNORE
				
	else:
		hide_popup()
	update_deckbuttons()
	
func highlight_typed_buttons():
	if $TextEdit.text != "" and $TextEdit.text != "검색...":
		
		for button in buttons_all:
			var abuff = {
				"description": ""
			}
			if button.trait.reference != "none":
				abuff = LBuffs.buff_data[button.trait.reference]
			button.modulate = Color(1, 1, 1, 1)
			
			if $TextEdit.text in textstrip.strip_bbcode(button.trait.Description).to_lower():
				pass
			elif $TextEdit.text in textstrip.strip_bbcode(abuff.description).to_lower() and abuff.description != "":
				pass
			elif $TextEdit.text in textstrip.strip_bbcode(prestige.trans_prestige_to_requirement_text(button.trait)).to_lower():
				pass
			elif $TextEdit.text in textstrip.strip_bbcode(button.trait.Name).to_lower():
				pass
			
			else:
				button.modulate = Color(0.3, 0.3, 0.3, 1)
		
			
		
			
			
	else:
		for button in buttons_all:
			button.modulate = Color(0.3, 0.3, 0.3, 1)
		for button in unlocked:
			button.modulate = Color(1, 1, 1, 1)

func write_description(trait, _button):
	$Description / Trait_Info_Pic.texture = load(trait.sprite)
	var stringa = ""
	if trait != null:
		
		
		stringa += "- " + prestige.trans_prestige_to_requirement_text(trait)
		
		
		
		stringa += "\n\n\n"
		stringa += trait.Name
		if ToolSettings.settings_data.feats.has(trait.title):
			stringa += "   "
			stringa += "[color=#707070]~승리~[/color]"
		
		stringa += ""
		stringa += "\n\n[img]" + str(trait.sprite) + "[/img]"
		stringa += "\n\n"
		stringa += trait.Description

		if trait.reference != "none":
			stringa += "\n\n"
			var abuff = LBuffs.buff_data[trait.reference]
			stringa += "[color=#707070]효과[/color]\n" + abuff.color + abuff.name + ": [/color]" + abuff.description

	

	stringa = "[color=#c0c0c0]" + stringa
	
	
	
	$Description / RichTextLabel.bbcode_text = stringa
	

func learn_prestige(button):
	if button.trait != null:
		if unlocked.has(button):
			prestige.add_prestige(button.trait)
			Global.sound.new_sound("Invoke")
			ui.open_traits()

func close():
	Global.universal.deck.reset_buttons()
	if ui.window_traits != null:
		ui.setup_deckbuttons()
	ui.window_prestige = null
	queue_free()

func _input(event):
	if is_typing == false:
		input_if_not_typing(event)
	
func input_if_not_typing(event):
	if event.is_action_pressed("escape") or event.is_action_pressed("r") or event.is_action_pressed("mouse_right"):
		ui.open_traits()
	if event.is_action_pressed("1"):
		if button_hovered != null:
			learn_prestige(button_hovered)
		else:
			learn_prestige(button_selected)
	
	if event.is_action_pressed("tab"):
			if Input.is_action_pressed("alt") == false and Input.is_action_pressed("shift") == false:
				if buttons_all.size() > 0:
					cycle_selection()
	
	if event.is_action_pressed("gamepad_b"):
			if ToolSettings.settings_data.gamepad_mode == "full":
					cycle_selection()
					update_deck_selected()
	if event.is_action_pressed("gamepad_x"):
		if ToolSettings.settings_data.gamepad_mode == "full":
			close_popup()
			update_deck_selected()
	if event.is_action_pressed("gamepad_y"):
		if ToolSettings.settings_data.gamepad_mode == "full":
			ui.open_traits()
	
	Global.universal.deck.input_handler(event)

func write_elements():
	var stringa = "[color=#c0c0c0]"
	if Global.Player.ELEMENTS.size() >= 1:
		stringa += translate.element(Global.Player.ELEMENTS[0]) + " " + str(translate.element_to_points(Global.Player.ELEMENTS[0]))
		if Global.Player.ELEMENTS.size() >= 2:
			stringa += " / " + translate.element(Global.Player.ELEMENTS[1]) + " " + str(translate.element_to_points(Global.Player.ELEMENTS[1]))
			if Global.Player.ELEMENTS.size() >= 3:
				stringa += " / " + translate.element(Global.Player.ELEMENTS[2]) + " " + str(translate.element_to_points(Global.Player.ELEMENTS[2]))
		
			
	else:
		stringa += "[color=#707070]능력을 획득하여 해금하라...[/color]"
	
	
	
	
	return stringa


func hide_popup():
	
	$PopupLayer / Popup / Button_Popup_Background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$PopupLayer / Popup.position = Vector2(900, 0)
	


func show_popup(button):
	
	$PopupLayer / Popup / Button_Popup_Background.mouse_filter = Control.MOUSE_FILTER_STOP
	var button_position = button.get_global_position()
	$PopupLayer / Popup.position = button_position
	
	
	var stringa = "[center]"
	stringa += button.trait.Name
	
	
	
	$PopupLayer / Popup / RichTextLabel.bbcode_text = stringa
	
	stringa = "[center]"
	if unlocked.has(button) == true:
		stringa += "[color=#c0c0c0][[color=#ffff50]1[/color]] Become![/color]"
		$PopupLayer / Popup / Button_Learn.mouse_filter = Control.MOUSE_FILTER_STOP
		$PopupLayer / Popup / Button_Learn / text.bbcode_text = stringa
	else:
		stringa += "[color=#505050]requirements unmet[/color]"
		$PopupLayer / Popup / Button_Learn.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$PopupLayer / Popup / Button_Learn / text.bbcode_text = stringa

	if button_position.x >= 225:
		$PopupLayer / Popup.position.x -= 192

func close_popup():
	if buttons_tab.has(button_selected) == true:
		pass
	else:
		button_selected = buttons_tab[0]
	if popup_visible == false:
		popup_visible = true
	else:
		popup_visible = false
	Global.sound.new_sound("Hover")
	$PopupLayer / Popup / Button_Learn.visible = true
	button_hovered = button_selected
	highlight()
	write_description(button_selected.trait, button_selected)


func _on_Button_Quit_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Button_Quit_mouse_exited():
	Global.sound.new_sound("Hover")


func _on_Button_Quit_pressed():
	ui.open_traits()


func _on_Button_Learn_mouse_exited():
	pass


func _on_Button_Learn_mouse_entered():
	pass


func _on_Button_Learn_pressed():
	learn_prestige(button_selected)


func _on_Button_Popup_Background_pressed():
	close_popup()


func _on_TextEdit_text_changed(_new_text):
	var caret_location = $TextEdit.caret_position
	$TextEdit.text = $TextEdit.text.to_lower()
	$TextEdit.caret_position = caret_location
	highlight_typed_buttons()


func _on_TextEdit_focus_entered():
	is_typing = true
	$TextEdit.text = ""


func _on_TextEdit_focus_exited():
	is_typing = false

func setup_deckbuttons():
	Global.universal.deck.deckbutton_selected = null
	Global.universal.deck.index_x = 0
	Global.universal.deck.index_y = 0
	
	update_deckbuttons()
	
	Global.universal.deck.set_first_button()

func update_deckbuttons():
	Global.universal.deck.deckbuttons = [[$Control / Button_Quit]]
	if popup_visible == false:
		update_no_popup()
	else:
		update_popup()

func update_no_popup():
	
	Global.universal.deck.deckbuttons.append([])
	for button in buttons_all:
		while button.index_x >= Global.universal.deck.deckbuttons.size():
			Global.universal.deck.deckbuttons.append([])
		Global.universal.deck.deckbuttons[button.index_x].append(button)

func update_popup():
	Global.universal.deck.deckbuttons = [[$Control / Button_Quit], [$PopupLayer / Popup / Button_Learn]]


func update_deck_selected():
	var anode = button_selected
	
	if anode != null:
		var x = 0
		for array in Global.universal.deck.deckbuttons:
			var y = 0
			for button in array:
				
				if button == anode:
					Global.universal.deck.index_x = x
					Global.universal.deck.index_y = y
					
				y += 1
			x += 1
	
	else:
		Global.universal.deck.index_x = 0
		Global.universal.deck.index_y = 0
	
	if popup_visible == true:
		Global.universal.deck.index_x = 1
		Global.universal.deck.index_y = 0
	
	Global.universal.deck.set_first_button()
