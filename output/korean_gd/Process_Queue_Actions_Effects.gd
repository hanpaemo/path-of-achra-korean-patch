extends Node


class_name qe

static func check(action):
	
	
	if action.has("msg") == false:
		action["msg"] = ""
	add_message(action)
	level_up(action)
	display_generic(action)
	display_land_intro(action)
	display_intro(action)
	display_item(action)
	create_effect(action)
	attack_extra(action)
	apply_bonus(action)
	apply_bonus_random_ally(action)
	apply_bonus_ally_random_of_tag(action)
	add_buff(action)
	buff_tiles_in_range(action)
	buff_targets_in_range(action)
	remove_random_buff(action)
	remove_buff(action)
	reduce_buff(action)
	teleport(action)
	teleport_random(action)
	heal(action)
	heal_allies_in_range(action)
	heal_allied_targets_in_range(action)
	delayed_damage_tile(action)
	attack_targets_range(action)
	hit_target(action)
	hit_targets_range(action)
	magic_damage_targets_range(action)
	magic_damage_tiles_in_range(action)
	magic_damage_tiles_in_area(action)
	magic_damage_tiles_in_line(action)
	magic_damage_tiles_in_path(action)
	magic_damage_tiles_in_path_to_targets_in_range(action)
	magic_damage_tiles_in_path_to_furthest(action)
	delayed_magic_damage_tiles_in_path_to_targets_in_range(action)
	delayed_magic_damage_tiles_in_range(action)
	delayed_damage_target(action)
	magic_damage_target_closest(action)
	magic_damage_target_furthest(action)
	magic_damage_target(action)
	summon_allies(action)
	summon_ally_random(action)
	change_tileset_in_area(action)
	change_tileset_in_path(action)
	

static func add_message(action):
	if action["name"] == "add_message":
		ToolMessageCreator.add_message(action.color, action.message)

static func level_up(action):
	if action["name"] == "level_up":
		Global.Player.level_up()
		pass

static func display_generic(action):
	if action["name"] == "display_generic":
		Global.game.get_node("UI").spawn_display(action.data, action.type)

static func display_item(action):
	if action["name"] == "display_item":
		Global.game.get_node("UI").spawn_display(action.item, "item")
		Global.inv_glow = true
		
		pass

static func display_intro(action):
	if action["name"] == "display_intro":
		Global.game.get_node("UI").spawn_display(action.unit, "intro")

static func display_land_intro(action):
	if action["name"] == "display_land_intro":
		Global.game.get_node("UI").spawn_display(StateWorld.tileset, "land")

static func create_effect(action):
	if action["name"] == "create_effect":
		effectmaker.create_effect_animated(action.position, Global.EffectAnimated, action.effect_sprite)

static func attack_extra(action):
	if action["name"] == "attack_extra":
		if action["defender"].is_dead() == false and action.attacker.is_dead() == false:
			if ToolCalculateRange.tile_is_in_range_unblocked(action["attacker"].residence, action["defender"].residence, action["tile_range"]) == true:
				action["attacker"].get_node("AnimationPlayer").play("wobble")
				ProcessFight.fight(action["attacker"], action["defender"], action["weapon"], action.msg)


	
		
			

static func apply_bonus(action):
	if action.name == "apply_bonus":
		if action.target.is_dead() == false and action.target != Global.Player:
			event_apply_bonus.apply_bonus(action.origin, action.target, action.type, action.amount, action.msg)
			

static func apply_bonus_random_ally(action):
	var pool = []
	if action.name == "apply_bonus_random_ally":
		for ally in Global.Allies:
			if ally.object_type == "ally":
				pool.append(ally)
	
	if pool.size():
		var target = pool[Global.rng.randi_range(0, pool.size() - 1)]
		event_apply_bonus.apply_bonus(action.origin, target, action.type, action.amount, action.msg)

static func apply_bonus_ally_random_of_tag(action):
	var pool = []
	if action.name == "apply_bonus_ally_random_of_tag":
		for ally in Global.Allies:
			if ally.object_type == "ally":
				if ally.type.tags.has(action.tag):
					pool.append(ally)
	
	if pool.size():
		var target = pool[Global.rng.randi_range(0, pool.size() - 1)]
		event_apply_bonus.apply_bonus(action.origin, target, action.type, action.amount, action.msg)

