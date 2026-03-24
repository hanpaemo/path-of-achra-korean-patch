extends Node2D


var buttons_all = [
]
var auto_buffer = 0
var buttons_known = []
var buttons_tree = []
var buttons_locked = []

var is_typing = false




var limit_known = 7
var known_count = 0
var limit_elements = 3

var buttons_tab = []

onready var game = Global.game
onready var ui = game.get_node("UI")

var button_selected = null
var button_hovered = null
var trait_selected = null

var popup_visible = false


var last_learned = ""

var info = cloner.clone_dict(LInfo.info_data)
onready var preset_buttons = [$Control / DEX / Button_DEX, $Control / STR / Button_STR, $Control / WIL / Button_WIL]

func initiate():
	for window in ui.get_open_windows():
		window.close()
	ui.window_traits = get_node(".")
	$Button_God / Sprite.texture = load(StatePlayerSheet.God.sprite)
	
	update()
	

func set_unlocked():
	for trait in LTraits.list_all:
		if Global.Player.TRAITS_UNLOCKED.has(trait.title):
			Global.Player.TRAITS_UNLOCKED.erase(trait.title)
	
	
	if Global.Player.ELEMENTS.size() < limit_elements:
		for trait in LTraits.list_all:
			if Global.Player.TRAITS_UNLOCKED.has(trait.title) == false:
				confirm_unlock(trait.title)
	else:
		for trait in LTraits.list_all:
			if Global.Player.ELEMENTS.has(trait.Element) == true:
				confirm_unlock(trait.title)
				

func confirm_unlock(label):
	if known_count < limit_known:
		Global.Player.TRAITS_UNLOCKED.append(label)
	elif Global.Player.get_traits().has(label):
		Global.Player.TRAITS_UNLOCKED.append(label)
	
func update():
	set_known_count()
	set_unlocked()
	$elements.bbcode_text = write_elements()
	$points.bbcode_text = write_points()
	if button_selected != null:
		trait_selected = button_selected.trait.title
	button_selected = null
	for button in buttons_all:
		button.queue_free()
	buttons_all = []
	buttons_known = []
	buttons_tree = []
	buttons_locked = []
	
	
	create_known_buttons()
	create_stalks()
	create_generic_traits()
	
	
	dim_expensive_buttons()
	dim_typed_buttons()
	hide_locked_buttons()
	

	set_tab_buttons()
	
	
	if last_learned == "":
		if buttons_known.size() > 0:
			button_selected = buttons_known[0]
		elif buttons_all.size() > buttons_locked.size():
			var buttons_unlocked = []
			for button in buttons_all:
				if buttons_locked.has(button) == false:
					buttons_unlocked.append(button)
			button_selected = buttons_unlocked[0]
		elif buttons_all.size() > 0:
			button_selected = buttons_all[0]
	else:
		for button in buttons_all:
			if button.trait.title == last_learned:
				button_selected = button
		for button in buttons_known:
			if button.trait.title == last_learned:
				button_selected = button
				button_hovered = button_selected
	for button in buttons_all:
			if button.trait.title == trait_selected:
				button_selected = button
	for button in buttons_known:
			if button.trait.title == trait_selected:
				button_selected = button
	
	
	if button_hovered == null:
		button_hovered = button_selected
	else:
		button_selected = button_hovered
	
	if button_hovered != null:
		write_description(button_hovered.trait, button_hovered)
	update_prestige()
	highlight()
	
	
	
	
	
	$Control / STR / value.bbcode_text = "[right][color=#ffff50]" + str(Global.Player.get_total_STR()) + "[/color][/right]"
	$Control / DEX / value.bbcode_text = "[right][color=#ffff50]" + str(Global.Player.get_total_DEX()) + "[/color][/right]"
	$Control / WIL / value.bbcode_text = "[right][color=#ffff50]" + str(Global.Player.get_total_WIL()) + "[/color][/right]"
	
	
	setup_deckbuttons()
	pass

func update_prestige():
	print("prestige update!!!")
	var has_prestige = prestige.check()
	if has_prestige == false:
		$Control / Plus.visible = true
		$Control / Plus.modulate = Color(0.4, 0.4, 0.4, 0.5)
		var available = prestige.look_for_prestige(Global.Player.get_traits())
		if available.size() >= 1:
			$Control / PrestigeAlarm.visible = true
			$Control / Plus.modulate = Color(1, 1, 1, 1)
		else:
			$Control / PrestigeAlarm.visible = false
	else:
		$Control / Plus.visible = false
		$Control / PrestigeAlarm.visible = false

