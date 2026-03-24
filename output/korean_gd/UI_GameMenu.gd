extends CanvasLayer

var scene_disabled = false
var volmax = 5
var volmin = 0
var saved_label = "game"
var topscreen = null



func _ready():
	Global.options_menu_open = true
	Global.options_menu_open = true
	$version.text = str(Global.version)
	$Colors / Button_Blue / ColorRect.color = Color(0.05, 0, 0.1, 1)
	$Colors / Button_Brown / ColorRect.color = Color(0.1, 0.05, 0, 1)
	$Colors / Button_Green / ColorRect.color = Color(0, 0.1, 0.05, 1)
	$Colors / Button_Red / ColorRect.color = Color(0.2, 0.05, 0.05, 1)
	$Colors / Button_Grey / ColorRect.color = Color(0.15, 0.15, 0.15, 1)
	$Colors / Button_Tan / ColorRect.color = Color(0.05, 0.2, 0.2, 1)
	$Colors / Button_Tan2 / ColorRect.color = Color(0.2, 0.15, 0.05, 1)
	$Colors / Button_Tan3 / ColorRect.color = Color(0.15, 0.05, 0.2, 1)
	setup_deckbuttons("normal")

func quit():
	Global.options_menu_open = false
	scene_disabled = true
	ToolMessageCreator.hover_info_type = "none"
	ToolMessageCreator.update()
	var next_scene = "start"
	ProcessQueue.PAUSED = false
	if StateWorld.type == "path" and StateWorld.land != "dust":
		if Global.Player.is_dead() == false and StateWorld.victorious == false:
			saveload.saveload(saveload.create_player_file())
		else:
			saveload.saveload(saveload.create_empty_file())
			score.build_score_elements()
			if Global.Player.is_dead() == true:
				StatePlayerSheet.score_data["condition"] = "death"
				if ToolSettings.settings_data.winners_only == false:
					graveyard.set_graveyard_add_player()
			elif StateWorld.victorious == true:
				StatePlayerSheet.score_data["condition"] = "victory"
				graveyard.set_graveyard_add_player()
			else:
				StatePlayerSheet.score_data["condition"] = "abandon"
			next_scene = "score"
	else:
		if StateWorld.land != "dust":
			saveload.saveload(saveload.create_empty_file())
		score.build_score_elements()
		if Global.Player.is_dead() == true:
			StatePlayerSheet.score_data["condition"] = "death"
			if StateWorld.land != "dust":
				if ToolSettings.settings_data.winners_only == false:
					graveyard.set_graveyard_add_player()
			
		else:
			StatePlayerSheet.score_data["condition"] = "abandon"
		next_scene = "score"
	
	if StateWorld.land == "dust":
		next_scene = "graveyard"
		graveyard.dust_key(StatePlayerSheet.title_name, StateWorld.Floor_Current)
	
	
	
	
	StatePlayerSheet.clear()
	Global.clear_level_data()
	
	Global.universal.transition(next_scene)
	queue_free()

func close():
	
	if topscreen != null:
		close_topscreen()
	else:
		Global.universal.deck.reset_buttons()
		Global.universal.deck.setup_current_screen()
		ToolSettings.save_settings()
		ProcessQueue.PAUSED = false
		Global.options_menu_open = false
		queue_free()

func _on_Button_Close_pressed():
	ToolSettings.save_settings()
	close()


func _on_Button_Close_mouse_entered():
	Global.sound.new_sound("Hover")




func _on_Button_QuitGame_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Button_QuitGame_pressed():
	quit()



