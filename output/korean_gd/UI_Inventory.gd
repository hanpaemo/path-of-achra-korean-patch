extends Node2D

onready var game = get_parent().get_parent()
var buttons = []
var buttons_bag = []
var drop_mode = false

func update():
	for n in buttons.size():
		buttons[n].clear_sprite()
		if buttons[n].button_type == "inventory_weapon_main":
			if game.Player.weapon_main != null:
				var texture_path = game.Player.weapon_main["icon"]
				buttons[n].set_sprite(texture_path)
		if buttons[n].button_type == "inventory_weapon_off":
			if game.Player.weapon_off != null:
				var texture_path = game.Player.weapon_off["icon"]
				buttons[n].set_sprite(texture_path)
		if buttons[n].button_type == "inventory_head":
			if game.Player.armor_head != null:
				var texture_path = game.Player.armor_head["icon"]
				buttons[n].set_sprite(texture_path)
		if buttons[n].button_type == "inventory_chest":
			if game.Player.armor_chest != null:
				var texture_path = game.Player.armor_chest["icon"]
				buttons[n].set_sprite(texture_path)
		if buttons[n].button_type == "inventory_hands":
			if game.Player.armor_hands != null:
				var texture_path = game.Player.armor_hands["icon"]
				buttons[n].set_sprite(texture_path)
		if buttons[n].button_type == "inventory_legs":
			if game.Player.armor_legs != null:
				var texture_path = game.Player.armor_legs["icon"]
				buttons[n].set_sprite(texture_path)
	
	for n in buttons_bag.size():
		if game.Player.bag.size() - 1 >= n and game.Player.bag[n] != null:
			if game.Player.bag[n]["type"] == "weapon":
				var texture_path = game.Player.bag[n]["icon"]
				buttons_bag[n].set_sprite(texture_path)
			if game.Player.bag[n]["type"] == "armor":
				var texture_path = game.Player.bag[n]["icon"]
				buttons_bag[n].set_sprite(texture_path)
		if drop_mode == true:
			buttons_bag[n].modulate = Color(1, 0, 0, 1)
			$Drop_Button.modulate = Color(1, 0, 0, 1)
		else:
			buttons_bag[n].modulate = Color(1, 1, 1, 1)
			$Drop_Button.modulate = Color(1, 1, 1, 1)
	
	$decription.bbcode_text = write_description()
	
	
	$Title.bbcode_text = str(Global.Player.get_name()) + "[color=grey]의[/color] " + str(Global.Player.get_race()) + " " + str(Global.Player.get_class())
	

func initiate():

	initiate_inventory_buttons()
	
func open():
	drop_mode = false
	modulate = Color(1, 1, 1, 1)
	for n in buttons.size():
		buttons[n].get_node("Button").mouse_filter = Control.MOUSE_FILTER_STOP
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	$Drop_Button.mouse_filter = Control.MOUSE_FILTER_STOP
	
func close():
	drop_mode = false
	modulate = Color(1, 1, 1, 0)
	for n in buttons.size():
		buttons[n].get_node("Button").mouse_filter = Control.MOUSE_FILTER_IGNORE
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	$Drop_Button.mouse_filter = Control.MOUSE_FILTER_IGNORE

func write_description():
	var stringa = ""
	var nmbcolor = "[color=#ffff30]"
	var ttlcolor = "[color=#ffbf30]"
	if game.Player.get_hands_used() == 1:
		var weapon = game.Player.weapon_main
		
		
		stringa = stringa + "\n" + weapon["name"]
		stringa = stringa + "\n" + weapon["description"]
		
			
		
			
			
			
				
		stringa = stringa + "\n명중률: " + nmbcolor + str(int(game.Player.get_ACC(weapon))) + "-" + str(int(game.Player.get_ACC(weapon) * game.Player.get_ACC_sides(weapon))) + "[/color]"
		stringa = stringa + "   피해: " + nmbcolor + str(int(game.Player.get_DMG(weapon))) + "-" + str(int(game.Player.get_DMG(weapon) * game.Player.get_DMG_sides(weapon))) + "[/color]"
		stringa = stringa + "   사거리: " + nmbcolor + str(game.Player.get_range_attack(weapon)) + "[/color]"
		if weapon["aoe"] > 1:
			stringa = stringa + "\n[color=#ff9090]범위 공격[/color]"
		
		
	else:
		var weapon = game.Player.weapon_main
		
	
		if weapon == null:
			stringa = stringa + "\nBare fist"
			stringa = stringa + "\n[color=#af8f50]타격[/color]"
		else:
			stringa = stringa + "\n" + weapon["name"]
			stringa = stringa + "\n" + weapon["description"]
		
		stringa = stringa + "\n명중률: " + nmbcolor + str(int(game.Player.get_ACC(weapon))) + "-" + str(int(game.Player.get_ACC(weapon) * game.Player.get_ACC_sides(weapon))) + "[/color]"
		stringa = stringa + "   피해: " + nmbcolor + str(int(game.Player.get_DMG(weapon))) + "-" + str(int(game.Player.get_DMG(weapon) * game.Player.get_DMG_sides(weapon))) + "[/color]"
		stringa = stringa + "   사거리: " + nmbcolor + str(game.Player.get_range_attack(weapon)) + "[/color]"
		
		weapon = game.Player.weapon_off
		stringa = stringa + "\n"
	
		if weapon == null:
			stringa = stringa + "\nBare fist"
			stringa = stringa + "\n[color=#af8f50]타격[/color]"
		else:
			stringa = stringa + "\n" + weapon["name"]
			stringa = stringa + "\n" + weapon["description"]
		
		stringa = stringa + "\n명중률: " + nmbcolor + str(int(game.Player.get_ACC(weapon))) + "-" + str(int(game.Player.get_ACC(weapon) * game.Player.get_ACC_sides(weapon))) + "[/color]"
		stringa = stringa + "   피해: " + nmbcolor + str(int(game.Player.get_DMG(weapon))) + "-" + str(int(game.Player.get_DMG(weapon) * game.Player.get_DMG_sides(weapon))) + "[/color]"
		stringa = stringa + "   사거리: " + nmbcolor + str(game.Player.get_range_attack(weapon)) + "[/color]"
	
	stringa = stringa + "\n\n"
	stringa = stringa + write_description2()
	
	return stringa

