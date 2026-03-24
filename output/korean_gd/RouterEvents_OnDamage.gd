extends Node

class_name event_damage

static func check(dmg, dmg_type, attacker, defender, msg):
	var immune = true
	if defender.is_dead() == false:
		immune = false
		immune = translate.check_immune(defender, defender.get_traits(), attacker, attacker.get_traits())
	
	
		
		
			
				
	
	if immune == false:
		check_go(dmg, dmg_type, attacker, defender, msg)
	else:
		ToolMessageCreator.add_message("[color=#a0a0a0]", defender.get_name_color() + " 면역!")
		

static func check_go(dmg, dmg_type, attacker, defender, msg):
		var msg_string = "..."
		var txcolor = "[color=#df5050]"
		var imp_message = ""
		
		
		
		txcolor = get_txt_color(dmg, dmg_type, defender, attacker)
		
		msg_string = message_damage(dmg, dmg_type, defender, attacker)
		
		var mod_info = {
			"string": [str(int(dmg))]
		}
		
		
		dmg = check_resists(dmg, dmg_type, attacker, defender, false, mod_info)
		
		
		
		
		
		msg_string += message_damage_value(dmg, dmg_type, attacker, defender)
		
		if mod_info.string.size() and ToolSettings.settings_data.log_detail == true:
			var count_message = 0
			for message in mod_info.string:
				if count_message > 0:
					msg += ", " + message
				else:
					msg += " " + message
				count_message += 1
			
		
		if msg != "":
			msg_string += "[color=#707070] <- " + ({"Familiar": "사역마", "Summoned": "소환됨", "Initial": "최초", "Hit": "명중", "공격": "공격", "Being hit": "피격", "enemy Purges you": "적의 정화"}.get(textstrip.strip_bbcode(msg), textstrip.strip_bbcode(msg))) + "[/color]"
		
		if imp_message != "":
			msg_string += "[color=#707070] <- " + imp_message + "[/color]"
		
		ToolMessageCreator.add_message(txcolor, msg_string)
	
		if attacker == Global.Player:
			check_achievements(dmg)
		check_effects(dmg, dmg_type, attacker, defender)
		
		text_popup(dmg, dmg_type, defender)
		add_score(dmg, dmg_type, attacker, defender)
		
		if defender == Global.Player:
			if dmg >= 15.0:
				ToolInvokes.recharge("take 15 damage")
			if attacker.object_type == "enemy":
				ToolInvokes.recharge("damaged by enemy")
		if Global.Player.get_traits().has("Formus"):
			if Global.Allies.has(defender) and Global.Player.is_dead() == false and attacker.object_type == "enemy":
				if calcrange.tile_is_in_range(Global.Player.residence, defender.residence, 1) == true:
					ToolInvokes.recharge("adjacent ally damaged by enemy")
		
		defender.HP -= int(dmg)
		if defender.HP < 1:
			defender.event_killer = attacker
		defender.update()
		attacker.update()

static func check_achievements(dmg):
	var checked_damage = float(dmg)
	if checked_damage >= 1000.0:
		Steam.set_achievement("dmg1k")
	if checked_damage >= 10000.0:
		Steam.set_achievement("dmg10k")
	if checked_damage >= 100000.0:
		Steam.set_achievement("dmg100k")
	if checked_damage >= 1000000.0:
		Steam.set_achievement("dmg1mil")

