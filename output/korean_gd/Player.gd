extends Node2D

var object_type = "player"
var residence = null
var game = null
var ui_inventory = null
var ui = null
var ui_invokes = null
var has_died = false
var is_stationary = false
var target_enemy = null
var targets = []
var player_turn = 0

var POINTS = StatePlayerSheet.POINTS
var POINTS_TRAITS = StatePlayerSheet.POINTS_TRAITS
var TRAITS_UNLOCKED = StatePlayerSheet.TRAITS_UNLOCKED
var ELEMENTS = StatePlayerSheet.ELEMENTS
var HP = StatePlayerSheet.HP
var HP_max = StatePlayerSheet.HP_max
var STR = StatePlayerSheet.STR
var DEX = StatePlayerSheet.DEX
var WIL = StatePlayerSheet.WIL
var SPEED = StatePlayerSheet.SPEED

var xp = StatePlayerSheet.xp
var xp_needed = StatePlayerSheet.xp_needed
var level = StatePlayerSheet.level

var title_name = StatePlayerSheet.title_name
var title_class = StatePlayerSheet.title_class
var title_race = StatePlayerSheet.title_race

var abilities = StatePlayerSheet.abilities
var invokes = StatePlayerSheet.invokes


var ACC = 0.0
var DMG = 0.0
var DEF = 0.0

var RACE = StatePlayerSheet.RACE
var god = StatePlayerSheet.God

var ARM = 0.0
var range_move = 1
var range_sight = 6
var range_attack = 1

var Buffs = []
var Effects = []
var bag = StatePlayerSheet.bag
var weapon_main = StatePlayerSheet.weapon_main
var weapon_off = StatePlayerSheet.weapon_off
var armor_head = StatePlayerSheet.armor_head
var armor_chest = StatePlayerSheet.armor_chest
var armor_hands = StatePlayerSheet.armor_hands
var armor_legs = StatePlayerSheet.armor_legs

var inherited_types = []

var equipment = []

var hands_used = 1




var really_dead = false

var event_killer = null
var event_killing_damg_type = "none"
var traits_duplicate = {}

var taunt = "어찌 이럴 수가?"
var spritescreen = StatePlayerSheet.sprite_skin

var sprite_corpse = "CorpseRed"

var tick = 100.0

var trait_memory = {}

var interventions = 0

var autoing = false

func _ready():
	
	
	if StatePlayerSheet.score_data.has("feats") == false:
		StatePlayerSheet.score_data["feats"] = []
	
	add_score_element("game_turns")
	
	add_score_element("damage_dealt")
	add_score_element("highest_damage")
	add_score_element("highest_damage_type")
	
	add_score_element("enemies_killed")
	add_score_element("enemies_killed_by_allies")
	
	add_score_element("allies_summoned")
	add_score_element("allies_killed")
	
	
	add_score_element("damage_taken")
	add_score_element("amount_healed")
	
	add_score_element("times_attack")
	add_score_element("times_pray")
	add_score_element("times_stood")
	add_score_element("times_intervention")
	
	add_score_element("highest_stack_effect")
	add_score_element_label("highest_stack_effect_label")
	add_score_element("forbidden_places_entered")
	add_score_element("towers_entered")
	
	if StatePlayerSheet.score_data.has("enemies") == false:
		StatePlayerSheet.score_data["enemies"] = []
	if StatePlayerSheet.score_data.has("allies") == false:
		StatePlayerSheet.score_data["allies"] = []
	
func _process(_delta):
	if target_enemy == null:
		$targeter.visible = false
		
	else:
		
		$targeter.visible = true
		$targeter.global_position = target_enemy.global_position

	
func add_score_element(label):
	if StatePlayerSheet.score_data.has(label) == false:
		StatePlayerSheet.score_data[label] = 0

func add_score_element_label(label):
	if StatePlayerSheet.score_data.has(label) == false:
		StatePlayerSheet.score_data[label] = ""

func initiate():
	$Sprites / Body.texture = load(StatePlayerSheet.sprite_skin)
	game = ProcessQueue.game

	ui = game.get_node("UI")
	ui_invokes = ui.get_node("Invokes")
	ToolPlayerController.player = get_node(".")
	Global.Player = get_node(".")
	Global.Allies.append(get_node("."))
	ProcessFight.Player = get_node(".")
	ProcessQueue.Player = get_node(".")
	ProcessText.Player = get_node(".")
	ProcessQueue.initiate_action_timer(SPEED)
	
	check_inv_glow()
	
	
	update_traits()
	square_traits()
	update()
	event_enter_level.check(get_node("."), residence)
	

func update():
	
	
	update_traits()
	ProcessQueue.update_action_timer(SPEED)
	update_equipment()
	ui.update()
	var weapon = weapon_main
	ACC = get_ACC(weapon)
	DMG = get_DMG(weapon)
	DEF = get_DEF()
	range_attack = get_range_attack(weapon)
	ARM = get_ARM()
	
	hands_used = get_hands_used()
	if StateWorld.Floor_Current == 0:
		pass
		
	
		
	
		
	for key in abilities:
		if TRAITS_UNLOCKED.has(key) == false:
			TRAITS_UNLOCKED.append(key)
	
	
	buffcheck.just_erase(self)
	
	update_damage()
	if has_died == false:
		update_targeted(false)
		
func update_equipment():
	var to_erase = []
	for item in bag:
		if item == null:
			to_erase.append(item)
	for item in to_erase:
		bag.erase(item)
	update_sprites()

