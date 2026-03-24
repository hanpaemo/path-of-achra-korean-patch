extends Node


class_name event_turn

static func run():

	Global.game.turn_number += 1

	StatePlayerSheet.score_data.game_turns += 1
	
	ToolMessageCreator.add_message("[color=#505050]", "게임 턴 경과...")

	var unit_list = []
	for unit in Global.Allies:
		unit_list.append(unit)
	for unit in Global.Enemies:
		unit_list.append(unit)
		
	for unit in unit_list:
		unit.buffs_tick()
		check(unit)
	for event in Global.game.delayed_events:
		event.tick()

static func check(unit):
	
	if StateWorld.type != "path":
		if unit == Global.Player:
			if calcrange.is_adjacent_enemy(unit, Global.Enemies) == true:
				ToolInvokes.recharge("adjacent enemy")
			else:
				ToolInvokes.lose_charge("no adjacent enemy")
				if Global.Enemies.size():
					ToolInvokes.recharge("game turn none adjacent")
	
	var traits = unit.get_traits()
	
	
	if unit == Global.Player:
		
		for buff in unit.Buffs:
			
			
			
			if buff.harmful == true:
				if traits.has("Parafrost") and buff.name == "Freeze":
					pass
				elif traits.has("VoidMage") and buff.name == "Freeze":
					pass
				elif traits.has("MasterEntangle") and buff.name == "Entangle":
					pass
				elif traits.has("MasterScorch") and buff.name == "Scorch":
					pass
				elif traits.has("MasterDoom") and buff.name == "Doom":
					pass
				elif traits.has("MasterBleed") and buff.name == "Bleed":
					pass
				elif traits.has("Damunja") and buff.name == "Bleed":
					pass
				elif traits.has("Acid_Necklace") and buff.name == "Corrosion":
					pass
				elif traits.has("Torturer") == true:
					pass
				else:
					var rng = Global.rng
					if rng.randi_range(1, 100) < int(unit.get_total_WIL()):
						
							var action = {
					"name": "remove_buff", 
					"target": unit, 
					"buff": buff, 
					"msg": "의지력 회복"
		}
							ProcessQueue.add_effect(action)
							
	
	if unit != Global.Player:
		for buff in unit.Buffs:
			if buff.harmful == true:
				var rng = Global.rng
				if rng.randi_range(1, 100) < unit.type.size:
					if buff.name == "Doom" and Global.Player.get_traits().has("Doomsayer"):
						pass
					else:
						var action = {
					"name": "remove_buff", 
					"target": unit, 
					"buff": buff, 
					"msg": "자연 회복"
					}
		
						ProcessQueue.add_effect(action)
						ToolMessageCreator.add_message("[color=#707070]", unit.get_name_color() + "(이)가 [color=#9010cf]회복[/color]: " + buff.color + buff.name + "[/color]")
	
	
	for buff in unit.Buffs:
			if buff.name == "Scorch":
				buffcheck.burn(buff.duration, buff.target, buff.source, null)
			if buff.name == "Sickness":
				buffcheck.poison(buff.duration, buff.target, buff.source, null)
			if buff.name == "Plague":
				buffcheck.plague(buff.duration, buff.target, buff.source, null)
			if buff.name == "Stasis":
						if traits.has("Qamar"):
							var action = {
					"name": "remove_buff", 
					"target": unit, 
					"buff": buff, 
					"msg": traits.Qamar.Name
		}
							ProcessQueue.add_effect(action)
	
	
	if traits.has("BloodRetort") == true:
		if Global.Enemies.size() > 0:
	
			var trait = traits.BloodRetort
			for n in trait.Level:
						var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.bleedingdead, 
					"summoner": unit, 
					"msg": traits.BloodRetort.Name
				}
						ProcessQueue.add_effect(action)
	
			var action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": 25.0, 
					"damage_type": "blood", 
					"effect_sprite": "Blood", 
					"msg": traits.BloodRetort.Name
				}
			ProcessQueue.add_effect(action)
	
	
			
	
	
	if traits.has("FrenziedChant"):
		if Global.Enemies.size() > 0:
			
			for n in traits.FrenziedChant.Level:
			
					var action = {
			"name": "attack_targets", 
			"attacker": unit, 
			"number_of_targets": 1, 
			"msg": traits.FrenziedChant.Name
		}
					ProcessQueue.add_effect(action)
			
			var new_buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
			new_buff["target"] = unit
			new_buff["source"] = unit
			new_buff.duration = 5 * traits.FrenziedChant.Level
			var action = {
				"name": "add_buff", 
				"buff": new_buff, 
				"msg": "Frenzied Chant"
			}
			ProcessQueue.add_effect(action)
			
	
			action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": 25.0, 
					"damage_type": "psychic", 
					"effect_sprite": "Psychic", 
					"msg": traits.FrenziedChant.Name
				}
			ProcessQueue.add_effect(action)
			
			
	
	
	if traits.has("AuroraChant"):
		if Global.Enemies.size() > 0:
			
			for buff in unit.Buffs:
				if buff.name == "Meditate":
					for n in traits.AuroraChant.Level:
						var action = {
				"name": "magic_damage_target_closest", 
				"caster": unit, 
				"damage": 5.0 * buff.duration, 
				"damage_type": "ice", 
				"effect_sprite": "Bastral", 
				"msg": traits.AuroraChant.Name
				}
						ProcessQueue.add_effect(action)
	
			var action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": 25.0, 
					"damage_type": "astral", 
					"effect_sprite": "Bastral", 
					"msg": traits.AuroraChant.Name
				}
			ProcessQueue.add_effect(action)
			
			var new_buff = cloner.clone_dict(LBuffs.buff_data.Meditate)
			new_buff["target"] = unit
			new_buff["source"] = unit
			new_buff.duration = 1 * traits.AuroraChant.Level
			action = {
				"name": "add_buff", 
				"buff": new_buff, 
				"msg": "Aurora Chant"
			}
			ProcessQueue.add_effect(action)
	
	if traits.has("Plaguedrinking"):
		if Global.Enemies.size() > 0:
			for enemy in Global.Enemies:
							var new_buff = cloner.clone_dict(LBuffs.buff_data.Plague)
							new_buff["target"] = enemy
							new_buff["source"] = unit
							new_buff.duration = 2 * traits.Plaguedrinking.Level
							var action = {
				"name": "add_buff", 
				"buff": new_buff, 
				"msg": "Plague Chant"
			}
							ProcessQueue.add_effect(action)
			
			var action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": 25.0, 
					"damage_type": "poison", 
					"effect_sprite": "PoisonHit", 
					"msg": traits.Plaguedrinking.Name
				}
			ProcessQueue.add_effect(action)
			
			
	
	if traits.has("ChannelDeath"):
		if Global.Enemies.size() > 0:
			var trait = traits.ChannelDeath
		
			var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": trait.Level * 100.0, 
				"damage_type": "ice", 
				"effect_sprite": "Ice", 
				"effect_range": trait.Level, 
				"msg": traits.ChannelDeath.Name
			}
			ProcessQueue.add_effect(action)
		
			action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": trait.Level * 100.0, 
				"damage_type": "death", 
				"effect_sprite": "Curse", 
				"effect_range": trait.Level, 
				"msg": traits.ChannelDeath.Name
			}
			ProcessQueue.add_effect(action)
		
			action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": 25.0, 
					"damage_type": "ice", 
					"effect_sprite": "Ice", 
					"msg": traits.ChannelDeath.Name
				}
			ProcessQueue.add_effect(action)
		
			
			
			
			
			
			
			
			
			
			
	
	
	if traits.has("LizardLord"):
		if Global.Enemies.size() > 0:
			if Global.Player.get_armor_list().size() == 1 and Global.Player.armor_head != null:
			
				var msg = traits.LizardLord.Name
				var buff = cloner.clone_dict(LBuffs.buff_data.Lizardform)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 2
				var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": msg
			}
				ProcessQueue.add_effect(action)
			
					
					
	
	
	
	if traits.has("Acid_Necklace"):
		if Global.Enemies.size() > 0:
			var msg = traits.Acid_Necklace.Name
				
			for check_buff in unit.Buffs:
				
				if check_buff.name == "Corrosion":
					
					var action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": check_buff.duration, 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": traits.Acid_Necklace.Name
				}
					ProcessQueue.add_effect(action)
					
					var buff = cloner.clone_dict(LBuffs.buff_data.Corrosion)
					buff["target"] = unit
					buff["source"] = unit
					buff.duration = check_buff.duration
					action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": msg
			}
					ProcessQueue.add_effect(action)
				
				
			var buff = cloner.clone_dict(LBuffs.buff_data.Corrosion)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 5
			var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": msg
			}
			ProcessQueue.add_effect(action)
	
	
	
	if unit.get_traits().has("Yu"):
		if Global.Enemies.size():
			var buff_duration = unit.get_total_WIL()
			var buff_scaling = 0.1
			var buff = cloner.clone_dict(LBuffs.buff_data.Refraction)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = buff_duration
			var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": traits.Yu.Name
			}
			ProcessQueue.add_effect(action)
		
			for checkbuff in unit.Buffs:
				if checkbuff.source == unit:
					buff = cloner.clone_dict(LBuffs.buff_data[checkbuff.title])
					buff["target"] = unit
					buff["source"] = unit
					buff.duration = int(float(checkbuff.duration) * buff_scaling)
					action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": traits.Yu.Name
			}
					ProcessQueue.add_effect(action)
	
	
	if traits.has("Hazar"):
		if Global.Enemies.size() > 0:
		
			var action = {
			"name": "change_tileset_in_area", 
			"tile_target": unit.residence, 
			"tileset": "acid", 
			"effect_range": 3, 
			"effect_sprite": "none"
		}
			ProcessQueue.add_effect(action)
	
	
	if traits.has("Gala"):
		if Global.Enemies.size() > 0:
			var is_present = false
			for ally in Global.Allies:
				if ally != Global.Player:
					if ally.type.title == "WarPriest":
						is_present = true
			
			if is_present == false:
				for n in 1:
					var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.WarPriest, 
					"summoner": unit, 
					"msg": traits.Gala.Name
				}
					ProcessQueue.add_effect(action)
	
	if traits.has("VariLapsi"):
			for n in 2:
				var action = {
					"name": "summon", 
					"alliance": "enemy", 
					"type": LEnemies.enemy_data.lapsi, 
					"summoner": unit, 
					"msg": traits.VariLapsi.Name
				}
				ProcessQueue.add_effect(action)
	
	if traits.has("VariGore"):
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": "enemy", 
					"type": LEnemies.enemy_data.gore_nymph, 
					"summoner": unit, 
					"msg": traits.VariGore.Name
				}
				ProcessQueue.add_effect(action)
	
	if traits.has("VariOkopod"):
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": "enemy", 
					"type": LEnemies.enemy_data.okopod, 
					"summoner": unit, 
					"msg": traits.VariOkopod.Name
				}
				ProcessQueue.add_effect(action)
	
	if traits.has("VariOkopodBeast"):
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": "enemy", 
					"type": LEnemies.enemy_data.okopod, 
					"summoner": unit, 
					"msg": traits.VariOkopodBeast.Name
				}
				ProcessQueue.add_effect(action)
	
	if traits.has("VariOkokorpus"):
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": "enemy", 
					"type": LEnemies.enemy_data.okokorpus, 
					"summoner": unit, 
					"msg": traits.VariOkokorpus.Name
				}
				ProcessQueue.add_effect(action)
	
	if traits.has("JadeBracers"):
		if Global.Enemies.size() > 0:
			for n in unit.Buffs.size():
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.JadeSoldier, 
					"summoner": unit, 
					"msg": traits.JadeBracers.Name
				}
				ProcessQueue.add_effect(action)
	
	if traits.has("RatBanner"):
		if Global.Enemies.size() > 0:
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.ratman_flourisher, 
					"summoner": unit, 
					"msg": traits.RatBanner.Name
				}
				ProcessQueue.add_effect(action)
	
	if traits.has("ProjectiveForce"):
		var action = {

		"name": "delayed_magic_damage_tiles_in_path_to_targets_in_range", 
		"caster": unit, 
		"damage": unit.get_DMG_max(null), 
		"damage_type": unit.get_DMG_type(null), 
		"effect_sprite": translate.dmgtype_to_animation(unit.get_DMG_type(null)), 
		"number_of_targets": 1, 
		"effect_range": 99, 
		"enemies": null, 
		"duration": 1, 
		"msg": traits.ProjectiveForce.Name

}

		ProcessQueue.add_effect(action)
	
	if traits.has("TealCharge"):
			if Global.Enemies.size() > 0:
		
				var buff = cloner.clone_dict(LBuffs.buff_data.Charge)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 5
				var action = {
				"name": "buff_targets_in_range", 
				"caster": unit, 
				"effect_sprite": "Charge", 
				"number_of_targets": 1, 
				"effect_range": 3, 
				"buff": buff, 
				"is_allied": true, 
				"msg": traits.TealCharge.Name
				}
				ProcessQueue.add_effect(action)
	
	if traits.has("AuraCharge"):
			if Global.Enemies.size() > 0:
		
				var buff = cloner.clone_dict(LBuffs.buff_data.Charge)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 2
				var action = {
				"name": "buff_tiles_in_range", 
				"caster": unit, 
				"effect_sprite": "Charge", 
				"effect_range": 3, 
				"buff": buff, 
				"alliance": calcrange.get_allied_alliance(unit), 
				"msg": traits.AuraCharge.Name
			}
				ProcessQueue.add_effect(action)

			
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 3
				var action2 = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": traits.AuraCharge.Name
			}
				ProcessQueue.add_effect(action2)
		
	if traits.has("AuraInflame"):
			if Global.Enemies.size() > 0:
		
				var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 3
				var action = {
				"name": "buff_tiles_in_range", 
				"caster": unit, 
				"effect_sprite": "Inflame", 
				"effect_range": 2, 
				"buff": buff, 
				"alliance": calcrange.get_allied_alliance(unit), 
				"msg": traits.AuraInflame.Name
			}
				ProcessQueue.add_effect(action)

			
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 3
				var action2 = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": traits.AuraInflame.Name
			}
				ProcessQueue.add_effect(action2)
	
	if traits.has("Fawdaa") == true:
		if Global.Enemies.size() > 0:
		
			var action = {
				"name": "teleport_random", 
				"unit": unit, 
				"msg": traits.Fawdaa.Name
			}
			ProcessQueue.add_effect(action)
	
	
	if unit.get_buff_names().has("Dream"):
		for buff in unit.Buffs:
				if buff.name == "Dream":
					
						
						var action = {
				"name": "magic_damage_target_closest", 
				"caster": unit, 
				"damage": 10.0 * float(buff.duration), 
				"damage_type": "psychic", 
				"effect_sprite": "Psychic", 
				"msg": "Dream"
				}
						ProcessQueue.add_effect(action)
						action = {
				"name": "magic_damage_target_closest", 
				"caster": unit, 
				"damage": 10.0 * float(buff.duration), 
				"damage_type": "ice", 
				"effect_sprite": "Ice", 
				"msg": "Dream"
				}
						ProcessQueue.add_effect(action)
	
	
	if traits.has("Mehtar"):
				var amount = 1
				var buff_scaling = 0.0
				for buff in unit.Buffs:
					if buff.name == "Dream":
						buff_scaling = float(buff.duration)
						amount += buff.duration
						if amount > 5: amount = 5
					
				for times in amount:
							
							if Global.Enemies.size():
								var action = {
									"name": "hit_targets_range", 
									"attacker": unit, 
									"hit": 10.0, 
									"weapon": unit.weapon_main, 
									"effect_range": 4, 
									"number_of_targets": 1, 
									"msg": traits.Mehtar.Name
			
									}
								ProcessQueue.add_effect(action)
							
							var action = {
								"name": "summon_random", 
								"alliance": "ally", 
								"type": LAllies.ally_data.phantasm, 
								"summoner": unit, 
								"msg": traits.Mehtar.Name
								}
							ProcessQueue.add_effect(action)
							var newbuff = cloner.clone_dict(LBuffs.buff_data.Dream)
							newbuff["target"] = unit
							newbuff["source"] = unit
							newbuff.duration = 1
							action = {
								"name": "add_buff", 
								"buff": newbuff, 
								"msg": unit.get_traits().Mehtar.Name
								}
							ProcessQueue.add_effect(action)
							
		
	if unit == Global.Player:
		
		
		
		if unit.get_buff_names().has("Treeform") and traits.has("Arborus"):
				for buff in unit.Buffs:
					if buff.name == "Treeform":
						var amount = buff.duration
						if amount > 30: amount = 30
						for duration in amount:
							var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Wisp, 
					"summoner": unit, 
					"msg": traits.Arborus.Name
				}
							ProcessQueue.add_effect(action)
		
		if traits.has("MassMind"):
			var trait = unit.get_traits().MassMind
			var damage = Global.Allies.size() * trait.Level * 5.0
			damage = float(damage)
			var damage_range = trait.Level
			
			for n in trait.Level:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.GlintingBlade, 
					"summoner": unit, 
					"msg": traits.MassMind.Name
				}
				ProcessQueue.add_effect(action)
			
			var action = {
				"name": "magic_damage_targets_range", 
				"caster": unit, 
				"damage": damage, 
				"damage_type": "psychic", 
				"effect_sprite": "Psychic", 
				"effect_range": damage_range, 
				"number_of_targets": 300, 
				"msg": traits.MassMind.Name
			}
			ProcessQueue.add_effect(action)
		
		
		if traits.has("Stormbringer"):
			if Global.Enemies.size() > 0:
				
				
				var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": 100.0, 
				"damage_type": "ice", 
				"effect_sprite": "Ice", 
				"effect_range": 4, 
				"msg": traits.Stormbringer.Name
			}
				ProcessQueue.add_effect(action)
				action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": 100.0, 
				"damage_type": "lightning", 
				"effect_sprite": "Zap", 
				"effect_range": 4, 
				"msg": traits.Stormbringer.Name
			}
				ProcessQueue.add_effect(action)
		
		if traits.has("Exultite"):
			if Global.Enemies.size() > 0:
				var damage = 0.0
				for buff in unit.Buffs:
					if buff.name == "Inflame":
						damage += buff.duration * 10.0
						damage = float(damage)
				
				if damage > 0.0:
					var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": damage, 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"effect_range": 3, 
				"msg": traits.Exultite.Name
			}
					ProcessQueue.add_effect(action)
					action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": damage, 
				"damage_type": "blood", 
				"effect_sprite": "Blood", 
				"effect_range": 3, 
				"msg": traits.Exultite.Name
			}
					ProcessQueue.add_effect(action)
				
				var new_buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
				new_buff["target"] = unit
				new_buff["source"] = unit
				new_buff.duration = 2
				var action = {
				"name": "add_buff", 
				"buff": new_buff, 
				"msg": traits.Exultite.Name
			}
				ProcessQueue.add_effect(action)
		
		
		if traits.has("Frostpulse"):
			if Global.Enemies.size() > 0:
				var trait = unit.get_traits().Frostpulse
				var damage = unit.get_total_weight() * trait.Level * 5.0
				damage = float(damage)
				var damage_range = trait.Level
				var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": damage, 
				"damage_type": "ice", 
				"effect_sprite": "Ice", 
				"effect_range": damage_range, 
				"msg": traits.Frostpulse.Name
			}
				ProcessQueue.add_effect(action)
		
		if traits.has("GoreTide"):
			if Global.Enemies.size() > 0:
				var trait = unit.get_traits().GoreTide
				var damage = (unit.HP_max - unit.HP) * trait.Level
				damage = float(damage)
				if damage < 1.0: damage = 1.0
				var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": damage, 
				"damage_type": "blood", 
				"effect_sprite": "Blood", 
				"effect_range": 3, 
				"msg": traits.GoreTide.Name
			}
				ProcessQueue.add_effect(action)
		
		if traits.has("Lash") == true:
			for n in Global.Allies.size():
				var action = {
			"name": "hit_targets_range", 
			"attacker": unit, 
			"hit": 25.0, 
			"weapon": unit.weapon_off, 
			"effect_range": 3, 
			"number_of_targets": 1, 
			"msg": traits.Lash.Name
			
				}
				ProcessQueue.add_effect(action)
		
		if traits.has("Doomsayer"):
		
			var buff = cloner.clone_dict(LBuffs.buff_data.Doom)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 15
			var action = {
				"name": "buff_tiles_in_range", 
				"caster": unit, 
				"effect_sprite": "Doom", 
				"effect_range": 3, 
				"buff": buff, 
				"alliance": calcrange.get_enemy_alliance(unit), 
				"msg": traits.Doomsayer.Name
			}
			ProcessQueue.add_effect(action)
		
		if traits.has("Formus"):
			if Global.Enemies.size() > 0:
				var ants = ["AntPoison", "AntFire", "AntBlood", "AntAstral"]
				var amount = 1
				
				
					
				for n in amount:
						var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data[ants[Global.rng.randi_range(0, ants.size() - 1)]], 
					"summoner": unit, 
					"msg": traits.Formus.Name
				}
						ProcessQueue.add_effect(action)
		
		if traits.has("Overgrowth"):
			if Global.Enemies.size() > 0:
				var trait = unit.get_traits().Overgrowth
				
				for ally in Global.Allies:
					if ally != Global.Player:
						
						if ally.type.tags.has("[color=#00a000]Plant[/color]"):
						
							var life_gain = (0.05 * float(trait.Level)) * ally.HP_max
							if life_gain > 1000.0:
								life_gain = 1000.0
							var action = {
			"name": "apply_bonus", 
			"origin": unit, 
			"target": ally, 
			"amount": life_gain, 
			"type": "life", 
			"msg": traits.Overgrowth.Name
			}
							ProcessQueue.add_effect(action)
						
					
				
				for n in trait.Level:
						var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Gisa, 
					"summoner": unit, 
					"msg": traits.Overgrowth.Name
				}
						ProcessQueue.add_effect(action)
		
		
		if traits.has("EarthMage"):
			if Global.Enemies.size() > 0:
				for n in 2:
						var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.gorse, 
					"summoner": unit, 
					"msg": traits.EarthMage.Name
				}
						ProcessQueue.add_effect(action)
		if traits.has("Necromancer"):
			if Global.Enemies.size() > 0:
				for n in 2:
						var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.skeleton, 
					"summoner": unit, 
					"msg": traits.Necromancer.Name
				}
						ProcessQueue.add_effect(action)
		
		if traits.has("Gallus"):
			if Global.Enemies.size() > 0:
	
				var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": unit.get_total_weight(), 
				"damage_type": "blunt", 
				"effect_sprite": "Bash", 
				"effect_range": 4, 
				"msg": traits.Gallus.Name
			}
				ProcessQueue.add_effect(action)
		
		if traits.has("Destroyer"):
			if Global.Enemies.size() > 0:
				
				var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": 50.0, 
				"damage_type": "death", 
				"effect_sprite": "Curse", 
				"effect_range": 99, 
				"msg": traits.Destroyer.Name
			}
				ProcessQueue.add_effect(action)
				action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": 50.0, 
				"damage_type": "astral", 
				"effect_sprite": "Astral", 
				"effect_range": 99, 
				"msg": traits.Destroyer.Name
			}
				ProcessQueue.add_effect(action)
		
		
		
		
		if traits.has("WarChant"):
			if Global.Enemies.size() > 0:
		
				var buff = cloner.clone_dict(LBuffs.buff_data.Poise)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = unit.get_traits().WarChant.Level * 5
				var action = {
					"name": "buff_tiles_in_range", 
					"caster": unit, 
					"effect_sprite": "Poise", 
					"effect_range": 3, 
					"buff": buff, 
					"alliance": calcrange.get_allied_alliance(unit), 
					"msg": traits.WarChant.Name
			}
				ProcessQueue.add_effect(action)

			
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = unit.get_traits().WarChant.Level * 5
				var action2 = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": traits.WarChant.Name
				}
				ProcessQueue.add_effect(action2)
		
		
		
		
		
		
		if traits.has("AmplifiedHealing"):
			var trait = traits.AmplifiedHealing
			if Global.Enemies.size() > 0:
				var action = {
				"name": "heal", 
				"amount": 50.0 * trait.Level, 
				"healer_unit": unit, 
				"healed_unit": unit, 
				"msg": traits.AmplifiedHealing.Name
			}
				ProcessQueue.add_effect(action)
		
		if traits.has("Geistform"):
			if Global.Enemies.size() > 0:
				for buff in unit.Buffs:
					if buff.name == "Crystalform":
			
						var action = {
				"name": "heal", 
				"amount": 1.0 * buff.duration, 
				"healer_unit": unit, 
				"healed_unit": unit, 
				"msg": "Crystalform"
			}
						ProcessQueue.add_effect(action)
						
						for enemy in Global.Enemies:
							var new_buff = cloner.clone_dict(LBuffs.buff_data.Freeze)
							new_buff["target"] = enemy
							new_buff["source"] = unit
							new_buff.duration = 1 * buff.duration
							action = {
				"name": "add_buff", 
				"buff": new_buff, 
				"msg": "Crystalform"
			}
							ProcessQueue.add_effect(action)
		
		
	
	if traits.has("gorse"):
			if Global.Enemies.size() > 0:
				var amount = unit.HP_max * 0.25
				var action = {
				"name": "heal", 
				"amount": amount, 
				"healer_unit": unit, 
				"healed_unit": unit, 
				"msg": traits.gorse.Name
			}
				ProcessQueue.add_effect(action)
	
	if traits.has("Chuluma"):
			var trait = unit.get_traits().Chuluma
			var buff = cloner.clone_dict(LBuffs.buff_data.Entangle)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 3 * trait.Level
			var action = {
				"name": "buff_targets_in_range", 
				"caster": unit, 
				"effect_sprite": "Entangle", 
				"number_of_targets": 2, 
				"effect_range": 3, 
				"buff": buff, 
				"is_allied": false, 
				"msg": traits.Chuluma.Name
			}
			ProcessQueue.add_effect(action)
	
	
	if traits.has("SummonBuds"):
		for n in 5:
				var action = {
					"name": "summon", 
					"alliance": "enemy", 
					"type": LEnemies.enemy_data.GlimmeringBud, 
					"summoner": unit, 
					"msg": traits.SummonBuds.Name
				}
				ProcessQueue.add_effect(action)
	
	if traits.has("KingSummon"):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var unit_list = [LEnemies.enemy_data.demongreen, 
		LEnemies.enemy_data.demonred, 
		LEnemies.enemy_data.demonwhite, 
		LEnemies.enemy_data.demongold, 
		LEnemies.enemy_data.demonviolet]
		var action = {
					"name": "summon_random", 
					"alliance": "enemy", 
					"type": unit_list[rng.randi_range(0, unit_list.size() - 1)], 
					"summoner": unit, 
					"msg": traits.KingSummon.Name
				}
		ProcessQueue.add_effect(action)
	
	if traits.has("SikuApak"):
		
			var buff = cloner.clone_dict(LBuffs.buff_data.Freeze)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 5 * unit.get_traits().SikuApak.Level
			var action = {
				"name": "buff_targets_in_range", 
				"caster": unit, 
				"effect_sprite": "Chill", 
				"number_of_targets": 2, 
				"effect_range": 3, 
				"buff": buff, 
				"is_allied": false, 
				"msg": traits.SikuApak.Name
			}
			ProcessQueue.add_effect(action)
	
	if traits.has("Immolation"):
			var trait = unit.get_traits().Immolation
			var buff = cloner.clone_dict(LBuffs.buff_data.Scorch)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 10 * trait.Level
			var action = {
				"name": "buff_tiles_in_range", 
				"caster": unit, 
				"effect_sprite": "Burn", 
				"effect_range": 1, 
				"buff": buff, 
				"alliance": calcrange.get_enemy_alliance(unit), 
				"msg": traits.Immolation.Name
			}
			ProcessQueue.add_effect(action)
	
	
	if traits.has("Ihra"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Protection)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 1
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": Global.Player.get_traits().Ihra.Name
			}
			ProcessQueue.add_effect(action)
	
	
	if traits.has("Static"):

		var action = {
				"name": "magic_damage_tiles_in_path_to_targets_in_range", 
				"caster": unit, 
				"damage": 10.0, 
				"damage_type": "lightning", 
				"effect_sprite": "Zap", 
				"number_of_targets": 1, 
				"effect_range": 99, 
				"enemies": null, 
				"msg": traits.Static.Name
				}
		ProcessQueue.add_effect(action)
	
	
	if traits.has("Ninhurs"):
		for enemy in Global.Enemies:
			if enemy.residence.tileset.title == "ninhurs":
		
				var buff = cloner.clone_dict(LBuffs.buff_data.Entangle)
				buff["target"] = enemy
				buff["source"] = unit
				buff.duration = 10
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": traits.Ninhurs.Name
			}
				ProcessQueue.add_effect(action)
	
	
	if traits.has("IceShah"):
		for enemy in Global.Enemies:
			if enemy.residence.tileset.title == "iceshah":
		
				var buff = cloner.clone_dict(LBuffs.buff_data.Entangle)
				buff["target"] = enemy
				buff["source"] = unit
				buff.duration = 5
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": Global.Player.get_traits().IceShah.Name
			}
				ProcessQueue.add_effect(action)
			
				action = {
					"name": "magic_damage_target", 
					"target": enemy, 
					"caster": unit, 
					"damage": 200.0, 
					"damage_type": "ice", 
					"effect_sprite": "Ice", 
					"msg": traits.IceShah.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit == Global.Player:

		if traits.has("Oozemancer") and Global.Enemies.size() > 0:
			
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.ooze, 
					"summoner": unit, 
					"msg": traits.Oozemancer.Name
				}
				ProcessQueue.add_effect(action)
	
		
		
		if traits.has("BloodMage"):
				
				var buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 6
				var action = {
				"name": "buff_tiles_in_range", 
				"caster": unit, 
				"effect_sprite": "Bleed", 
				"effect_range": 3, 
				"buff": buff, 
				"alliance": calcrange.get_enemy_alliance(unit), 
				"msg": traits.BloodMage.Name
			}
				ProcessQueue.add_effect(action)
	
	if unit == Global.Player:
		
		
		if traits.has("Warrior"):

			
				var buff = cloner.clone_dict(LBuffs.buff_data.Poise)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 7
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": traits.Warrior.Name
			}
				ProcessQueue.add_effect(action)
		
		
		if traits.has("Secutor"):
			if Global.Enemies.size():

				var pool = ["Poise", "Evasion", "Inflame", "Anoint"]
				
				var highest_number = unit.get_total_STR()
				if unit.get_total_DEX() > highest_number: highest_number = unit.get_total_DEX()
				if unit.get_total_WIL() > highest_number: highest_number = unit.get_total_WIL()
				
				for n in 1:
					
					var buff = cloner.clone_dict(LBuffs.buff_data[pool[Global.rng.randi_range(0, pool.size() - 1)]])
					buff["target"] = unit
					buff["source"] = unit
					buff.duration = highest_number
					var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": traits.Secutor.Name
			}
					ProcessQueue.add_effect(action)
				
				var heal = 0.0
				for buff in unit.Buffs:
					if float(buff.duration) > heal:
						heal = float(buff.duration)
						
				if heal > 0.0:
					var action = {
				"name": "heal", 
				"amount": heal, 
				"healer_unit": unit, 
				"healed_unit": unit, 
				"msg": traits.Secutor.Name
				}
					ProcessQueue.add_effect(action)
		
		if traits.has("MasterRepulsion"):
			if Global.Enemies.size() > 0:

				var scaled_duration = 1
				for checkbuff in unit.Buffs:
					if checkbuff.name == "Repulsion":
						scaled_duration = int(float(checkbuff.duration) * (0.05 * float(unit.get_traits().MasterRepulsion.Level)))
						if scaled_duration < 1: scaled_duration = 1
				var buff = cloner.clone_dict(LBuffs.buff_data.Repulsion)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = scaled_duration
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": traits.MasterRepulsion.Name
			}
				ProcessQueue.add_effect(action)
		
		
		if traits.has("Albaz"):
			if Global.Enemies.size() > 0:
		
				var action = {
				"name": "heal", 
				"amount": 100.0 + (unit.get_total_DEX() * 10.0), 
				"healer_unit": unit, 
				"healed_unit": unit, 
				"msg": traits.Albaz.Name
				}
				ProcessQueue.add_effect(action)
		
		if traits.has("greenhead"):
			if Global.Enemies.size() > 0:
		
				var action = {
				"name": "heal", 
				"amount": 0.05 * float(unit.HP_max), 
				"healer_unit": unit, 
				"healed_unit": unit, 
				"msg": traits.greenhead.Name
				}
				ProcessQueue.add_effect(action)
	
	if traits.has("AuraFreeze"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Freeze)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 3
			var action = {
				"name": "buff_targets_in_range", 
				"caster": unit, 
				"effect_sprite": "Chill", 
				"number_of_targets": 2, 
				"effect_range": 2, 
				"buff": buff, 
				"is_allied": false, 
				"msg": traits.AuraFreeze.Name
				}
			ProcessQueue.add_effect(action)
	
	if traits.has("Worshipper"):
		var action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": 500.0, 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"msg": traits.Worshipper.Name
				}
		ProcessQueue.add_effect(action)
		
		action = {
			"name": "magic_damage_targets_range", 
			"caster": unit, 
			"damage": 500.0, 
			"damage_type": "astral", 
			"effect_sprite": "Astral", 
			"number_of_targets": 1, 
			"effect_range": 1, 
			"msg": traits.Worshipper.Name
				}
		ProcessQueue.add_effect(action)
	
	if traits.has("CorrosionAura"):
		var buff = cloner.clone_dict(LBuffs.buff_data.Corrosion)
		buff["target"] = unit
		buff["source"] = unit
		buff.duration = 3
		var action = {
				"name": "buff_targets_in_range", 
				"caster": unit, 
				"effect_sprite": "Corrode", 
				"number_of_targets": 2, 
				"effect_range": 2, 
				"buff": buff, 
				"is_allied": false, 
				"msg": traits.CorrosionAura.Name
				}
		ProcessQueue.add_effect(action)

	if traits.has("DoomAura"):
		var buff = cloner.clone_dict(LBuffs.buff_data.Doom)
		buff["target"] = unit
		buff["source"] = unit
		buff.duration = 3
		var action = {
				"name": "buff_targets_in_range", 
				"caster": unit, 
				"effect_sprite": "Doom", 
				"number_of_targets": 2, 
				"effect_range": 2, 
				"buff": buff, 
				"is_allied": false, 
				"msg": traits.DoomAura.Name
				}
		ProcessQueue.add_effect(action)
	
	if traits.has("EntangleAura"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Entangle)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 3
			var action = {
				"name": "buff_targets_in_range", 
				"caster": unit, 
				"effect_sprite": "Entangle", 
				"number_of_targets": 2, 
				"effect_range": 2, 
				"buff": buff, 
				"is_allied": false, 
				"msg": traits.EntangleAura.Name
				}
			ProcessQueue.add_effect(action)
			
	
	if traits.has("AuraScorch"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Scorch)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 3
			var action = {
				"name": "buff_targets_in_range", 
				"caster": unit, 
				"effect_sprite": "Burn", 
				"number_of_targets": 2, 
				"effect_range": 2, 
				"buff": buff, 
				"is_allied": false, 
				"msg": traits.AuraScorch.Name
				}
			ProcessQueue.add_effect(action)
	
	if traits.has("AuraSick"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Sickness)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 3
			var action = {
				"name": "buff_targets_in_range", 
				"caster": unit, 
				"effect_sprite": "Poison", 
				"number_of_targets": 2, 
				"effect_range": 2, 
				"buff": buff, 
				"is_allied": false, 
				"msg": traits.AuraSick.Name
				}
			ProcessQueue.add_effect(action)
	
	if traits.has("AuraBleed"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 3
			var action = {
				"name": "buff_targets_in_range", 
				"caster": unit, 
				"effect_sprite": "Bleed", 
				"number_of_targets": 2, 
				"effect_range": 2, 
				"buff": buff, 
				"is_allied": false, 
				"msg": traits.AuraBleed.Name
				}
			
			
				
				
				
				
				
			
			ProcessQueue.add_effect(action)
