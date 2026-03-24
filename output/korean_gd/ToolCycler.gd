extends Node


class_name cycler





static func unlock_next_cycle():
	var risen = false
	var max_cycle = 32
	
	if ToolSettings.settings_data.cycle_unlocked < max_cycle:
		if int(ToolSettings.settings_data.cycle_unlocked) == int(ToolSettings.settings_data.cycle_current):
			ToolSettings.settings_data.cycle_unlocked += 1
			ToolSettings.settings_data.cycle_current = ToolSettings.settings_data.cycle_unlocked
			risen = true
	
	
		
	
		
	ToolSettings.save_settings()
	return risen

static func toggle_current_cycle():
	if ToolSettings.settings_data.cycle_current < ToolSettings.settings_data.cycle_unlocked:
		ToolSettings.settings_data.cycle_current += 1
	else:
			ToolSettings.settings_data.cycle_current = 1

static func toggle_current_cycle_down():
	if ToolSettings.settings_data.cycle_current > 1:
		ToolSettings.settings_data.cycle_current -= 1
	else:
			ToolSettings.settings_data.cycle_current = ToolSettings.settings_data.cycle_unlocked

static func int_to_cycle_name(inta):
	var stringa = ""
	inta = int(inta)
	
	match inta:
		1:
			stringa += "[color=#c09050]첫 번째[/color] 겸손의 [color=#c09050]순환[/color]"
		2:
			stringa += "[color=#9050c0]두 번째[/color] 타락의 [color=#9050c0]순환[/color]"
		3:
			stringa += "[color=#50b050]세 번째[/color] 희망의 [color=#50b050]순환[/color]"
		4:
			stringa += "[color=#b03090]네 번째[/color] 절망의 [color=#b03090]순환[/color]"
		5:
			stringa += "[color=#3030e0]다섯 번째[/color] 깨달음의 [color=#3030e0]순환[/color]"
		6:
			stringa += "[color=#a02020]여섯 번째[/color] 소멸의 [color=#a02020]순환[/color]"
		7:
			stringa += "[color=#f06030]일곱 번째[/color] 종말의 [color=#f06030]순환[/color]"
		8:
			stringa += "[color=#f03090]여덟 번째[/color] 열정의 [color=#f03090]순환[/color]"
		9:
			stringa += "[color=#2020a0]아홉 번째[/color] 분열의 [color=#2020a0]순환[/color]"
		10:
			stringa += "[color=#408040]열 번째[/color] 탐식의 [color=#408040]순환[/color]"
		11:
			stringa += "[color=#908060]열한 번째[/color] 계시의 [color=#908060]순환[/color]"
		12:
			stringa += "[color=#ffaf20]열두 번째[/color] 영광의 [color=#ffaf20]순환[/color]"
		13:
			stringa += "[color=#8f208f]열세 번째 [color=#c0c0c0]순환:[/color] 집착[/color]"
		14:
			stringa += "[color=#ff806f]열네 번째 [color=#c0c0c0]순환:[/color] 고독[/color]"
		15:
			stringa += "[color=#af606f]열다섯 번째 [color=#c0c0c0]순환:[/color] 오만[/color]"
		16:
			stringa += "[color=#ff303f]열여섯 번째 [color=#c0c0c0]순환:[/color] 파열[/color]"
		17:
			stringa += "[color=#9f903f]열일곱 번째 [color=#c0c0c0]순환:[/color] 삭마[/color]"
		18:
			stringa += "[color=#3f307f]열여덟 번째 [color=#c0c0c0]순환:[/color] 소거[/color]"
		19:
			stringa += "[color=#3f907f]열아홉 번째 [color=#c0c0c0]순환:[/color] 태동[/color]"
		20:
			stringa += "[color=#3fd09f]스무 번째 [color=#c0c0c0]순환:[/color] 탁월[/color]"
		21:
			stringa += "[color=#dfa0ff]스물한 번째 [color=#c0c0c0]순환:[/color] 무관심[/color]"
		22:
			stringa += "[color=#afa00f]스물두 번째 [color=#c0c0c0]순환:[/color] 원한[/color]"
		23:
			stringa += "[color=#ff300f]스물세 번째 [color=#c0c0c0]순환:[/color] 학살[/color]"
		24:
			stringa += "[color=#6fff00]스물네 번째 [color=#c0c0c0]순환:[/color] 신성[/color]"
		25:
			stringa += "[color=#A0522D]스물다섯 번째 [color=#c0c0c0]순환:[/color] 암울한 수정[/color]"
		26:
			stringa += "[color=#DA70D6]스물여섯 번째 [color=#c0c0c0]순환:[/color] 깨진 율법[/color]"
		27:
			stringa += "[color=#00BFFF]스물일곱 번째 [color=#c0c0c0]순환:[/color] 우주적 분노[/color]"
		28:
			stringa += "[color=#DC143C]스물여덟 번째 [color=#c0c0c0]순환:[/color] 부풀은 공포[/color]"
		29:
			stringa += "[color=#B0E0E6]스물아홉 번째 [color=#c0c0c0]순환:[/color] 뒤틀린 빛[/color]"
		30:
			stringa += "[color=#4169E1]서른 번째 [color=#c0c0c0]순환:[/color] 가라앉은 세계[/color]"
		31:
			stringa += "[color=#00FA9A]서른한 번째 [color=#c0c0c0]순환:[/color] 부서진 탑[/color]"
		32:
			stringa += "[color=#8A2BE2]서른두 번째 [color=#c0c0c0]순환:[/color] 외부의 어둠[/color]"
	
	return stringa

