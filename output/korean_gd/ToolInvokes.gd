extends Node


class_name invoker

static func recharge(label):
	if Global.Player.really_dead == false:
		recharge_if_alive(label)

static func recharge_if_alive(label):
	var dict = Global.Player.invokes
	for invoke in dict:
		if dict[invoke].use_recharge_type == label:
			if dict[invoke].level_required <= Global.Player.level:
				
				if dict[invoke].recharge_message != "none":
					if dict[invoke].use < dict[invoke].use_max:
						pass
						
				if dict[invoke].use < dict[invoke].use_max:
					dict[invoke].use += dict[invoke].use_gain
					ToolMessageCreator.add_message("[color=#707070]", textstrip.strip_bbcode(dict[invoke].name) + " +" + str(int(dict[invoke].use_gain)) + "  [color=#707070]" + label + "[/color]")
				if dict[invoke].use > dict[invoke].use_max:
					dict[invoke].use = dict[invoke].use_max

static func lose_charge(label):
	var dict = Global.Player.invokes
	for key in dict:
		var invoke = dict[key]
		if invoke.use_lose == label:
			if invoke.level_required <= Global.Player.level:
				
				if invoke.use > 0:
					ToolMessageCreator.add_message("[color=#707070]", textstrip.strip_bbcode(invoke.name) + " -1" + "  [color=#707070]" + label + "[/color]")
					invoke.use -= 1
		
static func force_lose_charge(invoke_key, msg):
	var invoke = Global.Player.invokes[invoke_key]
	if invoke.level_required <= Global.Player.level:
				
				if invoke.use > 0:
					ToolMessageCreator.add_message("[color=#707070]", textstrip.strip_bbcode(invoke.name) + " -1" + "  [color=#707070]" + ({"Familiar": "사역마", "Summoned": "소환됨", "Initial": "최초", "Hit": "명중", "공격": "공격", "Being hit": "피격", "enemy Purges you": "적의 정화"}.get(textstrip.strip_bbcode(msg), textstrip.strip_bbcode(msg))) + "[/color]")
					invoke.use -= 1


static func uhrata():
	var dict = Global.Player.invokes
	for invoke in dict:
		if dict[invoke].level_required == 1:
			if dict[invoke].use < dict[invoke].use_max:
				dict[invoke].use += 1
				ToolMessageCreator.add_message("[color=#707070]", textstrip.strip_bbcode(dict[invoke].name) + " +1" + "  [color=#707070]Uhrata[/color]")
			if dict[invoke].use > dict[invoke].use_max:
				dict[invoke].use = dict[invoke].use_max

static func zealot_recharge():
	var dict = Global.Player.invokes
	for invoke in dict:
		if dict[invoke].level_required <= Global.Player.level:
			if dict[invoke].use < dict[invoke].use_max:
				dict[invoke].use += 3
				ToolMessageCreator.add_message("[color=#707070]", textstrip.strip_bbcode(dict[invoke].name) + " +3" + "  [color=#707070]Zealot[/color]")
			if dict[invoke].use > dict[invoke].use_max:
				dict[invoke].use = dict[invoke].use_max

static func acolyte_recharge():
	var dict = Global.Player.invokes
	for invoke in dict:
		if dict[invoke].level_required <= Global.Player.level:
			if dict[invoke].use < dict[invoke].use_max:
				dict[invoke].use += 1
				ToolMessageCreator.add_message("[color=#707070]", textstrip.strip_bbcode(dict[invoke].name) + " +1" + "  [color=#707070]Acolyte[/color]")
			if dict[invoke].use > dict[invoke].use_max:
				dict[invoke].use = dict[invoke].use_max

static func alhaja_recharge():
	var dict = Global.Player.invokes
	for invoke in dict:
		if dict[invoke].level_required <= Global.Player.level:
			if dict[invoke].use < dict[invoke].use_max:
				dict[invoke].use += 1
				ToolMessageCreator.add_message("[color=#707070]", textstrip.strip_bbcode(dict[invoke].name) + " +1" + "  [color=#a090b0]Aistihdar[/color]")
			if dict[invoke].use > dict[invoke].use_max:
				dict[invoke].use = dict[invoke].use_max


static func liturgist_recharge():
	var dict = Global.Player.invokes
	for invoke in dict:
		if dict[invoke].level_required <= Global.Player.level:
			if dict[invoke].use < dict[invoke].use_max:
				dict[invoke].use += 1
				ToolMessageCreator.add_message("[color=#707070]", textstrip.strip_bbcode(dict[invoke].name) + " +1" + "  [color=#8050f0]Liturgist[/color]")
			if dict[invoke].use > dict[invoke].use_max:
				dict[invoke].use = dict[invoke].use_max

static func morlock_recharge():
		var dict = Global.Player.invokes

		for invoke in dict:
			if dict[invoke].level_required <= Global.Player.level:
				if dict[invoke].use < dict[invoke].use_max:
					dict[invoke].use += 1
					ToolMessageCreator.add_message("[color=#707070]", textstrip.strip_bbcode(dict[invoke].name) + " +1" + "  [color=#70c0c0]Med-Mora[/color]")
				if dict[invoke].use > dict[invoke].use_max:
					dict[invoke].use = dict[invoke].use_max