func write_menu(label):
	saved_label = label
	
	match label:
		"game":
			var stringa = ""
			if StateWorld.type != "path":
				$Button_QuitGame / Sprite.texture = load("res://Ham_Sprite/UI/Icon_Class_Firedancer2.png")
				$Button_QuitGame / Sprite.modulate = Color(1, 0, 0, 1)
				stringa = "  [color=#ff4000]포기[/color]"
				stringa += "     [color=#707070]저장하려면 세계 지도에서 나가세요[/color]"
			else:
				$Button_QuitGame / Sprite.texture = load("res://Ham_Sprite/UI/Icon_Class_Firedancer2.png")
				$Button_QuitGame / Sprite.modulate = Color(0, 1, 0, 1)
				stringa = "[color=#00ff00]저장[/color] 후 [color=#ff4000]종료[/color]"
				stringa += ""
			if StateWorld.land == "dust":
				$Button_QuitGame / Sprite.texture = load("res://Ham_Sprite/UI/Icon_Class_Firedancer2.png")
				$Button_QuitGame / Sprite.modulate = Color(1, 0, 0, 1)
				stringa = "  [color=#ff4000]포기[/color]"
				stringa += "     [color=#707070]먼지의 길에서는 저장할 수 없습니다[/color]"
	
			if Global.Player.is_dead() == true or StateWorld.victorious == true:
				$Button_QuitGame / Sprite.texture = load("res://Ham_Sprite/UI/Icon_Class_Firedancer2.png")
				$Button_QuitGame / Sprite.modulate = Color(1, 0, 0, 1)
				stringa = "   [color=#ff4000]종료[/color]"
			
			$Button_QuitGame / Label_Quit.bbcode_text = stringa
	
		"start":
			
			$Button_QuitGame.mouse_filter = Control.MOUSE_FILTER_IGNORE
			$Button_QuitGame.modulate = Color(1, 1, 1, 0)
			$Button_QuitGame / Label_Quit.bbcode_text = ""
			
			Global.universal.deck.deckbuttons[1].erase($Button_QuitGame)
			
			
	
	write_volumes()
	write_options()

func write_volumes():
	var stringa = ""
	stringa = "[color=#5050af]음악[/color]  "
	stringa += translate.get_spaced_lines_from_int(ToolSettings.settings_data.volume_music)
	$Volume_Music / Down / Label.bbcode_text = stringa
	
	stringa = ""
	stringa = "[color=#50af50]효과음[/color] "
	stringa += translate.get_spaced_lines_from_int(ToolSettings.settings_data.volume_sounds)
	$Volume_Sound / Down_sound / Label.bbcode_text = stringa

func write_options():
	if ToolSettings.settings_data.show_range == true:
		$ButtonRange / boolo.bbcode_text = "[center][color=#80a080]켜짐[/color]"
	else:
		$ButtonRange / boolo.bbcode_text = "[center][color=#a08080]꺼짐[/color]"
	
	if ToolSettings.settings_data.short_animation == true:
		$ButtonAnimations / boolo.bbcode_text = "[center][color=#80a080]켜짐[/color]"
	else:
		$ButtonAnimations / boolo.bbcode_text = "[center][color=#a08080]꺼짐[/color]"
	
	if ToolSettings.settings_data.long_log == true:
		$ButtonLog / boolo.bbcode_text = "[center][color=#80a080]켜짐[/color]"
	else:
		$ButtonLog / boolo.bbcode_text = "[center][color=#a08080]꺼짐[/color]"
	
	if ToolSettings.settings_data.floating_text == true:
		$ButtonLog2 / boolo.bbcode_text = "[center][color=#80a080]켜짐[/color]"
	else:
		$ButtonLog2 / boolo.bbcode_text = "[center][color=#a08080]꺼짐[/color]"
		
	if ToolSettings.settings_data.speed_bar == true:
		$ButtonSpeedBars / boolo.bbcode_text = "[center][color=#80a080]켜짐[/color]"
	else:
		$ButtonSpeedBars / boolo.bbcode_text = "[center][color=#a08080]꺼짐[/color]"
	
	if ToolSettings.settings_data.hide_big_bar == true:
		$ButtonCharges / boolo.bbcode_text = "[center][color=#80a080]켜짐[/color]"
	else:
		$ButtonCharges / boolo.bbcode_text = "[center][color=#a08080]꺼짐[/color]"
	
	if ToolSettings.settings_data.winners_only == true:
		$ButtonWinners / boolo.bbcode_text = "[center][color=#80a080]켜짐[/color]"
	else:
		$ButtonWinners / boolo.bbcode_text = "[center][color=#a08080]꺼짐[/color]"
		
	if ToolSettings.settings_data.log_detail == true:
		$ButtonDetail / boolo.bbcode_text = "[center][color=#80a080]켜짐[/color]"
	else:
		$ButtonDetail / boolo.bbcode_text = "[center][color=#a08080]꺼짐[/color]"
	
	if ToolSettings.settings_data.victory_markers == true:
		$ButtonVictoryMarkers / boolo.bbcode_text = "[center][color=#80a080]켜짐[/color]"
	else:
		$ButtonVictoryMarkers / boolo.bbcode_text = "[center][color=#a08080]꺼짐[/color]"
	
	if ToolSettings.settings_data.vsync == true:
		$ButtonVSYNC / boolo.bbcode_text = "[center][color=#80a080]켜짐[/color]"
	else:
		$ButtonVSYNC / boolo.bbcode_text = "[center][color=#a08080]꺼짐[/color]"
	
	if ToolSettings.settings_data.gamepad_mode == "full":
		$ButtonGamepad / boolo.bbcode_text = "[center][color=#50ff50]활성"
	else:
		$ButtonGamepad / boolo.bbcode_text = "[center][color=#ff5050]비활성"
	
	var list = ["[center][color=#808080]없음[/color]", 
	"[center][color=#ff7050]힘[/color]", 
	"[center][color=#50ff70]민첩[/color]", 
	"[center][color=#c050ff]의지[/color]", 
	"[center][color=#ff8080]활력[/color]", 
	"[center][color=#ff2090]무작위[/color]"]
	$ButtonAutoLevel / boolo.bbcode_text = list[ToolSettings.settings_data.auto_level]
	
	list = ["[center][color=#808080]없음[/color]", 
	"[center][color=#ffff50]30[/color]", 
	"[center][color=#ffff50]60[/color]", 
	"[center][color=#ffff50]90[/color]", 
	"[center][color=#ffff50]120[/color]", 
	"[center][color=#ffff50]180[/color]", 
	]
	$ButtonFPS / boolo.bbcode_text = list[ToolSettings.settings_data.fps]
	
	Global.universal.get_node("ButtonAutoLevel").update_text()
		

