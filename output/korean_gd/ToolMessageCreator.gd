extends Node

var MessageNode = null
var message_array = []
var hovering = false
var hover_info = null
var hover_info_type = "none"
var item_popup = null
var recent_message = ""
var recent_message_count = 1

var max_size = 500


class_name messages

func compose_ability_message(text, unit):
	var stringa = text
	if unit == Global.Player:
		stringa = "당신이 사용: " + stringa + ":"
	else:
		stringa = unit.get_name_color() + "(이)가 사용: " + stringa + ":"
	
	
	

func compose_damage_increase_message(text, unit):
	var stringa = text
	if unit == Global.Player:
		stringa = "피해가 증가: " + stringa + ":"
	else:
		stringa = unit.get_name_color() + " 피해 증가: " + stringa + ":"
	
	
	

func compose_damage_reduce_message(text, unit):
	var stringa = text
	if unit == Global.Player:
		stringa = "피해가 감소: " + stringa + ":"
	
	
	
	

func add_message(color, text):
	
		var message = color + "" + text
		if message_array.size() > max_size:
			var e = message_array[0]
			message_array.erase(e)
		
		
		
				
		if message == recent_message and message != "[color=#702070]*[/color]":
			recent_message_count += 1
			
			message_array[message_array.size() - 1] = recent_message + " [color=#505050]x" + str(recent_message_count) + "[/color]"
		else:
			recent_message = message
			recent_message_count = 1
			message_array.append(message)
		update()

func add_if_unique(color, text):
	var is_unique = true
	var message = color + "" + text
	
	if message_array.size() > max_size:
		var e = message_array[0]
		message_array.erase(e)
	for n in 5:
		if message_array[message_array.size() - (n + 1)] == message:
			is_unique = false
	
	if is_unique == true:
		message_array.append(message)
		update()

func update():
	if is_instance_valid(MessageNode):
		update_gated()
	else:
		if item_popup != null:
			item_popup.visible = false

func update_gated():
	var stringa = ""
	var message_log_size = 5
	var message_log_alignment = ""
	var message_log_indent = "\n"
	
	if item_popup != null:
		item_popup.visible = false
		
		
		if get_viewport().get_mouse_position().x >= 360:
			item_popup.position.x = 21
		else:
				item_popup.position.x = 400
	
	if ToolSettings.settings_data.long_log == true:
		message_log_size = 50
		message_log_alignment = ""
		message_log_indent = "   "
	
	
	if message_array.size() > 0:
		var display = message_array
		
		for n in message_log_size:

			var index = (display.size() - 1) - ((message_log_size - 1) - n)
			if display.size() > index and index > - 1:
				
				var message = display[index]
		
			
				if stringa != "":
					stringa = stringa + message_log_indent + message
				else:
					stringa = "[color=#c0c0c0]" + message_log_alignment + message
	
	if MessageNode != null:
		if hover_info != null:
			stringa = create_hovered_string()
		
		MessageNode.bbcode_text = stringa
		

