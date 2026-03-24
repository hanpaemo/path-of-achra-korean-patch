extends Node


class_name event_hit

static func check(attacker, defender, weapon, hit, msg):
	
	var imp_type = ""
	var damage_types = ["slash", "pierce", "blunt", "fire", "lightning", "ice", "astral", "poison", "death", "blood", "psychic"]
	if attacker.get_traits().has("Imp"):
			
			imp_type = damage_types[Global.rng.randi_range(0, damage_types.size() - 1)]
	
	
	var effect_sprite = attacker.get_DMG_type(weapon)
	if imp_type != "":
		effect_sprite = imp_type

	effect_art(attacker, defender, weapon, effect_sprite)
	

	hit += 0.0
	if defender == Global.Player:
		ToolInvokes.lose_charge("being hit")
	var msg_string = message_hit(defender, attacker, hit, msg)
	ToolMessageCreator.add_message("[color=#c0c0c0]", msg_string)
	
	check_effects(attacker, defender, weapon, hit)
	
	
	
	
	
	
	msg = "명중"
	
	
	event_damage.check(hit, effect_sprite, attacker, defender, msg)
	
	
		
	




static func check_effects(attacker, defender, weapon, hit):
	
	var attacker_traits = attacker.get_traits()
	var defender_traits = defender.get_traits()
	var player_traits = Global.Player.get_traits()
	

	for buff in defender.Buffs:
		
		if buff.name == "Inflame":
			if defender_traits.has("chest_gold") == false:
				var action = {
					"name": "reduce_buff", 
					"target": defender, 
					"buff": buff, 
					"duration": int(float(buff.duration) / 2.0), 
					"msg": "피격"
		}
				ProcessQueue.add_effect(action)
	
	
	
	var unit = attacker
	if unit.HP < unit.HP_max:
		if Global.Player.get_traits().has("Humbaba"):
			for buff in unit.Buffs:
				if buff.name == "Bloodrage":
					var action = {
					"name": "heal", 
					"amount": 5.0 * buff.duration, 
					"healer_unit": unit, 
					"healed_unit": unit, 
					"msg": "Bloodrage"
				}
					ProcessQueue.add_effect(action)
		
		if attacker_traits.has("Batform"):
			for buff in unit.Buffs:
				if buff.name == "Batform":
					var action = {
					"name": "heal", 
					"amount": 5 * buff.duration, 
					"healer_unit": unit, 
					"healed_unit": unit, 
					"msg": "Batform"
					
				}
					ProcessQueue.add_effect(action)
	
	
	
	if defender_traits.has("PsychicRetort"):
		
		var new_hit = 1.0
		for buff in defender.Buffs:
			if buff.name == "Repulsion":
				new_hit += buff.duration
				
		new_hit = float(new_hit)
		for n in 2:
			var msg = defender_traits.PsychicRetort.Name
			ToolMagicMaker.add_hit_event(attacker, defender, new_hit, weapon, msg)
		
		
	
	
	if Global.Allies.has(defender) and Global.Enemies.has(attacker):
		if defender != Global.Player:
			if Global.Player != null and Global.Player.is_dead() == false:
				if player_traits.has("Psychomorphism"):
					
					var sp_damage = 15.0
					
					var msg = player_traits.Psychomorphism.Name
					ToolMagicMaker.add_hit_event(Global.Player, attacker, sp_damage, null, msg)
	
	if Global.Allies.has(attacker) and Global.Enemies.has(defender):
		if attacker != Global.Player:
			if Global.Player != null and Global.Player.is_dead() == false:
				
				if player_traits.has("Psychomorphism"):
					var trait = Global.Player.get_traits().Psychomorphism
					var sp_damage = 15.0
					for n in trait.Level:
						var msg = player_traits.Psychomorphism.Name
						ToolMagicMaker.add_hit_event(defender, Global.Player, sp_damage, Global.Player.weapon_main, msg)
	
				
				
				
			
			
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
	
	
	
		
	
	
	
	if defender_traits.has("Rampage"):
		var trait = defender_traits.Rampage
		for n in trait.Level:
			
			var action = {
			"name": "attack_targets", 
			"attacker": defender, 
			"number_of_targets": 1, 
			"msg": defender_traits.Rampage.Name
		}
	
			ProcessQueue.add_effect(action)
			
	if attacker_traits.has("Psiblade") == true:
		if translate.is_bare_fist(weapon):
			var trait = attacker.get_traits().Psiblade
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": trait.Level * 50.0, 
					"damage_type": "psychic", 
					"effect_sprite": "Psychic", 
					"msg": attacker_traits.Psiblade.Name
				}
			ProcessQueue.add_effect(action)
			
			action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": trait.Level * 50.0, 
					"damage_type": "slash", 
					"effect_sprite": "Slash", 
					"msg": attacker_traits.Psiblade.Name
				}
			ProcessQueue.add_effect(action)
	
	
	if attacker_traits.has("UnstableThirst"):
		var trait = attacker_traits.UnstableThirst
		
		var action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": attacker, 
					"damage": 15.0, 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": attacker_traits.UnstableThirst.Name
				}
		ProcessQueue.add_effect(action)
		
		var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
		buff["target"] = attacker
		buff["source"] = attacker
		buff.duration = 2 * trait.Level
		action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": attacker_traits.UnstableThirst.Name
			}
		ProcessQueue.add_effect(action)
		
		action = {
					"name": "heal", 
					"amount": trait.base * trait.Level, 
					"healer_unit": unit, 
					"healed_unit": unit, 
					"msg": attacker_traits.UnstableThirst.Name
				}
		ProcessQueue.add_effect(action)
		
		
	
	
	if attacker_traits.has("AuraManica"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
			buff["target"] = attacker
			buff["source"] = attacker
			buff.duration = 5
			var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": attacker_traits.AuraManica.Name
			}
			ProcessQueue.add_effect(action)
		
			
				
			
			
			
			
		
		
	
	
	
	
	if attacker_traits.has("Psychokinesis"):
		var trait = attacker_traits.Psychokinesis
		var action = {
			"name": "magic_damage_tiles_in_path_to_targets_in_range", 
			"caster": unit, 
			"damage": 30.0 * trait.Level, 
			"damage_type": "psychic", 
			"effect_sprite": "Psychic", 
			"number_of_targets": 1, 
			"effect_range": 5, 
			"enemies": null, 
			"msg": attacker_traits.Psychokinesis.Name
				}
		ProcessQueue.add_effect(action)
				
		var buff = cloner.clone_dict(LBuffs.buff_data.Repulsion)
		buff["target"] = unit
		buff["source"] = unit
		buff.duration = 2 * trait.Level
		var action2 = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Psychokinesis.Name
			}
		ProcessQueue.add_effect(action2)
	
	if attacker_traits.has("FrostKnight"):
		for buffs in defender.Buffs:
			if buffs.name == "Freeze":
				var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": attacker, 
				"damage": attacker.get_total_weight() * buffs.duration, 
				"damage_type": "blunt", 
				"effect_sprite": "Bash", 
				"effect_range": 2, 
				"msg": attacker_traits.FrostKnight.Name
			}
				ProcessQueue.add_effect(action)
				
	if attacker_traits.has("Purge"):
		for buff in defender.Buffs:
			var action = {
					"name": "remove_buff", 
					"target": defender, 
					"buff": buff, 
					"msg": "적의 정화"
		}
			ProcessQueue.add_effect(action)
			
	if attacker_traits.has("Damunja"):
	
		if defender.get_buff_names().has("Bleed") and attacker.get_buff_names().has("Bleed"):
			var stacks = 0.0
			for buff in defender.Buffs:
				if buff.name == "Bleed":
					stacks += float(buff.duration)
			
			var self_stacks = 0.0
			for buff in attacker.Buffs:
				if buff.name == "Bleed":
					self_stacks += float(buff.duration)
					
			var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": stacks * self_stacks, 
					"damage_type": "lightning", 
					"effect_sprite": "Zap", 
					"msg": attacker_traits.Damunja.Name
				}
			ProcessQueue.add_effect(action)
			
			action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": attacker, 
				"damage": stacks * self_stacks, 
				"damage_type": "lightning", 
				"effect_sprite": "Zap", 
				"effect_range": 1, 
				"msg": attacker_traits.Damunja.Name
			}
			ProcessQueue.add_effect(action)
			
		var action = {
					"name": "magic_damage_target", 
					"target": attacker, 
					"caster": attacker, 
					"damage": 15.0, 
					"damage_type": "lightning", 
					"effect_sprite": "Zap", 
					"msg": attacker_traits.Damunja.Name
				}
		ProcessQueue.add_effect(action)
			
	
	if attacker_traits.has("Sesha"):
		var action = {
			"name": "magic_damage_targets_range", 
			"caster": attacker, 
			"damage": 20.0 * attacker.get_total_DEX(), 
			"damage_type": "astral", 
			"effect_sprite": "Astral", 
			"effect_range": 2, 
			"number_of_targets": 30, 
			"msg": attacker_traits.Sesha.Name
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
	
	if attacker_traits.has("Arjana"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Blind)
			buff["target"] = defender
			buff["source"] = attacker
			buff.duration = 1
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Arjana.Name
				}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Azar"):
		var trait = attacker_traits.Azar
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
			var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": attacker, 
				"damage": 30.0 * trait.Level, 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"effect_range": 1, 
				"msg": attacker_traits.Azar.Name
			}
			ProcessQueue.add_effect(action)
		else:
			var action = {
				"name": "magic_damage_tiles_in_area", 
				"caster": attacker, 
				"damage": 30.0 * trait.Level, 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"effect_range": 1, 
				"target_tile": defender.residence, 
				"msg": attacker_traits.Azar.Name
				}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Elding") == true:
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
			var action = {
				"name": "magic_damage_tiles_in_line", 
				"target": defender, 
				"caster": attacker, 
				"damage": 40.0 * attacker.get_traits()["Elding"].Level, 
				"damage_type": "lightning", 
				"effect_sprite": "Zap", 
				"msg": attacker_traits.Elding.Name
			}
			ProcessQueue.add_effect(action)
		else:
			var action = {
				"name": "magic_damage_tiles_in_path", 
				"target": defender, 
				"caster": attacker, 
				"damage": 40.0 * attacker.get_traits()["Elding"].Level, 
				"damage_type": "lightning", 
				"effect_sprite": "Zap", 
				"msg": attacker_traits.Elding.Name
			}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Inuk") == true:
		
		var trait = attacker_traits.Inuk
		var action = {
			"name": "magic_damage_targets_range", 
			"caster": attacker, 
			"damage": 35.0 * trait.Level, 
			"damage_type": "ice", 
			"effect_sprite": "Ice", 
			"effect_range": 1, 
			"number_of_targets": 2, 
			"msg": attacker_traits.Inuk.Name
				}
		ProcessQueue.add_effect(action)
		
		var buff = cloner.clone_dict(LBuffs.buff_data.Freeze)
		buff["target"] = defender
		buff["source"] = attacker
		buff.duration = 5
		action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Inuk.Name
			}
		ProcessQueue.add_effect(action)
	
	
	
	if attacker_traits.has("MavetKa") == true:
		var trait = attacker_traits.MavetKa
		var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 35.0 * trait.Level, 
					"damage_type": "death", 
					"effect_sprite": "Curse", 
					"msg": attacker_traits.MavetKa.Name
				}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Aim"):
		
		var buff = cloner.clone_dict(LBuffs.buff_data.Mark)
		buff["target"] = defender
		buff["source"] = attacker
		buff["duration"] = attacker.get_traits().Aim.Level
		var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": attacker_traits.Aim.Name
		}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Ikami"):
		
			
				
					
		var buff = cloner.clone_dict(LBuffs.buff_data.Charge)
		buff["target"] = attacker
		buff["source"] = attacker
		buff["duration"] = attacker.get_traits().Ikami.Level
		var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": attacker_traits.Ikami.Name
		}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("ArchMagus"):
		var buff = cloner.clone_dict(LBuffs.buff_data.Meditate)
		buff["target"] = attacker
		buff["source"] = attacker
		buff["duration"] = 1
		var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": attacker_traits.ArchMagus.Name
		}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Chuluma") == true:
		var trait = attacker_traits.Chuluma
		for buff in defender.Buffs:
			if buff.name == "Entangle":
				var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 5.0 * trait.Level * buff.duration, 
					"damage_type": "blood", 
					"effect_sprite": "Blood", 
					"msg": attacker_traits.Chuluma.Name
				}
				ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Ara"):
			var trait = attacker_traits.Ara
			var action = {
			"name": "magic_damage_tiles_in_path_to_targets_in_range", 
			"caster": unit, 
			"damage": 30.0 * trait.Level, 
			"damage_type": "astral", 
			"effect_sprite": "Astral", 
			"number_of_targets": 2, 
			"effect_range": 99, 
			"enemies": null, 
			"msg": attacker_traits.Ara.Name
				}
			ProcessQueue.add_effect(action)
	if attacker_traits.has("Venite"):
			var action = {
			"name": "magic_damage_tiles_in_path_to_targets_in_range", 
			"caster": unit, 
			"damage": 100.0, 
			"damage_type": "poison", 
			"effect_sprite": "PoisonHit", 
			"number_of_targets": 3, 
			"effect_range": 3, 
			"enemies": null, 
			"msg": attacker_traits.Venite.Name
				}
			ProcessQueue.add_effect(action)
	
	
	
	
	
	
	
	if attacker_traits.has("HitZap") == true:
		
		var ldamage = float(attacker.get_SPEED())
		var action = {
				"name": "magic_damage_tiles_in_path", 
				"target": defender, 
				"caster": attacker, 
				"damage": ldamage, 
				"damage_type": "lightning", 
				"effect_sprite": "Zap", 
				"msg": attacker_traits.HitZap.Name
			}
		for n in 1:
			action = {
				"name": "magic_damage_tiles_in_path_to_targets_in_range", 
				"caster": attacker, 
				"damage": ldamage, 
				"damage_type": "lightning", 
				"effect_sprite": "Zap", 
				"number_of_targets": 2, 
				"effect_range": 99, 
				"enemies": null, 
				"msg": attacker_traits.HitZap.Name
				}
			ProcessQueue.add_effect(action)
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Incinerate"):
			var action = {
				"name": "magic_damage_tiles_in_area", 
				"caster": attacker, 
				"damage": 20, 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"effect_range": 1, 
				"target_tile": defender.residence, 
				"msg": attacker_traits.Incinerate.Name
				}
			ProcessQueue.add_effect(action)
		
	if attacker_traits.has("Scourge"):
			var action = {
				"name": "magic_damage_tiles_in_area", 
				"caster": attacker, 
				"damage": 10, 
				"damage_type": "death", 
				"effect_sprite": "Curse", 
				"effect_range": 2, 
				"target_tile": defender.residence, 
				"msg": attacker_traits.Scourge.Name
				}
			ProcessQueue.add_effect(action)
		
	if attacker_traits.has("PoisonHit") == true:
		
			var buff = cloner.clone_dict(LBuffs.buff_data.Sickness)
			buff["target"] = defender
			buff["source"] = attacker
			buff.duration = 8
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.PoisonHit.Name
			}
			ProcessQueue.add_effect(action)
	
	
	

		
	if attacker_traits.has("BleedHit") == true:
			var buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
			buff["target"] = defender
			buff["source"] = attacker
			buff.duration = 5
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.BleedHit.Name
			}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("Hemokinesis") == true:
			var buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
			buff["target"] = defender
			buff["source"] = attacker
			buff.duration = 5
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.Hemokinesis.Name
			}
			ProcessQueue.add_effect(action)
	
	if defender_traits.has("Volkite") == true:
		if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == true:
			var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": defender, 
				"damage": defender.get_total_weight() * 20.0, 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"effect_range": 2, 
				"msg": defender_traits.Volkite.Name
			}
			ProcessQueue.add_effect(action)
		
	if attacker_traits.has("ChillHit") == true:
			var buff = cloner.clone_dict(LBuffs.buff_data.Freeze)
			buff["target"] = defender
			buff["source"] = attacker
			buff.duration = 8
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.ChillHit.Name
			}
			ProcessQueue.add_effect(action)
	
	
	if attacker_traits.has("HitParalysis") == true:
			var buff = cloner.clone_dict(LBuffs.buff_data.Paralysis)
			buff["target"] = defender
			buff["source"] = attacker
			buff.duration = 2
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.HitParalysis.Name
			}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("HitBlind") == true:
			var buff = cloner.clone_dict(LBuffs.buff_data.Blind)
			buff["target"] = defender
			buff["source"] = attacker
			buff.duration = 5
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.HitBlind.Name
			}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("BurnHit") == true:
			var buff = cloner.clone_dict(LBuffs.buff_data.Scorch)
			buff["target"] = defender
			buff["source"] = attacker
			buff.duration = 7
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.BurnHit.Name
			}
			ProcessQueue.add_effect(action)
	
	if defender.get_traits().has("Agara"):
		
		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": defender, 
				"damage": 30.0, 
				"damage_type": "ice", 
				"effect_sprite": "Ice", 
				"effect_range": 2, 
				"msg": defender_traits.Agara.Name
			}
		ProcessQueue.add_effect(action)
		action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": defender, 
				"damage": 30.0, 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"effect_range": 2, 
				"msg": defender_traits.Agara.Name
			}
		ProcessQueue.add_effect(action)
		action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": defender, 
				"damage": 30.0, 
				"damage_type": "lightning", 
				"effect_sprite": "Zap", 
				"effect_range": 2, 
				"msg": defender_traits.Agara.Name
			}
		ProcessQueue.add_effect(action)
		action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": defender, 
				"damage": 30.0, 
				"damage_type": "astral", 
				"effect_sprite": "Astral", 
				"effect_range": 2, 
				"msg": defender_traits.Agara.Name
			}
		ProcessQueue.add_effect(action)
	
	
	if attacker_traits.has("Nartaka") == true:
		
		var adamage = attacker.get_total_DEX() * attacker.get_total_WIL()
		var action = {
			"name": "magic_damage_targets_range", 
			"caster": attacker, 
			"damage": adamage, 
			"damage_type": "lightning", 
			"effect_sprite": "Zap", 
			"number_of_targets": 1, 
			"effect_range": 4, 
			"msg": attacker_traits.Nartaka.Name
				}
		ProcessQueue.add_effect(action)
		
	
	if attacker_traits.has("Sorcerer") == true:
		var action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": unit, 
	"damage": 5.0 * unit.level, 
	"damage_type": unit.get_DMG_type(unit.weapon_main), 
	"effect_sprite": translate.dmgtype_to_animation(unit.get_DMG_type(unit.weapon_main)), 
	"number_of_targets": 1, 
	"effect_range": 99, 
	"enemies": null, 
	"msg": attacker_traits.Sorcerer.Name
				}
		ProcessQueue.add_effect(action)
	
	
	if attacker_traits.has("Thunderblade") == true:
		var action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": attacker, 
	"damage": 5.0 * attacker.get_SPEED(), 
	"damage_type": "lightning", 
	"effect_sprite": "Zap", 
	"number_of_targets": 2, 
	"effect_range": 99, 
	"enemies": null, 
	"msg": attacker_traits.Thunderblade.Name
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
	
	if attacker_traits.has("Dianmai") == true:
		for buffs in attacker.Buffs:
			if buffs.name == "Evasion":
				var action = {
					"name": "magic_damage_target", 
					"target": defender, 
					"caster": attacker, 
					"damage": 10.0 * buffs.duration, 
					"damage_type": "pierce", 
					"effect_sprite": "Pierce", 
					"msg": attacker_traits.Dianmai.Name
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
	
	if attacker_traits.has("EntangleHit") == true:
			var buff = cloner.clone_dict(LBuffs.buff_data.Entangle)
			buff["target"] = defender
			buff["source"] = attacker
			buff.duration = 6
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.EntangleHit.Name
			}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("CorrosionHit") == true:
		var buff = cloner.clone_dict(LBuffs.buff_data.Corrosion)
		buff["target"] = defender
		buff["source"] = attacker
		buff.duration = 7
		var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.CorrosionHit.Name
			}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("DoomHit") == true:
		var buff = cloner.clone_dict(LBuffs.buff_data.Doom)
		buff["target"] = defender
		buff["source"] = attacker
		buff.duration = 5
		var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.DoomHit.Name
			}
		ProcessQueue.add_effect(action)
	
	if attacker_traits.has("AstralTechnique"):
		var trait = attacker_traits.AstralTechnique
		var damage = 100.0 * trait.Level
		var action = {
			"name": "magic_damage_targets_range", 
			"caster": unit, 
			"damage": damage, 
			"damage_type": "astral", 
			"effect_sprite": "Astral", 
			"number_of_targets": 3, 
			"effect_range": 99, 
			"msg": attacker_traits.AstralTechnique.Name
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
					
		
	if attacker_traits.has("FireHealing") == true:
		var trait = attacker_traits.FireHealing
		
		var buff = cloner.clone_dict(LBuffs.buff_data.Scorch)
		buff["target"] = defender
		buff["source"] = attacker
		buff.duration = 2 * trait.Level
		var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.FireHealing.Name
			}
		ProcessQueue.add_effect(action)
		
	if attacker_traits.has("PoisonPalm") == true:
			var buff = cloner.clone_dict(LBuffs.buff_data.Sickness)
			buff["target"] = defender
			buff["source"] = attacker
			buff.duration = 5
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": attacker_traits.PoisonPalm.Name
			}
			ProcessQueue.add_effect(action)
		
	if attacker_traits.has("DisruptionHit") == true:
			var action = {
				"name": "teleport_random", 
				"unit": defender, 
				"msg": attacker_traits.DisruptionHit.Name
			}
			ProcessQueue.add_effect(action)
	
	if attacker_traits.has("TransalChakram") == true:
			var action = {
				"name": "teleport_random", 
				"unit": defender, 
				"msg": attacker_traits.TransalChakram.Name
			}
			ProcessQueue.add_effect(action)
		
	if attacker_traits.has("Autoblink") == true:
			var action = {
				"name": "teleport", 
				"unit": attacker, 
				"tile_target": calcrange.get_random_open_tile(), 
				"msg": attacker_traits.Autoblink.Name
			}
			ProcessQueue.add_effect(action)
		
	if attacker_traits.has("SummonDancingFlesh") == true:
			var action = {
					"name": "summon", 
					"alliance": "enemy", 
					"type": LEnemies.enemy_data.dancing_flesh, 
					"summoner": attacker, 
					"msg": attacker_traits.SummonDancingFlesh.Name
				}
			ProcessQueue.add_effect(action)
			

