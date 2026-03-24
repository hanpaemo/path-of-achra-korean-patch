extends Node

class_name event_apply_buff


static func check(buff):
	
	var abort = false
	
	if buff.name == "Plague":
		if buff.target.get_traits().has("Plaguemancer"):
			abort = true
	
	if abort == false: truecheck(buff)


static func modify_duration(buff):
	
	
	return buff

static func truecheck(buff):
	var max_duration = 1000000
	if buff.name == "Protection":
		max_duration = 1
	
	buff = cloner.clone_dict(buff)
	
	if buff.has("msg") == false: buff.msg = ""
	
	var msg = str(buff.msg)
	
	var mod_info = {
			"string": [str(int(buff.duration))]
		}
	
	
	
	
	var repeated = false
	
	var form_inherit_msg = ""
	if buff.unique == true and buff.duration > 0:
		for buff_current in buff.target.Buffs:
			if buff_current.name == buff.name:
				
				repeated = true
				
				
				check_effects(buff_current, buff, buff.name, buff.source, buff.target, buff.duration, repeated, mod_info)
				buff_current.duration += buff.duration
				
				if mod_info.string.size() and ToolSettings.settings_data.log_detail == true:
					var count_message = 0
					for message in mod_info.string:
						if count_message > 0:
							msg += ", " + message
						else:
							msg += " " + message
						count_message += 1
					buff.msg = str(msg)
				
				if buff_current.duration > max_duration:
					buff_current.duration = max_duration
					buff.msg += " (최대 " + str(max_duration) + ")"
				
				
				if buff_current.source == Global.Player:
					add_score(buff_current)
				
				message_buff(buff.name, buff.source, buff.target, buff.duration, buff.color, buff.msg)
			
			elif buff.form == true and buff_current.form == true:
				buff.duration += buff_current.duration
				form_inherit_msg += " (+" + str(buff_current.duration) + " 스택 계승: " + buff_current.name + ")"
				if buff.source == Global.Player:
					add_score(buff)
			
				var action = {
					"name": "remove_buff", 
					"target": buff.target, 
					"buff": buff_current, 
					"msg": "transformation replaced"
		}
				ProcessQueue.add_effect(action)
			
			
			
	if repeated == false and buff.duration > 0:
		var buff_current = buff
		
		
		check_effects(buff_current, buff, buff.name, buff.source, buff.target, buff.duration, repeated, mod_info)
		
		
		if mod_info.string.size() and ToolSettings.settings_data.log_detail == true:
			var count_message = 0
			for message in mod_info.string:
						if count_message > 0:
							msg += ", " + message
						else:
							msg += " " + message
						count_message += 1
			buff.msg = str(msg)
		
		
		buff.target.Buffs.append(buff)
		
		buff.msg += form_inherit_msg
		
		if buff_current.duration > max_duration:
			buff_current.duration = max_duration
			buff.msg += " (최대 " + str(max_duration) + ")"
		
		if buff_current.source == Global.Player:
			add_score(buff_current)
		
		message_buff(buff.name, buff.source, buff.target, buff.duration, buff.color, buff.msg)
	
		if buff.form == true:
			effectmaker.create_effect_animated(buff.target.global_position, Global.EffectAnimated, "Transform")

	

	if buff.target == Global.Player and buff.duration > 0:
		Global.game.get_node("UI").get_node("UI_BuffDrawer").write_buffs()

	