func create_hovered_string():
	var stringa = ""
	
	match hover_info_type:
		"unit":
			stringa = write_unit(hover_info)
		"enemy_cont":
			
			
			write_enemy_popup(hover_info)
			item_popup.visible = true
		"item_cont":
			
			write_item_popup(hover_info)
			item_popup.visible = true
		"invoke":
			stringa = "[color=#a0a0a0][[color=#ffff50]" + str(hover_info.hotkey) + "[/color]] "
			stringa += "[color=#c0c0c0][color=#589c84]암송:[/color] " + hover_info.name
			if hover_info.level_required > Global.Player.level:
				stringa += "   [color=#ff5050]영광 필요: " + str(hover_info.level_required) + "[/color]"
			else:
				pass
				
				
				
				
				
			stringa += "\n" + hover_info.description_short
			if hover_info.reference != "none":
					stringa += "\n"
					var abuff = LBuffs.buff_data[hover_info.reference]
					stringa += abuff.color + abuff.name + ": [/color]" + abuff.description
		"feature":
			stringa = write_tile_feature(hover_info)
		"buff":
			stringa = "[color=#c0c0c0]" + hover_info.color + hover_info.name + "[/color]" + "[color=#c0c0c0]: " + hover_info.description + "[/color]"
			
		"inventory":
			stringa = "[color=#a0a0a0][[color=#ffff50]i[/color]]"
			stringa += " 인벤토리, 능력치, 무기 및 방어구 장착"
			stringa += "\n\n[color=#a0a0a0][[color=#ffff50]5[/color]]를 눌러 주무장과 보조 무기를 교체 [color=#707070]행동으로 치지 않으며, 인벤토리에서도 수행 가능"
		"powers":
			stringa = "[color=#a0a0a0][[color=#ffff50]p[/color]]"
			stringa += " 새로운 능력을 배우고 레벨업"
		"menu":
			stringa = "[color=#a0a0a0][[color=#ffff50]esc[/color]]"
			stringa += " 설정 메뉴"
		"log":
			stringa = "[color=#a0a0a0][[color=#ffff50]g[/color]]"
			stringa += " 이벤트 로그 확장"
		"life":
			stringa += "당신의 [color=#ff5050]생명력[/color]...  [color=#78bca4]신의 개입[/color]으로 [color=#ff3030]죽음[/color]을 막아줍니다 [img]res://Ham_Sprite/UI/Ankh.png[/img], 무작위 [color=#78bca4]완충된 기도[/color]의 모든 충전을 소모합니다\n[color=#ffff50]영광 "
			stringa += str(Global.Player.level) + "  [color=#c0c0c0]" + str(Global.Player.xp) + " /" + str(Global.Player.xp_needed) + ""
			stringa += "  새 지역 진입과 비소환 적 처치로 획득"
			stringa += "\n[color=#50a050]" + str(int(100 * Global.game.get_node("GameBars").get_node("SpeedBar").rect_scale.x)) + "%[/color] 다음 '게임 턴'까지, 속도에 비례하여 진행; '게임 턴' 직전에 [color=#50ff50]초록[/color]으로 변함"
		"autolevel":
			stringa += "영광이 오르면 [color=#ff9000]자동 선택[/color]할 능력치를 설정합니다"
		"order":
			stringa += "[color=#a0a0a0]"
			stringa += "아군 명령, 현재: "
			match Global.summon_order:
				"attack":
					stringa += "[color=#ff5050]공격[/color]으로 이동"
				"hold":
					stringa += "[color=#ffff50]위치[/color] 고수"
			
			stringa += "\n\n소환 아군: [color=#b050b0]" + str(Global.get_allies_size_minus_familiars() - 1) + " 소환된[/color] 아군"
			stringa += ", 한계: [color=#707070]" + str(Global.Player.get_total_WIL()) + " (의지)[/color]"
			stringa += "\n사역마: [color=#703080]" + str(Global.Allies.size() - Global.get_allies_size_minus_familiars())
			stringa += " 소환된 사역마[/color], 무제한"
			
			
		
		
		"cycle":
			stringa += "먼지의 길 현재 층"
			stringa += "\n적이 [color=#af40af]증폭[/color]을 획득 up to x[color=#ffff50]" + str(cycler.get_multi()) + "[/color]"
			stringa += "\n5층 이상에서만 [color=#a0a000]사후 영광[/color]을 얻습니다"
		
		"SwapCont":
			stringa = "[color=#a0a0a0][[color=#ffff50]tab[/color]]"
			stringa += " 땅 전환"
	
	stringa = "[color=#a0a0a0]" + stringa
	
	
	
	
	return stringa


func clear():
	message_array = []
	update()


