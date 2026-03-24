extends Node2D


var Tick = 0.0
var enemy_placed = false
var tick_new = 1.0



var rng = RandomNumberGenerator.new()
var point = Vector2(0, 0)
var Player = null
var open_tiles = []
var update_remove = []
var game_over = false
var paused = true

var leveling_up = false


var turn_number = 0

var delayed_events = []

var enemy_types = []
var ally_types = []

var item_pool = []

var floor_cleared = false

var tile_start = null
var tile_exit = null

var auto_buffer = 0
var auto_buffer_max = 15


	

func update_range_indicators():
	if ToolSettings.settings_data.show_range == true:
		for tile in Global.Tile_Ground:
			tile.get_node("red").visible = false
			if ToolMessageCreator.hover_info_type == "unit":
				var unit = ToolMessageCreator.hover_info
				if calcrange.tile_is_in_range_unblocked(unit.residence, tile, unit.get_range_attack(unit.weapon_main)):
					tile.get_node("red").visible = true
			elif ToolMessageCreator.hover_info_type == "feature":
				if ToolMessageCreator.hover_info.resident != null:
					if ToolMessageCreator.hover_info.resident == Global.Player:
						if Global.Player.is_dead() == false:
							var unit = ToolMessageCreator.hover_info.resident
							if calcrange.tile_is_in_range_unblocked(unit.residence, tile, unit.get_range_attack(unit.weapon_main)):
								tile.get_node("red").visible = true

func _ready():
	Global.universal.deck.reset_buttons()
	
	initiate()
	rng.randomize()
	generate()
	
	


func generate():
	var game = get_node(".")
	ToolGenerateLevel.generate(game)
	
	
	
		
func update_game():
	for n in Global.Tile.size():
		
		if Global.Tile[n].resident != null:
			Global.Tile[n].resident.update()
		
		Global.Tile[n].update()
		
	if update_remove.size() > 0:
		for n in update_remove.size():
			update_remove[n].queue_free()
			update_remove.erase(update_remove[n])
	update_range_indicators()
	
	ToolMessageCreator.hover_info = null
	ToolMessageCreator.hover_info_type = "none"
	ToolMessageCreator.update()
	
	update_deckbuttons()

func new_turn():
	
	
	if ProcessQueue2.is_game_active == true:
		ProcessQueue2.is_game_active = false
		
		run_effects()
	
	if Global.Enemies.size() == 0:
		if enemy_placed == true or StateWorld.type == "path":
			level_cleared()
	
	
	
	update_game()

func has_tick(player_speed):
	var reala = 10.0 / float(player_speed)
	if reala >= 1.0:
		reala = 1.0
	Tick += reala
	if Tick >= 1.0:
		Tick -= 1.0
		return true
	else:
		return false

func run_effects():
	event_turn.run()

	
	var effects = get_tree().get_nodes_in_group("effect")
	for n in effects.size():
		if effects[n].duration < 1:
			effects[n].queue_free()
		else:
			effects[n].duration -= 1

func level_cleared():
	
	if floor_cleared == false:
		
		print("VANQUISHED")
		Player.range_move = 30
		var txcolor = "[color=#ffff00]"
		if StateWorld.type != "path":
			ToolMessageCreator.add_message(txcolor, "섬멸!")
			
		
		
		for buff in Player.Buffs:
			if buff.name == "Entangle":
				var action = {
					"name": "remove_buff", 
					"target": Player, 
					"buff": buff, 
					"msg": "적 처치"
		}
				ProcessQueue.add_effect(action)
				ToolMessageCreator.add_message("[color=#707070]", "[color=#60af20]덩굴[/color]이 풀리기 시작한다...")
			
			if buff.name == "Bleed":
				var action = {
					"name": "remove_buff", 
					"target": Player, 
					"buff": buff, 
					"msg": "적 처치"
		}
				ProcessQueue.add_effect(action)
				ToolMessageCreator.add_message("[color=#707070]", "[color=#ff1010]출혈[/color]이 멎기 시작한다...")
		
		
		
		
		floor_cleared = true
	

