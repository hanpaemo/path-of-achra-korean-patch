extends Node2D

var object_type = "enemy"
var residence = null

var Turns = 0.0

var HP = 50.0
var HP_max = 50.0
var STR = 5.0
var DEX = 5.0
var WIL = 5.0

var cycle_boosted = false

var ACC = 5.0
var DMG = 5.0
var DMG_type = "blunt"
var DEF = 5.0
var SPEED = 4.0
var speedmin = 1.0

var is_stationary = false

var dodge = 0.0
var dodge_sides = 0.0
var deflect = 0.0
var deflect_sides = 0.0
var deflect_strength = 0.0
var accuracy = 0.0
var accuracy_sides = 0.0
var damage = 0.0
var damage_sides = 0.0

var cycle = []

var abilities = {
	
}

var size = 1
var ARM = 10.0

var range_move = 1
var range_attack = 2
var range_sight = 6
var hands_used = 1

var speed_bank = 10
var speed = 10

var game = null
var Player = null
var weapon_main = null
var weapon_off = null

var aoe = 1

var projectile_art = "res://Ham_Sprite/Props/Object_Arrow.png"
var event_killer = null
var event_killing_damg_type = "none"

var type = LEnemies.ratman_archer
var taunt = ""
var spritescreen = ""
var sprite_corpse = "CorpseRed"

var inherited_types = []
var Buffs = []
var Effects = []


var tick = 1.0


var trait_memory = {}

func _process(_delta):
	if ToolSettings.settings_data.speed_bar == true:
		$SpeedBar.visible = true
		if ProcessQueue2.active_units.has(self):
			$SpeedBar / bar.modulate = Color(1, 1, 1, 1)
		elif check_next_turn():
			$SpeedBar / bar.modulate = Color(1, 1, 1, 1)
		
	else:
		$SpeedBar.visible = false

func check_next_turn():
	
	var boola = false
	if Global.game != null and Global.Player != null:
		var ticks_left = (100.0 - (float(tick))) / float(get_SPEED())
		var player_ticks_left = (100.0 - (float(Global.Player.tick))) / float(Global.Player.get_SPEED())
		if ticks_left < player_ticks_left:
			boola = true

	
	return boola

func initiate():
	game = get_parent()
	if object_type == "enemy":
		Global.Enemies.append(get_node("."))
	elif object_type == "ally":
		Global.Allies.append(get_node("."))
	load_type()
	update()
	event_spawn.check(get_node("."), object_type)
	
	update()


func initiate_summoned():
	game = get_parent()
	if object_type == "enemy":
		Global.Enemies.append(get_node("."))
	elif object_type == "ally":
		Global.Allies.append(get_node("."))
	load_type()
	
	
	update_traits()
	add_bonuses()
	apply_inheritances()
	
	update()

func load_type():
	type = cloner.clone_dict(type)
	HP = float(type["hp"])
	HP_max = float(type["hp"])
	
	
	
	SPEED = float(type["speed"])
	if type.has("speedmin"):
		speedmin = float(type.speedmin)
	ARM = float(type["arm"])
	range_attack = int(type["range_attack"])
	projectile_art = str(type["proj_art"])
	size = int(type["size"])
	DMG_type = str(type["dmgtype"])
	
	
	dodge = float(type["dodge"][0])
	dodge_sides = float(type["dodge"][1])
	deflect = float(type["deflect"][0])
	deflect_sides = float(type["deflect"][1])
	deflect_strength = float(type["deflect"][2])
	accuracy = float(type["accuracy"][0])
	accuracy_sides = float(type["accuracy"][1])
	damage = float(type["damage"][0])
	damage_sides = float(type["damage"][1])
	
	sprite_corpse = type["sprite_corpse"]
	if object_type == "enemy":
		cycle = type["cycle"]
	
	abilities = type["abilities"]
	var abilities_new = {}
	for key in abilities:
		if LTraitsGeneric.trait_data.has(key):
			var trait = cloner.clone_dict(LTraitsGeneric.trait_data[key])
			var name = trait.title
		
			
			abilities_new[name] = trait
	abilities = {
		
	}
	abilities = abilities_new
	
	taunt = type["taunt"]
	spritescreen = type["sprite"]
	$Sprite.texture = load(type["sprite"])




