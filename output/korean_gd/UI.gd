extends CanvasLayer

var game = null
var menu_shown = false
var window_inventory = null
var window_traits = null
var window_prestige = null
var window_god = null

func _ready():
	$Button_God.modulate = Color(1, 1, 1, 0)
	$Button_Magi.modulate = Color(1, 1, 1, 0)
	$Button_Inventory2.modulate = Color(1, 1, 1, 0)

	$Messages.visible = Modes.messages_visible
	
	
	$Floor / Sprite.texture = load("res://Ham_Sprite/World/" + StateWorld.tileset.world_icon + ".png")
	
	if StateWorld.type != "path":
		var floorstring = ""
		floorstring += str(StateWorld.Floor_Current)
		floorstring += "-"
		floorstring += str(StateWorld.Floor_Max)
		$Floor / Label.text = floorstring
	else:
		$Floor.visible = false

func _process(_delta):
	if Global.trait_glow == true:
		$Button_Magi / AnimatedSprite.visible = true
	else:
		$Button_Magi / AnimatedSprite.visible = false

	if Global.inv_glow == true:
		$Button_Inventory2 / AnimatedSprite.visible = true
	else:
		$Button_Inventory2 / AnimatedSprite.visible = false


func initiate():
	

	
	$UI_Enemies.initiate()
	$Button_God / Sprite.texture = load(StatePlayerSheet.God.sprite)
	game = Global.game
	$FadeOut.fade_out()
	$Button_God.modulate = Color(1, 1, 1, 1)
	$Button_Magi.modulate = Color(1, 1, 1, 1)
	$Button_Log.visible = true
	$Button_Inventory2.modulate = Color(1, 1, 1, 1)
	
		
		
		

func get_open_windows():
	var array = []
	if window_inventory != null:
		array.append(window_inventory)
	if window_traits != null:
		array.append(window_traits)
	if window_god != null:
		array.append(window_god)
	if window_prestige != null:
		array.append(window_prestige)
	return array

func update():

	var stringa = "[color=#ffff50]" + str(Global.Player.get_name()) + "[/color] " + StatePlayerSheet.title_race + " " + StatePlayerSheet.title_class + " [color=#c0c0c0]-[/color] " + StatePlayerSheet.God.name
	
	
	
	$Info.bbcode_text = stringa
	
	get_parent().get_node("GameBars").update_bars()
	get_parent().get_node("SummonButton").update()
	if StateWorld.land == "dust":
		$Button_Cycle.visible = true
		$Button_Cycle.mouse_filter = Control.MOUSE_FILTER_STOP
		$Button_Cycle / Label.text = "" + str(StateWorld.Floor_Current)
	
	
	if Global.Player.POINTS_TRAITS > 0:
		$PowerPoints.bbcode_text = "+" + str(Global.Player.POINTS_TRAITS)
	else:
		$PowerPoints.bbcode_text = ""
		
	
	update_invokes()
	game.update_deckbuttons()
	

func update_invokes():
	$Invokes.update()

	
func open_inventory():
	
				
					
						
							Global.inv_glow = false
	
							var u = Global.UIInv.instance()
							Global.sound.new_sound("Hover")
							add_child(u)
							u.initiate()

func open_prestige():
	var u = Global.UIPrestige.instance()
	Global.sound.new_sound("Hover")
	add_child(u)
	u.initiate()

func open_traits():
	
				
					
						
							Global.trait_glow = false
	
							var u = Global.UITraits.instance()
							Global.sound.new_sound("Hover")
							add_child(u)
							u.initiate()

func open_god():
	var u = Global.UIGod.instance()
	Global.sound.new_sound("Hover")
	add_child(u)
	u.initiate()

func _on_Button_StartMenu_pressed():
	show_menu()

func show_menu():
	if Global.game.paused == false:
				if ProcessQueue.PAUSED == false and ProcessQueue.ACTIVE == false:
					if get_open_windows().size() == 0:
						if get_node("UI_Enemies").is_open == false:
							Global.sound.new_sound("Hover")
							var d = Global.UIMenu.instance()
							add_child(d)
							d.write_menu("game")
							ProcessQueue.PAUSED = true


func show_log():
	if Global.game.paused == false:
				if ProcessQueue.PAUSED == false and ProcessQueue.ACTIVE == false:
					if get_open_windows().size() == 0:
						if get_node("UI_Enemies").is_open == false:
							Global.sound.new_sound("Hover")
							var d = Global.UILog.instance()
							add_child(d)
							d.write_log()
							ProcessQueue.PAUSED = true

