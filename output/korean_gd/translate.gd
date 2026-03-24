extends Node

class_name translate


static func damage_type(label):
	var stringa = ""
	match label:
		"pierce":
			stringa += "[color=#af8f50]관통[/color]"
		"slash":
			stringa += "[color=#af8f50]참격[/color]"
		"blunt":
			stringa += "[color=#af8f50]타격[/color]"
		"blood":
			stringa += "[color=#ff1010]혈[/color]"
		"fire":
			stringa += "[color=#ff7000]화염[/color]"
		"lightning":
			stringa += "[color=#0060ff]번개[/color]"
		"astral":
			stringa += "[color=#8030af]성계[/color]"
		"poison":
			stringa += "[color=#70ff00]독[/color]"
		"psychic":
			stringa += "[color=#ffaf30]정신[/color]"
		"death":
			stringa += "[color=#a0a000]죽음[/color]"
		"ice":
			stringa += "[color=#5080ff]냉기[/color]"

	return stringa

static func element_to_resist_description(element):
	var stringa = ""
	stringa += "[color=#707070]" + element(element) + "에 투자한 각 포인트당 "
	match element:
		"Body":
			stringa += "[color=#ffff00]1%[/color] [color=#af8f50]관통[/color], [color=#af8f50]참격[/color] + [color=#af8f50]타격[/color] 저항"
		"Life":
			stringa += "[color=#ffff00]1%[/color] [color=#70ff00]독[/color], [color=#a0a000]죽음[/color] + [color=#ff1010]혈[/color] 저항"
		"Astral":
			stringa += "[color=#ffff00]2%[/color] " + element(element) + " 저항"
		"Fire":
			stringa += "[color=#ffff00]2%[/color] " + element(element) + " 저항"
		"Ice":
			stringa += "[color=#ffff00]2%[/color] " + element(element) + " 저항"
		"Death":
			stringa += "[color=#ffff00]2%[/color] " + element(element) + " 저항"
		"Poison":
			stringa += "[color=#ffff00]2%[/color] " + element(element) + " 저항"
		"Ice":
			stringa += "[color=#ffff00]2%[/color] " + element(element) + " 저항"
		"Psychic":
			stringa += "[color=#ffff00]2%[/color] " + element(element) + " 저항"
		"Lightning":
			stringa += "[color=#ffff00]2%[/color] " + element(element) + " 저항"
		"Blood":
			stringa += "[color=#ffff00]2%[/color] " + element(element) + " 저항"
			
	stringa += "[/color]"
	return stringa


static func element_to_points(label):
	var count = 0
	if Global.Player != null:
		var traits = Global.Player.get_traits()
		for title in traits:
			var trait = traits[title]
			if trait.generic == false:
				if trait.Element == label:
					count += trait.Level * trait.cost
	return count

static func value_to_color(integer):
	var stringa = ""
	if integer > 0:
		stringa = "[color=#50ff50]"
	else:
		stringa = "[color=#ff5050]"
		

	return stringa

static func damage_type_to_color(label):
	var stringa = ""
	match label:
		"pierce":
			stringa += "[color=#af8f50]"
		"slash":
			stringa += "[color=#af8f50]"
		"blunt":
			stringa += "[color=#af8f50]"
		"blood":
			stringa += "[color=#ff1010]"
		"fire":
			stringa += "[color=#ff7000]"
		"lightning":
			stringa += "[color=#0060ff]"
		"astral":
			stringa += "[color=#8030af]"
		"poison":
			stringa += "[color=#70ff00]"
		"psychic":
			stringa += "[color=#ffaf30]"
		"death":
			stringa += "[color=#a0a000]"
		"ice":
			stringa += "[color=#5080ff]"

	return stringa

static func damage_type_to_image(label):
	var stringa = ""
	stringa += "[img]"
	stringa += "res://Ham_Sprite/TextIcons/"
	match label:
		"pierce":
			stringa += "Pierce"
		"slash":
			stringa += "Slash"
		"blunt":
			stringa += "Blunt"
		"blood":
			stringa += "Blood"
		"fire":
			stringa += "Fire"
		"lightning":
			stringa += "Lightning"
		"astral":
			stringa += "Astral"
		"poison":
			stringa += "Poison"
		"psychic":
			stringa += "Psychic"
		"death":
			stringa += "Death"
		"ice":
			stringa += "Ice"
	
	stringa += ".png"
	stringa += "[/img]"
	return stringa

