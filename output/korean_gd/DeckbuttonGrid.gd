extends Node2D


var cursor_on_player = false

var deckbuttons = []
var deckbutton_selected = null
var index_x = 0
var index_y = 0

var cooldown = 1
var cooldown_max = 1

var gamepad_active = false

var allowed = true

func _process(_delta):
	if cooldown < cooldown_max:
		cooldown += 1
	if cursor_on_player == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _ready():
	if allowed == false:
		ToolSettings.settings_data.gamepad_mode = "none"
		ToolSettings.apply_settings()
	
	
		
			
				
				
					


func setup_current_screen():
	Global.universal.current_screen.setup_deckbuttons()



func reset_buttons():
	deckbutton_selected = null
	deckbuttons = []
	index_x = 0
	index_y = 0
	

func reset_selected():
	
	index_x = 0
	index_y = 0
	deckbutton_selected = deckbuttons[index_x][index_y]

func reset_current_selected():
	if index_x >= deckbuttons.size():
		index_x = 0
	if index_y >= deckbuttons[index_x].size():
		index_y = 0
	deckbutton_selected = deckbuttons[index_x][index_y]

func _input(event):
	if event is InputEventMouseButton:
		gamepad_active = false
		cursor_on_player = false
		
		

func set_first_button():
	if index_x > deckbuttons.size() - 1:
		index_x = 0
	if index_y > deckbuttons[index_x].size() - 1:
		index_y = 0
	
	
	if deckbuttons[index_x].size() < 1:
		index_y = 0
		index_x = 0
		
	
	deckbutton_selected = deckbuttons[index_x][index_y]
	if gamepad_active == true:
		move_mouse()

func cycle_deckbutton(x, y):
	gamepad_active = true
	var button = deckbutton_selected
	var buttons = deckbuttons
	
	
	if buttons.size():
		var current_index_x = 0
		var current_index_y = 0
		
		if button == null:
			
			button = buttons[index_x][index_y]
			current_index_x = index_x
			current_index_y = index_y
		
		elif is_instance_valid(button) == false:
			button = buttons[index_x][index_y]
			current_index_x = index_x
			current_index_y = index_y
		
		else:
			var old_button = button
			current_index_x = index_x
			current_index_y = index_y
			
			var attempts = 0
			
			while old_button == button:
				attempts += 1
				if attempts > 1: print("seaching for closest spot...")
				var new_coordinates = new_button(buttons, x, y, current_index_x, current_index_y)
				current_index_x = new_coordinates.x
				current_index_y = new_coordinates.y
				if buttons[current_index_x].size():
					button = buttons[current_index_x][current_index_y]
				if attempts > 20: break
		
			while button == null:
				attempts += 1
				if attempts > 1: print("seaching for non-null...")
				var new_coordinates = new_button(buttons, x, y, current_index_x, current_index_y)
				current_index_x = new_coordinates.x
				current_index_y = new_coordinates.y
				if buttons[current_index_x].size():
					button = buttons[current_index_x][current_index_y]
				if attempts > 20: break
		
		
		index_x = current_index_x
		index_y = current_index_y
		
		if index_x > deckbuttons.size() - 1:
			index_x = 0
		if index_y > deckbuttons[index_x].size() - 1:
			index_y = 0
		
		deckbutton_selected = buttons[current_index_x][current_index_y]
		
		if is_instance_valid(deckbutton_selected) == false:
			index_x = 0
			index_y = 0
			deckbutton_selected = deckbuttons[index_x][index_y]
		

		
		if deckbutton_selected != null and is_instance_valid(deckbutton_selected):
			if deckbutton_selected.is_in_group("tile"):
					cursor_on_player = true
					print("cursor on player")
			elif deckbutton_selected.is_in_group("enemies"):
					cursor_on_player = true
					print("cursor on player")
			elif deckbutton_selected.is_in_group("LevelUp"):
					pass
			else:
				cursor_on_player = false
				print("cursor NOT on player")
		
		move_mouse()