func update():
	update_traits()
	
	Player = game.Player
	
	
	
	
	
	
	
	buffcheck.just_erase(self)
	
	update_damage()
	
	if get_traits().has("stationary"):
		is_stationary = true

func die():
	if Global.Enemies.has(get_node(".")) == true or Global.Allies.has(get_node(".")) == true:
		event_all.on_death(get_node("."), event_killer)


func is_dead():
	var is_dead = false
	if HP < 1:
		is_dead = true
	return is_dead
	
func get_name():
	var stringa
	stringa = type["name"]
	return stringa

func get_name_color():
	var stringa
	stringa = type["name_color"]
	return stringa

func get_killer_name():
	var stringa = type["name_color"]
	return stringa

func get_traits():
	var traits = trait_memory
	
		
			
	return traits


func update_traits():
	trait_memory = {}
	for trait in abilities:
		if trait != "none":
			trait_memory[LTraitsGeneric.trait_data[trait].title] = LTraitsGeneric.trait_data[trait]
	pass

func get_resist(label):
	var resist = 0.0
	var key = "resist_" + label
	if type.has(key):
		resist += type[key]
	
	for buff in Buffs:
		if buff.name == "Plague":
			if resist > 0:
				resist -= buff.duration
				if resist < 0: resist = 0
	
	if resist > 90:
		resist = 90
	if resist < - 100:
		resist = - 100
	return resist

func get_projectile_art(_weapon):
	var spr = null
	if projectile_art != "none":
		spr = projectile_art
	return spr

func get_SPEED():
	var reala
	reala = SPEED
	
	reala += StatMods.check(get_node("."), "speed")
	
	reala = float(reala)
	
	if reala < speedmin:
		reala = speedmin
		
		
	if get_buff_names().has("Paralysis"):
		reala = float(speedmin)
	
	reala = float(reala)
	
	if reala < 1.0:
		reala = 1.0
	
	return reala

func has_turn(player_speed):
	var reala = get_SPEED() / float(player_speed)
	if reala >= 1.0:
		reala = 1.0
	Turns += reala
	if Turns >= 1.0:
		Turns -= 1.0
		return true
	else:
		return false

func get_armor_list():
	var inta = 0
	return inta

func get_range_attack(_weapon):
	var inta
	inta = range_attack
	return inta

func get_hands_used():
	var inta
	inta = hands_used
	return inta
	
func get_ACC(_weapon):
	var inta
	inta = accuracy
	inta += StatMods.check(get_node("."), "attack")
	if inta < 1:
		inta = 1
	return inta

func get_ACC_sides(_weapon):
	var inta
	inta = 10
	return inta

func get_ACC_total(_weapon):
	var inta
	inta = get_ACC_sides(_weapon) * get_ACC(_weapon)
	return inta

func get_DMG(_weapon):
	var inta
	inta = damage
	
	inta += StatMods.check(get_node("."), "damage")
	if inta < 1:
		inta = 1
	
	return inta

func get_DMG_max(_weapon):
	var inta
	inta = get_DMG_sides(_weapon) * get_DMG(_weapon)
	return inta

func get_DMG_total(_weapon):
	var inta
	inta = get_DMG_sides(_weapon) * get_DMG(_weapon)
	return inta

func get_DMG_type(_weapon):
	var stringa = ""
	stringa = DMG_type
	return stringa


func get_DMG_sides(_weapon):
	var inta
	inta = 10
	return inta

func get_DEF():
	var inta = 0.0
	inta += dodge
	
	inta += StatMods.check(get_node("."), "dodge")
	
	if inta < 1:
		inta = 1
		
	return inta

func get_DEF_sides():
	var inta
	inta = 10
	return inta

func get_DEF_total():
	
	var inta
	inta = dodge
	
	inta += StatMods.check(get_node("."), "dodge")
	
	inta *= get_DEF_sides()
	
	if get_buff_names().has("Paralysis"):
		inta = 1
	
	if inta < 1:
		inta = 1
		
	return inta
	

func get_ARM():
	var inta = 0.0
	inta += ARM
	inta += StatMods.check(get_node("."), "armor")
	if inta < 1.0:
		inta = 1.0
	return inta