func set_known_count():
	var inta = 0
	for key in Global.Player.get_traits():
		var trait = Global.Player.get_traits()[key]
		if trait.generic == false:
			inta += 1
	
	known_count = inta
			

func set_tab_buttons():
	buttons_tab = []
	for button in buttons_tree:
		if buttons_locked.has(button) == false:
			buttons_tab.append(button)
	for button in buttons_known:
		if buttons_locked.has(button) == false:
			buttons_tab.append(button)
	

func hide_locked_buttons():
	for button in buttons_tree:
		if Global.Player.TRAITS_UNLOCKED.has(button.trait.title) == false:
			buttons_locked.append(button)
	for button in buttons_locked:
		button.modulate = Color(0.1, 0.1, 0.1, 1)
		

func dim_expensive_buttons():
	for button in buttons_tree:
		if button.trait.cost > Global.Player.POINTS_TRAITS:
			button.modulate = Color(0.6, 0.2, 0.2, 1)
		else:
			button.modulate = Color(1, 1, 1, 1)
	for button in buttons_known:
		if button.trait.cost > Global.Player.POINTS_TRAITS and button.trait.generic != true:
			button.modulate = Color(0.6, 0.2, 0.2, 1)
		else:
			button.modulate = Color(1, 1, 1, 1)

func dim_typed_buttons():
	if $TextEdit.text != "" and $TextEdit.text != "검색...":
		
		for button in buttons_tree:
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
			elif $TextEdit.text in textstrip.strip_bbcode(button.trait.Name).to_lower():
				pass
			else:
				button.modulate = Color(0.3, 0.3, 0.3, 1)
		
		for button in buttons_known:
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
			elif $TextEdit.text in textstrip.strip_bbcode(button.trait.Name).to_lower():
				pass
			else:
				button.modulate = Color(0.3, 0.3, 0.3, 1)
			
			
	else:
		pass
		
			
		
		

func learn_trait():
	var button = button_hovered
	
	if Global.Player.POINTS_TRAITS >= button.trait.cost and Global.Player.really_dead == false:
			
			effectmaker.create_effect_animated_ui_context(get_node("."), button.get_global_position(), "Click")
			
			add_trait(button.trait)
			
			
			
	
	


func add_trait(trait):
			Global.Player.POINTS_TRAITS -= trait.cost
			if Global.Player.abilities.has(trait.title):
				Global.Player.abilities[trait.title].Level += 1
				print("Trait leveled up!")
				last_learned = trait.title
			else:
				var new_trait = cloner.clone_dict(trait)
				var name = trait.title
				
		
			
				Global.Player.abilities[name] = new_trait
				last_learned = trait.title
				print("Trait learned")
				if Global.Player.ELEMENTS.has(trait.Element) == false:
					Global.Player.ELEMENTS.append(trait.Element)
					print(Global.Player.ELEMENTS)
	
			if Global.Player.POINTS_TRAITS < trait.cost:
				popup_visible = false
				
			
			Global.Player.update()
			update()
			event_learn.check(trait.title, trait.Name)
			update_deck_selected()

func press_learn():
	if button_hovered != null:
		if button_hovered.trait.generic == false and Global.Player.POINTS_TRAITS >= button_hovered.trait.cost:
			if Global.Player.ELEMENTS.has(button_hovered.trait.Element) or Global.Player.ELEMENTS.size() < limit_elements:
				if known_count < limit_known or Global.Player.get_traits().has(button_hovered.trait.title):
					learn_trait()

func gain_prestige(trait):
	Global.sound.new_sound("Invoke")
	var stringa = ""
	stringa += "[color=#c0c0c0]상위 직업 해금!\n\n전직: "
	stringa += trait.Name
	$PopupLayer / Popup2 / Label.bbcode_text = stringa
	$PopupLayer / Popup2 / Sprite.texture = load(trait.sprite)
	$PopupLayer / Popup2 / AnimationPlayer.play("FadeIn")

