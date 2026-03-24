extends Node2D

var resident = null
var blank = false
var type = 0
var x = 0
var y = 0
var coordinates
var pile = []
var game = null
var Player = null
var rng = RandomNumberGenerator.new()
var id = 0
var id_all = - 1
var id_ground = - 1
var connections = []
var neighbors = []
var tileset = null
var alt_tile = false
var alt_tileset = null
var entering_stairs = false

var visible_to_player = true


var neighbors_wall = 0

var object_type = "tile"

onready var button = $Button


func _process(_delta):
	if Global.universal.deck.allowed == true:
		$purp.visible = false
		if Global.universal.deck.deckbutton_selected == self:
			$purp.visible = true
		elif resident != null:
			if Global.universal.deck.deckbutton_selected == resident:
				$purp.visible = true
	else:
		$purp.visible = false
			


func create():
	rng.randomize()
	game = get_parent()
	tileset = StateWorld.tileset
	if alt_tile == true and alt_tileset != null and type != Global.Tile_Type.WALL:
		tileset = alt_tileset
	position = Vector2((x * Global.Tile_Size) + Global.game_offset_x, (y * Global.Tile_Size) + Global.game_offset_y)
	
	var count = 0
	for neighbor in neighbors:
		if neighbor.type == Global.Tile_Type.WALL and neighbor.blank == false:
			count += 1
	
	neighbors_wall = count
	
	
	update_type()
	
		
func update_type():
	if type == Global.Tile_Type.GROUND or type == Global.Tile_Type.STAIRS:
		if Global.Tile_Ground.has(get_node(".")) == false:
			Global.Tile_Ground.append(get_node("."))
		if Global.Tile_Wall.has(get_node(".")) == true:
			Global.Tile_Wall.erase(get_node("."))
		var r = rng.randi_range(1, 3)
		if r == 3:
			$Sprite.texture = load("res://Ham_Sprite/Environment/" + tileset.ground_a + ".png")
		else:
			$Sprite.texture = load("res://Ham_Sprite/Environment/" + tileset.ground_b + ".png")
		add_to_group("floor")
	if type == Global.Tile_Type.STAIRS:
		$feature.texture = load("res://Ham_Sprite/Environment/" + tileset.stairs + ".png")
	if type == Global.Tile_Type.WALL:
		if Global.Tile_Wall.has(get_node(".")) == false:
			Global.Tile_Wall.append(get_node("."))
		if Global.Tile_Ground.has(get_node(".")) == true:
			Global.Tile_Ground.erase(get_node("."))
		button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.modulate = Color(0, 0, 0, 0)
		add_to_group("wall")
		var r = rng.randi_range(1, 3)
		if r == 3:
			$Sprite.texture = load("res://Ham_Sprite/Environment/" + tileset.wall_a + ".png")
		else:
			$Sprite.texture = load("res://Ham_Sprite/Environment/" + tileset.wall_b + ".png")
		if blank == true:
			$Sprite.texture = null
		
		

