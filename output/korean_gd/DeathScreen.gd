extends Control

var active = false
var scene_disabled = false
onready var ui = get_parent()



func play_screen(killer, type):
	Global.game.update_deckbuttons()
	var glory_added = Global.Player.level
	if Global.Player.level > 15:
		glory_added = Global.Player.level * 2
	
	if StateWorld.land == "dust":
		if StateWorld.Floor_Current < 6:
			glory_added = 1
		else:
			glory_added = int(Global.Player.level / 2)
			if glory_added < 1: glory_added = 1
	
	
	active = true
	$AnimationPlayer.play("fadein")
	ToolMessageCreator.hover_info_type = "none"
	score.build_score_elements()
	if killer != null and type == "death":
		StatePlayerSheet.score_data["condition"] = "death"
		StatePlayerSheet.score_data["killer_name"] = killer.get_killer_name()
		StatePlayerSheet.score_data["killer_sprite"] = killer.spritescreen
		
		$Sprite.texture = load(killer.spritescreen)
		$description.bbcode_text = "[color=#c0c0c0]" + killer.taunt + "[color=#ff3030] 당신은 죽었습니다...[/color]"
	
		$description2.bbcode_text = "영광 " + str(glory_added) + " 획득"

	if type == "victory":
		StatePlayerSheet.score_data["condition"] = "victory"
		
		
		$Sprite.texture = load(Global.Player.god.sprite)
		$description.bbcode_text = "[color=#ff9020]승리![/color][color=#c0c0c0] 찬양하라 " + Global.Player.god.name + "!"
		if cycler.unlock_next_cycle() == true:
			$description.bbcode_text += "\n\n다음 순환에 입장: " + cycler.int_to_cycle_name(ToolSettings.settings_data.cycle_current)
		else:
			$description.bbcode_text += "\n\n기이한 차원문이 부르지만, 아직 길이 드러나지 않았습니다..."
		$description2.bbcode_text = "영광 " + str(glory_added) + " 획득"

func _on_Button_QuitGame_mouse_entered():
	Global.sound.new_sound("Hover")
		


func press_quit():
	if Global.game.paused == false:
				if ProcessQueue.PAUSED == false and ProcessQueue.ACTIVE == false:
					if ui.get_open_windows().size() == 0:
						if ui.get_node("UI_Enemies").is_open == false:
							scene_disabled = true
							if StateWorld.land != "dust":
								if ToolSettings.settings_data.winners_only == true:
									if StatePlayerSheet.score_data["condition"] == "victory":
										graveyard.set_graveyard_add_player()
								else:
									graveyard.set_graveyard_add_player()
								
								saveload.saveload(saveload.create_empty_file())

							ToolMessageCreator.hover_info_type = "none"
							ToolMessageCreator.update()

							StatePlayerSheet.clear()
							Global.clear_level_data()
							
							if StateWorld.land != "dust":
								Global.universal.transition("score")
							else:
								Global.universal.transition("graveyard")
								graveyard.dust_key(StatePlayerSheet.title_name, StateWorld.Floor_Current)
	

func _on_Button_QuitGame_pressed():
	press_quit()
	


func _on_Button_View_pressed():
	queue_free()

func _input(event):
	if scene_disabled == false:
		if event.is_action_pressed("enter"):
			if active == true:
				press_quit()