func update_damage():
	draw_life()
	if HP <= 0 and has_died == false:
		if check_intervention() == false:
			has_died = true
			$Lifebar.modulate = Color(1, 1, 1, 0)
			die()
		else:
			var HP_new = int(0.25 * float(HP_max))
			if get_traits().has("Apophis"):
				HP_new = int(0.5 * float(HP_max))
			
				
			HP = HP_new

func check_intervention():
	var has_intervened = false
	var dict = invokes
	var invokes_available = []
	for key in dict:
		var invoke = dict[key]
		
		if invoke.use >= invoke.use_max and invoke.level_required <= level:
			invokes_available.append(invoke)
			has_intervened = true
	
	if get_traits().has("Ogham"):
		has_intervened = false
	
	if has_intervened == true:
		invokes_available.shuffle()
		var invoke = invokes_available[invokes_available.size() - 1]
		
		ToolMessageCreator.add_message("[color=#ff0000]", "[color=#78bca4]신의 개입[/color]! " + god.name + "(이)가 생명을 보존!..." + invoke.name + "[color=#ff5050] -" + str(int(invoke.use)) + " charges[/color]")
		invoke.use = 0
		for n in 10:
			effectmaker.create_effect_animated_spread(self.global_position, Global.EffectAnimated, god.title)
		event_intervention.check(self)
	
	
	return has_intervened
	pass

func draw_life():
	if HP == HP_max:
		$ColorRect.modulate = Color(0, 0, 0, 0)
		$Lifebar.modulate = Color(0, 0, 0, 0)
	if HP < HP_max:
		$ColorRect.modulate = Color(1, 1, 1, 1)
		$Lifebar.modulate = Color(1, 1, 1, 1)
		$Lifebar.rect_scale.x = hp_percent()
	if HP <= 0:
		$Lifebar.modulate = Color(0, 0, 0, 0)

func gain_xp(amount):
	if amount > 0:
		amount = cycler.glory_bonus(amount)
		if Global.testmode == true:
			amount *= 50
		xp += amount
		check_level()

func check_level():
	if xp >= xp_needed:
		xp -= xp_needed
		level += 1
		xp_needed += 10
		
		game.get_node("UI").update_invokes()
		
		var action = {
				"name": "level_up", 
				"unit": get_node(".")
			}
		ProcessQueue.add_effect(action)
		ProcessQueue.ACTIVE = true
		
		
		

func level_up():
	ToolInvokes.recharge("glory")
	POINTS_TRAITS += 1
	var txcolor = "[color=#ffff00]"
	ToolMessageCreator.add_message(txcolor, "찬양하라 " + Global.Player.god.name + "! 영광이 오른다!")
	effectmaker.create_effect_animated(Global.Player.global_position, Global.EffectAnimated, Global.Player.god.title)
	
	
	var list = ["[center][color=#808080]없음[/color]", 
	"[center][color=#ff7050]힘[/color]", 
	"[center][color=#50ff70]민첩[/color]", 
	"[center][color=#c050ff]의지[/color]", 
	"[center][color=#ff8080]활력[/color]", 
	"[center][color=#ff2090]무작위[/color]"]
		
	match list[ToolSettings.settings_data.auto_level]:
			"[center][color=#808080]없음[/color]":
				
				ProcessQueue.PAUSED = true
				var effect = Global.EffectScreen.instance()
				game.get_node("PauseLayer").add_child(effect)
			
			"[center][color=#ff7050]힘[/color]":
				level_up.strength()
			"[center][color=#50ff70]민첩[/color]":
				level_up.dexterity()
			"[center][color=#c050ff]의지[/color]":
				level_up.willpower()
			"[center][color=#ff8080]활력[/color]":
				level_up.vigor()
			"[center][color=#ff2090]무작위[/color]":
				level_up.random()
	
	event_levelup.check(self)
	update()
	check_level()

func die():
	print("PLAYER DETECTS DEATH")
	$Lifebar.modulate = Color(1, 1, 1, 0)
	really_dead = true
	event_all.on_death(get_node("."), event_killer)

func death_popup(type):
	if game.game_over == false:
		
		$Lifebar.modulate = Color(1, 1, 1, 0)
		game.game_over = true
		Global.Allies.erase(get_node("."))
		
		var glory_added = level
		if level > 15:
			glory_added = level * 2
			
		if StateWorld.land == "dust":
			if StateWorld.Floor_Current < 6:
				glory_added = 1
			else:
				glory_added = int(Global.Player.level / 2)
				if glory_added < 1: glory_added = 1
		
		ToolSettings.settings_data.glory_added += glory_added
		ToolSettings.save_settings()
		if StateWorld.land != "dust":
			saveload.saveload(saveload.create_empty_file())
		
		if type == "death":
			
			visible = false
			ui.get_node("DeathScreen").play_screen(event_killer, "death")
		
		if type == "victory":
			ui.get_node("DeathScreen").play_screen(null, "victory")
		
		
		
		

func is_dead():
	var is_dead = false
	if HP < 1.0:
		is_dead = true
	if has_died == true:
		if HP > 0.0:
			HP = 0.0
		is_dead = true
	return is_dead

func get_killer_name():
	var stringa = "[color=#ff0000]오류[/color]"
	return stringa

