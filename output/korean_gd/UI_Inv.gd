extends CanvasLayer

onready var equipped = $Buttons_Equipped
onready var player = Global.Player
onready var game = Global.game
onready var ui = game.get_node("UI")
var buttons_bag = []
var buttons_trait = []
var buttons_info = []
var buttons_buffs = []
var MODE_DROP = false
var trait_list = []

var destroy_hovered = false

var auto_buffer = 0

var is_typing = false
var popup_visible = false

onready var select_square = $Select
onready var focused_weapon = "main"
onready var focused_button = "main"
var hovered_button = "none"

var buttons_tab = []
var tab_selected = null

onready var b_equip = $PopupLayer / Popup / Equip

onready var b_destroy = $PopupLayer / Popup / Destroy
	
onready var b_equip2 = $PopupLayer / Popup / Equip2


onready var preset_buttons = [$Buttons_Equipped / Button_ArmorChest, $Buttons_Equipped / Button_ArmorHand, $Buttons_Equipped / Button_ArmorHead, $Buttons_Equipped / Button_ArmorLeg, $Buttons_Equipped / Button_WeaponMain, $Buttons_Equipped / Button_WeaponOff]

func initiate():
	for window in ui.get_open_windows():
		window.close()
	ui.window_inventory = get_node(".")
	$Button_God / Sprite.texture = load(StatePlayerSheet.God.sprite)
	
	update()

func update():
	player.update()
	set_buttons_equipped()
	create_bag()
	highlight_focused()
	create_traits()
	create_info()
	create_buffs()
	highlight_bag()
	write_descriptions()
	
	draw_body()
	setup_deckbuttons()
	




func take_off(item):
	popup_visible = false
	if item != null:
		match_player_null(item)
		player.bag.push_front(item)
		Global.game.update_game()
		update()

func match_player_null(item):
	match item:
		player.weapon_main:
			player.weapon_main = null
		player.weapon_off:
			player.weapon_off = null
		player.armor_hands:
			player.armor_hands = null
		player.armor_legs:
			player.armor_legs = null
		player.armor_head:
			player.armor_head = null
		player.armor_chest:
			player.armor_chest = null

func set_buttons_equipped():
	equipped.get_node("Button_WeaponOff").get_node("Sprite2").texture = null
	activate_button_equipped(equipped.get_node("Button_WeaponMain"), player.weapon_main, "res://Ham_Sprite/UI/SlotWeapon.png")
	activate_button_equipped(equipped.get_node("Button_WeaponOff"), player.weapon_off, "res://Ham_Sprite/UI/SlotWeapon.png")
	activate_button_equipped(equipped.get_node("Button_ArmorHead"), player.armor_head, "res://Ham_Sprite/UI/SlotHead.png")
	activate_button_equipped(equipped.get_node("Button_ArmorHand"), player.armor_hands, "res://Ham_Sprite/UI/SlotHand.png")
	activate_button_equipped(equipped.get_node("Button_ArmorChest"), player.armor_chest, "res://Ham_Sprite/UI/SlotChest.png")
	activate_button_equipped(equipped.get_node("Button_ArmorLeg"), player.armor_legs, "res://Ham_Sprite/UI/SlotLeg.png")
	
	if player.weapon_main == null:
		equipped.get_node("Button_WeaponMain").get_node("Sprite").texture = load("res://Ham_Sprite/UI/fist.png")
		equipped.get_node("Button_WeaponMain").get_node("Sprite").modulate = Color(1, 1, 1, 1)
		if player.weapon_off == null:
			equipped.get_node("Button_WeaponOff").get_node("Sprite").texture = load("res://Ham_Sprite/UI/fist.png")
			equipped.get_node("Button_WeaponOff").get_node("Sprite").modulate = Color(1, 1, 1, 1)
	else:
		if player.weapon_off == null:
			equipped.get_node("Button_WeaponOff").get_node("Sprite").texture = load(player.weapon_main.sprite)
			equipped.get_node("Button_WeaponOff").get_node("Body").visible = true


	
func activate_button_equipped(button, equipment, blanksprite):
	
	
	button.get_node("Sprite").texture = load(blanksprite)
	button.get_node("Sprite").modulate = Color(1, 1, 1, 1)
	button.get_node("Body").visible = false
	if equipment != null:
		
		
		if button != equipped.get_node("Button_WeaponOff"):
			button.get_node("Sprite").texture = load(equipment.sprite)
		else:
			button.get_node("Sprite2").texture = load(equipment.sprite)
		button.get_node("Body").visible = true
	else:
		button.get_node("Sprite").modulate = Color(1, 1, 1, 0.3)
	
	button.get_node("tint").visible = false
	if equipment != null:
		if equipment.has("tint"):
			if equipment.tint == true:
				button.get_node("tint").visible = true

	
	

func highlight_focused():
	
	var EquipButton = $PopupLayer / Popup / Equip

	var DestroyButton = $PopupLayer / Popup / Destroy
	
	var Equip2Button = $PopupLayer / Popup / Equip2
	
	if hovered_button == "none":
		hovered_button = focused_button
	
	
	
	EquipButton.modulate = Color(0.2, 0.2, 0.2, 1)
	
	
	Equip2Button.modulate = Color(0.2, 0.2, 0.2, 1)
	
	
	DestroyButton.modulate = Color(0.2, 0.2, 0.2, 1)
	
	DestroyButton.get_node("label").bbcode_text = "[color=#a0a0a0][[color=#ffff50]3[/color]] [color=#ff4000]제물[/color]"
	
	if popup_visible == false:
		hide_popup()
	
		
		
	
	var anode = $Buttons_Equipped / Button_WeaponMain

	
		
		
		
	
	
	
	match focused_button:
		"main":
			anode = $Buttons_Equipped / Button_WeaponMain
		"off":
			anode = $Buttons_Equipped / Button_WeaponOff
		"chest":
			anode = $Buttons_Equipped / Button_ArmorChest
		"head":
			anode = $Buttons_Equipped / Button_ArmorHead
		"hand":
			anode = $Buttons_Equipped / Button_ArmorHand
		"leg":
			anode = $Buttons_Equipped / Button_ArmorLeg
	
	
	
	
	for button in buttons_bag:
		if focused_button == str(button.bag_index) + "bag":
			anode = button
		if hovered_button == str(button.bag_index) + "bag":
			
			
			
			
			EquipButton.modulate = Color(1, 1, 1, 1)
			EquipButton.mouse_filter = Control.MOUSE_FILTER_STOP
			EquipButton.get_node("label").bbcode_text = "장착"
			
			DestroyButton.modulate = Color(1, 1, 1, 1)
			DestroyButton.mouse_filter = Control.MOUSE_FILTER_STOP
	
	
	for button in buttons_trait:
		if focused_button == button.trait.title:
			anode = button
		if hovered_button == button.trait.title:
			
			EquipButton.modulate = Color(0, 1, 0, 0)
			EquipButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
			Equip2Button.modulate = Color(0, 1, 0, 0)
			Equip2Button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
			DestroyButton.modulate = Color(1, 0, 0, 0)
			DestroyButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
			
			
			
			
			
			
			
	
	for button in buttons_info:
		if focused_button == button.info.title:
			anode = button
		if hovered_button == button.info.title:
			
			EquipButton.modulate = Color(0, 1, 0, 0)
			EquipButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
			Equip2Button.modulate = Color(0, 1, 0, 0)
			Equip2Button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
			DestroyButton.modulate = Color(1, 0, 0, 0)
			DestroyButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
			
			
			
			
			
			
	
	show_popup(anode.get_global_position())
	select_square.position = anode.get_global_position()
	update_deckbuttons(anode)
	create_tab_buttons()
	

	for button in preset_buttons:
		if popup_visible == true and anode != button:
			button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		else:
			button.mouse_filter = Control.MOUSE_FILTER_STOP
	for button in buttons_bag:
		if popup_visible == true and anode != button:
			button.get_node("Button").mouse_filter = Control.MOUSE_FILTER_IGNORE
		else:
			button.get_node("Button").mouse_filter = Control.MOUSE_FILTER_STOP
	for button in buttons_buffs:
		if popup_visible == true:
			button.get_node("Button").mouse_filter = Control.MOUSE_FILTER_IGNORE
		else:
			button.get_node("Button").mouse_filter = Control.MOUSE_FILTER_STOP
	for button in buttons_trait:
		if popup_visible == true:
			button.get_node("Button").mouse_filter = Control.MOUSE_FILTER_IGNORE
		else:
			button.get_node("Button").mouse_filter = Control.MOUSE_FILTER_STOP
	for button in buttons_info:
		if popup_visible == true:
			button.get_node("Button").mouse_filter = Control.MOUSE_FILTER_IGNORE
		else:
			button.get_node("Button").mouse_filter = Control.MOUSE_FILTER_STOP
	
	write_descriptions()