static func element(label):
	var stringa = label
	
	match label:
		"Fire":
			stringa = "[color=#ff8000]화염[/color]"
		"Death":
			stringa = "[color=#a0a000]죽음[/color]"
		"Lightning":
			stringa = "[color=#0060ff]번개[/color]"
		"Life":
			stringa = "[color=#00a000]생명[/color]"
		"Body":
			stringa = "[color=#af8f50]무술[/color]"
		"Astral":
			stringa = "[color=#8030af]성계[/color]"
		"Psychic":
			stringa = "[color=#ffaf30]정신[/color]"
		"Poison":
			stringa = "[color=#70ff00]독[/color]"
		"Death":
			stringa = "[color=#a0a000]죽음[/color]"
		"Ice":
			stringa = "[color=#5080ff]냉기[/color]"
		"Blood":
			stringa = "[color=#ff1010]혈[/color]"
		
	return stringa

static func dmgtype_to_animation(label):
	var stringa = ""
	match label:
		"pierce":
			stringa += "Pierce"
		"slash":
			stringa += "Slash"
		"blunt":
			stringa += "Blunt"
		"blood":
			stringa += "Blood"
		"fire":
			stringa += "Flame"
		"lightning":
			stringa += "Zap"
		"astral":
			stringa += "Astral"
		"poison":
			stringa += "PoisonHit"
		"psychic":
			stringa += "Psychic"
		"death":
			stringa += "Curse"
		"ice":
			stringa += "Ice"

	return stringa


static func weapon_type_to_scaling(type, stat):
	var stringa = ""
	

	
	var STR = "[color=#a0a0a0]STR[/color]"
	var DEX = "[color=#a0a0a0]DEX[/color]"
	var WIL = "[color=#a0a0a0]WIL[/color]"
	
	match type:
		"light":
			match stat:
				"acc":
					stringa += DEX
				"dmg":
					stringa += DEX + " " + STR
		
		"medium":
			match stat:
				"acc":
					stringa += DEX
				"dmg":
					stringa += DEX + " " + STR
		
		"heavy":
			match stat:
				"acc":
					stringa += DEX + " " + STR
				"dmg":
					stringa += STR
		
		"magic":
			match stat:
				"acc":
					stringa += DEX
				"dmg":
					stringa += WIL
			
						
	return stringa
	

static func get_lines_from_int(inta):
	var stringa = ""
	for n in inta:
		stringa += "|"
	return stringa

static func get_spaced_lines_from_int(inta):
	var stringa = ""
	for n in inta:
		stringa += "| "
	return stringa


static func armor_position(label):
	var stringa = ""
	match label:
		"chest":
			stringa += "가슴"
		"head":
			stringa += "머리"
		"arm":
			stringa += "팔"
		"leg":
			stringa += "다리"
	return stringa
	

static func is_physical(type):
	var is_physical = false
	
	if type == "blunt" or type == "pierce" or type == "slash":
		is_physical = true
	
	return is_physical
		
static func estimate_hit_chance(attacker, defender):
	var weapon = null
	var is_physical = is_physical(attacker.get_DMG_type(weapon))
	var dmg_type = attacker.get_DMG_type(weapon)
	if attacker == Global.Player:
		weapon = Global.Player.weapon_main
	var dmg = float(attacker.get_DMG_sides(weapon) * attacker.get_DMG(weapon))
	var acc = float(attacker.get_ACC_sides(weapon) * attacker.get_ACC(weapon))
	var dodge = float(defender.get_DEF() * defender.get_DEF_sides())
	var def = float(defender.get_block() * defender.get_block_sides())
	var shield_factor = 1.0
	if is_physical == false:
		shield_factor = 0.25
	var block = float(defender.get_block_strength()) * shield_factor
	var arm = float(defender.get_ARM()) * shield_factor
	var hit_chance = 0.0
	
	dmg = ToolCalcDamage.access_resists(dmg, dmg_type, attacker, defender)
	
	hit_chance = (acc / (acc + dodge))
	if dmg < block * 2:
		hit_chance *= (acc / (acc + def))
	
	hit_chance *= (dmg / (dmg + (arm * 2)))
	
	hit_chance *= 100
	var string = str(int(hit_chance))
	
	return string
	
static func attribute_to_string(label):
	var stringa = ""
	match label:
		"speed":
			stringa = "[color=#20ff20]속도[/color]"
		"life":
			stringa = "[color=#ff8080]체력[/color]"
		"armor":
			stringa = "[color=#5050ff]방어력[/color]"
		"accuracy":
			stringa = "[color=#ffa050]명중률[/color]"
		"damage":
			stringa = "[color=#ff8030]명중[/color]"
		"block":
			stringa = "[color=#5050ff]방어[/color]"
		"dodge":
			stringa = "[color=#50ffff]회피[/color]"
	
	return stringa