func update():
	$Glitter.visible = false
	$Glitter.modulate = Color(1, 1, 1, 1)
	var in_los = true
	modulate = Color(1, 1, 1, 1)
	if resident != null:
		resident.modulate = Color(1, 1, 1, 1)
	$Button.mouse_filter = Control.MOUSE_FILTER_STOP
	$Button.modulate = Color(1, 1, 1, 1)
	$Button_Interact.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Button_Interact.modulate = Color(0, 0, 0, 0)
	if type == Global.Tile_Type.WALL:
		$Button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$Button.modulate = Color(0, 0, 0, 0)
		pass
	elif type == Global.Tile_Type.STAIRS:
		
		
		if Global.Enemies.size() == 0:
			$Glitter.visible = true
		
	elif resident != null:
		if resident.object_type == "player":
			if resident.is_dead() == true:
				$Grave.visible = true
			
			
	elif pile.size() > 0:
		
		
		if Global.Enemies.size() == 0:
			$Glitter.visible = true
			$Glitter.modulate = Color(1, 1, 0.5, 1)
	else:
		$Button.mouse_filter = Control.MOUSE_FILTER_STOP
		$Button.modulate = Color(1, 1, 1, 1)
	

	if pile.size() < 1:
		$pile.texture = null
	else:
		$pile.texture = load("res://Ham_Sprite/UI/Bag.png")
	
	var p = game.Player
	var tile_start = p.residence
	var tile_end = get_node(".")
	var tile_range = 30
	
	if Global.Enemies.size() > 0 and resident != Global.Player and type != Global.Tile_Type.WALL and calcrange.tile_is_in_range_unblocked(tile_start, tile_end, tile_range) == false:
		var can_see = false
		for ally in Global.Allies:
			if ally != Global.Player:
				if ally.residence != null:
					if ally.residence.neighbors.has(self) or ally.residence == self:
						can_see = true
		if can_see == false:
			in_los = false
			$Button.mouse_filter = Control.MOUSE_FILTER_IGNORE
			$Button.modulate = Color(0, 0, 0, 0)
			$Button_Interact.mouse_filter = Control.MOUSE_FILTER_IGNORE
			$Button_Interact.modulate = Color(0, 0, 0, 0)
			modulate = Color(0.3, 0.3, 0.3, 1)
			if resident != null:
				if resident != Global.Player:
					if resident.object_type == "ally":
						resident.modulate = Color(0.3, 0.3, 0.3, 1)
					else:
						resident.modulate = Color(1, 1, 1, 0)
					resident.get_node("Button").mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	if Global.Enemies.size() > 0 and type == Global.Tile_Type.WALL:
		if Global.Player != null:
			if Global.Player.residence != null:
				if calcrange.tile_is_in_range_unblocked(tile_end, tile_start, tile_range) == false:
					modulate = Color(0.3, 0.3, 0.3, 1)
	
	if resident != null and in_los == true:
		
		if resident.object_type == "enemy":
			var weapon = p.weapon_main
			
			resident.get_node("Button").mouse_filter = Control.MOUSE_FILTER_STOP
			tile_range = p.get_range_attack(weapon)
			if calcrange.tile_is_in_range_unblocked(tile_start, tile_end, tile_range) == true:
				resident.get_node("Button").modulate = Color(1, 0, 0, 1)
				
			else:
				resident.get_node("Button").modulate = Color(0.8, 0.5, 0.5, 1)
				
				
				
		
		if resident.object_type == "ally":
			resident.get_node("Button").mouse_filter = Control.MOUSE_FILTER_STOP
			tile_range = p.range_move
			if calcrange.tile_is_in_range(tile_start, tile_end, tile_range) == true:
				
				resident.get_node("Button").modulate = Color(1, 1, 0, 1)
				
			else:
				resident.get_node("Button").modulate = Color(0.8, 0.8, 0.5, 1)
				
				
				
				
	
	visible_to_player = in_los
		

func pickup_pile():
	if pile.size() >= 1:
		if Global.Player != null:
			if resident == Global.Player:
				var to_erase = []
				var to_display = []
				for item in pile.size():
					if Global.Player.bag.size() < Global.bagsize:
						var picked_item = cloner.clone_dict(pile[item])
						event_pickup.check(picked_item)
					
						var apoint = Global.Player.get_global_position()
						var atext = picked_item["name"]
						atext = "[color=#808080]획득: [/color]" + atext
						var color = "[color=#ffffff]"
						
						ToolMessageCreator.add_message(color, atext)
						Global.Player.bag.append(picked_item)
						to_erase.append(pile[item])
						to_display.append(cloner.clone_dict(picked_item))
					else:
						var apoint = Global.Player.get_global_position()
						var atext = "가방이 가득 참"
						var color = "[color=#a0a0a0]"
						ProcessText.spawn_text_popup(apoint, atext, color)
						ToolMessageCreator.add_message(color, atext)
				if to_display.size() > 0:
					item_popup(to_display)
				for item in to_erase:
					pile.erase(item)
				
				Global.Player.update()
				update()


func item_popup(item_array):
	for item in item_array:
		var action = {
				"name": "display_item", 
				"item": cloner.clone_dict(item)
			}
		ProcessQueue.add_effect(action)
		ProcessQueue.ACTIVE = true
		ProcessQueue.cycle_go()

func flash_tween():
	
	pass


		
func _on_Button_pressed():
	print("Button pressed")
	if Global.Player != null:
		if Global.Player.is_dead() == false and StateWorld.victorious == false:
			if Global.game.paused == false:
				if ProcessQueue.PAUSED == false and ProcessQueue.ACTIVE == false:
					if resident == Global.Player and type == Global.Tile_Type.STAIRS:
						enter()
					else:
						pressed()
					