func create_known_buttons():
	var pos = $Known / Traits_First.global_position
	$Sprite.position = Vector2(pos.x - 16, pos.y)
	for key in Global.Player.abilities:
		var trait = Global.Player.abilities[key]
		if trait.generic == false:
			create_button(pos, trait, buttons_known)
			pos.x += 40
		elif trait.organize == "prestige":
			create_button($Control / Sprite.global_position, trait, buttons_known)
		
		
		
	for button in buttons_known:
		if button.trait.generic == false:
			button.get_node("Level").text = str(button.trait.Level)
			button.get_node("Level").visible = true
			button.get_node("LevelButton").visible = true
		button.get_node("background").visible = true
		
	$Sprite2.position = Vector2(pos.x + 16, pos.y)

func create_stalks():
	
	var pos = $Tree / Traits_Health.global_position
	var list = LTraits.list_health
	grow_stalk(pos, list)
	
		
		
	
	pos = $Tree / Traits_Fire.global_position
	list = LTraits.list_fire
	grow_stalk(pos, list)

	pos = $Tree / Traits_Lightning.global_position
	list = LTraits.list_lightning
	grow_stalk(pos, list)

	pos = $Tree / Traits_Poison.global_position
	list = LTraits.list_poison
	grow_stalk(pos, list)

	pos = $Tree / Traits_Death.global_position
	list = LTraits.list_death
	grow_stalk(pos, list)
	
	pos = $Tree / Traits_Ice.global_position
	list = LTraits.list_ice
	grow_stalk(pos, list)
	
	pos = $Tree / Traits_Astral.global_position
	list = LTraits.list_astral
	grow_stalk(pos, list)
	
	pos = $Tree / Traits_Psychic.global_position
	list = LTraits.list_psychic
	grow_stalk(pos, list)
	
	pos = $Tree / Traits_Life.global_position
	list = LTraits.list_life
	grow_stalk(pos, list)
	
	
	pos = $Tree / Traits_Blood.global_position
	list = LTraits.list_blood
	grow_stalk(pos, list)

func grow_stalk(pos, list):
	for trait in list:
		if trait.ready == true:
			if Global.Player.abilities.has(trait.title) == false:
				create_button(pos, trait, buttons_tree)
				pos.y += 32

func create_generic_traits():
	var pos = $Control / Generic.global_position
	for key in Global.Player.get_traits():
		var trait = Global.Player.get_traits()[key]
		if trait.generic == true and trait.organize != "prestige":
			create_generic_button(pos, trait)
			pos.x += 32
			

func create_button(pos, trait, special_array):
	var b = Global.ButtonTraitNode.instance()
	add_child(b)
	b.global_position = pos
	b.trait = trait
	b.context = get_node(".")
	buttons_all.append(b)
	special_array.append(b)
	b.create()

func create_generic_button(pos, trait):
	var b = Global.ButtonTraitNode.instance()
	add_child(b)
	b.global_position = pos
	b.trait = trait
	b.context = get_node(".")
	buttons_all.append(b)
	b.create()


func highlight():
	$PopupLayer / Popup / Button_Learn.modulate = Color(1, 1, 1, 1)
	$PopupLayer / Popup / Button_Learn.mouse_filter = Control.MOUSE_FILTER_STOP
	
		
	
	if get_random_button_pool().size() < 1:
		$Control / ButtonRandom.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$Control / ButtonRandom.visible = false
		$Control / SpriteDice.visible = false
		$Control / SpriteDice2.visible = false
	else:
		$Control / ButtonRandom.mouse_filter = Control.MOUSE_FILTER_STOP
		$Control / ButtonRandom.visible = true
		$Control / SpriteDice.visible = true
		$Control / SpriteDice2.visible = true
	
	if popup_visible == false:
		hide_popup()
	
	for button in buttons_all:
		button.get_node("Button").modulate = Color(1, 1, 1, 1)
		if buttons_tree.has(button):
			button.get_node("Button").modulate = Color(0.7, 0.7, 0.7, 1)
		if button == button_selected:
			$Select.position = button.get_node("Button").get_global_position()
			
			if Global.Player.POINTS_TRAITS < button.trait.cost or buttons_locked.has(button):
				$PopupLayer / Popup / Button_Learn.modulate = Color(0.2, 0.2, 0.2, 1)
				
			if button.trait.generic == true:
				$PopupLayer / Popup / Button_Learn.modulate = Color(1, 1, 1, 1)
		
		
				
			
	if button_selected == null:
		$PopupLayer / Popup / Button_Learn.modulate = Color(0.2, 0.2, 0.2, 1)
		
	
	if button_selected != button_hovered:
		if Global.Player.POINTS_TRAITS >= button_hovered.trait.cost:
			$PopupLayer / Popup / Button_Learn.modulate = Color(1, 1, 1, 1)
			
		else:
			$PopupLayer / Popup / Button_Learn.modulate = Color(0.2, 0.2, 0.2, 1)
			
		if button_hovered.trait.generic == true:
			$PopupLayer / Popup / Button_Learn.modulate = Color(1, 1, 1, 1)
	
	
	for button in buttons_all:
		if popup_visible == true:
			if button != button_selected:
				button.get_node("Button").mouse_filter = Control.MOUSE_FILTER_IGNORE
			else:
				button.get_node("Button").mouse_filter = Control.MOUSE_FILTER_STOP
				show_popup(button)
		else:
			button.get_node("Button").mouse_filter = Control.MOUSE_FILTER_STOP
	
	for button in preset_buttons:
		if popup_visible == true:
			button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		else:
			button.mouse_filter = Control.MOUSE_FILTER_STOP
	update_deckbuttons()
	

