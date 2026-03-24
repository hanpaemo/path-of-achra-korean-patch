extends Node



func add_attack(attacker, tile_start, tile_end, tile_range, defender, _weapon, msg):
	var action2 = {
		"name": "attack_extra"
		, "attacker": attacker
		, "defender": defender
		, "weapon": attacker.weapon_main
		, "tile_start": tile_start
		, "tile_end": tile_end
		, "tile_range": tile_range, 
		"msg": msg
	}
	ProcessQueue.add_effect(action2)

func add_ANYHAND_attack(attacker, tile_start, tile_end, tile_range, defender, weapon, msg):
	var action2 = {
		"name": "attack_extra"
		, "attacker": attacker
		, "defender": defender
		, "weapon": weapon
		, "tile_start": tile_start
		, "tile_end": tile_end
		, "tile_range": tile_range, 
		"msg": msg
	}
	ProcessQueue.add_effect(action2)


func magic_damage_targets_range(caster, damage, damage_type, effect_sprite, number_of_targets, effect_range, msg):
	var targets = get_number_of_enemy_targets_in_range(caster, get_enemies(caster), number_of_targets, effect_range)
	for target in targets:
		
		add_damage_event(target, caster, damage, damage_type, effect_sprite, msg)
		


func attack_targets(attacker, number_of_targets, msg):
	var targets = get_number_of_enemy_targets_in_range(attacker, get_enemies(attacker), number_of_targets, 1)
	for target in targets:
		add_attack(attacker, attacker.residence, target.residence, attacker.get_range_attack(attacker.weapon_main), target, attacker.weapon_main, msg)

func hit_targets_range(attacker, hit, weapon, number_of_targets, effect_range, msg):
	var targets = get_number_of_enemy_targets_in_range(attacker, get_enemies(attacker), number_of_targets, effect_range)
	for target in targets:
		
		add_hit_event(target, attacker, hit, weapon, msg)



func magic_damage_tiles_in_range(caster, damage, damage_type, effect_sprite, effect_range, msg):
	var area_effect = calcrange.get_tiles_in_range(caster.residence, effect_range)
	
	for tile in area_effect:
		if tile.resident != null:
			if tile.resident != caster:
				var target = tile.resident
				add_damage_event(target, caster, damage, damage_type, effect_sprite, msg)
				
		
		add_effect_event(tile.global_position, effect_sprite, tile)
				
	
		

func delayed_damage_tile(caster, damage, damage_type, effect_sprite, target_tile, delayed_node, msg):
	if target_tile.resident != null:
		var target = target_tile.resident
		add_damage_event(target, caster, damage, damage_type, effect_sprite, msg)
	add_effect_event(target_tile.global_position, effect_sprite, target_tile)
	delayed_node.remove()
		


func buff_tiles_in_range(caster, effect_sprite, effect_range, buff, alliance):
	var area_effect = calcrange.get_tiles_in_range(caster.residence, effect_range)
	var targets = []
	for tile in area_effect:
		
		if tile.resident != null:
			if tile.resident != caster:
				if alliance.has(tile.resident) == true:
					targets.append(tile.resident)
	for target in targets:
		if effect_sprite != null:
			effectmaker.create_effect_animated(target.residence.global_position, Global.EffectAnimated, effect_sprite)
		var buffclone = cloner.clone_dict(buff)
		buffclone["target"] = target
		add_buff_event(buffclone)
		


func buff_targets_range_is_allied(caster, effect_sprite, number_of_targets, effect_range, buff, is_allied):
	var targets = get_number_of_targets_in_range_is_allied(caster, is_allied, number_of_targets, effect_range)
	for target in targets:
		if effect_sprite != null:
			effectmaker.create_effect_animated(target.residence.global_position, Global.EffectAnimated, effect_sprite)
		var buffclone = cloner.clone_dict(buff)
		buffclone["target"] = target
		add_buff_event(buffclone)
		


func magic_damage_tiles_in_area(caster, damage, damage_type, effect_sprite, effect_range, tile_target, msg):
	var area_effect = calcrange.get_all_tiles_in_range(tile_target, effect_range)
	
	for tile in area_effect:
		if tile.resident != null:
			var target = tile.resident
			add_damage_event(target, caster, damage, damage_type, effect_sprite, msg)
		
		add_effect_event(tile.global_position, effect_sprite, tile)
			
	
		
		

func magic_damage_tiles_in_line(target, caster, damage, damage_type, effect_sprite, msg):
	var area_effect = calcrange.get_tiles_in_line(caster.residence, target.residence)
	area_effect.invert()
	
	for tile in area_effect:
		if tile.resident != null:
			target = tile.resident
			add_damage_event(target, caster, damage, damage_type, effect_sprite, msg)
		
		add_effect_event(tile.global_position, effect_sprite, tile)
			
	
		
		