func update_sprites():
	$Sprites.visible = true
	$Form.texture = null
	equipment = []
	if weapon_main != null:
		equipment.append(weapon_main)
		$Sprites / Weapon_Main.texture = load(weapon_main["sprite"])
	else:
		$Sprites / Weapon_Main.texture = null
	if weapon_off != null:
		equipment.append(weapon_off)
		$Sprites / Weapon_Off.texture = load(weapon_off["sprite"])
	else:
		$Sprites / Weapon_Off.texture = null
	if armor_head != null:
		equipment.append(armor_head)
		$Sprites / Armor_Head.texture = load(armor_head["sprite"])
	else:
		$Sprites / Armor_Head.texture = null
	if armor_chest != null:
		equipment.append(armor_chest)
		$Sprites / Armor_Chest.texture = load(armor_chest["sprite"])
	else:
		$Sprites / Armor_Chest.texture = null
	if armor_legs != null:
		equipment.append(armor_legs)
		$Sprites / Armor_Legs.texture = load(armor_legs["sprite"])
	else:
		$Sprites / Armor_Legs.texture = null
	if armor_hands != null:
		equipment.append(armor_hands)
		$Sprites / Armor_Hands.texture = load(armor_hands["sprite"])
	else:
		$Sprites / Armor_Hands.texture = null
	
	for buff in Buffs:
		if buff.form == true:
			$Sprites.visible = false
			if buff.formsprite != "none":
				$Form.texture = load(buff.formsprite)
		

func update_equipped():
	equipment = []
	if weapon_main != null:
		equipment.append(weapon_main)
	if weapon_off != null:
		equipment.append(weapon_off)
	if armor_head != null:
		equipment.append(armor_head)
	if armor_chest != null:
		equipment.append(armor_chest)
	if armor_legs != null:
		equipment.append(armor_legs)
	if armor_hands != null:
		equipment.append(armor_hands)

func get_traits():
	
	var traits = trait_memory
	return traits


func update_traits():
	trait_memory = {}
	traits_duplicate = {}
	
	for trait in abilities:
		if trait != "none":
			
			
			if trait_memory.has(trait):
				traits_duplicate[abilities[trait].title] = abilities[trait]
			trait_memory[abilities[trait].title] = abilities[trait]
				
	update_equipped()
	for item in equipment:
		for trait in item.abilities:
			if trait != "none":
				
				
				
				
				var new_trait = cloner.clone_dict(LTraitsGeneric.trait_data[trait])
				
				
				new_trait.Name = item.name
				trait_memory[new_trait.title] = new_trait
				
				
				
	
	
	pass

func square_traits():
	for trait in get_traits():
		get_traits()[trait] = translate.update_trait(get_traits()[trait])

func get_summon_limit():
	var inta = 0
	inta += get_total_WIL()
	if get_traits().has("Saurian"): inta += get_total_DEX()
	if get_traits().has("Ikshana"): inta += 20
	return inta

func get_name():
	var stringa
	stringa = title_name
	return stringa

func get_name_color():
	var stringa
	stringa = title_name
	return stringa

func get_race():
	var stringa
	stringa = title_race
	return stringa

func get_class():
	var stringa
	stringa = title_class
	return stringa

func get_SPEED_min():
	var inta = SPEED
	
	var increase = get_total_DEX() * 2.0
	
	if increase >= 1.0:
		inta += increase
	
	var minimum = 1.0
	if inta <= get_total_STR():
		minimum = inta
	else:
		minimum = get_total_STR()
	
	return minimum

func get_SPEED():
	var minimum = get_SPEED_min()
	var inta = SPEED + (get_total_DEX() * 2.0)
	var intb = (get_total_weight()) - (get_total_STR())

	
	
	if intb > 0:
		intb *= 2.0
		inta -= intb
	
	inta += StatMods.check(get_node("."), "speed")
	
	inta = float(inta)
	
	if get_buff_names().has("Paralysis"):
		inta = float(minimum)
	
		
	if inta < 1.0:
		inta = 1.0
	
	

	
	
	
	inta /= get_total_inflex()
	
	
	if get_traits().has("LizardVisage") == true:
		if armor_chest == null:
			var multi = 0.5
			multi = float(inta) * multi
			inta -= multi
	
	
	
	
	if inta < minimum:
		inta = minimum
	
	if get_traits().has("Yu") == true:
				if inta > 5.0:
					inta = 5.0
	
	for transformation in get_buff_names():
		match transformation:
			
			
				
			"Lizardform":
				if inta > 15.0:
					inta = 15.0
			
			"Treeform":
				if inta > 1.0:
					inta = 1.0
			
			
			
			
	
	
	
	
	inta = int(inta)
	
	return inta

func get_hands_used():
	var inta
	inta = 0
	if weapon_main != null and weapon_off == null:
		hands_used = 1
	else:
		hands_used = 2
	inta = hands_used
	return inta


func get_range_attack(weapon):
	var inta
	inta = 0
	if weapon != null:
		inta = weapon["range"]
	else:
		inta = 1
	
	if translate.is_bare_fist(weapon_main):
		if get_traits().has("Psiblade"):
			var trait = get_traits().Psiblade
			inta += trait.Level
	
	if get_hands_used() == 1:
		if get_traits().has("AstralTechnique"):
			var trait = get_traits().AstralTechnique
			inta += trait.Level
	
	
	for transformation in get_buff_names():
		match transformation:
			"Batform":
				inta = 1
			"Anqarak":
				inta = 1
			"Snakeform":
				inta = 1
			"Wormform":
				inta = 1
			"Flameform":
				inta = 1
			"Sparkform":
				inta = 1
			
			"Drakeform":
				inta = 1
			"Lizardform":
				inta = 1
			"Beastform":
				inta = 1
			"Wildform":
				inta = 1
			"Newtform":
				inta = 1
			"Jackalform":
				inta = 1
	
	return inta