func get_block():
	var inta = 0.0
	inta += deflect
	inta += StatMods.check(get_node("."), "defense")
	
	if inta < 1:
		inta = 1
	return inta

func get_block_chance():
	var inta = 50.0
	return inta

func get_block_sides():
	var inta = deflect_sides
	return inta

func get_block_strength():
	var inta = 0.0
	inta = deflect_strength
	inta += StatMods.check(get_node("."), "block")
	
	if inta < 1.0:
		inta = 1.0
	
	return inta

func get_total_STR():
	var inta = 0.0
	inta += STR
	return inta

func get_total_DEX():
	var inta = 0.0
	inta += DEX
	return inta

func get_total_WIL():
	var inta = 0.0
	inta += WIL
	return inta

func get_total_inflex():
	var inta = 1.0
	return inta

func get_total_weapon_size():
	var inta = 0.0
	return inta

func get_total_weight():
	var inta = 0.0
	return inta


func get_aoe(_weapon):
	var inta = aoe
	if get_traits().has("AOE"):
		inta = 2
	return inta

func update_damage():
	draw_life()
	if HP < 1:
		$Node2D / Lifebar.modulate = Color(1, 1, 1, 0)
		die()

func draw_life():
	if HP == HP_max:
		$ColorRect.modulate = Color(0, 0, 0, 0)
		$Node2D / Lifebar.modulate = Color(0, 0, 0, 0)
	if HP < HP_max:
		$ColorRect.modulate = Color(1, 1, 1, 1)
		$Node2D / Lifebar.modulate = Color(1, 0.5, 0.3, 1)
		if object_type == "ally":
			$Node2D / Lifebar.modulate = Color(0.8, 0.3, 0.8, 1)
			
		$Node2D / Lifebar.rect_scale.x = hp_percent()

func draw_speed():
		$SpeedBar.visible = true
		$SpeedBar / bar.rect_scale.x = float(tick) / float(100.0)
		if ProcessQueue2.active_units.has(self):
			$SpeedBar / bar.modulate = Color(1, 1, 1, 1)
			$SpeedBar / bar.rect_scale.x = 1.0
		else:
			$SpeedBar / bar.modulate = Color(0.5, 0.5, 0.5, 1)
		
		if $SpeedBar / bar.rect_scale.x > 1.0:
			$SpeedBar / bar.rect_scale.x = 1.0
		

func hp_percent():
	return (float(HP) / float(HP_max))
	
	
func get_buff_names():
	var array = []
	for buff in Buffs:
		array.append(buff.name)
	return array
	
func buffs_tick():
	
	var array = []
	for effect in Effects:
		array.append(effect)
	
	for effect in array:
		Effects.erase(effect)
		effect.temp = true
	
	
	var Buffs_Remove = []
	
	for buff in Buffs:
		if buff.duration <= 0:
			Buffs_Remove.append(buff)
	
	if Buffs_Remove.size() > 0:
		for buff in Buffs_Remove:
			Buffs.erase(buff)
	
	
	for buff in Buffs:
		buff.duration -= 1
		buffcheck.check(buff.name, buff.duration, buff.target, buff.source, buff)





func _on_Button_pressed():
	if Global.Player.is_dead() == false and StateWorld.victorious == false:
			if Global.game.paused == false:
				if ProcessQueue.PAUSED == false and ProcessQueue.ACTIVE == false:
					pressed()
	

func pressed():
	print("ENEMY PRESSED!")
	Player = game.Player
	var tile_start = Player.residence
	var tile_end = residence
	
	if object_type == "enemy":
		var weapon = Player.weapon_main
		var tile_range = Player.get_range_attack(weapon)
		if calcrange.tile_is_in_range_unblocked(tile_start, tile_end, tile_range) == true:
			Player.target_enemy = get_node(".")
			standard_attack(tile_start, tile_end)
		else:
			residence.pressed()
		
	if object_type == "ally":
		
		var tile_range = Player.range_move
		var action = ["player_move", tile_start, tile_end, tile_range]
		if calcrange.tile_is_in_range(tile_start, tile_end, tile_range) == true:
			ProcessQueue.queue.append(action)
			ProcessQueue.run_queue()
		else:
			residence.pressed()
	
	
	
	
	
		