func highlight_bag():
	$Description_Bag.bbcode_text = "[color=#9f6040]가방[/color]"
	$Button_Drop / Sprite.texture = load("res://Ham_Sprite/UI/Bag.png")
	for button in buttons_bag:
		button.modulate = Color(1, 1, 1, 1)
	
		var abuff = {
				"description": ""
			}
		var atrait = {
				"Description": "", 
				"reference": "none"
			}
		
		var item = player.bag[button.bag_index]
		
		for trait in item.abilities:
			if trait != "none":
					atrait = LTraitsGeneric.trait_data[trait]
		
		if atrait.reference != "none":
			abuff = LBuffs.buff_data[atrait.reference]
		
		if $TextEdit.text != "" and $TextEdit.text != "search bag...":
				if $TextEdit.text in textstrip.strip_bbcode(atrait.Description).to_lower():
					pass
				elif $TextEdit.text in textstrip.strip_bbcode(abuff.description).to_lower() and abuff.description != "":
					pass
				elif $TextEdit.text in textstrip.strip_bbcode(item.name).to_lower():
					pass
				elif $TextEdit.text in textstrip.strip_bbcode(item.type).to_lower():
					pass
				elif item.type == "weapon":
					if $TextEdit.text in textstrip.strip_bbcode(item.dmgtype).to_lower():
						pass
					elif $TextEdit.text in textstrip.strip_bbcode(translate.get_shield_or_aoe_text(item)).to_lower():
						pass
					elif translate.is_bare_fist(item) == true and $TextEdit.text in textstrip.strip_bbcode(translate.get_bare_fist_text()).to_lower():
						pass
					
					
					else:
						button.modulate = Color(0.1, 0.1, 0.1, 1)
				
				
				
				else:
					button.modulate = Color(0.1, 0.1, 0.1, 1)
	
func create_traits():
	for button in buttons_trait:
		button.queue_free()
	buttons_trait = []
	var traits = Global.Player.get_traits()
	var pos = $Traits.position
	var index_x = 0
	for trait in traits:
		
			
			var b = Global.ButtonBag.instance()
			add_child(b)
			b.position = pos
			b.trait = traits[trait]
			if b.trait.generic == false:
				b.get_node("Level").text = str(b.trait.Level)
				b.get_node("LevelButton").visible = true
			b.index_x = index_x
			pos.x += 32
			index_x += 1
			b.context = get_node(".")
			b.type = "trait"
			b.bag_index = 0
			b.get_node("Sprite").texture = load(traits[trait].sprite)
			buttons_trait.append(b)
			
				
					

func create_bag():
	var delete_array = []
	for button in buttons_bag:
		delete_array.append(button)
	for button in delete_array:
		buttons_bag.erase(button)
		button.queue_free()
	
	var pos = $Buttons_Bag.position
	var rowcount = 0
	for n in player.bag.size():
		var b = Global.ButtonBag.instance()
		add_child(b)
		b.index_x = rowcount
		b.position = pos
		pos.x += 32
		rowcount += 1
		
		if rowcount >= 11:
			rowcount = 0
			pos.y += 32
			pos.x = $Buttons_Bag.position.x
		
		b.context = get_node(".")
		b.type = "item"
		b.bag_index = n
		b.get_node("Sprite").texture = load(player.bag[n].sprite)
		b.get_node("Body").visible = true
		
		if player.bag[n].has("tint"):
			if player.bag[n].tint == true:
				b.get_node("tint").visible = true
		
		buttons_bag.append(b)

func create_tab_buttons():
	
	buttons_tab = ["main", "off", "head", "hand", "chest", "leg"]
	for button in buttons_bag:
		var label = str(button.bag_index) + "bag"
		buttons_tab.append(label)
	
	
		

func create_info():
	var delete_array = []
	for button in buttons_info:
		delete_array.append(button)
	for button in delete_array:
		buttons_info.erase(button)
		button.queue_free()
	$InfoButtons.create_buttons()


func create_buffs():
	var delete_array = []
	for button in buttons_buffs:
		delete_array.append(button)
	for button in delete_array:
		buttons_buffs.erase(button)
		button.queue_free()
	
	
	
	




	
	
		
		
		
			
		
		
	var pos = $InfoButtons / Buffs.position
	var rowcount = 0
	for buff in Global.Player.Buffs:
		var b = Global.ButtonBuff.instance()
		add_child(b)
		b.index_x = rowcount
		b.position = pos
	
		pos.x += 40
		rowcount += 1
		
		if rowcount >= 5:
			rowcount = 0
			pos.y += 17
			pos.x = $InfoButtons / Buffs.position.x
		
		b.buff = buff
		b.in_inventory = true
		b.context = get_node(".")
		
		var inta = b.buff.duration
		
		b.get_node("Label").text = "" + str(inta) + ""
		
			
		
	
		b.get_node("Sprite").texture = load(b.buff.icon)
		buttons_buffs.append(b)
	
	
	
