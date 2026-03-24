extends Node


class_name event_learn

static func check(label, msg):
	var unit = Global.Player
	
	var unit_traits = unit.get_traits()
	
	match label:
		
		"GoreTide":
				ToolMessageCreator.add_message("[color=#a0c0c0]", "[color=#ff1010]Gore Tide[/color]! [color=#707070]+50 체력[/color]")
				if ToolSettings.settings_data.cycle_current > 1:
					var hp_bonus = float(4)
					hp_bonus *= float(ToolSettings.settings_data.cycle_current)
					Global.Player.HP_max += int(hp_bonus)
					Global.Player.HP += int(hp_bonus)
					ToolMessageCreator.add_message("[color=#ff5050]", "순환의 기운이 충전된다...[color=#707070] +" + str(int(hp_bonus)) + " 체력[/color]")
			
				Global.Player.HP_max += 50
				Global.Player.HP += 50
				Global.Player.update()
		
		"Kuga":
				ToolMessageCreator.add_message("[color=#a0c0c0]", "[color=#a0a000]Kuga[/color]! [color=#707070]+50 체력[/color]")
				if ToolSettings.settings_data.cycle_current > 1:
					var hp_bonus = float(4)
					hp_bonus *= float(ToolSettings.settings_data.cycle_current)
					Global.Player.HP_max += int(hp_bonus)
					Global.Player.HP += int(hp_bonus)
					ToolMessageCreator.add_message("[color=#ff5050]", "순환의 기운이 충전된다...[color=#707070] +" + str(int(hp_bonus)) + " 체력[/color]")
			
				Global.Player.HP_max += 50
				Global.Player.HP += 50
				Global.Player.update()
		
		"Merzot":
				ToolMessageCreator.add_message("[color=#a0c0c0]", "[color=#70ff00]Merzot[/color]! [color=#707070]+50 체력[/color]")
				if ToolSettings.settings_data.cycle_current > 1:
					var hp_bonus = float(40)
					hp_bonus *= float(ToolSettings.settings_data.cycle_current)
					Global.Player.HP_max += int(hp_bonus)
					Global.Player.HP += int(hp_bonus)
					ToolMessageCreator.add_message("[color=#ff5050]", "순환의 기운이 충전된다...[color=#707070] +" + str(int(hp_bonus)) + " 체력[/color]")
				Global.Player.HP_max += 500
				Global.Player.HP += 500
				Global.Player.update()
		
		"AmplifiedHealing":
				ToolMessageCreator.add_message("[color=#a0c0c0]", "[color=#00a000]Life Chant[/color]! [color=#707070]+50 체력[/color]")
				if ToolSettings.settings_data.cycle_current > 1:
					var hp_bonus = float(4)
					hp_bonus *= float(ToolSettings.settings_data.cycle_current)
					Global.Player.HP_max += int(hp_bonus)
					Global.Player.HP += int(hp_bonus)
					ToolMessageCreator.add_message("[color=#ff5050]", "순환의 기운이 충전된다...[color=#707070] +" + str(int(hp_bonus)) + " 체력[/color]")
			
				Global.Player.HP_max += 50
				Global.Player.HP += 50
				Global.Player.update()
				
		"Strijela":
			if Global.Player.weapon_main != null:
				if Global.Player.weapon_main.range > 1:
					Global.Player.weapon_main.aoe = 2
		
		"Anroth":
			ToolMessageCreator.add_message("[color=#309fbf]", "Anroth의 정기가 온몸에 퍼진다![/color]")
			for n in int(unit.get_total_STR()):
				level_up.strength()
			for n in int(unit.get_total_DEX()):
				level_up.dexterity()
			for n in int(unit.get_total_WIL()):
				level_up.willpower()
			Global.Player.POINTS_TRAITS -= 10
		
		"Beastmaster":
			var highest_beast = 0
			var beast_type = "RedDragon2"
			for key in unit_traits:
				var trait = unit_traits[key]
				match trait.title:
					"SummonRedDragon":
						if trait.Level * trait.cost >= highest_beast:
							highest_beast = trait.Level * trait.cost
							beast_type = "RedDragon2"
					"SummonGrika":
						if trait.Level * trait.cost >= highest_beast:
							highest_beast = trait.Level * trait.cost
							beast_type = "Grika2"
					"PoisonFamiliar":
						if trait.Level * trait.cost >= highest_beast:
							highest_beast = trait.Level * trait.cost
							beast_type = "Tsuchigumo2"
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data[beast_type], 
					"summoner": unit, 
					"msg": unit_traits.Beastmaster.Name
				}
			ProcessQueue.add_effect(action)
		
		
		"WormMonk":
			for n in 10:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Crawler, 
					"summoner": unit, 
					"msg": unit_traits.WormMonk.Name
				}
				ProcessQueue.add_effect(action)
		
		"Necromancy":
			
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.skeleton, 
					"summoner": unit, 
					"msg": unit_traits.Necromancy.Name
				}
			ProcessQueue.add_effect(action)
				
			action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.skeleton_archer, 
					"summoner": unit, 
					"msg": unit_traits.Necromancy.Name
				}
			ProcessQueue.add_effect(action)
		
		"BurningOoze":
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.ooze, 
					"summoner": unit, 
					"msg": unit_traits.BurningOoze.Name
				}
				ProcessQueue.add_effect(action)
		
		
		"MinionFeast":
			for n in 3:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.bloodacolyte, 
					"summoner": unit, 
					"msg": unit_traits.MinionFeast.Name
				}
				ProcessQueue.add_effect(action)
		
		
		
			
				
				
					
				
			
			
		
		"BlightCult":
			for n in 3:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.blightpriest, 
					"summoner": unit, 
					"msg": unit_traits.BlightCult.Name
				}
				ProcessQueue.add_effect(action)
		
		
		
		"FlameCult":
			for n in 3:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.flamepriest, 
					"summoner": unit, 
					"msg": unit_traits.FlameCult.Name
				}
				ProcessQueue.add_effect(action)
		
		"GroveCult":
			for n in 3:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.grovepriest, 
					"summoner": unit, 
					"msg": unit_traits.GroveCult.Name
				}
				ProcessQueue.add_effect(action)
		
		"StarCult":
			for n in 3:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.StarPriest, 
					"summoner": unit, 
					"msg": unit_traits.StarCult.Name
				}
				ProcessQueue.add_effect(action)
		
		"Sparkform":
			
			var buff = cloner.clone_dict(LBuffs.buff_data.Sparkform)
			buff["target"] = unit
			buff["source"] = unit
			buff["duration"] = 10
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": unit_traits.Sparkform.Name
			}
			ProcessQueue.add_effect(action)
		
		
		"Shimmergang":
			for n in 3:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Blinksnake, 
					"summoner": unit, 
					"msg": unit_traits.Shimmergang.Name
				}
				ProcessQueue.add_effect(action)
		"Ormjarl":
			for n in 3:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.BlueWyrm, 
					"summoner": unit, 
					"msg": unit_traits.Ormjarl.Name
				}
				ProcessQueue.add_effect(action)
		"Mura":
			
		
			for n in 3:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.PearlMirror, 
					"summoner": unit, 
					"msg": unit_traits.Mura.Name
				}
				ProcessQueue.add_effect(action)
		"WarChant":
			for n in 2:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Thrall, 
					"summoner": unit, 
					"msg": unit_traits.WarChant.Name
				}
				ProcessQueue.add_effect(action)
		
		"PoisonFamiliar":
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Tsuchigumo, 
					"summoner": unit, 
					"msg": unit_traits.PoisonFamiliar.Name
				}
				ProcessQueue.add_effect(action)
		
		"HungryGrave":
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.HonoredDead, 
					"summoner": unit, 
					"msg": unit_traits.HungryGrave.Name
				}
				ProcessQueue.add_effect(action)
		"SummonGrika":
			
			
			
				
			
			for n in 1:
					var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.grika, 
					"summoner": unit, 
					"msg": unit_traits.SummonGrika.Name
				}
					ProcessQueue.add_effect(action)
		"Arsonist":
			for n in 10:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Root, 
					"summoner": unit, 
					"msg": unit_traits.Arsonist.Name
				}
				ProcessQueue.add_effect(action)
		
		"Uspori":
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Bukavac, 
					"summoner": unit, 
					"msg": unit_traits.Uspori.Name
				}
				ProcessQueue.add_effect(action)
		
		
		"SummonRedDragon":
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.RedDragon, 
					"summoner": unit, 
					"msg": unit_traits.SummonRedDragon.Name
				}
				ProcessQueue.add_effect(action)
		
		"Bloodcalling":
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Hemogoblin, 
					"summoner": unit, 
					"msg": unit_traits.Bloodcalling.Name
				}
				ProcessQueue.add_effect(action)
		
		"Zahan":
			for n in 4:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.fireworm, 
					"summoner": unit, 
					"msg": unit_traits.Zahan.Name
				}
				ProcessQueue.add_effect(action)
		
		"FulminantCult":
			for n in 3:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.fulminantpriest, 
					"summoner": unit, 
					"msg": unit_traits.FulminantCult.Name
				}
				ProcessQueue.add_effect(action)
