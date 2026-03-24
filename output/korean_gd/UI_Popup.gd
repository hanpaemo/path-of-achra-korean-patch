extends CanvasLayer


var data = null
var type = "none"

onready var sprite = $UiBoxSideways / Content / Sprite
onready var label = $UiBoxSideways / Content / Label
onready var Achoicelabel = $UiBoxSideways / Content / ButtonA / Label
onready var Achoicebutton = $UiBoxSideways / Content / ButtonA

onready var Bchoicelabel = $UiBoxSideways / Content / ButtonB / Label
onready var Bchoicebutton = $UiBoxSideways / Content / ButtonB




func create_display():
	Bchoicebutton.modulate = Color(1, 1, 1, 0)
	Bchoicebutton.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if data != null:
		
		if type == "tab":
			var stringa = "[color=#c0c0c0]"
			stringa += "여정이 시작됩니다..."
			stringa += "\n\n"
			stringa += "[color=#c0c050]TAB[/color] / [color=#c0c050]우클릭[/color]으로 자동 이동\n\n"
			stringa += "[img]res://Ham_Sprite/UI/Powers.png[/img] lets you [color=#ffff50]acquire new powers[/color]"
			label.bbcode_text = stringa
			sprite.texture = load(data.icon)
		
		if type == "item":
			var stringa = "[color=#c0c0c0]"
			sprite.texture = load(data.sprite)
			$UiBoxSideways / Content / Sprite2.visible = true
			stringa += "" + data.name
			
				
			
				
			stringa += "\n\n\n"
			if data. class != "equipment":
				effectmaker.create_effect_animated_ui_context($UiBoxSideways, $UiBoxSideways / Content / Sprite.get_global_position(), Global.Player.god.title)
			if data.has("rumor"):
				stringa += "[color=#a0a0a0]" + data.rumor + "[/color]"
				pass
			
				
				
					
			
			label.bbcode_text = stringa
			
			
			
			
			Achoicebutton.text = "OK"
		
		if type == "intro":
			var stringa = "[color=#c0c0c0]"
			sprite.texture = load(data.sprite)
			stringa += data.intro
			
			Achoicebutton.text = "OK"
				
			label.bbcode_text = stringa
			
			
			
		
		if type == "land":
			var stringa = "[color=#c0c0c0]"
			sprite.texture = load("res://Ham_Sprite/World/" + data.world_icon + ".png")
			stringa += data.intro
			
			Achoicebutton.text = "OK"
				
			label.bbcode_text = stringa
			
		
		if type == "preta":
			var stringa = "[color=#c0c0c0]"
			sprite.texture = load(data.sprite)
			stringa += data.name_color
			stringa += " 출현..."
			
			
			if Global.Player.get_tint_items():
				var items = Global.Player.get_tint_items()
				var item = items[Global.rng.randi_range(0, items.size() - 1)]
				stringa += "\n\n이끌려 온 대상: " + item.name + "..."
			
			stringa += "\n\n[color=#707070]오 아귀여...[/color]"
				
			
			Achoicebutton.text = "OK"
				
			label.bbcode_text = stringa
			
	
	

func press_A():
	ProcessQueue.PAUSED = false
	queue_free()

func _input(event):
	if event.is_action_pressed("tab"):
		press_A()
	if event.is_action_pressed("gamepad_b"):
		if ToolSettings.settings_data.gamepad_mode == "full":
			press_A()
	if event.is_action_pressed("enter") or event.is_action_pressed("click"):
		press_A()
	if event.is_action_pressed("pass"):
		press_A()
	if event.is_action_pressed("up"):
		press_A()
	if event.is_action_pressed("upleft"):
		press_A()
	if event.is_action_pressed("upright"):
		press_A()
	if event.is_action_pressed("left"):
		press_A()
	if event.is_action_pressed("right"):
		press_A()
	if event.is_action_pressed("down"):
		press_A()
	if event.is_action_pressed("downleft"):
		press_A()
	if event.is_action_pressed("downright"):
		press_A()
	if event.is_action_pressed("mouse_right"):
		press_A()
	if event.is_action_pressed("gamepad_a"):
		press_A()

func _on_ButtonA_pressed():
	press_A()


func _on_ButtonA_mouse_entered():
	Global.sound.new_sound("Hover")