static func cast(invoke, label):
	ToolMessageCreator.add_message("[color=#c0c0c0]", "[color=#ffff50]기도 암송:[/color] " + invoke.name)
	
	var animation = Global.Player.god.title
	
	
	
	effectmaker.create_effect_animated(Global.Player.global_position, Global.EffectAnimated, animation)
	
	event_invoke.check(label)
	
	match label:
		
		
		"meditate":
			meditate()
		"awe":
			awe()
		"vendi":
			vendi()
		
		
		"bloodrage":
			bloodrage()
		"halhala":
			halhala()
		"damu":
			damu()
		
		
		"leget":
			leget()
		"alu":
			alu()
		"musma":
			musma()
		
		
		"dorova":
			dorova()
		"tyrana":
			tyrana()
		"muruga":
			muruga()
		
		
		"senheb":
			senheb()
		"sedjhet":
			sedjhet()
		"neter":
			neter()
			
		
		"ti":
			ti()
		"zatu":
			zatu()
		"girra":
			girra()
		
		
		"gibija":
			gibija()
		"sluga":
			sluga()
		"razaranja":
			razaranja()
		
		
		"contemplation":
			contemplation()
		"punishment":
			punishment()
		"violence":
			violence()
			
		
		"hurah":
			hurah()
		"yirah":
			yirah()
		"selem":
			selem()
		
		
		"drow":
			drow()
		"moc":
			moc()
		"miana":
			miana()
		
		
		"turba":
			turba()
		"spera":
			spera()
		"viva":
			viva()
		
		
		"ygeia":
			ygeia()
		"doru":
			doru()
		"tekton":
			tekton()
		
		
		
		"oriad":
			oriad()
		"mira":
			mira()
		"ogra":
			ogra()
		
		
		"yahrub":
			yahrub()
		"wizara":
			wizara()
		"yamur":
			yamur()
		
		
		"gula":
			gula()
		"umam":
			umam()
		"namkalag":
			namkalag()
		
		
		"bahu":
			bahu()
		"chundu":
			chundu()
		"gongu":
			gongu()
		
		
		"eranya":
			eranya()
		"omranya":
			omranya()
		"anranya":
			anranya()
		
		
		"glyad":
			glyad()
		"goret":
			goret()
		"krasota":
			krasota()
		
		
		"eird":
			eird()
		"eiqab":
			eiqab()
		"muejab":
			muejab()
		
		
		"auzom":
			auzom()
		"ragna":
			ragna()
		"agara":
			agara()
		
		
		"enq":
			enq()
		"cheren":
			cheren()
		"khairkhan":
			khairkhan()
		
		
		"prakara":
			prakara()
		"ksudha":
			ksudha()
		"rogoga":
			rogoga()
		
		
		"isfet":
			isfet()
		"hetep":
			hetep()
		"neheb":
			neheb()
		


static func meditate():
	
	var unit = Global.Player
	var action = {
			"name": "heal", 
			"amount": 200.0, 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": "Med Vohu"
		}
	ProcessQueue.add_effect(action)
	
	
	



static func awe():
	var source = Global.Player
	
	var action = {
		"name": "magic_damage_targets_range", 
		"caster": source, 
		"damage": 100.0, 
		"damage_type": "astral", 
		"effect_sprite": "Astral", 
		"effect_range": 4, 
		"number_of_targets": 50, 
		"msg": "Yazata"
			}
	ProcessQueue.add_effect(action)
	


static func vendi():
	var source = Global.Player
	var unit = Global.Player
	
	var action = {
			"name": "magic_damage_target_closest", 
			"caster": source, 
			"damage": 200.0, 
			"damage_type": "astral", 
			"effect_sprite": "Astral", 
			"msg": "Vendi"
				}
	ProcessQueue.add_effect(action)
	
	var repeat = 0
	for buff in unit.Buffs:
		if buff.name == "Grace":
			repeat += buff.duration
	for n in repeat:
		ProcessQueue.add_effect(action)


static func bloodrage():
	
	var unit = Global.Player
	effectmaker.create_effect_animated_persist(unit, unit.global_position, "BloodRage")
	var buff = cloner.clone_dict(LBuffs.buff_data.Bloodrage)
	buff["target"] = unit
	buff["source"] = unit
	buff.duration = 5
	var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": "Sum Uri"
		}
	ProcessQueue.add_effect(action)
	
	for buffs in unit.Buffs:
		if buffs.name == "Bleed":
			action = {
			"name": "remove_buff", 
			"target": unit, 
			"buff": buffs, 
			"msg": "Sum Uri"
			
			}
			ProcessQueue.add_effect(action)
			buff = cloner.clone_dict(LBuffs.buff_data.Bloodrage)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = buffs.duration
			action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": "Sum Uri"
		}
			ProcessQueue.add_effect(action)

