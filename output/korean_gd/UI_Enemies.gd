extends Control

var game = null
var y_new = 0
var buttons = []
var buttons_traits = []
var is_open = false

var focused_button = "none"
var hovered_button = "none"


onready var display = get_node("Display")

func update():
	pass

func initiate():
	game = Global.game
	for button in buttons:
		button.queue_free()
	buttons = []
	close()
	y_new = 0
	
	var types = cloner.clone_array(game.ally_types)
	
	
	for n in types.size():
		var e = Global.ButtonInfoNode.instance()
		add_child(e)
		e.global_position.y = rect_position.y + y_new
		e.global_position.x = rect_position.x
		
		e.object_info = game.ally_types[n]
		e.get_node("Sprite").texture = load(game.ally_types[n]["sprite"])
		e.get_node("ColorRect").color = Color(0, 0.1, 0, 1)
		
		buttons.append(e)
		
		y_new += 32
	
	
	types = cloner.clone_array(game.enemy_types)
	
	
	for n in types.size():
		var e = Global.ButtonInfoNode.instance()
		add_child(e)
		e.global_position.y = rect_position.y + y_new
		e.global_position.x = rect_position.x
		
		e.object_info = game.enemy_types[n]
		e.get_node("Sprite").texture = load(game.enemy_types[n]["sprite"])
		e.get_node("ColorRect").color = Color(0.1, 0, 0, 1)
		
		buttons.append(e)
		
		y_new += 32
	



func close():
	
	is_open = false
	display.modulate = Color(1, 1, 1, 0)
	display.get_node("ColorRect").mouse_filter = Control.MOUSE_FILTER_IGNORE
	for button in buttons_traits:
		button.queue_free()
		focused_button = "none"
	buttons_traits = []
	
	
func open(clicked_button):
	
	is_open = true
	display.modulate = Color(1, 1, 1, 1)
	display.get_node("ColorRect").mouse_filter = Control.MOUSE_FILTER_STOP
	for n in buttons.size():
		if buttons[n] != clicked_button:
			buttons[n].close()
	
func load_info(object_info):
	
	
	display.get_node("Sprite").texture = load(object_info["sprite"])
	
	var stringa = "[color=#c0c0c0]"
	
	
	stringa += object_info.name_color
	
	stringa += "     "
	var checked_tags = []
	for tag in object_info.tags:
		if tag != "none" and checked_tags.has(tag) == false:
			stringa += " " + tag
			checked_tags.append(tag)
	
	stringa += "\n\n"
	stringa = stringa + "[color=#c0c0c0]" + object_info["description"] + "[/color]"
	
	
	
	display.get_node("decription").bbcode_text = stringa
	
	stringa = "\n\n"
	stringa += "[color=#c0c0c0]공격 속성: "
	stringa = stringa + translate.damage_type(object_info.dmgtype)
	stringa += " 피해"
	
	if object_info.range_attack != 1:
		stringa += " [color=#ffff50]"
		stringa += str(object_info.range_attack)
		stringa += " 사거리[/color]"
	else:
		stringa += " [color=#ffff50]근접[/color]"
	stringa += "\n\n"
	stringa += "[color=#ffff50]" + str(object_info.size) + "%[/color]"
	stringa += " 확률로 게임 턴에 해로운 효과에서 [color=#9010cf]회복[/color]"
	stringa += "\n"
	var typelist = ["slash", "blunt", "pierce", "fire", "ice", "poison", "lightning", "death", "psychic", "astral", "blood"]
	for label in typelist:
		if object_info.has("resist_" + label):
			var resist = object_info["resist_" + label]
			if resist != 0:
				stringa += "\n"
				stringa += translate.damage_type_to_color(label)
				stringa += "저항 "
				stringa += "[/color]"
				stringa += translate.damage_type(label)
				stringa += translate.value_to_color(resist)
				stringa += " " + str(resist) + "%"
				stringa += "[/color]"
				
	display.get_node("decription2").bbcode_text = stringa
	
	create_trait_buttons(object_info)
	
	
			

func create_trait_buttons(object_info):
	buttons_traits = []
	var parent = $Display / Buttons
	var pos = Vector2(0, 0)
	var unit = object_info
	for traitname in unit.abilities:
		if traitname != "none":
			var trait = LTraitsGeneric.trait_data[traitname]
			var e = Global.ButtonBag.instance()
			parent.add_child(e)
			e.context = get_node(".")
			e.type = "trait"
			e.trait = trait
			e.get_node("Sprite").texture = load(trait.sprite)
			e.position = pos
			
			e.info_other = cloner.clone_dict(object_info)
			
			pos.x += 32
			buttons_traits.append(e)
	
	if buttons_traits.size() >= 1:
		focused_button = buttons_traits[0].trait.title
		hovered_button = focused_button
	else:
		focused_button = "none"
		hovered_button = "none"
	highlight_focused()

func highlight_focused():
	var select = $Display / Buttons / Select
	if hovered_button == "none":
		hovered_button = focused_button
	if focused_button == "none":
		select.position = $Display / Buttons / offscreen.position
		$Display / Sprite_Focus.texture = null
		$Display / decription_focus.bbcode_text = ""
	else:
		for button in buttons_traits:
			if button.trait.title == focused_button:
				select.position = button.position
				
	
	for button in buttons_traits:
		if button.trait.title == hovered_button:
			$Display / Sprite_Focus.texture = load(button.trait.sprite)
			$Display / decription_focus.bbcode_text = describe_focused(hovered_button, button.info_other)

func describe_focused(label, info_other):
	var button = LTraitsGeneric.trait_data
	var trait = label
	var stringa = "[color=#c0c0c0]"
	stringa += LTraitsGeneric.trait_data[label]["Name"]
	stringa += "\n\n\n"
	stringa += LTraitsGeneric.trait_data[label]["Description_Unit"]
	if button[trait].reference != "none":
				stringa += "\n\n"
				var abuff = LBuffs.buff_data[button[trait].reference]
				stringa += abuff.color + abuff.name + ": [/color]" + abuff.description
	
	if label == "Amplification":
		stringa += cycler.write_amplification(info_other)
	return stringa
	