func standard_attack(tile_start, tile_end):
		var weapon = Player.weapon_main
		var tile_range = Player.get_range_attack(weapon)
		var enemy = get_node(".")
		var action = ["player_attack_enemy", tile_start, tile_end, tile_range, enemy, weapon]
		var msg = "Initial"
		check_player_extra_attacks(Player, tile_start, tile_end, tile_range, enemy, weapon, action)
		
		
		
		if Player.get_hands_used() == 1:

			if Player.get_aoe(weapon) > 1:
				
				tile_start = Player.residence
				var border_tiles = ToolCalculateRange.get_border_tiles_occupied_in_range(tile_start, Player.get_range_attack(weapon))
				var count = 1
				for tile in border_tiles:
					if tile.resident != null:
						if tile.resident != get_node(".") and tile.resident.object_type == "enemy":
							count += 1
							enemy = tile.resident
							tile_end = tile
							check_player_extra_attacks(Player, tile_start, tile_end, tile_range, enemy, Player.weapon_main, action)
							ToolMagicMaker.add_attack(Player, tile_start, tile_end, tile_range, enemy, weapon, msg)
							
							
							
				var msg_string = "범위 공격: " + translate.get_weapon_name(weapon) + "...x" + str(count)
				ToolMessageCreator.add_message("[color=#707070]", msg_string)
			else:
				var msg_string = "공격: " + translate.get_weapon_name(Player.weapon_main) + "..."
				ToolMessageCreator.add_message("[color=#707070]", msg_string)
				
		if Player.get_hands_used() == 2:
			
			weapon = Player.weapon_off
			
			
			tile_range = Player.get_range_attack(weapon)
			if calcrange.tile_is_in_range(Player.residence, residence, tile_range) == true:
				var extra_attack_range = Player.get_range_attack(Player.weapon_main)
				check_player_extra_attacks(Player, tile_start, tile_end, extra_attack_range, enemy, Player.weapon_main, action)
			ToolMagicMaker.add_ANYHAND_attack(Player, tile_start, tile_end, tile_range, enemy, weapon, msg)
		
		
		weapon = Player.weapon_main
		tile_range = Player.get_range_attack(weapon)
		enemy = get_node(".")
		
		
		action = ["player_attack_enemy", tile_start, tile_end, tile_range, enemy, weapon, msg]
		
		ProcessQueue.queue.append(action)
		if Player.get_hands_used() == 2:
			var msg_string = "공격: " + translate.get_weapon_name(Player.weapon_main) + " & " + translate.get_weapon_name(Player.weapon_off) + "..."
			ToolMessageCreator.add_message("[color=#707070]", msg_string)
		
		
		
		ProcessQueue.run_queue()

func add_attack(Player, tile_start, tile_end, tile_range, enemy, _weapon, msg):
	var action2 = {
		"name": "attack_extra"
		, "attacker": Player
		, "defender": enemy
		, "weapon": Player.weapon_main
		, "tile_start": tile_start
		, "tile_end": tile_end
		, "tile_range": tile_range
		, "msg": msg
	}
	ProcessQueue.add_effect(action2)

func check_player_extra_attacks(_Player, _tile_start, _tile_end, _tile_range, _enemy, weapon, _action):
	pass