static func add_buff(action):
	if action["name"] == "add_buff":
		if action["buff"].target.is_dead() == false:
			if action.buff.has("msg") == false:
				action.buff["msg"] = action.msg
			ToolMagicMaker.add_buff(action["buff"])

static func buff_tiles_in_range(action):
	if action["name"] == "buff_tiles_in_range":
		action.buff["msg"] = action.msg
		ToolMagicMaker.buff_tiles_in_range(action.caster, action.effect_sprite, action.effect_range, action.buff, action.alliance)

static func buff_targets_in_range(action):
	if action["name"] == "buff_targets_in_range":
		if action["caster"].is_dead() == false:
			action.buff["msg"] = action.msg
			ToolMagicMaker.buff_targets_range_is_allied(action.caster, action.effect_sprite, action.number_of_targets, action.effect_range, action.buff, action.is_allied)
			

static func remove_random_buff(action):
	if action["name"] == "remove_random_buff":
		var target = action.target
		if action["target"].is_dead() == false:
			var pool = []
			for buff in target.Buffs:
				if action.external == true:
					if buff.source != target:
						pool.append(buff)
				elif buff.source == target:
					pool.append(buff)
			if pool.size():
				var buff = pool[Global.rng.randi_range(0, pool.size() - 1)]
				ToolMagicMaker.remove_buff(target, buff, action.msg)

static func remove_buff(action):
	if action["name"] == "remove_buff":
		if action["target"].is_dead() == false and action["target"].Buffs.has(action["buff"]):
			ToolMagicMaker.remove_buff(action["target"], action["buff"], action.msg)

static func reduce_buff(action):
	if action["name"] == "reduce_buff":
		if action["target"].is_dead() == false and action["target"].Buffs.has(action["buff"]):
			ToolMagicMaker.reduce_buff(action["target"], action["buff"], action["duration"], action.msg)

static func magic_damage_targets_range(action):
	if action["name"] == "magic_damage_targets_range":
		if action["caster"].is_dead() == false:
			ToolMagicMaker.magic_damage_targets_range(action["caster"], action["damage"], action["damage_type"], action["effect_sprite"], action["number_of_targets"], action["effect_range"], action.msg)

static func attack_targets_range(action):
	if action["name"] == "attack_targets":
		if action["attacker"].is_dead() == false:
			ToolMagicMaker.attack_targets(action["attacker"], action["number_of_targets"], action.msg)

static func hit_targets_range(action):
	if action["name"] == "hit_targets_range":
		if action["attacker"].is_dead() == false:
			ToolMagicMaker.hit_targets_range(action["attacker"], action["hit"], action["weapon"], action["number_of_targets"], action["effect_range"], action.msg)


static func hit_target(action):
	if action["name"] == "hit_target":
		if action["attacker"].is_dead() == false and action.defender.is_dead() == false:
			ToolMagicMaker.hit_target(action["attacker"], action.defender, action["hit"], action["weapon"], action.msg)

static func magic_damage_tiles_in_range(action):
	if action["name"] == "magic_damage_tiles_in_range":
		if action["caster"].is_dead() == false:
			ToolMagicMaker.magic_damage_tiles_in_range(action["caster"], action["damage"], action["damage_type"], action["effect_sprite"], action["effect_range"], action.msg)
	
static func magic_damage_tiles_in_area(action):
	if action["name"] == "magic_damage_tiles_in_area":
		if action["caster"].is_dead() == false:
			ToolMagicMaker.magic_damage_tiles_in_area(action["caster"], action["damage"], action["damage_type"], action["effect_sprite"], action["effect_range"], action["target_tile"], action.msg)

static func magic_damage_tiles_in_line(action):
	if action["name"] == "magic_damage_tiles_in_line":
		if action["caster"].is_dead() == false:
			ToolMagicMaker.magic_damage_tiles_in_line(action["target"], action["caster"], action["damage"], action["damage_type"], action["effect_sprite"], action.msg)

static func magic_damage_tiles_in_path(action):
	if action["name"] == "magic_damage_tiles_in_path":
		if action["caster"].is_dead() == false:
			ToolMagicMaker.magic_damage_tiles_in_path(action["target"], action["caster"], action["damage"], action["damage_type"], action["effect_sprite"], action.msg)