func hide_popup():
	
	$PopupLayer / Popup / Button_Popup_Background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$PopupLayer / Popup.position = Vector2(900, 0)
	$PopupLayer / CancelLoc.position = Vector2(900, 0)


func show_popup(button):
	
	$PopupLayer / Popup / Button_Popup_Background.mouse_filter = Control.MOUSE_FILTER_STOP
	var button_position = button.get_global_position()
	$PopupLayer / Popup.position = button_position
	$PopupLayer / CancelLoc.position = button_position
	
	var stringa = "[center]"
	stringa += button.trait.Name
	
	
	
	$PopupLayer / Popup / RichTextLabel.bbcode_text = stringa
	

	
	if button_position.x >= 225:
		$PopupLayer / Popup.position.x -= 128
	if button_position.y > 400:
		$PopupLayer / Popup.position.y -= 99

func write_description(trait, button):
	$Description / Trait_Info_Pic.texture = load(trait.sprite)
	var stringa = ""
	if trait != null:
		
		stringa += trait.Name
		
		
		if trait.generic == false:
			stringa += "\n\n"
			stringa += translate.element(trait.Element) + " [color=#808080]element[/color]"
			stringa += "\n\n"
			if Global.Player.abilities.has(trait.title):
				stringa += "[color=#808080]레벨 [/color]" + str(Global.Player.abilities[trait.title].Level)
			else:
				stringa += "[color=#808080]Unknown[/color]"
			
			stringa += "\n\n[color=#808080]Costs [color=#ffff00]"
			stringa += str(trait.cost)
			stringa += "[/color] to "
			if Global.Player.abilities.has(trait.title):
				stringa += "level up[/color]"
			else:
				stringa += "learn[/color]"
			
			
		else:
			stringa += "\n\n\n"
			match trait.organize:
				"prestige":
					stringa += "[color=#c0c0c0]상위 직업"
				"racial":
					stringa += "[color=#c0c0c0]문화"
				"god":
					stringa += "[color=#c0c0c0]신앙"
				"unit/item":
					stringa += "[color=#c0c0c0]아이템"
				"class":
					stringa += "[color=#c0c0c0]직업"
			stringa += "\n"
		stringa += "\n\n"
		stringa += trait.Description
	
		
	
	
	
	
		
		
	
	
	if trait.reference != "none":
		stringa += "\n\n"
		var abuff = LBuffs.buff_data[trait.reference]
		stringa += "[color=#707070]효과[/color]\n" + abuff.color + abuff.name + ": [/color]" + abuff.description
	
	
	if trait.generic == false:
		stringa += "\n\n\n" + translate.element_to_resist_description(trait.Element)

		
	
	
	stringa = "[color=#c0c0c0]" + stringa
	$Description / RichTextLabel.bbcode_text = stringa
	
	stringa = "[color=#a0a0a0][[color=#ffff50]1[/color]][/color] "
	if trait.generic == false:
		if Global.Player.abilities.has(trait.title):
			stringa += "[color=#c0c0c0]레벨 업[/color] "
		else:
			stringa += "[color=#c0c0c0]습득[/color] "
	stringa += " [color=#ff0000]-"
	stringa += str(trait.cost)
	stringa += "[/color]"
	stringa += "[color=#ffff00] / "
	stringa += str(Global.Player.POINTS_TRAITS)
	stringa += "[/color]"
	if trait.generic == false:
		
		$PopupLayer / Popup / Button_Learn.mouse_filter = Control.MOUSE_FILTER_STOP
		$PopupLayer / Popup / Button_Learn / text.bbcode_text = stringa
	else:
		$PopupLayer / Popup / Button_Learn.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$PopupLayer / Popup / Button_Learn / text.bbcode_text = "[color=#c0c0c0]상위 직업"
	
