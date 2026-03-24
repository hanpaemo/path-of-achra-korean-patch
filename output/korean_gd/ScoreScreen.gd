extends Node2D

var scene_disabled = false
var screenshotted = false
var body_labels = ["main", "off", "head", "chest", "leg", "hand"]

var more_info = false

func _ready():
	
	
	setup_deckbuttons()
	write_screen(Global.last_score_data)

func _process(_delta):
	pass
	
	
	
		
		
		
		
		
func write_screen(data):
	var stringa = "[color=#c0c0c0]"
	stringa += data.name
	stringa += "\n\n"
	

	
	match data.condition:
		"victory":
			stringa += "[color=#ff3000]승리![/color]"
		"death":
			stringa += "사인: " + data.killer_name + "..."
			stringa += data.place_suffix + " " + data.place + "..."

		"abandon":
			stringa += "[color=#ff5050]길을 포기했습니다...[/color]"

	stringa += "\n\n"
	stringa += "[color=#ffff00]" + str(data.day) + "[/color]일차"
	
	stringa += "\n\n"
	stringa += cycler.int_to_cycle_name(data.cycle)
	
	
	
	stringa += "\n\n"
	
	stringa += "[color=#ff8080]체력[/color] [color=#ffff00]" + str(int(data.life)) + "[/color]"
	stringa += "\n[color=#ff7050]힘[/color] [color=#ffff00]" + str(int(data.str)) + "[/color]"
	stringa += "\n[color=#50ff70]민첩[/color] [color=#ffff00]" + str(int(data.dex)) + "[/color]"
	stringa += "\n[color=#c050ff]의지[/color] [color=#ffff00]" + str(int(data.wil)) + "[/color]"
	
	stringa += "\n\n[color=#707070]장착[/color]"
	
	for item in data.inventory:
		stringa += "\n" + item.name
	
	stringa += "\n\n[color=#707070]습득[/color]"
	
	for power in data.powers:
		stringa += "\n" + power.Name + " " + str(int(power.Level))
	
	stringa += "\n\n[color=#707070]업적"
	
	for feat in data.feats:
		stringa += "\n" + feat
		
			
			
		
	
	$RichTextLabel.bbcode_text = stringa
	
	
	
	
	
	
	
	
	
		
	
	
		
	
	
	
	
	
	
	
	
	
	
	stringa = "[right]"
	
	stringa += ""
	
	
	
	var enemies = []
	
	for title in data.enemies:
		enemies.append(LEnemies.enemy_data[title])
	
	for enemy in enemies:
		if enemy.boss == true:
			stringa += "[img]" + enemy.sprite + "[/img]"
			
	stringa += "\n"
	for enemy in enemies:
		if enemy.boss == false:
			stringa += "[img]" + enemy.sprite + "[/img]"
	
	stringa += ""
	if data.has("preta"):
		for sprite in data.preta:
			stringa += "[img]" + sprite + "[/img]"
	
	var allies = []
	if allies.size():
		stringa += "\n"
	
	for title in data.allies:
		allies.append(LAllies.ally_data[title])
	for ally in allies:
		stringa += "[img]" + ally.sprite + "[/img]"
	
	
	
	$enemies.bbcode_text = stringa
	
	stringa = "[center]"
	
	stringa += "[/center]"
	$allies.bbcode_text = stringa
	
	$Control.get_node("body").texture = load(data.body)
	for label in body_labels:
			draw_body_element(data, label)
	
	write_middle(data)
	
func write_middle(data):
	
	if more_info == false:
		$poem.bbcode_text = proem.compose_end_poem(data)
	
	
	else:
		pass
		var stringa = "[center][color=#a0a0a0]"
		stringa += "[color=#ff5050]" + str(data.game_turns) + "[/color] 턴 경과"
		stringa += "\n\n"
		stringa += "[color=#ffff00]" + translate.add_commas(str(data.times_attack)) + "[/color]회 공격 수행"
		stringa += "\n"
		stringa += "제자리 대기 [color=#ffff00]" + translate.add_commas(str(data.times_stood)) + "[/color]회"
		stringa += "\n"
		stringa += "기도 [color=#ffff00]" + translate.add_commas(str(data.times_pray)) + "[/color]회"
		stringa += "\n"
		stringa += "신의 개입 [color=#ffff00]" + translate.add_commas(str(data.times_intervention)) + "[/color]회"
		
		stringa += "\n\n"
		stringa += "피해 [color=#ffff00]" + translate.add_commas(str(data.damage_dealt)) + "[/color] 피해"
		stringa += "\n"
		stringa += "최대 피해 [color=#ffff00]" + translate.add_commas(str(data.highest_damage)) + "[/color]"
		if str(data.highest_damage_type) != "0":
				stringa += " " + str(data.highest_damage_type)
		stringa += "\n"
		stringa += "받은 피해 [color=#ffff00]" + translate.add_commas(str(data.damage_taken)) + "[/color] 피해"
		stringa += "\n"
		stringa += "회복량 [color=#ffff00]" + translate.add_commas(str(data.amount_healed)) + "[/color]"
		
		stringa += "\n\n"
		if data.highest_stack_effect > 0:
			stringa += "최고 적용 효과 [color=#ffff00]" + translate.add_commas(str(data.highest_stack_effect)) + "[/color] " + str(data.highest_stack_effect_label)
		else:
			stringa += "[color=#ff5050]효과 없음[/color]"
		
		
		stringa += "\n\n"
		stringa += "적 처치 [color=#ffff00]" + translate.add_commas(str(data.enemies_killed)) + "[/color]"
		
		stringa += "\n\n"
		stringa += "아군 소환 [color=#ffff00]" + translate.add_commas(str(data.allies_summoned)) + "[/color]"
		stringa += "\n"
		stringa += "[color=#ffff00]" + translate.add_commas(str(data.enemies_killed_by_allies)) + "[/color]마리 적이 아군에 의해 처치됨"
		stringa += "\n"
		stringa += "아군 사망 [color=#ffff00]" + translate.add_commas(str(data.allies_killed)) + "[/color]"
		
		$poem.bbcode_text = stringa

	
	
	
	



func draw_body_element(data, label):
	if data[label] != "none":
		$Control.get_node(label).texture = load(data[label])
	else:
		$Control.get_node(label).texture = null
			
func remove_unit_duplicates(data):
	var to_erase = []
	var cleaned_array = []
	for unit in data:
		cleaned_array.append(unit)
		var label = unit.name
		var count = 0
		for unit2 in data:
			if unit2.name == label:
				count += 1
			if count > 1:
				if to_erase.has(unit2) == false:
					to_erase.append(unit2)
	for unit in to_erase:
		cleaned_array.erase(unit)
	
	return cleaned_array
	
			

func quit():
	scene_disabled = true
	Global.universal.transition("start")


func _on_Button2_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Button2_pressed():
	quit()

func _input(event):
	if scene_disabled == false:
		if event.is_action_pressed("enter") or event.is_action_pressed("escape"):
			quit()
		Global.universal.deck.input_handler(event)
		
func setup_deckbuttons():
	if Global.universal.deck.allowed == true:
		Global.universal.deck.deckbuttons = [[$Button2, $Button3]]
		Global.universal.deck.index_x = 0
		Global.universal.deck.index_y = 0
		Global.universal.deck.set_first_button()


func _on_Button3_mouse_exited():
	Global.sound.new_sound("Hover")
	more_info = false
	write_middle(Global.last_score_data)


func _on_Button3_mouse_entered():
	Global.sound.new_sound("Hover")
	more_info = true
	write_middle(Global.last_score_data)
