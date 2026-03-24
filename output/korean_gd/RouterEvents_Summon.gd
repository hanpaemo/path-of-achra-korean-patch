extends Node


class_name event_summon


static func check(alliance, type, tile, summoner, msg):
	
	type = modify_abilities(type, summoner)
	
	if summoner == Global.Player and tile != null:
		if Global.get_allies_size_minus_familiars() >= Global.Player.get_summon_limit() + 1 and type.abilities.has("Familiar") == false:
			var txtcolor = "[color=#ff3090]"
			if tile != null:
				effectmaker.create_effect_animated(tile.global_position, Global.EffectAnimated, "CorpsePurp")
				effectmaker.create_effect_animated(tile.global_position, Global.EffectAnimated, "Summon")
				effectmaker.create_effect_animated(tile.global_position, Global.EffectAnimated, "Astral")
			ToolMessageCreator.add_if_unique("[color=#ff3090]", "소환 실패! 의지력 부족...")
		else:
			check_effects(alliance, type, tile, summoner)
			spawn.spawn_unit(alliance, type, tile, summoner, msg)
	elif tile != null:
		check_effects(alliance, type, tile, summoner)
		spawn.spawn_unit(alliance, type, tile, summoner, msg)
		pass


static func modify_abilities(type, summoner):
	var traits = summoner.get_traits()
	type = cloner.clone_dict(type)
		
	var current_trait_titles = []
	
	for title in type.abilities:
		current_trait_titles.append(title)
	
	if traits.has("HungryGrave"):
		if type.abilities.has("Familiar"):
			type.tags.append("[color=#a0a000]언데드[/color]")
	
	if traits.has("Overgrowth"):
		if type.abilities.has("Familiar"):
			type.tags.append("[color=#00a000]Plant[/color]")
	
	if traits.has("Oozemancer"):
		if type.title == "ooze":
			if current_trait_titles.has("Revenge") == false:
				type.abilities.append("Revenge")
	
	if traits.has("Gliva"):
		if type.title != "cadaver" and type.abilities.has("Familiar") == false:
			var hp = Global.Player.HP_max / 5
			if hp < 1: hp = 1
			type = cloner.clone_dict(LAllies.ally_data.Mushroom)
			type.hp = hp
	
	return type