func write_elements():
	var stringa = "[color=#c0c0c0]"
	if Global.Player.ELEMENTS.size() >= 1:
		stringa += translate.element(Global.Player.ELEMENTS[0]) + " " + str(translate.element_to_points(Global.Player.ELEMENTS[0]))
		if Global.Player.ELEMENTS.size() >= 2:
			stringa += " / " + translate.element(Global.Player.ELEMENTS[1]) + " " + str(translate.element_to_points(Global.Player.ELEMENTS[1]))
			if Global.Player.ELEMENTS.size() >= 3:
				stringa += " / " + translate.element(Global.Player.ELEMENTS[2]) + " " + str(translate.element_to_points(Global.Player.ELEMENTS[2]))
		
			
	else:
		stringa += "[color=#707070]3개 원소에서 능력을 획득하라...[/color]"
	
	
	
	
	return stringa

func write_points():
	var stringa = ""
	stringa += "[color=#ffff30]"
	stringa += str(Global.Player.POINTS_TRAITS)
	stringa += "[/color]"
	stringa += " [color=#c0c0c0]포인트 사용 가능"
	return stringa

func close():
	Global.universal.deck.reset_buttons()
	ui.window_traits = null
	Global.universal.deck.setup_current_screen()
	queue_free()

func cycle_buttons_tab(inta):
	if buttons_tab.has(button_selected) == true:
		if popup_visible == false:
			popup_visible = true
		
		
		else:
			
			var index = 0
			for n in buttons_tab.size():
				var button = buttons_tab[n]
				if button_selected == button:
					index = n
			
			index += inta
			
			if index >= buttons_tab.size():
				index = 0
			if index < 0:
				index = buttons_tab.size() - 1
		
			button_selected = buttons_tab[index]
			button_hovered = buttons_tab[index]
			trait_selected = buttons_tab[index].trait.title
			
		Global.sound.new_sound("Hover")
		button_hovered = button_selected
		$PopupLayer / Popup / Button_Learn.visible = true
		highlight()
		write_description(button_selected.trait, button_selected)
	else:
		button_selected = buttons_tab[0]
		button_hovered = buttons_tab[0]
		trait_selected = buttons_tab[0]
		if popup_visible == false:
			popup_visible = true
		
		Global.sound.new_sound("Hover")
		button_hovered = button_selected
		$PopupLayer / Popup / Button_Learn.visible = true
		highlight()
		write_description(button_selected.trait, button_selected)

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



func _input(event):
	if is_typing == false and ui.window_prestige == null:
		input_if_not_typing(event)


func input_if_not_typing(event):
	if event.is_action_pressed("escape") or event.is_action_pressed("p") or event.is_action_pressed("mouse_right"):
		close()
	if event.is_action_pressed("r"):
		open_prestige()
	if event.is_action_pressed("1"):
		press_learn()
		close_prestige()

	if event.is_action_pressed("pass"):
		close_popup()
		close_prestige()
	if event.is_action_pressed("0"):
		random_power()
	
	if event.is_action_pressed("gamepad_b"):
			if ToolSettings.settings_data.gamepad_mode == "full":
					cycle_buttons_tab(1)
					close_prestige()
					update_deck_selected()
	if event.is_action_pressed("gamepad_x"):
		if ToolSettings.settings_data.gamepad_mode == "full":
			close_popup()
			update_deck_selected()
	if event.is_action_pressed("gamepad_y"):
		if ToolSettings.settings_data.gamepad_mode == "full":
			if popup_visible == true:
				close_popup()
			else:
				close()
	
	Global.universal.deck.input_handler(event)
	
	if event.is_action_pressed("tab"):
		if Input.is_action_pressed("alt") == false and Input.is_action_pressed("shift") == false:
			cycle_buttons_tab(1)
			close_prestige()
	if event.is_action_pressed("right"):
		cycle_buttons_tab(1)
	if event.is_action_pressed("down"):
		cycle_buttons_tab(1)
	if event.is_action_pressed("downright"):
		cycle_buttons_tab(1)
	if event.is_action_pressed("downleft"):
		cycle_buttons_tab(1)
		
	
	if event.is_action_pressed("target"):
		cycle_buttons_tab( - 1)
	if event.is_action_pressed("left"):
		cycle_buttons_tab( - 1)
	if event.is_action_pressed("up"):
		cycle_buttons_tab( - 1)
	if event.is_action_pressed("upleft"):
		cycle_buttons_tab( - 1)
	if event.is_action_pressed("upright"):
		cycle_buttons_tab( - 1)

