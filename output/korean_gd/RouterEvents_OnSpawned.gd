extends Node

class_name event_spawn


static func check(unit, alliance):
	
	
	var unit_traits = unit.get_traits()
	
	if unit.object_type == "enemy" and StateWorld.land != "dust":
		if unit.type.boss == true:
			var action = {
				"name": "display_intro", 
				"unit": unit.type, 
				
			}
			ProcessQueue.add_effect(action)
	
		if unit.get_traits().has("Preta"):
			var action = {
			"name": "display_generic", 
			"type": "preta", 
			"data": unit.type, 
			
		}
			ProcessQueue.add_effect(action)
	
	if unit.object_type == "enemy":
		cycler.apply_cycle_bonus(unit, unit.cycle)
	
	if unit.get_name() == "Gilded Dead":
		ToolInvokes.recharge("gilded")
		
	
	
	
	
	
	if unit.get_traits().has("RatKing"):
			for n in 5:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.ratman_phalangite, 
					"summoner": unit, 
					"msg": unit_traits.RatKing.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonRatArchers"):
			for n in 2:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.ratman_archer, 
					"summoner": unit, 
					"msg": unit_traits.SummonRatArchers.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonSebekPriest"):
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.sebek_priest, 
					"summoner": unit, 
					"msg": unit_traits.SummonSebekPriest.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonBuds"):
			for n in 3:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.GlimmeringBud, 
					"summoner": unit, 
					"msg": unit_traits.SummonBuds.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonGranga"):
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.GrangaGutSpiller, 
					"summoner": unit, 
					"msg": unit_traits.SummonGranga.Name
				}
				ProcessQueue.add_effect(action)
				action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.GrangaRadiant, 
					"summoner": unit, 
					"msg": unit_traits.SummonGranga.Name
				}
				ProcessQueue.add_effect(action)
	
	
	if unit.get_traits().has("KingSummon"):
			for n in 3:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.arbiter, 
					"summoner": unit, 
					"msg": unit_traits.KingSummon.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonZealots"):
			for n in 6:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.moroidzealot, 
					"summoner": unit, 
					"msg": unit_traits.SummonZealots.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonAstropedes"):
			for n in 5:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.astropede, 
					"summoner": unit, 
					"msg": unit_traits.SummonAstropedes.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("VariAstropede"):
			for n in 2:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.astropede, 
					"summoner": unit, 
					"msg": unit_traits.VariAstropede.Name
				}
				ProcessQueue.add_effect(action)
	
	
	if unit.get_traits().has("DisgorgeFireSnake"):
			for n in 2:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.fire_snake, 
					"summoner": unit, 
					"msg": unit_traits.DisgorgeFireSnake.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("VariOkopodBeast"):
			for n in 3:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.okopod, 
					"summoner": unit, 
					"msg": unit_traits.VariOkopodBeast.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("VariOkokorpus"):
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.okokorpus, 
					"summoner": unit, 
					"msg": unit_traits.VariOkokorpus.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("VariOkopod"):
			for n in 3:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.okopod, 
					"summoner": unit, 
					"msg": unit_traits.VariOkopod.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("VariTaggla"):
			for n in 2:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.taggla, 
					"summoner": unit, 
					"msg": unit_traits.VariTaggla.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonGoldDemons"):
			for n in 3:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.demongold, 
					"summoner": unit, 
					"msg": unit_traits.SummonGoldDemons.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonMindPalms"):
			for n in 3:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.MindPalm, 
					"summoner": unit, 
					"msg": unit_traits.SummonMindPalms.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonSurtmirs"):
			for n in 3:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.surtmir, 
					"summoner": unit, 
					"msg": unit_traits.SummonSurtmirs.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonBloodGuard"):
			for n in 10:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.BloodWretch, 
					"summoner": unit, 
					"msg": unit_traits.SummonBloodGuard.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonCrestGuard"):
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.FeyBlueCrest, 
					"summoner": unit, 
					"msg": unit_traits.SummonCrestGuard.Name
				}
				ProcessQueue.add_effect(action)
				action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.FeyRedCrest, 
					"summoner": unit, 
					"msg": unit_traits.SummonCrestGuard.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonScouts"):
			for n in 4:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.fey_scout, 
					"summoner": unit, 
					"msg": unit_traits.SummonScouts.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonMouth"):
			for n in 6:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.gibbousmouth, 
					"summoner": unit, 
					"msg": unit_traits.SummonMouth.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonBrungles"):
			for n in 4:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.Brungle, 
					"summoner": unit, 
					"msg": unit_traits.SummonBrungles.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonGiliot"):
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.gore_idol, 
					"summoner": unit, 
					"msg": unit_traits.SummonGiliot.Name
				}
				ProcessQueue.add_effect(action)
			for n in 3:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.giliot, 
					"summoner": unit, 
					"msg": unit_traits.SummonGiliot.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonAgarites"):
			for n in 7:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.agarite, 
					"summoner": unit, 
					"msg": unit_traits.SummonAgarites.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonIcePriests"):
			for n in 5:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.icepriest, 
					"summoner": unit, 
					"msg": unit_traits.SummonIcePriests.Name
				}
				ProcessQueue.add_effect(action)
	if unit.get_traits().has("SummonBurningBody"):
			for n in 2:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.BurningBody, 
					"summoner": unit, 
					"msg": unit_traits.SummonBurningBody.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonBramble"):
			for n in 2:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.Bramble, 
					"summoner": unit, 
					"msg": unit_traits.SummonBramble.Name
				}
				ProcessQueue.add_effect(action)
	
	
	if unit.get_traits().has("SummonEldite"):
			for n in 2:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.Eldite, 
					"summoner": unit, 
					"msg": unit_traits.SummonEldite.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonKiggak"):
			for n in 2:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.Kiggak, 
					"summoner": unit, 
					"msg": unit_traits.SummonKiggak.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonThunderPriest"):
			for n in 2:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.thunder_priest, 
					"summoner": unit, 
					"msg": unit_traits.SummonThunderPriest.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonOrchidWretch"):
			for n in 3:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.orchidwretch, 
					"summoner": unit, 
					"msg": unit_traits.SummonOrchidWretch.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonSkinPriest"):
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.skin_priest, 
					"summoner": unit, 
					"msg": unit_traits.SummonSkinPriest.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonMaskedZealot"):
			for n in 2:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.MaskedZealot, 
					"summoner": unit, 
					"msg": unit_traits.SummonMaskedZealot.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonGehen"):
			for n in 2:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.Gehen, 
					"summoner": unit, 
					"msg": unit_traits.SummonGehen.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonZahrat"):
			for n in 2:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.Zahrat, 
					"summoner": unit, 
					"msg": unit_traits.SummonZahrat.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonFerod"):
			for n in 6:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.Fera, 
					"summoner": unit, 
					"msg": unit_traits.SummonFerod.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonAcroserpents"):
			for n in 4:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.acroserpent, 
					"summoner": unit, 
					"msg": unit_traits.SummonAcroserpents.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonRukThralls"):
			for n in 10:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.RukThrall, 
					"summoner": unit, 
					"msg": unit_traits.SummonRukThralls.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonImps"):
			for n in 9:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.impred, 
					"summoner": unit, 
					"msg": unit_traits.SummonImps.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("Hobgang"):
			for n in 2:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.hobgoblin, 
					"summoner": unit, 
					"msg": unit_traits.Hobgang.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("Packmaster"):
		var trait = unit.get_traits().Packmaster
		for n in trait.base:
			var action = {
				"name": "summon", 
				"alliance": alliance, 
				"type": LEnemies.enemy_data.hound, 
				"summoner": unit, 
				"msg": unit_traits.Packmaster.Name
			}
			ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonIrga"):
	
		for n in 3:
			var action = {
				"name": "summon", 
				"alliance": alliance, 
				"type": LEnemies.enemy_data.irga_guard, 
				"summoner": unit, 
				"msg": unit_traits.SummonIrga.Name
			}
			ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("FleshRetinue"):
	
		for n in 4:
			var action = {
				"name": "summon", 
				"alliance": alliance, 
				"type": LEnemies.enemy_data.dancing_flesh, 
				"summoner": unit, 
				"msg": unit_traits.FleshRetinue.Name
			}
			ProcessQueue.add_effect(action)
		
	if unit.get_traits().has("SummonSebek"):
	
		for n in 1:
			var action = {
				"name": "summon", 
				"alliance": alliance, 
				"type": LEnemies.enemy_data.sebek_warrior, 
				"summoner": unit, 
				"msg": unit_traits.SummonSebek.Name
			}
			ProcessQueue.add_effect(action)
	
	
	if unit.get_traits().has("SummonUmbralith"):
			for n in 4:
				var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.umbralith, 
					"summoner": unit, 
					"msg": unit_traits.SummonUmbralith.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("Slaghmaster"):
		var trait = unit.get_traits().Slaghmaster
		for n in trait.base:
			var action = {
					"name": "summon", 
					"alliance": alliance, 
					"type": LEnemies.enemy_data.slagh_skirmisher, 
					"summoner": unit, 
					"msg": unit_traits.Slaghmaster.Name
				}
			ProcessQueue.add_effect(action)