func fade_in():
	if $UI / Label.visible == false:
		$UI / FadeIn.fade_in()

func initiate():
	Global.game = get_node(".")
	ProcessQueue.game = get_node(".")
	ProcessQueue.TimerNode = $Timer
	ProcessFight.game = get_node(".")
	ProcessText.game = get_node(".")
	
	if StateWorld.type == "path":
		floor_cleared = true
		Global.universal.deck.index_x = 4
		Global.universal.deck.index_y = 0
		$Gamepad_help.modulate = Color(0, 0, 0, 0)


func place_player():
	open_tiles = []
	for t in Global.Tile_Ground.size():
		if tile_exit != null and Global.Tile_Ground[t].resident == null and Global.Tile_Ground[t].type != Global.Tile_Type.STAIRS:
			if calcrange.tile_is_in_range(Global.Tile_Ground[t], tile_exit, 4) == false:
				open_tiles.append(Global.Tile_Ground[t])
	

	
	if open_tiles.size() <= 0:
		for t in Global.Tile_Ground.size():
			if Global.Tile_Ground[t].resident == null and Global.Tile_Ground[t].type != Global.Tile_Type.STAIRS:
				open_tiles.append(Global.Tile_Ground[t])

	
	var tiles_neighbor_6 = []
	var tiles_neighbor_5 = []
	var tiles_neighbor_4 = []
	var tiles_neighbor_3 = []
	var tiles_neighbor_2 = []

	for tile in open_tiles:
		if tile.neighbors_wall >= 6:
			tiles_neighbor_6.append(tile)
		elif tile.neighbors_wall == 5:
			tiles_neighbor_5.append(tile)
		elif tile.neighbors_wall == 4:
			tiles_neighbor_4.append(tile)
		elif tile.neighbors_wall == 3:
			tiles_neighbor_3.append(tile)
		elif tile.neighbors_wall == 2:
			tiles_neighbor_2.append(tile)
	
	
	
	if tiles_neighbor_6.size():
		var inta = rng.randi_range(0, tiles_neighbor_6.size() - 1)
		tile_start = tiles_neighbor_6[inta]
	elif tiles_neighbor_5.size():
		var inta = rng.randi_range(0, tiles_neighbor_5.size() - 1)
		tile_start = tiles_neighbor_5[inta]
	elif tiles_neighbor_4.size():
		var inta = rng.randi_range(0, tiles_neighbor_4.size() - 1)
		tile_start = tiles_neighbor_4[inta]
	elif tiles_neighbor_3.size():
		var inta = rng.randi_range(0, tiles_neighbor_3.size() - 1)
		tile_start = tiles_neighbor_3[inta]
	elif tiles_neighbor_2.size():
		var inta = rng.randi_range(0, tiles_neighbor_2.size() - 1)
		tile_start = tiles_neighbor_2[inta]
	else:
		var inta = rng.randi_range(0, open_tiles.size() - 1)
		tile_start = open_tiles[inta]
	
	
	var p = Global.PlayerNode.instance()
	p.position = tile_start.position
	if StateWorld.type == "path":
		p.position = Global.continent.current_tile.position
		p.position.y += Global.continent.position.y
		p.position.x += Global.continent.position.x
	
	tile_start.resident = p
	add_child(p)
	p.residence = tile_start
	Player = p
	Player.initiate()

func place_enemy(type):
	enemy_placed = true
	open_tiles = []
	for t in Global.Tile_Ground.size():
		if Global.Tile_Ground[t].resident == null:
			if calcrange.tile_is_in_range(Global.Tile_Ground[t], Global.Player.residence, 2) == false:
				open_tiles.append(Global.Tile_Ground[t])
	if open_tiles.size() > 0:
		var inta = rng.randi_range(0, open_tiles.size() - 1)
		var e = Global.EnemyNode.instance()
		e.position = open_tiles[inta].position
		open_tiles[inta].resident = e
		add_child(e)
		e.residence = open_tiles[inta]
		e.type = type
		e.initiate()
	
