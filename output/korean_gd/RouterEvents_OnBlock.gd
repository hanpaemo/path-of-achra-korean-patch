extends Node


class_name event_block

static func check(attacker, defender, weapon, block):
	
	var unit = defender
	
	var defender_traits = defender.get_traits()
	var attacker_traits = attacker.get_traits()
	
	
	if defender == Global.Player:
		ToolInvokes.recharge("block")
	
	if defender_traits.has("PurifyingDisplay"):
		
		for buff in unit.Buffs:
			if buff.name == "Entangle" or buff.name == "Freeze" or buff.name == "Sickness" or buff.name == "Bleed":
				var action = {
					"name": "remove_buff", 
					"target": unit, 
					"buff": buff, 
					"msg": defender_traits.PurifyingDisplay.Name
		}
				ProcessQueue.add_effect(action)
	
	var player_traits = Global.Player.get_traits()
	
		
			
			
				
					
					
					
					
				
				
				
		
					
	
	
	if defender_traits.has("Pallas"):
		if defender.get_hands_used() == 2:
			
			var damage = 0.1 * float(defender.get_DMG_total(defender.weapon_off))
			if damage < 1.0: damage = 1.0
			var action = {
			"name": "magic_damage_targets_range", 
			"caster": defender, 
			"damage": damage, 
			"damage_type": "pierce", 
			"effect_sprite": "Pierce", 
			"number_of_targets": 2, 
			"effect_range": 2, 
			"msg": defender_traits.Pallas.Name
				}
			ProcessQueue.add_effect(action)
	
	
	if defender_traits.has("Scutum"):
				var buff = cloner.clone_dict(LBuffs.buff_data.Poise)
				buff["target"] = defender
				buff["source"] = defender
				buff.duration = 2
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.Scutum.Name
			}
				ProcessQueue.add_effect(action)
	
	
	if defender_traits.has("Champion"):

			
				var buff = cloner.clone_dict(LBuffs.buff_data.Poise)
				buff["target"] = defender
				buff["source"] = defender
				buff.duration = 2
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.Champion.Name
			}
				ProcessQueue.add_effect(action)
				action = {
			"name": "attack_targets", 
			"attacker": defender, 
			"number_of_targets": 1, 
			"msg": defender_traits.Champion.Name
		}
	
				ProcessQueue.add_effect(action)
	
	if defender_traits.has("Mubarizun") == true:
		var action = {
			"name": "attack_targets", 
			"attacker": unit, 
			"number_of_targets": 1, 
			"msg": defender_traits.Mubarizun.Name
		}
	
		ProcessQueue.add_effect(action)
	
	if defender_traits.has("Weirding") == true:
		var trait = defender.get_traits().Weirding
		var action = {
					"name": "magic_damage_tiles_in_path_to_targets_in_range", 
					"caster": defender, 
					"damage": 75.0 * trait.Level, 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"number_of_targets": 1, 
					"effect_range": 4, 
					"enemies": null, 
					"msg": defender_traits.Weirding.Name
				}
		ProcessQueue.add_effect(action)
	
	if defender_traits.has("ShieldThrow") == true:
			var action = {
				"name": "magic_damage_tiles_in_path", 
				"target": attacker, 
				"caster": defender, 
				"damage": 200.0, 
				"damage_type": "slash", 
				"effect_sprite": "Slash", 
				"msg": defender_traits.ShieldThrow.Name
			}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("Counter") == true:
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
			var msg = defender_traits.Counter.Name
			ToolMagicMaker.add_attack(defender, defender.residence, attacker.residence, defender.get_range_attack(defender.weapon_main), attacker, defender.weapon_main, msg)
	
	if defender_traits.has("ShieldMirage") == true:
		
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.psychomorph, 
					"summoner": defender, 
					"msg": defender_traits.ShieldMirage.Name
				}
			ProcessQueue.add_effect(action)
	
	
	
	if defender_traits.has("Arjuta") == true:
			var buff = cloner.clone_dict(LBuffs.buff_data.Freeze)
			buff["target"] = attacker
			buff["source"] = defender
			buff.duration = 3 * defender_traits.Arjuta.Level
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.Arjuta.Name
			}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("FireShield") == true:
		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": defender, 
				"damage": defender.get_block_strength(), 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"effect_range": 1, 
				"msg": defender_traits.FireShield.Name
			}
		ProcessQueue.add_effect(action)
	
	if defender_traits.has("chest_blue") == true:
		
			var med_buff = cloner.clone_dict(LBuffs.buff_data.Meditate)
			med_buff["target"] = defender
			med_buff["source"] = defender
			med_buff.duration = 3 * defender.get_total_inflex()
			var action = {
			"name": "add_buff", 
			"buff": med_buff, 
			"msg": defender_traits.chest_blue.Name
			}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("BloodGuard") == true:
			var buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
			buff["target"] = attacker
			buff["source"] = defender
			buff.duration = defender.get_total_DEX()
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.BloodGuard.Name
			}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("Aqliyya"):
				var action = {
			"name": "attack_targets", 
			"attacker": defender, 
			"number_of_targets": 1, 
			"msg": defender_traits.Aqliyya.Name
		}
				ProcessQueue.add_effect(action)
	
	if defender_traits.has("Acid_Shield") == true:
			var buff = cloner.clone_dict(LBuffs.buff_data.Corrosion)
			buff["target"] = attacker
			buff["source"] = defender
			buff.duration = defender.get_total_STR()
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.Acid_Shield.Name
			}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("Skiagh") == true:
			var duration = 4 - defender.get_armor_list().size()
			duration *= 10
			if duration > 0:
				var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
				buff["target"] = defender
				buff["source"] = defender
				buff.duration = duration
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.Skiagh.Name
			}
				ProcessQueue.add_effect(action)
	
	if defender_traits.has("ShieldMed") == true:
			var duration = defender.get_total_WIL()

			var buff = cloner.clone_dict(LBuffs.buff_data.Meditate)
			buff["target"] = defender
			buff["source"] = defender
			buff.duration = duration
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.ShieldMed.Name
			}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("Murmillo") == true:
		var trait = defender.get_traits().Murmillo
		for n in trait.Level:
			var action = {
			"name": "hit_targets_range", 
			"attacker": defender, 
			"hit": 50.0, 
			"weapon": defender.weapon_main, 
			"effect_range": 1, 
			"number_of_targets": 1, 
			"msg": defender_traits.Murmillo.Name
				}
			ProcessQueue.add_effect(action)
	
	
		
		
		
		
		
			
		
			
		
	
	
	
	
	
	effectmaker.create_effect_animated(defender.global_position, Global.EffectAnimated, "Block")