func get_charged_invokes():
	var total = 0
	for string in invokes:
		var invoke = invokes[string]
		if invoke.level_required <= level:
			if invoke.use >= invoke.use_max:
				total += 1
	return total

func get_known_invokes():
	var total = 0
	for string in invokes:
		var invoke = invokes[string]
		if invoke.level_required <= level:
			
				total += 1
	return total

func get_resist(label):
	var items = [RACE, weapon_main, weapon_off, armor_head, armor_hands, armor_legs, armor_chest]
	var resist = 0
	var key = "resist_" + label
	for item in items:
		if item != null:
			if item.has(key):
				resist += item[key]
	
	var traits = get_traits()
	for title in traits:
		var trait = traits[title]
		if trait.has(key):
			resist += trait.Level * trait.cost * trait[key]
			
	
	

		
			
					
					
	
	
	if get_traits().has("BloodDrinker"):
		resist -= 50
	
	
	if get_traits().has("Arba"):
		resist += int(get_total_inflex()) * 5
	
	
	if get_traits().has("Ape"):
		for n in 4 - get_armor_list().size():
			resist += 5
		for n in get_armor_list().size():
			resist -= 10
	

	
	if get_traits().has("BeastVisage"):
		if armor_chest == null:
			resist += 15
	
		
			
	
	if label == "death" or label == "poison" or label == "blood":
		
			var bonus = get_total_STR()
			
			resist += bonus
	
	for buff in Buffs:
		if buff.name == "Plague":
			resist -= buff.duration
		if buff.name == "Treeform" and label != "fire":
			resist += 75
		if buff.name == "Vineform" and label == "fire":
			resist -= 50
	
	if resist > 75:
		resist = 75
	if resist < - 100:
		resist = - 100
	return resist


func get_ACC(weapon):
	var inta
	inta = 0.0
	if weapon != null:
		if weapon["use"] != "heavy":
			inta = get_total_DEX() * 2
		else:
			inta = get_total_DEX() + get_total_STR()
		if get_hands_used() == 1:
			inta += get_total_DEX()
			if get_aoe(weapon) <= 1:
				inta += get_total_DEX()
		else:
			inta -= weapon["range"]
	else:
		inta = get_total_DEX() * 3
	
	inta -= (get_hands_used() + get_weapon_size_penalty() + 1)
	
	inta += StatMods.check(get_node("."), "attack")
	
	if inta < 1:
		inta = 1
	return inta

func get_ACC_sides(weapon):
	var inta
	inta = 0
	if weapon != null:
		inta = weapon["acc"]
	else:
		inta = 13
	return inta

func get_ACC_total(weapon):
	var inta = 0.0
	var multi = 0.0
	
	if weapon != null:
		inta = weapon.acc * 10.0
	else:
		inta = 150.0
	
	
	
	var increase = 0.0
	
	multi = get_total_DEX()
	
	if get_hands_used() == 1:
		multi += get_total_DEX()
	
	multi = float(multi) / 100.0
	multi *= 5.0
	multi = float(inta) * multi
	
	increase += multi
	
	inta += increase
	
	
	
	
	increase = 0.0
	
	if get_traits().has("Eris") == true:
		multi = 0.25 * get_charged_invokes()
		multi = float(inta) * multi
		increase += multi
	
	inta += increase
	
	
	
	increase = 0.0
	increase += StatMods.check(get_node("."), "attack") * 10.0
	if get_traits().has("Mardok"):
		increase += float(get_total_weight()) * 10.0
	inta += increase
	
	
	
	if get_traits().has("Koszmar") or get_traits().has("Elementalist"):
		if inta > 20.0:
			inta = 20.0
	
	if inta < 1:
		inta = 1
		
	return int(inta)

func get_DMG(weapon):
	var inta
	inta = 0.0
	if weapon != null:
		if weapon["use"] == "light":
			inta = get_total_DEX() + get_total_STR()
		else:
			inta = get_total_STR() * 2
		if get_hands_used() == 1:
			if weapon["use"] == "heavy":
				inta += get_total_STR()
			else:
				inta += (get_total_DEX() / 2)
			if get_aoe(weapon) <= 1:
				inta += get_total_DEX()
		
		if weapon["use"] == "magic":
			inta = get_total_WIL() * 2
			if get_hands_used() == 1:
				inta += get_total_WIL()
	else:
		inta = get_total_STR() + get_total_DEX()
	
	inta += StatMods.check(get_node("."), "damage")
	
	if inta < 1:
		inta = 1.0
	
	return inta

func get_DMG_sides(_weapon):
	var inta = 5
	
	
	
	
		
	return inta

func get_DMG_max(weapon):
	var inta
	inta = get_DMG_sides(weapon) * get_DMG(weapon)
	return inta

