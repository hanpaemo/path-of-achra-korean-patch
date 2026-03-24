extends Node


class_name event_invoke


static func check(label):
	var caster = Global.Player
	var god = StatePlayerSheet.God
	ToolInvokes.recharge(label)
	effects(caster, label, god)
	
	
	
	
static func effects(caster, label, god):
	
	add_score(caster)
	
	var unit = caster
	
	var traits = caster.get_traits()
	var buffs = unit.Buffs
	for buff in buffs:
		
		
		if buff.name == "Beastform":
				var duration = 1
				var action = {
					"name": "reduce_buff", 
					"target": caster, 
					"buff": buff, 
					"duration": duration, 
					"msg": "non-attack action"
		}
				ProcessQueue.add_effect(action)
		
		if buff.name == "Attune":
			if caster.get_traits().has("Naqui"):
				var amount = int(float(buff.duration * 0.2))
				if amount > 30: amount = 30
				if amount < 2: amount = 2

				var action = {
					"name": "reduce_buff", 
					"target": unit, 
					"buff": buff, 
					"duration": amount * - 1, 
					"msg": caster.get_traits().Naqui.Name
		}
				ProcessQueue.add_effect(action)

	if unit.get_traits().has("Magus"):
		if int(unit.get_total_weight()) <= int(unit.get_total_STR()):
			if int(unit.get_total_inflex()) <= 1:
				ToolMessageCreator.add_message("[color=#c07070]", Global.Player.get_traits().Magus.Name + "(이)가 '제자리 대기' 행동 수행...")
				event_move.check_wait(Global.Player)
	
	if unit.get_traits().has("Agara"):
		
			
				ToolMessageCreator.add_message("[color=#c07070]", Global.Player.get_traits().Agara.Name + "(이)가 '제자리 대기' 행동 수행...")
				event_move.check_wait(Global.Player)

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
			"msg": unit.get_traits().Gala.Name
			}
				ProcessQueue.add_effect(action)
			
			
				action = {
				"name": "heal", 
				"amount": heal_amount, 
				"healer_unit": unit, 
				"healed_unit": unit, 
				"msg": unit.get_traits().Gala.Name
			}
				ProcessQueue.add_effect(action)
	
	if caster.get_traits().has("Ashem"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Grace)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 3
			var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": caster.get_traits().Ashem.Name
			}
			ProcessQueue.add_effect(action)
	
	if caster.get_traits().has("Baghatar"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Gust)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = 3
			var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": caster.get_traits().Baghatar.Name
			}
			ProcessQueue.add_effect(action)

	if caster.get_traits().has("Azhdaha"):
		var buff = cloner.clone_dict(LBuffs.buff_data.Drakeform)
		buff["target"] = unit
		buff["source"] = unit
		buff.duration = 5
		var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": caster.get_traits().Azhdaha.Name
		}
		ProcessQueue.add_effect(action)


	if caster.get_traits().has("Geistform"):
		
			var trait = caster.get_traits().Geistform
			var buff = cloner.clone_dict(LBuffs.buff_data.Crystalform)
			buff["target"] = caster
			buff["source"] = caster
			buff.duration = 5 * trait.Level
			var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": caster.get_traits().Geistform.Name
			}
			ProcessQueue.add_effect(action)
	
	
	if traits.has("ChannelDeath"):
		if Global.Enemies.size() > 0:
			var trait = traits.ChannelDeath
		
			var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": trait.Level * 100.0, 
				"damage_type": "ice", 
				"effect_sprite": "Ice", 
				"effect_range": trait.Level, 
				"msg": traits.ChannelDeath.Name
			}
			ProcessQueue.add_effect(action)
		
			action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": trait.Level * 100.0, 
				"damage_type": "death", 
				"effect_sprite": "Curse", 
				"effect_range": trait.Level, 
				"msg": traits.ChannelDeath.Name
			}
			ProcessQueue.add_effect(action)
		
			action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": 25.0, 
					"damage_type": "ice", 
					"effect_sprite": "Ice", 
					"msg": traits.ChannelDeath.Name
				}
			ProcessQueue.add_effect(action)
		
			
			
			
			
			
			
			
			
			
			
	
	if traits.has("BerserkerStaff"):

				var buff = cloner.clone_dict(LBuffs.buff_data.Berserk)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 5
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": traits.BerserkerStaff.Name
				}
				ProcessQueue.add_effect(action)
				
				for checkbuff in unit.Buffs:
					if checkbuff.name == "Berserk":
						action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": unit, 
	"damage": checkbuff.duration * 10.0, 
	"damage_type": "slash", 
	"effect_sprite": "Slash", 
	"number_of_targets": 1, 
	"effect_range": 99, 
	"enemies": null, 
	"msg": traits.BerserkerStaff.Name
				}
						ProcessQueue.add_effect(action)
	
	
	if traits.has("FrenziedChant"):
		if Global.Enemies.size() > 0:
			
			for n in traits.FrenziedChant.Level:
			
					var action = {
			"name": "attack_targets", 
			"attacker": unit, 
			"number_of_targets": 1, 
			"msg": traits.FrenziedChant.Name
		}
					ProcessQueue.add_effect(action)
			
			var new_buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
			new_buff["target"] = unit
			new_buff["source"] = unit
			new_buff.duration = 5 * traits.FrenziedChant.Level
			var action = {
				"name": "add_buff", 
				"buff": new_buff, 
				"msg": "Frenzied Chant"
			}
			ProcessQueue.add_effect(action)
			
	
			action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": 25.0, 
					"damage_type": "psychic", 
					"effect_sprite": "Psychic", 
					"msg": traits.FrenziedChant.Name
				}
			ProcessQueue.add_effect(action)
	
	if caster.get_traits().has("Plaguedrinking"):
		if Global.Enemies.size() > 0:
			for enemy in Global.Enemies:
							var new_buff = cloner.clone_dict(LBuffs.buff_data.Plague)
							new_buff["target"] = enemy
							new_buff["source"] = caster
							new_buff.duration = 2 * caster.get_traits().Plaguedrinking.Level
							var action = {
				"name": "add_buff", 
				"buff": new_buff, 
				"msg": "Plague Chant"
			}
							ProcessQueue.add_effect(action)
			
			var action = {
					"name": "magic_damage_target", 
					"target": caster, 
					"caster": caster, 
					"damage": 25.0, 
					"damage_type": "poison", 
					"effect_sprite": "PoisonHit", 
					"msg": caster.get_traits().Plaguedrinking.Name
				}
			ProcessQueue.add_effect(action)
			
			
	if caster.get_traits().has("Stran"):
		for ally in Global.Allies:
			if ally.get_name() == "Tugar":
				var action = {
			"name": "apply_bonus", 
			"origin": ally, 
			"target": ally, 
			"amount": float(ally.get_DMG(null)) * 0.25, 
			"type": "damage", 
			"msg": caster.get_traits().Stran.Name
			}
				ProcessQueue.add_effect(action)
				
				action = {
			"name": "heal", 
			"amount": float(ally.HP_max) * 0.25, 
			"healer_unit": caster, 
			"healed_unit": ally, 
			"msg": caster.get_traits().Stran.Name
			}
				ProcessQueue.add_effect(action)
	
	if traits.has("VotiveHelm"):
		
		var action = {
			"name": "heal", 
			"amount": 10.0 * caster.get_total_WIL(), 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": traits.VotiveHelm.Name
			}
		ProcessQueue.add_effect(action)
	
	if traits.has("VotiveSkirt"):
		var action = {
			"name": "heal", 
			"amount": 10.0 * caster.get_total_DEX(), 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": traits.VotiveSkirt.Name
			}
		ProcessQueue.add_effect(action)
	
	if traits.has("VotiveChest"):
				var action = {
			"name": "heal", 
			"amount": 10.0 * unit.get_total_STR(), 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": traits.VotiveChest.Name
			}
				ProcessQueue.add_effect(action)
	
	if caster.get_traits().has("Mehtar"):
				var amount = 1
				var buff_scaling = 0.0
				for buff in unit.Buffs:
					if buff.name == "Dream":
						buff_scaling = float(buff.duration)
						amount += buff.duration
						if amount > 5: amount = 5
					
				for times in amount:
							
							if Global.Enemies.size():
								var action = {
									"name": "hit_targets_range", 
									"attacker": unit, 
									"hit": 10.0, 
									"weapon": unit.weapon_main, 
									"effect_range": 4, 
									"number_of_targets": 1, 
									"msg": traits.Mehtar.Name
			
									}
								ProcessQueue.add_effect(action)
							
							var action = {
								"name": "summon_random", 
								"alliance": "ally", 
								"type": LAllies.ally_data.phantasm, 
								"summoner": unit, 
								"msg": traits.Mehtar.Name
								}
							ProcessQueue.add_effect(action)
							var newbuff = cloner.clone_dict(LBuffs.buff_data.Dream)
							newbuff["target"] = unit
							newbuff["source"] = unit
							newbuff.duration = 1
							action = {
								"name": "add_buff", 
								"buff": newbuff, 
								"msg": unit.get_traits().Mehtar.Name
								}
							ProcessQueue.add_effect(action)
	
	if caster.get_traits().has("Templar"):
		var buff = cloner.clone_dict(LBuffs.buff_data.Anoint)
		buff["target"] = unit
		buff["source"] = unit
		buff.duration = 2
		var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": caster.get_traits().Templar.Name
		}
		ProcessQueue.add_effect(action)
	
	
	
	if caster.get_traits().has("Morbumancy"):
		var trait = caster.get_traits().Morbumancy
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
				"msg": caster.get_traits().Morbumancy.Name
				}
				ProcessQueue.add_effect(action)
	
	if caster.get_traits().has("Warlock"):
			var buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
			buff["target"] = caster
			buff["source"] = caster
			buff["duration"] = 3
			var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": caster.get_traits().Warlock.Name
		}
			ProcessQueue.add_effect(action)
		
			action = {
				"name": "magic_damage_target_closest", 
				"caster": caster, 
				"damage": 100.0, 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"msg": caster.get_traits().Warlock.Name
				}
			ProcessQueue.add_effect(action)
	
	
	if traits.has("Sorcerer") == true:
		var action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": unit, 
	"damage": 5.0 * unit.level, 
	"damage_type": unit.get_DMG_type(unit.weapon_main), 
	"effect_sprite": translate.dmgtype_to_animation(unit.get_DMG_type(unit.weapon_main)), 
	"number_of_targets": 1, 
	"effect_range": 99, 
	"enemies": null, 
	"msg": traits.Sorcerer.Name
				}
		ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("Uhrata") and Global.Enemies.size():
		var dtypes = ["blood", "poison", "ice", "astral", "fire"]
		for dtype in dtypes:
			var action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": 0.05 * float(unit.HP_max), 
					"damage_type": dtype, 
					"effect_sprite": translate.dmgtype_to_animation(dtype), 
					"msg": unit.get_traits().Uhrata.Name
				}
			ProcessQueue.add_effect(action)
			
			action = {
			"name": "magic_damage_targets_range", 
			"caster": unit, 
			"damage": 0.05 * float(unit.HP_max), 
			"damage_type": dtype, 
			"effect_sprite": translate.dmgtype_to_animation(dtype), 
			"number_of_targets": 1, 
			"effect_range": 99, 
			"msg": unit.get_traits().Uhrata.Name
				}
			ProcessQueue.add_effect(action)
			
			
	
	if unit.get_traits().has("Aslan"):
		if Global.Enemies.size():
				var action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": 0.75 * float(unit.HP_max), 
					"damage_type": "pierce", 
					"effect_sprite": "Pierce", 
					"msg": unit.get_traits().Aslan.Name
				}
				ProcessQueue.add_effect(action)
	
	if unit.get_traits().has("Alhaja") == true:

		var action = {
			"name": "hit_targets_range", 
			"attacker": unit, 
			"hit": unit.get_DMG_total(unit.weapon_main), 
			"weapon": unit.weapon_main, 
			"effect_range": 2, 
			"number_of_targets": 1, 
			"msg": caster.get_traits().Alhaja.Name
				}
		ProcessQueue.add_effect(action)
	
	if traits.has("BheithNochti"):
		
		
			
				var weapon = unit.weapon_main
				var action = {
				"name": "magic_damage_targets_range", 
				"caster": unit, 
				"damage": float(unit.get_DMG_total(weapon)), 
				"damage_type": unit.get_DMG_type(weapon), 
				"effect_sprite": translate.dmgtype_to_animation(unit.get_DMG_type(weapon)), 
				"effect_range": 1, 
				"number_of_targets": 8, 
				"msg": traits.BheithNochti.Name
			}
				ProcessQueue.add_effect(action)
	
	if traits.has("HoodZealot"):
			
		
				var action = {
				"name": "heal", 
				"amount": 0.05 * float(unit.HP_max), 
				"healer_unit": unit, 
				"healed_unit": unit, 
				"msg": traits.HoodZealot.Name
				}
				ProcessQueue.add_effect(action)
				
	if traits.has("greenhead"):
			
		
				var action = {
				"name": "heal", 
				"amount": 0.05 * float(unit.HP_max), 
				"healer_unit": unit, 
				"healed_unit": unit, 
				"msg": traits.greenhead.Name
				}
				ProcessQueue.add_effect(action)
	
	if traits.has("AuroraChant"):
		if Global.Enemies.size() > 0:
			
			
			
			for buff in unit.Buffs:
				if buff.name == "Meditate":
					for n in traits.AuroraChant.Level:
						var action = {
				"name": "magic_damage_target_closest", 
				"caster": unit, 
				"damage": 5.0 * buff.duration, 
				"damage_type": "ice", 
				"effect_sprite": "Bastral", 
				"msg": traits.AuroraChant.Name
				}
						ProcessQueue.add_effect(action)
	
			var action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": 25.0, 
					"damage_type": "astral", 
					"effect_sprite": "Bastral", 
					"msg": traits.AuroraChant.Name
				}
			ProcessQueue.add_effect(action)
			
			var new_buff = cloner.clone_dict(LBuffs.buff_data.Meditate)
			new_buff["target"] = unit
			new_buff["source"] = unit
			new_buff.duration = 1 * traits.AuroraChant.Level
			action = {
				"name": "add_buff", 
				"buff": new_buff, 
				"msg": "Aurora Chant"
			}
			ProcessQueue.add_effect(action)
	
	if caster.get_traits().has("Kerjata"):
			var trait = caster.get_traits().Kerjata
			for n in trait.Level:
				
				var action = {}
				action = {
				"name": "magic_damage_tiles_in_path_to_targets_in_range", 
				"caster": caster, 
				"damage": caster.get_SPEED() * trait.Level, 
				"damage_type": "lightning", 
				"effect_sprite": "Zap", 
				"number_of_targets": 1, 
				"effect_range": 2, 
				"enemies": null, 
				"msg": caster.get_traits().Kerjata.Name
				}
				ProcessQueue.add_effect(action)
				
			var buff = cloner.clone_dict(LBuffs.buff_data.Charge)
			buff["target"] = unit
			buff["source"] = unit
			buff["duration"] = trait.Level
			var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": caster.get_traits().Kerjata.Name
		}
			ProcessQueue.add_effect(action)
	
	if caster.get_traits().has("IceShah"):
		for n in 8:
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.livingice, 
					"summoner": unit, 
					"msg": caster.get_traits().IceShah.Name
				}
			ProcessQueue.add_effect(action)
	
	
	if caster.get_traits().has("TurbanAbdi"):
		
		for buff in unit.Buffs:
			if buff.name == "Doom" or buff.name == "Sickness" or buff.name == "Corrosion":
				var action = {
					"name": "remove_buff", 
					"target": caster, 
					"buff": buff, 
					"msg": caster.get_traits().TurbanAbdi.Name
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
				"msg": caster.get_traits().Pyromancy.Name
			}
		ProcessQueue.add_effect(action)
	
	
	if caster.get_traits().has("Cryomancy"):
		var trait = unit.get_traits().Cryomancy
		for n in trait.Level:
				var action = {}
				
				var buff = cloner.clone_dict(LBuffs.buff_data.Freeze)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 5
				action = {
				"name": "buff_targets_in_range", 
				"caster": unit, 
				"effect_sprite": "Chill", 
				"number_of_targets": 2, 
				"effect_range": 3, 
				"buff": buff, 
				"is_allied": false, 
				"msg": caster.get_traits().Cryomancy.Name
				}
				ProcessQueue.add_effect(action)
	
	
	if caster.get_traits().has("staffcrimson"):
					var buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
					buff["target"] = caster
					buff["source"] = caster
					buff.duration = caster.get_total_weapon_size()
					var action = {
				"name": "buff_tiles_in_range", 
				"caster": caster, 
				"effect_sprite": "Bleed", 
				"effect_range": 4, 
				"buff": buff, 
				"alliance": calcrange.get_enemy_alliance(caster), 
				"msg": caster.get_traits().staffcrimson.Name
			}
					ProcessQueue.add_effect(action)
	
	if traits.has("Phoenix"):
		if Global.Enemies.size():
			for n in caster.get_charged_invokes():
				var action = {
					"name": "magic_damage_target", 
					"target": caster, 
					"caster": caster, 
					"damage": (0.01 * float(caster.HP_max)) * float(caster.get_total_WIL()), 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": traits.Phoenix.Name
				}
				ProcessQueue.add_effect(action)
	
	if caster.get_traits().has("AstralSeeking") == true:
		
		var action = {
				"name": "teleport_random", 
				"unit": caster, 
				"msg": caster.get_traits().AstralSeeking.Name
			}
		ProcessQueue.add_effect(action)
		
				

	
	if traits.has("Exultite"):
			if Global.Enemies.size() > 0:
				var damage = 0.0
				for buff in unit.Buffs:
					if buff.name == "Inflame":
						damage += buff.duration * 10.0
						damage = float(damage)
				
				if damage > 0.0:
					var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": damage, 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"effect_range": 3, 
				"msg": traits.Exultite.Name
			}
					ProcessQueue.add_effect(action)
					action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": damage, 
				"damage_type": "blood", 
				"effect_sprite": "Blood", 
				"effect_range": 3, 
				"msg": traits.Exultite.Name
			}
					ProcessQueue.add_effect(action)
				
				var new_buff = cloner.clone_dict(LBuffs.buff_data.Inflame)
				new_buff["target"] = unit
				new_buff["source"] = unit
				new_buff.duration = 2
				var action = {
				"name": "add_buff", 
				"buff": new_buff, 
				"msg": traits.Exultite.Name
			}
				ProcessQueue.add_effect(action)
	if traits.has("AmplifiedHealing"):
			var trait = traits.AmplifiedHealing
			if Global.Enemies.size() > 0:
				var action = {
				"name": "heal", 
				"amount": 50.0 * trait.Level, 
				"healer_unit": unit, 
				"healed_unit": unit, 
				"msg": traits.AmplifiedHealing.Name
			}
				ProcessQueue.add_effect(action)
				
	if traits.has("BloodRetort") == true:
		if Global.Enemies.size() > 0:
	
			var trait = traits.BloodRetort
			for n in trait.Level:
						var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.bleedingdead, 
					"summoner": unit, 
					"msg": traits.BloodRetort.Name
				}
						ProcessQueue.add_effect(action)
	
			var action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": 25.0, 
					"damage_type": "blood", 
					"effect_sprite": "Blood", 
					"msg": traits.BloodRetort.Name
				}
			ProcessQueue.add_effect(action)
	
	if traits.has("Overgrowth"):
			if Global.Enemies.size() > 0:
				var trait = unit.get_traits().Overgrowth
				
				for ally in Global.Allies:
					if ally != Global.Player:
						
						if ally.type.tags.has("[color=#00a000]Plant[/color]"):
						
							var life_gain = (0.05 * float(trait.Level)) * ally.HP_max
							if life_gain > 1000.0:
								life_gain = 1000.0
							var action = {
			"name": "apply_bonus", 
			"origin": unit, 
			"target": ally, 
			"amount": life_gain, 
			"type": "life", 
			"msg": traits.Overgrowth.Name
			}
							ProcessQueue.add_effect(action)
						
					
				
				for n in trait.Level:
						var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Gisa, 
					"summoner": unit, 
					"msg": traits.Overgrowth.Name
				}
						ProcessQueue.add_effect(action)
		
		
	if unit.get_traits().has("Acolyte"):
		var action = {
		"name": "magic_damage_targets_range", 
		"caster": unit, 
		"damage": float(unit.get_DMG_total(unit.weapon_main)) * 1.0, 
		"damage_type": "psychic", 
		"effect_sprite": "PsychicDark", 
		"effect_range": 3, 
		"number_of_targets": 1, 
		"msg": unit.get_traits().Acolyte.Name
			}
		ProcessQueue.add_effect(action)
		
		action = {
		"name": "magic_damage_targets_range", 
		"caster": unit, 
		"damage": float(unit.get_DMG_total(unit.weapon_main)) * 1.0, 
		"damage_type": "death", 
		"effect_sprite": "PsychicDark", 
		"effect_range": 3, 
		"number_of_targets": 1, 
		"msg": unit.get_traits().Acolyte.Name
			}
		ProcessQueue.add_effect(action)
	if unit.get_traits().has("BloodMage"):
				
				var buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 3
				var action = {
				"name": "buff_tiles_in_range", 
				"caster": unit, 
				"effect_sprite": "Bleed", 
				"effect_range": 3, 
				"buff": buff, 
				"alliance": calcrange.get_enemy_alliance(unit), 
				"msg": caster.get_traits().BloodMage.Name
			}
				ProcessQueue.add_effect(action)
	
	
	
	if caster.get_traits().has("Albaz"):
		
		var action = {
				"name": "heal", 
				"amount": 100.0 + (caster.get_total_DEX() * 10.0), 
				"healer_unit": unit, 
				"healed_unit": unit, 
				"msg": caster.get_traits().Albaz.Name
				}
		ProcessQueue.add_effect(action)
	
	
	
	
	if caster.get_traits().has("BheithNochti"):
		
		if unit.weapon_main != null:
			var item = unit.weapon_main
			if item.dmg <= 99:
				if item.dmg <= 98:
					item.dmg += 2
				else:
					item.dmg += 1
				var stringa = ""
				stringa += item.name
				stringa = "무기 강화: " + stringa + " [color=#ff8030]+20 명중[/color]"
				stringa += " [color=#707070]→ " + str(item.dmg * 10)
				stringa += " ← Bheith Nochti"
				ToolMessageCreator.add_message("[color=#c0c0c0]", stringa)
	
	if caster.get_traits().has("Slahana"):
		var trait = caster.get_traits().Slahana
		var action = {
				"name": "magic_damage_target_closest", 
				"caster": caster, 
				"damage": ((trait.base * trait.Level) * (caster.get_total_WIL() / 5.0)) / caster.get_total_inflex(), 
				"damage_type": "lightning", 
				"effect_sprite": "Zap", 
				"msg": caster.get_traits().Slahana.Name
				}
		ProcessQueue.add_effect(action)

	if caster.get_traits().has("Druid"):
			var amount = 3
			for n in amount:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.serpent, 
					"summoner": caster, 
					"msg": caster.get_traits().Druid.Name
				}
				ProcessQueue.add_effect(action)
	if caster.get_traits().has("VileCoup"):
			var amount = 3
			for n in amount:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.serpent, 
					"summoner": caster, 
					"msg": caster.get_traits().VileCoup.Name
				}
				ProcessQueue.add_effect(action)
	if caster.get_traits().has("Necromancy"):
		
		for ally in Global.Allies:
				if ally != Global.Player:
					if ally.type.tags.has("[color=#a0a000]언데드[/color]"):
						
					
						var action = {
			"name": "apply_bonus", 
			"origin": caster, 
			"target": ally, 
			"amount": 5.0, 
			"type": "speed", 
			"msg": caster.get_traits().Necromancy.Name
			}
						ProcessQueue.add_effect(action)
		
		for n in caster.get_traits().Necromancy.Level:
			var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.cadaver, 
					"summoner": caster, 
					"msg": caster.get_traits().Necromancy.Name
				}
			ProcessQueue.add_effect(action)
	
	
	if caster.get_traits().has("Liturgist"):
		
		for ally in Global.Allies:
				if ally != Global.Player:
					if ally.type.tags.has("[color=#8050f0]Priest[/color]"):
						
					
						var action = {
			"name": "apply_bonus", 
			"origin": caster, 
			"target": ally, 
			"amount": 5.0, 
			"type": "speed", 
			"msg": caster.get_traits().Liturgist.Name
			}
						ProcessQueue.add_effect(action)
						action = {
			"name": "apply_bonus", 
			"origin": caster, 
			"target": ally, 
			"amount": 10.0, 
			"type": "damage", 
			"msg": caster.get_traits().Liturgist.Name
			}
						ProcessQueue.add_effect(action)
	
	if caster.get_traits().has("Oozemancy"):
			for n in caster.get_traits().Oozemancy.Level:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.ooze, 
					"summoner": caster, 
					"msg": caster.get_traits().Oozemancy.Name
				}
				ProcessQueue.add_effect(action)
	if caster.get_traits().has("ErtHunab"):
			
			for ally in Global.Allies:
					if ally != Global.Player:
						if ally.type.tags.has("[color=#00a000]Plant[/color]"):

							var action = {
			"name": "apply_bonus", 
			"origin": caster, 
			"target": ally, 
			"amount": 5.0, 
			"type": "speed", 
			"msg": caster.get_traits().ErtHunab.Name
			}
							ProcessQueue.add_effect(action)
		
		
			for n in caster.get_traits().ErtHunab.Level:
				
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.creeper, 
					"summoner": caster, 
					"msg": caster.get_traits().ErtHunab.Name
				}
				ProcessQueue.add_effect(action)
	
	
	if caster.get_traits().has("Arsonist"):
			for n in 3:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Root, 
					"summoner": caster, 
					"msg": caster.get_traits().Arsonist.Name
				}
				ProcessQueue.add_effect(action)


static func add_score(unit):
	if unit == Global.Player:
			StatePlayerSheet.score_data.times_pray += 1
