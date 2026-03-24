extends Node2D


var button_selected = null
var scene_disabled = false
var button_hovered = null

var buttons = []

var auto_buffer = 0
var auto_buffer_max = 15

var total_achieved = []


var lore_data = {}

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
	
	lore_data = loader.load_data("res://Data/Table_Lore.json")
	for key in lore_data:
		print(key)
	
	update_from_graveyard()
	create_buttons()
	update_selected()
	
	
	var stringa = "[color=#707070]업적 달성...   "
	
	stringa += "[color=#ff80ff]"
	for n in total_achieved.size():
		stringa += "|"
	
	stringa += "[color=#404040]"
	for n in buttons.size() - total_achieved.size():
		stringa += "|"
	stringa += "   [color=#ff80ff]" + str(total_achieved.size())
	stringa += " [color=#707070]/" + str(buttons.size())
	$RichTextLabel3.bbcode_text = stringa
	setup_deckbuttons()
	


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
			button.modulate = Color(0.2, 0.2, 0.2, 1)
		else:
			button.modulate = Color(0.6, 0.6, 0.6, 1)
		
		if button.unlocked == true:
			button.modulate = Color(1, 1, 1, 1)


func write_button(button):
	var data = button.data
	
	var stringa = ""
	
	if button.type == "feat":
	
		stringa += data.name
	
	
		stringa += "\n\n[img]" + data.sprite + "[/img]"
		
		if button.unlocked == true: stringa += "\n\n" + write_lore(data.title)
		
	
		stringa += "\n\n" + data.description
		
	
	else:
		
		stringa += data.Name
		
		
		stringa += "\n\n[img]" + data.sprite + "[/img]"
		
		
		
		if button.unlocked == true: stringa += "\n\n" + write_lore(data.title)
		
		
		stringa += "\n\n" + data.Name + " 상위 직업으로 승리"
	
	
	
	if button.unlocked == false:
		
		stringa += "\n\n아직 달성하지 못함..."
	
		
	
		stringa = "[color=#707070]" + stringa
	
	else:
		
		stringa = "[color=#a0a0a0]" + stringa
		
		stringa += "\n\n[color=#ff80ff]달성!"
	
	$RichTextLabel.bbcode_text = stringa


func write_lore(title):
	var stringa = "[color=#909090]"
	
	if lore_data.has(title):
		if lore_data[title].text != null:
			stringa += lore_data[title].text
		
		else: stringa += "전승 준비 중..."
	
	else: stringa += "오 영광스러운 아크라여..."
	
	stringa += "[/color]"
	
	return stringa


func create_buttons():
	var powers = compose_total_feats()
	var x = 0
	var y = 0
	var columns = 0
	var columns_max = 10
	var first = true

	for power in powers[0]:

			var b = Global.FeatButton.instance()
			get_node("Node2D").add_child(b)
			b.get_node("Sprite").texture = load(power.sprite)
			b.position = Vector2(x, y)
			b.data = power
			b.context = self
			buttons.append(b)
			b.index_x = columns
			if ToolSettings.settings_data.feats.has(power.title):
				b.unlocked = true
				b.get_node("unlocked").visible = true
				total_achieved.append(b)
		
			x += 32
			columns += 1
			if columns > columns_max:
				columns = 0
				x = 0
				y += 32
			
			if first == true:
				button_selected = b
				first = false
	
	
	
	for power in powers[1]:
			
			var b = Global.FeatButton.instance()
			get_node("Node2D").add_child(b)
			b.get_node("Sprite").texture = load(power.sprite)
			b.position = Vector2(x, y)
			b.data = power
			b.context = self
			buttons.append(b)
			b.type = "prestige"
			b.index_x = columns
			if ToolSettings.settings_data.feats.has(power.title):
				b.get_node("unlocked").visible = true
				b.unlocked = true
				total_achieved.append(b)
		
			x += 32
			columns += 1
			if columns > columns_max:
				columns = 0
				x = 0
				y += 32


	

func compose_total_feats():
	var feats = []
	var prestiges = LTraitsGeneric.prestige_list
	
	var featdata = loader.load_data("res://Data/Table_Feats.json")
	var realfeats = []
	for key in featdata:
		var feat = featdata[key]
		realfeats.append(feat)
	
	feats.append(realfeats)
	
	var prestigefeats = []
	for element in prestiges:
		prestigefeats.append(cloner.clone_dict(element))
		
	feats.append(prestigefeats)
	
	return feats


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

func _input(event):
		if event.is_action_pressed("escape"):
			quit()
		if event.is_action_pressed("gamepad_y"):
				if ToolSettings.settings_data.gamepad_mode == "full":
					quit()
		if event.is_action_pressed("tab"):
			if Input.is_action_pressed("alt") == false and Input.is_action_pressed("shift") == false:
				if buttons.size() > 0:
					cycle_selection()
		if event.is_action_pressed("gamepad_b"):
				if ToolSettings.settings_data.gamepad_mode == "full":
					cycle_selection()
		Global.universal.deck.input_handler(event)

func quit():
	if scene_disabled == false:
		scene_disabled = true
		Global.universal.transition("first")

func _on_Quit_pressed():
	quit()


func _on_Quit_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Clear_pressed():
	pass
	
	
		
			
			
			


func _on_Clear_mouse_entered():
	var stringa = ""
	stringa += "[color=#a00000]모든 상위 직업 관련 Steam 업적 초기화[/color]"
	stringa += "\n\n[color=#707070]상위 직업 업적이 2024/1/10에 승리 필수로 변경되었으며, Steam 문구도 변경됨 (해금만으로는 불충분)"
	stringa += "\n\n Steam에서 다시 달성하려면 이 버튼으로 [color=#a00000]아직 승리하지 못한 상위 직업의 모든 업적을 초기화[/color]할 수 있습니다"
	stringa += " (버전 0.9.4.6 '업적' 이후)"
	$RichTextLabel.bbcode_text = stringa



func update_from_graveyard():
	ToolFeatGiver.update_from_graveyard()

func _on_Clear_mouse_exited():
	update_selected()

func setup_deckbuttons():
	Global.universal.deck.deckbuttons = []
	
	
	for button in buttons:
		while button.index_x >= Global.universal.deck.deckbuttons.size():
			Global.universal.deck.deckbuttons.append([])
		Global.universal.deck.deckbuttons[button.index_x].append(button)
		
	
	Global.universal.deck.deckbutton_selected = null
	Global.universal.deck.index_x = 0
	Global.universal.deck.index_y = 0
	Global.universal.deck.set_first_button()
	Global.universal.deck.deckbuttons.append([$Quit])
