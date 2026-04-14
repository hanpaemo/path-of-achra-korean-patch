extends Node


var rng = RandomNumberGenerator.new()
var drift = 20
var game = null
var Player = null
var popup_stack_window_ms = 180
var popup_stack_offset_y = 12
var popup_stack_offset_x = 6
var popup_stack_max = 5
var popup_slots = {}

func _ready():
	rng.randomize()

func popup_stack_index(apoint):
	var key = str(int(round(apoint.x / 16.0))) + "," + str(int(round(apoint.y / 16.0)))
	var now = OS.get_ticks_msec()
	if popup_slots.has(key) == false:
		popup_slots[key] = {"count": 0, "time": now}
	var slot = popup_slots[key]
	if now - int(slot["time"]) > popup_stack_window_ms:
		slot["count"] = 0
	slot["time"] = now
	slot["count"] = min(int(slot["count"]) + 1, popup_stack_max)
	popup_slots[key] = slot
	return int(slot["count"]) - 1

func popup_point(apoint):
	var bpoint = apoint
	var stack = popup_stack_index(apoint)
	bpoint.x += rng.randi_range(drift * - 1, drift)
	bpoint.y += rng.randi_range((drift * - 1) * 3, 0)
	bpoint.y -= stack * popup_stack_offset_y
	if stack > 0:
		var direction = -1 if stack % 2 == 1 else 1
		bpoint.x += direction * popup_stack_offset_x * int((stack + 1) / 2)
	return bpoint

func spawn_text_popup(apoint, atext, color):
	if ToolSettings.settings_data.floating_text == true:
		var bpoint = popup_point(apoint)
		var popup = Global.TextPopup.instance()
	
		popup.modulate = Color(1, 1, 1, 1)
	
		game.add_child(popup)
		popup.get_node("Label").bbcode_text = color + atext + "[/color]"
		popup.position = bpoint

func spawn_speech_popup(apoint, atext, color):
	
		var bpoint = popup_point(apoint)
		var popup = Global.TextPopup.instance()
	
		popup.modulate = Color(1, 1, 1, 1)
		popup.make_speech()
	
		game.add_child(popup)
		popup.get_node("Label").bbcode_text = color + atext + "[/color]"
		popup.position = bpoint
	
func spawn_text_popup_context(apoint, atext, color, context):
	var bpoint = popup_point(apoint)
	var popup = Global.TextPopup.instance()
	context.add_child(popup)
	popup.get_node("Label").bbcode_text = color + atext + "[/color]"
	popup.position = bpoint