func _on_Down_pressed():
	Global.sound.new_sound("Hover")
	if ToolSettings.settings_data.volume_music > volmin:
		ToolSettings.settings_data.volume_music -= 1
	ToolSettings.apply_settings()
	write_volumes()


func _on_Up_pressed():
	Global.sound.new_sound("Hover")
	if ToolSettings.settings_data.volume_music < volmax:
		ToolSettings.settings_data.volume_music += 1
	ToolSettings.apply_settings()
	write_volumes()


func _on_Down_sound_pressed():
	Global.sound.new_sound("Hover")
	if ToolSettings.settings_data.volume_sounds > volmin:
		ToolSettings.settings_data.volume_sounds -= 1
	ToolSettings.apply_settings()
	write_volumes()

func _on_Up_sound_pressed():
	Global.sound.new_sound("Hover")
	if ToolSettings.settings_data.volume_sounds < volmax:
		ToolSettings.settings_data.volume_sounds += 1
	ToolSettings.apply_settings()
	write_volumes()


func _on_Down_sound_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Up_sound_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Down_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Up_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Fullscreen_pressed():
	ToolSettings.settings_data.fullscreen = not ToolSettings.settings_data.fullscreen
	ToolSettings.apply_settings()


func _on_Restore_pressed():
	ToolSettings.restore_defaults()
	write_menu(saved_label)

func close_topscreen():
	if topscreen != null:
		topscreen.visible = false
		topscreen.mouse_filter = Control.MOUSE_FILTER_IGNORE
		topscreen = null
		setup_deckbuttons("normal")
		

func _input(event):
	
	if scene_disabled == false:
		if event.is_action_pressed("escape") or event.is_action_pressed("mouse_right"):
			close()
		if event.is_action_pressed("?"):
			open_controls()
		if event.is_action_pressed("g"):
			open_guide()
		if event.is_action_pressed("gamepad_y"):
			if ToolSettings.settings_data.gamepad_mode == "full":
				close()
		Global.universal.deck.input_handler(event)
		


func _on_Button_Controls_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Button_Controls_pressed():
	open_controls()
	
func open_controls():
	close_topscreen()
	setup_deckbuttons("topscreen")
	topscreen = $Windows / Controls
	topscreen.visible = true
	topscreen.mouse_filter = Control.MOUSE_FILTER_STOP

func open_guide():
	close_topscreen()
	setup_deckbuttons("topscreen")
	topscreen = $Windows / Guide
	topscreen.visible = true
	topscreen.mouse_filter = Control.MOUSE_FILTER_STOP
	


