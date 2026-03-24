extends Node

class_name event_attack

static func check(attacker, defender, weapon, msg):
	if attacker.get_projectile_art(weapon) != null:
		var e = effectmaker.create_effect(attacker.position, 1, attacker.get_projectile_art(weapon))
		var rot = attacker.position.angle_to_point(defender.position)
		effectmaker.effect_proj(e, attacker.position, defender.position, rad2deg(rot))
	
	if attacker == Global.Player:
		ToolInvokes.recharge("attack")
	
	if attacker == Global.Player and translate.is_bare_fist(weapon):
		ToolInvokes.recharge("attack bare fist")
	if attacker == Global.Player:
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
			ToolInvokes.recharge("adjacent attack")
	if defender == Global.Player:
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
			ToolInvokes.recharge("attacked adjacent")
	
	if msg == "Initial":
		extra_attacks_from_initial(defender, attacker, weapon, msg)
	
	check_effects(attacker, defender, weapon)

	

static func check_effects(attacker, defender, weapon):
	
			
	var defender_traits = defender.get_traits()
	var attacker_traits = attacker.get_traits()
	var player_traits = Global.Player.get_traits()

	add_score(attacker)

	if attacker_traits.has("WindRibbon"):
		
		var action = {
			"name": "magic_damage_tiles_in_path_to_furthest", 
			"caster": attacker, 
			"damage": attacker.get_SPEED() * 10.0, 
			"damage_type": "slash", 
			"effect_sprite": "Wind", 
			"msg": attacker_traits.WindRibbon.Name
				}
		ProcessQueue.add_effect(action)
		
		var speed = int((float(attacker.get_SPEED()) * 0.2))
		if speed >= 1:
			action = {
			"name": "apply_bonus_random_ally", 
			"origin": attacker, 
			"amount": speed, 
			"type": "speed", 
			"msg": attacker_traits.WindRibbon.Name
			}
			ProcessQueue.add_effect(action)

	if attacker_traits.has("Slime"):
		var trait = attacker_traits.Slime
		for n in 1:

				var buff = cloner.clone_dict(LBuffs.buff_data.Corrosion)
				buff["target"] = attacker
				buff["source"] = attacker
				buff.duration = 5 * trait.Level
				var action = {
				"name": "buff_targets_in_range", 
				"caster": attacker, 
				"effect_sprite": "Corrode", 
				"number_of_targets": 3, 
				"effect_range": 3, 
				"buff": buff, 
				"is_allied": false, 
				"msg": attacker_traits.Slime.Name
				}
				ProcessQueue.add_effect(action)

	if attacker_traits.has("BloodDrinker"):
		if calcrange.get_range_between_tiles(attacker.residence, defender.residence) <= 1:
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": float(defender.HP_max) * 0.02, 
					"damage_type": "blood", 
					"effect_sprite": "Blood", 
					"msg": attacker_traits.BloodDrinker.Name
				}
			ProcessQueue.add_effect(action)
	
	
	
	for buff in attacker.Buffs:
		if buff.name == "Bleed":
			if attacker_traits.has("MasterBleed") == false and attacker_traits.has("Damunja") == false:
				var action = {
					"name": "magic_damage_target", 
					"target": buff.target, 
					"caster": buff.source, 
					"damage": 5 * buff.duration, 
					"damage_type": "blood", 
					"effect_sprite": "Blood", 
					"msg": "Bleed"
				}
				ProcessQueue.add_effect(action)
			
		if buff.name == "Dream" or buff.name == "Treeform":
			var action = {
					"name": "remove_buff", 
					"target": attacker, 
					"buff": buff, 
					"msg": "Attacking"
		}
			ProcessQueue.add_effect(action)
		
		if buff.name == "Drakeform":
			var action = {
			"name": "hit_targets_range", 
			"attacker": attacker, 
			"hit": 50.0, 
			"weapon": attacker.weapon_main, 
			"effect_range": 1, 
			"number_of_targets": 8, 
			"msg": "Drakeform"
				}
			ProcessQueue.add_effect(action)
			
			action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": attacker, 
				"damage": 25.0 * buff.duration, 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"effect_range": 2, 
				"msg": "Drakeform"
			}
			ProcessQueue.add_effect(action)
			
		
		if buff.name == "Windstrike":
			
			var action = {
					"name": "remove_buff", 
					"target": attacker, 
					"buff": buff, 
					"msg": "Attacking"
		}
			ProcessQueue.add_effect(action)
			
			for n in buff.duration:

				action = {
				"name": "magic_damage_target", 
				"caster": attacker, 
				"target": defender, 
				"damage": attacker.get_DMG_total(attacker.weapon_main), 
				"damage_type": "slash", 
				"effect_sprite": "Wind", 
				"msg": "Windstrike"
			}
			
				ProcessQueue.add_effect(action)
		
		if buff.name == "Gust":
			
			var action = {
					"name": "remove_buff", 
					"target": attacker, 
					"buff": buff, 
					"msg": "Attacking"
		}
			ProcessQueue.add_effect(action)
			
			for n in buff.duration:

				action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": attacker, 
	"damage": 50.0 + attacker.get_total_DEX(), 
	"damage_type": "slash", 
	"effect_sprite": "Wind", 
	"number_of_targets": 1, 
	"effect_range": 99, 
	"enemies": null, 
	"msg": "Gust"
				}
				ProcessQueue.add_effect(action)
		
	
		if buff.name == "Horrorform":
			
				var action = {
				"name": "magic_damage_target", 
				"caster": attacker, 
				"target": defender, 
				"damage": 1.0 * buff.duration, 
				"damage_type": "astral", 
				"effect_sprite": "Astral", 
				"msg": "Horrorform"
			}
			
				ProcessQueue.add_effect(action)
			
				var new_buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
				new_buff["target"] = defender
				new_buff["source"] = attacker
				new_buff.duration = 10 * buff.duration
				action = {
				"name": "add_buff", 
				"buff": new_buff, 
				"msg": "Horrorform"
			}
				ProcessQueue.add_effect(action)
		
		if buff.name == "Anqarak":
			
				var action = {
				"name": "magic_damage_target", 
				"caster": attacker, 
				"target": defender, 
				"damage": 2.0 * buff.duration, 
				"damage_type": "blood", 
				"effect_sprite": "Blood", 
				"msg": "Anqarak"
			}
			
				ProcessQueue.add_effect(action)
	
		if buff.name == "Lizardform":
			var buff_list = ["Scorch", "Corrosion", "Sickness"]
			
			for buff_name in buff_list:
				var new_buff = cloner.clone_dict(LBuffs.buff_data[buff_name])
				new_buff["target"] = defender
				new_buff["source"] = attacker
				new_buff.duration = 5 * buff.duration
				var action = {
				"name": "add_buff", 
				"buff": new_buff, 
				"msg": "Lizardform"
			}
				ProcessQueue.add_effect(action)
			
			var action = {
			"name": "heal", 
			"amount": 10 * buff.duration, 
			"healer_unit": attacker, 
			"healed_unit": attacker, 
			"msg": "Lizardform"
				}
			ProcessQueue.add_effect(action)
			
	
	for buff in defender.Buffs:
		
		
		if buff.name == "Stasis":
			
			if defender_traits.has("VoidHelm") == false and defender_traits.has("VoidChest") == false and defender_traits.has("NullChausses") == false:
				var duration = 1
				var action = {
					"name": "reduce_buff", 
					"target": defender, 
					"buff": buff, 
					"duration": duration, 
					"msg": "attacked"
		}
				ProcessQueue.add_effect(action)
			
			
		
		
		if buff.name == "Doom":
			if defender_traits.has("MasterDoom") == false:
				var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": buff.source, 
					"damage": 5 * buff.duration, 
					"damage_type": "death", 
					"effect_sprite": "Curse", 
					"msg": "Doom"
				}
				ProcessQueue.add_effect(action)
	
		if buff.name == "Freeze":
			if defender_traits.has("Parafrost") == false and defender_traits.has("VoidMage") == false:
				var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": buff.source, 
					"damage": buff.duration, 
					"damage_type": "blunt", 
					"effect_sprite": "Bash", 
					"msg": "Freeze"
				}
				ProcessQueue.add_effect(action)
	
		if buff.name == "Corrosion":
			
				var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": buff.source, 
					"damage": buff.duration, 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": "Corrosion"
				}
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("PurifyingDisplay"):
		
		for buff in attacker.Buffs:
			if buff.name == "Entangle" or buff.name == "Freeze" or buff.name == "Sickness" or buff.name == "Bleed":
				var action = {
					"name": "remove_buff", 
					"target": attacker, 
					"buff": buff, 
					"msg": attacker_traits.PurifyingDisplay.Name
		}
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("scythescorch") == true:
			var buff = cloner.clone_dict(LBuffs.buff_data.Scorch)
			buff["target"] = defender
			buff["source"] = attacker
			buff.duration = 5
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.scythescorch.Name
			}
			ProcessQueue.add_effect(action)
			for buffs in defender.Buffs:
				if buffs.name == "Scorch":
					action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 15.0 * buffs.duration, 
					"damage_type": "slash", 
					"effect_sprite": "Slash", 
					"msg": attacker_traits.scythescorch.Name
				}
					ProcessQueue.add_effect(action)
	
	if attacker_traits.has("scythevine") == true:
			var buff = cloner.clone_dict(LBuffs.buff_data.Entangle)
			buff["target"] = defender
			buff["source"] = attacker
			buff.duration = 5
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.scythevine.Name
			}
			ProcessQueue.add_effect(action)
			
			for buffs in defender.Buffs:
				if buffs.name == "Entangle":
					action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 15.0 * buffs.duration, 
					"damage_type": "slash", 
					"effect_sprite": "Slash", 
					"msg": attacker_traits.scythevine.Name
				}
					ProcessQueue.add_effect(action)
	
	if attacker_traits.has("DoomBlade") == true:
			var buff = cloner.clone_dict(LBuffs.buff_data.Doom)
			buff["target"] = defender
			buff["source"] = attacker
			buff.duration = 5
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.DoomBlade.Name
			}
			ProcessQueue.add_effect(action)
			for buffs in defender.Buffs:
				if buffs.name == "Doom":
					action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": attacker, 
				"damage": 10.0 * buffs.duration, 
				"damage_type": "death", 
				"effect_sprite": "Curse", 
				"effect_range": 2, 
				"msg": attacker_traits.DoomBlade.Name
			}
					ProcessQueue.add_effect(action)
	
	if defender.object_type == "ally":
		if player_traits.has("PainCleric"):
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": Global.Player, 
					"damage": 100.0, 
					"damage_type": "blood", 
					"effect_sprite": "Blood", 
					"msg": player_traits.PainCleric.Name
				}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Doomsayer"):
		
			var buff = cloner.clone_dict(LBuffs.buff_data.Doom)
			buff["target"] = attacker
			buff["source"] = attacker
			buff.duration = 15
			var action = {
				"name": "buff_tiles_in_range", 
				"caster": attacker, 
				"effect_sprite": "Doom", 
				"effect_range": 3, 
				"buff": buff, 
				"alliance": calcrange.get_enemy_alliance(attacker), 
				"msg": attacker_traits.Doomsayer.Name
			}
			ProcessQueue.add_effect(action)
	
	
	
	if defender_traits.has("FrostKnight") == true:
		var buff = cloner.clone_dict(LBuffs.buff_data.Freeze)
		buff["target"] = attacker
		buff["source"] = defender
		buff.duration = 5
		var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.FrostKnight.Name
			}
		ProcessQueue.add_effect(action)

	if attacker_traits.has("UrBeast"):
		if attacker.get_armor_list().size() == 1 and attacker.armor_head != null:
			var buff = cloner.clone_dict(LBuffs.buff_data.Beastform)
			buff["target"] = attacker
			buff["source"] = attacker
			buff.duration = 1
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.UrBeast.Name
			}
			ProcessQueue.add_effect(action)

	if attacker_traits.has("BeastVisage"):
		if attacker.armor_chest == null:
				var buff = cloner.clone_dict(LBuffs.buff_data.Berserk)
				buff["target"] = attacker
				buff["source"] = attacker
				buff.duration = 8
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.BeastVisage.Name
			}
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("SummonRedDragon"):
				var trait = attacker_traits.SummonRedDragon
				var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
				buff["target"] = attacker
				buff["source"] = attacker
				buff.duration = 4 * trait.Level
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.SummonRedDragon.Name
			}
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Surtmir"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Freeze)
			buff["target"] = attacker
			buff["source"] = attacker
			buff.duration = 5
			var action = {
				"name": "buff_targets_in_range", 
				"caster": attacker, 
				"effect_sprite": "Chill", 
				"number_of_targets": 20, 
				"effect_range": 2, 
				"buff": buff, 
				"is_allied": false, 
				"msg": attacker_traits.Surtmir.Name
				}
			ProcessQueue.add_effect(action)
	
	if attacker.object_type == "ally" or defender.object_type == "ally":
		if player_traits.has("Angra"):
			var target = attacker
			if defender.object_type == "ally":
				target = defender
				var action = {
					"name": "magic_damage_target", 
					"target": target, 
					"caster": target, 
					"damage": float(target.HP_max), 
					"damage_type": "blood", 
					"effect_sprite": "Blood", 
					"msg": player_traits.Angra.Name
				}
				ProcessQueue.add_effect(action)
			if attacker.object_type == "ally":
				target = attacker
				var action = {
					"name": "magic_damage_target", 
					"target": target, 
					"caster": target, 
					"damage": float(target.HP_max), 
					"damage_type": "blood", 
					"effect_sprite": "Blood", 
					"msg": player_traits.Angra.Name
				}
				ProcessQueue.add_effect(action)
	
	if attacker.object_type == "ally":
		if player_traits.has("StaffStasis"):
		
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": Global.Player, 
					"damage": float(attacker.HP_max), 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"msg": player_traits.StaffStasis.Name
				}
			ProcessQueue.add_effect(action)
			
			action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": attacker, 
					"damage": float(attacker.HP_max), 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"msg": player_traits.StaffStasis.Name
				}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("DeathBreath"):
		var action = {
		"name": "magic_damage_targets_range", 
		"caster": attacker, 
		"damage": float(attacker.get_DMG_total(attacker.weapon_main)) * 0.1, 
		"damage_type": "death", 
		"effect_sprite": "Curse", 
		"effect_range": 3, 
		"number_of_targets": 50, 
		"msg": attacker_traits.DeathBreath.Name
			}
		ProcessQueue.add_effect(action)
	
	
	if attacker_traits.has("FireBreath"):
		var action = {
		"name": "magic_damage_targets_range", 
		"caster": attacker, 
		"damage": float(attacker.get_DMG_total(attacker.weapon_main)) * 0.1, 
		"damage_type": "fire", 
		"effect_sprite": "Flame", 
		"effect_range": 3, 
		"number_of_targets": 50, 
		"msg": attacker_traits.FireBreath.Name
			}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Tachi"):
		var action = {
				"name": "magic_damage_targets_range", 
				"caster": attacker, 
				"damage": attacker.get_DMG_total(attacker.weapon_main) * 1.0, 
				"damage_type": "slash", 
				"effect_sprite": "Wind", 
				"effect_range": 1, 
				"number_of_targets": 1, 
				"msg": attacker_traits.Tachi.Name
			}
			
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("RagnaAxe"):
		
		var action = {
				"name": "magic_damage_targets_range", 
				"caster": attacker, 
				"damage": attacker.get_DMG_total(attacker.weapon_main) * 1.0, 
				"damage_type": "ice", 
				"effect_sprite": "Ice", 
				"effect_range": 99, 
				"number_of_targets": 1, 
				"msg": attacker_traits.RagnaAxe.Name
			}
			
		ProcessQueue.add_effect(action)
		
		action = {
				"name": "magic_damage_targets_range", 
				"caster": attacker, 
				"damage": attacker.get_DMG_total(attacker.weapon_main) * 1.0, 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"effect_range": 99, 
				"number_of_targets": 1, 
				"msg": attacker_traits.RagnaAxe.Name
			}
			
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("HelmAmethyst"):
		var action = {
				"name": "magic_damage_targets_range", 
				"caster": attacker, 
				"damage": attacker.get_DMG_total(attacker.weapon_main) * 3.0, 
				"damage_type": "astral", 
				"effect_sprite": "Astral", 
				"effect_range": 1, 
				"number_of_targets": 1, 
				"msg": attacker_traits.HelmAmethyst.Name
			}
			
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Wormform"):
		for check_buff in attacker.Buffs:
				if check_buff.name == "Newtform":
					var buff = cloner.clone_dict(LBuffs.buff_data.Corrosion)
					buff["target"] = attacker
					buff["source"] = attacker
					buff.duration = check_buff.duration * 2
					var action = {
				"name": "buff_tiles_in_range", 
				"caster": attacker, 
				"effect_sprite": "Corrode", 
				"effect_range": 3, 
				"buff": buff, 
				"alliance": calcrange.get_enemy_alliance(attacker), 
				"msg": "Newtform"
			}
					ProcessQueue.add_effect(action)
	if defender_traits.has("Wormform"):
		for check_buff in defender.Buffs:
				if check_buff.name == "Newtform":
					var buff = cloner.clone_dict(LBuffs.buff_data.Corrosion)
					buff["target"] = defender
					buff["source"] = defender
					buff.duration = check_buff.duration * 2
					var action = {
				"name": "buff_tiles_in_range", 
				"caster": defender, 
				"effect_sprite": "Corrode", 
				"effect_range": 3, 
				"buff": buff, 
				"alliance": calcrange.get_enemy_alliance(defender), 
				"msg": "Newtform"
			}
					ProcessQueue.add_effect(action)
	
	
	if player_traits.has("BurningOoze"):
		if attacker.object_type == "ally":
			var damage = player_traits.BurningOoze.Level * 10.0
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": Global.Player, 
					"damage": damage, 
					"damage_type": "poison", 
					"effect_sprite": "PoisonHit", 
					"msg": player_traits.BurningOoze.Name
				}
			ProcessQueue.add_effect(action)
			action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": Global.Player, 
					"damage": damage, 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": player_traits.BurningOoze.Name
				}
			ProcessQueue.add_effect(action)
			
	
	if Global.Allies.has(attacker) and attacker != Global.Player:
		
		if player_traits.has("Necromancy"):
					var trait = player_traits.Necromancy
					var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": Global.Player, 
					"damage": 5.0 * trait.Level, 
					"damage_type": "death", 
					"effect_sprite": "Curse", 
					"msg": player_traits.Necromancy.Name
				}
					ProcessQueue.add_effect(action)
		
		
		if player_traits.has("Hat_Curse"):
				var buff = cloner.clone_dict(LBuffs.buff_data.Doom)
				buff["target"] = defender
				buff["source"] = Global.Player
				buff.duration = 2
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": player_traits.Hat_Curse.Name
			}
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Gladius"):

			
				var buff = cloner.clone_dict(LBuffs.buff_data.Poise)
				buff["target"] = attacker
				buff["source"] = attacker
				buff.duration = 5
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Gladius.Name
			}
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("PilumAmir"):
			
			
			for unit in Global.Allies:
				if unit != Global.Player:
					var action = {
			"name": "apply_bonus", 
			"origin": attacker, 
			"target": unit, 
			"amount": 1.0, 
			"type": "damage", 
			"msg": attacker_traits.PilumAmir.Name
			}
					ProcessQueue.add_effect(action)
	
	if defender_traits.has("StaffGala"):
		var damage_new = float(attacker.HP_max) * 0.05
		var action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": defender, 
					"damage": damage_new, 
					"damage_type": "psychic", 
					"effect_sprite": "Psychic", 
					"msg": defender_traits.StaffGala.Name
				}
		ProcessQueue.add_effect(action)
		
	if attacker_traits.has("Anqarak"):
				var buff = cloner.clone_dict(LBuffs.buff_data.Freeze)
				buff["target"] = defender
				buff["source"] = attacker
				buff.duration = 2
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Anqarak.Name
			}
				ProcessQueue.add_effect(action)
		
				buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
				buff["target"] = defender
				buff["source"] = attacker
				buff.duration = 2
				action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Anqarak.Name
			}
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("GloveFire"):

				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.BurningBlade, 
					"summoner": attacker, 
					"msg": attacker_traits.GloveFire.Name
				}
				ProcessQueue.add_effect(action)
				var buff = cloner.clone_dict(LBuffs.buff_data.Scorch)
				buff["target"] = defender
				buff["source"] = attacker
				buff.duration = attacker.get_total_WIL()
				action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.GloveFire.Name
			}
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("KnifeFire"):

			
				var buff = cloner.clone_dict(LBuffs.buff_data.Scorch)
				buff["target"] = defender
				buff["source"] = attacker
				buff.duration = 10
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.KnifeFire.Name
			}
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("RebelJambiya"):

				var buff = cloner.clone_dict(LBuffs.buff_data.Scorch)
				buff["target"] = defender
				buff["source"] = attacker
				buff.duration = 10
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.RebelJambiya.Name
			}
				ProcessQueue.add_effect(action)
				
				if defender.Buffs.size():
					var target_buff = defender.Buffs[0]
					var lowest_duration = defender.Buffs[0].duration
					for cbuff in defender.Buffs:
						if cbuff.harmful == true:
							if cbuff.duration < lowest_duration:
								lowest_duration = cbuff.duration
								target_buff = cbuff
				
					if target_buff.harmful == true:
						var nbuff = cloner.clone_dict(LBuffs.buff_data[target_buff.title])
						nbuff["target"] = defender
						nbuff["source"] = attacker
						nbuff.duration = int(target_buff.duration)
						action = {
					"name": "add_buff", 
					"buff": nbuff, 
					"msg": attacker_traits.RebelJambiya.Name
			}
						ProcessQueue.add_effect(action)
					
						
	
	if defender_traits.has("Aslan"):
		if defender != attacker:
		
			var hit = 50.0
			var msg = defender_traits.Aslan.Name
			ToolMagicMaker.add_hit_event(attacker, defender, hit, weapon, msg)
	
	if defender_traits.has("HelmJade"):
		if defender != attacker:
			var hit = 0.0
			for buff in defender.Buffs:
				hit += buff.duration
			if hit > 0.0:
				var msg = defender_traits.HelmJade.Name
				ToolMagicMaker.add_hit_event(attacker, defender, hit, weapon, msg)
	
	if attacker_traits.has("Suwag"):
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
			var points = 0
		
			for key in attacker.get_traits():
				var trait = attacker.get_traits()[key]
				if trait.generic == false:
					if trait.title == "GoreCleave":
						
						points += trait.Level * trait.cost
			
			var hit = 50.0 * float(points)
			if hit > 0:
					var action = {
				"name": "magic_damage_tiles_in_line", 
				"target": defender, 
				"caster": attacker, 
				"damage": hit, 
				"damage_type": "blood", 
				"effect_sprite": "Blood", 
				"msg": attacker_traits.Suwag.Name
			}
					ProcessQueue.add_effect(action)
	
	
	if attacker_traits.has("Elementalist"):
		var kinesis_count = 0
		var kinesis_points = 0
		
		for key in attacker.get_traits():
			var trait = attacker.get_traits()[key]
			if trait.generic == false:
				if "kinesis" in textstrip.strip_bbcode(trait.Name).to_lower():
					kinesis_count += 1
					kinesis_points += trait.Level * trait.cost
		
		var hit = float(kinesis_points) * 20.0
		if kinesis_count > 0:
			for n in kinesis_count:
				var msg = attacker_traits.Elementalist.Name
				ToolMagicMaker.add_hit_event(defender, attacker, hit, weapon, msg)
	
	
	if attacker_traits.has("Nihang"):
		var unit = attacker
		var hit = 100.0
		for n in unit.get_charged_invokes():
			var msg = attacker_traits.Nihang.Name
			ToolMagicMaker.add_hit_event(defender, attacker, hit, weapon, msg)
	
	
	if attacker_traits.has("Pallas"):
		if attacker.get_hands_used() == 2:
			
			var damage = 0.1 * float(attacker.get_DMG_total(attacker.weapon_off))
			if damage < 1.0: damage = 1.0
			var action = {
			"name": "magic_damage_targets_range", 
			"caster": attacker, 
			"damage": damage, 
			"damage_type": "pierce", 
			"effect_sprite": "Pierce", 
			"number_of_targets": 2, 
			"effect_range": 2, 
			"msg": attacker_traits.Pallas.Name
				}
			ProcessQueue.add_effect(action)
	
	
	if attacker_traits.has("Hadad"):
		var unit = attacker
		for n in unit.get_charged_invokes():
			
			var new_buff = cloner.clone_dict(LBuffs.buff_data.Charge)
			new_buff["target"] = unit
			new_buff["source"] = unit
			new_buff.duration = 2
			var action = {
				"name": "add_buff", 
				"buff": new_buff, 
				"msg": attacker_traits.Hadad.Name
			}
			ProcessQueue.add_effect(action)
			
			
			action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": unit, 
	"damage": 30.0, 
	"damage_type": "fire", 
	"effect_sprite": "Flame", 
	"number_of_targets": 1, 
	"effect_range": 4, 
	"enemies": null, 
	"msg": attacker_traits.Hadad.Name
				}
			ProcessQueue.add_effect(action)
			action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": unit, 
	"damage": 30.0, 
	"damage_type": "lightning", 
	"effect_sprite": "Zap", 
	"number_of_targets": 1, 
	"effect_range": 4, 
	"enemies": null, 
	"msg": attacker_traits.Hadad.Name
				}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Kashra"):
			for buff in attacker.Buffs:
				if buff.name != "Inflame":
					var action = {
						"name": "remove_buff", 
						"target": attacker, 
						"buff": buff, 
						"msg": attacker_traits.Kashra.Name
						}
					ProcessQueue.add_effect(action)
			
			var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
			buff["target"] = attacker
			buff["source"] = attacker
			buff.duration = 3
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Kashra.Name
				}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Herja"):
		var action = {
			"name": "magic_damage_tiles_in_path_to_furthest", 
			"caster": attacker, 
			"damage": 50.0 * attacker_traits.Herja.Level, 
			"damage_type": "lightning", 
			"effect_sprite": "Zap", 
			"msg": attacker_traits.Herja.Name
				}
		ProcessQueue.add_effect(action)
	
	if defender_traits.has("Frenzied"):
		if Global.Enemies.size() > 0:
			var msg = defender_traits.Frenzied.Name
				
			for check_buff in defender.Buffs:
				
				if check_buff.name == "Inflame":
					var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": defender, 
					"damage": check_buff.duration * 1.0, 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": msg
				}
					ProcessQueue.add_effect(action)
					
					action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": defender, 
					"damage": check_buff.duration * 1.0, 
					"damage_type": "psychic", 
					"effect_sprite": "Psychic", 
					"msg": msg
				}
					ProcessQueue.add_effect(action)
	
	if defender_traits.has("GreenCrown"):
			
			var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
			buff["target"] = defender
			buff["source"] = defender
			buff.duration = 5
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.GreenCrown.Name
				}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("Ashem"):
			
			var buff = cloner.clone_dict(LBuffs.buff_data.Grace)
			buff["target"] = defender
			buff["source"] = defender
			buff.duration = 1
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.Ashem.Name
				}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("VotiveSkirt"):
			
			
			var action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": attacker, 
					"damage": attacker.get_total_DEX(), 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": attacker_traits.VotiveSkirt.Name
				}
			ProcessQueue.add_effect(action)
			
			var buff = cloner.clone_dict(LBuffs.buff_data.Meditate)
			buff["target"] = attacker
			buff["source"] = attacker
			buff.duration = attacker.get_total_DEX()
			action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.VotiveSkirt.Name
				}
			ProcessQueue.add_effect(action)
	
	
	if defender_traits.has("VotiveHelm"):
			
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": defender, 
					"damage": defender.get_total_WIL(), 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": defender_traits.VotiveHelm.Name
				}
			ProcessQueue.add_effect(action)
			
			var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
			buff["target"] = defender
			buff["source"] = defender
			buff.duration = defender.get_total_WIL()
			action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.VotiveHelm.Name
				}
			ProcessQueue.add_effect(action)
	
	
	if defender_traits.has("VoidHelm"):
			
			var buff = cloner.clone_dict(LBuffs.buff_data.Stasis)
			buff["target"] = defender
			buff["source"] = defender
			buff.duration = 2
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.VoidHelm.Name
				}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Anwar"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Blind)
			buff["target"] = defender
			buff["source"] = attacker
			buff.duration = attacker.get_total_DEX()
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Anwar.Name
				}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("DullGoldMantle"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Blind)
			buff["target"] = attacker
			buff["source"] = defender
			buff.duration = 3
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.DullGoldMantle.Name
				}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("PsychicRetort"):
		var trait = defender_traits.PsychicRetort
		var buff = cloner.clone_dict(LBuffs.buff_data.Repulsion)
		buff["target"] = defender
		buff["source"] = defender
		buff.duration = 5 * trait.Level
		var action2 = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.PsychicRetort.Name
			}
		ProcessQueue.add_effect(action2)
	
	
	
			
			
			
				
				
				
				
				
			
			
			
			
		
		
		
		
		
			
			
			
			
			
	
	if defender_traits.has("DreadHoplon"):
					var action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": defender, 
					"damage": float(defender.get_block_strength()) * 0.5, 
					"damage_type": "death", 
					"effect_sprite": "Curse", 
					"msg": defender_traits.DreadHoplon.Name
				}
					ProcessQueue.add_effect(action)
	if defender_traits.has("Apophis"):
					var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": defender, 
					"damage": 0.07 * float(defender.HP_max), 
					"damage_type": "astral", 
					"effect_sprite": "AFlame", 
					"msg": defender_traits.Apophis.Name
				}
					ProcessQueue.add_effect(action)
	
	
	if defender_traits.has("SunHelm"):
			
			var buff = cloner.clone_dict(LBuffs.buff_data.Blind)
			buff["target"] = attacker
			buff["source"] = defender
			buff.duration = defender.get_total_WIL()
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.SunHelm.Name
				}
			ProcessQueue.add_effect(action)
			
			for cbuff in attacker.Buffs:
				if cbuff.name == "Blind":
					
					action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": defender, 
					"damage": cbuff.duration * 5.0, 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": defender_traits.SunHelm.Name
				}
					ProcessQueue.add_effect(action)
					
					action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": defender, 
					"damage": cbuff.duration * 5.0, 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"msg": defender_traits.SunHelm.Name
				}
					ProcessQueue.add_effect(action)
	
	if defender.object_type == "ally" and Global.Player.is_dead() == false:
		if defender.type.title == "PearlMirror":
			
			var reflect_damage = attacker.get_DMG_total(null)
			if attacker == Global.Player:
				reflect_damage = attacker.get_DMG_total(attacker.weapon_main)
			var action = {
				"name": "magic_damage_targets_range", 
			"caster": Global.Player, 
			"damage": 0.2 * reflect_damage, 
			"damage_type": "astral", 
			"effect_sprite": "Astral", 
			"effect_range": 4, 
			"number_of_targets": 1, 
			"msg": Global.Player.get_traits().Mura.Name
				}
			ProcessQueue.add_effect(action)
			
			action = {
				"name": "magic_damage_targets_range", 
			"caster": Global.Player, 
			"damage": 0.2 * reflect_damage, 
			"damage_type": "ice", 
			"effect_sprite": "Ice", 
			"effect_range": 4, 
			"number_of_targets": 1, 
			"msg": Global.Player.get_traits().Mura.Name
				}
			ProcessQueue.add_effect(action)
	
	if defender.get_traits().has("UrBeast"):
		for buff in defender.Buffs:
			if buff.name == "Beastform":
				for n in buff.duration:
					var action = {
			"name": "attack_targets", 
			"attacker": defender, 
			"number_of_targets": 1, 
			"msg": "Beastform"
		}
	
					ProcessQueue.add_effect(action)
	
	if defender.get_traits().has("Samnite"):
		var action = {
			"name": "attack_targets", 
			"attacker": defender, 
			"number_of_targets": 1, 
			"msg": defender_traits.Samnite.Name
		}
	
		ProcessQueue.add_effect(action)

		action = {
					"name": "heal", 
					"amount": 1.0 * defender.get_total_STR(), 
					"healer_unit": defender, 
					"healed_unit": defender, 
					"msg": defender_traits.Samnite.Name
				}
		ProcessQueue.add_effect(action)
	
	if defender_traits.has("Gliva"):
		if Global.Enemies.size() > 0:
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Mushroom, 
					"summoner": defender, 
					"msg": defender_traits.Gliva.Name
				}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("WormMonk"):
		if Global.Enemies.size() > 0:
			for n in 2:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Crawler, 
					"summoner": defender, 
					"msg": defender_traits.WormMonk.Name
				}
				ProcessQueue.add_effect(action)
	
	if defender_traits.has("MasterScorch"):
			var trait = defender_traits.MasterScorch
			
			var sbuff = cloner.clone_dict(LBuffs.buff_data.Scorch)
			sbuff["target"] = defender
			sbuff["source"] = defender
			sbuff.duration = trait.Level
			var action = {
				"name": "add_buff", 
				"buff": sbuff, 
				"msg": defender_traits.MasterScorch.Name
				}
			ProcessQueue.add_effect(action)
			
			
			var scorch_duration = 0
			for buff in defender.Buffs:
				if buff.name == "Scorch":
					scorch_duration += buff.duration
				
			if scorch_duration > 0:
				action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": defender, 
				"damage": scorch_duration * trait.Level * 5.0, 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"effect_range": 1, 
				"msg": defender_traits.MasterScorch.Name
			}
				ProcessQueue.add_effect(action)
				
				action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": defender, 
					"damage": scorch_duration * trait.Level * 5.0, 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": defender_traits.MasterScorch.Name
				}
				ProcessQueue.add_effect(action)
			
			
	
			
				
	if attacker_traits.has("MasterBleed"):
			var trait = attacker_traits.MasterBleed
			var buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
			buff["target"] = attacker
			buff["source"] = attacker
			buff.duration = 5 * trait.Level
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.MasterBleed.Name
				}
			ProcessQueue.add_effect(action)
	
	
		
	
	if attacker_traits.has("DisgorgeWretch") == true:
			var action = {
					"name": "summon", 
					"alliance": "enemy", 
					"type": LEnemies.enemy_data.golden_wretch, 
					"summoner": attacker, 
					"msg": attacker_traits.DisgorgeWretch.Name
				}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("DisgorgeFireSnake") == true:
			var action = {
					"name": "summon", 
					"alliance": "enemy", 
					"type": LEnemies.enemy_data.fire_snake, 
					"summoner": attacker, 
					"msg": attacker_traits.DisgorgeFireSnake.Name
				}
			ProcessQueue.add_effect(action)
	
	
	if attacker_traits.has("Brud"):
		
			var buff_duration = 0
			for buff in defender.Buffs:
				if buff.name == "Sickness" or buff.name == "Doom" or buff.name == "Bleed" or buff.name == "Plague":
					buff_duration += buff.duration
			
		
			if buff_duration > 0:
				var action = {
			"name": "heal", 
			"amount": buff_duration, 
			"healer_unit": attacker, 
			"healed_unit": attacker, 
			"msg": attacker_traits.Brud.Name
				}
				ProcessQueue.add_effect(action)
	
	
	if attacker_traits.has("RapidStrikes"):
		if translate.is_bare_fist(weapon):
			var trait = attacker_traits.RapidStrikes
			var hit = 20.0
			for n in trait.Level:
				var msg = attacker_traits.RapidStrikes.Name
				ToolMagicMaker.add_hit_event(defender, attacker, hit, weapon, msg)
	
	
	if attacker_traits.has("Tengu"):
		
		var action = {
				"name": "magic_damage_targets_range", 
			"caster": attacker, 
			"damage": 50.0, 
			"damage_type": "lightning", 
			"effect_sprite": "Zap", 
			"number_of_targets": 1, 
			"effect_range": 99, 
			"msg": attacker_traits.Tengu.Name
				}
		ProcessQueue.add_effect(action)
		
		var buff = cloner.clone_dict(LBuffs.buff_data.Charge)
		buff["target"] = attacker
		buff["source"] = attacker
		buff["duration"] = 2
		action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": attacker_traits.Tengu.Name
		}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("GoldenSword"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
			buff["target"] = attacker
			buff["source"] = attacker
			buff["duration"] = 5
			var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": attacker_traits.GoldenSword.Name
		}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("DragonSword"):
		
		if attacker.get_hands_used() == 1:
			var action = {
					"name": "magic_damage_tiles_in_range", 
				"caster": attacker, 
				"damage": float(attacker.get_DMG_total(attacker.weapon_main)) * 0.1, 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"effect_range": 4, 
				"msg": attacker_traits.DragonSword.Name
				}
			ProcessQueue.add_effect(action)
		
			var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
			buff["target"] = attacker
			buff["source"] = attacker
			buff["duration"] = 10
			action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": attacker_traits.DragonSword.Name
		}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Mask_Frenzy"):
		
		
		for buff in attacker.Buffs:
			if buff.name == "Inflame":
				var action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": attacker, 
					"damage": 3.0 * buff.duration, 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": attacker_traits.Mask_Frenzy.Name
				}
				ProcessQueue.add_effect(action)
				
				action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 3.0 * buff.duration, 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": attacker_traits.Mask_Frenzy.Name
				}
				ProcessQueue.add_effect(action)
		
		var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
		buff["target"] = attacker
		buff["source"] = attacker
		buff["duration"] = 2
		var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": attacker_traits.Mask_Frenzy.Name
		}
		ProcessQueue.add_effect(action)
	
	if defender.object_type == "ally":
		
		if Global.Player.get_traits().has("Topheth"):
				var damage = 500.0
				var msg = Global.Player.get_traits().Topheth.Name
				ToolMagicMaker.add_hit_event(defender, Global.Player, damage, Global.Player.weapon_main, msg)
	
	if attacker.object_type == "ally":
		
		if Global.Player.get_traits().has("Topheth"):
				var damage = 500.0
				var msg = Global.Player.get_traits().Topheth.Name
				ToolMagicMaker.add_hit_event(attacker, Global.Player, damage, Global.Player.weapon_main, msg)
	
	if attacker_traits.has("Vinakinesis") == true:
		
			var buff = cloner.clone_dict(LBuffs.buff_data.Entangle)
			buff["target"] = defender
			buff["source"] = attacker
			buff.duration = 5
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Vinakinesis.Name
			}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Acolyte"):
		
			var action = {
				"name": "magic_damage_target", 
				"caster": attacker, 
				"target": attacker, 
				"damage": float(attacker.get_total_WIL()), 
				"damage_type": "psychic", 
				"effect_sprite": "PsychicDark", 
				"msg": attacker_traits.Acolyte.Name
			}
			ProcessQueue.add_effect(action)
	
	
	if attacker_traits.has("Aqliyya") == true:
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true and attacker.get_hands_used() == 1:
			var action = {
			"name": "hit_targets_range", 
			"attacker": attacker, 
			"hit": attacker.get_DMG_total(attacker.weapon_main) * 1.0, 
			"weapon": attacker.weapon_main, 
			"effect_range": 99, 
			"number_of_targets": 1, 
			"msg": attacker_traits.Aqliyya.Name
				}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("DreadHelm") == true:
		
			var action = {
			"name": "hit_targets_range", 
			"attacker": attacker, 
			"hit": attacker.get_DMG_total(attacker.weapon_main) * 0.25, 
			"weapon": attacker.weapon_main, 
			"effect_range": 99, 
			"number_of_targets": 1, 
			"msg": attacker_traits.DreadHelm.Name
				}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Bash") == true:
		if attacker.get_hands_used() == 1:
			var action = {
			"name": "hit_targets_range", 
			"attacker": attacker, 
			"hit": 0.3 * float(attacker.HP_max), 
			"weapon": attacker.weapon_main, 
			"effect_range": 1, 
			"number_of_targets": 1, 
			"msg": attacker_traits.Bash.Name
				}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Arbestus") == true:
			if Global.Enemies.size():
				var perform_times = 1
				if attacker.get_hands_used() == 2:
					if translate.is_bare_fist(attacker.weapon_main): perform_times += 1
					if translate.is_bare_fist(attacker.weapon_off): perform_times += 1
				elif translate.is_bare_fist(attacker.weapon_main): perform_times += 1
		
				for n in perform_times:
					var action = {
			"name": "hit_targets_range", 
			"attacker": attacker, 
			"hit": 10.0, 
			"weapon": attacker.weapon_main, 
			"effect_range": 2, 
			"number_of_targets": 1, 
			"msg": attacker_traits.Arbestus.Name
			
				}
					ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Ape"):
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
				var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
				buff["target"] = attacker
				buff["source"] = attacker
				buff.duration = attacker.get_total_STR()
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Ape.Name
			}
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("IllManica"):
		if translate.is_bare_fist(weapon):
			var action = {
				"name": "magic_damage_target", 
				"caster": attacker, 
				"target": defender, 
				"damage": 10.0 * float(attacker.get_total_WIL()), 
				"damage_type": "poison", 
				"effect_sprite": "PoisonHit", 
				"msg": attacker_traits.IllManica.Name
			}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Dastaana"):
		if translate.is_bare_fist(weapon):
				var buff = cloner.clone_dict(LBuffs.buff_data.Charge)
				buff["target"] = attacker
				buff["source"] = attacker
				buff.duration = attacker.get_total_DEX()
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Dastaana.Name
			}
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("LeechStyle"):
		if translate.is_bare_fist(weapon):
			var action = {
			"name": "heal", 
			"amount": 1.0 * attacker.get_total_DEX(), 
			"healer_unit": attacker, 
			"healed_unit": attacker, 
			"msg": attacker_traits.LeechStyle.Name
				}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Hemogoblin"):
			var action = {
			"name": "heal", 
			"amount": 100, 
			"healer_unit": attacker, 
			"healed_unit": attacker, 
			"msg": attacker_traits.Hemogoblin.Name
				}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Vineform"):
		if attacker.get_buff_names().has("Vineform"):
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Root, 
					"summoner": attacker, 
					"msg": attacker_traits.Vineform.Name
				}
			ProcessQueue.add_effect(action)
			
			for buff in attacker.Buffs:
				if buff.name == "Vineform":
					for unit in Global.Allies:
						if unit != Global.Player:
							if unit.type.tags.has("[color=#00a000]Plant[/color]"):
								action = {
			"name": "apply_bonus", 
			"origin": attacker, 
			"target": unit, 
			"amount": 1.0 * buff.duration, 
			"type": "damage", 
			"msg": "Vineform"
			}
								ProcessQueue.add_effect(action)
							
							if unit.HP < unit.HP_max:
								action = {
			"name": "heal", 
			"amount": 5.0 * buff.duration, 
			"healer_unit": attacker, 
			"healed_unit": unit, 
			"msg": "Vineform"
			}
								ProcessQueue.add_effect(action)
					
	
	if attacker_traits.has("helm_dark"):
		
		if defender.get_buff_names().has("Doom"):
		
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.cadaver, 
					"summoner": attacker, 
					"msg": attacker_traits.helm_dark.Name
				}
			ProcessQueue.add_effect(action)
	
	
	if attacker_traits.has("Stormcalling"):
		var trait = attacker_traits.Stormcalling
		for n in trait.Level * 2:
			var action = {
					"name": "summon_random", 
					"alliance": "ally", 
					"type": LAllies.ally_data.BallLightning, 
					"summoner": attacker, 
					"msg": attacker_traits.Stormcalling.Name
				}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Mend25"):
		var trait = attacker_traits.Mend25
		var action = {
		"name": "heal_allies_in_range", 
		"caster": attacker, 
		"amount": trait.base, 
		"effect_range": 2, 
		"msg": attacker_traits.Mend25.Name
			}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Mend50"):
		var trait = attacker_traits.Mend50
		var action = {
		"name": "heal_allies_in_range", 
		"caster": attacker, 
		"amount": trait.base, 
		"msg": attacker_traits.Mend50.Name, 
		"effect_range": 2
			}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Mend200"):
		var trait = attacker_traits.Mend200
		var action = {
		"name": "heal_allies_in_range", 
		"caster": attacker, 
		"amount": trait.base, 
		"effect_range": 2, 
		"msg": attacker_traits.Mend200.Name
			}
		ProcessQueue.add_effect(action)

	if attacker_traits.has("Apostle"):
		var action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": attacker, 
					"damage": 15.0, 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"msg": attacker_traits.Apostle.Name
				}
		ProcessQueue.add_effect(action)


	if attacker_traits.has("TikaaniCrook"):
		
		var damage = float(attacker.get_total_STR() * attacker.get_total_weight())
		
		if damage < 1.0: damage = 1.0
		
		if translate.is_bare_fist(attacker.weapon_main):
			var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": attacker, 
				"damage": damage, 
				"damage_type": "psychic", 
				"effect_sprite": "Psychic", 
				"effect_range": 1, 
				"msg": attacker_traits.TikaaniCrook.Name
			}
			ProcessQueue.add_effect(action)
		
		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": attacker, 
				"damage": damage, 
				"damage_type": "ice", 
				"effect_sprite": "Ice", 
				"effect_range": 1, 
				"msg": attacker_traits.TikaaniCrook.Name
			}
		ProcessQueue.add_effect(action)
		
		


	if attacker_traits.has("Cyclops"):
		
		var damage = 0.5 * float(attacker.HP)
		if damage < 1.0: damage = 1.0
		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": attacker, 
				"damage": damage, 
				"damage_type": "blunt", 
				"effect_sprite": "Bash", 
				"effect_range": 1, 
				"msg": attacker_traits.Cyclops.Name
			}
		ProcessQueue.add_effect(action)

	if defender_traits.has("Merzot"):
		
		var damage = 0.1 * defender.HP_max
		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": defender, 
				"damage": damage, 
				"damage_type": "blood", 
				"effect_sprite": "Blood", 
				"effect_range": 2, 
				"msg": defender_traits.Merzot.Name
			}
		ProcessQueue.add_effect(action)
		action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": defender, 
				"damage": damage, 
				"damage_type": "poison", 
				"effect_sprite": "PoisonHit", 
				"effect_range": 2, 
				"msg": defender_traits.Merzot.Name
			}
		ProcessQueue.add_effect(action)

	if attacker_traits.has("GoreCleave"):
		var trait = attacker_traits.GoreCleave
		var damage = 100.0 * trait.Level
		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": attacker, 
				"damage": damage, 
				"damage_type": "blood", 
				"effect_sprite": "Blood", 
				"effect_range": 1, 
				"msg": attacker_traits.GoreCleave.Name
			}
		ProcessQueue.add_effect(action)
		
		action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": attacker, 
					"damage": 15.0, 
					"damage_type": "slash", 
					"effect_sprite": "Slash", 
					"msg": attacker_traits.GoreCleave.Name
				}
		ProcessQueue.add_effect(action)

	if attacker_traits.has("Berserker"):
		
		
	
		var action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": attacker, 
					"damage": 15.0, 
					"damage_type": "death", 
					"effect_sprite": "Curse", 
					"msg": attacker_traits.Berserker.Name
				}
		ProcessQueue.add_effect(action)
		
		action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": attacker, 
					"damage": 15.0, 
					"damage_type": "blood", 
					"effect_sprite": "Blood", 
					"msg": attacker_traits.Berserker.Name
				}
		ProcessQueue.add_effect(action)
		
		action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": attacker, 
					"damage": 15.0, 
					"damage_type": "ice", 
					"effect_sprite": "Ice", 
					"msg": attacker_traits.Berserker.Name
				}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Sparkform"):
		
		var damage = 10
		var spark_duration = 0
		for buff in attacker.Buffs:
			if buff.name == "Sparkform":
				spark_duration += buff.duration
		damage *= spark_duration
		
		if spark_duration > 0:
			var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": attacker, 
				"damage": damage, 
				"damage_type": "lightning", 
				"effect_sprite": "Zap", 
				"effect_range": 2, 
				"msg": "Sparkform"
			}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Oozemancer"):
		for ally in Global.Allies:
			if ally != Global.Player:
				if ally.type.title == "ooze":
					var action = {
			"name": "attack_targets", 
			"attacker": ally, 
			"number_of_targets": 1, 
			"msg": attacker_traits.Oozemancer.Name
		}
					ProcessQueue.add_effect(action)

	if attacker_traits.has("ProjectiveAura"):
			var action = {
				"name": "delayed_magic_damage_tiles_in_range", 
				"caster": attacker, 
				"damage": attacker.get_DMG_max(null), 
				"damage_type": attacker.get_DMG_type(null), 
				"effect_sprite": translate.dmgtype_to_animation(attacker.get_DMG_type(null)), 
				"effect_range": 1, 
				"msg": "Projective Aura"
			}
			ProcessQueue.add_effect(action)

	if attacker_traits.has("Whirl"):
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
			
			var damage = 50.0
			if attacker == Global.Player:
				damage = attacker.get_SPEED() * 3.0
			var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": attacker, 
				"damage": damage, 
				"damage_type": "slash", 
				"effect_sprite": "Wind", 
				"effect_range": 1, 
				"msg": attacker_traits.Whirl.Name
			}
			ProcessQueue.add_effect(action)

	if attacker.object_type == "ally":
			if player_traits.has("Plaguedrinking") == true:
				var buff = cloner.clone_dict(LBuffs.buff_data.Plague)
				buff["target"] = defender
				buff["source"] = Global.Player
				buff.duration = player_traits.Plaguedrinking.Level * 2
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": player_traits.Plaguedrinking.Name
			}
				ProcessQueue.add_effect(action)

	if attacker != Global.Player:
		if Global.Allies.has(attacker):
			if player_traits.has("Mask_Vine") == true:
				var buff = cloner.clone_dict(LBuffs.buff_data.Entangle)
				buff["target"] = defender
				buff["source"] = Global.Player
				buff.duration = 1
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": player_traits.Mask_Vine.Name
			}
				ProcessQueue.add_effect(action)

	if defender_traits.has("CorrosionSkin") == true:
		var buff = cloner.clone_dict(LBuffs.buff_data.Corrosion)
		buff["target"] = attacker
		buff["source"] = defender
		buff.duration = 2
		var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.CorrosionSkin.Name
			}
		ProcessQueue.add_effect(action)
	
	if defender_traits.has("SicknessSkin") == true:
		var buff = cloner.clone_dict(LBuffs.buff_data.Sickness)
		buff["target"] = attacker
		buff["source"] = defender
		buff.duration = 2
		var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.SicknessSkin.Name
			}
		ProcessQueue.add_effect(action)
	
	if defender_traits.has("DoomSkin") == true:
		var buff = cloner.clone_dict(LBuffs.buff_data.Doom)
		buff["target"] = attacker
		buff["source"] = defender
		buff.duration = 2
		var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.DoomSkin.Name
			}
		ProcessQueue.add_effect(action)

	if attacker_traits.has("PoisonPalm") == true:
		
		var trait = attacker.get_traits().PoisonPalm
		var action2 = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 30.0 * trait.Level, 
					"damage_type": "poison", 
					"effect_sprite": "PoisonHit", 
					"msg": attacker_traits.PoisonPalm.Name
				}
		ProcessQueue.add_effect(action2)

	if attacker_traits.has("SubtleKnife") == true:
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
	
			var action2 = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 10.0 * attacker.get_total_DEX(), 
					"damage_type": "pierce", 
					"effect_sprite": "Pierce", 
					"msg": attacker_traits.SubtleKnife.Name
				}
			ProcessQueue.add_effect(action2)
	
					
	
	if attacker_traits.has("knifebleed") == true:
		var buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
		buff["target"] = defender
		buff["source"] = attacker
		buff.duration = 2
		var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.knifebleed.Name
			}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("AcidKnife") == true:
		var buff = cloner.clone_dict(LBuffs.buff_data.Corrosion)
		buff["target"] = defender
		buff["source"] = attacker
		buff.duration = 2
		var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.AcidKnife.Name
			}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("knifepoison") == true:
		var buff = cloner.clone_dict(LBuffs.buff_data.Sickness)
		buff["target"] = defender
		buff["source"] = attacker
		buff.duration = 2
		var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.knifepoison.Name
			}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Dianmai") == true:
		if translate.is_bare_fist(weapon):
			var buff = cloner.clone_dict(LBuffs.buff_data.Sickness)
			buff["target"] = defender
			buff["source"] = attacker
			buff.duration = 5
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Dianmai.Name
			}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Gehibah"):
			
				
			var action = {
					"name": "magic_damage_tiles_in_range", 
					"caster": attacker, 
					"damage": attacker.HP_max - attacker.HP + 1, 
					"damage_type": "death", 
					"effect_sprite": "Curse", 
					"effect_range": 1, 
					"msg": attacker_traits.Gehibah.Name
				}
			ProcessQueue.add_effect(action)
	
	
	if attacker_traits.has("Jishu"):
		
	
			var action = {
				"name": "magic_damage_tiles_in_path_to_targets_in_range", 
				"caster": attacker, 
				"damage": attacker.get_SPEED() * 6, 
				"damage_type": "poison", 
				"effect_sprite": "PoisonHit", 
				"number_of_targets": 2, 
				"effect_range": 3, 
				"enemies": null, 
				"msg": attacker_traits.Jishu.Name
				
				}
			ProcessQueue.add_effect(action)
			
	
	if attacker_traits.has("Impact"):
		
			var action = {
				"name": "magic_damage_target", 
				"target": defender, 
				"caster": attacker, 
				"damage": float(attacker.get_DMG_total(weapon)) * 0.1, 
				"damage_type": attacker.get_DMG_type(weapon), 
				"effect_sprite": translate.dmgtype_to_animation(attacker.get_DMG_type(weapon)), 
				"msg": attacker_traits.Impact.Name
			}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("ProjectiveRetort"):
		
			var action = {
				"name": "delayed_damage_target", 
				"target": attacker, 
				"caster": defender, 
				"damage": float(defender.get_DMG_total(null)), 
				"damage_type": defender.get_DMG_type(null), 
				"effect_sprite": translate.dmgtype_to_animation(defender.get_DMG_type(null)), 
				"msg": defender_traits.ProjectiveRetort.Name
			}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("Retort"):
		
			var defender_weapon = null
			var action = {
				"name": "magic_damage_target", 
				"target": attacker, 
				"caster": defender, 
				"damage": float(defender.get_DMG_total(defender_weapon)) * 0.1, 
				"damage_type": defender.get_DMG_type(defender_weapon), 
				"effect_sprite": translate.dmgtype_to_animation(defender.get_DMG_type(defender_weapon)), 
				"msg": defender_traits.Retort.Name
			}
			ProcessQueue.add_effect(action)
	
	
	if attacker_traits.has("Ara") == true:
		var trait = attacker.get_traits().Ara
		var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 30.0 * trait.Level, 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"msg": attacker_traits.Ara.Name
				}
		ProcessQueue.add_effect(action)
	
	
	if attacker_traits.has("Pulwar") == true:
		var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": float(defender.HP_max) * 0.02, 
					"damage_type": "slash", 
					"effect_sprite": "Slash", 
					"msg": attacker_traits.Pulwar.Name
				}
		ProcessQueue.add_effect(action)
	
	
	
	if attacker_traits.has("LapisGlaive") == true:
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
			
			var action = {
				"name": "magic_damage_tiles_in_line", 
				"target": defender, 
				"caster": attacker, 
				"damage": 100.0, 
				"damage_type": "lightning", 
				"effect_sprite": "Zap", 
				"msg": attacker_traits.LapisGlaive.Name
			}
			ProcessQueue.add_effect(action)
			
			action = {
				"name": "magic_damage_tiles_in_line", 
				"target": defender, 
				"caster": attacker, 
				"damage": 100.0, 
				"damage_type": "astral", 
				"effect_sprite": "Astral", 
				"msg": attacker_traits.LapisGlaive.Name
			}
			ProcessQueue.add_effect(action)
			action = {
				"name": "magic_damage_tiles_in_line", 
				"target": defender, 
				"caster": attacker, 
				"damage": 100.0, 
				"damage_type": "pierce", 
				"effect_sprite": "Pierce", 
				"msg": attacker_traits.LapisGlaive.Name
			}
			ProcessQueue.add_effect(action)
			
			
			var buff = cloner.clone_dict(LBuffs.buff_data.Meditate)
			buff["target"] = attacker
			buff["source"] = attacker
			buff["duration"] = 5
			action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": attacker_traits.LapisGlaive.Name
		}
			ProcessQueue.add_effect(action)
			
			

	
	if attacker.object_type == "enemy":
		var unit = attacker
		if Global.Player.get_traits().has("Dudar"):
			if Global.Player.invokes.eird.use < Global.Player.invokes.eird.use_max:
				
				
					var buffadd = cloner.clone_dict(LBuffs.buff_data.Corrosion)
					buffadd["target"] = unit
					buffadd["source"] = Global.Player
					buffadd.duration = 3
					var action2 = {
				"name": "add_buff", 
				"buff": buffadd, 
				"msg": Global.Player.get_traits().Dudar.Name
			}
					ProcessQueue.add_effect(action2)
					
					for buff in unit.Buffs:
						if buff.name == "Corrosion":
							var action = {
							"name": "heal", 
							"amount": buff.duration, 
							"healer_unit": Global.Player, 
							"healed_unit": Global.Player, 
							"msg": Global.Player.get_traits().Dudar.Name
			}
							ProcessQueue.add_effect(action)
							action = {
								"name": "magic_damage_target", 
								"target": unit, 
								"caster": Global.Player, 
								"damage": buff.duration, 
								"damage_type": "psychic", 
								"effect_sprite": "Psychic", 
								"msg": Global.Player.get_traits().Dudar.Name
				}
							ProcessQueue.add_effect(action)

	if defender_traits.has("Naqui") == true:
		var buff = cloner.clone_dict(LBuffs.buff_data.Attune)
		buff["target"] = defender
		buff["source"] = defender
		buff.duration = 1
		var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.Naqui.Name
				}
		ProcessQueue.add_effect(action)

	if defender_traits.has("Dorok") == true:
		var buff = cloner.clone_dict(LBuffs.buff_data.Poise)
		buff["target"] = defender
		buff["source"] = defender
		buff.duration = 3
		var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.Dorok.Name
				}
		ProcessQueue.add_effect(action)

	if defender_traits.has("RubyNecklace") == true:
		
		var action = {
				"name": "magic_damage_tiles_in_path_to_targets_in_range", 
				"caster": defender, 
				"damage": 10.0 * defender.get_total_WIL(), 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"number_of_targets": 2, 
				"effect_range": 99, 
				"enemies": null, 
				"msg": defender_traits.RubyNecklace.Name
				
				}
		ProcessQueue.add_effect(action)
		var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
		buff["target"] = defender
		buff["source"] = defender
		buff.duration = int(defender.get_total_WIL())
		action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.RubyNecklace.Name
				}
		ProcessQueue.add_effect(action)
		
	
	if attacker_traits.has("Kuga"):
				var trait = attacker_traits.Kuga
		

				var buff = cloner.clone_dict(LBuffs.buff_data.Plague)
				buff["target"] = attacker
				buff["source"] = attacker
				buff.duration = 3 * trait.Level
				var action = {
				"name": "buff_targets_in_range", 
				"caster": attacker, 
				"effect_sprite": "Plague", 
				"number_of_targets": 1, 
				"effect_range": 3, 
				"buff": buff, 
				"is_allied": false, 
				"msg": attacker_traits.Kuga.Name
				}
				ProcessQueue.add_effect(action)
	
	if defender_traits.has("Siku") == true:
		
		var action = {
				"name": "magic_damage_tiles_in_path_to_targets_in_range", 
				"caster": defender, 
				"damage": defender.get_total_inflex() * defender.get_total_WIL(), 
				"damage_type": "ice", 
				"effect_sprite": "Ice", 
				"number_of_targets": 1, 
				"effect_range": 99, 
				"enemies": null, 
				"msg": defender_traits.Siku.Name
				
				}
		ProcessQueue.add_effect(action)


	if attacker_traits.has("Intabah"):
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
			
				var buff = cloner.clone_dict(LBuffs.buff_data.Repulsion)
				buff["target"] = attacker
				buff["source"] = attacker
				buff.duration = 5
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Intabah.Name
				}
				
				ProcessQueue.add_effect(action)

	if attacker_traits.has("IgnisPunctum") == true:
		
		var action = {
				"name": "magic_damage_tiles_in_path", 
				"target": defender, 
				"caster": attacker, 
				"damage": 10 * attacker.get_total_STR(), 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"msg": attacker_traits.IgnisPunctum.Name
			}
		ProcessQueue.add_effect(action)
		
		action = {
				"name": "magic_damage_tiles_in_path", 
				"target": defender, 
				"caster": attacker, 
				"damage": 10 * attacker.get_total_DEX(), 
				"damage_type": "pierce", 
				"effect_sprite": "Pierce", 
				"msg": attacker_traits.IgnisPunctum.Name
			}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Trample"):
		
		var damage = 25.0 + attacker.get_total_weight()
		if attacker == Global.Player:
			damage = 10.0 * attacker.get_total_weight()
		
		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": attacker, 
				"damage": damage, 
				"damage_type": "blunt", 
				"effect_sprite": "Bash", 
				"effect_range": 1, 
				"msg": attacker_traits.Trample.Name
			}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Might"):
		var trait = attacker.get_traits().Might
		if attacker.get_hands_used() == 1:
			if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
				var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": attacker, 
				"damage": float((float(attacker.get_DMG_total(weapon)) * 0.1) * trait.Level), 
				"damage_type": attacker.get_DMG_type(weapon), 
				"effect_sprite": translate.dmgtype_to_animation(attacker.get_DMG_type(weapon)), 
				"effect_range": 1, 
				"msg": attacker_traits.Might.Name
			}
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Aim"):
			var trait = attacker.get_traits().Aim
		
			if attacker.get_range_attack(attacker.weapon_main) > 1:
				var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": float((float(attacker.get_DMG_total(weapon)) * 0.1) * trait.Level), 
					"damage_type": "pierce", 
					"effect_sprite": "Pierce", 
					"msg": attacker_traits.Aim.Name
				}
				ProcessQueue.add_effect(action)

	if attacker_traits.has("Hazar"):
		var msg = attacker_traits.Hazar.Name
		var action = {}
		var buff_duration = 0
		for enemy in Global.Enemies:
				if enemy.residence != null:
					if enemy.residence.tileset.title == "acid":
						
						for buff in enemy.Buffs:
							if buff.name == "Corrosion":
								buff_duration += buff.duration
								
					
						var new_buff = cloner.clone_dict(LBuffs.buff_data.Corrosion)
						new_buff["target"] = enemy
						new_buff["source"] = attacker
						new_buff.duration = 5
						action = {
								"name": "add_buff", 
								"buff": new_buff, 
								"msg": msg
								}
						ProcessQueue.add_effect(action)
		if buff_duration > 0:
				action = {
			"name": "heal", 
			"amount": buff_duration, 
			"healer_unit": attacker, 
			"healed_unit": attacker, 
			"msg": msg
				}
				ProcessQueue.add_effect(action)
					
					

	if attacker_traits.has("TrampleFire"):
		
		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": attacker, 
				"damage": 20.0, 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"effect_range": 1, 
				"msg": attacker_traits.TrampleFire.Name
			}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("TrampleZap"):
		
		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": attacker, 
				"damage": 20.0, 
				"damage_type": "lightning", 
				"effect_sprite": "Zap", 
				"effect_range": 1, 
				"msg": attacker_traits.TrampleZap.Name
			}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("TrampleIce"):
		
		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": attacker, 
				"damage": 20.0, 
				"damage_type": "ice", 
				"effect_sprite": "Ice", 
				"effect_range": 1, 
				"msg": attacker_traits.TrampleIce.Name
			}
		ProcessQueue.add_effect(action)

	if attacker_traits.has("Force") == true:
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
			
			var msg = attacker_traits.Force.Name
			ToolMagicMaker.add_hit_event(defender, attacker, 40.0, attacker.weapon_main, msg)
	
	if attacker_traits.has("FlameKnight") == true:
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
				var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 300.0, 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": attacker_traits.FlameKnight.Name
				}
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Shantih") == true:
		
				var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 100.0, 
					"damage_type": "lightning", 
					"effect_sprite": "Zap", 
					"msg": attacker_traits.Shantih.Name
				}
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Executioner") == true:
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
			if attacker.get_hands_used() == 1:
				var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 500, 
					"damage_type": "blood", 
					"effect_sprite": "Blood", 
					"msg": attacker_traits.Executioner.Name
				}
				ProcessQueue.add_effect(action)
		
				action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 500, 
					"damage_type": "slash", 
					"effect_sprite": "Slash", 
					"msg": attacker_traits.Executioner.Name
				}
				ProcessQueue.add_effect(action)
	
	
	
	if attacker_traits.has("Castpsy") == true:
		
		var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 25, 
					"damage_type": "psychic", 
					"effect_sprite": "Psychic", 
					"msg": attacker_traits.Castpsy.Name
				}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Castastra") == true:
		
		var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 25, 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"msg": attacker_traits.Castastra.Name
				}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Castcurse") == true:
		
		var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 25, 
					"damage_type": "death", 
					"effect_sprite": "Curse", 
					"msg": attacker_traits.Castcurse.Name
				}
		ProcessQueue.add_effect(action)
		
	if attacker_traits.has("Castblood") == true:
		
		var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 25, 
					"damage_type": "blood", 
					"effect_sprite": "Blood", 
					"msg": attacker_traits.Castblood.Name
				}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Castvenom") == true:
		
		var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 25, 
					"damage_type": "poison", 
					"effect_sprite": "PoisonHit", 
					"msg": attacker_traits.Castvenom.Name
				}
		ProcessQueue.add_effect(action)

	if attacker_traits.has("PranaBindu"):
			if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
				var action = {
				"name": "magic_damage_target", 
				"target": defender, 
				"caster": attacker, 
				"damage": attacker.get_DEF_total(), 
				"damage_type": "psychic", 
				"effect_sprite": "Psychic", 
				"msg": attacker_traits.PranaBindu.Name
			}
				ProcessQueue.add_effect(action)

	if defender_traits.has("PranaNisi") == true:
	
		var damage_dealt = defender.get_SPEED()
		if defender == Global.Player:
			damage_dealt = defender.get_DEF_total()
		var action = {
			"name": "magic_damage_targets_range", 
			"caster": defender, 
			"damage": damage_dealt, 
			"damage_type": "psychic", 
			"effect_sprite": "Psychic", 
			"effect_range": 1, 
			"number_of_targets": 1, 
			"msg": defender_traits.PranaNisi.Name
				}
		ProcessQueue.add_effect(action)

	if defender_traits.has("Aurostasis") == true:
		
		var heal = 5.0
		if defender == Global.Player:
			heal = 2.0 * defender.get_total_inflex()
		var action = {
			"name": "heal", 
			"amount": heal, 
			"healer_unit": defender, 
			"healed_unit": defender, 
			"msg": defender_traits.Aurostasis.Name
				}
		ProcessQueue.add_effect(action)

	if attacker_traits.has("MindKnight") == true:
		var trait = attacker_traits.MindKnight
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
			if attacker.get_hands_used() == 1:
				var action = {
				"name": "magic_damage_tiles_in_line", 
				"target": defender, 
				"caster": attacker, 
				"damage": 50.0 * trait.Level, 
				"damage_type": "psychic", 
				"effect_sprite": "Psychic", 
				"msg": attacker_traits.MindKnight.Name
			}
				ProcessQueue.add_effect(action)
				
				var buff = cloner.clone_dict(LBuffs.buff_data.Repulsion)
				buff["target"] = attacker
				buff["source"] = attacker
				buff.duration = 1 * trait.Level
				var action2 = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.MindKnight.Name
			}
				ProcessQueue.add_effect(action2)
	
	if defender_traits.has("MindKnightPrestige") == true:
		
		
				var buff = cloner.clone_dict(LBuffs.buff_data.Repulsion)
				buff["target"] = defender
				buff["source"] = defender
				buff.duration = defender.get_total_STR()
				var action2 = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.MindKnightPrestige.Name
			}
				ProcessQueue.add_effect(action2)
	
	if attacker_traits.has("ColdSteel"):
			
				var repeat = attacker.get_total_inflex()
				for n in repeat:
					var action = {
				"name": "magic_damage_tiles_in_path_to_targets_in_range", 
				"caster": attacker, 
				"damage": attacker.get_total_weight() * 5, 
				"damage_type": "ice", 
				"effect_sprite": "Ice", 
				"number_of_targets": 2, 
				"effect_range": 3, 
				"enemies": null, 
				"msg": attacker_traits.ColdSteel.Name
				}
			
			
					ProcessQueue.add_effect(action)
	
	if attacker_traits.has("GloveIce"):
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.livingice, 
					"summoner": attacker, 
					"msg": attacker_traits.GloveIce.Name
				}
			ProcessQueue.add_effect(action)
			
			
			var buff = cloner.clone_dict(LBuffs.buff_data.Freeze)
			buff["target"] = attacker
			buff["source"] = attacker
			buff.duration = attacker.get_total_WIL()
			action = {
				"name": "buff_targets_in_range", 
				"caster": attacker, 
				"effect_sprite": "Chill", 
				"number_of_targets": 8, 
				"effect_range": 1, 
				"buff": buff, 
				"is_allied": false, 
				"msg": attacker_traits.GloveIce.Name
				}
		
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("ImpalingIce") == true:
		
		var damage = 50.0
		if attacker == Global.Player:
			damage = 1 + attacker.get_block_strength()
		var action = {
				"name": "magic_damage_tiles_in_path", 
				"target": defender, 
				"caster": attacker, 
				"damage": damage, 
				"damage_type": "ice", 
				"effect_sprite": "Ice", 
				"msg": attacker_traits.ImpalingIce.Name
			}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("HoodMubarizun"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Evasion)
			buff["target"] = attacker
			buff["source"] = attacker
			buff.duration = 2
			var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": attacker_traits.HoodMubarizun.Name
			}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("Upuat"):
		if defender.armor_chest == null:
			var buff = cloner.clone_dict(LBuffs.buff_data.Jackalform)
			buff["target"] = defender
			buff["source"] = defender
			buff.duration = 3
			var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": defender_traits.Upuat.Name
			}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Mubarizun"):
		if attacker.get_hands_used() == 2:
			var action = {
			"name": "hit_targets_range", 
			"attacker": attacker, 
			"hit": 10.0, 
			"weapon": attacker.weapon_main, 
			"effect_range": 1, 
			"number_of_targets": 1, 
			"msg": attacker_traits.Mubarizun.Name
				}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Strijela"):
		var action = {
			"name": "magic_damage_tiles_in_path_to_furthest", 
			"caster": attacker, 
			"damage": 10.0 * attacker.get_total_DEX(), 
			"damage_type": attacker.get_DMG_type(weapon), 
			"effect_sprite": translate.dmgtype_to_animation(attacker.get_DMG_type(weapon)), 
			"msg": attacker_traits.Strijela.Name
				}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("SuVarpa"):
		var number_of_target = 1
		var custom_damage = 50
		if attacker == Global.Player:
			number_of_target = 5 - Global.Player.get_armor_list().size()
			custom_damage = 15.0 * attacker.get_total_STR()
			
			
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
			var action = {
				"name": "magic_damage_tiles_in_path_to_targets_in_range", 
				"caster": attacker, 
				"damage": custom_damage, 
				"damage_type": "astral", 
				"effect_sprite": "Astral", 
				"number_of_targets": number_of_target, 
				"effect_range": 99, 
				"enemies": null, 
				"msg": attacker_traits.SuVarpa.Name
				}
			ProcessQueue.add_effect(action)
	
	
	if attacker_traits.has("Shockwave") == true:
		var damage = 50.0
		if attacker == Global.Player:
			damage = (attacker.get_total_weight() + 1.0) * 5.0
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
			
			var action = {
				"name": "magic_damage_tiles_in_line", 
				"target": defender, 
				"caster": attacker, 
				"damage": damage, 
				"damage_type": "blunt", 
				"effect_sprite": "Bash", 
				"msg": attacker_traits.Shockwave.Name
			}
			ProcessQueue.add_effect(action)
	
	
	if defender_traits.has("PoisonSkin") == true:
		var trait = defender.get_traits().PoisonSkin
		
		var buff = cloner.clone_dict(LBuffs.buff_data.Sickness)
		buff["target"] = attacker
		buff["source"] = defender
		buff.duration = 2 * trait.Level
		var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.PoisonSkin.Name
			}
		ProcessQueue.add_effect(action)
	
	
	
	
	if defender_traits.has("Mask_Acid") == true:
		
		
		var buff = cloner.clone_dict(LBuffs.buff_data.Corrosion)
		buff["target"] = attacker
		buff["source"] = defender
		buff.duration = 7
		var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.Mask_Acid.Name
			}
		ProcessQueue.add_effect(action)
		
		for checkbuff in attacker.Buffs:
			if checkbuff.name == "Corrosion":
				action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": defender, 
					"damage": checkbuff.duration * 5.0, 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": defender_traits.Mask_Acid.Name
				}
				ProcessQueue.add_effect(action)
				
	
	if defender_traits.has("BloodMask") == true:
		
		
			var buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
			buff["target"] = attacker
			buff["source"] = defender
			buff.duration = 2
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": defender_traits.BloodMask.Name
			}
			ProcessQueue.add_effect(action)
			
			for effect in attacker.Buffs:
				if effect.name == "Bleed":
					action = {
					"name": "heal", 
					"amount": effect.duration, 
					"healer_unit": defender, 
					"healed_unit": defender, 
					"msg": defender_traits.BloodMask.Name
				}
					ProcessQueue.add_effect(action)
	
	if defender_traits.has("chest_dark") == true:
		
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
			var action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": defender, 
					"damage": defender.get_ARM(), 
					"damage_type": "death", 
					"effect_sprite": "Curse", 
					"msg": defender_traits.chest_dark.Name
				}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("MasterDoom") == true:
		
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
			var trait = defender.get_traits().MasterDoom
			var multi = 0
			for buff in defender.Buffs:
				if buff.name == "Doom":
					multi = buff.duration * trait.Level
			if multi > 0:
				var action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": defender, 
					"damage": multi, 
					"damage_type": "death", 
					"effect_sprite": "Curse", 
					"msg": defender_traits.MasterDoom.Name
				}
				ProcessQueue.add_effect(action)
	
	
	
	if defender_traits.has("MasterEntangle") == true:
		if defender.get_buff_names().has("Entangle"):
			for buff in defender.Buffs:
				if buff.name == "Entangle":
					var action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": defender, 
					"damage": float(defender_traits.MasterEntangle.Level * buff.duration), 
					"damage_type": "pierce", 
					"effect_sprite": "Pierce", 
					"msg": defender_traits.MasterEntangle.Name
				}
					ProcessQueue.add_effect(action)
					

	if attacker.object_type == "ally" and defender.object_type == "enemy":
		if attacker.type.tags.has("[color=#00a000]Plant[/color]"):
			if Global.Player.get_traits().has("ErtHunab"):
				var trait = Global.Player.get_traits().ErtHunab
				var buff = cloner.clone_dict(LBuffs.buff_data.Entangle)
				buff["target"] = defender
				buff["source"] = Global.Player
				buff.duration = trait.Level
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": Global.Player.get_traits().ErtHunab.Name
			}
				ProcessQueue.add_effect(action)

	if defender != Global.Player:
		if defender.type.tags.has("[color=#00a000]Plant[/color]"):
			if Global.Player.get_traits().has("Overgrowth"):
				var trait = Global.Player.get_traits().Overgrowth
				var buff = cloner.clone_dict(LBuffs.buff_data.Entangle)
				buff["target"] = attacker
				buff["source"] = Global.Player
				buff.duration = trait.Level
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": Global.Player.get_traits().Overgrowth.Name
			}
				ProcessQueue.add_effect(action)
		
		if defender.type.tags.has("[color=#30f000]Fungus[/color]"):
			if Global.Player.get_traits().has("Gliva"):
				var damage = 0.0
				for ally in Global.Allies:
					if ally != Global.Player:
						if ally.type.tags.has("[color=#30f000]Fungus[/color]"):
							damage += 1.0
				damage *= Global.Player.get_total_WIL()
			
				var action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": Global.Player, 
					"damage": damage, 
					"damage_type": "psychic", 
					"effect_sprite": "Psychic", 
					"msg": Global.Player.get_traits().Gliva.Name
				}
				ProcessQueue.add_effect(action)

	if attacker_traits.has("JadeGladius"):
		var damage = 0.0
		for buff in attacker.Buffs:
			damage += float(buff.duration)
		if damage > 0.0:
				var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": damage, 
					"damage_type": "poison", 
					"effect_sprite": "YuPoison", 
					"msg": attacker_traits.JadeGladius.Name
				}
				ProcessQueue.add_effect(action)

	if attacker_traits.has("Worshipper"):
		var action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": attacker, 
					"damage": 500.0, 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"msg": attacker_traits.Worshipper.Name
				}
		ProcessQueue.add_effect(action)
		action = {
			"name": "magic_damage_targets_range", 
			"caster": attacker, 
			"damage": 500.0, 
			"damage_type": "astral", 
			"effect_sprite": "Astral", 
			"number_of_targets": 1, 
			"effect_range": 1, 
			"msg": attacker_traits.Worshipper.Name
				}
		ProcessQueue.add_effect(action)

	if attacker_traits.has("Shapeshifter") == true:
		for buff in attacker.Buffs:
			if buff.name == "Wildform":
				var types = ["lightning", "fire", "poison"]
				for element in types:
					var action = {
				"name": "magic_damage_tiles_in_path_to_targets_in_range", 
				"caster": attacker, 
				"damage": 10.0 * buff.duration, 
				"damage_type": element, 
				"effect_sprite": translate.dmgtype_to_animation(element), 
				"number_of_targets": 1, 
				"effect_range": 3, 
				"enemies": null, 
				"msg": "Wildform"
				
				}
					ProcessQueue.add_effect(action)
		
		var buff = cloner.clone_dict(LBuffs.buff_data.Wildform)
		buff["target"] = attacker
		buff["source"] = attacker
		buff["duration"] = 2
		var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": attacker_traits.Shapeshifter.Name
		}
		ProcessQueue.add_effect(action)

	
	for buff in defender.Buffs:
		if buff.name == "Repulsion":
			if defender_traits.has("Mesmer") == false:
				var action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": defender, 
					"damage": 1.0 * buff.duration, 
					"damage_type": "psychic", 
					"effect_sprite": "Psychic", 
					"msg": "Repulsion"
				}
				ProcessQueue.add_effect(action)
			else:
				var action = {
				"name": "magic_damage_tiles_in_path", 
				"target": attacker, 
				"caster": defender, 
				"damage": 1.0 * buff.duration, 
				"damage_type": "psychic", 
				"effect_sprite": "Psychic", 
				"msg": defender_traits.Mesmer.Name
			}
				ProcessQueue.add_effect(action)
		
		if buff.name == "Anqarak":
				var refract_damage = 2.0
				
				var action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": defender, 
					"damage": refract_damage * buff.duration, 
					"damage_type": "blood", 
					"effect_sprite": "Blood", 
					"msg": "Anqarak"
				}
				ProcessQueue.add_effect(action)
		
		if buff.name == "Refraction":
				var refract_damage = 10.0
				
				var action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": defender, 
					"damage": refract_damage * buff.duration, 
					"damage_type": "poison", 
					"effect_sprite": "YuPoison", 
					"msg": "Refraction"
				}
				ProcessQueue.add_effect(action)
		
		
		if buff.name == "Lizardform":
			var action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": defender, 
					"damage": defender.get_ARM(), 
					"damage_type": "poison", 
					"effect_sprite": "PoisonHit", 
					"msg": "Lizardform"
				}
			ProcessQueue.add_effect(action)
		
		if buff.name == "Grace":
			var action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": defender, 
					"damage": 5.0 * buff.duration, 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"msg": "Grace"
				}
			ProcessQueue.add_effect(action)
		
		if buff.name == "Protection":
			if Global.rng.randi_range(1, 10) <= 2:
				var action = {
					"name": "remove_buff", 
					"target": defender, 
					"buff": buff, 
					"msg": "Attacked"
		}
				ProcessQueue.add_effect(action)
				
				if defender == Global.Player:
						ToolMessageCreator.add_message("[color=#f09090]", "보호막이 파괴되었다!")
				else:
						ToolMessageCreator.add_message("[color=#c07070]", defender.get_name_color() + " 보호막이 파괴됨!")