func get_DMG_total(weapon):
	var inta = 10.0
	var multi = 0.0
	
	if weapon != null:
		inta = weapon["dmg"] * 10.0
	else:
		inta = 20.0

	
	
	var increase = 0.0
	
	if float(get_SPEED()) > 100.0:
		increase += float(get_SPEED()) - 100.0
	
	multi = get_total_STR()
	
	if weapon != null:
		if get_hands_used() == 1:
			multi += get_total_STR()
	if get_traits().has("LizardVisage") == true:
		if armor_chest == null:
			multi += get_total_STR()
	
	multi = float(multi) / 10.0
	multi = float(inta) * multi
	
	increase += multi
	
	if get_traits().has("MindKnightPrestige") == true:
		if get_hands_used() == 1:
			increase += get_total_WIL() * 30.0
	
	inta += increase
	
	
	
	
	
	increase = 0.0
	
	
	
	if get_traits().has("Eris") == true:
		multi = 0.25 * get_charged_invokes()
		multi = float(inta) * multi
		increase += multi
	
	if get_traits().has("WormMonk") == true:
		if Global.Allies.size() > 1:
			multi = 0.5 * Global.Allies.size() - 1
			multi = float(inta) * multi
			if multi < 0.0: multi = 0.0
			
			increase += multi
	
	if get_traits().has("Rampage") == true:
		multi = 0.1 * (4 - get_armor_list().size())
		multi *= get_traits().Rampage.Level
		multi = float(inta) * multi
		increase += multi
	
	if get_traits().has("Taugh") == true:
			multi = float(HP / HP_max)
			multi = 1.0 - multi
			
			if multi > 0:
				multi = float(inta) * multi
				
				increase += multi
	
	inta += increase
	
	
	
	
	increase = 10.0
	multi = 0.0

	
	multi += StatMods.check(get_node("."), "damage")
	
	if get_traits().has("Mardok"):
		multi += float(get_total_weight()) * 4.0
	if get_traits().has("AxeDivine") and get_hands_used() == 1:
		multi += float(get_total_weight()) * 20.0
	
	increase *= multi
	
	inta += increase
	
	
	
	increase = 0.0
	if get_traits().has("CrowVisage") == true:
		if armor_chest == null:
			multi = 0.5
			multi = float(inta) * multi
			increase -= multi
	inta += increase
	
	
	
	if get_traits().has("Elementalist"):
		if inta > 20.0:
			inta = 20.0
	
	
	if get_buff_names().has("Crystalform"):
		inta = 1.0
	
	if inta < 1.0:
		inta = 1.0
	
	return inta

func get_DMG_type(weapon):
	var stringa = ""
	if weapon != null:
		stringa = weapon["dmgtype"]
	else:
		stringa = "blunt"
	return stringa

func get_DEF():
	var inta
	inta = get_total_DEX() * 2
	
	
	
	inta += StatMods.check(get_node("."), "dodge")
	
	if inta < 1:
		inta = 1
	
	
	var intb = get_total_weight() - get_total_STR()
	
	if intb > 0:
		intb *= 1
		inta -= intb
	if inta < 1:
		inta = 1
	
	return inta


func get_DEF_total():
	var inta = float(get_total_DEX()) * 20.0
	
	var intb = (get_total_weight()) - (get_total_STR())
	if intb > 0:
		intb *= 10.0
		intb *= 2.0
		inta -= intb
	
	
	
	
	var increase = 0.0
	if get_traits().has("MindKnightPrestige") == true:
		if get_hands_used() == 1.0:
			increase += get_total_WIL() * 20.0
	
	inta += increase
	
	
	
	increase = 0.0
	
	if get_traits().has("Eris") == true:
		var multi = 0.25 * get_charged_invokes()
		multi = float(inta) * multi
		increase += multi
	
	inta += increase
	
	
	
	increase = 0.0
	
	increase += StatMods.check(get_node("."), "dodge") * 10.0
	
	inta += increase
	
	
	if inta < 1.0: inta = 10.0
	
	
	increase = 0.0
	
	if get_traits().has("LizardVisage") == true:
		if armor_chest == null:
			var multi = 0.5
			multi = float(inta) * multi
			increase -= multi
	
	inta += increase
	
	
	if get_buff_names().has("Paralysis"):
		inta = 1.0
	
	if inta < 1.0:
		inta = 1.0
	
	if get_traits().has("Sorcerer") == true:
		var limit = 10.0 * get_total_WIL()
		if inta > limit: inta = limit
	
	
		
			
	
	
	
	inta = int(inta)
	
	return inta
	

func get_DEF_sides():
	var inta
	inta = 10
	return inta

func get_ARM():
	var inta = 0.0
	
	var increase = 0.0
	
	var armor_list = get_armor_list()
	for armor in armor_list:
		inta += armor["arm"]
	
	
	
	
	increase += float(get_total_STR() * 15.0)
	increase += inta * (float(get_total_STR()) * 0.1)
	
	
	inta += increase
	
	
	
	
	
	increase = 0.0
	
	if get_traits().has("Eris") == true:
		var multi = 0.25 * get_charged_invokes()
		multi = float(inta) * multi
		increase += multi
	
	for armor in armor_list:
		if get_traits().has("Tenacity"):
			var trait = get_traits().Tenacity
			var intb = float(trait.Level) * 0.2
			intb *= float(armor["arm"])
			increase += intb
	
	
	
	inta += increase
	
	
	
	
	increase = 0.0
	
	increase += StatMods.check(get_node("."), "armor")
	
	
	inta += increase
	


	
	increase = 0.0
	if get_traits().has("BeastVisage") == true:
		if armor_chest == null:
			var multi = 0.5
			multi = float(inta) * multi
			increase -= multi
	
	if get_traits().has("CrowVisage") == true:
		if armor_chest == null:
			var multi = 0.5
			multi = float(inta) * multi
			increase -= multi
	
	inta += increase
	


	if inta < 1:
		inta = 1.0
	
	if get_traits().has("Sorcerer") == true:
		var limit = 10.0 * get_total_WIL()
		if inta > limit: inta = limit
	
	
	
	for transformation in get_buff_names():
		if transformation == "Batform":
			inta = 1.0
		if transformation == "Sparkform":
			inta = 1.0
		if transformation == "Horrorform":
			inta = 1.0
		if transformation == "Jackalform":
			inta = 1.0
		if transformation == "Crowform":
			inta = 1.0
	
	return inta