static func check_effects(dmg, dmg_type, attacker, defender):
	var unit = attacker
	
	var attacker_traits = attacker.get_traits()
	var defender_traits = defender.get_traits()
	
	var attacker_buff_names = attacker.get_buff_names()
	var defender_buff_names = defender.get_buff_names()
	
	if unit.HP < unit.HP_max:
		
		if attacker_traits.has("FireHealing"):
		
			if dmg_type == "fire":
				var action = {
					"name": "heal", 
					"amount": (attacker_traits.FireHealing.base * unit.get_traits().FireHealing.Level), 
					"healer_unit": unit, 
					"healed_unit": unit, 
					"msg": attacker_traits.FireHealing.Name
				}
				
				ProcessQueue.add_effect(action)
		
		if attacker_traits.has("PoisonSkin"):
		
			if dmg_type == "poison":
				var action = {
					"name": "heal", 
					"amount": 2.0 * unit.get_traits().PoisonSkin.Level, 
					"healer_unit": unit, 
					"healed_unit": unit, 
					"msg": attacker_traits.PoisonSkin.Name
				}
				
				ProcessQueue.add_effect(action)
		
		if attacker_traits.has("Bloodcalling"):
			if attacker == defender:
				var trait = attacker_traits.Bloodcalling
				var hit_bonus_h = trait.Level * 2.0
				
				var action = {
			"name": "apply_bonus_random_ally", 
			"origin": attacker, 
			"amount": 1.0 * trait.Level, 
			"type": "speed", 
			"msg": attacker_traits.Bloodcalling.Name
			}
				ProcessQueue.add_effect(action)
				
				for ally in Global.Allies:
				
					if ally.get_name() == "Hemogoblin":
						action = {
			"name": "apply_bonus", 
			"origin": attacker, 
			"target": ally, 
			"amount": hit_bonus_h, 
			"type": "damage", 
			"msg": attacker_traits.Bloodcalling.Name
			}
						ProcessQueue.add_effect(action)
		
		
		
		if attacker_traits.has("Bloodbath"):
			var trait = attacker_traits.Bloodbath
			if dmg_type == "blood":
				if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1):
					var action = {
					"name": "heal", 
					"amount": trait.base * trait.Level, 
					"healer_unit": unit, 
					"healed_unit": unit, 
					"msg": attacker_traits.Bloodbath.Name
				}
					
					ProcessQueue.add_effect(action)
		

		

		

		if attacker_traits.has("HealingPoison"):
		
			if dmg_type == "poison":
				var action = {
					"name": "heal", 
					"amount": 10.0, 
					"healer_unit": unit, 
					"healed_unit": unit, 
					"msg": attacker_traits.HealingPoison.Name
				}
				
				ProcessQueue.add_effect(action)
		
		if attacker_traits.has("HealingFlame"):
		
			if dmg_type == "fire":
				var action = {
					"name": "heal", 
					"amount": 10.0, 
					"healer_unit": unit, 
					"healed_unit": unit, 
					"msg": attacker_traits.HealingFlame.Name
				}
				
				ProcessQueue.add_effect(action)
	
	
	if defender_traits.has("Astrostoicism") and attacker.object_type == "enemy":
		var trait = defender_traits.Astrostoicism
		var action = {
				"name": "teleport", 
				"unit": attacker, 
				"tile_target": calcrange.get_random_open_tile(), 
				"msg": defender_traits.Astrostoicism.Name
			}
		ProcessQueue.add_effect(action)
		var buff = cloner.clone_dict(LBuffs.buff_data.Poise)
		buff["target"] = defender
		buff["source"] = defender
		buff.duration = 3 * trait.Level
		action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.Astrostoicism.Name
			}
		ProcessQueue.add_effect(action)
	
	
	if defender.get_traits().has("Struggler"):
		if attacker.object_type == "enemy":
			var action = {
			"name": "attack_targets", 
			"attacker": defender, 
			"number_of_targets": 1, 
			"msg": defender_traits.Struggler.Name
		}
	
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Ormjarl"):
		if dmg_type == "lightning":
			for ally in Global.Allies:
				if ally != Global.Player:
					var action = {
					"name": "heal", 
					"amount": 20.0, 
					"healer_unit": unit, 
					"healed_unit": ally, 
					"msg": attacker_traits.Ormjarl.Name
				}
					ProcessQueue.add_effect(action)
				
	
	if Global.Allies.has(defender) and Global.Enemies.has(attacker):
		if Global.Player.get_traits().has("AmplifyPain"):
			
			var action = {
					"name": "magic_damage_target", 
					"target": Global.Player, 
					"caster": Global.Player, 
					"damage": 5.0, 
					"damage_type": "blood", 
					"effect_sprite": "Blood", 
					"msg": Global.Player.get_traits().AmplifyPain.Name
				}
			ProcessQueue.add_effect(action)
			
			action = {
					"name": "magic_damage_target", 
					"target": Global.Player, 
					"caster": Global.Player, 
					"damage": 5.0, 
					"damage_type": "psychic", 
					"effect_sprite": "Psychic", 
					"msg": Global.Player.get_traits().AmplifyPain.Name
				}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("DreadSash"):
		if dmg_type == "slash" or dmg_type == "blunt" or dmg_type == "pierce":

			var action = {
			"name": "magic_damage_targets_range", 
			"caster": attacker, 
			"damage": float(dmg) * 0.25, 
			"damage_type": "death", 
			"effect_sprite": "Curse", 
			"effect_range": 1, 
			"number_of_targets": 10, 
			"msg": attacker_traits.DreadSash.Name
				}
			ProcessQueue.add_effect(action)
	
	
	if defender_traits.has("AmplifyPain"):
		
		if defender == attacker:
			var trait = defender_traits.AmplifyPain
			var action = {
			"name": "magic_damage_targets_range", 
			"caster": defender, 
			"damage": 20.0 * trait.Level, 
			"damage_type": "psychic", 
			"effect_sprite": "Psychic", 
			"effect_range": 2, 
			"number_of_targets": 20, 
			"msg": defender_traits.AmplifyPain.Name
				}
			ProcessQueue.add_effect(action)
			
			var buff = cloner.clone_dict(LBuffs.buff_data.Repulsion)
			buff["target"] = defender
			buff["source"] = defender
			buff.duration = trait.Level
			var action2 = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.AmplifyPain.Name
			}
			ProcessQueue.add_effect(action2)
	
	if defender_traits.has("VariGore") == true:
		if Global.Allies.has(attacker):
			var action = {
					"name": "summon", 
					"alliance": "enemy", 
					"type": LEnemies.enemy_data.gore_nymph, 
					"summoner": defender, 
					"msg": defender_traits.VariGore.Name
				}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("VariOkopod") == true:
		if Global.Allies.has(attacker):
			var action = {
					"name": "summon", 
					"alliance": "enemy", 
					"type": LEnemies.enemy_data.okopod, 
					"summoner": defender, 
					"msg": defender_traits.VariOkopod.Name
				}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("VariOkokorpus") == true:
		if Global.Allies.has(attacker):
			var action = {
					"name": "summon", 
					"alliance": "enemy", 
					"type": LEnemies.enemy_data.okokorpus, 
					"summoner": defender, 
					"msg": defender_traits.VariOkokorpus.Name
				}
			ProcessQueue.add_effect(action)
	
	
	if defender_traits.has("VariOkopodBeast") == true:
		if Global.Allies.has(attacker):
			var action = {
					"name": "summon", 
					"alliance": "enemy", 
					"type": LEnemies.enemy_data.okopod, 
					"summoner": defender, 
					"msg": defender_traits.VariOkopodBeast.Name
				}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("VariLapsi") == true:
		if Global.Allies.has(attacker):
			for n in 2:
				var action = {
					"name": "summon", 
					"alliance": "enemy", 
					"type": LEnemies.enemy_data.lapsi, 
					"summoner": defender, 
					"msg": defender_traits.VariLapsi.Name
				}
				ProcessQueue.add_effect(action)
	
	if defender_traits.has("VariTaggla") == true:
		if Global.Allies.has(attacker):
			var action = {
					"name": "summon", 
					"alliance": "enemy", 
					"type": LEnemies.enemy_data.taggla, 
					"summoner": defender, 
					"msg": defender_traits.VariTaggla.Name
				}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("VariAstropede") == true:
		if Global.Allies.has(attacker):
			var action = {
					"name": "summon", 
					"alliance": "enemy", 
					"type": LEnemies.enemy_data.astropede, 
					"summoner": defender, 
					"msg": defender_traits.VariAstropede.Name
				}
			ProcessQueue.add_effect(action)
	
	
	if defender_traits.has("MasterEntangle"):
				var trait = defender_traits.MasterEntangle
				var buff = cloner.clone_dict(LBuffs.buff_data.Entangle)
				buff["target"] = defender
				buff["source"] = defender
				buff.duration = trait.Level
				var action = {
				"name": "buff_tiles_in_range", 
				"caster": defender, 
				"effect_sprite": "Entangle", 
				"effect_range": 1, 
				"buff": buff, 
				"alliance": calcrange.get_enemy_alliance(defender), 
				"msg": defender_traits.MasterEntangle.Name
			}
				ProcessQueue.add_effect(action)
				
				buff["target"] = defender
				buff["source"] = defender
				buff.duration = trait.Level
				var action2 = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.MasterEntangle.Name
			}
				ProcessQueue.add_effect(action2)
	
	
		
	if attacker_traits.has("Chamakana"):
		var trait = attacker.get_traits().Chamakana
		var hit = 100
		var weapon = attacker.weapon_main
		if Global.Enemies.has(defender) == true:
			if dmg_type == "lightning" or dmg_type == "slash" or dmg_type == "pierce":
				if float(defender.HP) / float(defender.HP_max) >= 1.0:
					for n in trait.Level:
						var msg = attacker_traits.Chamakana.Name
						ToolMagicMaker.add_hit_event(defender, attacker, hit, weapon, msg)
	
	
	if attacker_traits.has("chest_red") == true:
		if dmg_type == "slash" or dmg_type == "blunt" or dmg_type == "pierce" or dmg_type == "blood":
			
				for buff in attacker.Buffs:
					if buff.name == "Bleed":
						var action = {
						"name": "remove_buff", 
						"target": attacker, 
						"buff": buff, 
						"msg": attacker_traits.chest_red.Name
						}
						ProcessQueue.add_effect(action)
			
				var action = {
					"name": "heal", 
					"amount": 5.0, 
					"healer_unit": unit, 
					"healed_unit": unit, 
					"msg": attacker_traits.chest_red.Name
				}
				ProcessQueue.add_effect(action)
				
	
	if attacker_traits.has("ArcingHeat"):
		
		if dmg_type == "fire" or dmg_type == "lightning":
			var dmg_new = dmg / 3
			if dmg_new > 100:
				var action = {
					"name": "magic_damage_targets_range", 
					"caster": attacker, 
					"damage": dmg_new, 
					"damage_type": "lightning", 
					"effect_sprite": "Zap", 
					"number_of_targets": 4, 
					"effect_range": 20, 
					"msg": attacker_traits.ArcingHeat.Name
				}
				ProcessQueue.add_effect(action)
	
	
	if attacker_traits.has("Mindbreaker"):
		if attacker.get_total_weight() <= attacker.get_total_STR():
			if dmg_type == "psychic":
				var action = {
					"name": "magic_damage_targets_range", 
					"caster": attacker, 
					"damage": dmg * 2.0, 
					"damage_type": "blood", 
					"effect_sprite": "Blood", 
					"number_of_targets": 1, 
					"effect_range": 1, 
					"msg": attacker_traits.Mindbreaker.Name
				}
				ProcessQueue.add_effect(action)
	if attacker_traits.has("RukfeatherSkirt"):
		if dmg_type == "pierce":
			var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": attacker, 
				"damage": 3.0 * attacker.get_SPEED(), 
				"damage_type": "blunt", 
				"effect_sprite": "Blunt", 
				"effect_range": 1, 
				"msg": attacker_traits.RukfeatherSkirt.Name
			}
			ProcessQueue.add_effect(action)
	
	
	
	if attacker_traits.has("Dahan") and attacker.get_hands_used() == 1:
		
		if dmg_type == "fire":
			var action = {
					"name": "magic_damage_targets_range", 
					"caster": attacker, 
					"damage": dmg * 2.0, 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"number_of_targets": 1, 
					"effect_range": 1, 
					"msg": attacker_traits.Dahan.Name
				}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Skera"):
		if defender != attacker:
			if dmg_type == "slash" or dmg_type == "pierce":
				var action = {
					"name": "magic_damage_tiles_in_path", 
					"target": defender, 
					"caster": attacker, 
					"damage": 50.0 * attacker.get_traits().Skera.Level, 
					"damage_type": "lightning", 
					"effect_sprite": "Zap", 
					"msg": attacker_traits.Skera.Name
				}
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Isaz"):
		if dmg_type == "blunt" or dmg_type == "pierce":
			var action = {
				"name": "magic_damage_targets_range", 
				"caster": attacker, 
				"damage": 100.0 * attacker.get_traits().Isaz.Level, 
				"damage_type": "ice", 
				"effect_sprite": "Ice", 
				"effect_range": 2, 
				"number_of_targets": 1, 
				"msg": attacker_traits.Isaz.Name
			}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Shamsar"):
		
		if dmg_type == "slash" or dmg_type == "blunt":
			var action = {
			"name": "magic_damage_targets_range", 
			"caster": attacker, 
			"damage": 150.0 * attacker.get_traits().Shamsar.Level, 
			"damage_type": "fire", 
			"effect_sprite": "Flame", 
			"effect_range": 1, 
			"number_of_targets": 2, 
			"msg": attacker_traits.Shamsar.Name
				}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Immolate"):
		
		if dmg_type == "slash":
			var dmgnew = dmg * 0.5
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": attacker_traits.Immolate.Name
				}
			
			ProcessQueue.add_effect(action)
	
	
	if attacker_traits.has("EmeraldEye"):
		if dmg_type == "poison":
				var buff = cloner.clone_dict(LBuffs.buff_data.Blind)
				buff["target"] = defender
				buff["source"] = attacker
				buff.duration = 2
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.EmeraldEye.Name
				}
				
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Samsi"):
		
		if dmg_type == "psychic":
			var dmgnew = attacker.get_total_DEX() * 10.0
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "lightning", 
					"effect_sprite": "ZapLight", 
					"msg": attacker_traits.Samsi.Name
				}
			
			ProcessQueue.add_effect(action)
	
		if dmg_type == "lightning":
				var buff = cloner.clone_dict(LBuffs.buff_data.Blind)
				buff["target"] = defender
				buff["source"] = attacker
				buff.duration = 1
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Samsi.Name
				}
				
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("PiercingLightning"):
		
		if dmg_type == "pierce":
			var dmgnew = dmg * 0.5
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "lightning", 
					"effect_sprite": "Zap", 
					"msg": attacker_traits.PiercingLightning.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Mindcrush"):
		
		if dmg_type == "blunt":
			var dmgnew = dmg * 0.5
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "psychic", 
					"effect_sprite": "Psychic", 
					"msg": attacker_traits.Mindcrush.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("AstraBlade"):
		
		if dmg_type == "slash":
			var dmgnew = dmg * 0.5
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"msg": attacker_traits.AstraBlade.Name
				}
			
			ProcessQueue.add_effect(action)
	
	
		
		
			
				
				
				
			
				
				
				
				
				
				
				
			
			
				
			
				
	
	if attacker_traits.has("Auzom"):
		
		if dmg_type == "astral":
			var dmgnew = dmg * 0.25
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "lightning", 
					"effect_sprite": "Zap", 
					"msg": attacker_traits.Auzom.Name
				}
			
			ProcessQueue.add_effect(action)
	
	
	if attacker_traits.has("arcanecurse"):
		
		if dmg_type == "death":
			var dmgnew = dmg * 0.25
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"msg": attacker_traits.arcanecurse.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("deathwound"):
		
		if dmg_type == "blood":
			var dmgnew = dmg * 0.25
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "death", 
					"effect_sprite": "Curse", 
					"msg": attacker_traits.deathwound.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("CrystalHand"):
		
		if dmg_type == "ice":
			var dmgnew = 3.0 * attacker.get_total_WIL()
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"msg": attacker_traits.CrystalHand.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("numbingcold"):
		
		if dmg_type == "ice":
			var dmgnew = dmg * 0.25
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "psychic", 
					"effect_sprite": "Psychic", 
					"msg": attacker_traits.numbingcold.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("sepsis"):
		
		if dmg_type == "poison":
			var dmgnew = dmg * 0.25
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "death", 
					"effect_sprite": "Curse", 
					"msg": attacker_traits.sepsis.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("bloodvenom"):
		
		if dmg_type == "poison":
			var dmgnew = dmg * 0.25
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "blood", 
					"effect_sprite": "Blood", 
					"msg": attacker_traits.bloodvenom.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("ChillingCurse"):
		
		if dmg_type == "death":
			var dmgnew = dmg * 0.25
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "ice", 
					"effect_sprite": "Ice", 
					"msg": attacker_traits.ChillingCurse.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("PiercingVenom"):
		
		if dmg_type == "pierce":
			var dmgnew = dmg * 0.5
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "poison", 
					"effect_sprite": "PoisonHit", 
					"msg": attacker_traits.PiercingVenom.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("IsaRagna"):
		
		if dmg_type == "ice":
			var dmgnew = dmg * 0.25
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": attacker_traits.IsaRagna.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Rabata"):
		
		if dmg_type == "lightning":
			var dmgnew = dmg * 0.25
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": attacker_traits.Rabata.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Mindblade"):
		
		if dmg_type == "psychic":
			var dmgnew = dmg * 0.25
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "blood", 
					"effect_sprite": "Blood", 
					"msg": attacker_traits.Mindblade.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Sitanna"):
		
		if dmg_type == "fire":
			var dmgnew = dmg * 0.25
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"msg": attacker_traits.Sitanna.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Tikaarak"):
		
		if dmg_type == "blunt":
			var dmgnew = dmg * 0.5
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "ice", 
					"effect_sprite": "Ice", 
					"msg": attacker_traits.Tikaarak.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Rupture"):
		
		if dmg_type == "slash":
			var dmgnew = dmg * 0.5
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "blood", 
					"effect_sprite": "Blood", 
					"msg": attacker_traits.Rupture.Name
				}
		
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("BurningPoison"):
		
		if dmg_type == "poison":
			var action = {
					"name": "magic_damage_tiles_in_path", 
					"target": defender, 
					"caster": attacker, 
					"damage": 50.0, 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": attacker_traits.BurningPoison.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("VilePoison"):
		
		if dmg_type == "poison":
			var action = {
				"name": "magic_damage_tiles_in_path_to_targets_in_range", 
				"caster": attacker, 
				"damage": 50.0, 
				"damage_type": "death", 
				"effect_sprite": "Curse", 
				"number_of_targets": 1, 
				"effect_range": 3, 
				"enemies": null, 
				"msg": attacker_traits.VilePoison.Name
				
				}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("TaaronKa"):
		if dmg_type == "pierce":
			var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": attacker, 
				"damage": 30.0, 
				"damage_type": "astral", 
				"effect_sprite": "Astral", 
				"effect_range": 2, 
				"msg": attacker_traits.TaaronKa.Name
			}
		
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("Bloodbath"):
		var trait = defender_traits.Bloodbath
		if dmg_type == "pierce" or dmg_type == "blunt" or dmg_type == "slash":
			var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": defender, 
				"damage": 75.0 * trait.Level, 
				"damage_type": "blood", 
				"effect_sprite": "Blood", 
				"effect_range": 1, 
				"msg": defender_traits.Bloodbath.Name
			}
		
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("HeavyCleave"):
		
		if dmg_type == "slash":
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 5.0 * attacker.get_total_weight(), 
					"damage_type": "blunt", 
					"effect_sprite": "Blunt", 
					"msg": attacker_traits.HeavyCleave.Name
					
				}
		
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("BloodVengeance"):
		
		if attacker != defender:
			if attacker.get_traits().has("BloodVengeance") == false:
				if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == false:
				
					var buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
					buff["target"] = attacker
					buff["source"] = defender
					buff.duration = defender.get_total_DEX()
					var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.BloodVengeance.Name
				}
				
					ProcessQueue.add_effect(action)
	
	if defender_traits.has("MasterBleed"):
		var trait = defender_traits.MasterBleed
		if defender_buff_names.has("Bleed") == true:
			if Global.Enemies.has(attacker) == true:
				var multi = 1
				for buff in defender.Buffs:
					if buff.name == "Bleed":
						multi += buff.duration
				var action = {
				"name": "magic_damage_tiles_in_path", 
				"target": attacker, 
				"caster": defender, 
				"damage": float(5.0 * trait.Level * multi), 
				"damage_type": "blood", 
				"effect_sprite": "Blood", 
				"msg": defender_traits.MasterBleed.Name
			}
			
				ProcessQueue.add_effect(action)
	
	if defender_traits.has("helm_red"):
		if attacker == defender:
			var action = {
				"name": "magic_damage_targets_range", 
				"caster": defender, 
				"damage": defender.get_total_weapon_size() * 50.0, 
				"damage_type": "blood", 
				"effect_sprite": "Blood", 
				"effect_range": 1, 
				"number_of_targets": 3, 
				"msg": defender_traits.helm_red.Name
			}
			
			ProcessQueue.add_effect(action)
	
	
	
	if attacker_traits.has("Wormform") and dmg_type == "fire":
		if dmg > 100:
			var trait = attacker_traits.Wormform
			var buff = cloner.clone_dict(LBuffs.buff_data.Newtform)
			buff["target"] = attacker
			buff["source"] = attacker
			buff.duration = trait.Level * 2
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Wormform.Name
			}
		
			ProcessQueue.add_effect(action)
	
	
	if defender_traits.has("Koszmar"):
			var action = {
				"name": "magic_damage_targets_range", 
				"caster": defender, 
				"damage": dmg, 
				"damage_type": "psychic", 
				"effect_sprite": "Psychic", 
				"effect_range": 99, 
				"number_of_targets": 1, 
				"msg": defender_traits.Koszmar.Name
			}
			
			ProcessQueue.add_effect(action)
			
			if int(defender.get_total_weight()) <= int(defender.get_total_STR()):
				for n in 2:
					ProcessQueue.add_effect(cloner.clone_dict(action))
	
	if attacker_traits.has("robe_red"):
		if attacker == defender:
				var buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
				buff["target"] = attacker
				buff["source"] = attacker
				buff.duration = 3
				var action = {
				"name": "buff_targets_in_range", 
				"caster": attacker, 
				"effect_sprite": "Bleed", 
				"number_of_targets": 1, 
				"effect_range": 3, 
				"buff": buff, 
				"is_allied": false, 
				"msg": attacker_traits.robe_red.Name
				}
				
				ProcessQueue.add_effect(action)
		
		elif Global.Allies.has(defender):
			var action = {
				"name": "magic_damage_targets_range", 
				"caster": attacker, 
				"damage": 50.0, 
				"damage_type": "blood", 
				"effect_sprite": "Blood", 
				"effect_range": 3, 
				"number_of_targets": 1, 
				"msg": attacker_traits.robe_red.Name
			}
			
			ProcessQueue.add_effect(action)
			
			
	if attacker_traits.has("Exultite"):
		if calcrange.get_enemy_alliance(attacker) == calcrange.get_enemy_alliance(defender):
			if attacker != defender:
				var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
				buff["target"] = attacker
				buff["source"] = attacker
				buff["duration"] = 2
				var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": attacker_traits.Exultite.Name
		}
			
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("PainCleric"):
		if calcrange.get_enemy_alliance(attacker) == calcrange.get_enemy_alliance(defender):
			if attacker != defender:
				var action = {
				"name": "magic_damage_target_closest", 
				"caster": unit, 
				"damage": 100.0, 
				"damage_type": "death", 
				"effect_sprite": "Curse", 
				"msg": attacker_traits.PainCleric.Name
				}
			
				ProcessQueue.add_effect(action)
				
				var buff = cloner.clone_dict(LBuffs.buff_data.Doom)
				buff["target"] = attacker
				buff["source"] = attacker
				buff.duration = 5
				action = {
				"name": "buff_targets_in_range", 
				"caster": attacker, 
				"effect_sprite": "Doom", 
				"number_of_targets": 1, 
				"effect_range": 99, 
				"buff": buff, 
				"is_allied": false, 
				"msg": attacker_traits.PainCleric.Name
				}
				
				ProcessQueue.add_effect(action)
	
	
	if defender_traits.has("BloodRetort"):
		
			var trait = defender_traits.BloodRetort
			var action = {
			"name": "magic_damage_tiles_in_path_to_targets_in_range", 
			"caster": defender, 
			"damage": 50.0 * trait.Level, 
			"damage_type": "blood", 
			"effect_sprite": "Blood", 
			"number_of_targets": 1, 
			"effect_range": 4, 
			"enemies": null, 
			"msg": defender_traits.BloodRetort.Name
				}
		
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("Brud"):
					var buff = cloner.clone_dict(LBuffs.buff_data.Doom)
					buff["target"] = defender
					buff["source"] = defender
					buff.duration = 5
					var action = {
				"name": "buff_targets_in_range", 
				"caster": defender, 
				"effect_sprite": "Doom", 
				"number_of_targets": 1, 
				"effect_range": 5, 
				"buff": buff, 
				"is_allied": false, 
				"msg": defender_traits.Brud.Name
				}
					
					ProcessQueue.add_effect(action)
	
	if defender_traits.has("Acid_Sash"):
					var buff = cloner.clone_dict(LBuffs.buff_data.Corrosion)
					buff["target"] = defender
					buff["source"] = defender
					buff.duration = 2
					var action = {
				"name": "buff_targets_in_range", 
				"caster": defender, 
				"effect_sprite": "Doom", 
				"number_of_targets": 8, 
				"effect_range": 1, 
				"buff": buff, 
				"is_allied": false, 
				"msg": defender_traits.Acid_Sash.Name
				}
					
					ProcessQueue.add_effect(action)
	
	if defender_traits.has("helm_dark"):
		
					var buff = cloner.clone_dict(LBuffs.buff_data.Doom)
					buff["target"] = defender
					buff["source"] = defender
					buff.duration = 5
					var action = {
				"name": "buff_targets_in_range", 
				"caster": defender, 
				"effect_sprite": "Doom", 
				"number_of_targets": 1, 
				"effect_range": 2, 
				"buff": buff, 
				"is_allied": false, 
				"msg": defender_traits.helm_dark.Name
				}
					
					ProcessQueue.add_effect(action)
	
	if defender_traits.has("Takhal"):
		
					var buff = cloner.clone_dict(LBuffs.buff_data.Plague)
					buff["target"] = defender
					buff["source"] = defender
					buff.duration = 3
					var action = {
				"name": "buff_targets_in_range", 
				"caster": defender, 
				"effect_sprite": "Plague", 
				"number_of_targets": 1, 
				"effect_range": 99, 
				"buff": buff, 
				"is_allied": false, 
				"msg": defender_traits.Takhal.Name
				}
					
					ProcessQueue.add_effect(action)
	
	if attacker_traits.has("RobeLight"):
		if dmg_type == "fire" or dmg_type == "astral":
					var buff = cloner.clone_dict(LBuffs.buff_data.Blind)
					buff["target"] = attacker
					buff["source"] = attacker
					buff.duration = 5
					var action = {
				"name": "buff_targets_in_range", 
				"caster": attacker, 
				"effect_sprite": "Blind", 
				"number_of_targets": 2, 
				"effect_range": 3, 
				"buff": buff, 
				"is_allied": false, 
				"msg": attacker_traits.RobeLight.Name
				}
					
					ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Gehikul"):
		if dmg_type == "slash":
			var dmgnew = dmg * 0.5
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "death", 
					"effect_sprite": "Curse", 
					"msg": attacker_traits.Gehikul.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("IllManica") == true:
		if dmg_type == "poison":
			var buff = cloner.clone_dict(LBuffs.buff_data.Meditate)
			buff["target"] = attacker
			buff["source"] = attacker
			buff.duration = 2
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.IllManica.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Pyromancy") == true:
		if dmg_type == "fire":
			var buff = cloner.clone_dict(LBuffs.buff_data.Scorch)
			buff["target"] = defender
			buff["source"] = attacker
			buff.duration = attacker_traits.Pyromancy.Level * 3
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Pyromancy.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Stormbringer") == true:
		if dmg_type == "ice" or dmg_type == "lightning":
			var buff = cloner.clone_dict(LBuffs.buff_data.Charge)
			buff["target"] = attacker
			buff["source"] = attacker
			buff.duration = 1
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Stormbringer.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Rabbah") == true:
		if dmg_type == "death":
			var buff = cloner.clone_dict(LBuffs.buff_data.Doom)
			buff["target"] = defender
			buff["source"] = attacker
			buff.duration = attacker_traits.Rabbah.Level
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Rabbah.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("VoidMage") == true:
		if dmg_type == "death":
				var buff = cloner.clone_dict(LBuffs.buff_data.Freeze)
				buff["target"] = attacker
				buff["source"] = attacker
				buff.duration = 2
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.VoidMage.Name
				}
				
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Vengati") == true:
		if dmg_type == "psychic":
				var buff = cloner.clone_dict(LBuffs.buff_data.Sickness)
				buff["target"] = defender
				buff["source"] = attacker
				buff.duration = 1
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Vengati.Name
				}
				
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("MalaYuga") == true:
		if dmg_type == "slash" or dmg_type == "blunt" or dmg_type == "pierce":
			
				var buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
				buff["target"] = defender
				buff["source"] = attacker
				buff.duration = 2
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.MalaYuga.Name
				}
				
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Uspori") == true and defender.object_type == "enemy":
		if dmg_type == "poison" or dmg_type == "ice":
			if calcrange.tile_is_in_range(attacker.residence, defender.residence, 2):
				var buff = cloner.clone_dict(LBuffs.buff_data.Paralysis)
				buff["target"] = defender
				buff["source"] = attacker
				buff.duration = 1
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Uspori.Name
				}
				
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Envenom") == true:
		if dmg_type == "slash" or dmg_type == "blunt" or dmg_type == "pierce":
			
				var buff = cloner.clone_dict(LBuffs.buff_data.Sickness)
				buff["target"] = defender
				buff["source"] = attacker
				buff.duration = 2
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Envenom.Name
				}
				
				ProcessQueue.add_effect(action)
	
	
	if attacker_traits.has("BloodDrinker"):
		if dmg_type == "blood":
			
				var action = {
					"name": "heal", 
					"amount": 0.1 * float(dmg), 
					"healer_unit": unit, 
					"healed_unit": unit, 
					"msg": attacker_traits.BloodDrinker.Name
				}
				
				ProcessQueue.add_effect(action)
			
	
	if attacker_traits.has("Berserker"):
		if dmg_type == "blood" or dmg_type == "death" or dmg_type == "ice":
			var works = false
			
			if attacker == defender:
				works = true
			elif calcrange.get_range_between_tiles(attacker.residence, defender.residence) <= 1:
				works = true
			
			if works == true:
				var buff = cloner.clone_dict(LBuffs.buff_data.Berserk)
				buff["target"] = attacker
				buff["source"] = attacker
				buff.duration = 2
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Berserker.Name
				}
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Gehivah"):
		if dmg_type == "pierce" or dmg_type == "slash" or dmg_type == "blunt":
			
				var buff = cloner.clone_dict(LBuffs.buff_data.Doom)
				buff["target"] = defender
				buff["source"] = attacker
				buff.duration = 2
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Gehivah.Name
				}
				
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("SkullHelm"):
		if dmg_type == "death" or dmg_type == "lightning" or dmg_type == "psychic":
			
				var buff = cloner.clone_dict(LBuffs.buff_data.Doom)
				buff["target"] = defender
				buff["source"] = attacker
				buff.duration = 1
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.SkullHelm.Name
				}
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Damunja"):
		if dmg_type == "lightning":
			
				var buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
				buff["target"] = defender
				buff["source"] = attacker
				buff.duration = 5
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Damunja.Name
				}
				
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Feith_Shillelagh"):
		if dmg_type == "pierce" or dmg_type == "slash" or dmg_type == "blunt":

				var buff = cloner.clone_dict(LBuffs.buff_data.Entangle)
				buff["target"] = defender
				buff["source"] = attacker
				buff.duration = 2
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Feith_Shillelagh.Name
				}
			
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Sioc_Shillelagh"):
		if dmg_type == "pierce" or dmg_type == "slash" or dmg_type == "blunt":

				var buff = cloner.clone_dict(LBuffs.buff_data.Freeze)
				buff["target"] = defender
				buff["source"] = attacker
				buff.duration = 2
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Sioc_Shillelagh.Name
				}
			
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Sahasi"):
		if dmg_type == "astral" or dmg_type == "pierce" or dmg_type == "slash" or dmg_type == "blunt":
			var buff = cloner.clone_dict(LBuffs.buff_data.Poise)
			buff["target"] = attacker
			buff["source"] = attacker
			buff.duration = 2
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Sahasi.Name
				}
			
			ProcessQueue.add_effect(action)
	
	
	if attacker_traits.has("SigilFire") and dmg_type == "fire":
		
			var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
			buff["target"] = attacker
			buff["source"] = attacker
			buff.duration = 2
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.SigilFire.Name
				}
			
			ProcessQueue.add_effect(action)
	

	
	if attacker_traits.has("SigilLightning") and dmg_type == "lightning":
		
			var buff = cloner.clone_dict(LBuffs.buff_data.Charge)
			buff["target"] = attacker
			buff["source"] = attacker
			buff.duration = 1
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.SigilLightning.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Alizeh"):
		if dmg_type == "lightning" or dmg_type == "astral":
			var buff = cloner.clone_dict(LBuffs.buff_data.Charge)
			buff["target"] = attacker
			buff["source"] = attacker
			buff.duration = 1
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Alizeh.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Psychonaut") == true and dmg_type == "psychic":
		if calcrange.get_range_between_tiles(attacker.residence, defender.residence) <= 3:
			var action = {
				"name": "teleport", 
				"unit": attacker, 
				"tile_target": calcrange.get_random_open_tile(), 
				"msg": attacker_traits.Psychonaut.Name
			}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("SigilPsychic") and dmg_type == "psychic":
			var buff = cloner.clone_dict(LBuffs.buff_data.Repulsion)
			buff["target"] = attacker
			buff["source"] = attacker
			buff.duration = 2
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.SigilPsychic.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("BloodMage") and defender == attacker:
		
				var buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
				buff["target"] = attacker
				buff["source"] = attacker
				buff.duration = 6
				var action = {
				"name": "buff_tiles_in_range", 
				"caster": attacker, 
				"effect_sprite": "Bleed", 
				"effect_range": 3, 
				"buff": buff, 
				"alliance": calcrange.get_enemy_alliance(unit), 
				"msg": attacker_traits.BloodMage.Name
			}
				
				ProcessQueue.add_effect(action)
			
	
	if attacker_traits.has("SigilAstral") and dmg_type == "astral":
		if calcrange.get_range_between_tiles(attacker.residence, defender.residence) > 1:
			var action = {
			"name": "magic_damage_targets_range", 
			"caster": attacker, 
			"damage": float(dmg) * 0.25, 
			"damage_type": "astral", 
			"effect_sprite": "Astral", 
			"number_of_targets": 1, 
			"effect_range": calcrange.get_range_between_tiles(attacker.residence, defender.residence) - 1, 
			"msg": attacker_traits.SigilAstral.Name
				}
			
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Pyromaniac") and dmg_type == "fire":

			var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
			buff["target"] = attacker
			buff["source"] = attacker
			buff.duration = 1
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Pyromaniac.Name
				}
			
			ProcessQueue.add_effect(action)
	
	
	
	
	if attacker_traits.has("robe_earth"):
		if dmg_type == "slash" or dmg_type == "pierce" or dmg_type == "blunt":
			
				var buff = cloner.clone_dict(LBuffs.buff_data.Poise)
				buff["target"] = attacker
				buff["source"] = attacker
				buff.duration = 2
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.robe_earth.Name
				}
				
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Psychonaut"):
		if dmg_type == "astral":
			for buff in attacker.Buffs:
					if buff.name == "Stasis":
						var action = {
						"name": "remove_buff", 
						"target": attacker, 
						"buff": buff, 
						"msg": attacker_traits.Psychonaut.Name
						}
						ProcessQueue.add_effect(action)
	
	if attacker_traits.has("robe_astral"):
		
			if dmg_type == "psychic" or dmg_type == "astral":
				for buff in attacker.Buffs:
					if buff.name == "Stasis":
						var action = {
						"name": "remove_buff", 
						"target": attacker, 
						"buff": buff, 
						"msg": attacker_traits.robe_astral.Name
						}
						
						ProcessQueue.add_effect(action)
			
				var buff = cloner.clone_dict(LBuffs.buff_data.Repulsion)
				buff["target"] = attacker
				buff["source"] = attacker
				buff.duration = 1
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.robe_astral.Name
				}
			
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("robe_swamp"):
		
			if dmg_type == "death" or dmg_type == "poison":
				for buff in attacker.Buffs:
					if buff.name == "Doom" or buff.name == "Sickness":
						var action = {
						"name": "remove_buff", 
						"target": attacker, 
						"buff": buff, 
						"msg": attacker_traits.robe_swamp.Name
						}
						
						ProcessQueue.add_effect(action)
				
				var buff = cloner.clone_dict(LBuffs.buff_data.Evasion)
				buff["target"] = attacker
				buff["source"] = attacker
				buff.duration = 1
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.robe_swamp.Name
				}
			
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("robe_fire"):
		
			if dmg_type == "fire" or dmg_type == "lightning":
				
				for buff in attacker.Buffs:
					if buff.name == "Freeze" or buff.name == "Scorch":
						var action = {
						"name": "remove_buff", 
						"target": attacker, 
						"buff": buff, 
						"msg": attacker_traits.robe_fire.Name
						}
						
						ProcessQueue.add_effect(action)
	
				var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
				buff["target"] = attacker
				buff["source"] = attacker
				buff.duration = 1
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.robe_fire.Name
				}
			
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Gothi") and dmg_type == "lightning":
			var buff = cloner.clone_dict(LBuffs.buff_data.Evasion)
			buff["target"] = attacker
			buff["source"] = attacker
			buff.duration = 1
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Gothi.Name
				}
			
			ProcessQueue.add_effect(action)
	
	
	
	
	if defender_traits.has("Protection_Harm"):
		if dmg >= 0.15 * float(defender.HP_max):
				var buff = cloner.clone_dict(LBuffs.buff_data.Protection)
				buff["target"] = defender
				buff["source"] = defender
				buff.duration = 1
				var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": defender_traits.Protection_Harm.Name
		}
				ProcessQueue.add_effect(action)
	
	if defender_buff_names.has("Protection"):
		for buff in defender.Buffs:
			if buff.name == "Protection" and attacker != defender:
				if Global.rng.randi_range(1, 10) <= 2:
					var action = {
					"name": "remove_buff", 
					"target": defender, 
					"buff": buff, 
					"msg": "Damaged"
		}
					ProcessQueue.add_effect(action)
					if defender == Global.Player:
						ToolMessageCreator.add_message("[color=#f09090]", "보호막이 파괴되었다!")
					else:
						ToolMessageCreator.add_message("[color=#c07070]", defender.get_name_color() + " 보호막이 파괴됨!")
	
	
	if defender_traits.has("MaskApostle"):
		if defender == attacker:
			var action = {
					"name": "magic_damage_targets_range", 
					"caster": defender, 
					"damage": 100.0, 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"number_of_targets": 1, 
					"effect_range": 4, 
					"msg": defender_traits.MaskApostle.Name
				}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("Lochra"):
		var buff = cloner.clone_dict(LBuffs.buff_data.Berserk)
		buff["target"] = defender
		buff["source"] = defender
		buff.duration = 2
		
		if defender == attacker:
				buff.duration = 3
		var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.Lochra.Name
			}
		
		ProcessQueue.add_effect(action)
	
	if defender_traits.has("Horror"):
		var buff = cloner.clone_dict(LBuffs.buff_data.Horrorform)
		buff["target"] = defender
		buff["source"] = defender
		buff.duration = int(dmg)
		var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.Horror.Name
			}
		ProcessQueue.add_effect(action)
	
	if defender_traits.has("Batform") and defender == attacker:
		var trait = defender_traits.Batform
		var buff = cloner.clone_dict(LBuffs.buff_data.Batform)
		buff["target"] = defender
		buff["source"] = defender
		buff.duration = trait.Level * 2
		var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.Batform.Name
			}
	
		ProcessQueue.add_effect(action)
	

