extends Node

class_name event_heal

static func check(amount, healer_unit, healed_unit, msg):
	if healed_unit.HP < healed_unit.HP_max:
		
		var mod_info = {
			"string": [str(int(amount))]
		}
		
		amount = check_effects(amount, healer_unit, healed_unit, mod_info)
		
		if mod_info.string.size() and ToolSettings.settings_data.log_detail == true:
			var count_message = 0
			for message in mod_info.string:
				if count_message > 0:
					msg += ", " + message
				else:
					msg += " " + message
				count_message += 1
		
		if msg != "":
			msg = "[color=#707070] <- " + ({"Familiar": "사역마", "Summoned": "소환됨", "Initial": "최초", "Hit": "명중", "공격": "공격", "Being hit": "피격", "enemy Purges you": "적의 정화"}.get(textstrip.strip_bbcode(msg), textstrip.strip_bbcode(msg))) + "[/color]"
		
		text_popup(int(amount), healed_unit)
		message_damage(amount, healed_unit, healer_unit, msg)
		effectmaker.create_effect_animated(healed_unit.global_position, Global.EffectAnimated, "Heal")
		
		var score_amount = 0.0
		if healed_unit.HP_max - healed_unit.HP >= amount:
			score_amount = amount
		else:
			score_amount = healed_unit.HP_max - healed_unit.HP
		
		add_score(score_amount, healer_unit, healed_unit)
		
		if healed_unit == Global.Player:
			ToolInvokes.lose_charge("heal")
		
		healed_unit.HP += int(amount)
		if healed_unit.HP > healed_unit.HP_max:
			healed_unit.HP = healed_unit.HP_max
		healed_unit.draw_life()
	else:
		amount = 0


static func check_effects(amount, healer_unit, healed_unit, mod_info):
	var unit = healed_unit
	var total_increase = 0.0
	
	var unit_traits = unit.get_traits()
	
	
	if unit_traits.has("AmplifiedHealing") == true:
		var trait = unit.get_traits().AmplifiedHealing
		var increase = trait.Level * 5.0
		total_increase += increase
		mod_info.string.append(unit_traits.AmplifiedHealing.Name + " +" + str(int(increase)))
	
	if unit_traits.has("Merzot") == true:
		total_increase += 20.0
		mod_info.string.append(unit_traits.Merzot.Name + " +" + str(int(20.0)))
	
	if unit_traits.has("Ninhurs") == true:
		if unit.residence.tileset.title == "ninhurs":
			var increase = amount * 0.5
			if increase < 1.0:
				increase = 1.0
			total_increase += increase
			mod_info.string.append(unit_traits.Ninhurs.Name + " +" + str(int(increase)))
	
	if unit_traits.has("BloodDrinker") == true:
			var increase = amount * 1.0
			if increase < 1.0:
				increase = 1.0
			total_increase += increase
			mod_info.string.append(unit_traits.BloodDrinker.Name + " +" + str(int(increase)))
	
	
	if unit_traits.has("GoldenHelm"):
				var trait = unit_traits.GoldenHelm
				var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 2
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": trait.Name
			}
				ProcessQueue.add_effect(action)
				
	if unit_traits.has("MavetKa"):
		var trait = unit_traits.MavetKa
		var action = {
				"name": "magic_damage_target_closest", 
				"caster": unit, 
				"damage": 35.0 * trait.Level, 
				"damage_type": "death", 
				"effect_sprite": "Curse", 
				"msg": unit_traits.MavetKa.Name
				}
		ProcessQueue.add_effect(action)
	
	if unit_traits.has("Gehimon"):
		var damage = float(50 * Global.Allies.size())
		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": damage, 
				"damage_type": "death", 
				"effect_sprite": "Curse", 
				"effect_range": 1, 
				"msg": unit_traits.Gehimon.Name
			}
		ProcessQueue.add_effect(action)
	
	if healed_unit == Global.Player or healer_unit == Global.Player:
		var increase = float(Global.Player.get_total_WIL()) * 0.1
		
		increase *= amount
		if increase >= 1.0:
			total_increase += increase
			mod_info.string.append("의지 +" + str(int(increase)))
			
	
	amount += total_increase
	
	if amount < 1.0:
		amount = 1.0
	
	
	
	
	
	
	return amount
	
static func text_popup(amount, healed_unit):
	var apoint = healed_unit.get_global_position()
	var damage_string = translate.add_commas(str(int(amount)))
	var atext = "+" + str(damage_string)
	var color = "[color=#50af50]"
	if healed_unit == Global.Player:
		color = "[color=#00ff00]"
	if amount == 0:
		color = "[color=#c0e0c0]"
	ProcessText.spawn_text_popup(apoint, atext, color)

static func message_damage(amount, healed_unit, healer_unit, msg):
	var txcolor = "[color=#a0a0a0]"
	var name_a = healed_unit.get_name_color()
	var name_d = healer_unit.get_name_color()
	var damage_string = translate.add_commas(str(int(amount)))
	var stringa = ""
	if healed_unit == Global.Player and healer_unit == Global.Player:
		stringa = "회복: [color=#50ff50]" + damage_string + "[/color]"
	elif healed_unit == Global.Player:
		stringa = name_d + "(이)가 회복: [color=#50ff50]" + damage_string + "[/color]"
	elif healer_unit == Global.Player:
		stringa = name_a + " 회복: [color=#50af50]" + damage_string + "[/color]"
	elif healed_unit == healer_unit:
		txcolor = "[color=#707070]"
		stringa = name_d + "(이)가 자가 회복: [color=#50af50]" + damage_string + "[/color]"
	else:
		txcolor = "[color=#707070]"
		stringa = name_d + "(이)가 " + name_a + " 회복: [color=#50af50]" + damage_string + "[/color]"

	if msg != "":
		stringa += msg

	ToolMessageCreator.add_message(txcolor, stringa)
	

static func add_score(amount, _healer_unit, healed_unit):
	match healed_unit.object_type:
		"player":
			StatePlayerSheet.score_data.amount_healed += int(amount)
