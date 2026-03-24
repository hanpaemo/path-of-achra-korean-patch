extends Node2D


var context = null


var button_type = "none"

func initiate():
	$Sprite.texture = null
	add_to_special_arrays()
	set_sprite_position()

func add_to_special_arrays():
	if button_type == "bag_item":
		$Button.modulate = Color(1, 1, 1, 0.3)
		var this_button = get_node(".")
		context.buttons_bag.append(this_button)


func set_sprite_position():
	if button_type == "inventory_close":
		$Button.text = "X"
	
	
	

func clear_sprite():
	$Sprite.texture = null

func set_sprite(texture_path):
	$Sprite.texture = load(texture_path)
	
func _on_Button_pressed():
	check_type()

func check_type():
	type_context_close()
	type_bag_item()
	type_inventory_item()
	
func type_context_close():
	if button_type == "inventory_close":
		context.close()

func type_inventory_item():
	if button_type == "inventory_weapon_main":
		
		if $Sprite.texture != null:
			if Global.Player.weapon_off == null:
				var new_item = null
				var old_item = Global.Player.weapon_main
				Global.Player.weapon_main = new_item
				Global.Player.weapon_off = old_item
				print("You move " + old_item["name"] + "to Off-Hand")
			else:
				var new_item = null
				var old_item = Global.Player.weapon_main
				Global.Player.weapon_main = new_item
				Global.Player.bag.append(old_item)
				print("You put away a" + (old_item["name"]))
	
	if button_type == "inventory_weapon_off":
		
		if $Sprite.texture != null:
			var new_item = null
			var old_item = Global.Player.weapon_off
			Global.Player.weapon_off = new_item
			Global.Player.bag.append(old_item)
			print("You put away a" + (old_item["name"]))
	
	if button_type == "inventory_hands":
		
		if $Sprite.texture != null:
			var new_item = null
			var old_item = Global.Player.armor_hands
			Global.Player.armor_hands = new_item
			Global.Player.bag.append(old_item)
			print("You put away a" + (old_item["name"]))
	
	if button_type == "inventory_chest":
		if $Sprite.texture != null:
			var new_item = null
			var old_item = Global.Player.armor_chest
			Global.Player.armor_chest = new_item
			Global.Player.bag.append(old_item)
			print("You put away a" + (old_item["name"]))
	
	if button_type == "inventory_legs":
		if $Sprite.texture != null:
			var new_item = null
			var old_item = Global.Player.armor_legs
			Global.Player.armor_legs = new_item
			Global.Player.bag.append(old_item)
			print("You put away a" + (old_item["name"]))
	
	if button_type == "inventory_head":
		if $Sprite.texture != null:
			var new_item = null
			var old_item = Global.Player.armor_head
			Global.Player.armor_head = new_item
			Global.Player.bag.append(old_item)
			print("You put away a" + (old_item["name"]))
	
	Global.Player.update()
	Global.game.update_game()
	

func type_bag_item():
	if button_type == "bag_item":
		var buttonbag = null
		var inta = 0
		if $Sprite.texture != null:
			for n in context.buttons_bag.size():
				if context.buttons_bag[n] == get_node("."):
					buttonbag = Global.Player.bag[n]
					inta = n
		if buttonbag != null:
			if context.drop_mode == false:
				if buttonbag["type"] == "weapon":
					bag_item_weapon(inta)
				if buttonbag["type"] == "armor":
					bag_item_armor(inta)
			if context.drop_mode == true:
				bag_item_drop(inta)
			
					
		Global.Player.update()
		Global.game.update_game()

func bag_item_drop(n):
	var new_item = Global.Player.bag[n]
	var old_item = null
	Global.Player.bag[n] = old_item
	Global.Player.residence.pile.append(new_item)
	print("You drop a " + (new_item["name"]))

func bag_item_armor(n):
	var new_item = Global.Player.bag[n]
	if new_item["position"] == "chest":
		var old_item = Global.Player.armor_chest
		Global.Player.armor_chest = new_item
		Global.Player.bag[n] = old_item
		print("You put on a " + (new_item["name"]))
		ProcessQueue.run_multiple_times(6)
	if new_item["position"] == "arm":
		var old_item = Global.Player.armor_hands
		Global.Player.armor_hands = new_item
		Global.Player.bag[n] = old_item
		print("You put on a " + (new_item["name"]))
		ProcessQueue.run_multiple_times(3)
	if new_item["position"] == "leg":
		var old_item = Global.Player.armor_legs
		Global.Player.armor_legs = new_item
		Global.Player.bag[n] = old_item
		print("You put on a " + (new_item["name"]))
		ProcessQueue.run_multiple_times(3)
	if new_item["position"] == "head":
		var old_item = Global.Player.armor_head
		Global.Player.armor_head = new_item
		Global.Player.bag[n] = old_item
		print("You put on a " + (new_item["name"]))
		ProcessQueue.run_multiple_times(3)
		

func bag_item_weapon(n):
	var new_item = Global.Player.bag[n]
					
	if Global.Player.weapon_main != null and Global.Player.weapon_off != null:
		var old_item = Global.Player.weapon_main
		Global.Player.weapon_main = new_item
		Global.Player.bag[n] = old_item
		print("You put away a " + (old_item["name"]))
		print("You wield a " + (new_item["name"]))
		ProcessQueue.run_multiple_times(3)
					
	if Global.Player.weapon_main != null and Global.Player.weapon_off == null:
		var old_item = Global.Player.weapon_off
		Global.Player.weapon_off = new_item
		Global.Player.bag[n] = old_item
		
		print("You off-hand wield a " + (new_item["name"]))
		ProcessQueue.run_multiple_times(3)
					
	if Global.Player.weapon_main == null:
		var old_item = Global.Player.weapon_main
		Global.Player.weapon_main = new_item
		Global.Player.bag[n] = old_item
		
		print("You wield a " + (new_item["name"]))
		ProcessQueue.run_multiple_times(3)
