extends Node2D

var tile_list = []
var current_tile = null
var selected_tile = null
var tileset_data = null
var paused = false
var enemy_buttons = []
var item_buttons = []
var hovered_button = null
var poem_line = proem.get_continent_line()

func _ready():
	Global.continent = get_node(".")
	StateWorld.continent = get_node(".")
	ToolPlayerController.continent = get_node(".")
	tileset_data = loader.load_data("res://Data/Table_Tilesets.json")

func delete():
	current_tile = null
	selected_tile = null
	for tile in tile_list:
		
		tile.queue_free()
		
	
	tile_list = []

func update_marker():
	$Swap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Swap.visible = false
	if current_tile != null:
		$Marker.position = current_tile.position
	if selected_tile != null:
		$Looker.position = selected_tile.position
		if selected_tile == current_tile:
			$Looker.modulate = Color(1, 1, 1, 0)
		else:
			$Looker.modulate = Color(1, 1, 1, 0)
	
	$Button_Enter.modulate = Color(1, 1, 1, 0)
	$Button_Enter.get_node("Button").mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Button_Enter.get_node("Sprite").texture = null
	$Place.texture = null
	if selected_tile != null:
		if selected_tile.data.type != "ocean" and selected_tile.data.type != "void":
			if selected_tile.explored == false:
				if StateWorld.type == "path":
					$Button_Enter.modulate = Color(1, 1, 1, 1)
					$Button_Enter.get_node("Button").mouse_filter = Control.MOUSE_FILTER_STOP
					
					$Button_Enter.position = selected_tile.position
					$Place.texture = load(selected_tile.data.sprite)
	
	
		
		
			
			
			
	
	
	for tile in tile_list:
		tile.update_button()
		tile.get_node("Tier").modulate = Color(1, 1, 1, 0)
		tile.get_node("Treasure").modulate = Color(1, 1, 1, 0)
		tile.button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tile.button.modulate = Color(1, 1, 1, 0)
		if tile.x + 1 >= current_tile.x and tile.x - 1 <= current_tile.x:
			if tile.y + 2 >= current_tile.y and tile.y - 2 <= current_tile.y:
				tile.button.mouse_filter = Control.MOUSE_FILTER_STOP
				tile.button.modulate = Color(1, 1, 1, 1)
				if tile.data.type == "ocean" or tile.data.type == "void":
					tile.button.mouse_filter = Control.MOUSE_FILTER_IGNORE
					tile.button.modulate = Color(1, 1, 1, 0)
				
		if tile.explored == true:
				
				tile.button.mouse_filter = Control.MOUSE_FILTER_STOP
				tile.button.modulate = Color(1, 1, 1, 1)
				tile.get_node("Tier").modulate = Color(1, 1, 1, 0)
				tile.get_node("Treasure").modulate = Color(1, 1, 1, 0)
				if tile.data.type == "ocean" or tile.data.type == "void":
					tile.button.mouse_filter = Control.MOUSE_FILTER_IGNORE
					tile.button.modulate = Color(1, 1, 1, 0)
		
		if tile.x <= current_tile.x:
			tile.button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		
			
	if selected_tile.explored == false:
		
		update_hovered_description()
		$Description.bbcode_text = write_description() + " \n\n" + write_description3()
		
		
		$Description2.bbcode_text = write_description2()
	$Date.bbcode_text = write_description_date()
	
	
	if StateWorld.type != "path" or Global.universal.current_screen_label == "start":
		paused = true
		$Swap.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$Swap.visible = false
		get_node(".").modulate = Color(1, 1, 1, 0)
		for tile in tile_list:
			tile.button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		for button in enemy_buttons:
			button.get_node("Button").mouse_filter = Control.MOUSE_FILTER_IGNORE
		for button in item_buttons:
			button.get_node("Button").mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	elif StateWorld.type == "path":
	
		
		get_node(".").modulate = Color(1, 1, 1, 1)
		
			
		paused = false
		if StateWorld.victorious == true:
			$Marker.modulate = Color(1, 1, 1, 0)
		
		
		$Swap.mouse_filter = Control.MOUSE_FILTER_STOP
		$Swap.visible = true
	
	if Global.game != null and Global.Player != null:
		Global.game.update_deckbuttons()
	