func magic_damage_tiles_in_path(target, caster, damage, damage_type, effect_sprite, msg):
	var area_effect = calcrange.get_tiles_in_ground_path_to_target(caster.residence, target.residence)
	area_effect.invert()
	
	for tile in area_effect:
		if tile.resident != null:
			target = tile.resident
			add_damage_event(target, caster, damage, damage_type, effect_sprite, msg)
		if tile.type != Global.Tile_Type.WALL:
			add_effect_event(tile.global_position, effect_sprite, tile)

func magic_damage_tiles_in_path_to_furthest(caster, damage, damage_type, effect_sprite, msg):
	var target = null
	target = get_furthest_enemy(caster, get_enemies(caster))
	if target != null:
		magic_damage_tiles_in_path(target, caster, damage, damage_type, effect_sprite, msg)
		


func delayed_magic_damage_tiles_in_range(caster, damage, damage_type, effect_sprite, effect_range, duration, msg):
	var area_effect = calcrange.get_tiles_in_range(caster.residence, effect_range)
	
	print("DELAYED DAMAGE IN TILES RANGE")
	for tile in area_effect:
			if tile.resident != caster:
				
				create_delayed_damage_effect(caster, tile, damage, damage_type, effect_sprite, duration, msg)
		
		

func delayed_magic_damage_tiles_in_path(target, caster, damage, damage_type, effect_sprite, duration, msg):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var area_effect = calcrange.get_tiles_in_ground_path_to_target(caster.residence, target.residence)
	area_effect.invert()
	
	var area_effect2 = calcrange.get_all_tiles_in_range(target.residence, 2)
	for tile in area_effect2:
		if area_effect.has(tile) == false:
			area_effect.append(tile)
	
	var to_erase = []
	for tile in area_effect:
		if rng.randi_range(1, 6) >= 2:
			to_erase.append(tile)
	
	for tile in to_erase:
		area_effect.erase(tile)
	
	for tile in area_effect:
		create_delayed_damage_effect(caster, tile, damage, damage_type, effect_sprite, duration, msg)
			

func delayed_damage_target(target, caster, damage, damage_type, effect_sprite, duration, msg):
	var tile = target.residence
	print("DELAYED DAMAGE ON TILE")
	create_delayed_damage_effect(caster, tile, damage, damage_type, effect_sprite, duration, msg)


func damage_target(target, caster, damage, damage_type, effect_sprite, msg):
	
	
	var damage_types = ["slash", "pierce", "blunt", "fire", "lightning", "ice", "astral", "poison", "death", "blood", "psychic"]
	if caster.get_traits().has("Imp"):
			damage_type = damage_types[Global.rng.randi_range(0, damage_types.size() - 1)]
			effect_sprite = translate.dmgtype_to_animation(damage_type)
	
	
	if translate.check_immune(target, target.get_traits(), caster, caster.get_traits()) == false:
		effectmaker.create_effect_animated(target.global_position, Global.EffectAnimated, effect_sprite)

	event_all.on_damage(damage, damage_type, caster, target, msg)



func damage_target_closest(caster, damage, damage_type, effect_sprite, msg):
	var target = null
	target = get_closest_enemy(caster, get_enemies(caster))
	if target != null:
		
		
		var damage_types = ["slash", "pierce", "blunt", "fire", "lightning", "ice", "astral", "poison", "death", "blood", "psychic"]
		if caster.get_traits().has("Imp"):
			
			damage_type = damage_types[Global.rng.randi_range(0, damage_types.size() - 1)]
			effect_sprite = translate.dmgtype_to_animation(damage_type)
		
		
		if translate.check_immune(target, target.get_traits(), caster, caster.get_traits()) == false:
			effectmaker.create_effect_animated(target.global_position, Global.EffectAnimated, effect_sprite)
		event_all.on_damage(damage, damage_type, caster, target, msg)

func damage_target_furthest(caster, damage, damage_type, effect_sprite, msg):
	var target = null
	target = get_furthest_enemy(caster, get_enemies(caster))
	if target != null:
		
		
		var damage_types = ["slash", "pierce", "blunt", "fire", "lightning", "ice", "astral", "poison", "death", "blood", "psychic"]
		if caster.get_traits().has("Imp"):
			
			damage_type = damage_types[Global.rng.randi_range(0, damage_types.size() - 1)]
			effect_sprite = translate.dmgtype_to_animation(damage_type)
		
		if translate.check_immune(target, target.get_traits(), caster, caster.get_traits()) == false:
			
			
			effectmaker.create_effect_animated(target.global_position, Global.EffectAnimated, effect_sprite)
		event_all.on_damage(damage, damage_type, caster, target, msg)