func new_button(buttons, x, y, current_index_x, current_index_y):
				if x != 0:
						current_index_x += x
						if current_index_x >= buttons.size(): current_index_x = 0
						if current_index_x < 0: current_index_x = buttons.size() - 1
						if current_index_y >= buttons[current_index_x].size(): current_index_y = 0
						if current_index_y < 0: current_index_y = buttons[current_index_x].size() - 1

				if y != 0:
				
						current_index_y += y
						if current_index_x >= buttons.size(): current_index_x = 0
						if current_index_y >= buttons[current_index_x].size(): current_index_y = 0
						if current_index_y < 0: current_index_y = buttons[current_index_x].size() - 1
				
				
				
				return Vector2(current_index_x, current_index_y)

func input_handler(event):
	if cooldown >= cooldown_max:
		if allowed == true and ToolSettings.settings_data.gamepad_mode != "none":
			do_input(event)
			cooldown = 0
	else:
		pass
		


func move_mouse():
	if is_instance_valid(deckbutton_selected) == false:
		index_x = 0
		index_y = 0
		deckbutton_selected = deckbuttons[index_x][index_y]
	
	if deckbutton_selected != null and is_instance_valid(deckbutton_selected):
		if deckbutton_selected.is_in_group("MiddleMouse"):
			get_viewport().warp_mouse(Vector2(deckbutton_selected.get_global_position().x + 500, deckbutton_selected.get_global_position().y + 500))
			print("MIDDLE MOUSE")
		elif deckbutton_selected.is_in_group("Colors"):
			get_viewport().warp_mouse(Vector2(deckbutton_selected.get_global_position().x + 5, deckbutton_selected.get_global_position().y - 20))
		elif deckbutton_selected.is_in_group("logbuttondown"):
			get_viewport().warp_mouse(Vector2(deckbutton_selected.get_global_position().x + 5, deckbutton_selected.get_global_position().y - 5))
		elif deckbutton_selected.is_in_group("ButtonInfoInv"):
			if deckbutton_selected.in_inventory == true:
				get_viewport().warp_mouse(Vector2(deckbutton_selected.get_global_position().x + 5, deckbutton_selected.get_global_position().y + 10))
			else:
				get_viewport().warp_mouse(Vector2(deckbutton_selected.get_global_position().x + 5, deckbutton_selected.get_global_position().y + 5))
		else:
			get_viewport().warp_mouse(Vector2(deckbutton_selected.get_global_position().x + 5, deckbutton_selected.get_global_position().y + 5))

func do_input(event):
	
	
	if event.is_action_pressed("gamepad_up"):
			cycle_deckbutton(0, - 1)
	if event.is_action_pressed("gamepad_down"):
			cycle_deckbutton(0, 1)
	if event.is_action_pressed("gamepad_left"):
			cycle_deckbutton( - 1, 0)
	if event.is_action_pressed("gamepad_right"):
			cycle_deckbutton(1, 0)
	
	if ToolSettings.settings_data.gamepad_mode == "full":
		if event.is_action_pressed("gamepad_a"):
			gamepad_active = true
			if deckbutton_selected != null:
				
				if deckbutton_selected.is_in_group("tile"):
					cursor_on_player = true
					print("TRUE")
				elif deckbutton_selected.is_in_group("enemies"):
					cursor_on_player = true
					print("TRUE")
				elif deckbutton_selected.is_in_group("LevelUp"):
					pass
				else:
					cursor_on_player = false
					print("FALSE")
				
				if deckbutton_selected.is_in_group("startmenu"):
					deckbutton_selected.get_node("Button_Open").emit_signal("pressed")
				elif deckbutton_selected.is_in_group("ButtonButton"):
					deckbutton_selected.get_node("Button").emit_signal("pressed")
				else:
					deckbutton_selected.emit_signal("pressed")
				
		if event.is_action_pressed("gamepad_b"):
			gamepad_active = true
		if event.is_action_pressed("gamepad_x"):
			gamepad_active = true
		if event.is_action_pressed("gamepad_y"):
			gamepad_active = true
	
		