static func check_effects(alliance, type, tile, summoner):
	var traits = summoner.get_traits()
	
	
	if traits.has("Liturgist"):
		if Global.Enemies.size():
			if type.tags.has("[color=#8050f0]Priest[/color]"):
			
				var amount = 0
				for title in traits:
					match title:
						"GroveCult":
							amount += 1
						"FlameCult":
							amount += 1
						"FulminantCult":
							amount += 1
						"StarCult":
							amount += 1
						"BlightCult":
							amount += 1
						"MinionFeast":
							amount += 1
				
				amount = 1
			
				for n in amount:
					var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.worshipper, 
					"summoner": summoner, 
					"msg": traits.Liturgist.Name
				}
					ProcessQueue.add_effect(action)
	
	
	
	if traits.has("Ormjarl"):
		
			var action = {
				"name": "magic_damage_targets_range", 
			"caster": summoner, 
			"damage": 100.0, 
			"damage_type": "lightning", 
			"effect_sprite": "Zap", 
			"effect_range": 99, 
			"number_of_targets": 1, 
			"msg": traits.Ormjarl.Name
				}
			ProcessQueue.add_effect(action)
	if traits.has("IceShah"):
		
			var action2 = {
			"name": "change_tileset_in_area", 
			"tile_target": tile, 
			"tileset": "iceshah", 
			"effect_range": 1, 
			"effect_sprite": "none"
		}
			ProcessQueue.add_effect(action2)
	
	if traits.has("Slime"):
		var trait = traits.Slime
		for n in 1:

				var buff = cloner.clone_dict(LBuffs.buff_data.Corrosion)
				buff["target"] = summoner
				buff["source"] = summoner
				buff.duration = 5 * trait.Level
				var action = {
				"name": "buff_targets_in_range", 
				"caster": summoner, 
				"effect_sprite": "Corrode", 
				"number_of_targets": 3, 
				"effect_range": 3, 
				"buff": buff, 
				"is_allied": false, 
				"msg": traits.Slime.Name
				}
				ProcessQueue.add_effect(action)
	
	
	if traits.has("MinionFeast"):
		
			var action = {
					"name": "magic_damage_target", 
					"target": summoner, 
					"caster": summoner, 
					"damage": 15.0, 
					"damage_type": "blood", 
					"effect_sprite": "Blood", 
					"msg": traits.MinionFeast.Name
				}
			ProcessQueue.add_effect(action)
			
			var trait = traits.MinionFeast
			var buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
			buff["target"] = summoner
			buff["source"] = summoner
			buff.duration = 10.0 * trait.Level
			action = {
				"name": "buff_targets_in_range", 
				"caster": summoner, 
				"effect_sprite": "Bleed", 
				"number_of_targets": 1, 
				"effect_range": 4, 
				"buff": buff, 
				"is_allied": false, 
				"msg": traits.MinionFeast.Name
				}
		
			ProcessQueue.add_effect(action)
	
	
	
	if traits.has("Vineform"):
			var trait = traits.Vineform
			var buff = cloner.clone_dict(LBuffs.buff_data.Vineform)
			buff["target"] = summoner
			buff["source"] = summoner
			buff.duration = trait.Level * 2
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": traits.Vineform.Name
			}
			ProcessQueue.add_effect(action)
	
	if traits.has("SnakeCharmer"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Sickness)
			buff["target"] = summoner
			buff["source"] = summoner
			buff.duration = 1.0 * summoner.get_total_DEX()
			var action = {
				"name": "buff_targets_in_range", 
				"caster": summoner, 
				"effect_sprite": "Sickness", 
				"number_of_targets": 1, 
				"effect_range": 2, 
				"buff": buff, 
				"is_allied": false, 
				"msg": traits.SnakeCharmer.Name
				}
		
			ProcessQueue.add_effect(action)
	
	if traits.has("VileCoup"):
		
		var damage = 5.0 * summoner.get_total_DEX()
		
		var action = {
			"name": "magic_damage_tiles_in_path_to_targets_in_range", 
			"caster": summoner, 
			"damage": damage, 
			"damage_type": "poison", 
			"effect_sprite": "PoisonHit", 
			"number_of_targets": 1, 
			"effect_range": 4, 
			"msg": traits.VileCoup.Name, 
			"enemies": null
				}
		ProcessQueue.add_effect(action)
	
	if traits.has("Ninhurs"):
		
			var action2 = {
			"name": "change_tileset_in_area", 
			"tile_target": tile, 
			"tileset": "ninhurs", 
			"effect_range": 1, 
			"effect_sprite": "none"
		}
			ProcessQueue.add_effect(action2)
	
	if summoner != Global.Player:
		
		if traits.has("VariGore") or traits.has("VariOkopod") or traits.has("VariLapsi") or traits.has("VariTaggla") or traits.has("VariAstropede"):
			var action = {
					"name": "magic_damage_target", 
					"target": summoner, 
					"caster": summoner, 
					"damage": float(summoner.HP_max) * 0.1, 
					"damage_type": summoner.get_DMG_type(null), 
					"effect_sprite": translate.dmgtype_to_animation(summoner.get_DMG_type(null)), 
					"msg": "Varikorpus"
				}
			ProcessQueue.add_effect(action)
		
		if traits.has("VariOkokorpus"):
			var action = {
					"name": "magic_damage_target", 
					"target": summoner, 
					"caster": summoner, 
					"damage": float(summoner.HP_max) * 0.3, 
					"damage_type": summoner.get_DMG_type(null), 
					"effect_sprite": translate.dmgtype_to_animation(summoner.get_DMG_type(null)), 
					"msg": "Varikorpus"
				}
			ProcessQueue.add_effect(action)
		
		if traits.has("VariOkopodBeast"):
			var action = {
					"name": "magic_damage_target", 
					"target": summoner, 
					"caster": summoner, 
					"damage": float(summoner.HP_max) * 0.03, 
					"damage_type": summoner.get_DMG_type(null), 
					"effect_sprite": translate.dmgtype_to_animation(summoner.get_DMG_type(null)), 
					"msg": "Varikorpus"
				}
			ProcessQueue.add_effect(action)
	
	if traits.has("Oozemancy"):
		var count = 0
		for unit in Global.Allies:
			if unit != Global.Player:
				if unit.type.title == "ooze":
					count += 1
		if count >= 1:
			var action = {
			"name": "magic_damage_targets_range", 
			"caster": summoner, 
			"damage": 20.0 * count, 
			"damage_type": "poison", 
			"effect_sprite": "PoisonHit", 
			"effect_range": 2, 
			"number_of_targets": 3, 
			"msg": traits.Oozemancy.Name
				}
			ProcessQueue.add_effect(action)
	
	
	
	
	if traits.has("StaffDruid"):
		
		var action = {
				"name": "magic_damage_target_closest", 
				"caster": summoner, 
				"damage": 50.0, 
				"damage_type": "poison", 
				"effect_sprite": "PoisonHit", 
				"msg": traits.StaffDruid.Name
				}
		ProcessQueue.add_effect(action)
	
	
	if traits.has("EarthMage"):
		var buff = cloner.clone_dict(LBuffs.buff_data.Entangle)
		buff["target"] = summoner
		buff["source"] = summoner
		buff.duration = 5
		var action = {
			
				"name": "buff_targets_in_range", 
				"caster": summoner, 
				"effect_sprite": "Entangle", 
				"number_of_targets": 3, 
				"effect_range": 99, 
				"buff": buff, 
				"is_allied": false, 
				"msg": traits.EarthMage.Name
			}
		ProcessQueue.add_effect(action)
	
	if traits.has("FulminantCult"):
					var trait = traits.FulminantCult
					var unit = summoner
					var buff = cloner.clone_dict(LBuffs.buff_data.Charge)
					buff["target"] = unit
					buff["source"] = unit
					buff.duration = trait.Level
					var action = {
					"name": "add_buff", 
					"buff": buff, 
					"msg": traits.FulminantCult.Name
			}
					ProcessQueue.add_effect(action)
	
	if traits.has("StarCult"):
					var trait = traits.StarCult
					var unit = summoner
					var buff = cloner.clone_dict(LBuffs.buff_data.Meditate)
					buff["target"] = unit
					buff["source"] = unit
					buff.duration = trait.Level
					var action = {
					"name": "add_buff", 
					"buff": buff, 
					"msg": traits.StarCult.Name
			}
					ProcessQueue.add_effect(action)
				
	if traits.has("StaffStasis"):
					
					var unit = summoner
					var buff = cloner.clone_dict(LBuffs.buff_data.Agony)
					buff["target"] = unit
					buff["source"] = unit
					buff.duration = 1
					var action = {
					"name": "add_buff", 
					"buff": buff, 
					"msg": traits.StaffStasis.Name
			}
					ProcessQueue.add_effect(action)
	
	if traits.has("GroveCult"):
			var unit = summoner
			var trait = traits.GroveCult
			var action = {
				"name": "heal", 
				"amount": trait.base * trait.Level, 
				"healer_unit": unit, 
				"healed_unit": unit, 
				"msg": traits.GroveCult.Name
				}
			ProcessQueue.add_effect(action)
	if traits.has("Arsonist"):
		var action = {
			"name": "magic_damage_tiles_in_path_to_targets_in_range", 
			"caster": summoner, 
			"damage": 75.0, 
			"damage_type": "fire", 
			"effect_sprite": "Flame", 
			"number_of_targets": 1, 
			"effect_range": 4, 
			"enemies": null, 
			"msg": traits.Arsonist.Name
				}
		ProcessQueue.add_effect(action)
	
	if traits.has("FlameCult"):
				var unit = summoner
				var trait = unit.get_traits().FlameCult
				var action = {
			"name": "magic_damage_tiles_in_path_to_targets_in_range", 
			"caster": unit, 
			"damage": 40.0 * trait.Level, 
			"damage_type": "fire", 
			"effect_sprite": "Flame", 
			"number_of_targets": 1, 
			"effect_range": 4, 
			"enemies": null, 
			"msg": traits.FlameCult.Name
				}
				ProcessQueue.add_effect(action)
	
	
	if summoner == Global.Player:
		for unit in Global.Enemies:
			var unit_traits = unit.get_traits()
		
			
			if unit_traits.has("Warding"):
				var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 2
				var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": unit_traits.Warding.Name
			}
				ProcessQueue.add_effect(action)