static func halhala():
	var source = Global.Player
	var multi = 1
	for buff in source.Buffs:
		if buff.name == "Bloodrage":
			multi += buff.duration
	var action = {
		"name": "magic_damage_tiles_in_range", 
		"caster": source, 
		"damage": source.get_total_weapon_size() * 5.0 * multi, 
		"damage_type": "blood", 
		"effect_sprite": "Blood", 
		"effect_range": 2, 
		"msg": "Ur Halhala"
			}
	ProcessQueue.add_effect(action)
	
		
		
	if source.invokes.bloodrage.use < 2:
		source.invokes.bloodrage.use += 1
		ToolMessageCreator.add_message("[color=#707070]", "Sum Uri +1 Ur Halhala")
	

static func damu():
	
	var unit = Global.Player
	var action = {
			"name": "heal", 
			"amount": float(unit.HP_max) * 0.25, 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": "Ur Damu"
		}
	ProcessQueue.add_effect(action)
	
	
	var buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
	buff["target"] = unit
	buff["source"] = unit
	buff.duration = 10
	var action2 = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": "Ur Damu"
		}
	ProcessQueue.add_effect(action2)



static func leget():
	var unit = Global.Player
	var action = {
			"name": "heal", 
			"amount": 150.0, 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": "Leget Mhor"
		}
	ProcessQueue.add_effect(action)
	
	action = {
		"name": "heal_allies_in_range", 
		"caster": unit, 
		"amount": 150.0, 
		"effect_range": 2, 
		"msg": "Leget Mhor"
			}
	ProcessQueue.add_effect(action)
	
	for buff in unit.Buffs:
		if buff.name == "Sickness":
			action = {
			"name": "remove_buff", 
			"target": unit, 
			"buff": buff, 
			"msg": "Leget Mhor"
		}
			ProcessQueue.add_effect(action)

static func alu():
	var source = Global.Player
	var action = {
		"name": "magic_damage_tiles_in_range", 
		"caster": source, 
		"damage": 50.0 * source.invokes.alu.use, 
		"damage_type": "poison", 
		"effect_sprite": "PoisonHit", 
		"effect_range": 2, 
		"msg": "Uttuk Alu"
			}
	source.invokes.alu.use = 0
	ProcessQueue.add_effect(action)
	action = {
			"name": "change_tileset_in_area", 
			"tile_target": source.residence, 
			"tileset": "ninhurs", 
			"effect_range": 1, 
			"effect_sprite": "Ninhurs"
		}
	ProcessQueue.add_effect(action)

static func musma():
	var source = Global.Player
	var action = {
		"name": "summon", 
		"alliance": "ally", 
		"type": LAllies.ally_data.musmahu, 
		"summoner": source, 
		"msg": "Loh Musma"
			}
	
	if source.invokes.alu.use < source.invokes.alu.use_max:
		source.invokes.alu.use = source.invokes.alu.use_max
		ToolMessageCreator.add_message("[color=#707070]", "Uttuk Alu +" + str(source.invokes.alu.use_max - source.invokes.alu.use) + " Loh Musma")
	ProcessQueue.add_effect(action)


static func dorova():
	
	var unit = Global.Player
	
	
	for buffs in unit.Buffs:
		if buffs.name == "Dream":
			var action = {
			"name": "heal", 
			"amount": 20.0 * buffs.duration, 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": "Het Dorova"
		}
			ProcessQueue.add_effect(action)

		if buffs.name == "Freeze":
			var action = {
			"name": "remove_buff", 
			"target": unit, 
			"buff": buffs, 
			"msg": "Het Dorova"
		}
			ProcessQueue.add_effect(action)

static func tyrana():
	var unit = Global.Player
	
	for buffs in unit.Buffs:
		if buffs.name == "Dream":
			var buff = cloner.clone_dict(LBuffs.buff_data.Dream)
			buff["target"] = unit
			buff["source"] = unit
			buff.duration = buffs.duration
			var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": "Va Tyrana"
		}
			ProcessQueue.add_effect(action)
			

static func muruga():
	var unit = Global.Player
	
	for buffs in unit.Buffs:
		if buffs.name == "Dream":
				var action = {
					"name": "magic_damage_targets_range", 
					"caster": unit, 
					"damage": 10.0 * buffs.duration, 
					"damage_type": "ice", 
					"effect_sprite": "Ice", 
					"effect_range": 4, 
					"number_of_targets": 100, 
					"msg": "Ra Muruga"
			}
				ProcessQueue.add_effect(action)
				action = {
					"name": "magic_damage_targets_range", 
					"caster": unit, 
					"damage": 10.0 * buffs.duration, 
					"damage_type": "psychic", 
					"effect_sprite": "Psychic", 
					"effect_range": 4, 
					"number_of_targets": 100, 
					"msg": "Ra Muruga"
			}
				ProcessQueue.add_effect(action)


static func senheb():
	var unit = Global.Player

	
	var action = {
			"name": "heal", 
			"amount": unit.get_ARM(), 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": "Senheb"
		}
	ProcessQueue.add_effect(action)

	for buff in unit.Buffs:
		if buff.name == "Corrosion" or buff.name == "Doom":
			action = {
			"name": "remove_buff", 
			"target": unit, 
			"buff": buff, 
			"msg": "Senheb"
		}
			ProcessQueue.add_effect(action)
	