static func magic_damage_tiles_in_path_to_targets_in_range(action):
	if action["name"] == "magic_damage_tiles_in_path_to_targets_in_range":
		if action["caster"].is_dead() == false:
			var enemies = ToolMagicMaker.get_enemies(action.caster)
			var targets = ToolMagicMaker.get_number_of_enemy_targets_in_range(action.caster, enemies, action.number_of_targets, action.effect_range)
			for target in targets:
				ToolMagicMaker.magic_damage_tiles_in_path(target, action["caster"], action["damage"], action["damage_type"], action["effect_sprite"], action.msg)

static func magic_damage_tiles_in_path_to_furthest(action):
	if action["name"] == "magic_damage_tiles_in_path_to_furthest":
		if action["caster"].is_dead() == false:
			ToolMagicMaker.magic_damage_tiles_in_path_to_furthest(action["caster"], action["damage"], action["damage_type"], action["effect_sprite"], action.msg)


static func delayed_magic_damage_tiles_in_range(action):
	if action["name"] == "delayed_magic_damage_tiles_in_range":
		if action["caster"].is_dead() == false:
			ToolMagicMaker.delayed_magic_damage_tiles_in_range(action.caster, action.damage, action.damage_type, action.effect_sprite, action.effect_range, 1, action.msg)

static func delayed_magic_damage_tiles_in_path_to_targets_in_range(action):
	if action["name"] == "delayed_magic_damage_tiles_in_path_to_targets_in_range":
		if action["caster"].is_dead() == false:
			var enemies = ToolMagicMaker.get_enemies(action.caster)
			var targets = ToolMagicMaker.get_number_of_enemy_targets_in_range(action.caster, enemies, action.number_of_targets, action.effect_range)
			for target in targets:
				ToolMagicMaker.delayed_magic_damage_tiles_in_path(target, action.caster, action.damage, action.damage_type, action.effect_sprite, 1, action.msg)

static func delayed_damage_target(action):
	if action["name"] == "delayed_damage_target":
		if action["target"].is_dead() == false:
			ToolMagicMaker.delayed_damage_target(action.target, action.caster, action.damage, action.damage_type, action.effect_sprite, 1, action.msg)

static func magic_damage_target(action):
	if action["name"] == "magic_damage_target":
		if action["target"].is_dead() == false:
			ToolMagicMaker.damage_target(action["target"], action["caster"], action["damage"], action["damage_type"], action["effect_sprite"], action.msg)

static func magic_damage_target_closest(action):
	if action["name"] == "magic_damage_target_closest":
		if action["caster"].is_dead() == false:
			ToolMagicMaker.damage_target_closest(action["caster"], action["damage"], action["damage_type"], action["effect_sprite"], action.msg)

static func magic_damage_target_furthest(action):
	if action["name"] == "magic_damage_target_furthest":
		if action["caster"].is_dead() == false:
			ToolMagicMaker.damage_target_furthest(action["caster"], action["damage"], action["damage_type"], action["effect_sprite"], action.msg)

static func summon_allies(action):
	if action["name"] == "summon":
		if action["summoner"].is_dead() == false:
			var type = cloner.clone_dict(action["type"])
			event_summon.check(action["alliance"], type, calcrange.get_closest_tile(action["summoner"].residence, calcrange.get_open_tiles()), action["summoner"], action.msg)

static func summon_ally_random(action):
	if action.name == "summon_random":
		if action.summoner.is_dead() == false:
			var type = cloner.clone_dict(action["type"])
			event_summon.check(action.alliance, type, calcrange.get_random_open_tile(), action.summoner, action.msg)

static func heal(action):
	if action["name"] == "heal":
		if action["healed_unit"].is_dead() == false and action["healer_unit"].is_dead() == false:
			event_heal.check(action["amount"], action["healer_unit"], action["healed_unit"], action.msg)

static func heal_allies_in_range(action):
	if action["name"] == "heal_allies_in_range":
		if action["caster"].is_dead() == false:
			ToolMagicMaker.heal_allies_in_range(action.caster, action.amount, action.effect_range, action.msg)
		

static func heal_allied_targets_in_range(action):
	if action["name"] == "heal_allied_targets_in_range":
		if action["caster"].is_dead() == false:
			ToolMagicMaker.heal_targets_range_is_allied(action.caster, action.amount, action.number_of_targets, action.effect_range, true, action.msg)
			
static func teleport(action):
	if action["name"] == "teleport":
		if action["unit"].is_dead() == false:
			if action["tile_target"] != null:
				ToolMagicMaker.teleport(action["unit"], action["tile_target"], action.msg)
			

