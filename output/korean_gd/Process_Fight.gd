extends Node


var rng = RandomNumberGenerator.new()
var game = null
var Player

enum RESULT{miss, shrug, block, hit}
var result = RESULT.miss

var fight_string = ""

func fight(attacker, defender, weapon, msg):
	
	fight_string = ""
	
	var msg_string = event_attack.message_hit(defender, attacker, msg)
	ToolMessageCreator.add_message("[color=#c0c0c0]", msg_string)
	
	
	
	
	result = RESULT.miss
	rng.randomize()
	
	
	
	var hit = float(int(calculate_hit(attacker, defender, weapon)))
	
	
	
	
	
	
	event_all.on_attack(attacker, defender, weapon, msg)
	
	if hit >= 1.0:
		fight_string += ", 결과 = 명중 " + str(int(hit))
	
	if ToolSettings.settings_data.log_detail == true:
		if attacker == Global.Player or defender == Global.Player:
			ToolMessageCreator.add_message("[color=#707070]", fight_string)
	
	if hit >= 1.0:
		
		msg = "공격"
		event_all.on_hit(attacker, defender, weapon, hit, msg)
	
	
	
	combat_message(attacker, defender, hit)

func calculate_hit(attacker, defender, weapon):
	if calculate_attack_roll(attacker, weapon) > calculate_defense_roll(defender):
	
		result = RESULT.hit
		return calculate_damage(attacker, defender, weapon)
	else:
		if rng.randi_range(1, 10) == 1:
			guard_break_message(attacker, defender, "dodge")
			fight_string += ", 회피 간파"
			result = RESULT.hit
			return calculate_damage(attacker, defender, weapon)
		else:
			result = RESULT.miss
			event_dodge.check(attacker, defender, weapon)
			fight_string += ", 결과 = 회피"
			return 0.0

func calculate_attack_roll(attacker, weapon):
	
	
	var anumber = rng.randi_range(1, attacker.get_ACC_total(weapon))
	fight_string += "//명중 굴림 " + str(int(anumber))
	return anumber
	
func calculate_defense_roll(defender):
	
	
	var anumber = rng.randi_range(1, defender.get_DEF_total())
	fight_string += ", 회피 굴림 " + str(int(anumber))
	return anumber

func calculate_damage(attacker, defender, weapon):
	
	
	var total = rng.randi_range(1, attacker.get_DMG_total(weapon))
	var dmgtype = attacker.get_DMG_type(weapon)
	var physical = is_physical(dmgtype)
	
	
	
	
	var block_chance = defender.get_block_chance()
	
	var block_strength = defender.get_block_strength()
	
	
	
	if total < float(defender.HP_max) * 0.1: total = float(defender.HP_max) * 0.1
	
	if total > attacker.get_DMG_total(weapon): total = attacker.get_DMG_total(weapon)
	
	fight_string += ", 초기 피해 굴림 " + str(int(total))
	
	
	
	
	var totaltest = total
	
	if rng.randi_range(1, 100) <= block_chance:
		if defender.get_traits().has("Myrmidon"):
			if calcrange.tile_is_in_range(attacker.residence, defender.residence, 1) == false:
				block_strength *= 2.0
	
		if physical == false:
			var resist = float(defender.get_resist(dmgtype)) / 100.0
			if resist < 0.25: resist = 0.25
			if resist > 0.0:
				block_strength *= (resist + 0.25)
			else:
				block_strength = 0.0
		
		if attacker.get_traits().has("Penetration"):
			block_strength *= 0.1
		
		if attacker.get_traits().has("Sesha"):
			if attacker.get_total_weapon_size() < 5:
				block_strength = 0.0
		
		fight_string += ", 방어 -" + str(int(block_strength))
		
		if block_strength >= totaltest:
			total = 0.0
			event_block.check(attacker, defender, weapon, block_strength)
			result = RESULT.block
			fight_string += ", 결과 = 방어"
		else:
			total -= block_strength
		
		if total <= 0.0:
			total = 0.0
	else:
		
		guard_break_message(attacker, defender, "block")
		fight_string += ", 방어 실패"
	
	
	
	
	totaltest = total
	
	if total >= 1.0:
		var armor = defender.get_ARM()
		if physical == false:
			var resist = float(defender.get_resist(dmgtype)) / 100.0
			if resist < 0.25: resist = 0.25
			if resist > 0.0:
				armor *= (resist + 0.25)
			else:
				armor = 0.0
		
		if attacker.get_traits().has("Penetration"):
			armor *= 0.1
		if attacker.get_traits().has("Sesha"):
			if attacker.get_total_weapon_size() < 5:
				armor = 0.0
		
		
		if rng.randi_range(1, 10) <= 9:
			
			fight_string += ", 방어력 -" + str(int(armor))
			
			if totaltest < armor:
				total = 0.0
			else:
				total -= armor
		elif total >= 1.0:
			total = total_limit_to_not_max_life(total, defender)
			guard_break_message(attacker, defender, "armor")
			fight_string += ", 방어력 실패"
		
		if total < 1.0:
			total = 0.0
			event_shrug.check(attacker, defender, weapon, armor)
			result = RESULT.shrug
			fight_string += ", 결과 = 상쇄"
	
	
	
	return total