func write_descriptions():
	describe_clear()
	$Focus / DescriptionFocus.bbcode_text = ""
	$Focus / DescriptionFocus2.bbcode_text = ""
	$Focus / Sprite_Equip_Focused.texture = null
	$Focus / infpen.texture = null
	$Focus / Sprite_Focus.visible = true
	
	var stringa = ""
	
	if hovered_button == "none":
		hovered_button = focused_button
		
	
	
	
	
	


	
	
	match hovered_button:
		
		"states":
			stringa = "[color=#707070]상태[/color]"
			$Focus / Sprite_Focus.visible = false
			$Focus / Sprite_Equip_Focused.texture = null
			stringa += describe_states()
			
		
		"main":
			stringa = describe_weapon(player.weapon_main)
			
			
			if player.weapon_main != null:
				var EquipButton = $PopupLayer / Popup / Equip
				EquipButton.modulate = Color(1, 1, 1, 1)
				EquipButton.mouse_filter = Control.MOUSE_FILTER_STOP
				EquipButton.get_node("label").bbcode_text = "[color=#a0a0a0][[color=#ffff50]1[/color]] 가방에 넣기[/color]"
				
			var EquipButton = $PopupLayer / Popup / Equip2
			EquipButton.modulate = Color(1, 1, 1, 1)
			EquipButton.mouse_filter = Control.MOUSE_FILTER_STOP
			EquipButton.get_node("label").bbcode_text = "[color=#a0a0a0][[color=#ffff50]2[/color]] 손 교체"
			
		"off":
			if player.get_hands_used() > 1:
				stringa = describe_weapon(player.weapon_off)
				
			else:
				stringa = "[color=#c0c0c0]보조손\n\n주무장이 '양손 장착' 중"
				$Focus / Sprite_Focus.visible = false
				$Focus / Sprite_Equip_Focused.texture = null
				$PopupLayer / Popup / RichTextLabel.bbcode_text = "[center][color=#c0c0c0]보조손"
			
			if player.weapon_off != null:
				var EquipButton = $PopupLayer / Popup / Equip
				EquipButton.modulate = Color(1, 1, 1, 1)
				EquipButton.mouse_filter = Control.MOUSE_FILTER_STOP
				EquipButton.get_node("label").bbcode_text = "[color=#a0a0a0][[color=#ffff50]1[/color]] 가방에 넣기"
				
			var EquipButton = $PopupLayer / Popup / Equip2
			EquipButton.modulate = Color(1, 1, 1, 1)
			EquipButton.mouse_filter = Control.MOUSE_FILTER_STOP
			EquipButton.get_node("label").bbcode_text = "[color=#a0a0a0][[color=#ffff50]2[/color]] 손 교체"
			
			
		"head":
			stringa = describe_armor(player.armor_head)
			if player.armor_head != null:
				var EquipButton = $PopupLayer / Popup / Equip
				EquipButton.modulate = Color(1, 1, 1, 1)
				EquipButton.mouse_filter = Control.MOUSE_FILTER_STOP
				EquipButton.get_node("label").bbcode_text = "[color=#a0a0a0][[color=#ffff50]1[/color]] 가방에 넣기[/color]"
			else:
				stringa = "[color=#c0c0c0]빈 머리[/color]"
			
		"chest":
			stringa = describe_armor(player.armor_chest)
			if player.armor_chest != null:
				var EquipButton = $PopupLayer / Popup / Equip
				EquipButton.modulate = Color(1, 1, 1, 1)
				EquipButton.mouse_filter = Control.MOUSE_FILTER_STOP
				EquipButton.get_node("label").bbcode_text = "[color=#a0a0a0][[color=#ffff50]1[/color]] 가방에 넣기[/color]"
			else:
				stringa = "[color=#c0c0c0]빈 가슴[/color]"
			
		"hand":
			stringa = describe_armor(player.armor_hands)
			if player.armor_hands != null:
				var EquipButton = $PopupLayer / Popup / Equip
				EquipButton.modulate = Color(1, 1, 1, 1)
				EquipButton.mouse_filter = Control.MOUSE_FILTER_STOP
				EquipButton.get_node("label").bbcode_text = "[color=#a0a0a0][[color=#ffff50]1[/color]] 가방에 넣기[/color]"
			else:
				stringa = "[color=#c0c0c0]빈 팔[/color]"
			
		"leg":
			stringa = describe_armor(player.armor_legs)
			if player.armor_legs != null:
				var EquipButton = $PopupLayer / Popup / Equip
				EquipButton.modulate = Color(1, 1, 1, 1)
				EquipButton.mouse_filter = Control.MOUSE_FILTER_STOP
				EquipButton.get_node("label").bbcode_text = "[color=#a0a0a0][[color=#ffff50]1[/color]] [color=#c0c0c0]가방에 넣기[/color]"
			else:
				stringa = "[color=#c0c0c0]빈 다리[/color]"
		
		
		
	for button in buttons_bag:
		if hovered_button == str(button.bag_index) + "bag":
			var item = player.bag[button.bag_index]
			$Focus / Sprite_Equip_Focused.texture = load(item.sprite)
			match item.type:
					"weapon":
						stringa = describe_weapon(item)
						var EquipButton = $PopupLayer / Popup / Equip2
						EquipButton.modulate = Color(1, 1, 1, 1)
						EquipButton.mouse_filter = Control.MOUSE_FILTER_STOP
						EquipButton.get_node("label").bbcode_text = "[color=#a0a0a0][[color=#ffff50]2[/color]] [color=#c0c0c0]보조손에 장착[/color]"
						$PopupLayer / Popup / Equip.get_node("label").bbcode_text = "[color=#a0a0a0][[color=#ffff50]1[/color]] 주무장에 장착[/color]"
					"armor":
						stringa = describe_armor(item)
						$PopupLayer / Popup / Equip.get_node("label").bbcode_text = "[color=#a0a0a0][[color=#ffff50]1[/color]] 방어구로 착용[/color]"
			if destroy_hovered == true:
				$Focus / Sprite_Focus.visible = false
				$Focus / Sprite_Equip_Focused.texture = null
				stringa = write_destroy()
	
	
	for button in buttons_trait:
		if hovered_button == button.trait.title:
			stringa = button.trait.Name
			stringa += "\n\n"
			if button.trait.generic == true:
				if button.trait.organize == "racial":
					stringa += "[color=#808080]문화[/color]\n"
				elif button.trait.organize == "class":
					stringa += "[color=#808080]직업[/color]\n"
				elif button.trait.organize == "god":
					stringa += "[color=#808080]신앙[/color]\n"
				elif button.trait.organize == "prestige":
					stringa += "[color=#808080]상위 직업[/color]\n"
				else:
					stringa += "[color=#808080]아이템[/color]\n"
				if button.trait.levelable == true:
					stringa += "[color=#808080]레벨 [/color]" + str(button.trait.Level)
			else:
				stringa += translate.element(button.trait.Element) + "[color=#808080] 원소[/color]"
				stringa += "\n\n[color=#808080]레벨 [/color]" + str(button.trait.Level)
				
				
			stringa += "\n\n"
			stringa += button.trait.Description
			
			if button.trait.reference != "none":
				stringa += "\n\n"
				var abuff = LBuffs.buff_data[button.trait.reference]
				stringa += "[color=#707070]효과[/color]\n" + abuff.color + abuff.name + ": [/color]" + abuff.description
			
			if button.trait.generic == false:
				stringa += "\n\n\n\n\n" + translate.element_to_resist_description(button.trait.Element)
			
			
			$Focus / Sprite_Equip_Focused.texture = load(button.trait.sprite)
			$Focus / Sprite_Focus.visible = false
	
	for button in buttons_info:
		if hovered_button == button.info.title:
			stringa += button.info.description + "\n\n"
			$Focus / Sprite_Focus.visible = false
			
			
		
			$Focus / Sprite_Equip_Focused.texture = null
			if button.info.title == "resistances":
				var typelist = ["slash", "blunt", "pierce", "fire", "ice", "poison", "lightning", "death", "psychic", "astral", "blood"]
				for label in typelist:
					var resist = Global.Player.get_resist(label)
					if resist != 300:
						stringa += "\n"
						
						
						
						stringa += translate.damage_type(label)
						stringa += translate.value_to_color(resist)
						stringa += " " + str(resist) + "%"
						stringa += "[/color]"
	
	
	for button in buttons_buffs:
		if hovered_button == button.buff.title + "buff":
			stringa += button.buff.color + button.buff.name + "[/color]"
			stringa += "\n\n"
			stringa += "[color=#808080]효과[/color]"
			stringa += "\n\n"
			stringa += button.buff.description
			
			
			$Focus / Sprite_Focus.visible = false
			$Focus / Sprite_Equip_Focused.texture = load(button.buff.icon)
			
	
	stringa = "[color=#c0c0c0]" + stringa
	
	$Focus / DescriptionFocus.bbcode_text = stringa
	
	
	
	
		
		
			
		
		
			
		
		
	
	
	describe_total_info()
	
	