static func sedjhet():
	var source = Global.Player
	var action = {
		"name": "magic_damage_targets_range", 
		"caster": source, 
		"damage": source.get_ARM(), 
		"damage_type": "death", 
		"effect_sprite": "Curse", 
		"effect_range": 2, 
		"number_of_targets": 50, 
		"msg": "Sedjhet"
			}
	ProcessQueue.add_effect(action)
	
	


static func neter():
	var unit = Global.Player
	var action = {
			"name": "magic_damage_target_closest", 
			"caster": unit, 
			"damage": 2.0 * unit.get_ARM(), 
			"damage_type": "fire", 
			"effect_sprite": "Flame", 
			"msg": "Neter Ammah"
				}
	ProcessQueue.add_effect(action)


static func ti():
	var unit = Global.Player
	var action = {
			"name": "heal", 
			"amount": 200 * (unit.invokes.ti.use + 1), 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": "Nesh Ti"
		}
	ProcessQueue.add_effect(action)
	unit.invokes.ti.use = 0
	
	for buff in unit.Buffs:
		if buff.name == "Scorch":
			action = {
			"name": "remove_buff", 
			"target": unit, 
			"buff": buff, 
			"msg": "Nesh Ti"
		}
			ProcessQueue.add_effect(action)
	
static func zatu():
	var unit = Global.Player
	var repeat = unit.invokes.ti.use + 1
	for n in repeat:
		var action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": unit, 
	"damage": 200.0, 
	"damage_type": "fire", 
	"effect_sprite": "Flame", 
	"number_of_targets": 5, 
	"effect_range": 4, 
	"enemies": null, 
	"msg": "Nesh Zatu"
				}
		ProcessQueue.add_effect(action)
		action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": unit, 
	"damage": 200.0, 
	"damage_type": "lightning", 
	"effect_sprite": "Zap", 
	"number_of_targets": 5, 
	"effect_range": 4, 
	"enemies": null, 
	"msg": "Nesh Zatu"
				}
		ProcessQueue.add_effect(action)
	unit.invokes.zatu.use = 0
	
static func girra():
	var unit = Global.Player
	var damage = unit.get_DMG_total(unit.weapon_main)
	var repeat = unit.invokes.ti.use + 1
	for n in repeat:
		var action = {
	"name": "magic_damage_tiles_in_range", 
	"caster": unit, 
	"damage": damage, 
	"damage_type": "fire", 
	"effect_sprite": "Flame", 
	"effect_range": 1, 
	"msg": "Nesh Girra"
				}
		ProcessQueue.add_effect(action)
	
		action = {
	"name": "magic_damage_tiles_in_range", 
	"caster": unit, 
	"damage": damage, 
	"damage_type": "lightning", 
	"effect_sprite": "Zap", 
	"effect_range": 1, 
	"msg": "Nesh Girra"
				}
		ProcessQueue.add_effect(action)
	unit.invokes.girra.use = 0
	

static func gibija():
	var source = Global.Player
	for n in 5:
		
		var action = {
		"name": "summon", 
		"alliance": "ally", 
		"type": LAllies.ally_data.slouchingdead, 
		"summoner": source, 
		"msg": "Gibija"
			}
		ProcessQueue.add_effect(action)
	
	

static func sluga():
	var source = Global.Player
	var action = {
		"name": "summon", 
		"alliance": "ally", 
		"type": LAllies.ally_data.slouchingdead, 
		"summoner": source, 
		"msg": "Sluga"
			}
	ProcessQueue.add_effect(action)

static func razaranja():
	var source = Global.Player
	
	var buff = cloner.clone_dict(LBuffs.buff_data.Doom)
	buff["target"] = source
	buff["source"] = source
	buff.duration = 25
	var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": "Razaranja"
		}
	ProcessQueue.add_effect(action)
	
	action = {
		"name": "summon", 
		"alliance": "ally", 
		"type": LAllies.ally_data.MawEresh, 
		"summoner": source, 
		"msg": "Razaranja"
			}
	ProcessQueue.add_effect(action)
	
static func contemplation():
	var unit = Global.Player
	var action = {
			"name": "heal", 
			"amount": float(unit.HP_max) * 0.2, 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": "Grim Contemplation"
		}
	ProcessQueue.add_effect(action)
	
	for buff in unit.Buffs:
		if buff.name != "Poise":
			action = {
			"name": "remove_buff", 
			"target": unit, 
			"buff": buff, 
			"msg": "Grim Contemplation"
		}
			ProcessQueue.add_effect(action)
	

static func punishment():
	var unit = Global.Player
	
	
	var action = {
			"name": "magic_damage_tiles_in_path_to_furthest", 
			"caster": unit, 
			"damage": unit.HP_max - unit.HP + 1, 
			"damage_type": "blunt", 
			"effect_sprite": "Bash", 
			"msg": "Sober Punishment"
				}
	ProcessQueue.add_effect(action)

