extends Node

class_name event_enter_level

static func check(unit, residence):
	if StateWorld.type != "path":
		ToolInvokes.recharge("new area")
		
		if unit == Global.Player:
			
			Steam.set_achievement("path")
			
			unit.gain_xp(5 + (StateWorld.day * 3))
			
			
			if float(unit.HP) / float(unit.HP_max) <= 0.75:
				ToolInvokes.recharge("new area injured")
			else:
				ToolInvokes.lose_charge("new area uninjured")
				
		
		check_effects(unit, residence)
	else:
		if unit == Global.Player:
			
			if StateWorld.tileset.title == "tower_green" and StateWorld.land == "achra":
				Steam.set_achievement("green")
			if StateWorld.tileset.title == "tower_red" and StateWorld.land == "achra":
				Steam.set_achievement("red")
			
			if StateWorld.tileset.title == "tower_purple" and StateWorld.land == "achra":
				Steam.set_achievement("violet")
			
			if Global.testmode == true and StateWorld.land == "achra":
				Steam.set_achievement("obelisk")
				gencont.change_to_void(Global.continent, Global.continent.tile_list)
		
			elif StateWorld.tileset.title == "obelisk" and StateWorld.land == "achra":
				Steam.set_achievement("obelisk")
				gencont.change_to_void(Global.continent, Global.continent.tile_list)
				
			if StateWorld.tileset.title == "astrolith" and StateWorld.land == "void":
			
				Global.game.fade_in()
				StateWorld.victorious = true
				ToolFeatGiver.victory_feats()
				Global.Player.death_popup("victory")
				
				
	if unit == Global.Player:
		if StateWorld.type == "path":
			ToolMessageCreator.add_message("[color=#c0c0c0]", "길을 걷는다...")
		
		elif StateWorld.Floor_Current <= 1:
			ToolMessageCreator.add_message("[color=#c0c0c0]", "다음 순환에 입장: " + StateWorld.tileset.description + "...")

	
	ProcessQueue.run_queue()
	
	
	
		
			
			
	
		
	
