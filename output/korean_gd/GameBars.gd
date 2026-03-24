extends Node2D







func _process(_delta):
	if Global.Player != null:
		show_bars(ToolSettings.settings_data.hide_big_bar)
		if check_next_turn() or ProcessQueue2.is_game_active == true:
			$SpeedBar.modulate = Color(0, 0.6, 0, 1)
			$Turn.bbcode_text = "[right]-> 턴"
		else:
			$SpeedBar.modulate = Color(0.3, 0.2, 0.3, 1)
			$Turn.bbcode_text = ""


func check_next_turn():
	var boola = false
	var ticks_left = (100.0 - (float(Global.game.tick_new))) / 5.0
	var player_ticks_left = (100.0 - (float(Global.Player.tick))) / float(Global.Player.get_SPEED())
	if ticks_left <= player_ticks_left:
		boola = true

	
	return boola



func draw_speed():
	$SpeedBar.rect_scale.x = float(Global.game.tick_new) / 100.0
	if $SpeedBar.rect_scale.x >= 1.0 or ProcessQueue2.is_game_active == true:
		$SpeedBar.rect_scale.x = 1.0

func update_bars():
	var stringa = "[color=#ffff50]" + str(Global.Player.level) + " [color=#c0c0c0]" + str(Global.Player.xp) + "/" + str(Global.Player.xp_needed) + ""
	
	$Glorybar.rect_scale.x = float(Global.Player.xp) / float(Global.Player.xp_needed)
	
	stringa = "[color=#ff8080]" + str(Global.Player.HP) + " [color=#c0c0c0]/" + str(Global.Player.HP_max) + ""
	stringa = stringa + " " + str(int((float(Global.Player.HP) / float(Global.Player.HP_max)) * 100.0)) + "%"
	$Life.bbcode_text = stringa
	if Global.Player.HP > 0:
		$Lifebar.rect_scale.x = float(Global.Player.HP) / float(Global.Player.HP_max)
	else:
		$Lifebar.rect_scale.x = 0.0
	
	stringa = ""
	for n in Global.Player.get_charged_invokes():
		stringa += "[img]res://Ham_Sprite/UI/Ankh.png[/img]"
	$Glory2.bbcode_text = "[right]" + stringa + "  *" + str(Global.Player.level)
	$Glory2.visible = true
	$ButtonLifeBar.visible = true
	$Life.visible = true
	$Glory.visible = true
	show_bars(ToolSettings.settings_data.hide_big_bar)
		
	
	

func show_bars(boola):
		
		if boola == true:
			boola = false
		else:
			boola = true
		
		$Glorybar.visible = boola
		$Glorybar2.visible = boola
		$SpeedBar.visible = boola
		$BarOutline3.visible = boola
		
		
		$Lifebar.visible = boola
		$Lifebar2.visible = boola
		
		$ButtonGloryBar.visible = boola
	
	
	
		$BarOutline.visible = boola
		$BarOutline2.visible = boola