func get_armor_list():
	var armor_list = []
	if armor_chest != null:
		var a = cloner.clone_dict(armor_chest)
		armor_list.append(a)
	if armor_legs != null:
		var a = cloner.clone_dict(armor_legs)
		armor_list.append(a)
	if armor_head != null:
		var a = cloner.clone_dict(armor_head)
		armor_list.append(a)
	if armor_hands != null:
		var a = cloner.clone_dict(armor_hands)
		armor_list.append(a)
	return armor_list

func get_tint_items():
	var arraya = []
	var slots = [armor_chest, armor_hands, armor_head, armor_legs, weapon_main, weapon_off]
		
	for item in slots:
		if item != null:
			if item.has("tint"):
				if item.tint == true:
					arraya.append(cloner.clone_dict(item))
	
	
	return arraya

func get_weapon_size_penalty():
	var inta
	inta = 0
	if weapon_main != null:
		if weapon_main["size"] > 1:
			inta += weapon_main["size"]
		inta += weapon_main["weight"]
	if weapon_off != null:
		if weapon_off["size"] > 1:
			inta += weapon_off["size"]
		inta += weapon_off["weight"]
	inta /= (get_total_STR() + get_total_DEX())
	if inta < 1:
		inta = 0
	return inta

func get_total_weapon_size():
	var inta = 0
	if weapon_main != null:
		inta += weapon_main["size"]
	if weapon_off != null:
		inta += weapon_off["size"]
	return inta

func get_total_weight():
	var inta = 0
	if weapon_main != null:
		inta += weapon_main["weight"]
	if weapon_off != null:
		inta += weapon_off["weight"]
	if armor_chest != null:
		inta += armor_chest["weight"]
	if armor_hands != null:
		inta += armor_hands["weight"]
	if armor_head != null:
		inta += armor_head["weight"]
	if armor_legs != null:
		inta += armor_legs["weight"]
	
	if get_traits().has("Gallus"):
		var multi = float(get_total_STR()) * 0.1
		inta += int(float(inta * multi))
	
	inta += StatMods.check(get_node("."), "encumbrance")
	if inta < 0:
		inta = 0
		
	
	return inta

func get_total_inflex():
	var inta = 1.0
	if armor_chest != null:
		inta += armor_chest["inflex"]
	if armor_hands != null:
		inta += armor_hands["inflex"]
	if armor_head != null:
		inta += armor_head["inflex"]
	if armor_legs != null:
		inta += armor_legs["inflex"]
	inta += StatMods.check(get_node("."), "inflex")
	
	if get_traits().has("Myrmidon"):
		inta += int(float(get_total_DEX() / 5.0))
	
	
	if get_traits().has("MurunaSash"):
		if get_total_weight() <= get_total_STR():
			inta -= 6
	
	
	for transformation in get_buff_names():
		match transformation:
			
			
				
			"Crystalform":
				inta *= 2.0
	
	if inta < 1:
		inta = 1.0
	
	return inta

func get_block():
	var inta = 0.0
	inta += get_total_DEX() * 2
	inta += StatMods.check(get_node("."), "defense")
	
	if inta < 1:
		inta = 1
	
	
	
		
		
		
	return inta

func get_block_sides():
	var inta = 0
	if weapon_main != null:
		inta += weapon_main["def"]
	else: inta += 5
	
	if get_hands_used() > 1:
		if weapon_off != null:
			inta += weapon_off["def"]
		else: inta += 5
	
	
	return inta

func get_block_chance():
	
	var inta = 0.0
	if weapon_main != null:
		inta += 15.0
	if weapon_off != null:
		inta += 15.0
	
	var shielded = false
	if weapon_off != null:
		if weapon_off.shield == true:
			inta += 50.0
			shielded = true
	if weapon_main != null and shielded == false:
		if weapon_main.shield == true:
			inta += 50.0
		
	if armor_hands != null:
		inta += 15.0
	
	inta += 1.0 * get_total_DEX()
	
	if get_traits().has("MindKnightPrestige") and get_hands_used() == 1:
		inta += 1.0 * get_total_WIL()
	if get_traits().has("Isaz"):
		var trait = get_traits().Isaz
		inta += 5.0 * trait.Level
	if get_traits().has("Murmillo"):
		var trait = get_traits().Murmillo
		inta += 5.0 * trait.Level
	if get_traits().has("MindKnight"):
		var trait = get_traits().MindKnight
		inta += 3.0 * trait.Level
	if get_traits().has("Valr"):
		inta += 25.0
	if get_traits().has("Pallas"):
		if invokes.has("ygeia"):
			if invokes.ygeia.use > 0:
				inta += 50.0
	
	if inta > 90.0:
		inta = 90.0
	
	
	
	return inta

