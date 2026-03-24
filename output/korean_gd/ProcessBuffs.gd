extends Node


class_name buffcheck

static func check(_name, _duration, target, _source, buff):
	
	var cancel_effect = false
	for effect in target.Effects:
		if effect.effect_name == buff.animation:
			cancel_effect = true
	if cancel_effect != true and buff.form == false:
		effectmaker.create_effect_animated_persist(target, target.global_position, buff.animation)
	
	
	
		
		
		
		
		
			
		
		
		
				
	


static func just_draw(_name, _duration, target, _source, buff):
	var cancel_effect = false
	for effect in target.Effects:
		if effect.effect_name == buff.animation:
			cancel_effect = true
	if cancel_effect != true and buff.form == false:
		effectmaker.create_effect_animated_persist(target, target.global_position, buff.animation)

static func poison(duration, target, source, _buff_names):
	var action = {
				"name": "magic_damage_target", 
				"target": target, 
				"caster": source, 
				"damage": duration * 5, 
				"damage_type": "poison", 
				"effect_sprite": "PoisonHit", 
				"msg": "Sickness"
				}
	ProcessQueue.add_effect(action)


static func plague(duration, target, source, _buff_names):
	var action = {
				"name": "magic_damage_target", 
				"target": target, 
				"caster": source, 
				"damage": duration * 10, 
				"damage_type": "poison", 
				"effect_sprite": "PoisonHit", 
				"msg": "Plague"
				}
	ProcessQueue.add_effect(action)
	action = {
				"name": "magic_damage_target", 
				"target": target, 
				"caster": source, 
				"damage": duration * 10, 
				"damage_type": "death", 
				"effect_sprite": "Curse", 
				"msg": "Plague"
				}
	ProcessQueue.add_effect(action)
	
	var new_buff = cloner.clone_dict(LBuffs.buff_data.Plague)
	new_buff["target"] = target
	new_buff["source"] = target
	new_buff.duration = duration
	action = {
	"name": "buff_tiles_in_range", 
	"caster": target, 
	"effect_sprite": "Plague", 
	"effect_range": 1, 
	"buff": new_buff, 
	"alliance": calcrange.get_allied_alliance(target), 
	"msg": "역병 전파"
			}
	ProcessQueue.add_effect(action)
	
	

static func bleed(duration, target, source, _buff_names):
	var percent_hp = target.HP_max * 0.05
	if percent_hp < 1:
		percent_hp = 1
	var action = {
				"name": "magic_damage_target", 
				"target": target, 
				"caster": source, 
				"damage": int(target.HP_max * 0.1) + (duration * 2), 
				"damage_type": "blood", 
				"effect_sprite": "Blood"
				}
	ProcessQueue.add_effect(action)


static func burn(duration, target, source, _buff_names):

	
		
			
	if target.get_traits().has("MasterScorch") == false:
		var repeat = float(duration) / float(20)
		repeat = int(repeat)
		
		repeat += 1
	
		if repeat < 1: repeat = 1
	
		for n in repeat:
			var action = {
				"name": "magic_damage_target", 
				"target": target, 
				"caster": source, 
				"damage": duration * 10, 
				"damage_type": "fire", 
				"effect_sprite": "Flame", 
				"msg": "Scorch"
				}
			ProcessQueue.add_effect(action)

static func just_erase(unit):
	

	
	
	var Buffs_Remove = []
	
	var erase_effect = cloner.clone_array(unit.Effects)
	for buff in unit.Buffs:
		if buff.duration <= 0:
			Buffs_Remove.append(buff)
		
		for effect in unit.Effects:
			if effect.effect_name == buff.animation:
				if buff.duration <= 0:
					pass
				else:
					erase_effect.erase(effect)
			
	
	
	for effect in erase_effect:
		unit.Effects.erase(effect)
		effect.temp = true
	
	if Buffs_Remove.size() > 0:
		for buff in Buffs_Remove:
			unit.Buffs.erase(buff)