static func teleport_random(action):
	if action["name"] == "teleport_random":
		if action["unit"].is_dead() == false:
			ToolMagicMaker.teleport_random(action["unit"], action.msg)
			

static func change_tileset_in_area(action):
	if action["name"] == "change_tileset_in_area":
		ToolMagicMaker.change_tileset_in_area(action["tile_target"], action["tileset"], action["effect_range"], action["effect_sprite"])

static func change_tileset_in_path(action):
	if action["name"] == "change_tileset_in_path":
		ToolMagicMaker.change_tileset_in_path(action["tile_start"], action["tile_end"], action["tileset"], action["effect_sprite"])

static func delayed_damage_tile(action):
	if action.name == "delayed_damage_tile":
		ToolMagicMaker.delayed_damage_tile(action.caster, action.damage, action.damage_type, action.effect_sprite, action.target_tile, action.delayed_node, action.msg)



	
static func clean(queue):
	var to_delete = []
	
	for action in queue:
		to_delete.append(action)

	var impending_teleport = false

	for action in queue:
	
		
		
	
	
		if ToolSettings.settings_data.short_animation == true:
			if action["name"] == "apply_bonus":
				check(action)
				to_delete.erase(action)
		
			if action["name"] == "create_effect":
				if action.tile != null:
					if action.tile.resident == null:
						to_delete.erase(action)
					else:
						check(action)
						to_delete.erase(action)
			
		if action["name"] == "magic_damage_target":
			if translate.check_immune(action.target, action.target.get_traits(), action.caster, action.caster.get_traits()) == true:
				to_delete.erase(action)

		if action["name"] == "teleport":
			if action.tile_target == null:
				to_delete.erase(action)
			else:
				impending_teleport = true
		
		if action["name"] == "create_effect":
			if action["effect_sprite"] == "none":
				to_delete.erase(action)
		
		if action["name"] == "delayed_damage_tile":
			if action.target_tile.resident != null:
				if action.target_tile.resident == action.caster:
					action.delayed_node.remove()
					to_delete.erase(action)
		
		
		
		if action["name"] == "attack_extra":
			if action.defender.is_dead() == true:
				to_delete.erase(action)
		
		if action["name"] == "attack_targets":
			if impending_teleport == false:
				if calcrange.is_adjacent_enemy(action["attacker"], ToolMagicMaker.get_enemies(action["attacker"])) == false:
					to_delete.erase(action)
		
		if action["name"] == "hit_target_range":
			if impending_teleport == false:
				if ToolMagicMaker.get_number_of_enemy_targets_in_range(action["attacker"], ToolMagicMaker.get_enemies(action["attacker"]), action.number_of_targets, action.effect_range) < 1:
					to_delete.erase(action)

		if action["name"] == "magic_damage_target":
			if action.target.is_dead() == true:
				to_delete.erase(action)
		
		if action["name"] == "hit_target":
			if action.defender.is_dead() == true:
				to_delete.erase(action)


		if action["name"] == "add_buff":
			if action.buff.target.is_dead() == true:
				to_delete.erase(action)
		
		if action["name"] == "add_buff":
			if action.buff.name == "Protection":
				if action.buff.target.is_dead() == false:
					if action.buff.target.get_buff_names().has("Protection"):
						to_delete.erase(action)
			
		if action["name"] == "remove_buff":
			if action.target.is_dead() == true:
				to_delete.erase(action)
		
		if action["name"] == "reduce_buff":
			if action.target.is_dead() == true:
				to_delete.erase(action)
		
		if action["name"] == "level_up":
			if Global.Player == null:
				to_delete.erase(action)
			elif Global.Player.is_dead() == true:
				to_delete.erase(action)
			pass
		
		if action["name"] == "heal":
			if action.healed_unit.HP >= action.healed_unit.HP_max:
				to_delete.erase(action)
			if action.healed_unit.HP < 1.0:
				to_delete.erase(action)
	
		if Global.game != null:
			if Global.game.floor_cleared == true:
					if action["name"] == "summon":
						to_delete.erase(action)
						ToolMessageCreator.add_message("[color=#707070]", "소환 실패, 적이 섬멸됨...")
				
					if action["name"] == "summon_random":
						to_delete.erase(action)
						ToolMessageCreator.add_message("[color=#707070]", "소환 실패, 적이 섬멸됨...")
		
						
	
	queue = to_delete
	return queue

static func message_check(action):
	var stringa = ""
	if action.has("msg"):
		stringa += action.msg
	return stringa
