extends Node


class_name event_intervention

static func check(unit):
	var traits = unit.get_traits()
	unit.interventions += 1
	
	ToolInvokes.recharge("divine intervention")
	
	add_score(unit)
	if traits.has("Phoenix"):
		for enemy in Global.Enemies:
			var action = {
					"name": "magic_damage_target", 
					"target": enemy, 
					"caster": unit, 
					"damage": 200.0, 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": traits.Phoenix.Name
				}
			ProcessQueue.add_effect(action)
		
		if unit.interventions < 2:
			unit.WIL += 1
			var stringa = "찬양하라 [color=#ff9000]Phoenix[/color]! [color=#c050ff]의지[/color] 상승!"
			stringa += " [color=#ff5050]" + str(1 - unit.interventions) + " 남음[/color]"
			ToolMessageCreator.add_message("[color=#a0c0c0]", stringa)
		
	
	if traits.has("Stormbringer"):
			if Global.Enemies.size() > 0:
			
				var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": 100.0, 
				"damage_type": "ice", 
				"effect_sprite": "Ice", 
				"effect_range": 4, 
				"msg": traits.Stormbringer.Name
			}
				ProcessQueue.add_effect(action)
				action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": 100.0, 
				"damage_type": "lightning", 
				"effect_sprite": "Zap", 
				"effect_range": 4, 
				"msg": traits.Stormbringer.Name
			}
				ProcessQueue.add_effect(action)
	
	
	if traits.has("Slime"):
		for enemy in Global.Enemies:
			for buff in enemy.Buffs:
				if buff.name == "Corrosion":
					
					var action = {
					"name": "magic_damage_target", 
					"target": enemy, 
					"caster": unit, 
					"damage": 10.0 * buff.duration * traits.Slime.Level, 
					"damage_type": "poison", 
					"effect_sprite": "PoisonHit", 
					"msg": traits.Slime.Name
				}
					ProcessQueue.add_effect(action)
	
	
	
	if traits.has("Valr"):
		for n in 3:
			var damage = 0.2 * float(unit.get_block_strength())
			var action = {
				"name": "magic_damage_targets_range", 
			"caster": unit, 
			"damage": damage, 
			"damage_type": "death", 
			"effect_sprite": "Bastral", 
			"number_of_targets": 1, 
			"effect_range": 99, 
				"msg": traits.Valr.Name
				}
			ProcessQueue.add_effect(action)
	
	
	if traits.has("Snakeform"):
			
				for buff in unit.Buffs:
					if buff.name == "Snakeform":
						var action = {
					"name": "heal", 
					"amount": 10 * buff.duration, 
					"healer_unit": unit, 
					"healed_unit": unit, 
					"msg": "Snakeform"
				}
						
						ProcessQueue.add_effect(action)
	
	
	if traits.has("MassMind"):
			var trait = unit.get_traits().MassMind
			var damage = Global.Allies.size() * trait.Level * 5.0
			damage = float(damage)
			var damage_range = trait.Level
			
			for n in trait.Level:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.GlintingBlade, 
					"summoner": unit, 
					"msg": traits.MassMind.Name
				}
				ProcessQueue.add_effect(action)
			
			var action = {
				"name": "magic_damage_targets_range", 
				"caster": unit, 
				"damage": damage, 
				"damage_type": "psychic", 
				"effect_sprite": "Psychic", 
				"effect_range": damage_range, 
				"number_of_targets": 300, 
				"msg": traits.MassMind.Name
			}
			ProcessQueue.add_effect(action)
	
	if traits.has("Frostpulse"):
			if Global.Enemies.size() > 0:
				var trait = unit.get_traits().Frostpulse
				var damage = unit.get_total_weight() * trait.Level * 5.0
				damage = float(damage)
				var damage_range = trait.Level
				var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": damage, 
				"damage_type": "ice", 
				"effect_sprite": "Ice", 
				"effect_range": damage_range, 
				"msg": traits.Frostpulse.Name
			}
				ProcessQueue.add_effect(action)
	
	if traits.has("Bloodcalling"):
			for n in 1:
				var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.Hemogoblin, 
					"summoner": unit, 
					"msg": traits.Bloodcalling.Name
				}
				ProcessQueue.add_effect(action)
	
	
	if traits.has("Kuga"):
		for n in 6:
				var trait = traits.Kuga
		

				var buff = cloner.clone_dict(LBuffs.buff_data.Plague)
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = 3 * trait.Level
				var action = {
				"name": "buff_targets_in_range", 
				"caster": unit, 
				"effect_sprite": "Plague", 
				"number_of_targets": 1, 
				"effect_range": 3, 
				"buff": buff, 
				"is_allied": false, 
				"msg": traits.Kuga.Name
				}
				ProcessQueue.add_effect(action)
	
	if traits.has("GoreTide"):
			if Global.Enemies.size() > 0:
				var trait = unit.get_traits().GoreTide
				var damage = (unit.HP_max - unit.HP) * trait.Level
				damage = float(damage)
				if damage < 1.0: damage = 1.0
				var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": damage, 
				"damage_type": "blood", 
				"effect_sprite": "Blood", 
				"effect_range": 3, 
				"msg": traits.GoreTide.Name
			}
				ProcessQueue.add_effect(action)
	
	if traits.has("Apostle"):
		var action = {
				"name": "magic_damage_tiles_in_range", 
				"caster": unit, 
				"damage": 1000.0, 
				"damage_type": "astral", 
				"effect_sprite": "Astral", 
				"effect_range": 5, 
				"msg": traits.Apostle.Name
			}
		ProcessQueue.add_effect(action)
		action = {
					"name": "heal", 
					"amount": 600.0, 
					"healer_unit": unit, 
					"healed_unit": unit, 
					"msg": traits.Apostle.Name
				}
				
		ProcessQueue.add_effect(action)
	

static func add_score(unit):
	if unit == Global.Player:
			StatePlayerSheet.score_data.times_intervention += 1
	