func describe_weapon(weapon):
	var stringa = ""

	if weapon != null:
		$PopupLayer / Popup / RichTextLabel.bbcode_text = "[center]" + weapon.name
	else:
		$PopupLayer / Popup / RichTextLabel.bbcode_text = "[center][color=#ffff50]맨주먹[/color]"

	
	if weapon != null:
		$Focus / Sprite_Equip_Focused.texture = load(weapon.sprite)
		stringa += "\n[color=#ffa050]" + str(weapon.acc * 10) + " [color=#a0a0a0]명중률[/color][/color]"
		stringa += "\n[color=#ff8030]" + str(weapon.dmg * 10) + " [color=#a0a0a0]명중[/color][/color]"
		stringa += " " + translate.damage_type(weapon["dmgtype"])
		stringa = stringa + "\n[color=#5050ff]" + str(weapon.arm) + " [color=#a0a0a0]방어[/color][/color]"
	
	else:
		$Focus / Sprite_Focus.visible = false
		stringa += "\n[color=#ffa050]" + "75" + "[/color]"
		stringa += " [color=#a0a0a0]명중률[/color]"
		stringa += "\n[color=#ff8030]" + "10" + "[/color]"
		stringa += " [color=#a0a0a0]명중[/color] [color=#af8f50]타격[/color]"
	
	stringa += "\n"
	if weapon != null:
		if translate.is_bare_fist(weapon) == true:
	
			stringa += translate.get_bare_fist_text()
			stringa += "\n"
	var range_string = ""
	
	range_string = str(player.get_range_attack(weapon))
	
		
	
	
	stringa = stringa + "\n" + range_string + "[/color] [color=#a0a0a0]사거리[/color] "
	
	
	
	stringa = stringa + "\n"
	
	if weapon != null:
		
		stringa = stringa + "\n[color=#ff0000]" + str(weapon.weight) + " [/color][color=#a0a0a0]하중[/color]"
		stringa = stringa + "\n[color=#ff0000]" + str(weapon.size) + " [/color][color=#a0a0a0]무기 크기[/color]"
	
	if weapon != null:
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
	
	if weapon != null:
		stringa += translate.get_shield_or_aoe_text(weapon)
		
		
		
			
			
	
		
		
			
			
	
	stringa = stringa + "\n"

	
	
	if weapon != null:
		
		for trait in weapon.abilities:
			if trait != "none":
				var traitreal = LTraitsGeneric.trait_data[trait]
				
				stringa = stringa + "\n[img]" + traitreal.sprite + "[/img]"
			
				stringa = stringa + "\n[color=#c0c0c0]" + traitreal.Description
				
				if traitreal.reference != "none":
					stringa += "\n\n"
					var abuff = LBuffs.buff_data[traitreal.reference]
					stringa += "[color=#707070]효과[/color]\n" + abuff.color + abuff.name + ": [/color]" + abuff.description
				
				if check_duplicate_traits(trait) == true:
					stringa = stringa + "\n" + "[color=#c07070]*중복[/color]"
				
				stringa = stringa + "\n"
		
		
		
		stringa = weapon["name"] + "\n" + stringa
	else:
		stringa = "[color=#ffff50]맨주먹[/color]" + "\n" + stringa

	
	return stringa


func describe_armor(armor):
	var stringa = ""
	
	if armor != null:
		$PopupLayer / Popup / RichTextLabel.bbcode_text = "[center]" + armor.name
	else:
		$PopupLayer / Popup / RichTextLabel.bbcode_text = "[center][color=#a0a0a0]비어 있음"
	
	
	if armor != null:
		
		$PopupLayer / Popup / RichTextLabel.bbcode_text = "[center]" + armor.name
		
		$Focus / Sprite_Equip_Focused.texture = load(armor.sprite)
		stringa = armor.name + stringa
		
		stringa = stringa + "\n\n[color=#5050ff]" + "+" + str(armor.arm) + " [color=#a0a0a0]방어력[/color][/color]\n"
		stringa = stringa + "\n[color=#ff0000]" + "+" + str(armor.weight) + " [color=#a0a0a0]하중[/color][/color]"
		
		
		
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
				
		
		
		stringa += "\n"
		for trait in armor.abilities:
			if trait != "none":
				var traitreal = LTraitsGeneric.trait_data[trait]
				
				stringa = stringa + "\n[img]" + traitreal.sprite + "[/img]"
				
				stringa = stringa + "\n" + traitreal.Description
				
				if traitreal.reference != "none":
					stringa += "\n\n"
					var abuff = LBuffs.buff_data[traitreal.reference]
					stringa += "[color=#707070]효과[/color]\n" + abuff.color + abuff.name + ": [/color]" + abuff.description
				
				if check_duplicate_traits(trait) == true:
					stringa = stringa + "\n" + "[color=#c07070]You are receiving this trait from multiple items, but its effect only applies once.[/color]"
				
				stringa = stringa + "\n"
	else:
		$Focus / Sprite_Focus.visible = false
	
	return stringa

func check_duplicate_traits(trait):
	var is_duplicate = false
	player.get_traits()
	if player.traits_duplicate.has(trait):
		is_duplicate = true
		
		
	return is_duplicate

func describe_total_info():
	
	$InfoButtons / States.bbcode_text = ""
	if player.weapon_main != null and player.weapon_off == null:
		$InfoButtons / States.bbcode_text += "[color=#ffff50]양손 장착[/color]"
	else:
		$InfoButtons / States.bbcode_text += "[color=#50ffff]한손 장착[/color]"
	if int(game.Player.get_total_weight()) > int(game.Player.get_total_STR()):
		$InfoButtons / States.bbcode_text += "[color=#707070],[/color] [color=#ff0000]과중량[/color]"
	else:
		$InfoButtons / States.bbcode_text += "[color=#707070],[/color] [color=#00ff00]경량[/color]"
	if int(game.Player.get_total_inflex()) > 1:
		$InfoButtons / States.bbcode_text += "[color=#707070],[/color] [color=#ff0000]경직[/color]"
	else:
		$InfoButtons / States.bbcode_text += "[color=#707070],[/color] [color=#00ff00]유연[/color]"
	
	for button in buttons_info:
		var label = button.get_node("Label")
		var stringa = ""
		stringa = get_info_string(button.info, player)
		
		
		
		
		
		
		label.bbcode_text = stringa