static func violence():
	var unit = Global.Player
	
				
	
	var repeat = int(unit.get_total_inflex())
	for n in repeat:
		var action = {
			"name": "attack_targets", 
			"attacker": unit, 
			"number_of_targets": 1, 
			"msg": "Rigid Violence"
		}
	
		ProcessQueue.add_effect(action)
	


static func hurah():
	var unit = Global.Player
	var action = {
			"name": "heal", 
			"amount": 5.0 * unit.get_SPEED(), 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": "Hurah"
		}
	ProcessQueue.add_effect(action)
	

static func yirah():
	var unit = Global.Player
	for buff in unit.Buffs:
		if buff.name == "Sickness" or buff.name == "Entangle" or buff.name == "Freeze":
			var action = {
			"name": "remove_buff", 
			"target": unit, 
			"buff": buff, 
			"msg": "Yirah"
		}
			ProcessQueue.add_effect(action)
			
static func selem():
	var source = Global.Player
	
	var action = {
		"name": "magic_damage_targets_range", 
		"caster": source, 
		"damage": source.get_SPEED() * 50.0, 
		"damage_type": "slash", 
		"effect_sprite": "Wind", 
		"effect_range": 2, 
		"number_of_targets": 50, 
		"msg": "Selem"
			}
	ProcessQueue.add_effect(action)

static func drow():
	var unit = Global.Player
	var action = {
			"name": "heal", 
			"amount": 500.0, 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": "Proso Drow"
		}
	ProcessQueue.add_effect(action)

static func moc():
	var source = Global.Player
	
	var multi = 1
	var type = source.get_DMG_type(source.weapon_main)
	for buff in source.Buffs:
		if buff.name == "Drakeform":
			multi += buff.duration
	if multi > 1:
		var action = {
		"name": "magic_damage_tiles_in_range", 
		"caster": source, 
		"damage": 100.0 * multi, 
		"damage_type": type, 
		"effect_sprite": translate.dmgtype_to_animation(type), 
		"effect_range": 3, 
		"msg": "Proso Moc"
			}
		ProcessQueue.add_effect(action)

static func miana():
	var unit = Global.Player
	for buff in unit.Buffs:
		if buff.harmful == true:
			var action = {
			"name": "remove_buff", 
			"target": unit, 
			"buff": buff, 
			"msg": "Proso Miana"
		}
			ProcessQueue.add_effect(action)
	var buff = cloner.clone_dict(LBuffs.buff_data.Drakeform)
	buff["target"] = unit
	buff["source"] = unit
	buff.duration = 5
	var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": "Proso Miana"
		}
	ProcessQueue.add_effect(action)


static func turba():
	var ants = ["AntPoison", "AntFire", "AntBlood", "AntAstral"]
	var source = Global.Player
	print("turba")
	for unit in Global.Allies:
	
		if unit.get_name() == "Ant":
			print("ant summoned")
			var action = {
		"name": "summon", 
		"alliance": "ally", 
		"type": LAllies.ally_data[ants[Global.rng.randi_range(0, ants.size() - 1)]], 
		"summoner": source, 
		"msg": "Turba"
			}
			ProcessQueue.add_effect(action)
			
static func spera():
	var source = Global.Player
	for unit in Global.Allies:
				if unit != Global.Player:
					var action = {
			"name": "apply_bonus", 
			"origin": source, 
			"target": unit, 
			"amount": 10.0, 
			"type": "damage", 
			"msg": "Spera"
			}
					ProcessQueue.add_effect(action)
					action = {
			"name": "apply_bonus", 
			"origin": source, 
			"target": unit, 
			"amount": 10.0, 
			"type": "speed", 
			"msg": "Spera"
			}
					ProcessQueue.add_effect(action)

static func viva():
	var ants = ["AntPoison", "AntFire", "AntBlood", "AntAstral"]
	var source = Global.Player
	var action = {
		"name": "summon", 
		"alliance": "ally", 
		"type": LAllies.ally_data[ants[Global.rng.randi_range(0, ants.size() - 1)]], 
		"summoner": source, 
		"msg": "Viva Formica"
			}
	ProcessQueue.add_effect(action)


static func ygeia():
	var unit = Global.Player

	
	var action = {
			"name": "heal", 
			"amount": unit.get_block_strength(), 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": "Ygeia"
		}
	ProcessQueue.add_effect(action)
	
static func doru():
	var source = Global.Player
	var unit = Global.Player
	
	var action = {
			"name": "magic_damage_target_closest", 
			"caster": source, 
			"damage": 50.0, 
			"damage_type": "pierce", 
			"effect_sprite": "Pierce", 
			"msg": "Doru"
				}
	ProcessQueue.add_effect(action)
	
	var repeat = unit.get_total_weapon_size()
	for n in repeat:
		ProcessQueue.add_effect(action)

