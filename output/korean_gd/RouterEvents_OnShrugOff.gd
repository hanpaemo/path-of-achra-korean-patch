extends Node

class_name event_shrug

static func check(attacker, defender, weapon, armor):
	
	effects(attacker, defender, weapon, armor)
	
	effectmaker.create_effect_animated(defender.global_position, Global.EffectAnimated, "Shrug")
	

	pass

static func effects(attacker, defender, weapon, armor):
	var unit = defender
	
	var defender_traits = defender.get_traits()
	
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
	
	if defender_traits.has("Taugh") == true:
		if defender.get_hands_used() == 1:
			var multi = 4 - defender.get_armor_list().size()
			for n in multi:
				var action = {
			"name": "attack_targets", 
			"attacker": defender, 
			"number_of_targets": 1, 
			"msg": defender_traits.Taugh.Name
		}
				ProcessQueue.add_effect(action)
	
	if defender_traits.has("VoidChest"):
			
			for buff in defender.Buffs:
				if buff.name == "Stasis":
					var action = {
		"name": "magic_damage_targets_range", 
		"caster": defender, 
		"damage": 10.0 * buff.duration, 
		"damage_type": "astral", 
		"effect_sprite": "Astral", 
		"effect_range": 2, 
		"number_of_targets": 50, 
		"msg": defender_traits.VoidChest.Name
			}
					ProcessQueue.add_effect(action)
			
			var buff = cloner.clone_dict(LBuffs.buff_data.Stasis)
			buff["target"] = defender
			buff["source"] = defender
			buff.duration = 1
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.VoidChest.Name
				}
			ProcessQueue.add_effect(action)
			
			
	
	if defender_traits.has("Gallus"):
		
		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": defender, 
				"damage": defender.get_total_weight(), 
				"damage_type": "blunt", 
				"effect_sprite": "Bash", 
				"effect_range": 4, 
				"msg": defender_traits.Gallus.Name
			}
		ProcessQueue.add_effect(action)
	
	if defender_traits.has("Tenacity") == true:
		var trait = defender.get_traits().Tenacity
		var action = {
				"name": "magic_damage_targets_range", 
			"caster": defender, 
			"damage": defender.get_total_weight() * trait.Level, 
			"damage_type": "blunt", 
			"effect_sprite": "Bash", 
			"effect_range": 1, 
			"number_of_targets": 1, 
			"msg": defender_traits.Tenacity.Name
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
	
	
	var player_traits = Global.Player.get_traits()
	
		
			
				
				
					
					
				
				
			
				
				
		
					
		
	if defender_traits.has("EmeraldArmor") == true:
		for n in 2:
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.serpent, 
					"summoner": defender, 
					"msg": defender_traits.EmeraldArmor.Name
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

	if defender_traits.has("VotiveChest") == true:
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": defender, 
					"damage": defender.get_total_STR(), 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": defender_traits.VotiveChest.Name
				}
			ProcessQueue.add_effect(action)
		
		
			var buff = cloner.clone_dict(LBuffs.buff_data.Scorch)
			buff["target"] = attacker
			buff["source"] = defender
			buff.duration = defender.get_total_STR() * 10.0
			action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.VotiveChest.Name
			}
			ProcessQueue.add_effect(action)

	if defender_traits.has("FlameKnight") == true:
			var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
			buff["target"] = defender
			buff["source"] = defender
			buff.duration = 2
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.FlameKnight.Name
			}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("Bully") == true:
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
			ToolMagicMaker.add_attack(defender, defender.residence, attacker.residence, defender.get_range_attack(defender.weapon_main), attacker, defender.weapon_main, "Bully")
	