func get_info_string(info, player):
	var stringa = ""

	match info.title:
			"STR":
				stringa = str(player.get_total_STR())
			"DEX":
				stringa = str(player.get_total_DEX())
			"WIL":
				stringa = str(player.get_total_WIL())
		
		
			"attack":
				var weapon = player.weapon_main
				var color = "[color=#ffa050]"

				if StatMods.check(Global.Player, "attack") <= - 1:
					color = "[color=#ff0000]"

				stringa = str(int(player.get_ACC_total(weapon)))
				stringa = color + stringa + "[/color]"
			
				
			"damage":
				var color = "[color=#ff8030]"
				if StatMods.check(Global.Player, "damage") <= - 1:
					color = "[color=#ff0000]"
				var weapon = player.weapon_main
				stringa = str(int(player.get_DMG_total(weapon)))
				stringa = color + stringa + "[/color]"
				
				
				
				
				
			
			"attack2":
				if player.get_hands_used() > 1:
					var color = "[color=#ffa050]"
					var weapon = player.weapon_off
					if StatMods.check(Global.Player, "attack") <= - 1:
						color = "[color=#ff0000]"
					
						
					stringa = str(int(player.get_ACC_total(weapon)))
					stringa = color + stringa + "[/color]"
				else:
					stringa += "[color=#c0c0c0] - [/color]"
			"damage2":
				
				if player.get_hands_used() > 1:
					var color = "[color=#ff8030]"
					var weapon = player.weapon_off
					if StatMods.check(Global.Player, "damage") <= - 1:
						color = "[color=#ff0000]"
					
					stringa = str(int(player.get_DMG_total(weapon)))
					stringa = color + stringa + "[/color]"
					
					
					
					
						
				else:
					stringa += "[color=#c0c0c0] - [/color]"
		
		
		
			"life":
				var color = "[color=#ff8080]"
				stringa = str(player.HP) + "[/color] [color=#707070]/" + str(player.HP_max)
				stringa = color + stringa + "[/color]"
			"speed":
				var color = "[color=#20ff20]"
				if int(game.Player.get_total_weight()) > int(game.Player.get_total_STR()):
					color = "[color=#ff0000]"
				if int(game.Player.get_total_inflex()) > 1:
					color = "[color=#ff0000]"
				if StatMods.check(Global.Player, "speed") <= - 1:
					color = "[color=#ff0000]"
				stringa = str(int(game.Player.get_SPEED()))
				stringa = color + stringa + "[/color]"
				stringa += "[color=#707070] (" + str(int(game.Player.get_SPEED_min())) + ")[/color]"
			
			"resistances":
				var typelist = ["slash", "blunt", "pierce", "fire", "ice", "poison", "lightning", "death", "psychic", "astral", "blood"]
				var avg = 0.0
				for label in typelist:
					avg += float(Global.Player.get_resist(label))
				avg /= float(typelist.size())
				stringa = "[color=#a0a0a0]~" + translate.value_to_color(int(avg)) + str(int(avg)) + "%"
			
			
			"armor":
				var color = "[color=#5050ff]"
				if StatMods.check(Global.Player, "armor") <= - 1:
					color = "[color=#ff0000]"
				stringa = str(int(player.get_ARM()))
				stringa = color + stringa + "[/color]"
			
			
			
			
			
			
			"block":
				var color = "[color=#5050ff]"
				if StatMods.check(Global.Player, "block") <= - 1:
					color = "[color=#ff0000]"
				stringa = "[color=#707070]" + str(int(game.Player.get_block_chance())) + "%[/color] " + str(int(game.Player.get_block_strength()))
				stringa = color + stringa + "[/color]"
				
			"dodge":
				var color = "[color=#50ffff]"
				if int(game.Player.get_total_weight()) > int(game.Player.get_total_STR()):
					color = "[color=#ff0000]"
				if StatMods.check(Global.Player, "dodge") <= - 1:
					color = "[color=#ff0000]"
				
				stringa = str(int(game.Player.get_DEF_total()))
				stringa = color + stringa + "[/color]"
				
			"encumbrance":
				var color = "[color=#50ff50]"
				stringa = str(int(game.Player.get_total_weight()))
				
				if int(game.Player.get_total_weight()) > 0:
					color = "[color=#ff0000]"
				if int(game.Player.get_total_weight()) <= int(game.Player.get_total_STR()):
					color = "[color=#00ff00]"
				stringa = color + stringa + "[/color]" + " [color=#707070]" + str(player.get_total_STR()) + " STR"
				
				
			"inflex":
				var color = "[color=#50ff50]"
				stringa = str(int(game.Player.get_total_inflex()))
				if int(game.Player.get_total_inflex()) > 1:
					stringa += " !"
					color = "[color=#ff0000]"
				stringa = color + stringa + "[/color]"
				
			
			"weaponsize":
				var color = "[color=#50ff50]"
				stringa = str(int(game.Player.get_total_weapon_size()))
				if int(game.Player.get_total_weapon_size()) > 0:
					color = "[color=#ff0000]"
				stringa = color + stringa + "[/color]"

	stringa = "[right]" + stringa
	return stringa


func describe_states():
	var stringa = "\n\n[color=#707070]"
	if player.weapon_main != null and player.weapon_off == null:
		stringa += "[color=#ffff50]양손 장착[/color]"
		stringa += ": 보조손이 비어 주무장을 지지하여 명중과 명중률이 추가됩니다"
	else:
		stringa += "[color=#50ffff]한손 장착[/color]"
		stringa += ": 보조손에 무기가 있거나 주무장이 맨주먹이면 양손으로 공격합니다"
	if int(game.Player.get_total_weight()) > int(game.Player.get_total_STR()):
		stringa += "\n\n[color=#ff0000]과중량[/color]"
		stringa += ": 하중이 힘보다 높아 속도와 회피가 감소합니다"
	else:
		stringa += "\n\n[color=#00ff00]경량[/color]"
		stringa += ": 하중이 힘 이하로 페널티가 없습니다"
	if int(game.Player.get_total_inflex()) > 1:
		stringa += "\n\n[color=#ff0000]경직[/color]"
		stringa += ": 경직이 1을 초과하여 (보통 특정 방어구 장착 시) 속도와 의지 피해 보너스가 크게 감소하고 방어가 상승합니다"
	else:
		stringa += "\n\n[color=#00ff00]유연[/color]"
		stringa += ": 경직이 1로 페널티가 없습니다"
	
	return stringa


func describe_item_traits(item):
	var stringa = ""
	for trait in item.abilities:
			if trait != "none":
				if trait_list.has(trait) == false:
					trait_list.append(trait)
					stringa = stringa + LTraitsGeneric.trait_data[trait].Name
					stringa = stringa + "\n"
	return stringa

func describe_clear():
	$Buttons_Equipped / Description_WeaponMain.bbcode_text = ""
	$Buttons_Equipped / Description_WeaponOff.bbcode_text = ""
	$Buttons_Equipped / Description_ArmorChest.bbcode_text = ""
	$Buttons_Equipped / Description_ArmorHand.bbcode_text = ""
	$Buttons_Equipped / Description_ArmorHead.bbcode_text = ""
	$Buttons_Equipped / Description_ArmorLeg.bbcode_text = ""

func draw_body():
	$Image / body.texture = load(StatePlayerSheet.sprite_skin)
	if player.weapon_main != null:
		$Image / weapon_main.texture = load(player.weapon_main.sprite)
	else:
		$Image / weapon_main.texture = null
	if player.weapon_off != null:
		$Image / weapon_off.texture = load(player.weapon_off.sprite)
	else:
		$Image / weapon_off.texture = null
	if player.armor_head != null:
		$Image / armor_head.texture = load(player.armor_head.sprite)
	else:
		$Image / armor_head.texture = null
	if player.armor_chest != null:
		$Image / armor_chest.texture = load(player.armor_chest.sprite)
	else:
		$Image / armor_chest.texture = null
	if player.armor_hands != null:
		$Image / armor_hands.texture = load(player.armor_hands.sprite)
	else:
		$Image / armor_hands.texture = null
	if player.armor_legs != null:
		$Image / armor_legs.texture = load(player.armor_legs.sprite)
	else:
		$Image / armor_legs.texture = null

func write_info_top():
	
	
	
	var stringa = ""
	stringa = stringa + "[color=#c0c0c0]STR[/color] " + str(Global.Player.get_total_STR())
	stringa = stringa + " [color=#c0c0c0]DEX[/color] " + str(Global.Player.get_total_DEX())
	stringa = stringa + " [color=#c0c0c0]WIL[/color] " + str(Global.Player.get_total_WIL())
	
	$Info.bbcode_text = stringa

func swap_weapons():
	var main = cloner.clone_dict(player.weapon_main)
	var off = cloner.clone_dict(player.weapon_off)
	popup_visible = false
	player.weapon_main = off
	player.weapon_off = main
	
	if focused_weapon == "main":
		focused_weapon = "off"
	else:
		focused_weapon = "main"
	
	if focused_button == "main":
		focused_button = "off"
	else:
		focused_button = "main"
	
	hovered_button = focused_button
	effectmaker.create_effect_animated_ui_context(get_node("."), $Buttons_Equipped / Button_WeaponMain.get_global_position(), "Click")
	effectmaker.create_effect_animated_ui_context(get_node("."), $Buttons_Equipped / Button_WeaponOff.get_global_position(), "Click")
		
	Global.game.update_game()
	update()
	update_deck_selected()

func close():
	Global.universal.deck.reset_buttons()
	
	ui.window_inventory = null
	Global.universal.deck.setup_current_screen()
	queue_free()

func _on_Button_Close_pressed():
	close()