func write_tile_feature(tile):
	var stringa = "[color=#c0c0c0]"
	if tile.type == Global.Tile_Type.STAIRS:
		stringa += "[color=#ffff50]출구[/color]입니다\n"
	
	if tile.pile.size() > 0:
		stringa += "[color=#c0c0c0]바닥에 보이는 것: [/color]"
		for item in tile.pile:
			stringa += item.name + "\n"
	if tile.tileset.special == true and tile.resident == null:
			stringa += "  " + tile.tileset.description
	if tile.resident == Global.Player:
		if Global.Player != null:
			stringa += write_unit(Global.Player)
	
	return stringa
	


func write_unit(unit):
	var stringa = "[color=#909090]"
	if unit != Global.Player:
		stringa += unit.type.name_color
	else:
		stringa += "[color=#ffff50]" + unit.title_name + "[/color]"
	
	if Global.Enemies.has(unit):
		stringa += "  " + "[color=#ff5050]적[/color]"
		
	if Global.Allies.has(unit) and unit != Global.Player:
		stringa += "  " + "[color=#50ff50]아군[/color]"
	
	if unit != Global.Player:
		if unit.type.abilities.has("Familiar"):
			stringa += "  [color=#c050ff]사역마[/color]"
	
	var checked_tags = []
	if unit.object_type == "ally":
		for tag in unit.type.tags:
			if tag != "none" and checked_tags.has(tag) == false:
				checked_tags.append(tag)
				stringa += "  " + tag
	
	stringa += "  [color=#ff8080]" + str(int(unit.HP)) + "[/color] /" + str(int(unit.HP_max))
	var weapon_text = null
	if unit == Global.Player:
		weapon_text = unit.weapon_main
	stringa += "  사거리 [color=#ffff50]" + str(unit.get_range_attack(weapon_text)) + "[/color]"
	
		
	
	

	
	if unit.residence.tileset.special == true:
		stringa += "  " + unit.residence.tileset.description
	
	
	if unit == Global.Player:
		stringa += "\n주무장  "
	else:
		stringa += "\n"
	
	stringa += "명중률 [color=#ffa050]" + str(int(unit.get_ACC_total(weapon_text))) + "[/color]"
	stringa += "  명중 [color=#ff8030]" + str(int(unit.get_DMG_total(weapon_text))) + "[/color]"
	stringa += " " + translate.damage_type(unit.get_DMG_type(weapon_text))
	
	if unit == Global.Player:
		if unit.get_hands_used() <= 1:
			stringa += "  양손 장착"
		else:
			weapon_text = unit.weapon_off
			stringa += "  /  보조  명중률 [color=#ffa050]" + str(int(unit.get_ACC_total(weapon_text))) + "[/color]"
			stringa += "  명중 [color=#ff8030]" + str(int(unit.get_DMG_total(weapon_text))) + "[/color]"
			stringa += " " + translate.damage_type(unit.get_DMG_type(weapon_text))
			weapon_text = unit.weapon_main
			
	stringa += "\n속도 [color=#20ff20]" + str(int(unit.get_SPEED())) + "[/color]"
	if unit != Global.Player:
		stringa += " [color=#707070](" + str(int(unit.speedmin)) + ")[/color]"
	else:
		stringa += " [color=#707070](" + str(int(unit.get_SPEED_min())) + ")[/color]"
	stringa += "  회피 [color=#50ffff]" + str(int(unit.get_DEF_total())) + "[/color]"
	stringa += "  방어력 [color=#5050ff]" + str(int(unit.get_ARM())) + "[/color]"
	
	
	if unit == Global.Player:
		stringa += "  방어 [color=#5050ff]" + str(int(unit.get_block_chance())) + "% "
	else:
		stringa += "  방어 [color=#5050ff]50% "
	stringa += str(int(unit.get_block_strength())) + "[/color]"
	
	
	if unit == Global.Player:
		var color = "[color=#50ff50]"
		var stringsegment = str(int(unit.get_total_weight()))
				
		if int(unit.get_total_weight()) > 0:
					color = "[color=#ff0000]"
		if int(unit.get_total_weight()) <= int(unit.get_total_STR()):
					color = "[color=#00ff00]"
		stringsegment = color + stringsegment + "[/color]" + " [color=#707070]-" + str(unit.get_total_STR())
		
		stringa += "  하중 " + stringsegment
	
		color = "[color=#50ff50]"
		stringsegment = str(int(unit.get_total_inflex()))
		if int(unit.get_total_inflex()) > 1:
			stringsegment += " !"
			color = "[color=#ff0000]"
		stringsegment = color + stringsegment + "[/color]"
		
		stringa += "  경직 " + stringsegment
		
		
	stringa += "\n"
	
	var typelist = ["slash", "blunt", "pierce", "fire", "ice", "poison", "lightning", "death", "psychic", "astral", "blood"]
	
	var are_resists = false
	for label in typelist:
		var resist = unit.get_resist(label)
		if resist != 0:
				if are_resists == false:
					are_resists = true
					stringa += "[/color][color=#707070]저항 [/color]"
				stringa += translate.damage_type_to_color(label)
				stringa += ""
				stringa += "[/color]"
				stringa += translate.damage_type(label)
				stringa += translate.value_to_color(resist)
				stringa += " " + str(resist) + "%"
				stringa += "[/color]"
				stringa += "  "
			
	
	
		
	if unit != Global.Player:
		if unit.Buffs.size() > 0:
			stringa += " "
			for buff in unit.Buffs:
				stringa += buff.color + buff.name + "[/color] " + str(buff.duration) + "  "
	return stringa

