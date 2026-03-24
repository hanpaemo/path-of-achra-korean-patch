extends Node


class_name event_move

static func check(unit, tile_start, tile_end):
	var moving = false
	
	for buff in unit.Buffs:
		if buff.name == "Beastform":
				var duration = 1
				var action = {
					"name": "reduce_buff", 
					"target": unit, 
					"buff": buff, 
					"duration": duration, 
					"msg": "non-attack action"
		}
				ProcessQueue.add_effect(action)

	
	if tile_start == tile_end:
		
		check_wait(unit)
		
	else:
		moving = true
		check_move(unit, tile_start, tile_end)
		Global.sound.new_sound("Move")
		
		if unit.object_type == "enemy":
			if Global.rng.randi_range(1, 5) == 5:
				speak.create_speech(unit)
		
	
	
	unit.slide(tile_start.position, tile_end.position)
	tile_end.resident = unit
	unit.residence = tile_end
	
	if moving == true:
		check_end(unit, tile_start, tile_end)
		if unit == Global.Player:
			if calcrange.is_adjacent_enemy(unit, Global.Enemies) == true:
				ToolInvokes.recharge("step adjacent")
			elif Global.Enemies.size():
				ToolInvokes.recharge("step not adjacent")


static func check_end(unit, tile_start, tile_end):
	
	var adjacent = calcrange.get_border_tiles_occupied_in_range(unit.residence, 1)
	var adjacent_units = []
	for tile in adjacent:
		if tile.resident != null:
			if tile.resident != unit:
				var resident = tile.resident
				adjacent_units.append(resident)
	for neighbor in adjacent_units:
		if calcrange.get_enemy_alliance(unit).has(neighbor):
			if neighbor.get_traits().has("Vigilance"):
				var msg = neighbor.get_traits().Vigilance.Name
				ToolMagicMaker.add_attack(neighbor, neighbor.residence, unit.residence, neighbor.get_range_attack(neighbor.weapon_main), unit, neighbor.weapon_main, msg)
		if neighbor == Global.Player:
			if neighbor.get_traits().has("Sunder"):
				var msg = neighbor.get_traits().Sunder.Name
				ToolMagicMaker.add_attack(neighbor, neighbor.residence, unit.residence, neighbor.get_range_attack(neighbor.weapon_main), unit, neighbor.weapon_main, msg)