func _input(event):
	if is_typing == false:
		input_if_not_typing(event)

func input_if_not_typing(event):
	if event.is_action_pressed("escape") or event.is_action_pressed("i") or event.is_action_pressed("mouse_right"):
		close()
	if event.is_action_pressed("1"):
		equip1()
	if event.is_action_pressed("2"):
		equip2()
	if event.is_action_pressed("3"):
		destroy()
	
	if event.is_action_pressed("pass"):
		close_popup()
	
	if event.is_action_pressed("gamepad_b"):
				if ToolSettings.settings_data.gamepad_mode == "full":
					cycle_buttons_tab(1)
					
					
	if event.is_action_pressed("gamepad_x"):
		if ToolSettings.settings_data.gamepad_mode == "full":
			close_popup()
			
	if event.is_action_pressed("gamepad_y"):
		if ToolSettings.settings_data.gamepad_mode == "full":
			if popup_visible == true:
				close_popup()
			else:
				close()
	
	if event.is_action_pressed("tab"):
		if Input.is_action_pressed("alt") == false and Input.is_action_pressed("shift") == false:
			cycle_buttons_tab(1)
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
	
	Global.universal.deck.input_handler(event)

func cycle_buttons_tab(inta):
	if buttons_tab.has(focused_button) == true:
		if popup_visible == false:
			popup_visible = true
		
		
		else:
			
			var index = 0
			for n in buttons_tab.size():
				var label = buttons_tab[n]
				if focused_button == label:
					index = n
			
			index += inta
			
			if index >= buttons_tab.size():
				index = 0
			if index < 0:
				index = buttons_tab.size() - 1
		
			focused_button = buttons_tab[index]
			hovered_button = buttons_tab[index]
		hovered_button = focused_button
		Global.sound.new_sound("Hover")
		highlight_focused()
	else:
		focused_button = buttons_tab[0]
		hovered_button = buttons_tab[0]
		if popup_visible == false:
			popup_visible = true
		hovered_button = focused_button
		Global.sound.new_sound("Hover")
		highlight_focused()
			
func close_popup():
	if buttons_tab.has(focused_button) == true:
		pass
	else:
		focused_button = buttons_tab[0]
		hovered_button = buttons_tab[0]
	
	
	if popup_visible == false:
			popup_visible = true
	else:
		popup_visible = false
	hovered_button = focused_button
	Global.sound.new_sound("Hover")
	highlight_focused()

func _on_Button_SWAP_pressed():
		swap_weapons()
		

func press_equipment(string, item, button):
	var lookbag = false
	if item != null and Global.Player.bag.size() < Global.bagsize and focused_button == string and game.floor_cleared == true:
		effectmaker.create_effect_animated_ui_context(get_node("."), button.get_global_position(), "Click")
		lookbag = true
		take_off(item)
	elif Global.Player.bag.size() >= Global.bagsize and game.floor_cleared == true:
		ProcessText.spawn_text_popup_context($PopupLayer / Popup.position, "가방이 가득 참!", "[color=#ff2020]", $PopupLayer)
	elif game.floor_cleared == false and focused_button == string:
		ProcessText.spawn_text_popup_context($PopupLayer / Popup.position, "적이 가까이 있다!", "[color=#ff2020]", $PopupLayer)
	
	if string == "main" or string == "off":
		focused_weapon = string
	focused_button = string
	if lookbag == true:
		focused_button = "0bag"
	
	hovered_button = focused_button
	
	
	highlight_focused()
	update_deck_selected()

func equip1():
	var equipping = false
	for button in buttons_bag:
		if hovered_button == str(button.bag_index) + "bag":
			
			equipping = true
			var item = player.bag[button.bag_index]
			
			button.equip(item)
	if equipping == false:
		
		match hovered_button:
			"main":
				var item = player.weapon_main
				var button = $Buttons_Equipped / Button_WeaponMain
				press_equipment(focused_button, item, button)
			"off":
				var item = player.weapon_off
				var button = $Buttons_Equipped / Button_WeaponOff
				press_equipment(focused_button, item, button)
			"head":
				var item = player.armor_head
				var button = $Buttons_Equipped / Button_ArmorHead
				press_equipment(focused_button, item, button)
			"hand":
				var item = player.armor_hands
				var button = $Buttons_Equipped / Button_ArmorHand
				press_equipment(focused_button, item, button)
			"chest":
				var item = player.armor_chest
				var button = $Buttons_Equipped / Button_ArmorChest
				press_equipment(focused_button, item, button)
			"leg":
				var item = player.armor_legs
				var button = $Buttons_Equipped / Button_ArmorLeg
				press_equipment(focused_button, item, button)
	
func equip2():
	match hovered_button:
		"main":
			swap_weapons()
		"off":
			swap_weapons()
	
	for button in buttons_bag:
		if hovered_button == str(button.bag_index) + "bag":
			var item = player.bag[button.bag_index]
			if item.type == "weapon":
				button.equip_off(item)

func destroy():
	for button in buttons_bag:
		
		if hovered_button == str(button.bag_index) + "bag" and Global.Player.is_dead() == false:
			effectmaker.create_effect_animated_ui_context($PopupLayer, button.get_global_position(), "Flame")
			var selected_index = button.bag_index
			Global.sound.new_sound("Click")
			var item = player.bag[button.bag_index]
			
			if buttons_bag.size() > 1 and selected_index > 0:
				var new_index = button.bag_index - 1
				focused_button = str(new_index) + "bag"
				hovered_button = str(new_index) + "bag"
				
			else:
				hovered_button = "main"
				focused_button = "main"
			
			
			
			
			sacrifice_compose_upgrades(item)
			button.trash(item)
			

func hide_popup():
	
	$PopupLayer / Popup / Button_Popup_Background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$PopupLayer / Popup.position = Vector2(900, 0)
	$PopupLayer / CancelLoc.position = Vector2(900, 0)

	
func show_popup(position):
	if popup_visible == true:
		
		$PopupLayer / Popup / Button_Popup_Background.mouse_filter = Control.MOUSE_FILTER_STOP
		$PopupLayer / Popup.position = position
		$PopupLayer / CancelLoc.position = position
		if position.y <= 325:
			$PopupLayer / Popup.position.y += 128
		if position.x >= 200:
			$PopupLayer / Popup.position.x -= 128

		

func _on_Button_WeaponMain_pressed():
	var stringa = "main"
	
	var item = player.weapon_main
	
	if item != null and popup_visible == false:
		popup_visible = true
	else:
		popup_visible = false
	focused_button = stringa
	Global.sound.new_sound("Hover")
	highlight_focused()
	update_deck_selected()
	
	

func _on_Button_WeaponOff_pressed():
	var stringa = "off"
	
	var item = player.weapon_off
	
	if item != null and popup_visible == false:
		popup_visible = true
	else:
		popup_visible = false
	focused_button = stringa
	Global.sound.new_sound("Hover")
	highlight_focused()
	update_deck_selected()
	

	
func _on_Button_ArmorHead_pressed():
	var stringa = "head"
	
	var item = player.armor_head
	
	if item != null and popup_visible == false:
		popup_visible = true
	else:
		popup_visible = false
	focused_button = stringa
	Global.sound.new_sound("Hover")
	highlight_focused()
	update_deck_selected()
	


func _on_Button_ArmorHand_pressed():
	var stringa = "hand"
	
	var item = player.armor_hands
	
	if item != null and popup_visible == false:
		popup_visible = true
	else:
		popup_visible = false
	focused_button = stringa
	Global.sound.new_sound("Hover")
	highlight_focused()
	update_deck_selected()
	

func _on_Button_ArmorChest_pressed():
	var stringa = "chest"
	
	var item = player.armor_chest
	
	if item != null and popup_visible == false:
		popup_visible = true
	else:
		popup_visible = false
	focused_button = stringa
	Global.sound.new_sound("Hover")
	highlight_focused()
	update_deck_selected()
	