func place_item(item):
	rng.randomize()
	open_tiles = []
	for t in Global.Tile_Ground.size():
		open_tiles.append(Global.Tile_Ground[t])
	if open_tiles.size() > 0:
		var inta = rng.randi_range(0, open_tiles.size() - 1)
		var new_item = cloner.clone_dict(item)
		
		open_tiles[inta].pile.append(new_item)

func place_weapon():
	open_tiles = []
	for t in Global.Tile_Ground.size():
		if Global.Tile_Ground[t].resident == null:
			open_tiles.append(Global.Tile_Ground[t])
	if open_tiles.size() > 0:
		var inta = rng.randi_range(0, open_tiles.size() - 1)
		var r = rng.randi_range(0, LWep.weapons.size() - 1)
		open_tiles[inta].pile.append(LWep.weapons[r])

func place_armor():
	open_tiles = []
	for t in Global.Tile_Ground.size():
		if Global.Tile_Ground[t].resident == null:
			open_tiles.append(Global.Tile_Ground[t])
	if open_tiles.size() > 0:
		var inta = rng.randi_range(0, open_tiles.size() - 1)
		var r = rng.randi_range(0, LArm.armors.size() - 1)
		open_tiles[inta].pile.append(LArm.armors[r])
	
	
	
	
	
	
	
	
	

func place_interior_wall():
	open_tiles = []
	for t in Global.Tile_Ground.size():
		if Global.Tile_Ground[t].resident == null:
			open_tiles.append(Global.Tile_Ground[t])
	var tile = open_tiles[rng.randi_range(0, open_tiles.size() - 1)]
	tile.type = Global.Tile_Type.WALL
	tile.blank = true
	
	tile.create()
	Global.Tile_Ground.erase(tile)
	Global.Tile_Wall.append(tile)

func place_stairs():
	open_tiles = Global.Tile_Ground
	var t = open_tiles[rng.randi_range(0, open_tiles.size() - 1)]
	tile_exit = t
	
	t.type = Global.Tile_Type.STAIRS
	t.create()


func pause_player():
	$UI / PauseRect.mouse_filter = Control.MOUSE_FILTER_STOP
	$PauseLayer / ColorRect.mouse_filter = Control.MOUSE_FILTER_STOP
	paused = true

func unpause_player():
	$UI / PauseRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$PauseLayer / ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$UI.update()
	get_node("GameBars").draw_speed()
	for unit in Global.Enemies:
		unit.draw_speed()
	for unit in Global.Allies:
		if unit != Global.Player:
			unit.draw_speed()
	paused = false


func _on_Timer_timeout():
	if Input.is_action_pressed("tab"):
		auto_buffer += 1
		if auto_buffer >= auto_buffer_max:
			auto_buffer = auto_buffer_max
			if Global.Player != null:
				if float(Global.Player.HP) >= float(Global.Player.HP_max) * 0.2:
					Global.Player.auto_input("tab")
	elif Input.is_action_pressed("gamepad_b"):
		auto_buffer += 1
		if auto_buffer >= auto_buffer_max:
			auto_buffer = auto_buffer_max
			if Global.Player != null:
				if float(Global.Player.HP) >= float(Global.Player.HP_max) * 0.2:
					Global.Player.auto_input("gamepad_b")
	elif Input.is_action_pressed("gamepad_x"):
		auto_buffer += 1
		if auto_buffer >= auto_buffer_max:
			auto_buffer = auto_buffer_max
			if Global.Player != null:
				if float(Global.Player.HP) >= float(Global.Player.HP_max) * 0.2:
					Global.Player.auto_input("gamepad_x")
	elif Input.is_action_pressed("mouse_right"):
		auto_buffer += 1
		if auto_buffer >= auto_buffer_max:
			auto_buffer = auto_buffer_max
			if Global.Player != null:
				if float(Global.Player.HP) >= float(Global.Player.HP_max) * 0.2:
					Global.Player.auto_input("mouse_right")
	elif Input.is_action_pressed("pass"):
		if Global.Enemies.size() > 0:
			auto_buffer += 1
			if auto_buffer >= auto_buffer_max:
				auto_buffer = auto_buffer_max
				if Global.Player != null:
					if float(Global.Player.HP) >= float(Global.Player.HP_max) * 0.2:
						Global.Player.auto_input("pass")
				
	else:
		auto_buffer = 0

