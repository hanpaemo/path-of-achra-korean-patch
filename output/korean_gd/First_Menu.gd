extends Node2D





var scene_disabled = false
var menu_shown = false
var topscreen = null



func _process(_delta):
	menu_shown = Global.options_menu_open
	
	if Input.is_action_pressed("shift"):
		$hiddenbuttonslabel.visible = false
		$hiddenbuttons.visible = true
		$hiddenbuttons / ButtonData.mouse_filter = Control.MOUSE_FILTER_STOP
		$hiddenbuttons / ButtonCharacter.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		$hiddenbuttonslabel.visible = true
		$hiddenbuttons.visible = false
		$hiddenbuttons / ButtonData.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$hiddenbuttons / ButtonCharacter.mouse_filter = Control.MOUSE_FILTER_STOP
		

func _ready():
	$version.text = str(Global.version)
	if Global.export_type == "html":
		$Button2.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$Button2.visible = false

	var enemies = cloner.clone_dict(LEnemies.enemy_data)
	var enemy_sprites = []
	for key in enemies:
		if enemies[key].tier > 0:
			enemy_sprites.append(enemies[key].sprite)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	$Sprite.texture = load(enemy_sprites[rng.randi_range(0, enemy_sprites.size() - 1)])
	
	$Proem.bbcode_text = proem.compose()
	
	var figures = ["1", "2", "3", "4"]
	var figure = figures[Global.rng.randi_range(0, figures.size() - 1)]
	
	
	setup_deckbuttons()

func start():
	if menu_shown == false and scene_disabled == false:
		scene_disabled = true
		Global.universal.transition("start")

func go_graveyard():
	if menu_shown == false and scene_disabled == false:
		scene_disabled = true
		Global.universal.transition("graveyard")

func go_bestiary():
	if menu_shown == false and scene_disabled == false:
		scene_disabled = true
		Global.universal.transition("bestiary")

func go_feats():
	if menu_shown == false and scene_disabled == false:
		scene_disabled = true
		Global.universal.transition("feats")

func go_credits():
	if menu_shown == false and scene_disabled == false:
		scene_disabled = true
		Global.universal.transition("credits")

func go_armory():
	if menu_shown == false and scene_disabled == false:
		scene_disabled = true
		Global.universal.transition("armory")

func quit():
	if menu_shown == false and scene_disabled == false:
		scene_disabled = true
		Global.universal.transition("quit")


func show_menu():
	
	
	if menu_shown == false and scene_disabled == false:
		Global.sound.new_sound("Hover")
		var d = Global.UIMenu.instance()
		$CanvasLayer.add_child(d)
		d.write_menu("start")
		ProcessQueue.PAUSED = true

func _on_Button_pressed():
	start()


func _on_Button_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Menu_pressed():
	show_menu()


func _on_Button2_pressed():
	quit()


func _on_Button2_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Menu_mouse_entered():
	Global.sound.new_sound("Hover")


func _input(event):
	if scene_disabled == false:
		if event.is_action_pressed("enter"):
			start()
		
		if event.is_action_pressed("escape"):
			show_menu()

		Global.universal.deck.input_handler(event)
			

func _on_Button3_pressed():
	go_graveyard()


func _on_Button3_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Proem_mouse_entered():
	pass
	


func _on_Button4_pressed():
	go_feats()


func setup_deckbuttons():
	Global.universal.deck.deckbuttons = [[$Button, $Button3, $Button4, $Button2], [$Menu]]
	Global.universal.deck.deckbutton_selected = null
	Global.universal.deck.index_x = 0
	Global.universal.deck.index_y = 0
	Global.universal.deck.set_first_button()
	



func _on_Button5_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Button5_pressed():
	go_credits()


func _on_ButtonCharacter_pressed():
	ProcessText.spawn_text_popup_context(Vector2(300, 370), "저장된 캐릭터 삭제됨", "[color=#ff5050]", self)
	saveload.saveData(saveload.create_empty_file())


func _on_ButtonData_pressed():
	ProcessText.spawn_text_popup_context(Vector2(300, 370), "모든 데이터 삭제됨", "[color=#ff5050]", self)
	ToolSettings.create_from_default(ToolSettings.create_empty_file())
	graveyard.saveData(graveyard.create_empty_file())