static func check_resists(dmg, dmg_type, attacker, defender, is_check, mod_info):
	var attacker_traits = attacker.get_traits()
	var defender_traits = defender.get_traits()
	
	var total_increase = 0.0
	var attacker_buff_names = attacker.get_buff_names()
	var defender_buff_names = defender.get_buff_names()
	
	
	
	
	if attacker_traits.has("Spite") and defender.HP == defender.HP_max:
		total_increase += float(int(dmg))
		mod_info.string.append(attacker_traits.Spite.Name + " +" + str(int(dmg)))
	
	
	
						
	
	if attacker_traits.has("Kilij"):
		if dmg_type == "pierce" or dmg_type == "slash" or dmg_type == "blunt":
			total_increase += attacker.get_SPEED() * 2.0
			mod_info.string.append(attacker_traits.Kilij.Name + " +" + str(int(attacker.get_SPEED() * 2.0)))
						
	
	if attacker_traits.has("Myrmidon"):
		if dmg_type == "pierce" or dmg_type == "slash" or dmg_type == "blunt":
				var increase = float(attacker.get_total_inflex()) * 0.2
				increase *= dmg
				increase = float(int(increase))
				if increase > 0.0:
					total_increase += increase
					mod_info.string.append(attacker_traits.Myrmidon.Name + " +" + str(int(increase)))
	
	
			
	
	if attacker_traits.has("Sahasi"):
		if dmg_type == "astral" or dmg_type == "pierce" or dmg_type == "slash" or dmg_type == "blunt":
			if attacker_buff_names.has("Poise"):
				for buff in attacker.Buffs:
					if buff.name == "Poise":
						total_increase += buff.duration * 3.0
						mod_info.string.append(attacker_traits.Sahasi.Name + " +" + str(int(buff.duration * 3.0)))
						
	
	if attacker_traits.has("Pyromancy"):
		
		if dmg_type == "astral" or dmg_type == "fire" or dmg_type == "lightning":
			if defender_buff_names.has("Scorch"):
				for buff in defender.Buffs:
					if buff.name == "Scorch":
						var increase = float(attacker_traits.Pyromancy.Level) * float(buff.duration)
						total_increase += increase
						mod_info.string.append(attacker_traits.Pyromancy.Name + " +" + str(int(increase)))
						
	
	if attacker_traits.has("EarthMage"):
		
		if dmg_type == "poison" or dmg_type == "slash" or dmg_type == "blunt" or dmg_type == "pierce":
			if defender_buff_names.has("Entangle"):
				for buff in defender.Buffs:
					if buff.name == "Entangle":
						var increase = 10.0 * float(buff.duration)
						total_increase += increase
						mod_info.string.append(attacker_traits.EarthMage.Name + " +" + str(int(increase)))
	
	if attacker_traits.has("AssassinClass") == true:
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
			total_increase += 20.0 * attacker.get_total_DEX()
			mod_info.string.append(attacker_traits.AssassinClass.Name + " +" + str(int(20.0 * attacker.get_total_DEX())))
			
	
	
	if attacker_traits.has("Assassin"):
		var trait = attacker.get_traits().Assassin
		if dmg_type == "pierce" and float(defender.HP) / float(defender.HP_max) >= 0.75:
			total_increase += (dmg * 1.0 * trait.Level)
			mod_info.string.append(attacker_traits.Assassin.Name + " [color=#af2020]치명타![/color] +" + str(int(dmg * 1.0 * trait.Level)))
	
	if attacker_traits.has("Phoenix"):
		var trait = attacker_traits.Phoenix
		if attacker.invokes.has("krasota"):
				if attacker.level >= attacker.invokes.krasota.level_required:
					if attacker.invokes.krasota.use < attacker.invokes.krasota.use_max:
						total_increase += (dmg * 1.0)
						mod_info.string.append(trait.Name + " +" + str(int(dmg * 1.0 * trait.Level)))
						
	if attacker_traits.has("Windblade"):
		
		if dmg_type == "slash" and Global.rng.randi_range(1, 5) == 1:
			total_increase += (dmg * 2.0)
			mod_info.string.append(attacker_traits.Windblade.Name + " [color=#af2020]치명타![/color] +" + str(int(dmg * 2.0)))
	
	if attacker_traits.has("AssassinClass"):
		
		if dmg_type == "slash" or dmg_type == "pierce" or dmg_type == "blunt":
			if Global.rng.randi_range(1, 5) == 1:
				total_increase += (dmg * 2.0)
				mod_info.string.append(attacker_traits.AssassinClass.Name + " [color=#af2020]치명타![/color] +" + str(int(dmg * 2.0)))
			
			
		
	if attacker_traits.has("Morbumancy"):
		
		if dmg_type == "poison" or dmg_type == "death":
			if defender_buff_names.has("Sickness"):
				for buff in defender.Buffs:
					if buff.name == "Sickness":
						var increase = float(attacker_traits.Morbumancy.Level) * float(buff.duration)
						total_increase += increase
						mod_info.string.append(attacker_traits.Morbumancy.Name + " +" + str(int(increase)))
	
	if attacker_traits.has("Slime"):
		
		if dmg_type == "poison" or dmg_type == "fire":
			if defender_buff_names.has("Corrosion"):
				for buff in defender.Buffs:
					if buff.name == "Corrosion":
						total_increase += buff.duration
						mod_info.string.append(attacker_traits.Slime.Name + " +" + str(int(buff.duration)))
						

	if attacker_traits.has("chest_taurus"):
		if dmg_type == "pierce" or dmg_type == "slash" or dmg_type == "blunt":
			var increase = attacker.get_total_weight() * 5.0
			total_increase += increase
			mod_info.string.append(attacker_traits.chest_taurus.Name + " +" + str(int(increase)))
			
	
	if attacker_traits.has("Sunder"):
		if dmg_type == "pierce" or dmg_type == "slash" or dmg_type == "blunt":
			var increase = attacker.get_ARM() * 0.2
			total_increase += increase
			mod_info.string.append(attacker_traits.Sunder.Name + " +" + str(int(increase)))
			
	
	if attacker_traits.has("DeathKnight"):
		if dmg_type == "death":
			if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
				var increase = attacker.get_ARM()
				total_increase += increase
				mod_info.string.append(attacker_traits.DeathKnight.Name + " +" + str(int(increase)))
		
	
	
				
	
	if attacker_traits.has("Cryomancy"):
		
		if dmg_type == "pierce" or dmg_type == "slash" or dmg_type == "blunt" or dmg_type == "ice":
			if defender_buff_names.has("Freeze"):
				for buff in defender.Buffs:
					if buff.name == "Freeze":
						var increase = float(attacker_traits.Cryomancy.Level) * float(buff.duration)
						total_increase += increase
						mod_info.string.append(attacker_traits.Cryomancy.Name + " +" + str(int(increase)))
						
	
	
	
	
	
	
			
	
	
	
			
			
	
	
	
		
		
	
	for buff in attacker.Buffs:
		if buff.name == "Charge":
				total_increase += 5.0 * buff.duration
				mod_info.string.append("Charge +" + str(int(5.0 * buff.duration)))
		
		if buff.name == "Meditate":
				total_increase += 10.0 * buff.duration
				mod_info.string.append("Meditate +" + str(int(10.0 * buff.duration)))
				
		if buff.name == "Attune":
				var increase = float(buff.duration) * 0.01
				increase *= dmg
				increase = float(int(increase))
				if increase > 0.0:
					total_increase += increase
					mod_info.string.append("Attune +" + str(int(increase)))
		
		if buff.name == "Crowform":
				var increase = float(buff.duration) * 0.01
				increase *= dmg
				increase = float(int(increase))
				if increase > 0.0:
					total_increase += increase
					mod_info.string.append("Crowform +" + str(int(increase)))
				
	
	if attacker_traits.has("MasterRepulsion"):
		
		if dmg_type == "psychic" or dmg_type == "astral":
			if attacker_buff_names.has("Repulsion"):
				for buff in attacker.Buffs:
					if buff.name == "Repulsion":
						var increase = float(attacker_traits.MasterRepulsion.Level) * float(buff.duration)
						total_increase += increase
						mod_info.string.append(attacker_traits.MasterRepulsion.Name + " +" + str(int(increase)))
						
	
	if attacker_traits.has("Acid_Necklace"):
		
			if attacker_buff_names.has("Corrosion"):
				for buff in attacker.Buffs:
					if buff.name == "Corrosion":
						total_increase += buff.duration * 5.0
						mod_info.string.append(attacker_traits.Acid_Necklace.Name + " +" + str(int(buff.duration * 5.0)))
	if attacker_traits.has("Frenzied"):
		
			if attacker_buff_names.has("Inflame"):
				for buff in attacker.Buffs:
					if buff.name == "Inflame":
						total_increase += buff.duration * 5.0
						mod_info.string.append(attacker_traits.Frenzied.Name + " +" + str(int(buff.duration * 5.0)))
	
	
	if attacker_traits.has("VoidMage"):
		if dmg_type == "death":
				var increase = 0.0
			
				for buff in defender.Buffs:
					if buff.name == "Freeze":
						increase += float(buff.duration * 0.01)
			
				for buff in attacker.Buffs:
					if buff.name == "Freeze":
						increase += float(buff.duration * 0.01)
				increase *= dmg
				increase = float(int(increase))
				if increase > 0.0:
					total_increase += increase
					mod_info.string.append(attacker_traits.VoidMage.Name + " +" + str(int(increase)))
	
	
	if attacker_traits.has("FlameKnight"):
		if dmg_type == "fire":
			if attacker.get_hands_used() == 1:
				var increase = float(attacker.get_total_STR()) * 0.2
				increase *= dmg
				increase = float(int(increase))
				if increase > 0.0:
					total_increase += increase
					mod_info.string.append(attacker_traits.FlameKnight.Name + " +" + str(int(increase)))
	
	if attacker_traits.has("Baghatar"):
		var increase = 0.05 * float(translate.count_empty_prayers())
		increase *= dmg
		increase = float(int(increase))
		if increase > 0.0:
					total_increase += increase
					mod_info.string.append(attacker_traits.Baghatar.Name + " +" + str(int(increase)))
	
	
	if attacker_traits.has("Elementalist"):
		if dmg_type != "slash" and dmg_type != "pierce" and dmg_type != "blunt":
			
				var increase = float(attacker.get_total_WIL()) * 0.1
				increase *= dmg
				increase = float(int(increase))
				if increase > 0.0:
					total_increase += increase
					mod_info.string.append(attacker_traits.Elementalist.Name + " +" + str(int(increase)))
	
	if attacker_traits.has("Pyromaniac"):
		if dmg_type == "fire":
			if attacker.get_buff_names().has("Inflame"):
				for buff in attacker.Buffs:
					if buff.name == "Inflame":
						var increase = float(5 * buff.duration)
						if increase > 0.0:
							total_increase += increase
							mod_info.string.append(attacker_traits.Pyromaniac.Name + " +" + str(int(increase)))
	
	if attacker_traits.has("Shantih"):
		if dmg_type == "lightning":
		
				var increase = float(attacker.get_total_DEX()) * 0.2
				increase *= dmg
				increase = float(int(increase))
				if increase > 0.0:
					total_increase += increase
					mod_info.string.append(attacker_traits.Shantih.Name + " +" + str(int(increase)))
				
	
	if defender_buff_names.has("Mark"):
		if dmg_type == "pierce" or dmg_type == "slash" or dmg_type == "blunt":
			for buff in defender.Buffs:
				if buff.name == "Mark":
					var increase = buff.duration * 0.1
					increase *= dmg
					increase = float(int(increase))
					if increase > 0.0:
						total_increase += increase
						mod_info.string.append("Mark +" + str(int(increase)))
	
	if attacker == Global.Player:
		
		var increase = float(attacker.get_total_WIL()) * 0.1
		increase *= dmg
		increase = float(int(increase))
		if increase > 0.0:
			mod_info.string.append("의지 +" + str(int(increase)))
		if attacker_traits.has("LizardVisage") == true:
			if attacker.armor_chest == null:
				if increase > 0.0:
					mod_info.string.append(attacker_traits.LizardVisage.Name + " +" + str(int(increase)))
				increase += float(int(increase))
		if attacker_traits.has("Siku") == false:
			if attacker.get_total_inflex() > 1.0:
				var decrease = float((int(increase - (increase / attacker.get_total_inflex()))))
				if decrease > 0.0:
					mod_info.string.append("경직 -" + str(int(decrease)))
				
					increase -= decrease
			
		total_increase += increase
		
		
		
			
			
			
			
		
		
			
			
	
	
	
	
	
	
	
	
	
	var decrease = float(defender.get_resist(dmg_type))
	
	decrease *= 0.01
	decrease *= dmg + total_increase
	
	
	var no_resist = false
	
	
	if attacker_traits.has("DreadAxe") and decrease > 0.0:
		if attacker.get_hands_used() == 1:
			if dmg_type == "death" or dmg_type == "slash" or dmg_type == "blunt" or dmg_type == "pierce":
				if defender.get_resist(dmg_type) != 0:
					no_resist = true
					mod_info.string.append("공포의 도끼: 저항 무시")
	
	
			
				
					
					
	
	
	if no_resist == false:
		total_increase -= float(int(decrease))
	
	
	if attacker != defender and decrease > 0.0 and no_resist == false:
		mod_info.string.append("저항 -" + str(int(decrease)))
	
	if attacker != defender and decrease < 0.0 and no_resist == false:
		mod_info.string.append("역저항 +" + str(int(decrease * - 1)))
	
	
	
		
	
	
	
		
	if defender_buff_names.has("Grace"):
		for buff in defender.Buffs:
			if buff.name == "Grace":
					
				var increase = float(5.0 * buff.duration)
				if attacker != defender:
					mod_info.string.append("Grace -" + str(int(increase)))
				total_increase -= increase
				
	
	var no_change = false
	
	if attacker == defender:
		no_change = true
			
	
	
	if no_change == false:
		dmg += total_increase
	
		
		
		if defender_buff_names.has("Agony"):
			for buff in defender.Buffs:
				if buff.name == "Agony":
					if float(dmg) < float(defender.HP_max) * 0.02:
						mod_info.string.append("Agony +" + str(int((float(defender.HP_max) * 0.02) - dmg)))
						dmg = float(defender.HP_max) * 0.02
						
						
	
	
	dmg = float(dmg)
	
	if defender_buff_names.has("Protection"):
		if attacker != defender:
			var limit = 1.0
			if dmg > limit:
				mod_info.string.append("보호 -" + str(int(dmg - 1.0)))
				dmg = limit
	
	if defender_traits.has("Struggler"):
		if Global.rng.randi_range(1, 3) == 1:
			var limit = 1.0
			if dmg > limit:
				mod_info.string.append("투사 [color=#ff7030]인내[/color] -" + str(int(dmg - 1.0)))
				dmg = limit
	
	
		
			
			
			
	
	
	if attacker == defender:
		mod_info.string = [str(int(dmg), " (자해 피해)")]
		
	if dmg < 1.0:
			dmg = 1.0
	
	return dmg