func update_hovered_description():
	if hovered_button == null:
		if selected_tile.explored == false:
			$Description.bbcode_text = write_description() + " \n\n" + write_description3()
	elif hovered_button.data.has("sighting") == false:
		$Description.bbcode_text = ""
		for key in hovered_button.data.abilities:
			if key != "none":
				$Description.bbcode_text += LTraitsGeneric.trait_data[key].Description
	else:
		if selected_tile.explored == false:
			$Description.bbcode_text = write_description() + " \n\n" + write_description3()
func write_description_date():
	var stringa = ""
	stringa += "[right][color=#c0c0c0]일차 " + str(StateWorld.day)
	if StateWorld.land == "void":
		stringa += "\n일렁이는 [color=#9000a0]공허[/color]"
	else:
		stringa += "\n[color=#ffff50]아크라[/color]의 땅"
	
	if StateWorld.victorious == false:
		stringa += "\n" + cycler.int_to_cycle_name(ToolSettings.settings_data.cycle_current)
	else:
		stringa += "\n[color=#ff9020]승리![/color]"
	return stringa
	
func write_description():
	var stringa = ""
	
	stringa += "[color=#c0c0c0]"
	if current_tile != selected_tile:
		stringa += "바라보는 대상: " + selected_tile.Name + "..."
		
		
	
	else:
		pass
		
		
		
	
	if StateWorld.victorious == true:
		
		stringa = "광대하고 고요한 어둠이 있다..."
	
	
	
		
	
	return stringa

func write_description3():
	var stringa = ""
	if selected_tile.data.has("danger"):
		if selected_tile.data.danger == true:
			stringa += "[color=#ff5050]금단의 장소... "
	stringa += "[color=#a0a0a0]"
	
	
	for enemy in selected_tile.enemies:
		
		stringa += enemy.rumor + ". "
		
		
				
					
				
					
						
					
					
		
			
		
	
	stringa += "[/color]"
	stringa += "[color=#ff5050]"
	if selected_tile.boss != null:
		var enemy = selected_tile.boss
		stringa += enemy.rumor + ". "
	stringa += "[/color]"
	
	
	stringa += "\n\n[color=#707070]" + poem_line
	
	
	
	
	
	
	
	
	
	if StateWorld.victorious == true:
		stringa = ""
	
	if selected_tile.explored == true:
		stringa = "길을 걷는다..."
	
	return stringa

func write_description2():
	var stringa = "\n"
	
	
	var to_erase = []
	for button in enemy_buttons:
		to_erase.append(button)
	
	for button in to_erase:
		enemy_buttons.erase(button)
		button.queue_free()
	
	to_erase = []
	for button in item_buttons:
		to_erase.append(button)
	for button in to_erase:
		item_buttons.erase(button)
		button.queue_free()
		
	if selected_tile.explored == true:
		pass
		
	elif StateWorld.victorious == false:
		
		var pos = $Enemy_Buttons.position
		
		
		var treasure = false
		var count = 0
		for item in selected_tile.items:
			
			var b = Global.ButtonEnemyCont.instance()
			add_child(b)
			b.position = pos
			pos.x += 32
			var data = cloner.clone_dict(item)
			b.data = data
			b.get_node("Sprite").texture = load(item.sprite)
			b.get_node("Sprite2").visible = true
			
			item_buttons.append(b)
			
			if data.has("tint"):
				if data.tint == true:
					b.get_node("tint").visible = true
			
			if item.rarity > 0:
				
				
				
				
				count += 1
				treasure = true
		
		pos.x += 32
		
		for enemy in selected_tile.enemies:
			var b = Global.ButtonEnemyCont.instance()
			add_child(b)
			b.position = pos
			
			pos.x += 32
			var data = cloner.clone_dict(enemy)
			b.data = data
			if data.has("map_hidden"):
				if data.map_hidden == true:
					b.hidden = true
					b.get_node("Sprite").texture = load("res://Ham_Sprite/UI/Question.png")
				else:
					b.get_node("Sprite").texture = load(enemy.sprite)
			else:
				b.get_node("Sprite").texture = load(enemy.sprite)
			enemy_buttons.append(b)
			
			
			
			
		
		
		if selected_tile.boss != null:
			var enemy = selected_tile.boss
			var b = Global.ButtonEnemyCont.instance()
			add_child(b)
			b.position = pos
			pos.x += 32
			var data = cloner.clone_dict(enemy)
			b.data = data
			if data.has("map_hidden"):
				if data.map_hidden == true:
					b.hidden = true
					b.get_node("Sprite").texture = load("res://Ham_Sprite/UI/QuestionRed.png")
				else:
					b.get_node("Sprite").texture = load(enemy.sprite)
			else:
				b.get_node("Sprite").texture = load(enemy.sprite)
			enemy_buttons.append(b)
			
			
			
			
		
		
		
			
	
	return stringa


