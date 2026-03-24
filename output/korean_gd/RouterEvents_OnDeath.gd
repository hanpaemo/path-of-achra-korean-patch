extends Node

class_name event_death

static func check(dying_unit, killer):
	
	if Global.Enemies.has(dying_unit) == true or Global.Allies.has(dying_unit) == true:
		add_score(dying_unit, killer)
		death_message(dying_unit, killer)
		var target = dying_unit
		effectmaker.create_effect_animated(target.global_position, Global.EffectAnimated, target.sprite_corpse)
		
		
		if dying_unit.object_type == "enemy" or dying_unit.object_type == "ally":
			
			if dying_unit.object_type == "enemy":
				Global.Enemies.erase(dying_unit)
				Global.Enemies_Dead.append(dying_unit)
				var xp = dying_unit.type.lvl
				
				if xp < 0:
					xp = 0
				Global.Player.gain_xp(xp)
			if dying_unit.object_type == "ally":
				if Global.Enemies.size():
					ToolInvokes.lose_charge("ally death")
				Global.Allies.erase(dying_unit)
				Global.Allies_Dead.append(dying_unit)
		
		
		
		
	
			
			dying_unit.get_node("Button").mouse_filter = Control.MOUSE_FILTER_IGNORE
			dying_unit.modulate = Color(1, 1, 1, 0)
			if dying_unit.residence != null:
				dying_unit.residence.resident = null
		
		
		
			check_effects(dying_unit, killer)
	
	if dying_unit == Global.Player:
		print("PLAYER DIES")
		dying_unit.death_popup("death")
		
		Steam.set_achievement("death")
		
		
			
	if dying_unit.object_type == "enemy":
		if dying_unit.get_name() == "King of Many Colors":
			Steam.set_achievement("king")
		if dying_unit.get_name() == "Horror Giant" or dying_unit.get_name() == "Voggite" or dying_unit.get_name() == "Robak":
			Steam.set_achievement("golem")
	

	if dying_unit.object_type == "enemy":
		if Global.rng.randi_range(1, 3) == 3:
			speak.create_speech(dying_unit)
		
	
static func add_score(dying_unit, killer):
	match dying_unit.object_type:
		"enemy":
			match killer.object_type:
				"player":
					StatePlayerSheet.score_data.enemies_killed += 1
				"ally":
					StatePlayerSheet.score_data.enemies_killed_by_allies += 1
			if StatePlayerSheet.score_data.enemies.has(dying_unit.type.title) == false:
				if dying_unit.get_traits().has("Preta") == false:
					StatePlayerSheet.score_data.enemies.append(dying_unit.type.title)
				else:
					
					if StatePlayerSheet.score_data.has("preta") == false:
						StatePlayerSheet.score_data["preta"] = []
						StatePlayerSheet.score_data.preta.append(dying_unit.type.sprite)
					elif StatePlayerSheet.score_data.preta.has(dying_unit.type.sprite) == false:
						StatePlayerSheet.score_data.preta.append(dying_unit.type.sprite)
		
		"ally":
			match killer.object_type:
				"player":
					StatePlayerSheet.score_data.allies_killed += 1
	