static func get_multi():
	var multi = 0
	multi = int(ToolSettings.settings_data.cycle_current)
	if multi >= 6:
		multi += (multi / 2)
	if multi > 24:
		multi += (multi / 2)
	if multi >= 30:
		multi += (multi / 2)
	if StateWorld.land == "dust":
		multi = StateWorld.Floor_Current * StateWorld.Floor_Current
	
		
	return multi

static func apply_cycle_bonus(unit, list):
	
	var rng = Global.rng
	var multi = get_multi()
	
	
	
	
		
	
	var multi_min = 0
	if float(multi) / 2.0 > 0.0:
		multi_min = int(float(multi) / 2.0)
	
	var allowed = false
	if multi > 1 and StateWorld.day > 0:
		allowed = true
	if StateWorld.land == "dust":
		allowed = true
	
	if allowed == true:
		
		unit.cycle_boosted = true
		
		if list.has("hit") == false:
			var new_multi = rng.randi_range(multi_min, multi)
			new_multi /= 2
			if new_multi < 1:
				new_multi = 1
			var damage_increase = unit.damage * new_multi
			if damage_increase > 100.0:
				damage_increase = 100.0 + (new_multi * 5.0)
			if new_multi > 0:
				var action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": damage_increase, 
				"type": "damage", 
				"msg": "Amplification"
				}
				unit.get_node("AnimationPlayer2").play("cycle")
				ProcessQueue.add_effect(action)
		
		for attribute in list:
			var new_multi = rng.randi_range(multi_min, multi)
			if new_multi > 0:
				var action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": 0.0, 
				"type": "none", 
				"msg": "Amplification"
				}
			
				match attribute:
					"hp":
						var new_hp = unit.HP_max * new_multi
						if unit.type.boss == false:
							if new_hp > ToolSettings.settings_data.cycle_current * 1000.0:
								new_hp = (ToolSettings.settings_data.cycle_current * 1000.0) + (200.0 * new_multi)
						action.amount = new_hp
						action.type = "life"
					"armor":
						action.amount = unit.ARM * new_multi
						action.type = "armor"
					"accuracy":
						action.amount = unit.accuracy * new_multi
						action.type = "accuracy"
					"hit":
						unit.get_node("AnimationPlayer2").play("cycle")
						var damage_increase = unit.damage * new_multi
						if damage_increase > 100.0:
							damage_increase = 100.0 + (new_multi * 5.0)
						action.amount = damage_increase
						action.type = "damage"
					"block":
						action.amount = unit.deflect_strength * new_multi
						action.type = "block"
					"speed":
						action.amount = unit.speed * new_multi
						action.type = "speed"
					"dodge":
						action.amount = unit.dodge * new_multi
						action.type = "dodge"
				
				
			
			

				ProcessQueue.add_effect(action)

static func write_amplification(type):
	
	if type.has("cycle"):
	
		var stringa = ""
	
		for string in type.cycle:
			stringa += "\n"
		
			match string:
				"hit":
					stringa += "     [color=#ff8030]+ 명중[/color]"
				"accuracy":
					stringa += "     [color=#ffa050]+ 명중률[/color]"
				"dodge":
					stringa += "     [color=#50ffff]+ 회피[/color]"
				"block":
					stringa += "     [color=#5050ff]+ 방어[/color]"
				"armor":
					stringa += "     [color=#5050ff]+ 방어력[/color]"
				"speed":
					stringa += "     [color=#20ff20]+ 속도[/color]"
				"hp":
					stringa += "     [color=#ff8080]+ 최대 체력[/color]"
	
		return stringa

static func glory_bonus(glory):
	var rng = Global.rng
	var multi = get_multi()
	var multi_min = 1.0
	
	if ToolSettings.settings_data.cycle_current > 24:
		multi = 24 + (int(ToolSettings.settings_data.cycle_current) / 2)

	
	if StatePlayerSheet.level >= Global.cycle_taper:
		multi = ToolSettings.settings_data.cycle_current / 3
		if multi < 1: multi = 1
	

	multi_min = int(multi_min)
	
	if StateWorld.land == "dust":
		if StateWorld.Floor_Current > 1:
			multi = StateWorld.Floor_Current / 2
		else:
			multi = 1
	
	if multi > 1:
		multi = rng.randi_range(multi_min, multi)
		glory *= multi
		print("glory multiplied")
	
	return glory