func write_enemy_cont(data):
	var stringa = "[color=#c0c0c0]"
	stringa += data.name_color
	stringa += "   [color=#707070]" + data.description + "[/color]"
	stringa += "..."
	stringa += "\n공격 속성: "
	stringa += translate.damage_type(data.dmgtype) + " 피해"
	stringa += "  [color=#808080]저항... "
	var typelist = ["slash", "blunt", "pierce", "fire", "ice", "poison", "lightning", "death", "psychic", "astral", "blood"]
	for label in typelist:
		var resist = data["resist_" + label]
		if resist != 0:
			
			stringa += translate.damage_type_to_color(label)
			stringa += ""
			stringa += "[/color]"
			stringa += translate.damage_type(label)
			stringa += translate.value_to_color(resist)
			stringa += " " + str(resist) + "%"
			stringa += "[/color]"
			stringa += "  "
	stringa += "\n[color=#707070][[color=#ffff50]클릭[/color]] 상세 정보 보기"
	
	if data.has("map_hidden"):
		if data.map_hidden == true:
			stringa = "[color=#a0a0a0]" + data.rumor + "[/color]"
	
	return stringa

func write_item_cont(data):
	var stringa = "[color=#c0c0c0]"
	stringa += data.name
	stringa += "\n[color=#c0c0c0]" + data.rumor + "[/color]"
	stringa += "\n[color=#808080]저항... "
	var typelist = ["slash", "blunt", "pierce", "fire", "ice", "poison", "lightning", "death", "psychic", "astral", "blood"]
	for label in typelist:
		var resist = data["resist_" + label]
		if resist != 0:
			
			stringa += translate.damage_type_to_color(label)
			stringa += ""
			stringa += "[/color]"
			stringa += translate.damage_type(label)
			stringa += translate.value_to_color(resist)
			stringa += " " + str(resist) + "%"
			stringa += "[/color]"
			stringa += "  "
	stringa += "\n[color=#707070][[color=#ffff50]클릭[/color]] 상세 정보 보기"
	
	if data.has("map_hidden"):
		if data.map_hidden == true:
			stringa = "[color=#a0a0a0]" + data.rumor + "[/color]"
	
	return stringa



