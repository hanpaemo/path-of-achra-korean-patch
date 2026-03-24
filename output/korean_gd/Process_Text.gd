extends Node


var rng = RandomNumberGenerator.new()
var drift = 20
var game = null
var Player = null

func _ready():
	rng.randomize()

func spawn_text_popup(apoint, atext, color):
	if ToolSettings.settings_data.floating_text == true:
		var bpoint = apoint
		bpoint.x += rng.randi_range(drift * - 1, drift)
		bpoint.y += rng.randi_range((drift * - 1) * 3, 0)
		var popup = Global.TextPopup.instance()
	
		popup.modulate = Color(1, 1, 1, 1)
	
		game.add_child(popup)
		popup.get_node("Label").bbcode_text = color + atext + "[/color]"
		popup.position = bpoint

func spawn_speech_popup(apoint, atext, color):
	
		var bpoint = apoint
		bpoint.x += rng.randi_range(drift * - 1, drift)
		bpoint.y += rng.randi_range((drift * - 1) * 3, 0)
		var popup = Global.TextPopup.instance()
	
		popup.modulate = Color(1, 1, 1, 1)
		popup.make_speech()
	
		game.add_child(popup)
		popup.get_node("Label").bbcode_text = color + atext + "[/color]"
		popup.position = bpoint
	
func spawn_text_popup_context(apoint, atext, color, context):
	var bpoint = apoint
	bpoint.x += rng.randi_range(drift * - 1, drift)
	bpoint.y += rng.randi_range((drift * - 1) * 3, 0)
	var popup = Global.TextPopup.instance()
	context.add_child(popup)
	popup.get_node("Label").bbcode_text = color + atext + "[/color]"
	popup.position = bpoint