static func text_popup(dmg, dmg_type, defender):
	var apoint = defender.get_global_position()
	dmg = int(dmg)
	var damage_string = translate.add_commas(str(int(dmg)))
	var atext = "" + damage_string
	var color = "[color=#ff3030]"
	if defender == Global.Player:
		color = get_damage_color(dmg_type, color, true)
	else:
		color = get_damage_color(dmg_type, color, false)
	ProcessText.spawn_text_popup(apoint, atext, color)


static func pre_check_damage_type_effects(dmg, dmg_type, attacker, defender):
	var rng = Global.rng
	if dmg_type == "pierce" and dmg >= 50.0:
		if rng.randi_range(1, 100 + attacker.get_total_DEX()) >= 90:
			ToolMessageCreator.add_message("[color=#ff0000]", "깊이 관통!")
			dmg *= 5
	return dmg

static func post_check_damage_type_effects(dmg, dmg_type, attacker, defender):
	
	var rng = Global.rng
	var defender_name = defender.get_name()
	var prep = " is "
	
	if defender == Global.Player:
		defender_name = "You"
		prep = " are "
	
	if dmg_type == "slash" and dmg >= 25.0:
		if rng.randi_range(1, 25 + attacker.get_total_DEX()) >= 25:
			ToolMessageCreator.add_message("[color=#ff1010]", "베어 가르다!")
			var dmgnew = dmg * 3
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": dmgnew, 
					"damage_type": "blood", 
					"effect_sprite": "Blood"
				}
			ProcessQueue.add_effect(action)
	
	
		
		
		
		
			
			
				
				
				
				
			
			
	
	
	