func write_description2():
	var stringa = ""
	var nmbcolor = "[color=#ffff30]"
	var bdcolor = "[color=#ff5050]"
	var ttlcolor = "[color=#ffbf30]"
	if game.Player.armor_head != null:
		stringa = stringa + "   " + game.Player.armor_head["name"]
	if game.Player.armor_chest != null:
		stringa = stringa + "   " + game.Player.armor_chest["name"]
	if game.Player.armor_legs != null:
		stringa = stringa + "   " + game.Player.armor_legs["name"]
	if game.Player.armor_hands != null:
		stringa = stringa + "   " + game.Player.armor_hands["name"]
	
	if stringa == "":
		stringa = "[color=#ff4040]맨몸[/color]으로 싸운다"
	else:
		stringa = "착용 중:" + stringa
	
	stringa = stringa + "\nWeight: " + bdcolor + str(int(game.Player.get_total_weight())) + "[/color]"
	stringa = stringa + "   경직: " + bdcolor + str(int(game.Player.get_total_inflex())) + "[/color]"
	stringa = stringa + "\n\nArmor: " + nmbcolor + str(int(game.Player.get_ARM())) + "[/color]"
	stringa = stringa + "   방어: " + nmbcolor + str(int(game.Player.get_block_sides())) + "-" + str(int(game.Player.get_block() * game.Player.get_block_sides())) + " {" + str(int(game.Player.get_block_strength())) + "}" + "[/color]"
	stringa = stringa + "   회피: " + nmbcolor + str(int(game.Player.get_DEF())) + "-" + str(int(game.Player.get_DEF()) * game.Player.get_DEF_sides()) + "[/color]"
	stringa = stringa + "   속도: " + nmbcolor + str(int(game.Player.get_SPEED())) + "[/color]"
	return stringa

func write_description_traits():
	var stringa = ""
	for key in Global.Player.abilities:
		var stringb = Global.Player.abilities[key].title
		stringa = stringa + add_trait_description(stringb)
	return stringa

func add_trait_description(stringb):
	var stringa = ""
	stringa = stringa + Global.Player.abilities[stringb].Name
	stringa = stringa + " "
	stringa = stringa + "\n[color=#ffff50]LVL: [/color][color=#ffff00]" + str(Global.Player.abilities[stringb].Level) + "[/color] "
	stringa = stringa + Global.Player.abilities[stringb].Description
	return stringa

func spawn_button(parent, button_position, button_type, button_context):
	var new_button = Global.ButtonNode.instance()
	parent.add_child(new_button)
	buttons.append(new_button)
	new_button.position = button_position
	new_button.context = button_context
	new_button.button_type = button_type
	new_button.initiate()
	
func initiate_inventory_buttons():
	
	
	
	var parent = get_node("Point_Close")
	var button_position = Vector2(0, 0)
	var button_type = "inventory_close"
	var button_context = get_node(".")
	spawn_button(parent, button_position, button_type, button_context)
	
	parent = $Body / Point_Head
	button_position = Vector2(0, 0)
	button_type = "inventory_head"
	button_context = get_node(".")
	spawn_button(parent, button_position, button_type, button_context)
	
	parent = $Body / Point_Arms
	button_position = Vector2(0, 0)
	button_type = "inventory_hands"
	button_context = get_node(".")
	spawn_button(parent, button_position, button_type, button_context)
	
	parent = $Body / Point_Chest
	button_position = Vector2(0, 0)
	button_type = "inventory_chest"
	button_context = get_node(".")
	spawn_button(parent, button_position, button_type, button_context)
	
	parent = $Body / Point_Legs
	button_position = Vector2(0, 0)
	button_type = "inventory_legs"
	button_context = get_node(".")
	spawn_button(parent, button_position, button_type, button_context)
	
	parent = $Body / Point_Weapon_Main
	button_position = Vector2(0, 0)
	button_type = "inventory_weapon_main"
	button_context = get_node(".")
	spawn_button(parent, button_position, button_type, button_context)
	
	parent = $Body / Point_Weapon_Off
	button_position = Vector2(0, 0)
	button_type = "inventory_weapon_off"
	button_context = get_node(".")
	spawn_button(parent, button_position, button_type, button_context)

	for y in 3:
		for x in 4:
			parent = $Bag
			button_position = Vector2(x * 32, y * 32)
			button_type = "bag_item"
			button_context = get_node(".")
			spawn_button(parent, button_position, button_type, button_context)
	
	
		
	
	close()

func use_points(stat):
	if Global.Player.POINTS > 0:
		if stat == "str":
			Global.Player.STR += 1.0
		if stat == "dex":
			Global.Player.DEX += 1.0
		if stat == "wil":
			Global.Player.WIL += 1.0
		Global.Player.POINTS -= 1
	update()



func _on_Drop_Button_pressed():
	if drop_mode == false:
		drop_mode = true
	elif drop_mode == true:
		drop_mode = false
	update()
	pass



