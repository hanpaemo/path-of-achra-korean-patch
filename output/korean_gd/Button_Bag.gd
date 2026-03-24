extends Node2D

var context
var bag_index
var type
var trait
var info

var index_x = 0

var info_other = {}


onready var player = Global.Player

func _on_Button_pressed():
	if type == "item":
		Global.sound.new_sound("Hover")
		if context.popup_visible == false:
			context.popup_visible = true
		else:
			context.popup_visible = false
		if context.focused_button == str(bag_index) + "bag":
			context.highlight_focused()
			context.update_deck_selected()
		else:
			
			context.focused_button = str(bag_index) + "bag"
			context.highlight_focused()
			context.update_deck_selected()
		
	
	if type == "trait":
		Global.sound.new_sound("Hover")
		if context.focused_button == trait.title:
			pass
		else:
			context.focused_button = trait.title
			context.highlight_focused()
	if type == "info":
		Global.sound.new_sound("Hover")
		if context.focused_button == info.title:
			pass
		else:
			context.focused_button = info.title
			context.highlight_focused()


func equip(item):
	
	var new_item = cloner.clone_dict(item)
	if new_item.type == "weapon" and context.MODE_DROP == false and Global.game.floor_cleared == true:
		context.popup_visible = false
		
			
		context.focused_button = "main"
		effectmaker.create_effect_animated_ui_context(context, context.get_node("Buttons_Equipped/Button_WeaponMain").get_global_position(), "Click")
		if player.weapon_main == null:
			player.weapon_main = weapon_equip_changes(new_item)
		else:
			var i = cloner.clone_dict(player.weapon_main)
			player.weapon_main = weapon_equip_changes(new_item)
			player.bag.push_front(i)
			
				
				
				
				
				
					
					
					
		
		player.bag.erase(item)
		context.hovered_button = context.focused_button
		Global.game.update_game()
		context.update()
		context.update_deck_selected()
		
	if new_item.type == "armor" and context.MODE_DROP == false and Global.game.floor_cleared == true:
		context.popup_visible = false
		match new_item.position:
			"chest":
				context.focused_button = "chest"
				effectmaker.create_effect_animated_ui_context(context, context.get_node("Buttons_Equipped/Button_ArmorChest").get_global_position(), "Click")
				var i = cloner.clone_dict(player.armor_chest)
				if i != null:
					player.bag.push_front(i)
				player.armor_chest = new_item
			"arm":
				context.focused_button = "hand"
				effectmaker.create_effect_animated_ui_context(context, context.get_node("Buttons_Equipped/Button_ArmorHand").get_global_position(), "Click")
				var i = cloner.clone_dict(player.armor_hands)
				if i != null:
					player.bag.push_front(i)
				player.armor_hands = new_item
			"leg":
				context.focused_button = "leg"
				effectmaker.create_effect_animated_ui_context(context, context.get_node("Buttons_Equipped/Button_ArmorLeg").get_global_position(), "Click")
				var i = cloner.clone_dict(player.armor_legs)
				if i != null:
					player.bag.push_front(i)
				player.armor_legs = new_item
			"head":
				context.focused_button = "head"
				effectmaker.create_effect_animated_ui_context(context, context.get_node("Buttons_Equipped/Button_ArmorHead").get_global_position(), "Click")
				var i = cloner.clone_dict(player.armor_head)
				if i != null:
					player.bag.push_front(i)
				player.armor_head = new_item
		
		player.bag.erase(item)
		context.hovered_button = context.focused_button
		Global.game.update_game()
		context.update()
		context.update_deck_selected()
		
		
	if Global.game.floor_cleared == false and context.MODE_DROP == false:
		ProcessText.spawn_text_popup_context(context.get_node("PopupLayer/Popup").position, "적이 가까이 있다!", "[color=#ff2020]", context.get_node("PopupLayer"))
	elif context.MODE_DROP == true:
		context.focused_button = "main"
		player.bag.erase(item)
		context.update()


func equip_off(item):
	var new_item = cloner.clone_dict(item)
	if Global.game.floor_cleared == true:
		context.popup_visible = false
		context.focused_button = "off"
		context.hovered_button = context.focused_button
		effectmaker.create_effect_animated_ui_context(context, context.get_node("Buttons_Equipped/Button_WeaponOff").get_global_position(), "Click")
		if player.weapon_off == null:
			player.weapon_off = weapon_equip_changes(new_item)
		else:
			var i = cloner.clone_dict(player.weapon_off)
			player.weapon_off = weapon_equip_changes(new_item)
			player.bag.push_front(i)
		player.bag.erase(item)
		Global.game.update_game()
		context.update()
	else:
		ProcessText.spawn_text_popup_context(get_node(".").position, "적이 가까이 있다!", "[color=#ff2020]", context)
		
func weapon_equip_changes(item):
	
	var traits = Global.Player.get_traits()
	if item.type == "weapon":
		if traits.has("Strijela"):
			if item.range > 1:
				item.aoe = 2
	
	return item
			
func trash(item):
	
	
	context.hovered_button = context.focused_button
	player.bag.erase(item)
	
	
	
	context.update()
	context.update_deck_selected()

func _on_Button_mouse_entered():
	Global.sound.new_sound("Hover")
	if type == "item":
		if context.hovered_button != str(bag_index) + "bag":
			context.hovered_button = str(bag_index) + "bag"
			context.highlight_focused()
	if type == "trait":
		Global.sound.new_sound("Hover")
		if context.hovered_button != trait.title:
			context.hovered_button = trait.title
			context.highlight_focused()
	if type == "buff":
		Global.sound.new_sound("Hover")
		if context.hovered_button != trait.title + "buff":
			context.hovered_button = trait.title + "buff"
			context.highlight_focused()
	if type == "info":
		Global.sound.new_sound("Hover")
		if context.hovered_button != info.title:
			context.hovered_button = info.title
			context.highlight_focused()


func _on_Button_mouse_exited():
	context.hovered_button = "none"
	context.highlight_focused()
	