func _on_Button_ArmorLeg_pressed():
	var stringa = "leg"
	
	var item = player.armor_legs
	
	if item != null and popup_visible == false:
		popup_visible = true
	else:
		popup_visible = false
	focused_button = stringa
	Global.sound.new_sound("Hover")
	highlight_focused()
	update_deck_selected()
	


func _on_Button_Drop_pressed():
	if MODE_DROP == false:
		MODE_DROP = true
	else:
		MODE_DROP = false
	highlight_bag()


func _on_Button_Magi_pressed():
	ui.open_traits()


func _on_Button_God_pressed():
	ui.open_god()



func _on_Equip_pressed():
	
	
	equip1()
			
			
	

func _on_Equip2_pressed():
	equip2()

func _on_Destroy_pressed():
	
	destroy()

func _on_Button_SWAP_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Button_WeaponMain_mouse_entered():
	Global.sound.new_sound("Hover")
	hovered_button = "main"
	highlight_focused()


func _on_Button_WeaponOff_mouse_entered():
	Global.sound.new_sound("Hover")
	hovered_button = "off"
	highlight_focused()


func _on_Button_ArmorHead_mouse_entered():
	Global.sound.new_sound("Hover")
	hovered_button = "head"
	highlight_focused()


func _on_Button_ArmorHand_mouse_entered():
	Global.sound.new_sound("Hover")
	hovered_button = "hand"
	highlight_focused()


func _on_Button_ArmorChest_mouse_entered():
	Global.sound.new_sound("Hover")
	hovered_button = "chest"
	highlight_focused()


func _on_Button_ArmorLeg_mouse_entered():
	Global.sound.new_sound("Hover")
	hovered_button = "leg"
	highlight_focused()



	
	


func _on_Button_Close_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Button_Magi_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Button_God_mouse_entered():
	Global.sound.new_sound("Hover")



func _on_ButtonStates_mouse_entered():
	Global.sound.new_sound("Hover")
	hovered_button = "states"
	highlight_focused()

func _on_ButtonStates_mouse_exited():
	hovered_button = "none"
	highlight_focused()




func _on_Button_WeaponMain_mouse_exited():
	hovered_button = "none"
	highlight_focused()


func _on_Button_WeaponOff_mouse_exited():
	hovered_button = "none"
	highlight_focused()


func _on_Button_ArmorHead_mouse_exited():
	hovered_button = "none"
	highlight_focused()


func _on_Button_ArmorHand_mouse_exited():
	hovered_button = "none"
	highlight_focused()


func _on_Button_ArmorChest_mouse_exited():
	hovered_button = "none"
	highlight_focused()


func _on_Button_ArmorLeg_mouse_exited():
	hovered_button = "none"
	highlight_focused()


func _on_Equip_mouse_exited():
	hovered_button = "none"
	highlight_focused()


func _on_Equip2_mouse_exited():
	hovered_button = "none"
	highlight_focused()


func _on_Destroy_mouse_exited():
	hovered_button = "none"
	destroy_hovered = false
	highlight_focused()


func _on_Equip_mouse_entered():
	Global.sound.new_sound("Hover")
	
	
	
	

	
		
	
			
	
	
	
	
	
	
	
	
	

func _on_Equip2_mouse_entered():
	Global.sound.new_sound("Hover")
	
	
	

	
	
	
	
	
	
	
	
	

func _on_Destroy_mouse_entered():
	Global.sound.new_sound("Hover")
	
	for button in buttons_bag:
		if hovered_button == str(button.bag_index) + "bag":
			destroy_hovered = true
			write_descriptions()
	
	
	
	


func _on_Cancel_pressed():
	popup_visible = false
	highlight_focused()


func _on_Cancel_mouse_entered():
	Global.sound.new_sound("Hover")


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


func write_destroy():
	var stringa = ""
	var is_armor = false
	var is_equipped = false
	var dict = null
	var item = {
		"position": "none"
	}
	for button in buttons_bag:
		if focused_button == str(button.bag_index) + "bag":
			item = player.bag[button.bag_index]
	
	match item.position:
		"weapon":
			if Global.Player.weapon_main == null and Global.Player.weapon_off != null:
				dict = Global.Player.weapon_off
			else:
				dict = Global.Player.weapon_main
		"chest":
			is_armor = true
			dict = Global.Player.armor_chest
		"head":
			is_armor = true
			dict = Global.Player.armor_head
		"arm":
			is_armor = true
			dict = Global.Player.armor_hands
		"leg":
			is_armor = true
			dict = Global.Player.armor_legs
	
	if dict != null: is_equipped = true
	
	stringa = "[color=#a0a0a0][color=#ff4000]제물[/color] "
	stringa += item.name
	
	if is_equipped == true:
		stringa += "\n\nTo empower:\n\n"
		stringa += dict.name
		
		var multi = 0.25
		
		if "eris" in textstrip.strip_bbcode(item.name).to_lower():
			multi = 1.0
		
			
		
		if is_armor == false:
			var acc_amount = int(float(item.acc) * multi)
			if acc_amount < 1: acc_amount = 1
			acc_amount = "\n\n[color=#ffa050]+" + str(acc_amount * 10) + " 명중률"
			stringa += acc_amount
			
			
			var hit_amount = int(float(item.dmg) * multi)
			if hit_amount < 1: hit_amount = 1
			hit_amount = "\n[color=#ff8030]+" + str(hit_amount * 10) + " 명중"
			stringa += hit_amount
			
			
			var block_amount = int(float(item.arm) * multi)
			if block_amount < 1: block_amount = 1
			block_amount = "\n[color=#5050ff]+" + str(block_amount) + " 방어"
			stringa += block_amount
		else:
			var arm_amount = int(float(item.arm) * multi)
			if arm_amount < 1: arm_amount = 1
			arm_amount = "\n\n[color=#5050ff]+" + str(arm_amount) + " 방어력"
			stringa += arm_amount
			
		
		if "eris" in textstrip.strip_bbcode(item.name).to_lower():
			stringa += "\n\n[color=#707070][color=#fff0a0]에리스[/color]가 아이템 속성 100% 전달"
		else:
			stringa += "\n\n[color=#707070]보너스는 제물 아이템의 25%"
	else:
		stringa += "\n\n대응하는 장착 아이템 없음"
	
	stringa += "\n\n"
	stringa += "[color=#ff8080]+20 최대 체력[/color]"
	
	if Global.Player.get_traits().has("Goblin"):
		stringa += "\n\n\n[color=#90ff50]고블린의 길[/color]:"
		stringa += "\n\n[color=#ff8080]+25 최대 체력[/color]\n[color=#20ff20]+1 속도[/color] [color=#707070]기본[/color]"
	
	if item.position == "none": stringa = "error"
	
	return stringa