static func tekton():
	
	var unit = Global.Player
	var item = null
	if unit.weapon_off != null:
		item = unit.weapon_off
	elif unit.weapon_main != null:
		item = unit.weapon_main
	
	if item != null:
		item.dmg += 3
		item.arm += 30
		var stringa = ""
		stringa += item.name
		stringa = "[color=#ff7070]Pallas[/color] 무기 강화: " + stringa + " [color=#ff8030]+30 명중[/color] / [color=#5050ff]+30 방어[/color]"
		stringa += " [color=#707070]→ " + str(item.dmg * 10) + " 명중 / " + str(item.arm) + " 방어 ← Tekton[/color]"
		ToolMessageCreator.add_message("[color=#c0c0c0]", stringa)


static func oriad():
	var unit = Global.Player
	var action = {
			"name": "heal", 
			"amount": unit.HP_max - unit.HP, 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": "Oriad"
		}
	ProcessQueue.add_effect(action)

static func mira():
	var unit = Global.Player
	for n in 3:
		var action = {
					"name": "summon_random", 
					"alliance": "ally", 
					"type": LAllies.ally_data.tentacle, 
					"summoner": unit, 
					"msg": "Teth Mira"
				}
		ProcessQueue.add_effect(action)

static func ogra():
	var unit = Global.Player
	for n in 6:
		var action = {
					"name": "summon_random", 
					"alliance": "ally", 
					"type": LAllies.ally_data.tentacle, 
					"summoner": unit, 
					"msg": "Teth Ogra"
				}
		ProcessQueue.add_effect(action)

static func yahrub():
	for unit in Global.Allies:
		var action = {
				"name": "teleport_random", 
				"unit": unit, 
				"msg": "Yahrub"
			}
		ProcessQueue.add_effect(action)
	
		

static func wizara():
	for unit in Global.Enemies:
		var action = {
				"name": "teleport_random", 
				"unit": unit, 
				"msg": "Wizara"
			}
		ProcessQueue.add_effect(action)
	
	

static func yamur():
	if Global.Enemies.size():
		var unit = Global.Enemies[Global.rng.randi_range(0, Global.Enemies.size() - 1)]
		var action = {
			"name": "teleport", 
			"unit": unit, 
			"tile_target": Global.Player.residence, 
			"msg": "Yamur"
			}
		ProcessQueue.add_effect(action)
	

static func gula():
	var unit = Global.Player
	var heal = float(Global.Player.HP_max) * 0.1
	var action = {
			"name": "heal", 
			"amount": heal, 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": "Gula"
		}
	ProcessQueue.add_effect(action)
	
	action = {
		"name": "heal_allies_in_range", 
		"caster": unit, 
		"amount": heal, 
		"effect_range": 99, 
		"msg": "Gula"
			}
	ProcessQueue.add_effect(action)
	
static func umam():
	var source = Global.Player
	var action = {
		"name": "summon", 
		"alliance": "ally", 
		"type": LAllies.ally_data.mardok, 
		"summoner": source, 
		"msg": "Umam"
			}
	ProcessQueue.add_effect(action)
	
static func namkalag():
	var source = Global.Player
	for unit in Global.Allies:
		if unit != Global.Player:
			if unit.get_traits().has("Familiar"):
					var amount = float(unit.get_DMG(null)) * 0.5
					var action = {
			"name": "apply_bonus", 
			"origin": source, 
			"target": unit, 
			"amount": amount, 
			"type": "damage", 
			"msg": "Nam-Kalag"
			}
					ProcessQueue.add_effect(action)
	
static func bahu():
	var source = Global.Player
	var buff_duration = 5
	
	var buff = cloner.clone_dict(LBuffs.buff_data.Refraction)
	buff["target"] = source
	buff["source"] = source
	buff.duration = buff_duration
	var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": "Bahu"
		}
	ProcessQueue.add_effect(action)
	
	action = {
			"name": "heal", 
			"amount": 50.0, 
			"healer_unit": source, 
			"healed_unit": source, 
			"msg": "Bahu"
		}
	ProcessQueue.add_effect(action)

static func chundu():
	var unit = Global.Player
	var buff_scaling = 0.5
	for checkbuff in unit.Buffs:
		if checkbuff.source == unit:
				var buff = cloner.clone_dict(LBuffs.buff_data[checkbuff.title])
				buff["target"] = unit
				buff["source"] = unit
				buff.duration = int(float(checkbuff.duration) * buff_scaling)
				var action = {
			"name": "add_buff", 
			"buff": buff, 
			"msg": "Chundu"
			}
				ProcessQueue.add_effect(action)

static func gongu():
	var unit = Global.Player
	var damage = 2500.0
	for buff in unit.Buffs:
		damage += float(buff.duration)
	
	if damage >= 1.0:
		var action = {
			"name": "magic_damage_tiles_in_path_to_furthest", 
			"caster": unit, 
			"damage": damage, 
			"damage_type": "poison", 
			"effect_sprite": "YuPoison", 
			"msg": "Gongu"
				}
		ProcessQueue.add_effect(action)

static func eranya():
	var unit = Global.Player
	for n in 2:
		var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.TealPrisma, 
					"summoner": unit, 
					"msg": "Eranya"
				}
		ProcessQueue.add_effect(action)