func _on_Button_Black_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Button_Brown_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Button_Green_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Button_Blue_mouse_entered():
	Global.sound.new_sound("Hover")


func change_color(label):
	if ToolSettings.settings_data.has("background_color"):
		ToolSettings.settings_data.background_color = label
	ToolSettings.apply_settings()

func _on_Button_Black_pressed():
	change_color("black")


func _on_Button_Brown_pressed():
	change_color("brown")


func _on_Button_Green_pressed():
	change_color("green")


func _on_Button_Blue_pressed():
	change_color("blue")





func _on_Button_Grey_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Button_Grey_pressed():
	change_color("grey")


func _on_Button_Red_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Button_Red_pressed():
	change_color("red")



func _on_Button_Tan_pressed():
	change_color("lightblue")


func _on_Button_Tan2_pressed():
	change_color("lightbrown")

func _on_Button_Tan3_pressed():
	change_color("lightpurp")

func _on_Button_Guide_pressed():
	open_guide()


func _on_ButtonRange_pressed():
	Global.sound.new_sound("Hover")
	if ToolSettings.settings_data.show_range == true:
		ToolSettings.settings_data.show_range = false
		ToolSettings.apply_settings()
		write_options()
	else:
		ToolSettings.settings_data.show_range = true
		ToolSettings.apply_settings()
		write_options()


func _on_ButtonAnimations_pressed():
	Global.sound.new_sound("Hover")
	if ToolSettings.settings_data.short_animation == true:
		ToolSettings.settings_data.short_animation = false
		ToolSettings.apply_settings()
		write_options()
	else:
		ToolSettings.settings_data.short_animation = true
		ToolSettings.apply_settings()
		write_options()


func _on_ButtonAnimations_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_ButtonRange_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_ButtonLog_pressed():
	Global.sound.new_sound("Hover")
	if ToolSettings.settings_data.long_log == true:
		ToolSettings.settings_data.long_log = false
		ToolSettings.apply_settings()
		write_options()
	else:
		ToolSettings.settings_data.long_log = true
		ToolSettings.apply_settings()
		write_options()










func _on_ButtonLog2_pressed():
	if ToolSettings.settings_data.floating_text == true:
		ToolSettings.settings_data.floating_text = false
		ToolSettings.apply_settings()
		write_options()
	else:
		ToolSettings.settings_data.floating_text = true
		ToolSettings.apply_settings()
		write_options()


func _on_ButtonSpeedBars_pressed():
	if ToolSettings.settings_data.speed_bar == true:
		ToolSettings.settings_data.speed_bar = false
		ToolSettings.apply_settings()
		write_options()
	else:
		ToolSettings.settings_data.speed_bar = true
		ToolSettings.apply_settings()
		write_options()


func _on_ButtonCharges_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_ButtonCharges_pressed():
	if ToolSettings.settings_data.hide_big_bar == true:
		ToolSettings.settings_data.hide_big_bar = false
		ToolSettings.apply_settings()
		write_options()
	else:
		ToolSettings.settings_data.hide_big_bar = true
		ToolSettings.apply_settings()
		write_options()


func _on_ButtonWinners_pressed():
	if ToolSettings.settings_data.winners_only == true:
		ToolSettings.settings_data.winners_only = false
		ToolSettings.apply_settings()
		write_options()
	else:
		ToolSettings.settings_data.winners_only = true
		ToolSettings.apply_settings()
		write_options()


func _on_ButtonDetail_pressed():
	if ToolSettings.settings_data.log_detail == true:
		ToolSettings.settings_data.log_detail = false
		ToolSettings.apply_settings()
		write_options()
	else:
		ToolSettings.settings_data.log_detail = true
		ToolSettings.apply_settings()
		write_options()


func _on_ButtonAutoLevel_pressed():
	
	
	ToolSettings.settings_data.auto_level += 1
	if ToolSettings.settings_data.auto_level > 5:
		ToolSettings.settings_data.auto_level = 0
	ToolSettings.apply_settings()
	write_options()



func _on_ButtonFPS_pressed():
	ToolSettings.settings_data.fps += 1
	if ToolSettings.settings_data.fps > 5:
		ToolSettings.settings_data.fps = 0
	ToolSettings.apply_settings()
	write_options()