func spawn_display(data, type):
	Global.sound.new_sound("Hover")
	var d = Global.UIPopup.instance()
	Global.game.get_node("PauseLayer").add_child(d)
	d.data = data
	d.type = type
	d.create_display()
	ProcessQueue.PAUSED = true



func _on_Button_Magi_pressed():
	if Global.game.paused == false:
				if ProcessQueue.PAUSED == false and ProcessQueue.ACTIVE == false:
					if get_open_windows().size() == 0:
						if get_node("UI_Enemies").is_open == false:
							open_traits()


func _on_Button_Inventory2_pressed():
	if Global.game.paused == false:
				if ProcessQueue.PAUSED == false and ProcessQueue.ACTIVE == false:
					if get_open_windows().size() == 0:
						if get_node("UI_Enemies").is_open == false:
							open_inventory()


func _on_Button_God_pressed():
	open_god()


func _on_Hide_Messages_pressed():
	if Modes.messages_visible == true:
		Modes.messages_visible = false
	else:
		Modes.messages_visible = true
	$Messages.visible = Modes.messages_visible


func _on_Button_Inventory2_mouse_entered():
	Global.sound.new_sound("Hover")
	ToolMessageCreator.hover_info = {}
	ToolMessageCreator.hover_info_type = "inventory"
	ToolMessageCreator.update()


func _on_Button_Magi_mouse_entered():
	Global.sound.new_sound("Hover")
	ToolMessageCreator.hover_info = {}
	ToolMessageCreator.hover_info_type = "powers"
	ToolMessageCreator.update()


func _on_Button_God_mouse_entered():
	Global.sound.new_sound("Hover")
	


func _on_Button_StartMenu_mouse_entered():
	Global.sound.new_sound("Hover")
	ToolMessageCreator.hover_info = {}
	ToolMessageCreator.hover_info_type = "menu"
	ToolMessageCreator.update()


func _on_Button_SWAP_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Button_Log_mouse_entered():
	Global.sound.new_sound("Hover")
	ToolMessageCreator.hover_info = {}
	ToolMessageCreator.hover_info_type = "log"
	ToolMessageCreator.update()


func _on_Button_Log_pressed():
	show_log()





func _on_Button_Log_mouse_exited():
	ToolMessageCreator.hover_info = null
	ToolMessageCreator.hover_info_type = "none"
	ToolMessageCreator.update()


func _on_Button_StartMenu_mouse_exited():
	ToolMessageCreator.hover_info = null
	ToolMessageCreator.hover_info_type = "none"
	ToolMessageCreator.update()


func _on_Button_Inventory2_mouse_exited():
	ToolMessageCreator.hover_info = null
	ToolMessageCreator.hover_info_type = "none"
	ToolMessageCreator.update()


func _on_Button_Magi_mouse_exited():
	ToolMessageCreator.hover_info = null
	ToolMessageCreator.hover_info_type = "none"
	ToolMessageCreator.update()


func _on_ButtonLifeBar_mouse_entered():
	Global.sound.new_sound("Hover")
	ToolMessageCreator.hover_info = {}
	ToolMessageCreator.hover_info_type = "life"
	ToolMessageCreator.update()


func _on_ButtonLifeBar_mouse_exited():
	ToolMessageCreator.hover_info = null
	ToolMessageCreator.hover_info_type = "none"
	ToolMessageCreator.update()


func _on_ButtonGloryBar_mouse_entered():
	Global.sound.new_sound("Hover")
	ToolMessageCreator.hover_info = {}
	ToolMessageCreator.hover_info_type = "glory"
	ToolMessageCreator.update()


func _on_ButtonGloryBar_mouse_exited():
	ToolMessageCreator.hover_info = null
	ToolMessageCreator.hover_info_type = "none"
	ToolMessageCreator.update()


func _on_MessageButton_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_MessageButton_mouse_exited():
	Global.sound.new_sound("Hover")


func _on_MessageButton_pressed():
	show_log()


func _on_Button_Cycle_mouse_entered():
	Global.sound.new_sound("Hover")
	ToolMessageCreator.hover_info = {}
	ToolMessageCreator.hover_info_type = "cycle"
	ToolMessageCreator.update()


func _on_Button_Cycle_mouse_exited():
	ToolMessageCreator.hover_info = null
	ToolMessageCreator.hover_info_type = "none"
	ToolMessageCreator.update()
