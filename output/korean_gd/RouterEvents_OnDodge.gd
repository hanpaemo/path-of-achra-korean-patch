extends Node


class_name event_dodge


static func check(attacker, defender, weapon):
	
	if defender == Global.Player:
		ToolInvokes.recharge("dodge")
	
	var defender_traits = defender.get_traits()

	if defender_traits.has("Lunge") == true:
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
			var repeat = 5 - defender.get_armor_list().size()
			for n in repeat:
				var msg = defender_traits.Lunge.Name
				ToolMagicMaker.add_attack(defender, defender.residence, attacker.residence, defender.get_range_attack(defender.weapon_main), attacker, defender.weapon_main, msg)
	
	if defender_traits.has("Assassin"):
				var trait = defender.get_traits().Assassin
				for n in trait.Level:
					var action = {
			"name": "attack_targets", 
			"attacker": defender, 
			"number_of_targets": 1, 
			"msg": defender_traits.Assassin.Name
		}
	
					ProcessQueue.add_effect(action)
	
	if defender_traits.has("MirrorImage") == true:
		var trait = defender.get_traits().MirrorImage
		
		for n in trait.Level:
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.psychomorph, 
					"summoner": defender, 
					"msg": defender_traits.MirrorImage.Name
				}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("Mesmer"):
		var buff = cloner.clone_dict(LBuffs.buff_data.Repulsion)
		buff["target"] = defender
		buff["source"] = defender
		buff.duration = 2
		var action2 = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.Mesmer.Name
			}
		ProcessQueue.add_effect(action2)
	
	
	if defender_traits.has("Shantih"):
		var buff = cloner.clone_dict(LBuffs.buff_data.Charge)
		buff["target"] = defender
		buff["source"] = defender
		buff.duration = 2
		var action2 = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.Shantih.Name
			}
		ProcessQueue.add_effect(action2)
	
	
	if defender_traits.has("Aqliyya"):
				var action = {
			"name": "attack_targets", 
			"attacker": defender, 
			"number_of_targets": 1, 
			"msg": defender_traits.Aqliyya.Name
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

	if defender_traits.has("Kull"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Evasion)
			buff["target"] = defender
			buff["source"] = defender
			buff.duration = 3
			var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": defender_traits.Kull.Name
			}
			ProcessQueue.add_effect(action)

	if defender_traits.has("Mubarizun") == true:
		var action = {
			"name": "attack_targets", 
			"attacker": defender, 
			"number_of_targets": 1, 
			"msg": defender_traits.Mubarizun.Name
		}
	
		ProcessQueue.add_effect(action)
	
	if defender_traits.has("Elding") == true:
		var trait = defender.get_traits().Elding
		var action = {
		
		"name": "magic_damage_tiles_in_path_to_targets_in_range", 
		"caster": defender, 
		"damage": 40.0 * trait.Level, 
		"damage_type": "lightning", 
		"effect_sprite": "Zap", 
		"number_of_targets": 99, 
		"effect_range": 3, 
		"enemies": null, 
		"msg": defender_traits.Elding.Name
		
			}
		ProcessQueue.add_effect(action)
		

	

	effectmaker.create_effect_animated(defender.global_position, Global.EffectAnimated, "Dodge")
