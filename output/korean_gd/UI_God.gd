extends Node2D

onready var invoke_data = loader.load_data("res://Data/Table_Invokes.json")



onready var game = Global.game
onready var ui = game.get_node("UI")
onready var god = StatePlayerSheet.God
var invoke1 = null
var invoke2 = null
var invoke3 = null
var selected_invoke = 0
var hovered_invoke = 0


func _ready():
	pass
	

func initiate():
	for window in ui.get_open_windows():
		window.close()
	ui.window_god = get_node(".")
	$CloseSprite.texture = load(god.sprite)
	update()

func update():
	$Description.bbcode_text = write_description()
	$Sprite_God.texture = load(god.sprite)
	$Title.bbcode_text = god.name
	
	draw_invokes()

func draw_invokes():
	$Ivocations / Button_Trait / Sprite.texture = load(LTraitsGeneric.trait_data[god.trait].sprite)
	if god.invoke_1 != "none":
		invoke1 = invoke_data[god.invoke_1]
		$Ivocations / Button_Invoke1 / Sprite.texture = load(invoke1.sprite)
	if god.invoke_2 != "none":
		invoke2 = invoke_data[god.invoke_2]
		$Ivocations / Button_Invoke2 / Sprite.texture = load(invoke2.sprite)
	if god.invoke_3 != "none":
		invoke3 = invoke_data[god.invoke_3]
		$Ivocations / Button_Invoke3 / Sprite.texture = load(invoke3.sprite)
	
	highlight_invokes()

func highlight_invokes():
	match selected_invoke:
		0:
			$Ivocations / Select.position = $Ivocations / Button_Trait.rect_position
		1:
			$Ivocations / Select.position = $Ivocations / Button_Invoke1.rect_position
		2:
			$Ivocations / Select.position = $Ivocations / Button_Invoke2.rect_position
		3:
			$Ivocations / Select.position = $Ivocations / Button_Invoke3.rect_position
			
	match hovered_invoke:
		0:
			$DescriptionFocus.bbcode_text = write_description_trait(LTraitsGeneric.trait_data[god.trait])
		1:
			$DescriptionFocus.bbcode_text = write_invoke_description(invoke1)
		2:
			$DescriptionFocus.bbcode_text = write_invoke_description(invoke2)
		3:
			$DescriptionFocus.bbcode_text = write_invoke_description(invoke3)


func write_invoke_description(invoke):
	var string = ""
	$Sprite_Selected.texture = null
	if invoke != null:
		string += invoke.name
		if Global.Player.level < invoke.level_required:
			string += "\n\n[color=#ff6c64]필요 영광 "
			string += str(invoke.level_required) + "[/color]"
		string += "\n\n[color=#78bca4]"
		string += str(invoke.use_max)
		string += "[/color]"
		string += " 최대 [color=#78bca4]충전[/color]\n\n"
		string += invoke.description
		
		if invoke.infpen == true:
			$infpen.texture = load("res://Ham_Sprite/UI/Info/inflex.png")
		else:
			$infpen.texture = null
		
		$Sprite_Selected.texture = load(invoke.sprite)
	return string


func write_description_trait(trait):
	var stringa = ""
	stringa += trait.Name
	stringa += "\n\n[color=#c0c0c0]특성[/color]"
	stringa += "\n\n" + trait.Description
	if trait.infpen == true:
		$infpen.texture = load("res://Ham_Sprite/UI/Info/inflex.png")
	else:
		$infpen.texture = null
	$Sprite_Selected.texture = load(trait.sprite)
	return stringa

func write_description():
	var stringa = ""
	stringa += god.prayer
	stringa += "\n\n--\n\n"
	stringa += god.description
	
	
	

	
	return stringa

func close():
	ui.window_god = null
	queue_free()

func _input(event):
	if event.is_action_pressed("escape"):
		close()

func _on_Button_Close_pressed():
	close()


func _on_Button_Powers_pressed():
	ui.open_traits()


func _on_Button_Inventory_pressed():
	ui.open_inventory()


func _on_Button_Invoke2_pressed():
	Global.sound.new_sound("Hover")
	selected_invoke = 2
	highlight_invokes()


func _on_Button_Invoke3_pressed():
	Global.sound.new_sound("Hover")
	selected_invoke = 3
	highlight_invokes()

func _on_Button_Invoke1_pressed():
	Global.sound.new_sound("Hover")
	selected_invoke = 1
	highlight_invokes()


func _on_Button_Close_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Button_Powers_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Button_Inventory_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Button_Invoke1_mouse_entered():
	hovered_invoke = 1
	Global.sound.new_sound("Hover")
	highlight_invokes()


func _on_Button_Invoke2_mouse_entered():
	hovered_invoke = 2
	Global.sound.new_sound("Hover")
	highlight_invokes()


func _on_Button_Invoke3_mouse_entered():
	hovered_invoke = 3
	Global.sound.new_sound("Hover")
	highlight_invokes()


func _on_Button_Invoke1_mouse_exited():
	hovered_invoke = selected_invoke
	highlight_invokes()


func _on_Button_Invoke2_mouse_exited():
	hovered_invoke = selected_invoke
	highlight_invokes()


func _on_Button_Invoke3_mouse_exited():
	hovered_invoke = selected_invoke
	highlight_invokes()


func _on_Button_Trait_pressed():
	Global.sound.new_sound("Hover")
	selected_invoke = 0
	highlight_invokes()


func _on_Button_Trait_mouse_entered():
	hovered_invoke = 0
	Global.sound.new_sound("Hover")
	highlight_invokes()


func _on_Button_Trait_mouse_exited():
	hovered_invoke = selected_invoke
	highlight_invokes()