func is_physical(dmgtype):
	var boola = false
	match dmgtype:
		"pierce":
			boola = true
		"slash":
			boola = true
		"blunt":
			boola = true
	return boola

func text_hit(_defender, _hit):
	pass
	


	

func text_miss(_attacker):
	pass
	
	
	
	


func guard_break_message(attacker, defender, label):
	var name_a = attacker.get_name_color()
	if attacker == Global.Player:
		name_a = ""
	var name_d = defender.get_name_color()
	if defender == Global.Player:
		name_d = "당신"
	var txcolor = "[color=#c0c0c0]"
	
	if label == "block":
		
		if attacker == Global.Player:
			ToolMessageCreator.add_message(txcolor, name_a + "(이)가 " + name_d + "의 방어를 돌파!")
		elif defender == Global.Player:
			name_d = "당신의"
			ToolMessageCreator.add_message(txcolor, "" + name_a + "(이)가 " + name_d + " 방어를 돌파!")
	
	if label == "armor":
		
		if attacker == Global.Player:
			ToolMessageCreator.add_message(txcolor, name_a + "(이)가 " + name_d + "의 방어구를 관통!")
		elif defender == Global.Player:
			name_d = "당신의"
			ToolMessageCreator.add_message(txcolor, "" + name_a + "(이)가 " + name_d + " 방어구를 관통!")
	
	if label == "dodge":
		
		if attacker == Global.Player:
			ToolMessageCreator.add_message(txcolor, name_a + "(이)가 " + name_d + "의 회피를 간파!")
		elif defender == Global.Player:
			name_d = "당신의"
			ToolMessageCreator.add_message(txcolor, "" + name_a + "(이)가 " + name_d + " 회피를 간파!")

func combat_message(attacker, defender, _hit):
	
	var name_a = attacker.get_name_color()
	if attacker == Global.Player:
		name_a = ""
	var name_d = defender.get_name_color()
	if defender == Global.Player:
		name_d = "당신"
	
	
	if result == RESULT.miss:
		
		
		var txcolor = "[color=#c0c0c0]"
		if attacker == Global.Player:
			name_a = "당신의"
			ToolMessageCreator.add_message(txcolor, "" + name_d + "(이)가 " + name_a + " 공격을 회피")
		elif defender == Global.Player:
			txcolor = "[color=#c0c0c0]"
			ToolMessageCreator.add_message(txcolor, name_d + "(이)가 " + name_a + "의 공격을 [color=#50ffff]회피[/color]")
		else:
			pass
			
	
	if result == RESULT.block:
		
		
		var txcolor = "[color=#c0c0c0]"
		if attacker == Global.Player:
			name_a = "당신의"
			ToolMessageCreator.add_message(txcolor, "" + name_d + "(이)가 " + name_a + " 공격을 방어")
		elif defender == Global.Player:
			txcolor = "[color=#c0c0c0]"
			ToolMessageCreator.add_message(txcolor, name_d + "(이)가 " + name_a + "의 공격을 [color=#5050ff]방어[/color]")
		else:
			pass
			
	
	if result == RESULT.shrug:
		
		
		var txcolor = "[color=#c0c0c0]"
		
		if attacker == Global.Player:
			name_a = "당신의"
			ToolMessageCreator.add_message(txcolor, "" + name_d + "(이)가 " + name_a + " 공격을 상쇄")
		elif defender == Global.Player:
			txcolor = "[color=#c0c0c0]"
			ToolMessageCreator.add_message(txcolor, name_d + "(이)가 " + name_a + "의 공격을 [color=#5050ff]상쇄[/color]")
		else:
			pass
			
	
	
		
		
		
		
	
		
	
		
	
		

	pass


func total_limit_to_not_max_life(total, defender):
	if defender == Global.Player:
		if total > float(defender.HP_max) * 0.9:
			total = float(defender.HP_max) * 0.9
	return total
