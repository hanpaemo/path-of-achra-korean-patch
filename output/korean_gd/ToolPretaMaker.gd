extends Node



var preta_variation = 15






func compose_preta():
	
	var dict = cloner.clone_dict(LEnemies.enemy_data.mud_golem)
	
	
	dict.abilities = []
	dict.world = 0
	dict.tier = 0
	dict.quant = [1, 1]
	dict.size = 50
	dict.level = (StateWorld.day + 1) * 100
	
	
	dict.range_attack = Global.rng.randi_range(1, 7)
	if Global.rng.randi_range(1, 2) == 1: dict.range_attack = 1
	
	var cycle_set = ["accuracy", "armor", "armor", "dodge", "dodge", "speed"]
	
	dict.cycle = []
	
	
	if dict.range_attack > 1:
		cycle_set = ["hit", "accuracy", "armor", "armor", "dodge", "dodge", "speed"]
	else:
		dict.cycle.append("hit")
		
	dict.cycle.append("hp")
	for n in 1:
		dict.cycle.append(cycle_set[Global.rng.randi_range(0, cycle_set.size() - 1)])
	
	
	
	dict.sprite = pick_sprite()
	
	var prefix = pick_prefix()
	var name_colored = prefix[0]
	
	
	for n in prefix.size():
		if n - 1 != 0:
			dict.abilities.append(prefix[n - 1])
	
	
	var core = pick_core()
	name_colored += core[0]
	
	var high_stat = core[1]
	dict.abilities.append(core[2])
	
	
	var suffix = pick_suffix()
	name_colored += suffix[0]
	for n in suffix.size():
		if n - 1 != 0:
			dict.abilities.append(suffix[n - 1])
	
	var name_stripped = textstrip.strip_bbcode(name_colored)
	dict.title = name_stripped
	dict.name = name_stripped
	dict.name_color = name_colored
	dict.description = "혼돈의 형상을 한 [color=#af40af]아귀[/color], 먼지의 땅에서 온 굶주린 망령..."
	
	dict.taunt = name_colored + "(이)가 너를 존재에서 찢어낸다..."
	
	
	dict = set_randomized_attributes(dict, high_stat)
	
	
	dict.abilities.push_front("Preta")
	
	var final_dict = cloner.clone_dict(dict)
	
	return final_dict











func pick_sprite():
	var path = ""
	
	path += "res://Ham_Sprite/Enemies/Preta"
	path += str(Global.rng.randi_range(1, preta_variation))
	path += ".png"
	
	return path



func pick_suffix():
	var set = [
		["[color=#ff8000]az[/color]", "AOE", "FireBreath"], 
		["[color=#0060ff]liga[/color]", "AuraCharge", "HitZap"], 
		["[color=#ff7000]fra[/color]", "AuraInflame", "Impact"], 
		["[color=#8030af]oz[/color]", "Warding", "Impact"], 
		["[color=#a0a000]og[/color]", "Prescience", "Scourge"], 
		["[color=#af8f50]sha[/color]", "Vigilance", "Penetration"], 
		["[color=#ff7000]ak[/color]", "Vigilance", "Tracking"], 
		["[color=#e050e0]ax[/color]", "Retort", "Impact"], 
		["[color=#8030af]tet[/color]", "DisruptionHit", "Autoblink"]
	]
	
	var picked_set = set[Global.rng.randi_range(0, set.size() - 1)]
		
	return picked_set

func pick_core():
	var set = [
		["[color=#e0a050]dag[/color]", "damage", "ProjectiveForce"], 
		["[color=#e0a050]'ag[/color]", "damage", "ProjectiveForce"], 
		["[color=#5050ff]ru[/color]", "armor", "Bully"], 
		["[color=#ffff90]a'[/color]", "damage", "Protection_Harm"], 
		["[color=#ffff90]iz'[/color]", "armor", "Protection_Death"], 
		["[color=#a0a000]og[/color]", "life", "FeastCruel"], 
		["[color=#a0a000]ra[/color]", "life", "FeastDeadly"], 
		["[color=#904060]ek[/color]", "dodge", "AbsorbTime"], 
		["[color=#a030b0]t'[/color]", "accuracy", "Seeker"]
	]
	
	var picked_set = set[Global.rng.randi_range(0, set.size() - 1)]
	
	return picked_set
	


func pick_prefix():
	var set = [
		["[color=#70ff00]Il[/color]", "SicknessSkin", "PoisonHit", "Force"], 
		["[color=#5070ff]Anu[/color]", "ChillHit", "CrushingFrost", "Force"], 
		["[color=#ff8000]Aza[/color]", "BurnHit", "Sitanna", "Force"], 
		["[color=#ffd000]Obu[/color]", "CorrosionHit", "CorrosionSkin", "Force"], 
		["[color=#ff1010]Mag[/color]", "BleedHit", "AuraBleed", "Force"], 
		["[color=#a0a000]Uk[/color]", "DoomHit", "DoomSkin", "Force"], 
		["[color=#e0a050]Sar[/color]", "Shockwave", "Trample", "Frenzy"]
	]
	
	var picked_set = set[Global.rng.randi_range(0, set.size() - 1)]
		
	return picked_set
	
	

func set_randomized_attributes(dict, high_stat):
	
	var multi = StateWorld.day + 1
	if StateWorld.land == "dust": multi = StateWorld.Floor_Current
	
	dict.hp = multi * Global.rng.randi_range(300, 1000)
	dict.speed = multi * Global.rng.randi_range(1, 7)
	dict.arm = multi * Global.rng.randi_range(0, 100)
	dict.dodge[0] = multi * Global.rng.randi_range(0, 10)
	dict.deflect[2] = multi * Global.rng.randi_range(1, 200)
	dict.damage[0] = multi * Global.rng.randi_range(5, 30)
	dict.accuracy[0] = multi * Global.rng.randi_range(1, 10)
	
	if dict.speed > 50: dict.speed = 50

	var typelist = ["slash", "blunt", "pierce", "fire", "ice", "poison", "lightning", "death", "psychic", "astral", "blood"]
	
	dict.dmgtype = typelist[Global.rng.randi_range(0, typelist.size() - 1)]
	dict.proj_art = translate.damage_type_to_projectile_art(dict.dmgtype)
	
	
	for label in typelist:
		var resist = "resist_" + label
		dict[resist] = Global.rng.randi_range( - 25, 90)
	
	
	match high_stat:
		"damage":
			dict.damage[0] = dict.damage[0] * 2
		"armor":
			dict.arm = dict.arm * 2
		"life":
			dict.hp = dict.hp * 2
		"dodge":
			dict.dodge[0] = dict.dodge[0] * 2
		"accuracy":
			dict.accuracy[0] = dict.accuracy[0] * 2
	
	
	if dict.damage[0] > 100:
		dict.damage[0] = 100 + int(float(dict.damage[0] - 100) / 5.0)
	
	return dict


