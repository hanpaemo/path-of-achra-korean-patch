extends Button

onready var textbox = $AutoLevel

func _process(_delta):
	if Global.Player != null:
		mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	
func _ready():
	update_text()
	
func update_text():
	var list = ["[center][color=#808080]없음[/color]", 
	"[center][color=#ff7050]힘[/color]", 
	"[center][color=#50ff70]민첩[/color]", 
	"[center][color=#c050ff]의지[/color]", 
	"[center][color=#ff8080]활력[/color]", 
	"[center][color=#ff2090]무작위[/color]"]
	
	
	match list[ToolSettings.settings_data.auto_level]:
			"[center][color=#808080]없음[/color]":
				textbox.bbcode_text = "[right][color=#707070]...[/color]"
			"[center][color=#ff7050]힘[/color]":
				textbox.bbcode_text = "[right][color=#ffff50]+[/color] [color=#ff7050]힘[/color]"
			"[center][color=#50ff70]민첩[/color]":
				textbox.bbcode_text = "[right][color=#ffff50]+[/color] [color=#50ff70]민첩[/color]"
			"[center][color=#c050ff]의지[/color]":
				textbox.bbcode_text = "[right][color=#ffff50]+[/color] [color=#c050ff]의지[/color]"
			"[center][color=#ff8080]활력[/color]":
				textbox.bbcode_text = "[right][color=#ffff50]+[/color] [color=#ff8080]활력[/color]"
			"[center][color=#ff2090]무작위[/color]":
				textbox.bbcode_text = "[right][color=#ff2090]무작위[/color]"
	

func _on_ButtonAutoLevel_pressed():
	ToolSettings.settings_data.auto_level += 1
	if ToolSettings.settings_data.auto_level > 5:
		ToolSettings.settings_data.auto_level = 0
	ToolSettings.apply_settings()
	update_text()


func _on_ButtonAutoLevel_mouse_entered():
	Global.sound.new_sound("Hover")
	ToolMessageCreator.hover_info = {}
	ToolMessageCreator.hover_info_type = "autolevel"
	ToolMessageCreator.update()


func _on_ButtonAutoLevel_mouse_exited():
	ToolMessageCreator.hover_info = null
	ToolMessageCreator.hover_info_type = "none"
	ToolMessageCreator.update()