func _on_ButtonVSYNC_pressed():
	if ToolSettings.settings_data.vsync == true:
		ToolSettings.settings_data.vsync = false
		ToolSettings.apply_settings()
		write_options()
	else:
		ToolSettings.settings_data.vsync = true
		ToolSettings.apply_settings()
		write_options()


func _on_ButtonVictoryMarkers_pressed():
	if ToolSettings.settings_data.victory_markers == true:
		ToolSettings.settings_data.victory_markers = false
		ToolSettings.apply_settings()
		write_options()
	else:
		ToolSettings.settings_data.victory_markers = true
		ToolSettings.apply_settings()
		write_options()

func setup_deckbuttons(type):
	
	Global.universal.deck.deckbutton_selected = null
	Global.universal.deck.index_x = 0
	Global.universal.deck.index_y = 0
	
	if type == "topscreen":
		Global.universal.deck.deckbuttons = [[$Button_Close]]
		Global.universal.deck.set_first_button()
	else:
		
		Global.universal.deck.deckbuttons = [
	[$Button_Close], 
	[$Button_Controls, $Button_Guide, $Fullscreen, $Volume_Music / Down, $Volume_Sound / Down_sound, $ButtonLog2, $ButtonLog, $ButtonDetail, $ButtonWinners, $ButtonVictoryMarkers, $Button_QuitGame], 
	[null, null, $ButtonAutoLevel, $Volume_Music / Up, $Volume_Sound / Up_sound, $ButtonSpeedBars, $ButtonRange, $ButtonAnimations, $ButtonVSYNC, $ButtonFPS, $Colors / Button_Black], 
	[null, null, $ButtonAutoLevel, $Volume_Music / Up, $Volume_Sound / Up_sound, $ButtonSpeedBars, $ButtonRange, $ButtonAnimations, $ButtonVSYNC, $ButtonFPS, $Colors / Button_Brown], 
	[null, null, $ButtonAutoLevel, $Volume_Music / Up, $Volume_Sound / Up_sound, $ButtonSpeedBars, $ButtonRange, $ButtonAnimations, $ButtonVSYNC, $ButtonFPS, $Colors / Button_Green], 
	[null, null, $ButtonAutoLevel, $Volume_Music / Up, $Volume_Sound / Up_sound, $ButtonSpeedBars, $ButtonRange, $ButtonAnimations, $ButtonVSYNC, $ButtonFPS, $Colors / Button_Blue], 
	[null, null, $ButtonAutoLevel, $Volume_Music / Up, $Volume_Sound / Up_sound, $ButtonSpeedBars, $ButtonRange, $ButtonAnimations, $ButtonVSYNC, $ButtonFPS, $Colors / Button_Grey], 
	[null, null, $ButtonAutoLevel, $Volume_Music / Up, $Volume_Sound / Up_sound, $ButtonSpeedBars, $ButtonRange, $ButtonAnimations, $ButtonVSYNC, $ButtonFPS, $Colors / Button_Red], 
	[null, null, $ButtonAutoLevel, $Volume_Music / Up, $Volume_Sound / Up_sound, $ButtonSpeedBars, $ButtonRange, $ButtonAnimations, $ButtonVSYNC, $ButtonFPS, $Colors / Button_Tan], 
	[null, null, $ButtonAutoLevel, $Volume_Music / Up, $Volume_Sound / Up_sound, $ButtonSpeedBars, $ButtonRange, $ButtonAnimations, $ButtonVSYNC, $ButtonFPS, $Colors / Button_Tan2], 
	[null, null, $ButtonAutoLevel, $Volume_Music / Up, $Volume_Sound / Up_sound, $ButtonSpeedBars, $ButtonRange, $ButtonAnimations, $ButtonVSYNC, $ButtonFPS, $Colors / Button_Tan3], 
	[$ButtonCharges, $ButtonGamepad]
	]

	

	Global.universal.deck.set_first_button()


func _on_ButtonGamepad_pressed():
	if Global.universal.deck.allowed == true:
		if ToolSettings.settings_data.gamepad_mode == "full":
			ToolSettings.settings_data.gamepad_mode = "none"
			ToolSettings.apply_settings()
			write_options()
		else:
			ToolSettings.settings_data.gamepad_mode = "full"
			ToolSettings.apply_settings()
			write_options()
	else:
		ToolSettings.settings_data.gamepad_mode = "none"
		ToolSettings.apply_settings()
		write_options()