func write_enemy_popup(data):
	var stringa = "[color=#c0c0c0]"
	stringa += data.name_color
	stringa += "\n\n[color=#707070]" + data.description + "[/color]"
	stringa += "\n\n"

	stringa += "[color=#ff8080]" + str(data.hp) + "[/color] 체력"
	if data.cycle.has("hp") and ToolSettings.settings_data.cycle_current > 1: stringa += " [color=#af40af]+ 순환[/color]"
	
	stringa += "\n"

	stringa += "[color=#20ff20]" + str(data.speed) + "[/color] 속도, "
	if data.has("speedmin"):
		stringa += str(data.speedmin) + " 최소"
	if data.cycle.has("speed") and ToolSettings.settings_data.cycle_current > 1: stringa += " [color=#af40af]+ 순환[/color]"
	
	
	stringa += "\n[color=#b0b0b0]" + str(data.range_attack) + "[/color] 사거리"
	stringa += ", " + translate.damage_type(data.dmgtype) + " 피해"
	
	var resistcolor = "[color=#ffff50]"
	if Global.Player.get_resist(data.dmgtype) > 0: resistcolor = "[color=#00ff00]"
	if Global.Player.get_resist(data.dmgtype) < 0: resistcolor = "[color=#ff0000]"
	
	stringa += " [color=#707070]저항[/color] " + resistcolor + str(Global.Player.get_resist(data.dmgtype)) + "%[/color]"
	
	stringa += "\n"
	stringa += "[color=#ffa050]" + str(data.accuracy[0] * 10) + "[/color] 명중률"
	if data.cycle.has("accuracy") and ToolSettings.settings_data.cycle_current > 1: stringa += " [color=#af40af]+ 순환[/color]"
	
	stringa += "\n"
	stringa += "[color=#ff8030]" + str(data.damage[0] * 10) + "[/color] 명중"
	if data.cycle.has("hit") and ToolSettings.settings_data.cycle_current > 1: stringa += " [color=#af40af]+ 순환[/color]"
	
	stringa += "\n"
	stringa += "[color=#50ffff]" + str(data.dodge[0] * 10) + "[/color] 회피"
	if data.cycle.has("dodge") and ToolSettings.settings_data.cycle_current > 1: stringa += " [color=#af40af]+ 순환[/color]"
	
	stringa += "\n"
	stringa += "[color=#5050ff]" + str(data.deflect[2]) + "[/color] 방어"
	if data.cycle.has("block") and ToolSettings.settings_data.cycle_current > 1: stringa += " [color=#af40af]+ 순환[/color]"
	
	stringa += "\n"
	stringa += "[color=#5050ff]" + str(data.arm) + "[/color] 방어력"
	if data.cycle.has("armor") and ToolSettings.settings_data.cycle_current > 1: stringa += " [color=#af40af]+ 순환[/color]"
	
	
	
	
	stringa += "\n\n\n[color=#808080]저항:\n"
	var typelist = ["slash", "blunt", "pierce", "fire", "ice", "poison", "lightning", "death", "psychic", "astral", "blood"]
	for label in typelist:
		var resist = data["resist_" + label]
		if resist != 0:
			
			stringa += translate.damage_type_to_color(label)
			stringa += "\n"
			stringa += "[/color]"
			stringa += translate.damage_type(label)
			stringa += translate.value_to_color(resist)
			stringa += " " + str(resist) + "%"
			stringa += "[/color]"
			stringa += ""
	
	stringa += "\n\n\n[color=#808080]특성:\n"
	for key in data.abilities:
		if key != "none":
			stringa += "\n"
			stringa += LTraitsGeneric.trait_data[key].Name
	
	stringa += "\n\n\n[color=#707070][[color=#ffff50]클릭[/color]] 상세 특성 정보 보기"
	
	item_popup.get_node("label").bbcode_text = stringa
	


func write_item_popup(data):
	
	if item_popup != null:
	
	
		if data.type == "weapon":
			write_weapon(data)
		
		elif data.type == "armor":
			write_armor(data)