static func omranya():
	var unit = Global.Player
	for n in 4:
		var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.TopazPrisma, 
					"summoner": unit, 
					"msg": "Omranya"
				}
		ProcessQueue.add_effect(action)

static func anranya():
	var unit = Global.Player
	for n in 1:
		var action = {
					"name": "summon", 
					"alliance": "ally", 
					"type": LAllies.ally_data.GarnetPrisma, 
					"summoner": unit, 
					"msg": "Anranya"
				}
		ProcessQueue.add_effect(action)

static func glyad():
	var unit = Global.Player
	for enemy in Global.Enemies:
				var buff = cloner.clone_dict(LBuffs.buff_data.Blind)
				buff["target"] = enemy
				buff["source"] = unit
				buff.duration = unit.level
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": "Glyad"
			}
				ProcessQueue.add_effect(action)

static func goret():
	var unit = Global.Player
	for enemy in Global.Enemies:
				var buff = cloner.clone_dict(LBuffs.buff_data.Scorch)
				buff["target"] = enemy
				buff["source"] = unit
				buff.duration = unit.level
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": "Goret"
			}
				ProcessQueue.add_effect(action)

static func krasota():
		var unit = Global.Player
		var action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": 1000.0, 
					"damage_type": "fire", 
					"effect_sprite": "Flame", 
					"msg": "Krasota"
				}
		ProcessQueue.add_effect(action)


static func eird():
		var unit = Global.Player
		var buff = cloner.clone_dict(LBuffs.buff_data.Corrosion)
		buff["target"] = unit
		buff["source"] = unit
		buff.duration = 20
		var action = {
		"name": "add_buff", 
		"buff": buff, 
		"msg": "Du' Eird"
		}
		ProcessQueue.add_effect(action)
		
		if Global.Enemies.size() == 0:
			action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": 300.0, 
					"damage_type": "psychic", 
					"effect_sprite": "Psychic", 
					"msg": "Du' Eird"
				}
			ProcessQueue.add_effect(action)

static func eiqab():
	var unit = Global.Player
	for enemy in Global.Enemies:
		if enemy.get_buff_names().has("Corrosion"):
			var action = {
					"name": "magic_damage_target", 
					"target": enemy, 
					"caster": unit, 
					"damage": 200.0, 
					"damage_type": "psychic", 
					"effect_sprite": "Psychic", 
					"msg": "Eiqab"
				}
			ProcessQueue.add_effect(action)

static func muejab():
	var source = Global.Player
	
	var action = {
		"name": "magic_damage_targets_range", 
		"caster": source, 
		"damage": 0.25 * float(source.HP_max), 
		"damage_type": "psychic", 
		"effect_sprite": "Psychic", 
		"effect_range": 99, 
		"number_of_targets": 1, 
		"msg": "Muejab"
			}
	ProcessQueue.add_effect(action)

static func auzom():
		var unit = Global.Player
		var action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": unit, 
	"damage": 100.0, 
	"damage_type": "lightning", 
	"effect_sprite": "Zap", 
	"number_of_targets": 1, 
	"effect_range": 99, 
	"enemies": null, 
	"msg": "Ag' Auzom"
				}
		ProcessQueue.add_effect(action)
		action = {
	"name": "magic_damage_tiles_in_path_to_targets_in_range", 
	"caster": unit, 
	"damage": 100.0, 
	"damage_type": "astral", 
	"effect_sprite": "Astral", 
	"number_of_targets": 1, 
	"effect_range": 99, 
	"enemies": null, 
	"msg": "Ag' Auzom"
				}
		ProcessQueue.add_effect(action)
static func ragna():
	var unit = Global.Player
	var action = {
	"name": "magic_damage_tiles_in_range", 
	"caster": unit, 
	"damage": 500.0, 
	"damage_type": "ice", 
	"effect_sprite": "Ice", 
	"effect_range": 1, 
	"msg": "Ag' Ragna"
				}
	ProcessQueue.add_effect(action)
	action = {
	"name": "magic_damage_tiles_in_range", 
	"caster": unit, 
	"damage": 500.0, 
	"damage_type": "fire", 
	"effect_sprite": "Flame", 
	"effect_range": 1, 
	"msg": "Ag' Ragna"
				}
	ProcessQueue.add_effect(action)
static func agara():
	var source = Global.Player
	if source.invokes.auzom.use < source.invokes.auzom.use_max:
		source.invokes.auzom.use += 1
		ToolMessageCreator.add_message("[color=#707070]", "Ag' Auzom +1 Ag' Agara")
	
	if source.invokes.ragna.use < source.invokes.ragna.use_max:
		source.invokes.ragna.use += 1
		ToolMessageCreator.add_message("[color=#707070]", "Ag' Ragna +1 Ag' Agara")


static func enq():
	var unit = Global.Player
	for enemy in Global.Enemies:
		var action = {
			"name": "heal", 
			"amount": 10.0, 
			"healer_unit": unit, 
			"healed_unit": unit, 
			"msg": "Enq"
		}
		ProcessQueue.add_effect(action)
		
		