func hit_target(attacker, defender, hit, _weapon, msg):
	

	event_all.on_hit(attacker, defender, attacker.weapon_main, hit, msg)

func change_tileset_in_area(tile_target, tileset, effect_range, effect_sprite):
	var area_effect = calcrange.get_all_tiles_in_range(tile_target, effect_range)
	var tileset_data = loader.load_data("res://Data/Table_Tilesets.json")
	for tile in area_effect:
		add_effect_event(tile.global_position, effect_sprite, tile)
		
		tile.tileset = tileset_data[tileset]
		tile.flash_tween()
		tile.update_type()

func change_tileset_in_path(tile_start, tile_end, tileset, effect_sprite):
	var area_effect = calcrange.get_tiles_in_walkable_path_to_target(tile_start, tile_end)
	var tileset_data = loader.load_data("res://Data/Table_Tilesets.json")
	for tile in area_effect:
		add_effect_event(tile.global_position, effect_sprite, tile)
		
		tile.tileset = tileset_data[tileset]
		tile.flash_tween()
		tile.update_type()

func teleport(unit, tile_target, msg):
	if tile_target.resident == null:
		event_teleport.check(unit, tile_target, msg)
	else:
		tile_target = calcrange.get_closest_tile(tile_target, calcrange.get_open_tiles())
		event_teleport.check(unit, tile_target, msg)
	
func teleport_random(unit, msg):
	var tile_target = calcrange.get_random_open_tile()
	event_teleport.check(unit, tile_target, msg)

	

func add_buff(buff):
	event_apply_buff.check(buff)

func remove_buff(unit, buff, msg):
	event_remove_buff.check(unit, buff, msg)

func reduce_buff(unit, buff, duration, msg):
	
		
		
			
				if msg != "":
					msg = "[color=#707070] <- " + msg + "[/color]"
				
				if duration > 0 and unit == Global.Player:
					ToolMessageCreator.add_message("[color=#c0c0c0]", buff.color + buff.name + "[/color](이)가 " + "감소: " + str(duration) + msg)
				elif duration <= - 1:
					ToolMessageCreator.add_message("[color=#c0c0c0]", buff.color + buff.name + "[/color](이)가 " + "증가: " + str(duration * - 1) + msg)
				
				buff.duration -= duration
				
				if buff.duration < 1:
					event_remove_buff.check(unit, buff, msg)
				if unit == Global.Player:
					Global.game.get_node("UI").get_node("UI_BuffDrawer").write_buffs()
				
				
					
	
func heal_allies_in_range(caster, amount, effect_range, msg):
	var area_effect = calcrange.get_tiles_in_range(caster.residence, effect_range)
	var targets = []
	var enemies = get_enemies(caster)
	
	for tile in area_effect:
		
		if tile.resident != null:
			if enemies.has(tile.resident) == false:
				if tile.resident != caster:
					targets.append(tile.resident)
	for target in targets:
		add_heal_event(amount, caster, target, msg)
		

func heal_targets_range_is_allied(caster, amount, number_of_targets, effect_range, is_allied, msg):
	var targets = get_number_of_targets_in_range_is_allied(caster, is_allied, number_of_targets, effect_range)
	for target in targets:
		
		add_heal_event(amount, caster, target, msg)


func create_delayed_damage_effect(source, target_tile, damage, damage_type, effect_sprite, duration, msg):
	
	var d = Global.DelayedEvent.instance()
	var action = {
		"name": "delayed_damage_tile", 
		"caster": source, 
		"damage": damage, 
		"damage_type": damage_type, 
		"effect_sprite": effect_sprite, 
		"target_tile": target_tile, 
		"delayed_node": d, 
		"msg": msg
		
	}
	
	Global.game.add_child(d)
	d.event = action
	d.source = source
	d.position = target_tile.global_position

	d.duration = duration

func add_effect_event(position, effect_sprite, tile):
	if effect_sprite != "none":
		var action = {
		"name": "create_effect", 
		"tile": tile, 
		"position": position, 
		"effect_sprite": effect_sprite
				}
		ProcessQueue.add_effect(action)

func add_damage_event(target, caster, damage, damage_type, effect_sprite, msg):
	var action = {
		"name": "magic_damage_target", 
		"target": target, 
		"caster": caster, 
		"damage": damage, 
		"damage_type": damage_type, 
		"effect_sprite": effect_sprite, 
		"msg": msg
				}
	ProcessQueue.add_effect(action)