func enter():
	Player = Global.Player
	
	if resident == Player and type == Global.Tile_Type.STAIRS and ProcessQueue.queue == []:
		entering_stairs = true
		var action = ["new_level"]
		ProcessQueue.queue.append(action)
		ProcessQueue.run_queue()

func pressed():
	
	print("TILE PRESSED!")
	Player = Global.Player
	
	print(calcrange.get_range_between_tiles(Player.residence, get_node(".")))

	if entering_stairs == false and ProcessQueue.queue == [] and Global.Tile_Ground.has(self):
		if resident == Player:
			pickup_pile()
		var tile_start = Player.residence
		var tile_end = get_node(".")
		var tile_range = Player.range_move
		if resident == Player:
			
			var action = ["player_move", tile_start, tile_end, tile_range]
			ProcessQueue.queue.append(action)
			ProcessQueue.run_queue()
		elif ToolCalculateRange.tile_is_in_range(tile_start, tile_end, tile_range):
			
			
			
			var action = ["player_move", tile_start, tile_end, tile_range]
			ProcessQueue.queue.append(action)
			ProcessQueue.run_queue()
		else:
			
			
			var tile_target = ToolPathfinding.new_path(tile_start, tile_end)
			if tile_target != null:
				var action = ["player_move", tile_start, tile_target, tile_range]
				ProcessQueue.queue.append(action)
				ProcessQueue.run_queue()
			else:
				tile_end = Player.residence
				var action = ["player_move", tile_start, tile_end, tile_range]
				ProcessQueue.queue.append(action)
				ProcessQueue.run_queue()
	

func clear_buttons():
	button.modulate = Color(0, 0, 0, 0)
	button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if resident != null:
		if resident != game.Player:
			resident.get_node("Button").modulate = Color(0, 0, 0, 0)
	

func _on_Button_Interact_pressed():
	print("Button INTERACT pressed")
	if Global.Player != null:
		if Global.Player.is_dead() == false and StateWorld.victorious == false:
			if Global.game.paused == false:
				if ProcessQueue.PAUSED == false and ProcessQueue.ACTIVE == false:
					if resident == Global.Player and type == Global.Tile_Type.STAIRS:
						enter()
					else:
						pressed_interact()
					
	

func pressed_interact():

	Player = Global.Player
	
	if entering_stairs == false and ProcessQueue.queue == [] and Global.Tile_Ground.has(self):
		if resident == Player:
			pickup_pile()
		var tile_start = Player.residence
		var tile_end = get_node(".")
		var tile_range = Player.range_move
		if resident == Player:
			
			var action = ["player_move", tile_start, tile_end, tile_range]
			ProcessQueue.queue.append(action)
			ProcessQueue.run_queue()
		elif ToolCalculateRange.tile_is_in_range(tile_start, tile_end, tile_range):
			
			
			
			var action = ["player_move", tile_start, tile_end, tile_range]
			ProcessQueue.queue.append(action)
			ProcessQueue.run_queue()
		else:
			
			var tile_target = ToolPathfinding.new_path(tile_start, tile_end)
			if tile_target != null:
				
				var action = ["player_move", tile_start, tile_target, tile_range]
				ProcessQueue.queue.append(action)
				ProcessQueue.run_queue()
			else:
				tile_end = Player.residence
				var action = ["player_move", tile_start, tile_end, tile_range]
				ProcessQueue.queue.append(action)
				ProcessQueue.run_queue()
		
	

func _on_Button_mouse_entered():
	Global.sound.new_sound("Hover")
	
	
	ToolMessageCreator.hover_info = get_node(".")
	ToolMessageCreator.hover_info_type = "feature"
	if resident == Global.Player:
		game.update_range_indicators()
	ToolMessageCreator.update()

func _on_Button_mouse_exited():
	ToolMessageCreator.hover_info = null
	ToolMessageCreator.hover_info_type = "none"
	if resident == Global.Player:
		game.update_range_indicators()
	ToolMessageCreator.update()

func _on_Button_Interact_mouse_entered():
	Global.sound.new_sound("Hover")
	ToolMessageCreator.hover_info = get_node(".")
	ToolMessageCreator.hover_info_type = "feature"
	if resident == Global.Player:
		game.update_range_indicators()
	ToolMessageCreator.update()


func _on_Button_Interact_mouse_exited():
	ToolMessageCreator.hover_info = null
	ToolMessageCreator.hover_info_type = "none"
	if resident == Global.Player:
		game.update_range_indicators()
	ToolMessageCreator.update()