func _on_Button_pressed():
	
	enter_tile()

func enter_tile():
	if paused == false and selected_tile.explored == false and selected_tile.data.type != "ocean" and selected_tile.data.type != "void" and StateWorld.type == "path":
		if Global.Player != null:
			if Global.Player.is_dead() == false:
				Global.Player.slide(Global.Player.position, Vector2(selected_tile.position.x + position.x, selected_tile.position.y + position.y))
				Global.sound.new_sound("Wave")
				ToolMessageCreator.hover_info_type = "none"
				current_tile = selected_tile
				update_marker()
				StateWorld.world_new()
				var action = ["new_level"]
				ProcessQueue.queue.append(action)
				ProcessQueue.run_queue()

func spread_ocean():
	poem_line = proem.get_continent_line()
	var x = current_tile.x
	for tile in tile_list:
		if tile.x <= x and tile != current_tile and tile.data.type != "obelisk" and tile.data.type != "astrolith":
			if StateWorld.land == "void":
				tile.data.type = "void"
				
			else:
				tile.data.type = "ocean"
			tile.create()
	if StateWorld.land == "void":
		ToolMessageCreator.add_message("[color=#c0c0c0]", "[color=#9000a0]일렁이는 어둠[/color]이 밀려온다...")
	else:
		ToolMessageCreator.add_message("[color=#c0c0c0]", "[color=#0000ff]바다[/color]가 밀려온다...")


func select_next_tile():
	var x = current_tile.x + 1
	var y = 3
	var next_tiles = []
	var closest_tile = null
	var tower_tile = null
	for tile in tile_list:
		if tile.x == x:
			if tile.explored == false:
				next_tiles.append(tile)
	
	
	
	for tile in next_tiles:
		if tile.y == y:
			closest_tile = tile
	
	for tile in next_tiles:
		if tile.is_tower == true:
			tower_tile = tile
	
	if tower_tile != null:
		selected_tile = tower_tile
		update_marker()
	
	elif closest_tile != null:
		selected_tile = closest_tile
		update_marker()

func get_next_tiles():
	var x = current_tile.x + 1
	var next_tiles = []
	
	for tile in tile_list:
		if tile.x == x:
			if tile.explored == false:
				if tile.data.type != "void" and tile.data.type != "ocean":
					next_tiles.append(tile)
	
	return next_tiles

func tab_next_tile():
	var x = current_tile.x + 1
	var y = 3
	var next_tiles = []
	var closest_tile = null
	
	next_tiles = get_next_tiles()
	
		
			
				
					
					
	
	for tile in next_tiles:
		
		
		if current_tile.x < x:
			if tile.x == x and tile.y == y:
				closest_tile = tile

	var inta = 0
	if selected_tile != null:
		if next_tiles.has(selected_tile):
			for n in next_tiles.size():
				if next_tiles[n] == selected_tile:
					inta = n
	
	if next_tiles.size() > 1:
		if inta == next_tiles.size() - 1:
			closest_tile = next_tiles[0]
		else:
			closest_tile = next_tiles[inta + 1]
	elif next_tiles.size() == 1:
		closest_tile = next_tiles[0]
		
	if closest_tile != null:
		selected_tile = closest_tile
		if next_tiles.size() > 1:
			update_marker()
		
			
				
	


func _on_Button_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Swap_mouse_entered():
	Global.sound.new_sound("Hover")
	ToolMessageCreator.hover_info_type = "SwapCont"
	ToolMessageCreator.hover_info = {
		"title": "SwapCont"
	}
	ToolMessageCreator.update()


func _on_Swap_mouse_exited():
	ToolMessageCreator.hover_info = null
	ToolMessageCreator.hover_info_type = "none"
	ToolMessageCreator.update()


func _on_Swap_pressed():
	if StateWorld.type == "path":
		tab_next_tile()