func _on_Button_Quit_pressed():
	close()


func _on_Button_Learn_pressed():
	press_learn()
		
			


func _on_Button_Inventory_pressed():
	ui.open_inventory()


func _on_Button_God_pressed():
	ui.open_god()


func _on_Button_Inventory_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Button_God_mouse_entered():
	Global.sound.new_sound("Hover")

func _on_Button_Learn_mouse_entered():
	
	
	
	
	Global.sound.new_sound("Hover")


func _on_Button_Quit_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Button_Learn_mouse_exited():
	highlight()
	write_description(button_hovered.trait, button_hovered)





func _on_Button_STR_mouse_entered():
	button_hovered = null
	$PopupLayer / Popup / Button_Learn.visible = false
	$Description / Trait_Info_Pic.texture = null
	$Description / RichTextLabel.bbcode_text = "[color=#c0c0c0]" + info.STR.description


func _on_Button_STR_mouse_exited():
	button_hovered = button_selected
	$PopupLayer / Popup / Button_Learn.visible = true
	highlight()
	write_description(button_hovered.trait, button_hovered)


func _on_Button_DEX_mouse_entered():
	button_hovered = null
	$PopupLayer / Popup / Button_Learn.visible = false
	$Description / Trait_Info_Pic.texture = null
	$Description / RichTextLabel.bbcode_text = "[color=#c0c0c0]" + info.DEX.description


func _on_Button_DEX_mouse_exited():
	button_hovered = button_selected
	$PopupLayer / Popup / Button_Learn.visible = true
	highlight()
	write_description(button_hovered.trait, button_hovered)


func _on_Button_WIL_mouse_entered():
	button_hovered = null
	$PopupLayer / Popup / Button_Learn.visible = false
	$Description / Trait_Info_Pic.texture = null
	$Description / RichTextLabel.bbcode_text = "[color=#c0c0c0]" + info.WIL.description


func _on_Button_WIL_mouse_exited():
	button_hovered = button_selected
	$PopupLayer / Popup / Button_Learn.visible = true
	highlight()
	write_description(button_hovered.trait, button_hovered)


func _on_Timer_timeout():
	var event_list = ["tab", "target", "right", "down", "downright", "downleft", "left", "up", "upleft", "upright"]
	var label = ""
	for event in event_list:
		if Input.is_action_pressed(event):
			label = event
	if label != "":
		if auto_buffer < 6:
			auto_buffer += 1
		else:
			auto_input(label)
	
	else:
		auto_buffer = 0
		
func auto_input(label):
	
	if label == "tab":
		cycle_buttons_tab(1)
	if label == "right":
		cycle_buttons_tab(1)
	if label == "down":
		cycle_buttons_tab(1)
	if label == "downright":
		cycle_buttons_tab(1)
	if label == "downleft":
		cycle_buttons_tab(1)
		
	
	if label == "target":
		cycle_buttons_tab( - 1)
	if label == "left":
		cycle_buttons_tab( - 1)
	if label == "up":
		cycle_buttons_tab( - 1)
	if label == "upleft":
		cycle_buttons_tab( - 1)
	if label == "upright":
		cycle_buttons_tab( - 1)



func _on_Button_Popup_Background_pressed():
	close_popup()


func _on_Button_Prestige_mouse_entered():
	button_hovered = null
	$PopupLayer / Popup / Button_Learn.visible = false
	$Description / Trait_Info_Pic.texture = null
	$Description / RichTextLabel.bbcode_text = "[color=#c0c0c0]" + info.prestige.description


func _on_Button_Popup2_pressed():
	close_prestige()

func close_prestige():
	$PopupLayer / Popup2.modulate = Color(1, 1, 1, 0)
	$PopupLayer / Popup2 / Button_Popup2.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_Button_Prestige_pressed():
	open_prestige()
	