func get_block_strength():
	var inta = 0.0
	
	if weapon_main != null:
		var intb = weapon_main["arm"]
		inta += intb
	
	if armor_hands != null:
		var intb = armor_hands["arm"]
		
		inta += intb
	if get_hands_used() > 1:
		if weapon_off != null:
			var intb = weapon_off["arm"]
			inta += intb
	
	inta = float(inta)
	
	
	var increase = 0.0
	increase += float(get_total_DEX() * 20.0)
	increase += inta * (float(get_total_STR()) * 0.1)
	var multi = (get_total_inflex() - 1) * 0.25
	multi *= inta
	increase += multi
	
	inta += increase
	
	
	
	increase = 0.0
	
	if get_traits().has("Eris") == true:
		multi = 0.25 * get_charged_invokes()
		multi = float(inta) * multi
		increase += multi
	
	if get_traits().has("WormMonk") == true:
		if Global.Allies.size() > 1:
			multi = 0.5 * Global.Allies.size() - 1
			multi = float(inta) * multi
			increase += multi
	
	if weapon_main != null:
		if get_traits().has("Murmillo"):
			var trait = get_traits().Murmillo
			var intb = trait.Level * 0.3
			intb *= weapon_main["arm"]
			increase += intb
	
	if get_hands_used() > 1:
		if weapon_off != null:
			if get_traits().has("Murmillo"):
				var trait = get_traits().Murmillo
				var intb = trait.Level * 0.3
				intb *= weapon_off["arm"]
				increase += intb
	
	inta += increase
	
	
	
	
	increase = 0.0

	increase += StatMods.check(get_node("."), "block")

	inta += increase
	
	
	
	increase = 0.0
	if get_traits().has("CrowVisage") == true:
		if armor_chest == null:
			multi = 0.5
			multi = float(inta) * multi
			increase -= multi
	inta += increase
	
	
	if inta < 1.0:
		inta = 1.0
	if get_traits().has("Sorcerer") == true:
		var limit = 10.0 * get_total_WIL()
		if inta > limit: inta = limit
	
	for transformation in get_buff_names():
		if transformation == "Batform":
			inta = 1.0
		if transformation == "Anqarak":
			inta = 1.0
		if transformation == "Sparkform":
			inta = 1.0
		if transformation == "Horrorform":
			inta = 1.0
		if transformation == "Crowform":
			inta = 1.0
	
	return inta

	
func get_total_STR():
	var inta = 0
	inta += STR
	return inta

func get_total_DEX():
	var inta = 0
	inta += DEX
	return inta

func get_total_WIL():
	var inta = 0
	inta += WIL
	return inta
	
func get_projectile_art(weapon):
	var spr = null
	if weapon != null:
		if weapon["proj_art"] != "none":
			spr = weapon["proj_art"]
	
	
	if get_traits().has("Psiblade"):
		if translate.is_bare_fist(weapon_main):
			spr = "res://Ham_Sprite/Proj/Proj_Psychic.png"
	
	if weapon_main != null and weapon_off == null:
		if get_traits().has("AstralTechnique"):
			spr = "res://Ham_Sprite/Proj/Proj_Astral.png"
	
	
	
	return spr




func get_aoe(weapon):
	var inta = 1
	if weapon != null:
		inta = weapon["aoe"]
	return inta

func hp_percent():
	return (HP / HP_max)

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
			if buff.form == true:
				effectmaker.create_effect_animated(buff.target.global_position, Global.EffectAnimated, "Transform")
	
	if Buffs_Remove.size() > 0:
		for buff in Buffs_Remove:
			Buffs.erase(buff)
			
	
	
	for buff in Buffs:
		buff.duration -= 1
		buffcheck.check(buff.name, buff.duration, buff.target, buff.source, buff)
	
	Global.game.get_node("UI").get_node("UI_BuffDrawer").write_buffs()
		
			
	

func write_buffs():
	var stringa = ""
	for buff in Buffs:
		stringa = stringa + buff.color + buff.name + "[/color] " + str(buff.duration) + "   "
	return stringa
		
func get_buff_names():
	var array = []
	for buff in Buffs:
		array.append(buff.name)
	return array