static func cheren():
	var unit = Global.Player
	
	Global.Player.HP_max += 20
	Global.Player.HP += 20
	ToolMessageCreator.add_message("[color=#a0c0c0]", "오 강대한 [color=#80af00]Takhal[/color]! [color=#707070]+20 체력[/color]")
	if ToolSettings.settings_data.cycle_current > 1:
				var hp_bonus = float(2)
				hp_bonus *= float(ToolSettings.settings_data.cycle_current)
				Global.Player.HP_max += int(hp_bonus)
				Global.Player.HP += int(hp_bonus)
				ToolMessageCreator.add_message("[color=#ff5050]", "순환의 기운이 충전된다...[color=#707070] +" + str(int(hp_bonus)) + " 체력[/color]")
	
	var action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": 100 * Global.Enemies.size(), 
					"damage_type": "death", 
					"effect_sprite": "Curse", 
					"msg": "Cheren"
				}
	ProcessQueue.add_effect(action)
	
	
static func khairkhan():
	var unit = Global.Player
	for enemy in Global.Enemies:
		var action = {
					"name": "magic_damage_target", 
					"target": unit, 
					"caster": unit, 
					"damage": 50, 
					"damage_type": "poison", 
					"effect_sprite": "PoisonHit", 
					"msg": "Khairkhan"
				}
		ProcessQueue.add_effect(action)


static func prakara():
	var source = Global.Player
	var damage = source.HP_max - source.HP
	if damage < 1: damage = 1
	if damage >= 1:
		var action = {
		"name": "magic_damage_tiles_in_range", 
		"caster": source, 
		"damage": (source.invokes.prakara.use + 1) * damage, 
		"damage_type": "poison", 
		"effect_sprite": "PoisonHit", 
		"effect_range": 4, 
		"msg": "Prakara"
			}
		ProcessQueue.add_effect(action)
		action = {
		"name": "magic_damage_tiles_in_range", 
		"caster": source, 
		"damage": (source.invokes.prakara.use + 1) * damage, 
		"damage_type": "blood", 
		"effect_sprite": "Blood", 
		"effect_range": 4, 
		"msg": "Prakara"
			}
		ProcessQueue.add_effect(action)
		source.invokes.prakara.use = 0

static func ksudha():
	var source = Global.Player
	if source.invokes.prakara.use > 0:
		
		var action = {
			"name": "heal", 
			"amount": 20.0 * source.invokes.prakara.use, 
			"healer_unit": source, 
			"healed_unit": source, 
			"msg": "Ksudha"
		}
		ProcessQueue.add_effect(action)

static func rogoga():
	var unit = Global.Player
	if unit.invokes.prakara.use > 0:
		for enemy in Global.Enemies:
				var buff = cloner.clone_dict(LBuffs.buff_data.Sickness)
				buff["target"] = enemy
				buff["source"] = unit
				buff.duration = 1 * unit.invokes.prakara.use
				var action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": "Rogoga"
			}
				ProcessQueue.add_effect(action)
				
				buff = cloner.clone_dict(LBuffs.buff_data.Bleed)
				buff["target"] = enemy
				buff["source"] = unit
				buff.duration = 1 * unit.invokes.prakara.use
				action = {
				"name": "add_buff", 
				"buff": buff, 
				"msg": "Rogoga"
			}
				ProcessQueue.add_effect(action)

static func isfet():
	var source = Global.Player
	var action = {
					"name": "magic_damage_target", 
					"target": source, 
					"caster": source, 
					"damage": 15.0 * source.get_total_STR(), 
					"damage_type": "astral", 
					"effect_sprite": "AFlame", 
					"msg": "Pha Isfet"
				}
	ProcessQueue.add_effect(action)
	action = {
		"name": "magic_damage_tiles_in_range", 
		"caster": source, 
		"damage": 15.0 * source.get_total_STR(), 
		"damage_type": "astral", 
		"effect_sprite": "AFlame", 
		"effect_range": 2, 
		"msg": "Pha Isfet"
			}
	ProcessQueue.add_effect(action)

static func hetep():
	var unit = Global.Player
	for buff in unit.Buffs:
		if buff.harmful == true:
			var action = {
			"name": "remove_buff", 
			"target": unit, 
			"buff": buff, 
			"msg": "Pha Hetep"
		}
			ProcessQueue.add_effect(action)
	
static func neheb():
	var source = Global.Player
	var action = {
					"name": "magic_damage_target", 
					"target": source, 
					"caster": source, 
					"damage": 30.0 * source.get_total_STR(), 
					"damage_type": "astral", 
					"effect_sprite": "AFlame", 
					"msg": "Pha Neheb"
				}
	ProcessQueue.add_effect(action)
	for enemy in Global.Enemies:
		action = {
					"name": "magic_damage_target", 
					"target": enemy, 
					"caster": source, 
					"damage": 30.0 * source.get_total_STR(), 
					"damage_type": "astral", 
					"effect_sprite": "AFlame", 
					"msg": "Pha Neheb"
				}
		ProcessQueue.add_effect(action)
	source.invokes.neheb.use = 0