static func get_txt_color(_dmg, _dmg_type, _defender, _attacker):
	var stringa = "[color=#707070]"
	
	
	
	
	
		
		

	
		
		

	
		
	
	stringa = "[color=#c0c0c0]"
	
	return stringa


static func message_damage(dmg, dmg_type, defender, attacker):
	dmg = int(dmg)
	
	var name_a = attacker.get_name_color()
	var name_d = defender.get_name_color()
	var damage_text = get_damage_text(dmg_type, attacker, defender)
	
	
	var stringa = "..."
	
	
	
	if attacker == Global.Player and defender == Global.Player:

		name_a = ""
		name_d = "자신"
		stringa = name_a + name_d + "을(를) " + damage_text + " "
	elif attacker == Global.Player:
	
		name_a = ""
		stringa = name_a + name_d + "을(를) " + damage_text + " "
	elif defender == Global.Player:

		name_d = "당신"
		stringa = "" + name_a + "(이)가 " + name_d + "을(를) " + damage_text + " "
	
	elif attacker == defender:
	
		stringa = "[color=#707070]" + name_a + "(이)가 자신을 " + damage_text + " "
	
	else:
		
		stringa = "[color=#707070]" + name_a + "(이)가 " + name_d + "을(를) " + damage_text + " "
	
	
	
	
	return stringa