func check_player_extra_attacks_defunct(Player, tile_start, tile_end, tile_range, enemy, weapon, _action):
	
	
			
	if Player.get_traits().has("AttackTwice"):
			var msg = Player.get_traits().AttackTwice.Name
			ToolMagicMaker.add_attack(Player, tile_start, tile_end, tile_range, enemy, weapon, msg)
	
	if Player.get_traits().has("LiYan") == true:
		if Player.Buffs.size() > 0:
			for buff in Player.Buffs:
				var msg = Player.get_traits().LiYan.Name
				ToolMagicMaker.add_attack(Player, tile_start, tile_end, tile_range, enemy, weapon, msg)
	
	
	if Player.get_traits().has("Kashra"):
			var msg = Player.get_traits().Kashra.Name
			ToolMagicMaker.add_attack(Player, tile_start, tile_end, tile_range, enemy, weapon, msg)
			ToolMagicMaker.add_attack(Player, tile_start, tile_end, tile_range, enemy, weapon, msg)
	
	if Player.get_traits().has("Kendo"):
		
			for n in Player.get_traits().Kendo.Level:
				var attack_action = {
			"name": "attack_targets", 
			"attacker": Player, 
			"number_of_targets": 1, 
			"msg": Player.get_traits().Kendo.Name
		}
	
				ProcessQueue.add_effect(attack_action)
	
	if Player.get_traits().has("Claideb"):
		var number_of_target = 4 - Player.get_armor_list().size()
		for n in number_of_target:
			var action = {
			"name": "attack_targets", 
			"attacker": Player, 
			"number_of_targets": 1, 
			"msg": Player.get_traits().Claideb.Name
		}
	
			ProcessQueue.add_effect(action)
	
	if Player.get_traits().has("MasterEntangle"):
			if Player.get_buff_names().has("Entangle"):
				var repeat = 0
				for buff in Player.Buffs:
					if buff.name == "Entangle":
						repeat = buff.duration / 5
				if repeat > 0:
					for n in repeat:
						var attack_action = {
			"name": "attack_targets", 
			"attacker": Player, 
			"number_of_targets": 1, 
			"msg": Player.get_traits().MasterEntangle.Name
		}
	
						ProcessQueue.add_effect(attack_action)
	
	if Player.get_buff_names().has("Berserk"):
			var msg = "Berserk"
			ToolMagicMaker.add_attack(Player, tile_start, tile_end, tile_range, enemy, weapon, msg)
	
		
		
			
	if Player.get_traits().has("Venite"):
		if get_buff_names().has("Sickness") == true:
			var msg = Player.get_traits().Venite.Name
			ToolMagicMaker.add_attack(Player, tile_start, tile_end, tile_range, enemy, weapon, msg)
			ToolMagicMaker.add_attack(Player, tile_start, tile_end, tile_range, enemy, weapon, msg)
			ToolMagicMaker.add_attack(Player, tile_start, tile_end, tile_range, enemy, weapon, msg)
	