static func message_hit(defender, attacker, hit, msg):
	
	
	var name_a = attacker.get_name_color()
	var name_d = defender.get_name_color()
	var damage_text = "[color=#ff8030]명중[/color]"
	
	
	var stringa = "..."
	
	
	
	if attacker == Global.Player and defender == Global.Player:

		name_a = ""
		name_d = "자신"
		stringa = name_a + name_d + "을(를) " + damage_text + " "
	elif attacker == Global.Player:
	
		name_a = ""
		stringa = name_a + name_d + "을(를) " + damage_text + " "
	elif defender == Global.Player:

		name_d = ""
		stringa = name_a + "(이)가 당신을 " + damage_text + " "
	
	elif attacker == defender:
	
		stringa = "[color=#707070]" + name_a + "(이)가 자신을 " + damage_text + " "
	
	else:
		
		stringa = "[color=#707070]" + name_a + "(이)가 " + name_d + "을(를) " + damage_text + " "
	
	
	if msg != "":
		
			
		if ToolSettings.settings_data.log_detail == true:
			stringa += "[color=#707070] <- " + ({"Familiar": "사역마", "Summoned": "소환됨", "Initial": "최초", "Hit": "명중", "공격": "공격", "Being hit": "피격", "enemy Purges you": "적의 정화"}.get(textstrip.strip_bbcode(msg), textstrip.strip_bbcode(msg))) + " " + str(int(hit)) + "[/color]"
		else:
			stringa += "[color=#707070] <- " + ({"Familiar": "사역마", "Summoned": "소환됨", "Initial": "최초", "Hit": "명중", "공격": "공격", "Being hit": "피격", "enemy Purges you": "적의 정화"}.get(textstrip.strip_bbcode(msg), textstrip.strip_bbcode(msg))) + "[/color]"
	
	return stringa
	
	
	






			
