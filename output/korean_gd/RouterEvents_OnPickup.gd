extends Node

class_name event_pickup

static func check(item):
	
	ToolInvokes.recharge("pickup")
	
	if transformed(item) == true:
		pass



static func transformed(item):
	var is_transformed = false
	
	if Global.Player.get_traits().has("Mardok"):
		if item.type == "armor":
			if item.position == "head":
				item.rumor = item.name + " Mordok에 의해 변형..."
				item.weight += Global.Player.get_total_STR()
				item.name = "[color=#ff8030]Helm of Mardok[/color] [color=#707070](" + textstrip.strip_bbcode(item.name) + ")[/color]"
				item.sprite = "res://Ham_Sprite/Armor/MardokHelm.png"
	
	if Global.Player.get_traits().has("Dumuzi"):
		if item.type == "armor":
			if item.weight > 1:
				is_transformed = true
				item. class = "dumuzi"
				item.arm += 100
				item.inflex += 1
				
				item.rumor = item.name + " Dumuzi에 의해 변형..."
				match item.position:
					"head":
						item.name = "[color=#d09000]Gilded Helm[/color] [color=#707070](" + textstrip.strip_bbcode(item.name) + ")[/color]"
						item.sprite = "res://Ham_Sprite/Armor/GildedHead.png"
					"arm":
						item.name = "[color=#d09000]Gilded Bracers[/color] [color=#707070](" + textstrip.strip_bbcode(item.name) + ")[/color]"
						item.sprite = "res://Ham_Sprite/Armor/GildedArms.png"
					"leg":
						item.name = "[color=#d09000]Gilded Skirt[/color] [color=#707070](" + textstrip.strip_bbcode(item.name) + ")[/color]"
						item.sprite = "res://Ham_Sprite/Armor/GildedLegs.png"
					"chest":
						item.name = "[color=#d09000]Gilded Chestplate[/color] [color=#707070](" + textstrip.strip_bbcode(item.name) + ")[/color]"
						item.sprite = "res://Ham_Sprite/Armor/GildedChest.png"
	
	if Global.Player.get_traits().has("Strijela"):
		if item.type == "weapon":
			if item.range > 1:
				item.aoe = 2
	
	if Global.Player.get_traits().has("Virya"):
		if item.type == "weapon":
			if item.dmgtype == "slash":
				is_transformed = true
				item.rumor = item.name + " Vyranism에 의해 재련..."
				item.name = "[color=#c03090]Mighty Blade[/color] [color=#707070](" + textstrip.strip_bbcode(item.name) + ")[/color]"
				item.sprite = "res://Ham_Sprite/Weapons/MightyBlade.png"
				item.proj_art = "none"
				item.range = 1
				item.aoe = 2
				item.size = 7
				item.dmg = item.dmg * 2
				item.weight = item.weight * 2
	
	if Global.Player.get_traits().has("Pallas"):
		if item.type == "weapon":
			if item.shield == true:
				is_transformed = true
				item.rumor = item.name + " Pallas에 의해 변형..."
				item.name = "[color=#ff7070]Hoplon[/color] [color=#707070](" + textstrip.strip_bbcode(item.name) + ")[/color]"
				item.sprite = "res://Ham_Sprite/Weapons/Hoplon.png"
				item.proj_art = "none"
				item.size = 6
				if item.range > 1:
					item.proj_art = "res://Ham_Sprite/Proj/Hoplon.png"
				item.dmg = item.dmg * 2
				item.arm = item.arm * 2
	
		
	if Global.Player.get_traits().has("Ihra"):
		if item.type == "armor":
			if item.position == "leg":
				is_transformed = true
				
				item.rumor = item.name + " 숭고한 육체에 의해 변형..."
				item.sprite = "res://Ham_Sprite/Armor/IhranicGem.png"
				item.name = "[color=#60a0d0]Ihranic Gem[/color] [color=#707070](" + textstrip.strip_bbcode(item.name) + ")[/color]"
				item.weight = 1
				item.inflex = 0
				
	
	
	if Global.Player.get_traits().has("Oros"):
		if item.type == "weapon":
			is_transformed = true
			item. class = "oros"
			item.rumor = item.name + " Oros에 의해 변형..."
			item.name = "[color=#8040a0]Shimmering Orb[/color] [color=#707070](" + textstrip.strip_bbcode(item.name) + ")[/color]"
			item.sprite = "res://Ham_Sprite/Weapons/OrosOrb.png"
			item.range = 2
			item.dmgtype = "astral"
			
			item.weight = 1
			item.proj_art = "res://Ham_Sprite/Proj/Proj_Astral.png"
			
	
		if item.type == "armor":
			is_transformed = true
			item. class = "oros"
			item.rumor = item.name + " Oros에 의해 변형..."
			item.name = "[color=#8040a0]Vestige[/color] [color=#707070](" + textstrip.strip_bbcode(item.name) + ")[/color]"
			item.weight = 1
			item.inflex = 0
			item.resist_astral += 10
			
			match item.position:
				"head":
					item.sprite = "res://Ham_Sprite/Armor/OrosHead.png"
				"arm":
					item.sprite = "res://Ham_Sprite/Armor/OrosArms.png"
				"leg":
					item.sprite = "res://Ham_Sprite/Armor/OrosLegs.png"
				"chest":
					item.sprite = "res://Ham_Sprite/Armor/OrosChest.png"
	
	if is_transformed == true:
		ToolInvokes.recharge("transform item")
	
	return is_transformed



