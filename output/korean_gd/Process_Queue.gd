extends Node


var game = null
var TimerNode = null
var Player = null
var TimerTotal = 1
var TimerCurrent = 1

var inventory_open = false

var current_action = 0
var max_actions = 0
var cycle_times = 1

var ACTIVE = false
var PAUSED = false

var cycle_phase = 0
enum PHASE{special, enemy, ally}

var queue_effects = []
var queue = []
var STOP = false
enum ACTION{TYPE}





func run_queue():
	
	
	STOP = false
	ACTIVE = true
	
		
	
	

	
	
	
	
	

	
	
	
	
	
	ProcessQueue2.is_player_active = false
	
		
			
			
			
					
			
			
			
	
	
	
	
	game.update()
	if STOP == false:
		
		
		cycle_go_2()
		
		
		
		
		
			
			
		
		
		
		
		
		
	
		TimerCurrent -= 1
		if TimerCurrent <= 0:
			TimerCurrent = TimerTotal



func start_cycle(array):
	queue = []
	if Global.Enemies.size() != 0:
		ToolAi.add_unit_actions(array)
	
	
	
	game.pause_player()
	
	current_action = 0
	max_actions = queue.size() - 1
	
func run_effects():
	queue_effects = qe.clean(queue_effects)
	if queue_effects.size() > 0:
		var action = queue_effects[0]
		queue_effects.erase(queue_effects[0])
		qe.check(action)

func cycle_go():
	queue_effects = qe.clean(queue_effects)
	if queue_effects.size() > 0:
		var action = queue_effects[0]
		queue_effects.erase(queue_effects[0])
		qe.check(action)
	
	
	else:
		game.update()
		cycle_Ai_actions()
	
func cycle_Ai_actions():
	if max_actions >= 0:
		
		
		if queue.size() > 0 and queue.size() > current_action:
		
			
			if queue[current_action][1].is_dead() == false:
				
				queue[current_action] = ToolAi.determine_action(queue[current_action][1])
			
			
			
			
				unit_attack_enemy(current_action)
				unit_move(current_action)
	
	current_action += 1
	if current_action > max_actions:
		
		
		if cycle_phase == PHASE.special:
			cycle_phase = PHASE.enemy
			start_cycle([])
		
		elif cycle_phase == PHASE.enemy:
			cycle_phase = PHASE.ally
			start_cycle(Global.Allies)
			
		elif cycle_phase == PHASE.ally:
			if queue_effects.size() > 0:
				
				run_effects()
			else:
				cycle_times -= 1
			
			
			
			
				queue = []
				game.new_turn()
	
				TimerCurrent -= 1
				if TimerCurrent <= 0:
					TimerCurrent = TimerTotal
		
				if cycle_times > 0:
					
					cycle_phase = PHASE.enemy
					start_cycle(Global.Enemies)
				else:
	
					cycle_times = 1
				
					ACTIVE = false
					game.unpause_player()
					


func initiate_action_timer(SPEED):
	TimerTotal = SPEED
	TimerCurrent = SPEED

func update_action_timer(SPEED):
	var diff = SPEED - TimerTotal
	if diff > 0:
		TimerCurrent += diff
	TimerTotal = SPEED
	
func run_multiple_times(times):
	cycle_times = times
	run_queue()
	
	
func new_level(action):
	if queue[action][ACTION.TYPE] == "new_level":
		ACTIVE = false
		STOP = true
		queue = []
		queue_effects = []
		ProcessQueue2.active_units = []
		
		TimerCurrent = TimerTotal
		StateWorld.floor_up()
		Global.game.pause_player()
		StatePlayerSheet.update()
		Global.clear_level_data()
		Global.universal.transition("game")
		

func unit_attack_enemy(action):
	if queue[action][ACTION.TYPE] == "unit_attack_enemy":
		var tile_start = queue[action][1]
		var tile_end = queue[action][5].residence
		var tile_range = queue[action][3]
		var weapon = null
		var attacker = queue[action][4]
		var defender = queue[action][5]
		var msg = "Initial"
		if attacker.is_dead() == false and defender.is_dead() == false:
			if ToolCalculateRange.tile_is_in_range_unblocked(tile_start, tile_end, tile_range) == true:
				
				if attacker.get_aoe(weapon) > 1:
				
					tile_start = attacker.residence
					var border_tiles = ToolCalculateRange.get_border_tiles_occupied_in_range(tile_start, attacker.get_range_attack(weapon))
					for tile in border_tiles:
						if tile.resident != null:
							if tile.resident != defender and calcrange.get_enemy_alliance(attacker).has(tile.resident):
								var enemy = tile.resident
								tile_end = tile
								ToolMagicMaker.add_attack(attacker, tile_start, tile_end, tile_range, enemy, weapon, msg)
				
				attacker.get_node("AnimationPlayer").play("wobble")
				
				ProcessFight.fight(attacker, defender, weapon, msg)
				
				
				
				
			else:
				tile_end = ToolPathfinding.get_best_direction(tile_start, tile_end)
				tile_range = 1
				var actor = attacker
				tile_start = actor.residence
				if tile_end != null:
					if ToolCalculateRange.tile_is_in_range(tile_start, tile_end, tile_range) == true:
						if tile_end.resident == null:
							actor.slide(tile_start.position, tile_end.position)
							actor.position = tile_end.position
							tile_start.resident = null
							tile_end.resident = actor
							actor.residence = tile_end
							