static func check_move(unit, tile_start, tile_end):
	
	if unit == Global.Player:
			if Global.Enemies.size():
				ToolInvokes.recharge("step")
		
	var txcolor = "[color=#c0c0c0]"
	if unit == Global.Player:
			ToolMessageCreator.add_message(txcolor, "한 걸음 이동")
	
	
	var buffs = unit.Buffs
	var unit_traits = unit.get_traits()
	
	if unit_traits.has("KairosVeil") and Global.Enemies.size():
		ToolMessageCreator.add_message("[color=#c07070]", Global.Player.get_traits().KairosVeil.Name + "(이)가 '제자리 대기' 행동 수행...")
		check_wait(unit)
	
	for buff in buffs:
		
		if buff.name == "Poise":
			if unit_traits.has("Champion") == true and unit.get_range_attack(unit.weapon_main) == 1:
				pass
			else:
				var action = {
					"name": "reduce_buff", 
					"target": unit, 
					"buff": buff, 
					"duration": int(float(buff.duration) * 0.25), 
					"msg": "Stepping"
		}
				ProcessQueue.add_effect(action)
		
		if buff.name == "Meditate":
			
				
		
				var action = {
					"name": "reduce_buff", 
					"target": unit, 
					"buff": buff, 
					"duration": int(float(buff.duration) / 2.0), 
					"msg": "Stepping"
		}
				ProcessQueue.add_effect(action)
		
		
		
		if buff.name == "Dream" or buff.name == "Treeform":
			var action = {
					"name": "remove_buff", 
					"target": unit, 
					"buff": buff, 
					"msg": "Stepping"
		}
			ProcessQueue.add_effect(action)
		
		if buff.name == "Entangle":
			
			if unit_traits.has("MasterEntangle") == false:
				
				var action = {
					"name": "magic_damage_target", 
					"target": buff.target, 
					"caster": buff.source, 
					"damage": 5 * buff.duration, 
					"damage_type": "pierce", 
					"effect_sprite": "Pierce", 
					"msg": "Entangle"
				}
				ProcessQueue.add_effect(action)
			else:
				pass
			
			
			
			
			
			
			
			
			
		
			
		
		if buff.name == "Bleed":
			if unit_traits.has("MasterBleed") == false and unit_traits.has("Damunja") == false:
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
	
	if unit.object_type == "enemy":
		if unit.get_buff_names().has("Corrosion"):
			ToolInvokes.recharge("dudar step")
	
	if unit.object_type == "enemy":
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
	
	
		
			
				
				
				
				
				
				
				
				
				
	
	
	
	
	if unit_traits.has("Nartaka") == true:
		
		var adamage = unit.get_total_DEX() * unit.get_total_WIL()
		var action = {
			"name": "magic_damage_targets_range", 
			"caster": unit, 
			"damage": adamage, 
			"damage_type": "lightning", 
			"effect_sprite": "Zap", 
			"number_of_targets": 1, 
			"effect_range": 4, 
			"msg": unit_traits.Nartaka.Name
				}
		ProcessQueue.add_effect(action)
	
	
	if unit.get_traits().has("Mindbreaker"):
		var buff = cloner.clone_dict(LBuffs.buff_data.Repulsion)
		buff["target"] = unit
		buff["source"] = unit
		buff.duration = unit.get_total_DEX()
		var action2 = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": unit_traits.Mindbreaker.Name
			}
		ProcessQueue.add_effect(action2)
	
	if unit.get_traits().has("Saurian"):
		
		var action = {
			"name": "magic_damage_tiles_in_path_to_targets_in_range", 
			"caster": unit, 
			"damage": 10.0 * float(unit.get_total_STR() + unit.get_total_DEX()), 
			"damage_type": "poison", 
			"effect_sprite": "PoisonHit", 
			"number_of_targets": 1, 
			"effect_range": 3, 
			"enemies": null, 
			"msg": unit_traits.Saurian.Name
				}
		ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SnakeCharmer"):
		if Global.Enemies.size() > 0:
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.serpent, 
					"summoner": unit, 
					"msg": unit_traits.SnakeCharmer.Name
				}
			ProcessQueue.add_effect(action)
	
	
	
	if unit.get_traits().has("stafflightning") == true:
		var action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": unit, 
	"damage": 2.0 * unit.get_SPEED(), 
	"damage_type": "lightning", 
	"effect_sprite": "Zap", 
	"number_of_targets": 2, 
	"effect_range": 99, 
	"enemies": null, 
	"msg": unit_traits.stafflightning.Name
				}
		ProcessQueue.add_effect(action)
	
	if unit.get_buff_names().has("Windstrike") == false and unit_traits.has("Windblade"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Windstrike)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 1
			var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": unit_traits.Windblade.Name
			}
			ProcessQueue.add_effect(action)
	
	if unit_traits.has("NullChausses"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Stasis)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 3
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": unit_traits.NullChausses.Name
				}
			ProcessQueue.add_effect(action)
	
	if unit_traits.has("Peltast"):
		
		for enemy in Global.Enemies:
			if enemy.residence != null:
				if enemy.residence.visible_to_player == true:
					
					var buff = cloner.clone_dict(LBuffs.buff_data.Mark)
					buff["target"] = enemy
					buff["source"] = unit
					buff.duration = unit.get_range_attack(unit.weapon_main)
					var action2 = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": unit_traits.Peltast.Name
			}
					ProcessQueue.add_effect(action2)
					
	
	
	
	if unit_traits.has("Alizeh"):
		
		var action = {
			"name": "magic_damage_targets_range", 
			"caster": unit, 
			"damage": 25.0, 
			"damage_type": "astral", 
			"effect_sprite": "Astral", 
			"number_of_targets": 2, 
			"effect_range": 99, 
			"msg": unit_traits.Alizeh.Name
				}
		ProcessQueue.add_effect(action)
		
		action = {
				"name": "magic_damage_targets_range", 
			"caster": unit, 
			"damage": 25.0, 
			"damage_type": "lightning", 
			"effect_sprite": "Zap", 
			"number_of_targets": 2, 
			"effect_range": 99, 
			"msg": unit_traits.Alizeh.Name
				}
		ProcessQueue.add_effect(action)
		
	if unit_traits.has("Tengri"):
			
			for n in unit.get_charged_invokes():
				
				var action = {}
				action = {
				"name": "magic_damage_tiles_in_path_to_targets_in_range", 
				"caster": unit, 
				"damage": unit.get_SPEED() * 2, 
				"damage_type": "slash", 
				"effect_sprite": "Wind", 
				"number_of_targets": 1, 
				"effect_range": 3, 
				"enemies": null, 
				"msg": unit_traits.Tengri.Name
				}
				ProcessQueue.add_effect(action)

	if unit_traits.has("Shazuza"):
		for enemy in Global.Enemies:
			if enemy.get_buff_names().has("Sickness"):
				var action = {
					"name": "magic_damage_tiles_in_path", 
					"target": enemy, 
					"caster": unit, 
					"damage": unit.get_DMG_total(unit.weapon_main) * 0.2, 
					"damage_type": "lightning", 
					"effect_sprite": "Zap", 
					"msg": unit_traits.Shazuza.Name
				}
			
				ProcessQueue.add_effect(action)
				
				ToolMagicMaker.add_hit_event(enemy, unit, unit.get_DMG_total(unit.weapon_main) * 0.2, unit.weapon_main, unit_traits.Shazuza.Name)

	if unit_traits.has("Kerjata"):
			var trait = unit_traits.Kerjata
			for n in trait.Level:
				
				var action = {}
				action = {
				"name": "magic_damage_tiles_in_path_to_targets_in_range", 
				"caster": unit, 
				"damage": unit.get_SPEED() * trait.Level, 
				"damage_type": "lightning", 
				"effect_sprite": "Zap", 
				"number_of_targets": 1, 
				"effect_range": 2, 
				"enemies": null, 
				"msg": unit_traits.Kerjata.Name
				}
				ProcessQueue.add_effect(action)
				
			var buff = cloner.clone_dict(LBuffs.buff_data.Charge)
			buff["target"] = unit
			buff["source"] = unit
			buff["duration"] = trait.Level
			var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": unit_traits.Kerjata.Name
		}
			ProcessQueue.add_effect(action)
	
	if unit_traits.has("PurifyingStep"):
		
		for buff in unit.Buffs:
			if buff.name == "Doom" or buff.name == "Corrosion" or buff.name == "Scorch":
				var action = {
					"name": "remove_buff", 
					"target": unit, 
					"buff": buff, 
					"msg": unit_traits.PurifyingStep.Name
		}
				ProcessQueue.add_effect(action)
	
	
	

	
	
	if unit_traits.has("GloveLightning"):
		
		var damage = unit.get_SPEED() * 10.0
		var action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": unit, 
	"damage": damage, 
	"damage_type": "lightning", 
	"effect_sprite": "Zap", 
	"number_of_targets": 1, 
	"effect_range": 2, 
	"enemies": null, 
	"msg": unit_traits.GloveLightning.Name
				}
		ProcessQueue.add_effect(action)
	
	if unit_traits.has("Gothi"):
		
		var damage = 300.0
		var action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": unit, 
	"damage": damage, 
	"damage_type": "lightning", 
	"effect_sprite": "Zap", 
	"number_of_targets": 1, 
	"effect_range": 3, 
	"enemies": null, 
	"msg": unit_traits.Gothi.Name
				}
		ProcessQueue.add_effect(action)
			

	
	
	
	if unit_traits.has("Trample"):
		var damage = 25.0 + unit.get_total_weight()
		if unit == Global.Player:
			damage = 10.0 * unit.get_total_weight()
		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": damage, 
				"damage_type": "blunt", 
				"effect_sprite": "Bash", 
				"effect_range": 1, 
				"msg": unit_traits.Trample.Name
			}
		ProcessQueue.add_effect(action)
	
	if unit_traits.has("TrampleFire"):

		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": 20.0, 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"effect_range": 1, 
				"msg": unit_traits.TrampleFire.Name
			}
		ProcessQueue.add_effect(action)
	
	if unit_traits.has("TrampleZap"):

		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": 20.0, 
				"damage_type": "lightning", 
				"effect_sprite": "Zap", 
				"effect_range": 1, 
				"msg": unit_traits.TrampleZap.Name
			}
		ProcessQueue.add_effect(action)
	
	if unit_traits.has("TrampleIce"):

		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": 20.0, 
				"damage_type": "ice", 
				"effect_sprite": "Ice", 
				"effect_range": 1, 
				"msg": unit_traits.TrampleIce.Name
			}
		ProcessQueue.add_effect(action)
	
	if unit_traits.has("Mubarizun") == true:
		var action = {
			"name": "attack_targets", 
			"attacker": unit, 
			"number_of_targets": 1, 
			"msg": unit_traits.Mubarizun.Name
		}
	
		ProcessQueue.add_effect(action)
	
	if unit_traits.has("MurunaSash") == true:
		var action = {
			"name": "attack_targets", 
			"attacker": unit, 
			"number_of_targets": 1, 
			"msg": unit_traits.MurunaSash.Name
		}
	
		ProcessQueue.add_effect(action)
	
	if unit_traits.has("Suwag") == true:
		for n in 2:
			var action = {
			"name": "attack_targets", 
			"attacker": unit, 
			"number_of_targets": 1, 
			"msg": unit_traits.Suwag.Name
		}
	
			ProcessQueue.add_effect(action)
	
	if unit.get_buff_names().has("Vineform") == true:
		var action = {
			"name": "attack_targets", 
			"attacker": unit, 
			"number_of_targets": 1, 
			"msg": "Vineform"
		}
	
		ProcessQueue.add_effect(action)
	
	if unit_traits.has("Kendo") == true:
		var trait = unit_traits.Kendo
		
		for n in trait.Level:
				var action = {
			"name": "attack_targets", 
			"attacker": unit, 
			"number_of_targets": 1, 
			"msg": unit_traits.Kendo.Name
		}
				ProcessQueue.add_effect(action)
	
	
	
	if unit_traits.has("Swipe") == true:
		for n in Global.Enemies.size():
			var action = {
			"name": "hit_targets_range", 
			"attacker": unit, 
			"hit": 10.0, 
			"weapon": unit.weapon_main, 
			"effect_range": 1, 
			"number_of_targets": 1, 
			"msg": unit_traits.Swipe.Name
				}
			ProcessQueue.add_effect(action)
	
	
	if unit_traits.has("BloodDance"):

		var buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
		buff["target"] = unit
		buff["source"] = unit
		buff.duration = 25
		var action = {
				"name": "buff_targets_in_range", 
				"caster": unit, 
				"effect_sprite": "Bleed", 
				"number_of_targets": 1, 
				"effect_range": 2, 
				"buff": buff, 
				"is_allied": false, 
				"msg": unit_traits.BloodDance.Name
				}
		
		ProcessQueue.add_effect(action)
	
	if unit_traits.has("Kull"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Evasion)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 3
			var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": unit_traits.Kull.Name
			}
			ProcessQueue.add_effect(action)
			
	
	
	
	if unit_traits.has("GoldenGreaves"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = unit.get_total_STR()
			var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": unit_traits.GoldenGreaves.Name
			}
			ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("Shapeshifter") == true:
		
		var buff = cloner.clone_dict(LBuffs.buff_data.Wildform)
		buff["target"] = unit
		buff["source"] = unit
		buff["duration"] = 2
		var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": unit.get_traits().Shapeshifter.Name
		}
		ProcessQueue.add_effect(action)
	
	
	if unit_traits.has("Starjumper"):
		if Global.Enemies.size() > 0:
		
			var target = ToolMagicMaker.get_closest_enemy(unit, ToolMagicMaker.get_enemies(unit))
			if target != null:
			
			
			
				var action = {
				"name": "teleport_random", 
				"unit": unit, 
				"msg": unit_traits.Starjumper.Name
			}
				ProcessQueue.add_effect(action)
	
	
	
	
	
	if unit == Global.Player:
		for unit in Global.Enemies:
			var traits = unit.get_traits()
			if traits.has("Seeker"):
				print("SEEKED")
				var target = Global.Player
				if target.is_dead() == false:
					var msg = "Seeker"
					ToolMagicMaker.add_attack(unit, unit.residence, target.residence, unit.get_range_attack(unit.weapon_main), target, unit.weapon_main, msg)
			
					var action = {
			"name": "teleport", 
			"unit": unit, 
			"tile_target": target.residence, 
			"msg": traits.Seeker.Name
			}
					ProcessQueue.add_effect(action)
			
			if traits.has("Tracking"):
				var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 2
				var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": traits.Tracking.Name
			}
				ProcessQueue.add_effect(action)
			
			if traits.has("Gati"):
				var buff = cloner.clone_dict(LBuffs.buff_data.Repulsion)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 5
				var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": traits.Gati.Name
			}
				ProcessQueue.add_effect(action)
	