func open_prestige():
	var has_prestige = false
	for key in Global.Player.get_traits():
		var trait = Global.Player.get_traits()[key]
		if trait.generic == true:
			if trait.organize == "prestige":
				has_prestige = true
				has_prestige = true
	if has_prestige == false and Global.Player.really_dead == false:
		ui.open_prestige()


func _on_TextEdit_focus_entered():
	is_typing = true
	$TextEdit.text = ""


func _on_TextEdit_focus_exited():
	is_typing = false

func _on_TextEdit_text_changed(_new_text):
	var caret_location = $TextEdit.caret_position
	$TextEdit.text = $TextEdit.text.to_lower()
	$TextEdit.caret_position = caret_location
	
	dim_expensive_buttons()
	dim_typed_buttons()
	hide_locked_buttons()


func _on_ButtonRandom_mouse_entered():
	button_hovered = null
	$PopupLayer / Popup / Button_Learn.visible = false
	$Description / Trait_Info_Pic.texture = null
	$Description / RichTextLabel.bbcode_text = "[color=#c0c0c0][[color=#ffff50]0[/color]] 사용 가능한 원소에서 새 능력 무작위 습득\n\n능력 한도 시 보유 능력 무작위 레벨업[/color]"


func random_power():
	var random_button_pool = get_random_button_pool()
	
	
	if random_button_pool.size():
		
		var button = random_button_pool[Global.rng.randi_range(0, random_button_pool.size() - 1)]
		
		effectmaker.create_effect_animated_ui_context(get_node("."), button.get_global_position(), "Click")
		effectmaker.create_effect_animated_ui_context(get_node("."), $Control / ButtonRandom.get_global_position(), "Click")
		print("Learned randomly:" + button.trait.title)
		add_trait(button.trait)
		
	else:
		print("no random power, all available powers known or too expensive")
				

func get_random_button_pool():
	var random_button_pool = []
	for button in buttons_tree:
		
		if Global.Player.POINTS_TRAITS >= button.trait.cost:
			if buttons_locked.has(button) == false:
				if button.trait.generic == false:
					random_button_pool.append(button)
	
	if random_button_pool.size() < 1:
		for button in buttons_known:
			if button.trait.generic == false:
				if Global.Player.POINTS_TRAITS >= button.trait.cost:
					if buttons_locked.has(button) == false:
						random_button_pool.append(button)
	
	
		
	return random_button_pool

func _on_ButtonRandom_pressed():
	random_power()




func setup_deckbuttons():
	Global.universal.deck.deckbutton_selected = null
	Global.universal.deck.index_x = 0
	Global.universal.deck.index_y = 0
	
	update_deckbuttons()
	
	Global.universal.deck.set_first_button()

func update_deckbuttons():
	Global.universal.deck.deckbuttons = [[$Button_Quit, $Button_Inventory], 
	[$Control / Button_Prestige]]



	if popup_visible == false:
		update_no_popup()
	else:
		update_popup()

func update_no_popup():
	var index = Global.universal.deck.deckbuttons.size()
	Global.universal.deck.deckbuttons.append([])
	for button in buttons_known:
		
		Global.universal.deck.deckbuttons[index].append(button)
		Global.universal.deck.deckbuttons.append([])
		index += 1
	Global.universal.deck.deckbuttons[index].append($Control / ButtonRandom)
	Global.universal.deck.deckbuttons.append([])
	index += 1
	var elements = ["Body", "Fire", "Lightning", "Poison", "Death", "Ice", "Astral", "Psychic", "Life", "Blood"]
	for element in elements:
		for button in buttons_tree:
			if button.trait.Element == element:
				Global.universal.deck.deckbuttons[index].append(button)
				
		if Global.universal.deck.deckbuttons[index].size():
			Global.universal.deck.deckbuttons.append([])
			index += 1
	for button in buttons_all:
		if button.trait.generic == true:
			Global.universal.deck.deckbuttons[index].append(button)
			Global.universal.deck.deckbuttons.append([])
			index += 1


func update_popup():
	Global.universal.deck.deckbuttons = [[], []]
	Global.universal.deck.deckbuttons[0] = [$Button_Quit, $Button_Inventory]
	Global.universal.deck.deckbuttons[1] = [$PopupLayer / Popup / Button_Learn]

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
