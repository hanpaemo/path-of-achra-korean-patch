extends Node2D






func write_display():
	visible = true
	$Button.mouse_filter = Control.MOUSE_FILTER_STOP
	
	var stringa = "[center]"
	
	
	
	match Global.summon_order:
		"attack":
			$Sprite.modulate = Color(0.8, 0.5, 0.5)
			stringa += "[color=#ff5050]공격[/color]"
			
		"hold":
			$Sprite.modulate = Color(0.8, 0.8, 0.5)
			stringa += "[color=#ffff50]대기[/color]"
			
	stringa += " "
	stringa += "[color=#b050b0]" + str(Global.get_allies_size_minus_familiars() - 1) + "[/color]"
	stringa += " [color=#707070]/" + str(Global.Player.get_summon_limit())
	stringa += " [color=#703080]+" + str(Global.Allies.size() - Global.get_allies_size_minus_familiars()) + "[/color]"
	
	
	
	
		
	$Label.bbcode_text = stringa



func toggle_order():
	if Global.summon_order == "attack":
		Global.summon_order = "hold"
	else:
		Global.summon_order = "attack"


func update():
	visible = false
	$Button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if Global.Player != null:
		if Global.Allies.size() > 1:
			write_display()


func press_check():
		if Global.game.paused == false:
				if ProcessQueue.PAUSED == false and ProcessQueue.ACTIVE == false:
					if get_parent().get_node("UI").get_open_windows().size() == 0:
						if get_parent().get_node("UI").get_node("UI_Enemies").is_open == false:
							Global.sound.new_sound("Hover")
							toggle_order()
							update()

func _on_Button_pressed():
	
	press_check()


func _on_Button_mouse_entered():
	Global.sound.new_sound("Hover")
	ToolMessageCreator.hover_info = {}
	ToolMessageCreator.hover_info_type = "order"
	ToolMessageCreator.update()


func _on_Button_mouse_exited():
	ToolMessageCreator.hover_info = null
	ToolMessageCreator.hover_info_type = "none"
	ToolMessageCreator.update()