func slide(pos_start, pos_end):
	var tween = get_node("Tween")
	tween.interpolate_property(get_node("."), "position", 
		pos_start, pos_end, 0.3, 
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _on_Button_mouse_entered():
	Global.sound.new_sound("Hover")
	ToolMessageCreator.hover_info = get_node(".")
	
	
	ToolMessageCreator.hover_info_type = "unit"
	game.update_range_indicators()
	ToolMessageCreator.update()


func _on_Button_mouse_exited():
	ToolMessageCreator.hover_info = null
	ToolMessageCreator.hover_info_type = "none"
	game.update_range_indicators()
	ToolMessageCreator.update()


func apply_inheritances():
	if object_type == "ally":
		
		
		var inherited_labels = []
		var msg = ""
		if Global.Player != null:
			
			if get_traits().has("gorse"):
				HP_max = int(Global.Player.HP_max)
				HP = int(Global.Player.HP_max)
				inherited_types.append("life")
				inherited_labels.append("life")
				msg = get_traits().gorse.Name
			
			if get_traits().has("SacredSkin"):
				HP_max = int(0.2 * float(Global.Player.HP_max))
				HP = int(0.2 * float(Global.Player.HP_max))
				inherited_types.append("life")
				inherited_labels.append("life")
				msg = get_traits().SacredSkin.Name
				
				
			if get_traits().has("Psychomorph"):
				var weapon = Global.Player.weapon_main
				damage = int(float(Global.Player.get_DMG_total(weapon)) / 10.0)
				if damage < 1:
					damage = 1
				
				accuracy = int(Global.Player.get_ACC_total(weapon) / 10.0)
				if accuracy < 1:
					accuracy = 1
				inherited_types.append("damage")
				inherited_types.append("accuracy")
				inherited_labels.append("damage")
				inherited_labels.append("accuracy")
				msg = get_traits().Psychomorph.Name
				
				
			if get_traits().has("Hemogoblin"):
				HP_max = int(Global.Player.HP_max)
				HP = int(Global.Player.HP_max)
				var weapon = Global.Player.weapon_main
				damage = int(float(Global.Player.get_DMG_total(weapon)) / 10.0)
				if damage < 1:
					damage = 1
				inherited_types.append("life")
				inherited_types.append("damage")
				inherited_labels.append("life")
				inherited_labels.append("damage")
				msg = get_traits().Hemogoblin.Name
				
				
			if get_traits().has("DumuziServant"):
				ARM = int(Global.Player.get_ARM())
				deflect_strength = int(Global.Player.get_block_strength())
				inherited_types.append("armor")
				inherited_types.append("block")
				inherited_labels.append("armor")
				inherited_labels.append("block")
				msg = get_traits().DumuziServant.Name
				
				
			if get_traits().has("OrosAppendage"):
				var weapon = Global.Player.weapon_main
				damage = int(float(Global.Player.get_DMG_total(weapon)) / 10.0)
				if damage < 1:
					damage = 1
				inherited_types.append("damage")
				inherited_labels.append("damage")
				msg = get_traits().OrosAppendage.Name
				
				
			if get_traits().has("MardokBeast"):
				var weapon = Global.Player.weapon_main
				damage = int(float(Global.Player.get_DMG_total(weapon)) / 10.0)
				if damage < 1:
					damage = 1
				inherited_types.append("damage")
				inherited_labels.append("damage")
				msg = get_traits().MardokBeast.Name
		
		if msg != "":
					msg = "[color=#707070] <- " + ({"Familiar": "사역마", "Summoned": "소환됨", "Initial": "최초", "Hit": "명중", "공격": "공격", "Being hit": "피격", "enemy Purges you": "적의 정화"}.get(textstrip.strip_bbcode(msg), textstrip.strip_bbcode(msg))) + "[/color]"
					
		
		if inherited_labels != []:
			
			for label in inherited_labels:
				var message_string = get_name_color() + " " + translate.attribute_to_string(label) + " [color=#c04040]inherited[/color] from player..."
				if msg != "":
					message_string += msg
				var action = {
					"name": "add_message", 
					"message": message_string, 
					"color": "[color=#707070]"
				}
				ProcessQueue.add_effect(action)

func add_bonuses():
	
	
	
	if object_type == "ally":
		var action = {}
		var unit = get_node(".")
		
		
		
		var player = Global.Player
		if player != null:
			var player_WIL = player.get_total_WIL()
			var traits = player.get_traits()
			
			
			var multi = float(player.level) * 0.2
			var increase = multi * HP_max
			if increase < 1.0: increase = 1.0
			action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": increase, 
				"type": "life", 
				"msg": "Summoned"
				}
			ProcessQueue.add_effect(action)
				
			increase = multi * float(damage)
			if increase < 1.0: increase = 1.0
			action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": increase, 
				"type": "damage", 
				"msg": "Summoned"
				}
			ProcessQueue.add_effect(action)
			
			
			if get_traits().has("Familiar"):
				multi = float(player_WIL) * 0.1
				
				increase = multi * float(accuracy)
				if increase < 1.0: increase = 1.0
				action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": increase, 
				"type": "accuracy", 
				"msg": "Familiar"
				}
				ProcessQueue.add_effect(action)
				
				increase = multi * float(deflect_strength)
				if increase < 1.0: increase = 1.0
				action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": increase, 
				"type": "block", 
				"msg": "Familiar"
				}
				ProcessQueue.add_effect(action)
				
				increase = multi * float(ARM)
				if increase < 1.0: increase = 1.0
				action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": increase, 
				"type": "armor", 
				"msg": "Familiar"
				}
				ProcessQueue.add_effect(action)
				
				increase = multi * float(dodge)
				if increase < 1.0: increase = 1.0
				action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": increase, 
				"type": "dodge", 
				"msg": "Familiar"
				}
				ProcessQueue.add_effect(action)
				
				increase = multi * float(SPEED)
				if increase < 1.0: increase = 1.0
				action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": increase, 
				"type": "speed", 
				"msg": "Familiar"
				}
				ProcessQueue.add_effect(action)
			
			if traits.has("Beastmaster"):
				if get_name() == "RedDragon2" or get_name() == "Grika2" or get_name() == "Tsuchigumo2":
						multi = Global.Player.level / 5
						if multi < 1: multi = 1
						action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": HP_max * multi, 
				"type": "life", 
				"msg": traits.Beastmaster.Name
				}
						ProcessQueue.add_effect(action)
						
						action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": damage * multi, 
				"type": "damage", 
				"msg": traits.Beastmaster.Name
				}
						ProcessQueue.add_effect(action)
				
			
			if traits.has("PoisonFamiliar"):
				if get_name() == "Tsuchigumo":
					var trait = traits.PoisonFamiliar
					if trait.Level > 1:
						multi = trait.Level - 1
						action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": HP_max * multi, 
				"type": "life", 
				"msg": traits.PoisonFamiliar.Name
				}
						ProcessQueue.add_effect(action)
						
						action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": damage * multi, 
				"type": "damage", 
				"msg": traits.PoisonFamiliar.Name
				}
						ProcessQueue.add_effect(action)
			
			
			if traits.has("SummonRedDragon"):
				if get_name() == "Red Dragon":
					var trait = traits.SummonRedDragon
					if trait.Level > 1:
						multi = trait.Level - 1
						action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": HP_max * multi, 
				"type": "life", 
				"msg": traits.SummonRedDragon.Name
				}
						ProcessQueue.add_effect(action)
						
						action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": damage * multi, 
				"type": "damage", 
				"msg": traits.SummonRedDragon.Name
				}
						ProcessQueue.add_effect(action)
			
			if traits.has("Bloodcalling"):
				if get_name() == "Hemogoblin":
					var trait = traits.Bloodcalling
					if trait.Level > 1:
						multi = trait.Level - 1
						action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": HP_max * multi, 
				"type": "life", 
				"msg": traits.Bloodcalling.Name
				}
						ProcessQueue.add_effect(action)
						
						action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": damage * multi, 
				"type": "damage", 
				"msg": traits.Bloodcalling.Name
				}
						ProcessQueue.add_effect(action)
			
			if traits.has("SummonGrika"):
				if get_name() == "Grika":
					var trait = traits.SummonGrika
					if trait.Level > 1:
						multi = trait.Level - 1
						action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": HP_max * multi, 
				"type": "life", 
				"msg": traits.SummonGrika.Name
				}
						ProcessQueue.add_effect(action)
						
						action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": damage * multi, 
				"type": "damage", 
				"msg": traits.SummonGrika.Name
				}
						ProcessQueue.add_effect(action)
						
			
			
			if traits.has("SnakeCharmer"):
				if type.tags.has("[color=#10df90]Reptile[/color]"):
					action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": 5.0 * player.get_total_DEX(), 
				"type": "damage", 
				"msg": traits.SnakeCharmer.Name
				}
					ProcessQueue.add_effect(action)
				
					action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": 2.0 * player.get_total_DEX(), 
				"type": "speed", 
				"msg": traits.SnakeCharmer.Name
				}
					ProcessQueue.add_effect(action)
			
			if traits.has("Vigorlord"):
				increase = float(Global.Player.HP_max) * 0.1
				
				action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": increase, 
				"type": "life", 
				"msg": traits.Vigorlord.Name
				}
				ProcessQueue.add_effect(action)
			
			
			if traits.has("robe_wind"):
				action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": 5.0, 
				"type": "speed", 
				"msg": traits.robe_wind.Name
				}
				ProcessQueue.add_effect(action)
			
			if traits.has("CommandBracers"):
				action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": 10.0, 
				"type": "damage", 
				"msg": traits.CommandBracers.Name
				}
				ProcessQueue.add_effect(action)
				
			
			if traits.has("Summoner"):
				multi = float(player_WIL) * 0.1
				
				increase = multi * HP_max
				action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": increase, 
				"type": "life", 
				"msg": traits.Summoner.Name
				}
				ProcessQueue.add_effect(action)
				
				increase = multi * 10.0
				action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": increase, 
				"type": "damage", 
				"msg": traits.Summoner.Name
				}
				ProcessQueue.add_effect(action)
			
			if traits.has("Invigoration"):
				var trait = traits.Invigoration
				
				
				action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": 50.0 * trait.Level, 
				"type": "life", 
				"msg": traits.Invigoration.Name
				}
				ProcessQueue.add_effect(action)
				
				
				var armor_increase = 50.0 * trait.Level
				
				action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": armor_increase, 
				"type": "armor", 
				"msg": traits.Invigoration.Name
				}
				ProcessQueue.add_effect(action)
				
				var life_increase = 0.3 * trait.Level * float(HP_max)

				action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": life_increase, 
				"type": "life", 
				"msg": traits.Invigoration.Name
				}
				ProcessQueue.add_effect(action)
				
				action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": 25 * trait.Level, 
				"type": "resist_poison", 
				"msg": traits.Invigoration.Name
				}
				ProcessQueue.add_effect(action)
				
				action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": 25 * trait.Level, 
				"type": "resist_blood", 
				"msg": traits.Invigoration.Name
				}
				ProcessQueue.add_effect(action)
			
			if traits.has("Innervation"):
				var trait = traits.Innervation
			
				
				action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": 3.0 * trait.Level, 
				"msg": traits.Innervation.Name, 
				"type": "speed", 
				}
				ProcessQueue.add_effect(action)
				
				var accuracy_increase = trait.Level * 3.0
				
				action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": accuracy_increase, 
				"type": "accuracy", 
				"msg": traits.Innervation.Name
				}
				ProcessQueue.add_effect(action)
				
				var damage_increase = trait.Level * 5.0
				
				action = {
				"name": "apply_bonus", 
				"origin": unit, 
				"target": unit, 
				"amount": damage_increase, 
				"type": "damage", 
				"msg": traits.Innervation.Name
				}
				ProcessQueue.add_effect(action)
			
			
			
			
			