func _process(_delta):

	if ProcessQueue.ACTIVE == true and ProcessQueue.PAUSED == false and Global.universal.current_screen_label == "game":
		ProcessQueue.cycle_go_2()
		
	
	


func _on_Timer_Generate_timeout():
	ToolGenerateLevel.tick()


func _on_Button_SWAP_pressed():
	Global.sound.new_sound("Hover")
	var main = Global.Player.weapon_main
	var off = Global.Player.weapon_off
	Global.Player.weapon_main = off
	Global.Player.weapon_off = main
	update_game()



func has_type_title(array, check_type):
	var boola = false
	for type in array:
		if type.title == check_type.title:
			boola = true
	
	return boola

func swap_weapons():
	Global.sound.new_sound("Click")
	var main = cloner.clone_dict(Global.Player.weapon_main)
	var off = cloner.clone_dict(Global.Player.weapon_off)
	Global.Player.weapon_main = off
	Global.Player.weapon_off = main
	Global.Player.update()
	update_game()


func setup_deckbuttons():
	if Global.universal.deck.allowed == true and $UI.get_open_windows().size() == 0 and leveling_up == false:

		Global.universal.deck.index_x = 0
		Global.universal.deck.index_y = 0
	
		
		if StateWorld.type == "path":
			Global.universal.deck.index_x = 4
			Global.universal.deck.index_y = 0
	
	update_deckbuttons()


func update_deckbuttons():
	if Global.universal.deck.allowed == true and $UI.get_open_windows().size() == 0 and leveling_up == false:
		Global.universal.deck.deckbutton_selected = null

		update_deckbuttons_general()
		
		Global.universal.deck.set_first_button()


func update_deckbuttons_general():
	if Global.universal.deck.allowed == true:
		Global.universal.deck.deckbuttons = [[$UI / Button_Inventory2, $UI / Button_Magi], [], [], []]
		for button in $UI / UI_BuffDrawer.buttons:
			Global.universal.deck.deckbuttons[0].append(button)
		
		Global.universal.deck.deckbuttons[0].append($UI / Button_Log)
		Global.universal.deck.deckbuttons[0].append($UI / Button_StartMenu)
		
		
		if Global.Player.is_dead() == false and StateWorld.victorious == false:
			Global.universal.deck.deckbuttons[1].append($UI / Invokes.buttons[0])
	
	
		if Global.Player.is_dead() == false and StateWorld.victorious == false:
			Global.universal.deck.deckbuttons[2].append($UI / Invokes.buttons[1])
		
	
		if Global.Player.is_dead() == false and StateWorld.victorious == false:
			Global.universal.deck.deckbuttons[3].append($UI / Invokes.buttons[2])

		if StateWorld.type == "path":
			
			update_deckbuttons_continent_victory_check()
		else:
			update_deckbuttons_game()
			
		Global.universal.deck.deckbuttons.append([Global.universal.get_node("ButtonAutoLevel")])

func update_deckbuttons_continent_victory_check():
	if Global.Player != null:
		if Global.Player.is_dead() == true or StateWorld.victorious == true:
			for n in 3:
				Global.universal.deck.deckbuttons[1].append($UI / DeathScreen / Button_QuitGame)
			
			Global.universal.deck.index_x = 1
			Global.universal.deck.index_y = Global.universal.deck.deckbuttons[1].size() - 1
			
		else:
			update_deckbuttons_continent()
			
	else:
			Global.universal.deck.index_x = 0
			Global.universal.deck.index_y = Global.universal.deck.deckbuttons[0].size() - 1
	