static func message_damage_value(dmg, _dmg_type, attacker, defender):
	var stringa = "..."
	
	
	
	var damage_string = translate.add_commas(str(int(dmg)))
	if attacker == Global.Player:
		
		if defender == Global.Player:
			stringa = "[color=#df5050]" + damage_string + "[/color] 피해"
		else:
			stringa = "[color=#ffff50]" + damage_string + "[/color] 피해"
			
	elif defender == Global.Player:
		stringa = "[color=#df5050]" + damage_string + "[/color] 피해"
	else:
		stringa = damage_string + " 피해"
	
	
	
	return stringa

static func get_damage_text(dmg_type, attacker, _defender):
	var stringa = "타격"
	if dmg_type == "pierce":
		stringa = "관통"
	if dmg_type == "slash":
		stringa = "참격"
	if dmg_type == "blunt":
		stringa = "강타"
	if dmg_type == "blood":
		stringa = "찢기"
	if dmg_type == "fire":
		stringa = "화상"
	if dmg_type == "poison":
		stringa = "중독"
	if dmg_type == "astral":
		stringa = "폭발"
	if dmg_type == "lightning":
		stringa = "감전"
	if dmg_type == "psychic":
		stringa = "정신파"
	if dmg_type == "death":
		stringa = "저주"
	if dmg_type == "ice":
		stringa = "냉기"
	stringa = get_damage_color_for_message(dmg_type, "[color=#ffffff]", true) + stringa + "[/color]"
	return stringa