func player_attack_enemy(action):
	if queue[action][ACTION.TYPE] == "player_attack_enemy":
		var tile_start = queue[action][1]
		var tile_end = queue[action][4].residence
		var tile_range = queue[action][3]
		var weapon = queue[action][5]
		var enemy = queue[action][4]
		var attacker = Player
		var defender = enemy
		
		
		var msg = "Initial"
		
		if attacker.is_dead() == false and defender.is_dead() == false:
			if ToolCalculateRange.tile_is_in_range_unblocked(tile_start, tile_end, tile_range) == true:
				
				attacker.get_node("AnimationPlayer").play("wobble")
				ProcessFight.fight(attacker, defender, weapon, msg)
			else:
				pass
		
func player_move(action):
	if queue[action][ACTION.TYPE] == "player_move":
		var tile_start = queue[action][1]
		var tile_end = queue[action][2]
		var tile_range = queue[action][3]
		if tile_end == tile_start:
				event_move.check(Player, tile_start, tile_end)
		elif ToolCalculateRange.tile_is_in_range(tile_start, tile_end, tile_range) == true:
			
			if tile_end.resident == null:
				tile_start.resident = null
				event_move.check(Player, tile_start, tile_end)
				tile_end.pickup_pile()
			elif tile_end.resident.object_type == "ally":
				Global.sound.new_sound("Move")
				var ally = tile_end.resident
				event_move.check(Player, tile_start, tile_end)
				event_move.check(ally, tile_end, tile_start)
				tile_end.pickup_pile()
				

func unit_move(action):
	if queue[action][ACTION.TYPE] == "unit_move":
		var tile_start = queue[action][1]
		var tile_end = queue[action][2]
		var tile_range = queue[action][3]
		var actor = queue[action][4]
		if actor.is_dead() == false:
			if tile_end != tile_start:
				if ToolCalculateRange.tile_is_in_range(tile_start, tile_end, tile_range) == true:
					if tile_end.resident == null:
						tile_start.resident = null
						event_move.check(actor, tile_start, tile_end)
					
					elif calcrange.get_allied_alliance(actor).has(tile_end.resident) and tile_end.resident != Global.Player:
						var neighbor = tile_end.resident
						
						if neighbor.get_traits().has("stationary") == true:
							event_move.check(actor, tile_start, tile_end)
							event_move.check(neighbor, tile_end, tile_start)
						
						elif actor.get_range_attack(null) < neighbor.get_range_attack(null):
							event_move.check(actor, tile_start, tile_end)
							event_move.check(neighbor, tile_end, tile_start)
						
						elif actor.get_traits().has("Familiar") == true:
								
								if neighbor.get_traits().has("Familiar") == false:
									if actor.get_range_attack(null) <= neighbor.get_range_attack(null):
										
										event_move.check(actor, tile_start, tile_end)
										event_move.check(neighbor, tile_end, tile_start)
								
						
					elif tile_end.resident == Global.Player:
						tile_end = tile_start
						event_move.check(actor, tile_start, tile_end)
				else:
					pass
			else:
				event_move.check(actor, tile_start, tile_end)


func pick_weapon(action):
	if queue[action][ACTION.TYPE] == "player_pick_weapon":
		var picked_item = queue[action][1]
		var picked_object = queue[action][2]
		picked_object.text_pick_weapon(Player)
		Player.bag.append(picked_object.item)
		picked_object.object_type = "none"
		
		picked_object.update()
		game.update_remove.append(picked_object)
		
		
		
		
		Player.update()
		


func add_effect(action):
	
	queue_effects.push_front(action)












func cycle_go_2():
	
	
	game.update()
	queue_effects = qe.clean(queue_effects)
	if queue_effects.size() > 0:
		
		
		
		
			
			
			
			
			
			
		
		var action = queue_effects[0]
		
		queue_effects.erase(queue_effects[0])
		qe.check(action)
		game.new_turn()
	elif queue.size() > 0:
		
		if STOP == false:
			player_attack_enemy(0)
			player_move(0)
			new_level(0)
			if STOP == false:
				if queue[0][0] == "take_action":
					
					if queue[0].size() > 1:
						if queue[0][1] != null:
							if queue[0][1].is_dead() == false:
						
									queue[0] = ToolAi.determine_action(queue[0][1])
						
									unit_attack_enemy(0)
									unit_move(0)
				queue.erase(queue[0])
		
				game.new_turn()
	elif ProcessQueue2.is_game_active == true:
		
		game.new_turn()
		
	else:
		ProcessQueue2.search_for_turn()
		
		
	
	
func junk():
	if max_actions >= 0:
		
		
		if queue.size() > 0 and queue.size() > current_action:
		
			
			if queue[current_action][1].is_dead() == false:
				
				queue[current_action] = ToolAi.determine_action(queue[current_action][1])
			
			
			
			
				unit_attack_enemy(current_action)
				unit_move(current_action)
	
	current_action += 1
	if current_action > max_actions:
		
		
		if cycle_phase == PHASE.special:
			cycle_phase = PHASE.enemy
			start_cycle([])
		
		elif cycle_phase == PHASE.enemy:
			cycle_phase = PHASE.ally
			start_cycle(Global.Allies)
			
		elif cycle_phase == PHASE.ally:
			if queue_effects.size() > 0:
				
				run_effects()
			else:
				cycle_times -= 1
			
			
			
			
				queue = []
				game.new_turn()
	
				TimerCurrent -= 1
				if TimerCurrent <= 0:
					TimerCurrent = TimerTotal
		
				if cycle_times > 0:
					
					cycle_phase = PHASE.enemy
					start_cycle(Global.Enemies)
				else:
	
					cycle_times = 1
				
					ACTIVE = false
					game.unpause_player()

