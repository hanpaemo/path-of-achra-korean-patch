extends CanvasLayer


var scroll_offset = 0
var max_messages
var scroll_timer = 0
var is_typing = false
var scene_disabled = false

func _ready():
	var stringa = "[color=#ffff50]" + str(Global.Player.get_name()) + "[/color] " + StatePlayerSheet.title_race + " " + StatePlayerSheet.title_class + " [color=#c0c0c0]-[/color] " + StatePlayerSheet.God.name
	stringa += "\n\n"
	stringa += "[color=#707070]"
	stringa += "[color=#ff5050]" + str(StatePlayerSheet.score_data.game_turns) + "[/color] 게임 턴 경과"
	stringa += "\n\n"
	stringa += "[color=#ffff00]" + str(StatePlayerSheet.score_data.highest_damage) + "[/color]"
	if str(StatePlayerSheet.score_data.highest_damage_type) != "0":
			stringa += " " + str(StatePlayerSheet.score_data.highest_damage_type)
	stringa += " 최대 피해"
	$stats.bbcode_text = stringa
	setup_deckbuttons()

func _process(_delta):
	if $Up.is_pressed() or Input.is_action_pressed("up") or Input.is_action_pressed("wheel_up"):
		if is_typing == false:
			scroll_timer += 1
			if scroll_timer >= 2:
				scroll_timer = 0
				scroll_up()
	elif $Down.is_pressed() or Input.is_action_pressed("down") or Input.is_action_pressed("s") or Input.is_action_pressed("wheel_down"):
		if is_typing == false:
			scroll_timer += 1
			if scroll_timer >= 2:
				scroll_timer = 0
				scroll_down()
	elif ToolSettings.settings_data.gamepad_mode != "none":
		if Input.is_action_pressed("gamepad_a"):
			if is_instance_valid(Global.universal.deck.deckbutton_selected):
				if Global.universal.deck.deckbutton_selected != null:
					if Global.universal.deck.deckbutton_selected == $Down:
						if is_typing == false:
							scroll_timer += 1
							if scroll_timer >= 2:
								scroll_timer = 0
								scroll_down()
					elif Global.universal.deck.deckbutton_selected == $Up:
						if is_typing == false:
							scroll_timer += 1
							if scroll_timer >= 2:
								scroll_timer = 0
								scroll_up()
	else:
		scroll_timer = 0

func write_log():
	
	var array = ToolMessageCreator.message_array
	
	
		
	
	var stringa = ""

	for n in array.size():
		var new_n = n - scroll_offset
		if new_n > - 1 and new_n < array.size():
			stringa += mod_string(array[new_n])
			if new_n < array.size():
				stringa += "\n"
	
	$RichTextLabel.bbcode_text = stringa

func mod_string(stringa):
	if $TextEdit.text != "" and $TextEdit.text != "검색...":
		if $TextEdit.text in textstrip.strip_bbcode(stringa).to_lower():
			stringa = "[color=#ffff00]>[/color]" + stringa
		else:
			stringa = "[color=#505050]" + textstrip.strip_bbcode(stringa) + "[/color]"
	
	return stringa

func close():
	scene_disabled = true
	ProcessQueue.PAUSED = false
	Global.universal.deck.reset_buttons()
	Global.universal.deck.setup_current_screen()
	queue_free()

func _on_Button_Close_pressed():
	close()

func _input(event):
	if scene_disabled == false:
		if event.is_action_pressed("escape") or event.is_action_pressed("g") or event.is_action_pressed("mouse_right"):
			if is_typing == false:
				close()
		if event.is_action_pressed("gamepad_y"):
				if ToolSettings.settings_data.gamepad_mode == "full":
					close()

		if event.is_action_pressed("up"):
			if is_typing == false:
				scroll_up()
		if event.is_action_pressed("down"):
			if is_typing == false:
				scroll_down()
		if event.is_action_pressed("s"):
			if is_typing == false:
				scroll_down()
		if event.is_action_pressed("wheel_up"):
			scroll_up()
		if event.is_action_pressed("wheel_down"):
			scroll_down()
		Global.universal.deck.input_handler(event)

func _on_Button_Close_mouse_entered():
	Global.sound.new_sound("Hover")





func scroll_down():
	if scroll_offset > 0:
		scroll_offset -= 1
		write_log()

func scroll_up():
	if scroll_offset < ToolMessageCreator.message_array.size() - 42:
		scroll_offset += 1
		write_log()

func _on_Down_pressed():
	Global.sound.new_sound("Hover")
	scroll_down()
	
		


func _on_Up_pressed():
	Global.sound.new_sound("Hover")
	scroll_up()


func _on_Down_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Up_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_TextEdit_text_changed(_new_text):
	var caret_location = $TextEdit.caret_position
	$TextEdit.text = $TextEdit.text.to_lower()
	$TextEdit.caret_position = caret_location
	
	write_log()


func _on_TextEdit_focus_entered():
	is_typing = true
	$TextEdit.text = ""


func _on_TextEdit_focus_exited():
	is_typing = false

func setup_deckbuttons():
	Global.universal.deck.deckbutton_selected = null
	Global.universal.deck.index_x = 0
	Global.universal.deck.index_y = 0
	
	Global.universal.deck.deckbuttons = [[$Button_Close], [$Up, $Down]]
	
	Global.universal.deck.set_first_button()