static func update_trait(trait):
	
	var ref_trait = null
			
	if trait.generic == true:
		if LTraitsGeneric.trait_data.has(trait.title):
				ref_trait = LTraitsGeneric.trait_data[trait.title]
	elif LTraits.trait_data.has(trait.title):
				ref_trait = LTraits.trait_data[trait.title]
				
	if ref_trait != null:
		print("trait updated!!!")
		trait.Description = ref_trait.Description
		trait.Name = ref_trait.Name
		trait.cost = ref_trait.cost
	
	
	return trait


static func check_immune(unit, unit_traits, source, source_traits):
	var immune = false
	
	if unit_traits.has("DamageImmune"):
				immune = true
	
	if Global.Allies.has(unit) == true and unit != source and source == Global.Player:
	
			if source_traits.has("Innervation"):
				immune = true
			if source_traits.has("Invigoration"):
				immune = true
			if source_traits.has("Summoner"):
				immune = true
			if unit.type.title == "PearlMirror":
				immune = true
	
	return immune

static func add_commas(string):
	var i: int = string.length() - 3
	while i > 0:
		string = string.insert(i, ",")
		i = i - 3
	return string

static func is_bare_fist(weapon):
	var boola = false
	if weapon == null:
		boola = true
	elif "Shimmering Orb" in weapon.name:
		boola = true
	elif weapon.has("title"):
		if weapon.title == "mindeye":
			boola = true
		elif weapon.title == "EmeraldEye":
			boola = true
		elif weapon.title == "zclaw":
			boola = true
	
	return boola



static func get_bare_fist_text():
	
	
	var stringa = "[color=#707070]'[color=#8040a0]맨주먹[/color]'으로 취급"
	return stringa


static func get_weapon_name(weapon):
	var stringa = "[color=#ffff50]맨주먹[/color]"
	if weapon != null:
		stringa = weapon.name
	return stringa
	
	
static func damage_type_to_projectile_art(label):
	var stringa = "res://Ham_Sprite/Proj/Proj_Pilum.png"
	match label:
		"slash":
			stringa = "res://Ham_Sprite/Proj/proj_voggite.png"
		"pierce":
			stringa = "res://Ham_Sprite/Proj/Proj_Vine.png"
		"blunt":
			stringa = "res://Ham_Sprite/Proj/proj_voggite.png"
		"fire":
			stringa = "res://Ham_Sprite/Proj/Proj_Fireball.png"
		"ice":
			stringa = "res://Ham_Sprite/Proj/Proj_Ice.png"
		"poison":
			stringa = "res://Ham_Sprite/Proj/Proj_Poison.png"
		"lightning":
			stringa = "res://Ham_Sprite/Proj/Proj_Zap.png"
		"astral":
			stringa = "res://Ham_Sprite/Proj/Proj_Astral.png"
		"psychic":
			stringa = "res://Ham_Sprite/Proj/Proj_Psychic.png"
		"blood":
			stringa = "res://Ham_Sprite/Proj/Proj_Blood.png"
		"death":
			stringa = "res://Ham_Sprite/Proj/Proj_Curse.png"
		

	return stringa


static func count_empty_prayers():
	var invokes = Global.Player.invokes
	var count = 0
	
	for key in invokes:
		var invoke = invokes[key]
		if invoke.level_required <= Global.Player.level:
			count += (invoke.use_max - invoke.use)
	
	return count


static func is_encumbered(unit):
	var boola = true
	if int(unit.get_total_weight()) <= int(unit.get_total_STR()):
			boola = false
	return boola

static func compose_buff_description(buff):
	var stringa = buff.description
	stringa = "[color=#707070]효과:[/color]\n\n"
	return stringa

static func get_shield_or_aoe_text(weapon):
	var stringa = ""
	if weapon.aoe > 1:
		stringa += "\n[img]res://Ham_Sprite/TraitIcons/aoe.png[/img]\n[color=#ff9090]범위 공격[/color]"
		stringa += " [color=#a0a0a0]양손 장착 시[/color]"
		stringa += "\n[color=#707070]보조손 비어야 함[/color]"
	if weapon.has("shield"):
		if weapon.shield == true:
			stringa += "\n[img]res://Ham_Sprite/TraitIcons/Shield.png[/img]\n"
			stringa += "[color=#a0a0a0]+50% [color=#5050ff]방어 확률[/color] 획득[/color] [color=#707070]고유[/color]"
	return stringa




static func element_to_feat(element):
	var stringa = ""
	
	if element == "Body":
		stringa = "martial"
	
	elif element == "Death":
		stringa = "death2"
		
	else: stringa = element.to_lower()
	
	
	return stringa