static func extra_attacks_from_initial(defender, attacker, weapon, msg):
	
	
	var tile_range = attacker.get_range_attack(weapon)
	var enemy = defender
	var tile_start = attacker.residence
	var tile_end = defender.residence
	
	
	if attacker.get_traits().has("Ogham"):
		var number_of_target = 4 - attacker.get_armor_list().size()
		number_of_target = 1
		for n in number_of_target:
			var dict = attacker.invokes
			var rng = Global.rng
			var invokes = []
			for key in dict:
				var invoke = dict[key]
				if invoke["level_required"] <= Global.Player.level:
					invokes.append(invoke)
			var random_invoke = invokes[rng.randi_range(0, invokes.size() - 1)]
			if random_invoke.use > 0:
				random_invoke.use -= 1
			invoker.cast(random_invoke, random_invoke.title)
	
	if attacker.get_traits().has("AttackTwice"):
			msg = attacker.get_traits().AttackTwice.Name
			ToolMagicMaker.add_attack(attacker, tile_start, tile_end, tile_range, enemy, weapon, msg)
	
	if attacker.get_traits().has("Javelins"):
		if attacker.get_hands_used() == 2:
			msg = attacker.get_traits().Javelins.Name
			ToolMagicMaker.add_attack(attacker, tile_start, tile_end, tile_range, enemy, weapon, msg)
			
	
	if attacker.get_traits().has("LiYan") == true:
		if attacker.Buffs.size() > 0:
			for buff in attacker.Buffs:
				msg = attacker.get_traits().LiYan.Name
				ToolMagicMaker.add_attack(attacker, tile_start, tile_end, tile_range, enemy, weapon, msg)
	
	if attacker.get_traits().has("Mask_Frenzy"):
		for buff in attacker.Buffs:
			if buff.name == "Inflame":
				msg = attacker.get_traits().Mask_Frenzy.Name
				for n in buff.duration:
					ToolMagicMaker.add_attack(attacker, tile_start, tile_end, tile_range, enemy, weapon, msg)
	
	if attacker.get_traits().has("Kashra"):
			msg = attacker.get_traits().Kashra.Name
			ToolMagicMaker.add_attack(attacker, tile_start, tile_end, tile_range, enemy, weapon, msg)
			ToolMagicMaker.add_attack(attacker, tile_start, tile_end, tile_range, enemy, weapon, msg)
	
	if attacker.get_traits().has("Kendo"):
		
			for n in attacker.get_traits().Kendo.Level:
				var attack_action = {
			"name": "attack_targets", 
			"attacker": attacker, 
			"number_of_targets": 1, 
			"msg": attacker.get_traits().Kendo.Name
		}
	
				ProcessQueue.add_effect(attack_action)
	
	if attacker.get_traits().has("Claideb"):
		var number_of_target = 4 - attacker.get_armor_list().size()
		for n in number_of_target:
			var action = {
			"name": "attack_targets", 
			"attacker": attacker, 
			"number_of_targets": 1, 
			"msg": attacker.get_traits().Claideb.Name
		}
	
			ProcessQueue.add_effect(action)
	
	if attacker.get_traits().has("Taugh"):
		if attacker.get_hands_used() == 1:
			var number_of_target = 4 - attacker.get_armor_list().size()
			for n in number_of_target:
				var action = {
			"name": "attack_targets", 
			"attacker": attacker, 
			"number_of_targets": 1, 
			"msg": attacker.get_traits().Taugh.Name
		}
	
				ProcessQueue.add_effect(action)
	
	if attacker.get_buff_names().has("Anqarak"):
			msg = "Anqarak"
			for n in 2:
				ToolMagicMaker.add_attack(attacker, tile_start, tile_end, tile_range, enemy, weapon, msg)
	
	if attacker.get_buff_names().has("Berserk"):
			msg = "Berserk"
			ToolMagicMaker.add_attack(attacker, tile_start, tile_end, tile_range, enemy, weapon, msg)

	if attacker.get_traits().has("Herja"):
		var trait = attacker.get_traits().Herja
		msg = attacker.get_traits().Herja.Name
		for n in trait.Level:
			ToolMagicMaker.add_attack(attacker, tile_start, tile_end, tile_range, enemy, weapon, msg)

	if attacker.get_traits().has("Venite"):
		if defender.get_buff_names().has("Sickness") == true:
			msg = attacker.get_traits().Venite.Name
			ToolMagicMaker.add_attack(attacker, tile_start, tile_end, tile_range, enemy, weapon, msg)
			ToolMagicMaker.add_attack(attacker, tile_start, tile_end, tile_range, enemy, weapon, msg)
			ToolMagicMaker.add_attack(attacker, tile_start, tile_end, tile_range, enemy, weapon, msg)


static func message_hit(defender, attacker, msg):
	
	
	var name_a = attacker.get_name_color()
	var name_d = defender.get_name_color()
	var damage_text = "[color=#ffa050]attack[/color]"
	
	
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
	
	if msg != "":
		if msg != "Initial":
			msg = "추가 <- " + msg
		stringa += "[color=#707070] <- " + ({"Familiar": "사역마", "Summoned": "소환됨", "Initial": "최초", "Hit": "명중", "공격": "공격", "Being hit": "피격", "enemy Purges you": "적의 정화"}.get(textstrip.strip_bbcode(msg), textstrip.strip_bbcode(msg))) + "[/color]"
	return stringa


static func add_score(unit):
	if unit == Global.Player:
			StatePlayerSheet.score_data.times_attack += 1