static func check_effects(buff_current, buff, name, source, target, duration, _form_repeated, mod_info):
	
	buffcheck.just_draw(buff.name, buff.duration, buff.target, buff.source, buff)
	
	var source_traits = source.get_traits()
	var target_traits = target.get_traits()
	
	
	var duration_scaling = 1.0
	if buff_current == buff:
		duration_scaling = buff_current.duration
	else:
		duration_scaling = buff_current.duration + buff.duration
	
	
	
	
	
	
	
	if buff.name == "Paralysis":
		if buff.target.get_buff_names().has("Paralysis") == false:
			buff.target.tick = 1.0
	
	
	if source.object_type == "enemy":
		if StateWorld.day > 0:
			if cycler.get_multi() > 1:
				var random_increase = Global.rng.randi_range(1, cycler.get_multi())
				buff.duration += random_increase
				mod_info.string.append("증폭 +" + str(int(random_increase)))
		elif StateWorld.land == "dust":
			var random_increase = Global.rng.randi_range(1, cycler.get_multi())
			buff.duration += random_increase
			mod_info.string.append("증폭 +" + str(int(random_increase)))
	
	if source_traits.has("Priest"):
		var increase = int(0.5 * float(buff.duration))
		if increase > 100: increase = 100
		if increase > 100: increase = 100
		buff.duration += increase
		mod_info.string.append(source_traits.Priest.Name + " +" + str(int(increase)))
	
	if source_traits.has("Warrior"):
		if buff.name == "Poise":
			buff.duration += 3
			mod_info.string.append(source_traits.Warrior.Name + " +3")
	
	
		
		
			
	
	if source_traits.has("Arjana"):
		if buff.name == "Blind" or buff.name == "Freeze":
			var modification = float(int(source.get_total_DEX() / 5.0))
			if modification >= 1.0:
				buff.duration += modification
				mod_info.string.append(source_traits.Arjana.Name + " +" + str(int(modification)))
	
	if source_traits.has("Yu"):
	
			buff.duration += 5
			mod_info.string.append(source_traits.Yu.Name + " +5")
	
	if source_traits.has("Warlock"):
		if buff.name == "Inflame":
			buff.duration += 2
			mod_info.string.append(source_traits.Warlock.Name + " +2")
	
	if source_traits.has("Ascetic"):
		if buff.name == "Meditate":
			buff.duration += 1
			mod_info.string.append(source_traits.Ascetic.Name + " +1")
	
	if source_traits.has("Shapeshifter"):
		if buff.form == true:
			buff.duration += 1
			mod_info.string.append(source_traits.Shapeshifter.Name + " +1")
	
	if source_traits.has("PaintedLoincloth"):
		if buff.form == true:
			var bonus = 4 - source.get_armor_list().size()
			if bonus > 0:
				buff.duration += bonus
				mod_info.string.append(source_traits.PaintedLoincloth.Name + " +" + str(bonus))
	
	if name == "Berserk":
		if source_traits.has("BerserkerAxe"):
			var increase = 4 - Global.Player.get_armor_list().size()
			buff.duration += increase
			mod_info.string.append(source_traits.BerserkerAxe.Name + " +" + str(int(increase)))
	
	
	if name == "Charge":
		if source_traits.has("ThunderMask"):
			var new_dur = buff.duration + 1
			mod_info.string.append(source_traits.ThunderMask.Name + " +" + str(int(1)))
			buff.duration = new_dur
	
	if name == "Scorch":
		if source_traits.has("Mask_Flame"):
			var new_dur = buff.duration + 3
			mod_info.string.append(source_traits.Mask_Flame.Name + " +" + str(int(3)))
			buff.duration = new_dur
	
	if name == "Entangle":
		if source_traits.has("Mask_Vine"):
			var new_dur = buff.duration + 2
			mod_info.string.append(source_traits.Mask_Vine.Name + " +" + str(int(2)))
			buff.duration = new_dur
	
	if name == "Repulsion":
		if source_traits.has("Psychonaut"):
			var new_dur = buff.duration + 3
			mod_info.string.append(source_traits.Psychonaut.Name + " +" + str(int(3)))
			buff.duration = new_dur
		if source_traits.has("Mesmer"):
			var new_dur = buff.duration + 3
			mod_info.string.append(source_traits.Mesmer.Name + " +" + str(int(3)))
			buff.duration = new_dur
		if source_traits.has("MasterRepulsion"):
			buff.duration += source_traits.MasterRepulsion.Level
			mod_info.string.append(source_traits.MasterRepulsion.Name + " +" + str(int(source_traits.MasterRepulsion.Level)))
	
	if name == "Freeze" or name == "Meditate":
		if source_traits.has("helm_blue"):
			buff.duration += buff.source.get_total_inflex()
			mod_info.string.append(source_traits.helm_blue.Name + " +" + str(int(buff.source.get_total_inflex())))
	
	if name == "Corrosion":
		
		if source_traits.has("Mask_Acid"):
			var new_dur = buff.duration + 3
			mod_info.string.append(source_traits.Mask_Acid.Name + " +" + str(int(3)))
			buff.duration = new_dur
	
	if name == "Bleed":
		if source_traits.has("BloodMask"):
			var new_dur = buff.duration + 3
			mod_info.string.append(source_traits.BloodMask.Name + " +" + str(int(3)))
			buff.duration = new_dur
	
	if name == "Doom":
		if source_traits.has("SkullHelm"):
			var new_dur = buff.duration + 2
			mod_info.string.append(source_traits.SkullHelm.Name + " +" + str(int(2)))
			buff.duration = new_dur
	
	if source_traits.has("Paragon"):
		if buff.harmful == false and buff.form == false:
			if buff.target == source:
				var buff_new = cloner.clone_dict(buff)
				buff_new["target"] = source
				buff_new["source"] = source
				buff_new.duration = int(buff_current.duration)
				
				
				var action = {
				"name": "buff_targets_in_range", 
				"caster": source, 
				"effect_sprite": buff_new.animation, 
				"number_of_targets": 1, 
				"effect_range": 99, 
				"buff": buff_new, 
				"is_allied": true, 
				"msg": source_traits.Paragon.Name
				}
		
				ProcessQueue.add_effect(action)
	
	if source_traits.has("Torturer"):
		if buff.harmful == true and buff.form == false:
			if buff.target == source:
				var buff_new = cloner.clone_dict(buff)
				buff_new["target"] = source
				buff_new["source"] = source
				buff_new.duration = int(buff_current.duration)
				
				
				var action = {
				"name": "buff_targets_in_range", 
				"caster": source, 
				"effect_sprite": buff_new.animation, 
				"number_of_targets": 1, 
				"effect_range": 99, 
				"buff": buff_new, 
				"is_allied": false, 
				"msg": source_traits.Torturer.Name
				}
		
				ProcessQueue.add_effect(action)
	
	
	
	if name == "Sickness":
		
		if source_traits.has("Snakeform"):
			var trait = source.get_traits().Snakeform
			var new_buff = cloner.clone_dict(LBuffs.buff_data.Snakeform)
			new_buff["target"] = source
			new_buff["source"] = source
			new_buff.duration = trait.Level * 2
			var action = {
				"name": "add_buff", 
				"buff": new_buff, 
				"msg": source_traits.Snakeform.Name
			}
			ProcessQueue.add_effect(action)
	
	
	
	
	
	if name == "Dream":
		if Global.Enemies.size() > 0:
		
			ToolInvokes.recharge("dreaming")
			
	
	if name == "Sickness":
		
		
		
			
			
			
		
		
		if source_traits.has("PoisonPalm"):
			var trait = source.get_traits().PoisonPalm
			var defender = target
			var attacker = source
			
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 30.0 * trait.Level, 
					"damage_type": "poison", 
					"effect_sprite": "PoisonHit", 
					"msg": source_traits.PoisonPalm.Name
				}
			ProcessQueue.add_effect(action)
			action = {
			"name": "magic_damage_targets_range", 
			"caster": attacker, 
			"damage": 30.0 * trait.Level, 
			"damage_type": "poison", 
			"effect_sprite": "PoisonHit", 
			"effect_range": 1, 
			"number_of_targets": 3, 
			"msg": source_traits.PoisonPalm.Name
				}
			ProcessQueue.add_effect(action)
		
		if source_traits.has("Dianmai") == true:
			var new_new_buff = cloner.clone_dict(LBuffs.buff_data.Evasion)
			new_new_buff["target"] = source
			new_new_buff["source"] = source
			new_new_buff.duration = 2
			var action = {
				"name": "add_buff", 
				"buff": new_new_buff, 
				"msg": source_traits.Dianmai.Name
			}
			ProcessQueue.add_effect(action)
		
		
		
		if source_traits.has("knifepoison") == true:

			
			var action = {
				"name": "magic_damage_tiles_in_path", 
				"target": target, 
				"caster": source, 
				"damage": duration_scaling * 10, 
				"damage_type": "poison", 
				"effect_sprite": "PoisonHit", 
				"msg": source_traits.knifepoison.Name
			}
			ProcessQueue.add_effect(action)

	if name == "Entangle":
		if Global.Allies.has(source):
			if Global.Player.get_traits().has("Vinakinesis") and target_traits.has("MasterEntangle") == false:
		
				var trait = Global.Player.get_traits().Vinakinesis
				
				var action = {
					"name": "magic_damage_target", 
					"target": target, 
					"caster": Global.Player, 
					"damage": 30.0 * trait.Level, 
					"damage_type": "poison", 
					"effect_sprite": "PoisonHit", 
					"msg": Global.Player.get_traits().Vinakinesis.Name
				}
				ProcessQueue.add_effect(action)
		
	
	
	if name == "Inflame":
		if source_traits.has("SummonRedDragon"):
			var trait = source.get_traits().SummonRedDragon
			var hit = trait.Level * 3.0
			
			var action = {
			"name": "apply_bonus_random_ally", 
			"origin": source, 
			"amount": hit, 
			"type": "damage", 
			"msg": source_traits.SummonRedDragon.Name
			}
			ProcessQueue.add_effect(action)
			for unit in Global.Allies:
				if unit.get_name() == "Red Dragon":
				
					action = {
			"name": "heal", 
			"amount": 20.0 * trait.Level, 
			"healer_unit": source, 
			"healed_unit": unit, 
			"msg": source_traits.SummonRedDragon.Name
			}
					ProcessQueue.add_effect(action)
	
	
	
		
	
	
	
	
	if name == "Freeze" or name == "Poise":
		
		if source_traits.has("SummonGrika"):
			var trait = source.get_traits().SummonGrika
			var armor = trait.Level * 30.0
			var action = {
			"name": "apply_bonus_random_ally", 
			"origin": source, 
			"amount": armor, 
			"type": "armor", 
			"msg": source_traits.SummonGrika.Name
			}
			ProcessQueue.add_effect(action)
			
			for unit in Global.Allies:
				
				if unit.get_name() == "Grika":
					
					action = {
			"name": "apply_bonus", 
			"origin": source, 
			"target": unit, 
			"amount": 1.0 * trait.Level, 
			"type": "damage", 
			"msg": source_traits.SummonGrika.Name
			}
					ProcessQueue.add_effect(action)
				
					action = {
			"name": "heal", 
			"amount": armor, 
			"healer_unit": source, 
			"healed_unit": unit, 
			"msg": source_traits.SummonGrika.Name
			}
					ProcessQueue.add_effect(action)
	
	
	
	
	
	
	
	if name == "Freeze":
		
		
		
		
		
		if source_traits.has("Daruq"):
			var new_new_buff = cloner.clone_dict(LBuffs.buff_data.Doom)
			new_new_buff["target"] = target
			new_new_buff["source"] = source
			new_new_buff.duration = int(buff.duration)
			var action = {
				"name": "add_buff", 
				"buff": new_new_buff, 
				"msg": source_traits.Daruq.Name
				}
			ProcessQueue.add_effect(action)
		
		
		
		
		
		if source_traits.has("FrostKnight") == true:
			var new_new_buff = cloner.clone_dict(LBuffs.buff_data.Poise)
			new_new_buff["target"] = source
			new_new_buff["source"] = source
			new_new_buff.duration = 1
			var action = {
				"name": "add_buff", 
				"buff": new_new_buff, 
				"msg": source_traits.FrostKnight.Name
			}
			ProcessQueue.add_effect(action)

		if source_traits.has("Surtmir"):
			
			
			if target_traits.has("Parafrost") == false:
				var damage = duration_scaling
				for buff in target.Buffs:
					if buff.name == "Scorch" or buff.name == "Freeze":
						damage += float(buff.duration)
			
				var action = {
					"name": "magic_damage_target", 
					"target": target, 
					"caster": source, 
					"damage": float(damage), 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": source_traits.Surtmir.Name
				}
				ProcessQueue.add_effect(action)
			
			var new_new_buff = cloner.clone_dict(LBuffs.buff_data.Scorch)
			new_new_buff["target"] = target
			new_new_buff["source"] = source
			new_new_buff.duration = int(buff.duration)
			var action = {
				"name": "add_buff", 
				"buff": new_new_buff, 
				"msg": source_traits.Surtmir.Name
				}
			ProcessQueue.add_effect(action)
		
		if source_traits.has("CrushingFrost"):
			if target_traits.has("Parafrost") == false and target_traits.has("VoidMage") == false:
				var defender = target
				var attacker = source
				var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": duration_scaling, 
					"damage_type": "blunt", 
					"effect_sprite": "Bash", 
					"msg": source_traits.CrushingFrost.Name
				}
				ProcessQueue.add_effect(action)
		
		
		if source_traits.has("Inuk"):
			if target_traits.has("Parafrost") == false and target_traits.has("VoidMage") == false:
				var trait = source_traits.Inuk
				var defender = target
				var attacker = source
				var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 35.0 * trait.Level, 
					"damage_type": "ice", 
					"effect_sprite": "Ice", 
					"msg": source_traits.Inuk.Name
				}
				ProcessQueue.add_effect(action)
		
		if source_traits.has("IceNecklace") == true:
			if target_traits.has("Parafrost") == false and target_traits.has("VoidMage") == false:

				var action = {
				"name": "magic_damage_tiles_in_path", 
				"target": target, 
				"caster": source, 
				"damage": 10.0 * duration_scaling, 
				"damage_type": "ice", 
				"effect_sprite": "Ice", 
				"msg": source_traits.IceNecklace.Name
			}
				ProcessQueue.add_effect(action)
		
		if source_traits.has("Angiok") == true:
			if target_traits.has("Parafrost") == false and target_traits.has("VoidMage") == false:
				var action = {
				"name": "magic_damage_tiles_in_path", 
				"target": target, 
				"caster": source, 
				"damage": source.get_total_WIL() * 10.0, 
				"damage_type": "ice", 
				"effect_sprite": "Ice", 
				"msg": source_traits.Angiok.Name
			}
				ProcessQueue.add_effect(action)
	
	if name == "Freeze" or name == "Bleed":
		if source_traits.has("Anqarak"):
			var new_new_buff = cloner.clone_dict(LBuffs.buff_data.Anqarak)
			new_new_buff["target"] = source
			new_new_buff["source"] = source
			new_new_buff.duration = int(buff.duration)
			var action = {
				"name": "add_buff", 
				"buff": new_new_buff, 
				"msg": source_traits.Anqarak.Name
				}
			ProcessQueue.add_effect(action)
	
	if name == "Corrosion":
		
		
		
		
		
		var damage = duration_scaling * 10
		if source_traits.has("AcidKnife") == true:
			var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": source, 
				"damage": damage, 
				"effect_range": 1, 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"msg": source_traits.AcidKnife.Name

			}
			ProcessQueue.add_effect(action)
	
	
	if name == "Bleed":
		
		
			
		
		if source_traits.has("Bloodcalling"):
			var trait = source.get_traits().Bloodcalling
			var hit = trait.Level * 2.0
			
			var action = {
			"name": "apply_bonus_random_ally", 
			"origin": source, 
			"amount": 1.0 * trait.Level, 
			"type": "speed", 
			"msg": source_traits.Bloodcalling.Name
			}
			ProcessQueue.add_effect(action)
			
			for unit in Global.Allies:

				if unit.get_name() == "Hemogoblin":
					action = {
			"name": "apply_bonus", 
			"origin": source, 
			"target": unit, 
			"amount": hit, 
			"type": "damage", 
			"msg": source_traits.Bloodcalling.Name
			}
					ProcessQueue.add_effect(action)
		
		
		
		
		var damage = duration_scaling * 10
		if source_traits.has("knifebleed") == true:
			var action = {
				"name": "magic_damage_targets_range", 
				"caster": source, 
				"damage": damage, 
				"damage_type": "blood", 
				"effect_sprite": "Blood", 
				"effect_range": 1, 
				"number_of_targets": 2, 
				"msg": source_traits.knifebleed.Name
			}
			ProcessQueue.add_effect(action)
		
		if source_traits.has("Hemokinesis") == true:
			var trait = source.get_traits().Hemokinesis
			var action = {
			"name": "magic_damage_tiles_in_path_to_targets_in_range", 
			"caster": source, 
			"damage": (30.0 * trait.Level), 
			"damage_type": "blood", 
			"effect_sprite": "Blood", 
			"number_of_targets": 2, 
			"effect_range": 4, 
			"enemies": null, 
			"msg": source_traits.Hemokinesis.Name
				}
			ProcessQueue.add_effect(action)
		
		if source_traits.has("MalaTora"):
			var new_new_buff = cloner.clone_dict(LBuffs.buff_data.Doom)
			new_new_buff["target"] = target
			new_new_buff["source"] = source
			new_new_buff.duration = int(buff.duration)
			var action = {
				"name": "add_buff", 
				"buff": new_new_buff, 
				"msg": source_traits.MalaTora.Name
				}
			ProcessQueue.add_effect(action)
	
	if name == "Berserk":
		if source_traits.has("UrBeast"):
			if source.get_armor_list().size() == 1 and source.armor_head != null:
				var new_new_buff = cloner.clone_dict(LBuffs.buff_data.Beastform)
				new_new_buff["target"] = target
				new_new_buff["source"] = source
				new_new_buff.duration = 1
				var action = {
				"name": "add_buff", 
				"buff": new_new_buff, 
				"msg": source_traits.UrBeast.Name
				}
				ProcessQueue.add_effect(action)
	
	
	
	if name == "Sickness" or name == "Doom":
		if source_traits.has("Plaguemancer") and target_traits.has("Plaguemancer") == false:
			var new_new_buff = cloner.clone_dict(LBuffs.buff_data.Plague)
			new_new_buff["target"] = target
			new_new_buff["source"] = source
			new_new_buff.duration = 1
			var action = {
				"name": "add_buff", 
				"buff": new_new_buff, 
				"msg": source_traits.Plaguemancer.Name
				}
			ProcessQueue.add_effect(action)
	
	if name == "Sickness" or name == "Corrosion":
		if source_traits.has("PoisonFamiliar"):
			var trait = source_traits.PoisonFamiliar
			var dodge = trait.Level * 3.0
			
			var action = {
			"name": "apply_bonus_random_ally", 
			"origin": source, 
			"amount": dodge, 
			"type": "dodge", 
			"msg": source_traits.PoisonFamiliar.Name
			}
			ProcessQueue.add_effect(action)
			
			for unit in Global.Allies:
				if unit.get_name() == "Tsuchigumo":
					for n in trait.Level:
						action = {
			"name": "magic_damage_targets_range", 
			"caster": unit, 
			"damage": unit.get_DMG_total(unit.weapon_main), 
			"damage_type": "poison", 
			"effect_sprite": "PoisonHit", 
			"effect_range": 1, 
			"number_of_targets": 1, 
			"msg": source_traits.PoisonFamiliar.Name
				}
						ProcessQueue.add_effect(action)
			
	
	if name == "Bleed":
		

		
		if source_traits.has("BloodMage"):
			var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": source, 
				"damage": 0.1 * source.HP_max, 
				"damage_type": "blood", 
				"effect_sprite": "Blood", 
				"effect_range": 2, 
				"msg": source_traits.BloodMage.Name
			}
			ProcessQueue.add_effect(action)
	
	if name == "Meditate":
		if source_traits.has("ArchMagus") == true:
			
			var action = {
			"name": "magic_damage_tiles_in_path_to_targets_in_range", 
			"caster": source, 
			"damage": 100.0, 
			"damage_type": "astral", 
			"effect_sprite": "Astral", 
			"number_of_targets": 1, 
			"effect_range": 99, 
			"enemies": null, 
			"msg": source_traits.ArchMagus.Name
				}
			ProcessQueue.add_effect(action)
			
		if source_traits.has("Hat_Astral") == true:
			var action = {
			"name": "magic_damage_targets_range", 
			"caster": source, 
			"damage": 25.0, 
			"damage_type": "astral", 
			"effect_sprite": "Astral", 
			"number_of_targets": 1, 
			"effect_range": 99, 
			"msg": source_traits.Hat_Astral.Name
				}
			ProcessQueue.add_effect(action)
	
		if source_traits.has("NightCrow"):
			if Global.Player.get_armor_list().size() == 1 and Global.Player.armor_head != null:
				var crow_damage = 0.0
				for buff in source.Buffs:
					if buff.name == "Crowform":
						crow_damage += float(buff.duration)
				
				var crow_buff = cloner.clone_dict(LBuffs.buff_data.Crowform)
				crow_buff["target"] = source
				crow_buff["source"] = source
				crow_buff.duration = 2
				
				crow_damage *= 5.0
				if source.get_buff_names().has("Crowform"):
					var action = {
				"name": "magic_damage_target_closest", 
				"caster": source, 
				"damage": crow_damage, 
				"damage_type": "death", 
				"effect_sprite": "Curse", 
				"msg": source_traits.NightCrow.Name
				}
					ProcessQueue.add_effect(action)
					action = {
					"name": "magic_damage_target", 
					"target": source, 
					"caster": source, 
					"damage": 15.0, 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"msg": source_traits.NightCrow.Name
				}
					ProcessQueue.add_effect(action)
				
				var action = {
		"name": "add_buff", 
		"buff": crow_buff, 
		"msg": source_traits.NightCrow.Name
		}
				ProcessQueue.add_effect(action)
	
	
		
		
		


