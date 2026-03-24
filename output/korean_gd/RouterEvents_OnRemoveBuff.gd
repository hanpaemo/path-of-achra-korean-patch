extends Node


class_name event_remove_buff

static func check(unit, buff, msg):
	
	if unit.Buffs.has(buff):
		unit.Buffs.erase(buff)
		effectmaker.create_effect_animated(unit.global_position, Global.EffectAnimated, "Purge")

	if unit == Global.Player:
		Global.game.get_node("UI").get_node("UI_BuffDrawer").write_buffs()
		
		var stringa = "[color=#c05050]제거[/color]: " + buff.color + buff.name + "[/color] (자신)"
		if msg != "":
			stringa += "[color=#707070] <- " + ({"Familiar": "사역마", "Summoned": "소환됨", "Initial": "최초", "Hit": "명중", "공격": "공격", "Being hit": "피격", "enemy Purges you": "적의 정화"}.get(textstrip.strip_bbcode(msg), textstrip.strip_bbcode(msg))) + "[/color]"
		
		ToolMessageCreator.add_message("[color=#c0c0c0]", stringa)
	else:
		var stringa = unit.get_name_color() + "(이)가 [color=#c05050]제거[/color]: " + buff.color + buff.name + "[/color] (자신)"
		if msg != "":
			stringa += "[color=#707070] <- " + ({"Familiar": "사역마", "Summoned": "소환됨", "Initial": "최초", "Hit": "명중", "공격": "공격", "Being hit": "피격", "enemy Purges you": "적의 정화"}.get(textstrip.strip_bbcode(msg), textstrip.strip_bbcode(msg))) + "[/color]"
		
		ToolMessageCreator.add_message("[color=#c0c0c0]", stringa)