func update_deckbuttons_continent():
	Global.universal.deck.deckbuttons.append([Global.universal.get_node("Continent").get_node("Swap"), Global.universal.get_node("Continent").get_node("Button_Enter").get_node("Button")])
	
	var x_index = 4
	for button in Global.continent.item_buttons:
		x_index += 1
		if Global.universal.deck.deckbuttons.size() <= x_index:
			Global.universal.deck.deckbuttons.append([])
		Global.universal.deck.deckbuttons[x_index].append(button)
		Global.universal.deck.deckbuttons[x_index].append(Global.universal.get_node("Continent").get_node("Button_Enter").get_node("Button"))
	
	for button in Global.continent.enemy_buttons:
		x_index += 1
		if Global.universal.deck.deckbuttons.size() <= x_index:
			Global.universal.deck.deckbuttons.append([])
		Global.universal.deck.deckbuttons[x_index].append(button)
		Global.universal.deck.deckbuttons[x_index].append(Global.universal.get_node("Continent").get_node("Button_Enter").get_node("Button"))

	Global.universal.deck.deckbuttons.append([Global.universal.get_node("Continent").get_node("Button_Enter").get_node("Button")])

func update_deckbuttons_game():
	
	if Global.Player != null:
		if Global.Player.is_dead() == true or StateWorld.victorious == true:
			for n in 3:
				Global.universal.deck.deckbuttons[1].append($UI / DeathScreen / Button_QuitGame)
			
			Global.universal.deck.index_x = 1
			Global.universal.deck.index_y = Global.universal.deck.deckbuttons[1].size() - 1
			
		else:
			find_deckbuttons_for_player()
			
	else:
			Global.universal.deck.index_x = 0
			Global.universal.deck.index_y = Global.universal.deck.deckbuttons[0].size() - 1
	
	pass

func find_deckbuttons_for_player():
	var gamebuttons = []
	for Tile in Global.Tile_Ground:
		if Tile.resident == Global.Player:
			gamebuttons.append(Tile)
	
		if Tile.visible_to_player:
			if Tile.resident != null:
				if Tile.resident != Global.Player:
					if gamebuttons.has(Tile) == false:
						gamebuttons.append(Tile)
			elif Tile == tile_exit:
				if gamebuttons.has(Tile) == false:
					gamebuttons.append(Tile)
	for Tile in Global.Tile:
		if calcrange.tile_is_in_range(Tile, Global.Player.residence, 1):
			if gamebuttons.has(Tile) == false:
				gamebuttons.append(Tile)
			
			
			
	
	
	var columns = []
	var highest_x = 1
	for button in gamebuttons:
		if button.x > highest_x: highest_x = button.x

	for n in highest_x:
		columns.append([])
	columns.append([])
	
	for button in gamebuttons:
			columns[button.x].append(button)

	
	for column in columns:
		if column.size() == 0:
			columns.erase(column)

	for m in columns.size():
		var column = columns[m]
		var new_column = []
		while new_column.size() < column.size():
			for n in 30:
				for tile in column:
					if tile.y == n:
						new_column.append(tile)
						
		columns[m] = new_column
			
	for n in columns.size():
		for m in columns[n].size():
			var tile = columns[n][m]
			if tile.resident != null:
				if tile.resident != Global.Player:
					columns[n][m] = tile.resident

	
	for n in columns.size():
		var index = n + 4
		for button in columns[n]:
			while index >= Global.universal.deck.deckbuttons.size() - 4:
				Global.universal.deck.deckbuttons.append([])
				
			
			Global.universal.deck.deckbuttons[index].append(button)
			
					
	for array in Global.universal.deck.deckbuttons:
		if array.size() < 1:
			Global.universal.deck.deckbuttons.erase(array)
	
	for n in Global.universal.deck.deckbuttons.size():
		for m in Global.universal.deck.deckbuttons[n].size():
				var tile = Global.universal.deck.deckbuttons[n][m]
				if tile.is_in_group("tile"):
					if tile.resident != null:
						if tile.resident == Global.Player:
							if Global.universal.deck.cursor_on_player == true:
								Global.universal.deck.index_x = n
								Global.universal.deck.index_y = m
					
	
	