static func get_damage_color_for_message(dmg_type, txcolor, _is_player):
		var stringa = txcolor
	
		if dmg_type == "fire":
			stringa = "[color=#ff7000]"
		if dmg_type == "poison":
			stringa = "[color=#50ff00]"
		if dmg_type == "astral":
			stringa = "[color=#8030af]"
		if dmg_type == "lightning":
			stringa = "[color=#0060ff]"
		if dmg_type == "psychic":
			stringa = "[color=#ffaf30]"
		if dmg_type == "death":
			stringa = "[color=#a0a000]"
		if dmg_type == "ice":
			stringa = "[color=#5080ff]"
		if dmg_type == "pierce":
			stringa = "[color=#af8f50]"
		if dmg_type == "blunt":
			stringa = "[color=#af8f50]"
		if dmg_type == "slash":
			stringa = "[color=#af8f50]"
		if dmg_type == "blood":
			stringa = "[color=#ff1010]"
	
	
		return stringa

static func get_damage_color(dmg_type, txcolor, is_player):
	var stringa = txcolor
	if is_player == false:
		if dmg_type == "fire":
			stringa = "[color=#ff7000]"
		if dmg_type == "poison":
			stringa = "[color=#50ff00]"
		if dmg_type == "astral":
			stringa = "[color=#8030af]"
		if dmg_type == "lightning":
			stringa = "[color=#0060ff]"
		if dmg_type == "psychic":
			stringa = "[color=#ffaf30]"
		if dmg_type == "death":
			stringa = "[color=#a0a000]"
		if dmg_type == "ice":
			stringa = "[color=#5080ff]"
		if dmg_type == "pierce":
			stringa = "[color=#af8f50]"
		if dmg_type == "blunt":
			stringa = "[color=#af8f50]"
		if dmg_type == "slash":
			stringa = "[color=#af8f50]"
		if dmg_type == "blood":
			stringa = "[color=#ff1010]"
	
	
	return stringa
	
static func add_score(dmg, dmg_type, attacker, defender):
	match attacker.object_type:
		"player":
			StatePlayerSheet.score_data.damage_dealt += int(dmg)
			if dmg > StatePlayerSheet.score_data.highest_damage:
				StatePlayerSheet.score_data.highest_damage = int(dmg)
				StatePlayerSheet.score_data.highest_damage_type = translate.damage_type(dmg_type)
	
	if defender.object_type == "player":
		StatePlayerSheet.score_data.damage_taken += int(dmg)