static func effect_art(_attacker, defender, _weapon, dmg_type):
	
	
	
	match dmg_type:
		"pierce":
		
			
			effectmaker.create_effect_animated(defender.global_position, Global.EffectAnimated, "Pierce")
		"slash":
			
			
			effectmaker.create_effect_animated(defender.global_position, Global.EffectAnimated, "Slash")
		"blunt":
		
			
			effectmaker.create_effect_animated(defender.global_position, Global.EffectAnimated, "Blunt")
		"blood":
		
			
			effectmaker.create_effect_animated(defender.global_position, Global.EffectAnimated, "Blood")
		"fire":
			
			effectmaker.create_effect_animated(defender.global_position, Global.EffectAnimated, "Flame")
		"lightning":
			
			effectmaker.create_effect_animated(defender.global_position, Global.EffectAnimated, "Zap")
		"astral":
			
			effectmaker.create_effect_animated(defender.global_position, Global.EffectAnimated, "Astral")
		"poison":
			
			effectmaker.create_effect_animated(defender.global_position, Global.EffectAnimated, "PoisonHit")
		"psychic":
			
			effectmaker.create_effect_animated(defender.global_position, Global.EffectAnimated, "Psychic")
		"ice":
			
			effectmaker.create_effect_animated(defender.global_position, Global.EffectAnimated, "Ice")
		"death":
			
			effectmaker.create_effect_animated(defender.global_position, Global.EffectAnimated, "Curse")