func slide(pos_start, pos_end):
	
	var tween = get_node("Tween")
	tween.interpolate_property(get_node("."), "position", 
		pos_start, pos_end, 0.3, 
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _input(event):
	if is_dead() == false and StateWorld.victorious == false:
		if Global.game != null:
			if Global.game.paused == false:
				if ProcessQueue.PAUSED == false and ProcessQueue.ACTIVE == false:
					if ui.get_open_windows().size() == 0:
						if ui.get_node("UI_Enemies").is_open == false:
							keyboard_action(event)
	
	if Global.game != null:
			if Global.game.paused == false:
				if ProcessQueue.PAUSED == false and ProcessQueue.ACTIVE == false:
					if ui.get_open_windows().size() == 0:
						if ui.get_node("UI_Enemies").is_open == false:
							menu_actions(event)
	if Global.game != null:
			if Global.game.paused == false:
				if ProcessQueue.PAUSED == false and ProcessQueue.ACTIVE == false:
					if ui.get_open_windows().size() == 0:
						if ui.get_node("UI_Enemies").is_open == false:
							Global.universal.deck.input_handler(event)

func auto_input(label):
	if is_dead() == false and StateWorld.victorious == false:
		if Global.game != null:
			if Global.game.paused == false:
				if ProcessQueue.PAUSED == false and ProcessQueue.ACTIVE == false:
					if ui.get_open_windows().size() == 0:
						if ui.get_node("UI_Enemies").is_open == false:
							
							match label:
								"tab":
									if Input.is_action_pressed("alt") == false and Input.is_action_pressed("shift") == false:
										ToolPlayerController.autoattack()
								"mouse_right":
									if Input.is_action_pressed("alt") == false and Input.is_action_pressed("shift") == false:
										ToolPlayerController.autoattack()
								"gamepad_b":
									if ToolSettings.settings_data.gamepad_mode == "full":
										
										ToolPlayerController.autoattack()
								"gamepad_x":
									if ToolSettings.settings_data.gamepad_mode == "full":
										
										ToolPlayerController.move("pass")
								"pass":
									ToolPlayerController.move("pass")
	

func menu_actions(event):
	if event.is_action_pressed("escape"):
		ui.show_menu()
	if event.is_action_pressed("i"):
		ui.open_inventory()
	if event.is_action_pressed("p"):
		ui.open_traits()
	if event.is_action_pressed("g"):
		ui.show_log()
	
	
	if event.is_action_pressed("5"):
		game.swap_weapons()
	

func keyboard_action(event):
	if event.is_action_pressed("tab") or event.is_action_pressed("mouse_right"):
		if Input.is_action_pressed("alt") == false and Input.is_action_pressed("shift") == false:
			ToolPlayerController.autoattack()
	if event.is_action_pressed("gamepad_b") and ToolSettings.settings_data.gamepad_mode == "full":
		ToolPlayerController.autoattack()
	
	if event.is_action_pressed("1"):
		ui_invokes.invoke_hotkey(1)
	if event.is_action_pressed("2"):
		ui_invokes.invoke_hotkey(2)
	if event.is_action_pressed("3"):
		ui_invokes.invoke_hotkey(3)
	
	if event.is_action_pressed("pass"):
		
		ToolPlayerController.move("pass")
	if event.is_action_pressed("gamepad_x"):
		if ToolSettings.settings_data.gamepad_mode == "full":
		
			ToolPlayerController.move("pass")
	
	if event.is_action_pressed("enter"):
		
		ToolPlayerController.move("enter")
	if event.is_action_pressed("gamepad_y"):
		if ToolSettings.settings_data.gamepad_mode == "full":
		
			ToolPlayerController.move("enter")
	
	if event.is_action_pressed("up"):
		ToolPlayerController.move("up")
	
	if event.is_action_pressed("upleft"):
		ToolPlayerController.move("upleft")
	
	if event.is_action_pressed("upright"):
		ToolPlayerController.move("upright")
	
	if event.is_action_pressed("left"):
		ToolPlayerController.move("left")
	
	if event.is_action_pressed("right"):
		ToolPlayerController.move("right")
	
	if event.is_action_pressed("down"):
		ToolPlayerController.move("down")
	
	if event.is_action_pressed("downleft"):
		ToolPlayerController.move("downleft")
	
	if event.is_action_pressed("downright"):
		ToolPlayerController.move("downright")
	
	
	
	if event.is_action_pressed("target"):
		update_targeted(true)
	
	


func check_inv_glow():
	var available_traits = []
	
	if Global.Player.ELEMENTS.size() < 2:
		for trait in LTraits.list_all:
			if trait.ready == true:
				if trait.cost <= Global.Player.POINTS_TRAITS:
					available_traits.append(trait)
	else:
		for trait in LTraits.list_all:
			if trait.ready == true:
				if Global.Player.ELEMENTS.has(trait.Element) == true:
					if trait.cost <= Global.Player.POINTS_TRAITS:
						available_traits.append(trait)
	
	if available_traits.size() > 0:
		
		
		Global.trait_glow = true

func get_item_from_label(label):
	var item_dict = null
	match label:
		"main":
			if weapon_main != null:
				item_dict = cloner.clone_dict(weapon_main)
		"off":
			if weapon_off != null:
				item_dict = cloner.clone_dict(weapon_off)
		"head":
			if armor_head != null:
				item_dict = cloner.clone_dict(armor_head)
		"hand":
			if armor_hands != null:
				item_dict = cloner.clone_dict(armor_hands)
		"chest":
			if armor_chest != null:
				item_dict = cloner.clone_dict(armor_chest)
		"leg":
			if armor_legs != null:
				item_dict = cloner.clone_dict(armor_legs)
	
	return item_dict

func update_targeted(is_input):
	
	targets = get_enemies_in_range()
	
	if targets.has(target_enemy) == false:
		target_enemy = null
	if targets.size() <= 0:
		target_enemy = null
	
	if is_input == true:
		if target_enemy != null:
		
			var array_position = 0
			for n in targets.size():
				if targets[n] == target_enemy:
					array_position = n
		
			array_position += 1
			if array_position > targets.size() - 1:
				array_position = 0
		
			target_enemy = targets[array_position]
			ToolMessageCreator.hover_info = target_enemy
			ToolMessageCreator.hover_info_type = "unit"
			ToolMessageCreator.update()
		
	if target_enemy == null:
		
		if targets.size() > 0:
			var temp_target = ToolPlayerController.get_enemy_in_range(get_node("."), Global.Enemies)
			if targets.has(temp_target):
				target_enemy = temp_target
			
			
			
	
	if target_enemy == null:
		$targeter.visible = false
		
	else:
		
		$targeter.visible = true
		$targeter.global_position = target_enemy.global_position

func get_enemies_in_range():
	var array = []
	for enemy in Global.Enemies:
		if enemy.is_dead() == false:
			if calcrange.tile_is_in_range_unblocked(residence, enemy.residence, get_range_attack(weapon_main)) == true:
				array.append(enemy)
	return array

func get_equipped_items():
	var array = []
	var items = [weapon_main, weapon_off, armor_chest, armor_hands, armor_head, armor_legs]
	for item in items:
		if item != null:
			array.append(item)
	
	
	return array