static func text_popup(target, name, color):
	
	var apoint = target.get_global_position()
	var atext = "" + str(name)

	ProcessText.spawn_text_popup(apoint, atext, color)


static func message_buff(name, caster, target, duration, color, msg):
	
	Global.sound.new_sound("Effect")
	text_popup(target, name, color)
	var txcolor = color
	txcolor = "[color=#c0c0c0]"
	var name_a = caster.get_name_color()
	var name_d = target.get_name_color()
	name = color + name + "[/color]"
	var stringa = ""
	var duration_text = "[color=#9f9f50]" + str(duration) + "[/color] "
	
	
	
	
	if target == Global.Player and caster == Global.Player:
		name_a = ""
		name_d = "자신"
		stringa = name_a + "부여: " + duration_text + name + " → " + name_d + ""
		stringa += add_msg(msg)
		ToolMessageCreator.add_message(txcolor, stringa)
	elif caster == Global.Player:
		name_a = ""
		stringa = name_a + "부여: " + duration_text + name + " → " + name_d + ""
		stringa += add_msg(msg)
		ToolMessageCreator.add_message(txcolor, stringa)
	elif target == Global.Player:
		name_d = "당신"
		stringa = "" + name_a + "(이)가 부여: " + duration_text + name + " → " + name_d + ""
		stringa += add_msg(msg)
		ToolMessageCreator.add_message(txcolor, stringa)
	elif caster == target:
		txcolor = "[color=#707070]"
		stringa = "" + name_a + "(이)가 부여: " + duration_text + name + " → 자신"
		stringa += add_msg(msg)
		ToolMessageCreator.add_message(txcolor, stringa)
	else:
		txcolor = "[color=#707070]"
		stringa = "" + name_a + "(이)가 부여: " + duration_text + name + " → " + name_d + ""
		stringa += add_msg(msg)
		ToolMessageCreator.add_message(txcolor, stringa)


static func add_msg(msg):
	if msg != "":
		msg = "[color=#707070] <- " + ({"Familiar": "사역마", "Summoned": "소환됨", "Initial": "최초", "Hit": "명중", "공격": "공격", "Being hit": "피격", "enemy Purges you": "적의 정화"}.get(textstrip.strip_bbcode(msg), textstrip.strip_bbcode(msg))) + "[/color]"
	return msg





static func add_score(buff):
	var duration = buff.duration
	var name = buff.color + buff.name + "[/color]"
	if duration > StatePlayerSheet.score_data.highest_stack_effect:
		StatePlayerSheet.score_data.highest_stack_effect = int(duration)
		StatePlayerSheet.score_data.highest_stack_effect_label = name
	
	