func sacrifice_compose_upgrades(item):
	var is_armor = false
	var is_equipped = false
	var dict = null
	var positiona = trans_position_to_inv_button(item)
	
	match item.position:
		"weapon":
			dict = Global.Player.weapon_main
			if dict != null:
				is_equipped = true
				$Image / weapon_main / AnimationPlayer.stop()
				$Image / weapon_main / AnimationPlayer.play("flash")
			elif Global.Player.weapon_off != null:
				dict = Global.Player.weapon_off
				is_equipped = true
				$Image / weapon_off / AnimationPlayer.stop()
				$Image / weapon_off / AnimationPlayer.play("flash")
		"chest":
			is_armor = true
			dict = Global.Player.armor_chest
			if dict != null:
				is_equipped = true
				$Image / armor_chest / AnimationPlayer.stop()
				$Image / armor_chest / AnimationPlayer.play("flash")
		"head":
			is_armor = true
			dict = Global.Player.armor_head
			if dict != null:
				is_equipped = true
				$Image / armor_head / AnimationPlayer.stop()
				$Image / armor_head / AnimationPlayer.play("flash")
		"arm":
			is_armor = true
			dict = Global.Player.armor_hands
			if dict != null:
				is_equipped = true
				$Image / armor_hands / AnimationPlayer.stop()
				$Image / armor_hands / AnimationPlayer.play("flash")
		"leg":
			is_armor = true
			dict = Global.Player.armor_legs
			if dict != null:
				is_equipped = true
				$Image / armor_legs / AnimationPlayer.stop()
				$Image / armor_legs / AnimationPlayer.play("flash")
	
	if dict != null: is_equipped = true
	else:
		$Image / body / AnimationPlayer.stop()
		$Image / body / AnimationPlayer.play("flash")
	
	var stringa = "[color=#ff4000]제물![/color]"
	
	if is_equipped == true:
		stringa += " 강화: "
		stringa += dict.name
		stringa += ""
		
		var multi = 0.25
		
		if "eris" in textstrip.strip_bbcode(item.name).to_lower():
			multi = 1.0
	
		
		
		if is_armor == false:
			var acc_amount = int(float(item.acc) * multi)
			if acc_amount < 1: acc_amount = 1
			dict.acc += acc_amount
			stringa += " [color=#ffa050]+" + str(acc_amount * 10) + " 명중률"
			ProcessText.spawn_text_popup_context(positiona, "+" + str(acc_amount * 10), "[color=#ffa050]", $PopupLayer)
			
			
			
			
			var hit_amount = int(float(item.dmg) * multi)
			if hit_amount < 1: hit_amount = 1
			dict.dmg += hit_amount
			stringa += " [color=#ff8030]+" + str(hit_amount * 10) + " 명중"
			ProcessText.spawn_text_popup_context(positiona, "+" + str(hit_amount * 10), "[color=#ff8030]", $PopupLayer)
			
			
			
			var block_amount = int(float(item.arm) * multi)
			if block_amount < 1: block_amount = 1
			dict.arm += block_amount
			stringa += " [color=#5050ff]+" + str(block_amount) + " 방어"
			ProcessText.spawn_text_popup_context(positiona, "+" + str(block_amount), "[color=#5050ff]", $PopupLayer)
		else:
			var arm_amount = int(float(item.arm) * multi)
			if arm_amount < 1: arm_amount = 1
			dict.arm += arm_amount
			stringa += " [color=#5050ff]+" + str(arm_amount) + " 방어력"
			ProcessText.spawn_text_popup_context(positiona, "+" + str(arm_amount), "[color=#5050ff]", $PopupLayer)
		
	if is_equipped == false: stringa += " 획득"
	stringa += " [color=#ff8080]+20 최대 체력"
	Global.Player.HP_max += 20
	Global.Player.HP += 20
	Global.Player.update()
	ProcessText.spawn_text_popup_context(positiona, "+20", "[color=#ff8080]", $PopupLayer)
	
	if Global.Player.get_traits().has("Goblin"):
		Global.Player.HP_max += 25
		Global.Player.HP += 25
		Global.Player.SPEED += 1
		ProcessText.spawn_text_popup_context(positiona, "+25", "[color=#ff8080]", $PopupLayer)
		ProcessText.spawn_text_popup_context(positiona, "+1", "[color=#20ff20]", $PopupLayer)
		$Image / body / AnimationPlayer.stop()
		$Image / body / AnimationPlayer.play("flash")
		
		
	
	ToolMessageCreator.add_message("[color=#c0c0c0]", stringa)
	
	if Global.Player.get_traits().has("Goblin"):
		ToolMessageCreator.add_message("[color=#c0c0c0]", "[color=#90ff50]고블린의 길![/color] [color=#ff8080]+25 최대 체력[/color]  [color=#20ff20]+1 속도[/color] [color=#707070]기본[/color]")
	
	

func trans_position_to_inv_button(item):
	var positiona = Vector2(0, 0)
	match item.position:
		"weapon":
			positiona = $Image / PointMain.get_global_position()
		"chest":
			positiona = $Image / PointChest.get_global_position()
		"head":
			positiona = $Image / PointHead.get_global_position()
		"arm":
			positiona = $Image / PointArm.get_global_position()
		"leg":
			positiona = $Image / PointLeg.get_global_position()
	return positiona


func _on_TextEdit_focus_entered():
	is_typing = true
	$TextEdit.text = ""


func _on_TextEdit_focus_exited():
	is_typing = false

func _on_TextEdit_text_changed(_new_text):
	var caret_location = $TextEdit.caret_position
	$TextEdit.text = $TextEdit.text.to_lower()
	$TextEdit.caret_position = caret_location
	highlight_bag()



func setup_deckbuttons():
	Global.universal.deck.deckbutton_selected = null
	Global.universal.deck.index_x = 0
	Global.universal.deck.index_y = 0
	
	
	update_deckbuttons(null)
	
	Global.universal.deck.set_first_button()


func update_deckbuttons(anode):
	Global.universal.deck.deckbuttons = [[$Button_Close, $Button_Magi], 
	[$Buttons_Equipped / Button_WeaponMain, $Buttons_Equipped / Button_WeaponOff, 
	$Buttons_Equipped / Button_ArmorHead, $Buttons_Equipped / Button_ArmorHand, $Buttons_Equipped / Button_ArmorChest, $Buttons_Equipped / Button_ArmorLeg]]
	
	

		
			
		
			
	
	if popup_visible == false:
		update_no_popup(anode)
		
	else:
		update_popup(anode)


func update_popup(anode):
	Global.universal.deck.deckbuttons = [[], []]
	Global.universal.deck.deckbuttons[0] = [$Button_Close, $Button_Magi]
	Global.universal.deck.deckbuttons[1] = [$PopupLayer / Popup / Equip, $PopupLayer / Popup / Equip2, $PopupLayer / Popup / Destroy]
	

func update_no_popup(anode):
	
	
	
	var start_index = Global.universal.deck.deckbuttons.size()
	
	for button in buttons_buffs:
		var x = start_index + button.index_x
		while Global.universal.deck.deckbuttons.size() - 1 < x:
			Global.universal.deck.deckbuttons.append([])
		Global.universal.deck.deckbuttons[x].append(button)
		
	
	
	start_index = Global.universal.deck.deckbuttons.size()
	for button in buttons_bag:
		var x = start_index + button.index_x
		while Global.universal.deck.deckbuttons.size() - 1 < x:
			Global.universal.deck.deckbuttons.append([])
		Global.universal.deck.deckbuttons[x].append(button)
		
	
	start_index = Global.universal.deck.deckbuttons.size()
	for button in buttons_trait:
		var x = start_index + button.index_x
		while Global.universal.deck.deckbuttons.size() - 1 < x:
			Global.universal.deck.deckbuttons.append([])
		Global.universal.deck.deckbuttons[x].append(button)
		

func update_deck_selected():
	
	var anode = $Buttons_Equipped / Button_WeaponMain

	
	match focused_button:
		"main":
			anode = $Buttons_Equipped / Button_WeaponMain
		"off":
			anode = $Buttons_Equipped / Button_WeaponOff
		"chest":
			anode = $Buttons_Equipped / Button_ArmorChest
		"head":
			anode = $Buttons_Equipped / Button_ArmorHead
		"hand":
			anode = $Buttons_Equipped / Button_ArmorHand
		"leg":
			anode = $Buttons_Equipped / Button_ArmorLeg
	

	
	for button in buttons_bag:
		if focused_button == str(button.bag_index) + "bag":
			anode = button
	
	for button in buttons_trait:
		if focused_button == button.trait.title:
			anode = button
	
	
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
	
		

		
		