static func check_effects(unit, residence):
	
	
	if StateWorld.day == 0 and StateWorld.Floor_Current == 1 and StateWorld.land != "dust":
		if unit == Global.Player:
			if ToolSettings.settings_data.cycle_current > 1:
				var hp_bonus = float(Global.Player.HP_max) * 0.25
				hp_bonus *= float(ToolSettings.settings_data.cycle_current)
				Global.Player.HP_max += int(hp_bonus)
				Global.Player.HP += int(hp_bonus)
				ToolMessageCreator.add_message("[color=#ff5050]", "순환의 기운이 충전된다...[color=#707070] +" + str(int(hp_bonus)) + " 체력[/color]")
	
			if unit.get_traits().has("Virya"):
				if unit.weapon_off != null:
					event_pickup.virya_starting(unit.weapon_off)
				if unit.weapon_main != null:
					event_pickup.virya_starting(unit.weapon_main)
			
			if unit.get_traits().has("Pallas"):
				if unit.weapon_off != null:
					event_pickup.pallas_starting(unit.weapon_off)
				if unit.weapon_main != null:
					event_pickup.pallas_starting(unit.weapon_main)
			
			if unit.get_traits().has("Ihra"):
				print("IS IHRA ENTRANCE")
				if unit.armor_legs != null:
					event_pickup.ihra_starting(unit.armor_legs)
	
	
	
	
	
	
	
	if ToolSettings.check_and_turn_off_first_play() == true:
		var action = {
			"name": "display_generic", 
			"type": "tab", 
			"data": {
				"icon": "res://Ham_Sprite/Enemies/PriestYellow.png", 
				"dummy": "dummy entry"
			}
		}
		ProcessQueue.add_effect(action)
	
	var unit_traits = unit.get_traits()
	
	
	
	

	
	
	
	
	if unit_traits.has("Zealot"):
		ToolInvokes.zealot_recharge()
	
	
	if unit_traits.has("Apophis"):
		Global.Player.STR += 1
		Global.Player.HP_max += 25
		Global.Player.HP += 25
		ToolMessageCreator.add_message("[color=#a0c0c0]", "찬양하라 [color=#700090]Apophis[/color]! [color=#ff7050]힘[/color] 상승! [color=#707070]+25 체력[/color]")
		if ToolSettings.settings_data.cycle_current > 1:
				var hp_bonus = float(2)
				hp_bonus *= float(ToolSettings.settings_data.cycle_current)
				Global.Player.HP_max += int(hp_bonus)
				Global.Player.HP += int(hp_bonus)
				ToolMessageCreator.add_message("[color=#ff5050]", "순환의 기운이 충전된다...[color=#707070] +" + str(int(hp_bonus)) + " 체력[/color]")
	
		
	
	
	if unit_traits.has("Templar"):
		var buff = cloner.clone_dict(LBuffs.buff_data.Anoint)
		buff["target"] = unit
		buff["source"] = unit
		buff.duration = 2
		var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": unit_traits.Templar.Name
		}
		ProcessQueue.add_effect(action)
	
	if unit_traits.has("Morlock"):
		for n in (4 - unit.get_armor_list().size()):
			
			ToolInvokes.morlock_recharge()
			for m in 1:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.SacredSkin, 
					"summoner": unit, 
					"msg": unit_traits.Morlock.Name
				}
				ProcessQueue.add_effect(action)
			var action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": 0.2 * float(unit.HP_max), 
					"damage_type": "blood", 
					"effect_sprite": "Blood", 
					"msg": unit_traits.Morlock.Name
				}
			ProcessQueue.add_effect(action)
			
			
	
	if unit_traits.has("Alhaja"):
		ToolInvokes.alhaja_recharge()
	
	if unit_traits.has("Liturgist"):
		ToolInvokes.liturgist_recharge()
	
	
	if unit_traits.has("Acolyte"):
		ToolInvokes.acolyte_recharge()
		
	if unit_traits.has("Ihra"):
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
	
	
	if unit_traits.has("BurningOoze"):
		var trait = unit.get_traits().BurningOoze
		for n in trait.Level:
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.ooze, 
					"summoner": unit, 
					"msg": unit_traits.BurningOoze.Name
				}
			ProcessQueue.add_effect(action)
	
	if unit_traits.has("Ormjarl"):
		
		for n in 3:
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.BlueWyrm, 
					"summoner": unit, 
					"msg": unit_traits.Ormjarl.Name
				}
			ProcessQueue.add_effect(action)
	
	
	
	if unit_traits.has("LizardLord"):
		if Global.Player.get_armor_list().size() == 1 and Global.Player.armor_head != null:
			var msg = unit_traits.LizardLord.Name
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
	
	if unit_traits.has("Windblade"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Windstrike)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 3
			var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": unit_traits.Windblade.Name
			}
			ProcessQueue.add_effect(action)
	
	
	if unit_traits.has("Humbaba"):
		var buff = cloner.clone_dict(LBuffs.buff_data.Bloodrage)
		buff["target"] = unit
		buff["source"] = unit
		buff.duration = 2
		var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": unit_traits.Humbaba.Name
			}
		ProcessQueue.add_effect(action)
	
	
	
	if unit_traits.has("Naqui"):
		var buff = cloner.clone_dict(LBuffs.buff_data.Attune)
		buff["target"] = unit
		buff["source"] = unit
		buff.duration = 5
		var increase_duration = 0
		for string in unit.invokes:
			var invoke = unit.invokes[string]
			if invoke.level_required <= unit.level:
				if invoke.use >= invoke.use_max:
					increase_duration += 5
		buff["duration"] += increase_duration
		var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": unit_traits.Naqui.Name
			}
		ProcessQueue.add_effect(action)
	
	if unit_traits.has("Sparkform"):
		var trait = unit.get_traits().Sparkform
		var buff = cloner.clone_dict(LBuffs.buff_data.Sparkform)
		buff["target"] = unit
		buff["source"] = unit
		buff["duration"] = trait.Level * 10
		var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": unit_traits.Sparkform.Name
			}
		ProcessQueue.add_effect(action)
	
	
	if unit_traits.has("RatKing"):
			for n in 5:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.ratman_phalangite, 
					"summoner": unit, 
					"msg": unit_traits.RatKing.Name
				}
				ProcessQueue.add_effect(action)
	
	
	if unit_traits.has("WormMonk"):
			for n in 10:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Crawler, 
					"summoner": unit, 
					"msg": unit_traits.WormMonk.Name
				}
				ProcessQueue.add_effect(action)
	
	
	if unit_traits.has("RatBanner"):
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.ratman_flourisher, 
					"summoner": unit, 
					"msg": unit_traits.RatBanner.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit_traits.has("Hobgang"):
			for n in 2:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LEnemies.enemy_data.hobgoblin, 
					"summoner": unit, 
					"msg": unit_traits.Hobgang.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit_traits.has("Packmaster"):
		var trait = unit.get_traits().Packmaster
		for n in trait.base:
			var action = {
				"name": "summon", 
				"alliance": "ally", 
				"type": LEnemies.enemy_data.hound, 
				"summoner": unit, 
				"msg": unit_traits.Packmaster.Name
			}
			ProcessQueue.add_effect(action)
	
	if unit_traits.has("Arsonist"):
			for n in 10:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Root, 
					"summoner": unit, 
					"msg": unit_traits.Arsonist.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit_traits.has("MinionFeast"):
			for n in unit.get_traits().MinionFeast.Level * 3:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.bloodacolyte, 
					"summoner": unit, 
					"msg": unit_traits.MinionFeast.Name
				}
				ProcessQueue.add_effect(action)
	if unit_traits.has("Shimmergang"):
			for n in unit.get_traits().Shimmergang.Level * 3:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Blinksnake, 
					"summoner": unit, 
					"msg": unit_traits.Shimmergang.Name
				}
				ProcessQueue.add_effect(action)

	if unit_traits.has("WarChant"):
			for n in unit.get_traits().WarChant.Level * 2:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Thrall, 
					"summoner": unit, 
					"msg": unit_traits.WarChant.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit_traits.has("Necromancy"):
			for n in unit.get_traits().Necromancy.Level:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.skeleton, 
					"summoner": unit, 
					"msg": unit_traits.Necromancy.Name
				}
				ProcessQueue.add_effect(action)
				
				var action2 = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.skeleton_archer, 
					"summoner": unit, 
					"msg": unit_traits.Necromancy.Name
				}
				ProcessQueue.add_effect(action2)
	
	if unit_traits.has("BlightCult"):
			for n in unit.get_traits().BlightCult.Level * 3:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.blightpriest, 
					"summoner": unit, 
					"msg": unit_traits.BlightCult.Name
				}
				ProcessQueue.add_effect(action)
	
	
	
	if unit_traits.has("FlameCult"):
			for n in unit.get_traits().FlameCult.Level * 3:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.flamepriest, 
					"summoner": unit, 
					"msg": unit_traits.FlameCult.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit_traits.has("GroveCult"):
			for n in unit.get_traits().GroveCult.Level * 3:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.grovepriest, 
					"summoner": unit, 
					"msg": unit_traits.GroveCult.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit_traits.has("StarCult"):
			for n in unit.get_traits().StarCult.Level * 3:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.StarPriest, 
					"summoner": unit, 
					"msg": unit_traits.StarCult.Name
				}
				ProcessQueue.add_effect(action)
	
	
	
	
	
	
	
	
	
	
	
	if unit_traits.has("Zahan"):
			for n in unit.get_traits().Zahan.Level * 4:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.fireworm, 
					"summoner": unit, 
					"msg": unit_traits.Zahan.Name
				}
				ProcessQueue.add_effect(action)
	
			
				
					
					
					
					
				
				
	

	
	if unit_traits.has("Slaghmaster"):
		var trait = unit.get_traits().Slaghmaster
		for n in trait.base:
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LEnemies.enemy_data.slagh_skirmisher, 
					"summoner": unit, 
					"msg": unit_traits.Slaghmaster.Name
				}
			ProcessQueue.add_effect(action)
	
	
	if unit_traits.has("StaffWarlock"):
			for n in 3:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.bleedingdead, 
					"summoner": unit, 
					"msg": unit_traits.StaffWarlock.Name
				}
				ProcessQueue.add_effect(action)
	
	
	if unit_traits.has("HungryGrave"):
			for n in unit.get_traits().HungryGrave.Level * 1:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.HonoredDead, 
					"summoner": unit, 
					"msg": unit_traits.HungryGrave.Name
				}
				ProcessQueue.add_effect(action)
	
	
	if unit_traits.has("Amir"):
		var amount = int(1 + (unit.level / 5))
		if amount > 10: amount = 10
		for n in amount:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.pilgrim, 
					"summoner": unit, 
					"msg": unit_traits.Amir.Name
				}
				ProcessQueue.add_effect(action)
	
	
	if unit_traits.has("Druid"):
			var amount = 1
			for n in amount:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.boar, 
					"summoner": unit, 
					"msg": unit_traits.Druid.Name
				}
				ProcessQueue.add_effect(action)
	
	
	if unit_traits.has("Uspori"):
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Bukavac, 
					"summoner": unit, 
					"msg": unit_traits.Uspori.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit_traits.has("Stran"):
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.tugar, 
					"summoner": unit, 
					"msg": unit_traits.Stran.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit_traits.has("SummonGrika"):
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.grika, 
					"summoner": unit, 
					"msg": unit_traits.SummonGrika.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit_traits.has("PoisonFamiliar"):
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Tsuchigumo, 
					"summoner": unit, 
					"msg": unit_traits.PoisonFamiliar.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit_traits.has("SummonRedDragon"):
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.RedDragon, 
					"summoner": unit, 
					"msg": unit_traits.SummonRedDragon.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit_traits.has("Bloodcalling"):
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Hemogoblin, 
					"summoner": unit, 
					"msg": unit_traits.Bloodcalling.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit_traits.has("Dumuzi"):
		var unlocked_invokes = 0
		for key in Global.Player.invokes:
			var invoke = Global.Player.invokes[key]
			if invoke.level_required <= Global.Player.level:
				unlocked_invokes += 1
		for n in unlocked_invokes:
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.gilded_dead, 
					"summoner": unit, 
					"msg": unit_traits.Dumuzi.Name
				}
			ProcessQueue.add_effect(action)
	
	
	if unit_traits.has("Formus"):
			
				var ants = ["AntPoison", "AntFire", "AntBlood", "AntAstral"]
				var amount = 1
				
				
					
				for n in amount:
						var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data[ants[Global.rng.randi_range(0, ants.size() - 1)]], 
					"summoner": unit, 
					"msg": unit_traits.Formus.Name
				}
						ProcessQueue.add_effect(action)
	
	
	
	
	if unit_traits.has("Beastmaster"):
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
	
	
	if unit_traits.has("SummonJanin"):
		var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.janin, 
					"summoner": unit, 
					"msg": unit_traits.SummonJanin.Name
				}
		ProcessQueue.add_effect(action)
	
	if unit_traits.has("FulminantCult"):
			for n in unit.get_traits().FulminantCult.Level * 3:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.fulminantpriest, 
					"summoner": unit, 
					"msg": unit_traits.FulminantCult.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit_traits.has("Mura"):
		
		for n in 1:
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.PearlMirror, 
					"summoner": unit, 
					"msg": unit_traits.Mura.Name
				}
			ProcessQueue.add_effect(action)
	
	if unit_traits.has("Hazar"):
		
		var action = {
			"name": "change_tileset_in_area", 
			"tile_target": unit.residence, 
			"tileset": "acid", 
			"effect_range": 3, 
			"effect_sprite": "none"
		}
		ProcessQueue.add_effect(action)
	
	if unit_traits.has("Ninhurs"):
		var r = RandomNumberGenerator.new()
		r.randomize()
		var action = {
			"name": "change_tileset_in_area", 
			"tile_target": Global.game.tile_start, 
			"tileset": "ninhurs", 
			"effect_range": 1, 
			"effect_sprite": "none"
		}
		ProcessQueue.add_effect(action)
		
		var action2 = {
			"name": "change_tileset_in_path", 
			"tile_start": Global.game.tile_start, 
			"tile_end": Global.game.tile_exit, 
			"tileset": "ninhurs", 
			"effect_sprite": "none"
		}
		ProcessQueue.add_effect(action2)