static func check_wait(unit):
	
	add_score(unit)
	var txcolor = "[color=#c0c0c0]"
	if unit == Global.Player:
			ToolMessageCreator.add_message(txcolor, "제자리 대기")
			if calcrange.is_adjacent_enemy(unit, Global.Enemies) == true:
				ToolInvokes.recharge("stand still adjacent")
			if Global.Enemies.size():
				ToolInvokes.recharge("stand still")
	
	var unit_traits = unit.get_traits()
	var buffs = unit.Buffs
	for buff in buffs:
		
		if buff.name == "Charge":
			if unit.get_traits().has("Tamasa") == false:
				var action = {
					"name": "reduce_buff", 
					"target": unit, 
					"buff": buff, 
					"duration": int(float(buff.duration) / 2.0), 
					"msg": "제자리"
		}
				ProcessQueue.add_effect(action)
		
		
		if buff.name == "Evasion":
				var action = {
					"name": "reduce_buff", 
					"target": unit, 
					"buff": buff, 
					"duration": int(float(buff.duration) / 2.0), 
					"msg": "제자리"
		}
				ProcessQueue.add_effect(action)
		
		
		if buff.name == "Freeze":
			if unit.get_traits().has("Parafrost") == false and unit.get_traits().has("VoidMage") == false:
				var action = {
					"name": "magic_damage_target", 
					"target": buff.target, 
					"caster": buff.source, 
					"damage": 5 * buff.duration, 
					"damage_type": "ice", 
					"effect_sprite": "Ice", 
					"msg": "Freeze"
				}
				ProcessQueue.add_effect(action)
	
		
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
	
	if unit_traits.has("Arbestus") == true:
			if Global.Enemies.size():
				var perform_times = 1
				if unit.get_hands_used() == 2:
					if translate.is_bare_fist(unit.weapon_main): perform_times += 1
					if translate.is_bare_fist(unit.weapon_off): perform_times += 1
				elif translate.is_bare_fist(unit.weapon_main): perform_times += 1
		
				for n in perform_times:
					var action = {
			"name": "hit_targets_range", 
			"attacker": unit, 
			"hit": 10.0, 
			"weapon": unit.weapon_main, 
			"effect_range": 2, 
			"number_of_targets": 1, 
			"msg": unit_traits.Arbestus.Name
			
				}
					ProcessQueue.add_effect(action)
	
	
	if unit_traits.has("CrowVisage"):
			var action = {
				"name": "magic_damage_target", 
				"target": unit, 
				"caster": unit, 
				"damage": 25.0, 
				"damage_type": "astral", 
				"effect_sprite": "Astral", 
				"msg": unit_traits.CrowVisage.Name
				}
			ProcessQueue.add_effect(action)
	if unit_traits.has("Sorcerer") == true:
		var action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": unit, 
	"damage": 5.0 * unit.level, 
	"damage_type": unit.get_DMG_type(unit.weapon_main), 
	"effect_sprite": translate.dmgtype_to_animation(unit.get_DMG_type(unit.weapon_main)), 
	"number_of_targets": 1, 
	"effect_range": 99, 
	"enemies": null, 
	"msg": unit_traits.Sorcerer.Name
				}
		ProcessQueue.add_effect(action)
	
	if unit_traits.has("Hazar"):
		var msg = unit_traits.Hazar.Name
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
						new_buff["source"] = unit
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
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": msg
				}
				ProcessQueue.add_effect(action)
	
	if unit_traits.has("Saurian"):
		
		var action = {
			"name": "magic_damage_tiles_in_path_to_targets_in_range", 
			"caster": unit, 
			"damage": 10.0 * float(unit.get_total_STR() + unit.get_total_DEX()), 
			"damage_type": "poison", 
			"effect_sprite": "PoisonHit", 
			"number_of_targets": 1, 
			"effect_range": 3, 
			"enemies": null, 
			"msg": unit_traits.Saurian.Name
				}
		ProcessQueue.add_effect(action)
	
	if unit_traits.has("Phoenix"):
		if Global.Enemies.size():
			for n in unit.get_charged_invokes():
				var action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": (0.01 * float(unit.HP_max)) * float(unit.get_total_WIL()), 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": unit_traits.Phoenix.Name
				}
				ProcessQueue.add_effect(action)
	
	
	if unit_traits.has("Kairos_Sash"):
		if Global.Enemies.size() > 0:
			ToolMessageCreator.add_message("[color=#c07070]", unit_traits.Kairos_Sash.Name + "(이)가 '게임 턴' 행동 수행...")
			event_turn.check(unit)
	
	if unit_traits.has("Geistform"):
		if Global.Enemies.size() > 0:
			if unit.get_buff_names().has("Crystalform"):
				ToolMessageCreator.add_message("[color=#c07070]", unit_traits.Geistform.Name + "(이)가 '게임 턴' 행동 수행...")
				event_turn.check(unit)
	
	if unit_traits.has("Oozemancer"):
		for ally in Global.Allies:
			if ally != Global.Player:
				if ally.type.title == "ooze":
					var action = {
			"name": "attack_targets", 
			"attacker": ally, 
			"number_of_targets": 1, 
			"msg": unit_traits.Oozemancer.Name
		}
					ProcessQueue.add_effect(action)
	
	

	
	
	if unit_traits.has("Intabah"):

				var buff = cloner.clone_dict(LBuffs.buff_data.Repulsion)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 5
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": unit_traits.Intabah.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit_traits.has("Dreamer"):
		if Global.Enemies.size() > 0:
			
			ToolMessageCreator.add_message("[color=#c07070]", unit_traits.Dreamer.Name + "(이)가 '게임 턴' 행동 수행...")
			
			var buff = cloner.clone_dict(LBuffs.buff_data.Dream)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 5
			var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": unit_traits.Dreamer.Name
			}
			ProcessQueue.add_effect(action)
			
			event_turn.check(unit)
			
			
	
	if unit.get_traits().has("Apostle"):
		if Global.Enemies.size() > 0:
			var action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": 15.0, 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"msg": unit_traits.Apostle.Name
				}
			ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("ShieldMirage") == true:
		
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.psychomorph, 
					"summoner": unit, 
					"msg": unit_traits.ShieldMirage.Name
				}
			ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("Zahan"):
			var trait = unit.get_traits().Zahan
			if Global.Enemies.size() > 0:
		
				var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = trait.Level * 4
				var action = {
				"name": "buff_tiles_in_range", 
				"caster": unit, 
				"effect_sprite": "Inflame", 
				"effect_range": 1, 
				"buff": buff, 
				"alliance": calcrange.get_allied_alliance(unit), 
				"msg": unit_traits.Zahan.Name
			}
				ProcessQueue.add_effect(action)

			
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = trait.Level * 4
				var action2 = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": unit_traits.Zahan.Name
			}
				ProcessQueue.add_effect(action2)
	
	
	if unit.get_traits().has("staffcrimson"):
					var buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
					buff["target"] = unit
					buff["source"] = unit
					buff.duration = unit.get_total_weapon_size()
					var action = {
				"name": "buff_tiles_in_range", 
				"caster": unit, 
				"effect_sprite": "Bleed", 
				"effect_range": 4, 
				"buff": buff, 
				"alliance": calcrange.get_enemy_alliance(unit), 
				"msg": unit_traits.staffcrimson.Name
			}
					ProcessQueue.add_effect(action)
	
	
	if unit.get_traits().has("Doomsayer"):
		
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
				"msg": unit_traits.Doomsayer.Name
			}
			ProcessQueue.add_effect(action)
	
	
	
	
	if unit.get_traits().has("BloodMage"):
				
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
				"msg": unit_traits.BloodMage.Name
			}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("Angiok"):
		var buff = cloner.clone_dict(LBuffs.buff_data.Freeze)
		buff["target"] = unit
		buff["source"] = unit
		buff.duration = 5
		var action = {
				"name": "buff_tiles_in_range", 
				"caster": unit, 
				"effect_sprite": "Chill", 
				"effect_range": 3, 
				"buff": buff, 
				"alliance": calcrange.get_enemy_alliance(unit), 
				"msg": unit_traits.Angiok.Name
			}
		ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("Qamar") == true:
		if Global.Enemies.size() > 0:
		
			var action = {
				"name": "teleport_random", 
				"unit": unit, 
				"msg": unit_traits.Qamar.Name
			}
			ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("StandGround") == true:
				var trait = unit.get_traits().StandGround
		

				var buff = cloner.clone_dict(LBuffs.buff_data.Poise)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 10 * trait.Level
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": unit_traits.StandGround.Name
			}
				ProcessQueue.add_effect(action)
		
				
				for n in trait.Level:
			
					action = {
			"name": "attack_targets", 
			"attacker": unit, 
			"number_of_targets": 1, 
			"msg": unit_traits.StandGround.Name
		}
	
					ProcessQueue.add_effect(action)
	
	if unit_traits.has("Unataak"):
		
		var perform_times = 1
		if unit.get_hands_used() == 2:
			if translate.is_bare_fist(unit.weapon_main): perform_times += 1
			if translate.is_bare_fist(unit.weapon_off): perform_times += 1
		elif translate.is_bare_fist(unit.weapon_main): perform_times += 1
		
		for n in perform_times:
		
			var action = {
			"name": "attack_targets", 
			"attacker": unit, 
			"number_of_targets": 1, 
			"msg": unit_traits.Unataak.Name
		}
	
			ProcessQueue.add_effect(action)
		
			action = {
					"name": "remove_random_buff", 
					"target": unit, 
					"external": true, 
					"msg": unit_traits.Unataak.Name
		}
			ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("SummonGrika") == true:
		var trait = unit.get_traits().SummonGrika
		for ally in Global.Allies:
			if ally.get_name() == "Grika":
				for n in trait.Level:
			
					var action = {
			"name": "attack_targets", 
			"attacker": ally, 
			"number_of_targets": 1, 
			"msg": unit_traits.SummonGrika.Name
		}
	
					ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("Cryomancy"):
		var trait = unit.get_traits().Cryomancy
		for n in trait.Level:
			
				
				
				var buff = cloner.clone_dict(LBuffs.buff_data.Freeze)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 5
				var action = {
				"name": "buff_targets_in_range", 
				"caster": unit, 
				"effect_sprite": "Chill", 
				"number_of_targets": 2, 
				"effect_range": 3, 
				"buff": buff, 
				"is_allied": false, 
				"msg": unit_traits.Cryomancy.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit_traits.has("GloveIce"):
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.livingice, 
					"summoner": unit, 
					"msg": unit_traits.GloveIce.Name
				}
			ProcessQueue.add_effect(action)
			
			
			var buff = cloner.clone_dict(LBuffs.buff_data.Freeze)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = unit.get_total_WIL()
			action = {
				"name": "buff_targets_in_range", 
				"caster": unit, 
				"effect_sprite": "Chill", 
				"number_of_targets": 8, 
				"effect_range": 1, 
				"buff": buff, 
				"is_allied": false, 
				"msg": unit_traits.GloveIce.Name
				}
		
			ProcessQueue.add_effect(action)
	if unit.get_traits().has("Agara"):
		
		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": 30.0, 
				"damage_type": "ice", 
				"effect_sprite": "Ice", 
				"effect_range": 2, 
				"msg": unit_traits.Agara.Name
			}
		ProcessQueue.add_effect(action)
		action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": 30.0, 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"effect_range": 2, 
				"msg": unit_traits.Agara.Name
			}
		ProcessQueue.add_effect(action)
		action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": 30.0, 
				"damage_type": "lightning", 
				"effect_sprite": "Zap", 
				"effect_range": 2, 
				"msg": unit_traits.Agara.Name
			}
		ProcessQueue.add_effect(action)
		action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": 30.0, 
				"damage_type": "astral", 
				"effect_sprite": "Astral", 
				"effect_range": 2, 
				"msg": unit_traits.Agara.Name
			}
		ProcessQueue.add_effect(action)
	
	
	if unit.get_traits().has("Pyromancy"):
		var trait = unit.get_traits().Pyromancy
		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": trait.Level * 50.0, 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"effect_range": 2, 
				"msg": unit_traits.Pyromancy.Name
			}
		ProcessQueue.add_effect(action)
	
	if unit_traits.has("staff_earth"):
		
		
		var buff = cloner.clone_dict(LBuffs.buff_data.Poise)
		buff["target"] = unit
		buff["source"] = unit
		buff.duration = 3
		var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": unit_traits.staff_earth.Name
			}
		ProcessQueue.add_effect(action)
		
		
		action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": 5.0 * unit.get_total_weight(), 
				"damage_type": "blunt", 
				"effect_sprite": "Bash", 
				"effect_range": 4, 
				"msg": unit_traits.staff_earth.Name
			}
		ProcessQueue.add_effect(action)
		
		
	

		
	
		
		
		
		
		
		
		
		
		
	
	
	
	
	if unit.get_traits().has("Morbumancy"):
		var trait = unit.get_traits().Morbumancy
		for n in trait.Level:

				var buff = cloner.clone_dict(LBuffs.buff_data.Sickness)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 10
				var action = {
				"name": "buff_targets_in_range", 
				"caster": unit, 
				"effect_sprite": "Poison", 
				"number_of_targets": 1, 
				"effect_range": 3, 
				"buff": buff, 
				"is_allied": false, 
				"msg": unit_traits.Morbumancy.Name
				}
				ProcessQueue.add_effect(action)
	
	
	if unit.get_traits().has("stafffire") == true:
			
				var action = {
			"name": "magic_damage_targets_range", 
			"caster": unit, 
			"damage": unit.get_total_WIL() * 5.0, 
			"damage_type": "fire", 
			"effect_sprite": "Flame", 
			"number_of_targets": 5, 
			"effect_range": 99, 
			"msg": unit_traits.stafffire.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("VilePoison") == true:
			
				var action = {
			"name": "magic_damage_targets_range", 
			"caster": unit, 
			"damage": unit.get_total_WIL() * 5.0, 
			"damage_type": "poison", 
			"effect_sprite": "PoisonHit", 
			"number_of_targets": 99, 
			"effect_range": 3, 
			"msg": unit_traits.VilePoison.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("staffice") == true:
			
				var action = {
			"name": "magic_damage_targets_range", 
			"caster": unit, 
			"damage": unit.get_total_WIL() * 10.0, 
			"damage_type": "ice", 
			"effect_sprite": "Ice", 
			"number_of_targets": 99, 
			"effect_range": 3, 
			"msg": unit_traits.staffice.Name
				}
				ProcessQueue.add_effect(action)
				
				for enemy in Global.Enemies:
					if enemy.get_buff_names().has("Freeze"):
						action = {
					"name": "magic_damage_target", 
					"target": enemy, 
					"caster": unit, 
					"damage": unit.get_total_WIL() * 10.0, 
					"damage_type": "ice", 
					"effect_sprite": "Ice", 
					"msg": unit_traits.staffice.Name
				}
						ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("stafflightning") == true:
		var action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": unit, 
	"damage": 2.0 * unit.get_SPEED(), 
	"damage_type": "lightning", 
	"effect_sprite": "Zap", 
	"number_of_targets": 2, 
	"effect_range": 99, 
	"enemies": null, 
	"msg": unit_traits.stafflightning.Name
				}
		ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("StaffChaos") == true:
		
		
		if Global.Enemies.size():
			var action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": float(Global.rng.randi_range(1, 300)), 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"msg": unit_traits.StaffChaos.Name
				}
			ProcessQueue.add_effect(action)
		
			action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": unit, 
	"damage": float(Global.rng.randi_range(1, 100) * unit.get_total_WIL()), 
	"damage_type": "fire", 
	"effect_sprite": "Flame", 
	"number_of_targets": 1, 
	"effect_range": 99, 
	"enemies": null, 
	"msg": unit_traits.StaffChaos.Name
				}
			ProcessQueue.add_effect(action)
		
			action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": unit, 
	"damage": float(Global.rng.randi_range(1, 100) * unit.get_total_WIL()), 
	"damage_type": "death", 
	"effect_sprite": "Curse", 
	"number_of_targets": 1, 
	"effect_range": 99, 
	"enemies": null, 
	"msg": unit_traits.StaffChaos.Name
				}
			ProcessQueue.add_effect(action)
		
			action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": unit, 
	"damage": float(Global.rng.randi_range(1, 100) * unit.get_total_WIL()), 
	"damage_type": "blood", 
	"effect_sprite": "Blood", 
	"number_of_targets": 1, 
	"effect_range": 99, 
	"enemies": null, 
	"msg": unit_traits.StaffChaos.Name
				}
			ProcessQueue.add_effect(action)
		
			action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": unit, 
	"damage": float(Global.rng.randi_range(1, 100) * unit.get_total_WIL()), 
	"damage_type": "astral", 
	"effect_sprite": "Astral", 
	"number_of_targets": 1, 
	"effect_range": 99, 
	"enemies": null, 
	"msg": unit_traits.StaffChaos.Name
				}
			ProcessQueue.add_effect(action)
		
		
	
	
	
	
	if unit.get_traits().has("Ascetic"):

		
			var buff = cloner.clone_dict(LBuffs.buff_data.Meditate)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 4
			var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": unit_traits.Ascetic.Name
			}
			ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("StaffStar"):

			var damage = 20.0
			var action = {
				"name": "magic_damage_targets_range", 
			"caster": unit, 
			"damage": damage, 
			"damage_type": "astral", 
			"effect_sprite": "Astral", 
			"number_of_targets": 1, 
			"effect_range": 99, 
				"msg": unit_traits.StaffStar.Name
				}
			ProcessQueue.add_effect(action)
			
			
			var buff = cloner.clone_dict(LBuffs.buff_data.Meditate)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 3
			action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": unit_traits.StaffStar.Name
			}
			ProcessQueue.add_effect(action)
			
	
	if unit.get_traits().has("Paragon"):

		
			var buff = cloner.clone_dict(LBuffs.buff_data.Anoint)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 2
			var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": unit_traits.Paragon.Name
			}
			ProcessQueue.add_effect(action)
	
	if unit_traits.has("Torturer"):

		
			var buff = cloner.clone_dict(LBuffs.buff_data.Agony)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 2
			var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": unit_traits.Torturer.Name
			}
			ProcessQueue.add_effect(action)
	
	
	
	if unit_traits.has("IllProphet"):
			var msg = unit_traits.IllProphet.Name
			var tile = calcrange.get_random_ground_tile_non_terrain("strangetint")
			
			var multi = 0.0
			for tint in Global.Tile_Ground:
				if tint.tileset.title == "strangetint":
					multi += 1.0
			
			for enemy in Global.Enemies:
				if enemy.residence != null:
					if enemy.residence.tileset.title == "strangetint":
						var action = {
					"name": "magic_damage_target", 
					"target": enemy, 
					"caster": unit, 
					"damage": float(unit.get_total_WIL()) * multi, 
					"damage_type": "poison", 
					"effect_sprite": "PoisonHit", 
					"msg": msg
				}
						ProcessQueue.add_effect(action)
						
						action = {
					"name": "magic_damage_target", 
					"target": enemy, 
					"caster": unit, 
					"damage": float(unit.get_total_WIL()) * multi, 
					"damage_type": "astral", 
					"effect_sprite": "Astral", 
					"msg": msg
				}
						ProcessQueue.add_effect(action)
			
			var action = {
			"name": "change_tileset_in_area", 
			"tile_target": unit.residence, 
			"tileset": "strangetint", 
			"effect_range": 1, 
			"effect_sprite": "none", 
			
		}
			ProcessQueue.add_effect(action)
			
			if tile != null:
				action = {
			"name": "change_tileset_in_area", 
			"tile_target": tile, 
			"tileset": "strangetint", 
			"effect_range": 1, 
			"effect_sprite": "none", 
			
		}
				ProcessQueue.add_effect(action)
				
			
	
	if unit_traits.has("Frenzied"):
		if Global.Enemies.size() > 0:
			var msg = unit_traits.Frenzied.Name
				
			for check_buff in unit.Buffs:
				
				if check_buff.name == "Inflame":
					var action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": check_buff.duration * 1.0, 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": msg
				}
					ProcessQueue.add_effect(action)
					
					action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": check_buff.duration * 1.0, 
					"damage_type": "psychic", 
					"effect_sprite": "Psychic", 
					"msg": msg
				}
					ProcessQueue.add_effect(action)
				
					var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
					buff["target"] = unit
					buff["source"] = unit
					buff.duration = check_buff.duration
					action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": msg
			}
					ProcessQueue.add_effect(action)
				
							
			var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 10
			var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": msg
			}
			ProcessQueue.add_effect(action)
		
	
	if unit_traits.has("Tamasa"):
		if Global.Enemies.size() > 0:
			var msg = unit_traits.Tamasa.Name
				
			for check_buff in unit.Buffs:
				
				
				
				if check_buff.name == "Charge":
					var action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": check_buff.duration * 1.0, 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": msg
				}
					ProcessQueue.add_effect(action)
				
					var buff = cloner.clone_dict(LBuffs.buff_data.Charge)
					buff["target"] = unit
					buff["source"] = unit
					buff.duration = check_buff.duration
					action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": msg
			}
					ProcessQueue.add_effect(action)
				
				else:
					var action = {
					"name": "remove_buff", 
					"target": unit, 
					"buff": check_buff, 
					"msg": msg
		}
					ProcessQueue.add_effect(action)
			
			var action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": unit, 
	"damage": 100.0, 
	"damage_type": "lightning", 
	"effect_sprite": "Zap", 
	"number_of_targets": 2, 
	"effect_range": 99, 
	"enemies": null, 
	"msg": msg
				}
			ProcessQueue.add_effect(action)
			action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": unit, 
	"damage": 100.0, 
	"damage_type": "fire", 
	"effect_sprite": "Flame", 
	"number_of_targets": 2, 
	"effect_range": 99, 
	"enemies": null, 
	"msg": msg
				}
			ProcessQueue.add_effect(action)
			var buff = cloner.clone_dict(LBuffs.buff_data.Charge)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 5
			action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": msg
			}
			ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("StaffLife"):
		if Global.Enemies.size() > 0:
			var action = {
				"name": "heal", 
				"amount": 0.1 * float(unit.HP_max), 
				"healer_unit": unit, 
				"healed_unit": unit, 
				"msg": unit_traits.StaffLife.Name
			}
			ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("Parafrost"):
		var trait = unit.get_traits().Parafrost
		if Global.Enemies.size() > 0:
			
			
			var self_stacks = 0.0
			for buff in unit.Buffs:
				if buff.name == "Freeze":
					self_stacks += float(buff.duration)
			for enemy in Global.Enemies:
				
					var stacks = 0.0
					for buff in enemy.Buffs:
						if buff.name == "Freeze":
							stacks += float(buff.duration)
				
				
					if enemy.get_buff_names().has("Freeze"):
						var action = {
					"name": "magic_damage_target", 
					"target": enemy, 
					"caster": unit, 
					"damage": stacks * self_stacks, 
					"damage_type": "ice", 
					"effect_sprite": "Ice", 
					"msg": unit_traits.Parafrost.Name
				}
						ProcessQueue.add_effect(action)
			
			var buff = cloner.clone_dict(LBuffs.buff_data.Freeze)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = trait.Level * 3
			var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": unit_traits.Parafrost.Name
			}
			ProcessQueue.add_effect(action)
	
	
	if unit.get_traits().has("Gala"):
		if Global.Enemies.size() > 0:
			var heal_amount = float(unit.HP_max * 0.01)
			var multi = 0
			if unit == Global.Player:
				multi = 4 - Global.Player.get_armor_list().size()
			for n in multi:
		
				var action = {
			"name": "heal_allies_in_range", 
			"caster": unit, 
			"amount": heal_amount, 
			"effect_range": 20, 
			"msg": unit_traits.Gala.Name
			}
				ProcessQueue.add_effect(action)
			
			
				action = {
				"name": "heal", 
				"amount": heal_amount, 
				"healer_unit": unit, 
				"healed_unit": unit, 
				"msg": unit_traits.Gala.Name
			}
				ProcessQueue.add_effect(action)
	
	
	if unit_traits.has("Elementalist"):
		var kinesis_count = 0
		var kinesis_points = 0
		
		for key in unit.get_traits():
			var trait = unit.get_traits()[key]
			if trait.generic == false:
				if "kinesis" in textstrip.strip_bbcode(trait.Name).to_lower():
					kinesis_count += 1
					kinesis_points += trait.Level * trait.cost
		
		var hit = float(kinesis_points) * 20.0
		if kinesis_count > 0:
			for n in kinesis_count:
				var action = {
			"name": "hit_targets_range", 
			"attacker": unit, 
			"hit": hit, 
			"weapon": unit.weapon_main, 
			"effect_range": 4, 
			"number_of_targets": 1, 
			"msg": unit_traits.Elementalist.Name
				}
				ProcessQueue.add_effect(action)
	
	
	
	if unit.get_traits().has("Magus") == true:
		var trait = unit.get_traits().Magus
		for n in trait.Level:
			var action = {
			"name": "hit_targets_range", 
			"attacker": unit, 
			"hit": 20.0 * trait.Level, 
			"weapon": unit.weapon_main, 
			"effect_range": 4, 
			"number_of_targets": 1, 
			"msg": unit_traits.Magus.Name
				}
			ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("ArchMagus") == true:
		
		var action = {
			"name": "hit_targets_range", 
			"attacker": unit, 
			"hit": 100.0, 
			"weapon": unit.weapon_main, 
			"effect_range": 5, 
			"number_of_targets": 2, 
			"msg": unit_traits.ArchMagus.Name
				}
		ProcessQueue.add_effect(action)
	
	if unit_traits.has("Hat_Astral"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Meditate)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 2
			var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": unit_traits.Hat_Astral.Name
			}
			ProcessQueue.add_effect(action)
			
			
	
	if unit.get_traits().has("Hat_Psychic"):
		var damage = 0.0
		for buff in unit.Buffs:
			if buff.name == "Repulsion":
				damage += float(buff.duration)
		
		if damage >= 1.0:
			var action = {
			"name": "hit_targets_range", 
			"attacker": unit, 
			"hit": damage, 
			"weapon": unit.weapon_main, 
			"effect_range": 99, 
			"number_of_targets": 1, 
			"msg": unit_traits.Hat_Psychic.Name
				}
			ProcessQueue.add_effect(action)
		
		var buff = cloner.clone_dict(LBuffs.buff_data.Repulsion)
		buff["target"] = unit
		buff["source"] = unit
		buff.duration = 5
		var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": unit_traits.Hat_Psychic.Name
			}
		ProcessQueue.add_effect(action)
	
	if unit_traits.has("Hat_Poison"):
		
		
		for enemy in Global.Enemies:
			if enemy.get_buff_names().has("Sickness"):
				for buff in enemy.Buffs:
					if buff.name == "Sickness":
						var action = {
					"name": "magic_damage_target", 
					"target": enemy, 
					"caster": unit, 
					"damage": buff.duration * 10.0, 
					"damage_type": "poison", 
					"effect_sprite": "PoisonHit", 
					"msg": unit_traits.Hat_Poison.Name
				}
						ProcessQueue.add_effect(action)
		
		var buff = cloner.clone_dict(LBuffs.buff_data.Sickness)
		buff["target"] = unit
		buff["source"] = unit
		buff.duration = 5
		var action = {
				"name": "buff_targets_in_range", 
				"caster": unit, 
				"effect_sprite": "Poison", 
				"number_of_targets": 1, 
				"effect_range": 99, 
				"buff": buff, 
				"is_allied": false, 
				"msg": unit_traits.Hat_Poison.Name
				}
		ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("Hat_Curse"):
		var damage = float(25.0 * Global.Allies.size())
		var action = {
				"name": "magic_damage_target_closest", 
				"caster": unit, 
				"damage": damage, 
				"damage_type": "death", 
				"effect_sprite": "Curse", 
				"msg": unit_traits.Hat_Curse.Name
				}
		ProcessQueue.add_effect(action)
	
	
		
		
	
	if unit.get_traits().has("asclepa"):
		var damage = 5.0 * unit.get_total_WIL()
		var action = {
				"name": "magic_damage_target_closest", 
				"caster": unit, 
				"damage": damage, 
				"damage_type": "astral", 
				"effect_sprite": "Astral", 
				"msg": unit_traits.asclepa.Name
				}
		ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("Mesmer"):
		var buff = cloner.clone_dict(LBuffs.buff_data.Repulsion)
		buff["target"] = unit
		buff["source"] = unit
		buff.duration = 2
		var action2 = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": unit_traits.Mesmer.Name
			}
		ProcessQueue.add_effect(action2)
	
	
	if unit.get_traits().has("Arborus") and Global.Enemies.size():
		
		var buff = cloner.clone_dict(LBuffs.buff_data.Treeform)
		buff["target"] = unit
		buff["source"] = unit
		buff.duration = 6
		var action2 = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": unit_traits.Arborus.Name
			}
		ProcessQueue.add_effect(action2)
	
	if unit.get_traits().has("Psychokinesis"):
		var trait = unit.get_traits().Psychokinesis
		var action = {
			"name": "magic_damage_tiles_in_path_to_targets_in_range", 
			"caster": unit, 
			"damage": 30.0 * trait.Level, 
			"damage_type": "psychic", 
			"effect_sprite": "Psychic", 
			"number_of_targets": 1, 
			"effect_range": 5, 
			"enemies": null, 
			"msg": unit_traits.Psychokinesis.Name
				}
		ProcessQueue.add_effect(action)
				
		var buff = cloner.clone_dict(LBuffs.buff_data.Repulsion)
		buff["target"] = unit
		buff["source"] = unit
		buff.duration = 2 * trait.Level
		var action2 = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": unit_traits.Psychokinesis.Name
			}
		ProcessQueue.add_effect(action2)
	
	
	if unit.get_traits().has("Vigorlord"):
		var gain = 50.0
		for ally in Global.Allies:
			if ally != Global.Player:
				var action = {
				"name": "heal", 
				"amount": gain, 
				"healer_unit": unit, 
				"healed_unit": ally, 
				"msg": unit_traits.Vigorlord.Name
			}
				ProcessQueue.add_effect(action)
				
				action = {
			"name": "apply_bonus", 
			"origin": unit, 
			"target": ally, 
			"amount": gain, 
			"type": "life", 
			"msg": unit_traits.Vigorlord.Name
			}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("robe_wind"):
		for ally in Global.Allies:
			if ally != Global.Player:
				var action = {
			"name": "apply_bonus", 
			"origin": unit, 
			"target": ally, 
			"amount": 5.0, 
			"type": "speed", 
			"msg": unit_traits.robe_wind.Name
			}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("CommandBracers"):
		
		for ally in Global.Allies:
			if ally != Global.Player:
				var increase = float(ally.get_DMG(null)) * 0.1
				if increase > 50.0: increase = 50.0
				var action = {
			"name": "apply_bonus", 
			"origin": unit, 
			"target": ally, 
			"amount": increase, 
			"type": "damage", 
			"msg": unit_traits.CommandBracers.Name
			}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("Gehimon"):

		var damage = float(50 * Global.Allies.size())
		var action = {
				"name": "magic_damage_tiles_in_path_to_targets_in_range", 
				"caster": unit, 
				"damage": damage, 
				"damage_type": "death", 
				"effect_sprite": "Curse", 
				"number_of_targets": 2, 
				"effect_range": 3, 
				"enemies": null, 
				"msg": unit_traits.Gehimon.Name
				
				}
		ProcessQueue.add_effect(action)
	
	
	
	
	if unit.get_traits().has("AstralAssassin"):
		var target = ToolMagicMaker.get_closest_enemy(unit, ToolMagicMaker.get_enemies(unit))
		if target != null:
			var msg = unit.get_traits().AstralAssassin.Name
			ToolMagicMaker.add_attack(unit, unit.residence, target.residence, unit.get_range_attack(unit.weapon_main), target, unit.weapon_main, msg)
			
			var action = {
			"name": "teleport", 
			"unit": unit, 
			"tile_target": target.residence, 
			"msg": unit_traits.AstralAssassin.Name
			}
			ProcessQueue.add_effect(action)
	
	
	
	
	if unit.get_traits().has("Siku") == true:
		
		var action = {
				"name": "magic_damage_tiles_in_path_to_targets_in_range", 
				"caster": unit, 
				"damage": unit.get_total_inflex() * unit.get_total_WIL(), 
				"damage_type": "ice", 
				"effect_sprite": "Ice", 
				"number_of_targets": 1, 
				"effect_range": 99, 
				"enemies": null, 
				"msg": unit_traits.Siku.Name
				
				}
		ProcessQueue.add_effect(action)
	
	
	if unit.get_traits().has("Arba"):
		if Global.Enemies.size() > 0:
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.vinespawn, 
					"summoner": unit, 
					"msg": unit_traits.Arba.Name
				}
			ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("Mura"):
		if Global.Enemies.size() > 0:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.PearlMirror, 
					"summoner": unit, 
					"msg": unit_traits.Mura.Name
				}
				ProcessQueue.add_effect(action)
				
				for ally in calcrange.get_adjacent_allies(unit, Global.Allies):
					if ally.type.title == "PearlMirror":
						var msg = unit.get_traits().Mura.Name
						ToolMagicMaker.add_attack(unit, unit.residence, ally.residence, 1, ally, ally.weapon_main, msg)
				
	
	if unit.get_traits().has("Gliva"):
		if Global.Enemies.size() > 0:
			for n in 2:
				var action = {
					"name": "summon_random", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Mushroom, 
					"summoner": unit, 
					"msg": unit_traits.Gliva.Name
				}
				ProcessQueue.add_effect(action)
	
	
	if unit.get_traits().has("Druid"):
		if Global.Enemies.size() > 0:
			var amount = 1
			for n in amount:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.fleshfly, 
					"summoner": unit, 
					"msg": unit_traits.Druid.Name
				}
				ProcessQueue.add_effect(action)

	if unit.get_traits().has("Astrohunting"):
		var trait = unit.get_traits().Astrohunting
		var target = ToolMagicMaker.get_closest_enemy(unit, ToolMagicMaker.get_enemies(unit))
		if target != null:
			
			
			var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": 100.0 * trait.Level, 
				"damage_type": "astral", 
				"effect_sprite": "Astral", 
				"effect_range": 1, 
				"msg": unit_traits.Astrohunting.Name
			}
			ProcessQueue.add_effect(action)
			
			action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": 100.0 * trait.Level, 
				"damage_type": "lightning", 
				"effect_sprite": "Zap", 
				"effect_range": 1, 
				"msg": unit_traits.Astrohunting.Name
			}
			ProcessQueue.add_effect(action)
			
			
			
			action = {
			"name": "teleport", 
			"unit": unit, 
			"tile_target": target.residence, 
			"msg": unit_traits.Astrohunting.Name
			}
			ProcessQueue.add_effect(action)
	if unit.get_traits().has("Fawdaa"):
		for buff in unit.Buffs:
					if buff.name == "Stasis":
						var action = {
						"name": "remove_buff", 
						"target": unit, 
						"buff": buff, 
						"msg": unit_traits.Fawdaa.Name
						}
						
						ProcessQueue.add_effect(action)

	
	if unit == Global.Player:
		for unit in Global.Enemies:
			var traits = unit.get_traits()
			
			if traits.has("Prescience"):
				var buff = cloner.clone_dict(LBuffs.buff_data.Meditate)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 5
				var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": traits.Prescience.Name
			}
				ProcessQueue.add_effect(action)
			
			if traits.has("Gati"):
				var buff = cloner.clone_dict(LBuffs.buff_data.Repulsion)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 5
				var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": traits.Gati.Name
			}
				ProcessQueue.add_effect(action)

static func add_score(unit):
	if unit == Global.Player:
			StatePlayerSheet.score_data.times_stood += 1