func add_buff_event(buff):
	var action = {
			"name": "add_buff", 
			"buff": buff
			}
	ProcessQueue.add_effect(action)

func add_hit_event(defender, attacker, hit, weapon, msg):
	var action = {
		"name": "hit_target", 
		"defender": defender, 
		"attacker": attacker, 
		"hit": hit, 
		"weapon": weapon, 
		"msg": msg
				}
	ProcessQueue.add_effect(action)

func add_heal_event(amount, healer_unit, healed_unit, msg):
	var action = {
		"name": "heal", 
		"amount": amount, 
		"healer_unit": healer_unit, 
		"healed_unit": healed_unit, 
		"msg": msg
				}
	ProcessQueue.add_effect(action)

func text_damage(target, damage):
	var apoint = target.get_global_position()
	var atext = "-" + str(damage)
	var color = "[color=#ff00ff]"
	ProcessText.spawn_text_popup(apoint, atext, color)


func get_number_of_enemy_targets_in_range(caster, enemies, number_of_targets, effect_range):
	var targets = []
	
	var list = []
	for unit in enemies:
		if calcrange.tile_is_in_range(caster.residence, unit.residence, effect_range) == true:
			list.append(unit)
	list.shuffle()
	if number_of_targets > list.size():
		number_of_targets = list.size()
	
	for n in number_of_targets:
		targets.append(list[n - 1])
	
	return targets

func get_number_of_targets_in_range_is_allied(caster, is_allied, number_of_targets, effect_range):
	var targets = []
	
	var list = []
	for unit in get_targets_of_alliance(caster, is_allied):
		if calcrange.tile_is_in_range(caster.residence, unit.residence, effect_range) == true:
			list.append(unit)
	list.shuffle()
	if number_of_targets > list.size():
		number_of_targets = list.size()
	
	for n in number_of_targets:
		targets.append(list[n - 1])
		
	return targets
	
func get_enemies(caster):
	var enemies = []
	if caster.object_type == "enemy":
		for n in Global.Allies.size():
			enemies.append(Global.Allies[n])
	if caster.object_type == "player":
		for n in Global.Enemies.size():
			enemies.append(Global.Enemies[n])
	if caster.object_type == "ally":
		for n in Global.Enemies.size():
			enemies.append(Global.Enemies[n])
	return enemies

func get_targets_of_alliance(unit, is_allied):
	var targets = []
	var global_array = []
	match unit.object_type:
		"enemy":
			match is_allied:
				false:
					global_array = Global.Allies
				true:
					global_array = Global.Enemies
		"ally":
			match is_allied:
				false:
					global_array = Global.Enemies
				true:
					global_array = Global.Allies
		"player":
			match is_allied:
				false:
					global_array = Global.Enemies
				true:
					global_array = Global.Allies
	for unit in global_array:
		targets.append(unit)
	if targets.has(unit):
		targets.erase(unit)
	return targets

func get_closest_enemy(actor, enemy_array):
	var target_attack = null
	var tile_list = []
	for enemy in enemy_array:
		tile_list.append(enemy.residence)
	if tile_list.size() > 0:
		target_attack = calcrange.get_closest_tile(actor.residence, tile_list).resident
	return target_attack

func get_furthest_enemy(actor, enemy_array):
	var target_attack = null
	var tile_list = []
	for enemy in enemy_array:
		tile_list.append(enemy.residence)
	if tile_list.size() > 0:
		target_attack = calcrange.get_furthest_tile(actor.residence, tile_list).resident
	return target_attack

func erase_targets(targets, erase_targets):
	for n in erase_targets.size():
		if targets.has(erase_targets[n]):
			targets.erase(erase_targets[n])
	return targets

func message_damage(caster, target, damage, damage_type):
	var txcolor = "[color=#af30af]"
	var name_a = caster.get_name()
	var name_d = target.get_name()
	var damage_text = "피해"
	if damage_type == "fire":
		damage_text = "화상"
	if caster == Global.Player:
		txcolor = "[color=#ff00ff]"
		name_a = ""
		ToolMessageCreator.add_message(txcolor, name_d + "에게 " + damage_text + " (" + str(int(damage)) + ").")
	elif target == Global.Player:
		txcolor = "[color=#af30af]"
		name_d = "당신"
		ToolMessageCreator.add_message(txcolor, name_a + "(이)가 " + name_d + "에게 " + damage_text + " (" + str(int(damage)) + ").")
	else:
		ToolMessageCreator.add_message(txcolor, name_a + "(이)가 " + name_d + "에게 " + damage_text + " (" + str(int(damage)) + ").")