func write_weapon(data):
	var stringa = data.name
	var weapon = data
	stringa += "\n\n"
	stringa += "[color=#707070]"
	stringa += data.rumor
	stringa += ".."
	
	if data.rarity >= 2:
		stringa += "에서 발견: [color=#9000a0]공허[/color]"
	
	stringa += "[/color]"
	
	
	
	stringa += "\n\n[color=#ffa050]" + str(weapon.acc * 10) + " [color=#a0a0a0]명중률[/color][/color]"
	stringa += "\n[color=#ff8030]" + str(weapon.dmg * 10) + " [color=#a0a0a0]명중[/color][/color]"
	stringa += " " + translate.damage_type(weapon["dmgtype"])
	stringa = stringa + "\n[color=#5050ff]" + str(weapon.arm) + " [color=#a0a0a0]방어[/color][/color]"
	stringa += "\n"
	if weapon != null:
		if translate.is_bare_fist(weapon) == true:
	
			stringa += translate.get_bare_fist_text()
			stringa += "\n"
	
	
	
	
	stringa = stringa + "\n[color=#c0c0c0]" + str(weapon.range) + "[/color] [color=#a0a0a0]사거리[/color] "
	
	
	
	stringa = stringa + "\n"
	

		
	stringa = stringa + "\n[color=#ff0000]" + str(weapon.weight) + " [/color][color=#a0a0a0]하중[/color]"
	stringa = stringa + "\n[color=#ff0000]" + str(weapon.size) + " [/color][color=#a0a0a0]무기 크기[/color]"
	

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
	
	
	stringa += translate.get_shield_or_aoe_text(weapon)
	
		
		
		
		
	
	
		
		
			
	
	stringa = stringa + "\n"

	
		
	for trait in weapon.abilities:
			if trait != "none":
				var traitreal = LTraitsGeneric.trait_data[trait]
				
				stringa = stringa + "\n[img]" + traitreal.sprite + "[/img]"
			
				stringa = stringa + "\n[color=#c0c0c0]" + traitreal.Description
				
				if traitreal.reference != "none":
					stringa += "\n\n"
					var abuff = LBuffs.buff_data[traitreal.reference]
					stringa += "[color=#707070]효과[/color]\n" + abuff.color + abuff.name + ": [/color]" + abuff.description
				
				
				
				stringa = stringa + "\n"
		
		
	
	if data.has("tile_name"):
		stringa += "\n...in " + data.tile_name + "  [img]" + data.tile_sprite + "[/img]"
	
	item_popup.get_node("label").bbcode_text = stringa
	

func write_armor(data):
	var stringa = data.name
	var armor = data

	stringa += "\n\n"
	stringa += "[color=#707070]"
	stringa += data.rumor
	stringa += ".."
	
	if data.rarity >= 2:
		stringa += "에서 발견: [color=#9000a0]공허[/color]"
	stringa += "[/color]"
	
	
	stringa += "\n\n[color=#5050ff]" + "+" + str(armor.arm) + " [color=#a0a0a0]방어력[/color][/color]\n"
	stringa += "\n[color=#ff0000]" + "+" + str(armor.weight) + " [color=#a0a0a0]하중[/color][/color]"
		
		
		
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
				
		
		
	stringa += "\n[color=#c0c0c0]"
	for trait in armor.abilities:
			if trait != "none":
				var traitreal = LTraitsGeneric.trait_data[trait]
				
				stringa = stringa + "\n[img]" + traitreal.sprite + "[/img]"
				
				stringa = stringa + "\n" + traitreal.Description
				
				if traitreal.reference != "none":
					stringa += "\n\n"
					var abuff = LBuffs.buff_data[traitreal.reference]
					stringa += "[color=#707070]효과[/color]\n" + abuff.color + abuff.name + ": [/color]" + abuff.description
			
			stringa = stringa + "\n"
				
				
				
	
	if data.has("tile_name"):
		stringa += "\n...in " + data.tile_name + "  [img]" + data.tile_sprite + "[/img]"
	
	item_popup.get_node("label").bbcode_text = stringa