static func ihra_starting(item):
	print("IRHANIC GEM")
	var is_transformed = false
	if Global.Player.get_traits().has("Ihra"):
		if item.type == "armor":
			if item.position == "leg":
				is_transformed = true
				
				item.rumor = item.name + " 숭고한 육체에 의해 변형..."
				item.sprite = "res://Ham_Sprite/Armor/IhranicGem.png"
				item.name = "[color=#60a0d0]Ihranic Gem[/color] [color=#707070](" + textstrip.strip_bbcode(item.name) + ")[/color]"
				item.weight = 1
				item.inflex = 0
				
	
	if is_transformed == true:
		var action = {
				"name": "display_item", 
				"item": cloner.clone_dict(item)
			}
		ProcessQueue.add_effect(action)


static func virya_starting(item):
	var is_transformed = false
	if Global.Player.get_traits().has("Virya"):
		if item.type == "weapon":
			
				is_transformed = true
				item.rumor = item.name + " [color=#c03090]Viryanism[/color]에 의해 재련..."
				item.name = "[color=#c03090]Mighty Blade[/color] [color=#707070](" + textstrip.strip_bbcode(item.name) + ")[/color]"
				item.sprite = "res://Ham_Sprite/Weapons/MightyBlade.png"
				item.proj_art = "none"
				item.range = 1
				item.dmgtype = "slash"
				item.aoe = 2
				item.size = 7
				if item.dmg < 10: item.dmg = 10
				if item.weight < 5: item.weight = 5
	if is_transformed == true:
		var action = {
				"name": "display_item", 
				"item": cloner.clone_dict(item)
			}
		ProcessQueue.add_effect(action)



static func pallas_starting(item):
	var is_transformed = false
	if Global.Player.get_traits().has("Pallas"):
		if item.type == "weapon":
			if item.shield == true:
				is_transformed = true
				item.rumor = item.name + " Pallas에 의해 변형..."
				item.name = "[color=#ff7070]Hoplon[/color] [color=#707070](" + textstrip.strip_bbcode(item.name) + ")[/color]"
				item.sprite = "res://Ham_Sprite/Weapons/Hoplon.png"
				item.proj_art = "none"
				item.size = 6
				if item.range > 1:
					item.proj_art = "res://Ham_Sprite/Proj/Hoplon.png"
				item.dmg = item.dmg * 2
				item.arm = item.arm * 2
	if is_transformed == true:
		var action = {
				"name": "display_item", 
				"item": cloner.clone_dict(item)
			}
		ProcessQueue.add_effect(action)



