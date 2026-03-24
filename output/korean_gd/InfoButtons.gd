extends Control


onready var stat_area = $Stats
onready var att_area = $Attributes
onready var context = get_parent()



func create_buttons():
	context.buttons_info = []
	var width = 100
	var height = 16
	var info = cloner.clone_dict(LInfo.info_data)
	
	var pos = att_area.position
	
	
	
	
	create_button(info.STR, pos, Color(1, 1, 0.5, 1))
	pos.y += height
	create_button(info.DEX, pos, Color(1, 1, 0.5, 1))
	pos.y += height
	create_button(info.WIL, pos, Color(1, 1, 0.5, 1))
	
	
	
	pos = $Main.position
	
	create_button(info.attack, pos, Color(1, 1, 1, 1))
	pos.y += height
	create_button(info.damage, pos, Color(1, 1, 1, 1))
	
	pos = $Off.position
	
	create_button(info.attack2, pos, Color(1, 1, 1, 1))
	pos.y += height
	create_button(info.damage2, pos, Color(1, 1, 1, 1))
	
	
	
	
	
	
	
	
	
	pos = att_area.position
	pos.y += 60
	
	for key in info:
		var button = info[key]
		var color = Color(1, 1, 1, 1)
		if button.auto == true:
			
			create_button(button, Vector2(pos.x + (button.x * width), pos.y + (button.y * height)), color)
	
	
	
	
	
	
	
	
	
	
	
	
	
	


func create_button(info, pos, color):
	
	var b = Global.ButtonInformation.instance()
	add_child(b)
	b.position = pos
	b.info = cloner.clone_dict(info)
	b.context = context
	b.type = "info"
	b.bag_index = 0
	b.in_inventory = true
	
	
	
		
	
	b.get_node("Sprite").texture = null
	b.get_node("text_icon").bbcode_text = info.text_icon
	b.get_node("Label").modulate = color
	
	context.buttons_info.append(b)