static func check_effects(dying_unit, killer):
	
	var killer_traits = killer.get_traits()
	var dyer_traits = dying_unit.get_traits()
	var player_traits = Global.Player.get_traits()
	
	if dying_unit.object_type == "enemy":
		if dying_unit.type.boss == true:
			if Global.Player.get_traits().has("Eris") and StateWorld.land != "dust":
				
				var item = null
				if Global.Player.weapon_main != null:
					item = Global.Player.weapon_main
				elif Global.Player.weapon_off != null:
					item = Global.Player.weapon_off
				if item != null:
					
					item.dmg += int(float(item.dmg) * 0.5)
					item.arm += int(float(item.arm) * 0.5)
					item.acc += int(float(item.acc) * 0.5)
					
					if "Eris" in item.name:
						pass
					else:
						item.name += " of [color=#fff0a0]Eris[/color]"
					
					var stringa = "[color=#fff0a0]투사! Eris[/color] 무기 강화: " + item.name + " [color=#ffff50]+50%[/color] [color=#ff8030]명중[/color] / [color=#ffa050]Acc[/color] / [color=#5050ff]방어[/color]"
					effectmaker.create_effect_animated(dying_unit.global_position, Global.EffectAnimated, "Eris")
					ToolMessageCreator.add_message("[color=#c0c0c0]", stringa)
	
	
	if killer_traits.has("Mask_Flame"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Scorch)
			buff["target"] = killer
			buff["source"] = killer
			buff.duration = 2
			var action = {
				"name": "buff_tiles_in_range", 
				"caster": killer, 
				"effect_sprite": "Burn", 
				"effect_range": 4, 
				"buff": buff, 
				"alliance": calcrange.get_enemy_alliance(killer), 
				"msg": killer_traits.Mask_Flame.Name
			}
			ProcessQueue.add_effect(action)
	
	if Global.Player.get_traits().has("DeathKnight"):
		var buff = cloner.clone_dict(LBuffs.buff_data.Poise)
		buff["target"] = Global.Player
		buff["source"] = Global.Player
		buff.duration = 10
		var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": Global.Player.get_traits().DeathKnight.Name
		}
		ProcessQueue.add_effect(action)
		
		action = {
			"name": "heal", 
			"amount": 50.0, 
			"healer_unit": Global.Player, 
			"healed_unit": Global.Player, 
			"msg": Global.Player.get_traits().DeathKnight.Name
			}
		ProcessQueue.add_effect(action)
	

	
	if dying_unit.object_type == "ally":
		if Global.Player.get_traits().has("Valr"):
			var damage = 0.2 * float(Global.Player.get_block_strength())
			var action = {
				"name": "magic_damage_targets_range", 
			"caster": Global.Player, 
			"damage": damage, 
			"damage_type": "death", 
			"effect_sprite": "Bastral", 
			"number_of_targets": 1, 
			"effect_range": 99, 
				"msg": Global.Player.get_traits().Valr.Name
				}
			ProcessQueue.add_effect(action)
	
	if killer_traits.has("Kuga"):
				var trait = killer_traits.Kuga
		

				var buff = cloner.clone_dict(LBuffs.buff_data.Plague)
				buff["target"] = killer
				buff["source"] = killer
				buff.duration = 3 * trait.Level
				var action = {
				"name": "buff_targets_in_range", 
				"caster": killer, 
				"effect_sprite": "Plague", 
				"number_of_targets": 1, 
				"effect_range": 3, 
				"buff": buff, 
				"is_allied": false, 
				"msg": killer_traits.Kuga.Name
				}
				ProcessQueue.add_effect(action)
	
	if dying_unit.object_type == "ally" or dying_unit.object_type == "enemy":
		if Global.Player.get_traits().has("HungryGrave"):
			var trait = Global.Player.get_traits().HungryGrave
			var amount = 10.0 * trait.Level
			
			var action = {
			"name": "apply_bonus_ally_random_of_tag", 
			"origin": Global.Player, 
			"tag": "[color=#a0a000]언데드[/color]", 
			"amount": amount, 
			"type": "damage", 
			"msg": Global.Player.get_traits().HungryGrave.Name
			}
			ProcessQueue.add_effect(action)
	
	
	if dying_unit.object_type == "enemy":
		if Global.Player.is_dead() == false and Global.Player.armor_chest == null and Global.Player.get_traits().has("CrowVisage"):
			
			ToolMessageCreator.add_message("[color=#c07070]", Global.Player.get_traits().CrowVisage.Name + "(이)가 '제자리 대기' 행동 수행...")
			event_move.check_wait(Global.Player)
			
			
			
	
		
		if Global.Player.is_dead() == false and Global.Player.get_traits().has("IceShah"):
			if dying_unit.residence.tileset.title == "iceshah":
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.livingice, 
					"summoner": Global.Player, 
					"msg": Global.Player.get_traits().IceShah.Name
				}
				ProcessQueue.add_effect(action)
		
		if Global.Player.is_dead() == false and Global.Player.get_traits().has("Plaguemancer"):
			var traits = Global.Player.get_traits()
			var msg = traits.Plaguemancer.Name
			for enemy in Global.Enemies:
					var buff = cloner.clone_dict(LBuffs.buff_data.Plague)
					buff["target"] = enemy
					buff["source"] = Global.Player
					buff.duration = 2
					var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": msg
			}
					ProcessQueue.add_effect(action)
				
	
	
	if dying_unit.object_type == "ally":
		
		if killer != null:
			if Global.Player.get_traits().has("Necromancer") and killer.object_type == "enemy":
				var damage = 20.0 * Global.Allies.size()
				var msg = Global.Player.get_traits().Necromancer.Name
				ToolMagicMaker.add_hit_event(killer, Global.Player, damage, Global.Player.weapon_main, msg)
		
		
		
		
		
		if Global.Player.get_traits().has("Topheth"):
			
			var action = {
					"name": "magic_damage_target", 
					"target": Global.Player, 
					"caster": Global.Player, 
					"damage": 5.0 * Global.Allies.size(), 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": Global.Player.get_traits().Topheth.Name
				}
			ProcessQueue.add_effect(action)
			
			for enemy in Global.Enemies:
				action = {
					"name": "magic_damage_target", 
					"target": enemy, 
					"caster": Global.Player, 
					"damage": 20.0 * Global.Allies.size(), 
					"damage_type": "death", 
					"effect_sprite": "Curse", 
					"msg": Global.Player.get_traits().Topheth.Name
				}
				ProcessQueue.add_effect(action)
				
		
		
		
	
		if Global.Player.get_traits().has("Acolyte"):
		
				var action = {
				"name": "magic_damage_target", 
				"caster": Global.Player, 
				"target": Global.Player, 
				"damage": float(Global.Player.get_total_WIL()), 
				"damage_type": "psychic", 
				"effect_sprite": "PsychicDark", 
				"msg": Global.Player.get_traits().Acolyte.Name
			}
				ProcessQueue.add_effect(action)
	
	
	if killer != null:
		
		
		
		
		if killer_traits.has("Astrohunting") and dying_unit.object_type == "enemy":
			if Global.Player.get_armor_list().size() == 0:
				var trait = killer_traits.Astrohunting
				var target = ToolMagicMaker.get_closest_enemy(killer, ToolMagicMaker.get_enemies(killer))
				if target != null:
			
					var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": killer, 
				"damage": 100.0 * trait.Level, 
				"damage_type": "astral", 
				"effect_sprite": "Astral", 
				"effect_range": 1, 
				"msg": killer_traits.Astrohunting.Name
			}
					ProcessQueue.add_effect(action)
			
					action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": killer, 
				"damage": 100.0 * trait.Level, 
				"damage_type": "lightning", 
				"effect_sprite": "Zap", 
				"effect_range": 1, 
				"msg": killer_traits.Astrohunting.Name
			}
					ProcessQueue.add_effect(action)
			
					action = {
			"name": "teleport", 
			"unit": killer, 
			"tile_target": target.residence, 
			"msg": killer_traits.Astrohunting.Name
			}
					ProcessQueue.add_effect(action)
		
		
		if dying_unit.get_traits().has("DeathCurse"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Doom)
			buff["target"] = killer
			buff["source"] = dying_unit
			buff.duration = 5
			var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": dying_unit.get_traits().DeathCurse.Name
		}
			ProcessQueue.add_effect(action)
		
	
		
		
		if killer.get_name() == "Ant":
			ToolInvokes.recharge("ant kill")
		
		
		if dying_unit.object_type == "ally":
			ToolInvokes.recharge("ally death")
		
		if dying_unit.object_type == "enemy":
			ToolInvokes.recharge("enemy death")
			if Global.Player.is_dead() == false:
				if calcrange.tile_is_in_range(dying_unit.residence, Global.Player.residence, 1):
					ToolInvokes.recharge("enemy death adjacent")
				if calcrange.tile_is_in_range(dying_unit.residence, Global.Player.residence, 2):
					ToolInvokes.recharge("enemy death in range")
				
			if killer == Global.Player:
				ToolInvokes.recharge("kill")
				ToolInvokes.lose_charge("kill")
				if calcrange.tile_is_in_range(dying_unit.residence, Global.Player.residence, 1) == false:
					ToolInvokes.recharge("kill non adjacent")
				if killer.get_buff_names().has("Bloodrage"):
					ToolInvokes.recharge("kill while bloodrage")
			if dying_unit.residence.tileset.title == "ninhurs":
				ToolInvokes.recharge("kill on grass")
			if dying_unit.type.boss == true:
				ToolInvokes.recharge("kill boss")
		
		if killer_traits.has("Uhrata"):
			if dying_unit.object_type == "enemy":
				if calcrange.tile_is_in_range(dying_unit.residence, Global.Player.residence, 1):
					ToolInvokes.uhrata()
		
		if killer.get_traits().has("FeastDeadly"):
			
		
			
		
		
			
			
		
			
			var action = {
			"name": "apply_bonus", 
			"origin": killer, 
			"target": killer, 
			"amount": 10.0, 
			"type": "damage", 
			"msg": killer.get_traits().FeastDeadly.Name
			}
			ProcessQueue.add_effect(action)
		
		if Global.Player.get_traits().has("Oozemancer") and Global.Player.is_dead() == false:
			if dying_unit.object_type == "enemy":
			
			
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.ooze, 
					"summoner": Global.Player, 
					"msg": Global.Player.get_traits().Oozemancer.Name
				}
				ProcessQueue.add_effect(action)
		
		
		if killer.get_traits().has("Berserker"):
			var death_msg = killer.get_traits().Berserker.Name
			var action = {
					"name": "magic_damage_target", 
					"target": killer, 
					"caster": killer, 
					"damage": 15.0, 
					"damage_type": "death", 
					"effect_sprite": "Curse", 
					"msg": death_msg
				}
			ProcessQueue.add_effect(action)
		
			action = {
					"name": "magic_damage_target", 
					"target": killer, 
					"caster": killer, 
					"damage": 15.0, 
					"damage_type": "blood", 
					"effect_sprite": "Blood", 
					"msg": death_msg
				}
			ProcessQueue.add_effect(action)
			
			action = {
					"name": "magic_damage_target", 
					"target": killer, 
					"caster": killer, 
					"damage": 15.0, 
					"damage_type": "ice", 
					"effect_sprite": "Ice", 
					"msg": death_msg
				}
			ProcessQueue.add_effect(action)
		
	
	if killer.get_traits().has("Horror"):
		var msg = killer.get_traits().Horror.Name
		for fr_buff in killer.Buffs:
				if fr_buff.name == "Horrorform":
					var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": killer, 
				"damage": 1.0 * fr_buff.duration, 
				"damage_type": "blood", 
				"effect_sprite": "Blood", 
				"effect_range": 2, 
				"msg": killer.get_traits().Horror.Name
			}
					ProcessQueue.add_effect(action)
					
					for key in Global.Player.invokes:
						ToolInvokes.force_lose_charge(key, msg)
				
					
					
				
					
	
		
		
		
					
					
					
		
			
	
	if dying_unit.object_type != "player":
		if Global.Player.get_traits().has("Vengati"):
			for fr_buff in dying_unit.Buffs:
				if fr_buff.name == "Sickness":
					var buff = cloner.clone_dict(LBuffs.buff_data.Repulsion)
					buff["target"] = Global.Player
					buff["source"] = Global.Player
					buff.duration = int(fr_buff.duration) * 5
					var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": Global.Player.get_traits().Vengati.Name
		}
					ProcessQueue.add_effect(action)
	
	
	if dying_unit.object_type != "player":
		if Global.Player.get_traits().has("MasterDoom"):
			var trait = Global.Player.get_traits().MasterDoom
			var buff = cloner.clone_dict(LBuffs.buff_data.Doom)
			buff["target"] = Global.Player
			buff["source"] = Global.Player
			buff.duration = 10 * trait.Level
			var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": Global.Player.get_traits().MasterDoom.Name
		
		}
			ProcessQueue.add_effect(action)
			
		pass
	
		if Global.Player.get_traits().has("Doomsayer") and dying_unit.object_type == "enemy":
			for fr_buff in dying_unit.Buffs:
				if fr_buff.name == "Doom":
					var buff = cloner.clone_dict(LBuffs.buff_data.Doom)
					buff["target"] = Global.Player
					buff["source"] = Global.Player
					buff.duration = int(fr_buff.duration)
					var action = {
				"name": "buff_targets_in_range", 
				"caster": killer, 
				"effect_sprite": "Doom", 
				"number_of_targets": 1, 
				"effect_range": 99, 
				"buff": buff, 
				"is_allied": false, 
				"msg": player_traits.Doomsayer.Name
				}
					ProcessQueue.add_effect(action)
	
	
	
	
	if killer.get_traits().has("ToothedSword"):
			var unit = killer
			var action = {
				"name": "magic_damage_target", 
				"target": killer, 
				"caster": killer, 
				"damage": 50.0, 
				"damage_type": "blood", 
				"effect_sprite": "Blood", 
				"msg": killer.get_traits().ToothedSword.Name
				}
			ProcessQueue.add_effect(action)
			action = {
				"name": "magic_damage_target_closest", 
				"caster": unit, 
				"damage": unit.get_DMG_total(unit.weapon_main) * 0.5, 
				"damage_type": "blood", 
				"effect_sprite": "Blood", 
				"msg": killer.get_traits().ToothedSword.Name
				}
			ProcessQueue.add_effect(action)
	
	
	if dying_unit.get_traits().has("RatManFlourisher"):
		
		for n in 1:
			var action = {
					"name": "summon_random", 
					"alliance": "ally", 
					"type": LAllies.ally_data.ratman_peltast, 
					"summoner": Global.Player, 
					"msg": dying_unit.get_traits().RatManFlourisher.Name
				}
			ProcessQueue.add_effect(action)
	
	if killer.get_traits().has("ChannelDeath"):
		if dying_unit.get_name() != "Cadaver":
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.cadaver, 
					"summoner": killer, 
					"msg": killer.get_traits().ChannelDeath.Name
				}
			ProcessQueue.add_effect(action)
	
	if killer.get_traits().has("Sherkegar"):
			var unit = killer
			var action = {
			"name": "heal", 
			"amount": 50, 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": killer.get_traits().Sherkegar.Name
			}
			ProcessQueue.add_effect(action)
	
	if killer.get_traits().has("Humbaba"):
			var unit = killer
			var action = {
			"name": "heal", 
			"amount": 10, 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": killer.get_traits().Humbaba.Name
			}
			ProcessQueue.add_effect(action)
	
	if killer.get_traits().has("Upuat"):
		for buff in killer.Buffs:
			if buff.name == "Jackalform":
				var unit = killer
				var action = {
			"name": "heal", 
			"amount": buff.duration * 5, 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": "Jackalform"
			}
				ProcessQueue.add_effect(action)
				
	
	if killer.get_traits().has("LizardVisage"):
		if killer.armor_chest == null:
			var unit = killer
			var action = {
			"name": "heal", 
			"amount": 50, 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": killer.get_traits().LizardVisage.Name
			}
			ProcessQueue.add_effect(action)
	
	
	if dying_unit.object_type == "enemy":
		
		

		if Global.Player.get_traits().has("Rabbah"):
			var unit = Global.Player
			var trait = unit.get_traits().Rabbah
			var action = {
			"name": "heal", 
			"amount": trait.base * trait.Level, 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": Global.Player.get_traits().Rabbah.Name
			}
			ProcessQueue.add_effect(action)
			action = {
					"name": "magic_damage_targets_range", 
					"caster": unit, 
					"damage": 50.0 * trait.Level, 
					"damage_type": "death", 
					"effect_sprite": "Curse", 
					"number_of_targets": 2, 
					"effect_range": 1, 
					"msg": Global.Player.get_traits().Rabbah.Name
				}
			ProcessQueue.add_effect(action)
	
	if killer.get_traits().has("Executioner"):
		if dying_unit.object_type == "enemy":
			var unit = killer
			var action = {
			"name": "heal", 
			"amount": 100, 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": killer.get_traits().Executioner.Name
			}
			ProcessQueue.add_effect(action)
			action = {
			"name": "attack_targets", 
			"attacker": killer, 
			"number_of_targets": 1, 
			"msg": killer.get_traits().Executioner.Name
		}
	
			ProcessQueue.add_effect(action)
	
		
	if dying_unit.object_type == "ally":
		
		var caster = Global.Player
		if caster.get_traits().has("Warlock"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
			buff["target"] = caster
			buff["source"] = caster
			buff["duration"] = 3
			var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": caster.get_traits().Warlock.Name
		}
			ProcessQueue.add_effect(action)
		
			action = {
				"name": "magic_damage_target_closest", 
				"caster": caster, 
				"damage": 100.0, 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"msg": caster.get_traits().Warlock.Name
				}
			ProcessQueue.add_effect(action)
		
		
		if Global.Enemies.size() > 0:
			if Global.Player.get_traits().has("Eresh"):
				var unit = Global.Player
				var amount = float(Global.Player.bag.size()) * 5.0
				if StateWorld.land == "dust":
					amount = 33.0 * 5.0
				
				var action = {
			"name": "magic_damage_tiles_in_path_to_targets_in_range", 
			"caster": unit, 
			"damage": amount, 
			"damage_type": "death", 
			"effect_sprite": "Curse", 
			"number_of_targets": 1, 
			"effect_range": 99, 
			"enemies": null, 
			"msg": Global.Player.get_traits().Eresh.Name
				}
				ProcessQueue.add_effect(action)
				
				action = {
			"name": "heal", 
			"amount": amount, 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": Global.Player.get_traits().Eresh.Name
			}
				ProcessQueue.add_effect(action)
			
			if Global.Player.get_traits().has("BlightCult"):
				var unit = Global.Player
				var trait = unit.get_traits().BlightCult
				var action = {
			"name": "magic_damage_tiles_in_path_to_targets_in_range", 
			"caster": unit, 
			"damage": 50.0 * trait.Level, 
			"damage_type": "death", 
			"effect_sprite": "Curse", 
			"number_of_targets": 1, 
			"effect_range": 4, 
			"enemies": null, 
			"msg": Global.Player.get_traits().BlightCult.Name
				}
				ProcessQueue.add_effect(action)
	
	if killer.get_traits().has("Templar"):
		if killer.is_dead() == false:
			if killer.get_buff_names().has("Anoint"):
				var buff = cloner.clone_dict(LBuffs.buff_data.Anoint)
				buff["target"] = killer
				buff["source"] = killer
				buff.duration = 3
				var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": killer.get_traits().Templar.Name
		}
				ProcessQueue.add_effect(action)
	
	if killer.get_traits().has("BerserkerAxe"):
		if killer.is_dead() == false:
				var buff = cloner.clone_dict(LBuffs.buff_data.Berserk)
				buff["target"] = killer
				buff["source"] = killer
				buff.duration = 5
				var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": killer.get_traits().BerserkerAxe.Name
		}
				ProcessQueue.add_effect(action)
	
	if killer.get_traits().has("Destroyer"):
		if killer.is_dead() == false:
				var buff = cloner.clone_dict(LBuffs.buff_data.Meditate)
				buff["target"] = killer
				buff["source"] = killer
				buff.duration = 2
				var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": killer.get_traits().Destroyer.Name
		}
				ProcessQueue.add_effect(action)
		
	if killer.get_traits().has("NinhursServant"):
		if killer.is_dead() == false:
			var action2 = {
			"name": "change_tileset_in_area", 
			"tile_target": killer.residence, 
			"tileset": "ninhurs", 
			"effect_range": 1, 
			"effect_sprite": "Ninhurs", 
			"msg": killer.get_traits().NinhursServant.Name
		}
			ProcessQueue.add_effect(action2)
	
	if killer.get_traits().has("VoidMage"):
		if int(killer.get_total_weight()) <= int(killer.get_total_STR()):
			for buff in killer.Buffs:
				if buff.name == "Freeze":
					var action = {
						"name": "remove_buff", 
						"target": killer, 
						"buff": buff, 
						"msg": killer.get_traits().VoidMage.Name
						}
					ProcessQueue.add_effect(action)
			
			var damage = 25.0
			for enemy in Global.Enemies:
				var action = {
					"name": "magic_damage_target", 
					"target": enemy, 
					"caster": killer, 
					"damage": damage, 
					"damage_type": "death", 
					"effect_sprite": "Curse", 
					"msg": killer.get_traits().VoidMage.Name
				}
			
				ProcessQueue.add_effect(action)
	
	
	if killer.get_traits().has("EmeraldChakram"):
		if killer.is_dead() == false:
			if dying_unit.object_type == "enemy":
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.serpent, 
					"summoner": killer, 
					"msg": killer.get_traits().EmeraldChakram.Name
				}
				ProcessQueue.add_effect(action)
				action = {
			"name": "apply_bonus_random_ally", 
			"origin": killer, 
			"amount": 20.0, 
			"type": "speed", 
			"msg": killer.get_traits().EmeraldChakram.Name
				}
				ProcessQueue.add_effect(action)
	
	if killer.get_traits().has("Frenzy"):
		if killer.is_dead() == false:
			if dying_unit.object_type == "enemy":
				for n in 3:
					var action = {
			"name": "attack_targets", 
			"attacker": killer, 
			"number_of_targets": 1, 
			"msg": killer.get_traits().Frenzy.Name
		}
	
					ProcessQueue.add_effect(action)
				
				
				var heal = 5.0 * killer.get_total_STR()
				var unit = killer
				var action = {
			"name": "heal", 
			"amount": heal, 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": killer.get_traits().Frenzy.Name
			}
				ProcessQueue.add_effect(action)
	
	
	if killer.get_traits().has("stafffire") == true:
			
				var action = {
			"name": "magic_damage_targets_range", 
			"caster": killer, 
			"damage": killer.get_total_WIL() * 5.0, 
			"damage_type": "fire", 
			"effect_sprite": "Flame", 
			"number_of_targets": 1, 
			"effect_range": 2, 
			"msg": killer.get_traits().stafffire.Name
				}
				ProcessQueue.add_effect(action)
	
	if killer.get_traits().has("VileCoup"):
		
		var damage = 5.0 * killer.get_total_DEX()
		
		var action = {
			"name": "magic_damage_tiles_in_path_to_targets_in_range", 
			"caster": killer, 
			"damage": damage, 
			"damage_type": "poison", 
			"effect_sprite": "PoisonHit", 
			"number_of_targets": 1, 
			"effect_range": 4, 
			"msg": killer.get_traits().VileCoup.Name, 
			"enemies": null
				}
		ProcessQueue.add_effect(action)
	
	if killer.get_traits().has("Exult"):
		
		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": killer, 
				"damage": float(killer.get_DMG_max(null)) * 0.1, 
				"damage_type": killer.get_DMG_type(null), 
				"effect_sprite": translate.dmgtype_to_animation(killer.get_DMG_type(null)), 
				"msg": killer.get_traits().Exult.Name, 
				"effect_range": 2
			}
		ProcessQueue.add_effect(action)
	
	if killer.get_traits().has("NightCrow"):
		if Global.Player.get_armor_list().size() == 1 and Global.Player.armor_head != null:
			
				var crow_damage = 0.0
				for buff in killer.Buffs:
					if buff.name == "Crowform":
						crow_damage += float(buff.duration)
				
				var crow_buff = cloner.clone_dict(LBuffs.buff_data.Crowform)
				crow_buff["target"] = killer
				crow_buff["source"] = killer
				crow_buff.duration = 2
				crow_damage *= 5.0
				if killer.get_buff_names().has("Crowform"):
					var action = {
				"name": "magic_damage_target_closest", 
				"caster": killer, 
				"damage": crow_damage, 
				"damage_type": "death", 
				"effect_sprite": "Curse", 
				"msg": killer_traits.NightCrow.Name
				}
					ProcessQueue.add_effect(action)
					action = {
					"name": "magic_damage_target", 
					"target": killer, 
					"caster": killer, 
					"damage": 15.0, 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"msg": killer_traits.NightCrow.Name
				}
					ProcessQueue.add_effect(action)
				
				var action = {
		"name": "add_buff", 
		"buff": crow_buff, 
		"msg": killer_traits.NightCrow.Name
		}
				ProcessQueue.add_effect(action)
	
	if killer.get_traits().has("ThunderMask"):
		var buff = cloner.clone_dict(LBuffs.buff_data.Charge)
		buff["target"] = killer
		buff["source"] = killer
		buff.duration = 1
		var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": killer.get_traits().ThunderMask.Name
		}
		ProcessQueue.add_effect(action)

	if killer.get_traits().has("Bolga"):
		if dying_unit.object_type == "enemy":
			var damage = 100.0
			var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": killer, 
				"damage": damage, 
				"damage_type": "death", 
				"effect_sprite": "Curse", 
				"msg": killer.get_traits().Bolga.Name, 
				"effect_range": 2
			}
			ProcessQueue.add_effect(action)
		
			action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": killer, 
				"damage": damage, 
				"damage_type": "lightning", 
				"effect_sprite": "Zap", 
				"msg": killer.get_traits().Bolga.Name, 
				"effect_range": 2
			}
			ProcessQueue.add_effect(action)
		
			var buff = cloner.clone_dict(LBuffs.buff_data.Charge)
			buff["target"] = killer
			buff["source"] = killer
			buff.duration = 2
			action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": killer.get_traits().Bolga.Name
		}
			ProcessQueue.add_effect(action)
	
	
	if killer.get_traits().has("CosmicFlail"):
		var damage = 0.1 * float(dying_unit.HP_max)
		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": killer, 
				"damage": damage, 
				"damage_type": "astral", 
				"effect_sprite": "Astral", 
				"msg": killer.get_traits().CosmicFlail.Name, 
				"effect_range": killer.get_range_attack(killer.weapon_main)
			}
		ProcessQueue.add_effect(action)
		action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": killer, 
				"damage": damage, 
				"damage_type": "blunt", 
				"effect_sprite": "Bash", 
				"msg": killer.get_traits().CosmicFlail.Name, 
				"effect_range": killer.get_range_attack(killer.weapon_main)
			}
		ProcessQueue.add_effect(action)
	
	if killer.get_traits().has("Azar"):
			var trait = killer.get_traits().Azar
			var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": killer, 
				"damage": 30.0 * trait.Level, 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"effect_range": 2, 
				"msg": killer.get_traits().Azar.Name
			}
			ProcessQueue.add_effect(action)
	
		
	
	if killer.get_traits().has("AbsorbTime"):
			
				var action = {
			"name": "apply_bonus", 
			"origin": killer, 
			"target": killer, 
			"amount": 1.0, 
			"type": "dodge", 
			"msg": killer.get_traits().AbsorbTime.Name, 
			}
				ProcessQueue.add_effect(action)
				
				action = {
			"name": "apply_bonus", 
			"origin": killer, 
			"target": killer, 
			"amount": 5.0, 
			"type": "speed", 
			"msg": killer.get_traits().AbsorbTime.Name, 
			}
				ProcessQueue.add_effect(action)
	
	
	for enemy in Global.Enemies:
		var unit_traits = enemy.get_traits()
		
		if unit_traits.has("Revenge") and dying_unit.object_type == "enemy":
			if enemy.is_dead() == false:
			
				var action = {
			"name": "attack_targets", 
			"attacker": enemy, 
			"number_of_targets": 1, 
			"msg": unit_traits.Revenge.Name
		}
				ProcessQueue.add_effect(action)
		
		if dying_unit.object_type == "enemy":
			
			if unit_traits.has("Protection_Death"):
				var buff = cloner.clone_dict(LBuffs.buff_data.Protection)
				buff["target"] = enemy
				buff["source"] = enemy
				buff.duration = 1
				var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": unit_traits.Protection_Death.Name, 
		}
				ProcessQueue.add_effect(action)
			
			if unit_traits.has("FeastCruel"):
				var action = {
			"name": "heal", 
			"amount": 0.1 * float(enemy.HP_max), 
			"healer_unit": enemy, 
			"healed_unit": enemy, 
			"msg": unit_traits.FeastCruel.Name, 
			}
				ProcessQueue.add_effect(action)
			
				action = {
			"name": "apply_bonus", 
			"origin": enemy, 
			"target": enemy, 
			"amount": 5.0, 
			"type": "damage", 
			"msg": unit_traits.FeastCruel.Name, 
			}
				ProcessQueue.add_effect(action)
				
				action = {
			"name": "apply_bonus", 
			"origin": enemy, 
			"target": enemy, 
			"amount": 100.0, 
			"type": "life", 
			"msg": unit_traits.FeastCruel.Name, 
			}
				ProcessQueue.add_effect(action)
			
			if unit_traits.has("AbsorbTime"):
			
				var action = {
			"name": "apply_bonus", 
			"origin": enemy, 
			"target": enemy, 
			"amount": 1.0, 
			"type": "dodge", 
			"msg": unit_traits.AbsorbTime.Name
			}
				ProcessQueue.add_effect(action)
				
				action = {
			"name": "apply_bonus", 
			"origin": enemy, 
			"target": enemy, 
			"amount": 5.0, 
			"type": "speed", 
			"msg": unit_traits.AbsorbTime.Name
			}
				ProcessQueue.add_effect(action)
	
	
	for enemy in Global.Allies:
		var unit_traits = enemy.get_traits()
		if dying_unit.object_type == "ally":
			
			if unit_traits.has("Revenge"):
				if enemy.is_dead() == false:
			
					var action = {
			"name": "attack_targets", 
			"attacker": enemy, 
			"number_of_targets": 1, 
			"msg": unit_traits.Revenge.Name
		}
					ProcessQueue.add_effect(action)
			
			
			if unit_traits.has("AbsorbTime"):
			
				var action = {
			"name": "apply_bonus", 
			"origin": enemy, 
			"target": enemy, 
			"amount": 1.0, 
			"type": "dodge", 
			"msg": unit_traits.AbsorbTime.Name
			}
				ProcessQueue.add_effect(action)
				
				action = {
			"name": "apply_bonus", 
			"origin": enemy, 
			"target": enemy, 
			"amount": 5.0, 
			"type": "speed", 
			"msg": unit_traits.AbsorbTime.Name
			}
				ProcessQueue.add_effect(action)
			if unit_traits.has("FeastCruel"):
				var action = {
			"name": "heal", 
			"amount": 0.1 * float(enemy.HP_max), 
			"healer_unit": enemy, 
			"healed_unit": enemy, 
			"msg": unit_traits.FeastCruel.Name
			}
				ProcessQueue.add_effect(action)
			
				action = {
			"name": "apply_bonus", 
			"origin": enemy, 
			"target": enemy, 
			"amount": 5.0, 
			"type": "damage", 
			"msg": unit_traits.FeastCruel.Name
			}
				ProcessQueue.add_effect(action)
				
				action = {
			"name": "apply_bonus", 
			"origin": enemy, 
			"target": enemy, 
			"amount": 100.0, 
			"type": "life", 
			"msg": unit_traits.FeastCruel.Name
			}
				ProcessQueue.add_effect(action)



static func death_message(dying_unit, killer):
	var message = ""
	if killer != Global.Player and dying_unit == Global.Player:
		message = killer.type.taunt
		ToolMessageCreator.add_message("[color=#ff3030]", message)
	var name_d = "the " + dying_unit.get_name_color()
	var name_k = "The " + killer.get_name_color()
	var txtcolor = "[color=#ffb030]"
	if killer == Global.Player:
		name_k = ""
		if dying_unit == Global.Player:
			name_d = "자신"
		ToolMessageCreator.add_message(txtcolor, name_k + "(이)가 " + name_d + "을(를) 처치!")
	elif dying_unit == Global.Player:
		txtcolor = "[color=#ff0000]"
		name_d = "당신"
		ToolMessageCreator.add_message(txtcolor, name_k + "(이)가 " + name_d + "을(를) 처치!")
	else:
		txtcolor = "[color=#ffa070]"
		ToolMessageCreator.add_message(txtcolor, name_k + "(이)가 " + name_d + "을(를) 처치!")
