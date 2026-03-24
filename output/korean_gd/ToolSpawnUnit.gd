extends Node

class_name spawn

static func spawn_unit(alliance, type, target_tile, summoner, msg):
	if target_tile != null:
		
		var new_type = cloner.clone_dict(type)
		
		if alliance == "enemy":
			new_type = compose_amplification(new_type)
		
		if alliance == "ally":
			new_type.abilities.push_front("Summoned")
			
		add_score(new_type, alliance, summoner)
		effectmaker.create_effect_animated(target_tile.global_position, Global.EffectAnimated, "Summon")
		update_info_buttons(alliance, new_type)
		
		var e = Global.EnemyNode.instance()
		e.position = target_tile.position
		target_tile.resident = e
		Global.game.add_child(e)
		e.residence = target_tile
		e.object_type = alliance
		e.type = new_type
		e.initiate_summoned()
		spawn_message(e, summoner, msg)
		event_spawn.check(e, alliance)

static func update_info_buttons(alliance, type):
	var ally_titles = []
	var enemy_titles = []
	
	for unit_type in Global.game.ally_types:
		ally_titles.append(unit_type.title)
	for unit_type in Global.game.enemy_types:
		enemy_titles.append(unit_type.title)
	
	if alliance == "enemy":
		if enemy_titles.has(type.title) == false:
			Global.game.enemy_types.append(type)
			Global.game.get_node("UI/UI_Enemies").initiate()
	
	if alliance == "ally":
		if ally_titles.has(type.title) == false:
			Global.game.ally_types.append(type)
		
	Global.game.get_node("UI/UI_Enemies").initiate()
		


static func compose_amplification(type):
	
	var multi = int(ToolSettings.settings_data.cycle_current)
	if StateWorld.land == "dust":
		multi = cycler.get_multi() * StateWorld.Floor_Current
	
	if multi > 1 and StateWorld.day > 0:
		print("amplification added")
		type.abilities.push_front("Amplification")
	elif StateWorld.land == "dust":
		print("amplification added")
		type.abilities.push_front("Amplification")
	
	return type

static func spawn_message(unit, summoner, msg):
	var name_d = unit.get_name_color()
	var name_k = "" + summoner.get_name_color()
	var txtcolor = "[color=#7030af]"
	var stringa = ""
	txtcolor = "[color=#c0c0c0]"
	if summoner == Global.Player:
		name_k = ""
		stringa += name_k + " 소환: " + name_d
		if msg != "":
			stringa += "[color=#707070] <- " + ({"Familiar": "사역마", "Summoned": "소환됨", "Initial": "최초", "Hit": "명중", "공격": "공격", "Being hit": "피격", "enemy Purges you": "적의 정화"}.get(textstrip.strip_bbcode(msg), textstrip.strip_bbcode(msg))) + "[/color]"
		ToolMessageCreator.add_message(txtcolor, stringa)
	else:
		txtcolor = "[color=#60509f]"
		txtcolor = "[color=#707070]"
		stringa += name_k + "(이)가 소환: " + name_d
		if msg != "":
			stringa += "[color=#707070] <- " + ({"Familiar": "사역마", "Summoned": "소환됨", "Initial": "최초", "Hit": "명중", "공격": "공격", "Being hit": "피격", "enemy Purges you": "적의 정화"}.get(textstrip.strip_bbcode(msg), textstrip.strip_bbcode(msg))) + "[/color]"
		ToolMessageCreator.add_message(txtcolor, stringa)
	

static func add_score(type, alliance, summoner):
	match alliance:
		"ally":
			match summoner.object_type:
				"player":
					StatePlayerSheet.score_data.allies_summoned += 1
			if StatePlayerSheet.score_data.allies.has(type.title) == false:
				StatePlayerSheet.score_data.allies.append(type.title)