func apply_bonus(label, increase, msg):
	effectmaker.create_effect_animated(global_position, Global.EffectAnimated, "Power")
	var amount_string = int(increase)
	var inheritance_blocks = false
	if msg == "Familiar" or msg == "Summoned":
		if inherited_types.has(label):
			inheritance_blocks = true
	if inheritance_blocks == false:
		match label:
			"life":
				HP_max += int(increase)
				HP += int(increase)
			"armor":
				ARM += int(increase)
			"accuracy":
				amount_string *= 10
				accuracy += int(increase)
			"damage":
				amount_string *= 10
				damage += int(increase)
			"block":
				deflect_strength += int(increase)
			"defense":
				deflect += int(increase)
			"dodge":
				amount_string *= 10
				dodge += int(increase)
			"speed":
				SPEED += int(increase)
			"resist_poison":
				type.resist_poison += int(increase)
			"resist_blood":
				type.resist_blood += int(increase)
			"resist_slash":
				type.resist_slash += int(increase)
			"resist_pierce":
				type.resist_pierce += int(increase)
			"resist_blunt":
				type.resist_blunt += int(increase)
			"resist_fire":
				type.resist_fire += int(increase)
			"resist_lightning":
				type.resist_lightning += int(increase)
			"resist_ice":
				type.resist_ice += int(increase)
			"resist_psychic":
				type.resist_psychic += int(increase)
			"resist_death":
				type.resist_death += int(increase)
			"resist_astral":
				type.resist_astral += int(increase)
	if translate.attribute_to_string(label) != "":
		var message_string = ""
		if inheritance_blocks == false:
			message_string = get_name_color() + " " + translate.attribute_to_string(label) + " 상승!"
		
		
			

		
		
			if msg != "":
				if ToolSettings.settings_data.log_detail == true and inheritance_blocks == false:
					msg = "[color=#707070] <- " + ({"Familiar": "사역마", "Summoned": "소환됨", "Initial": "최초", "Hit": "명중", "공격": "공격", "Being hit": "피격", "enemy Purges you": "적의 정화"}.get(textstrip.strip_bbcode(msg), textstrip.strip_bbcode(msg))) + " +" + str(int(amount_string)) + "[/color]"
				else:
					msg = "[color=#707070] <- " + ({"Familiar": "사역마", "Summoned": "소환됨", "Initial": "최초", "Hit": "명중", "공격": "공격", "Being hit": "피격", "enemy Purges you": "적의 정화"}.get(textstrip.strip_bbcode(msg), textstrip.strip_bbcode(msg))) + "[/color]"
				message_string += msg
		
			ToolMessageCreator.add_message("[color=#707070]", message_string)
