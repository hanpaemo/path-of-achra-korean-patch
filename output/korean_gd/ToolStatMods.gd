extends Node

class_name StatMods


static func check(unit, label):
	var mod = 0.0
	var traits = unit.get_traits()
	match label:
		"speed":
			mod += speed(unit, traits)
		"dodge":
			mod += dodge(unit, traits)
		"attack":
			mod += attack(unit, traits)
		"damage":
			mod += damage(unit, traits)
		"block":
			mod += block(unit, traits)
		"armor":
			mod += armor(unit, traits)
		"encumbrance":
			mod += encumbrance(unit, traits)
		"inflex":
			mod += inflex(unit, traits)
	return mod


static func speed(unit, traits):
	var mod = 0.0
	
	for buff in unit.Buffs:
		
		
		if buff.name == "Jin-bu":
			mod += 2.0
		if buff.name == "Freeze":
			mod -= 1.0 * buff.duration
		if buff.name == "Entangle":
			mod -= 1.0 * buff.duration
		if buff.name == "Charge":
			if traits.has("Ikami"):
				mod += 1.0 * buff.duration
		if buff.name == "Inflame":
			if traits.has("Frenzied"):
				mod += 1.0 * buff.duration
		if buff.name == "Dream":
			mod -= 2.0 * buff.duration
		if buff.name == "Berserk":
			mod += 1.0 * buff.duration
		if buff.name == "Jackalform":
			mod += 1.0 * buff.duration
		if buff.name == "Batform":
			mod += 1.0 * buff.duration
		if buff.name == "Sparkform":
			mod += 30.0
		if buff.name == "Horrorform":
			mod += 50.0
		
		if buff.name == "Windstrike":
			mod += 100.0
		if traits.has("Champion"):
			if buff.name == "Poise":
				mod += 1.0 * buff.duration
		
	
	
	if traits.has("Mindbreaker"):
		var increase = 1.0 * unit.get_total_WIL()
		mod += increase
	
	if traits.has("BheithNochti"):
		var increase = 8.0 * (4.0 - unit.get_armor_list().size())
		mod += increase
	
	if traits.has("WormMonk"):
		if Global.Allies.size() > 1:
			var increase = 5.0 * (Global.Allies.size() - 1)
			mod += increase
	
	if traits.has("HelmAmethyst"):
		var increase = 5.0 * (4 - unit.get_armor_list().size())
		mod += increase
	
	if traits.has("AttackTwice"):
		mod += 20.0
	
	if traits.has("robe_wind"):
		mod += 10.0
		
	if traits.has("WindRibbon"):
		mod += 10.0
		
	if traits.has("RukfeatherSkirt"):
		mod += 10.0
	
	if traits.has("Kendo"):
		
		var trait = traits.Kendo
		mod += 3.0 * trait.Level
	
	if traits.has("Kerjata"):
		
		var trait = traits.Kerjata
		mod += 5.0 * trait.Level
	
	if traits.has("GoreCleave"):
		var trait = traits.GoreCleave
		mod += 2.0 * trait.Level
	
	return mod


static func dodge(unit, traits):
	
	var mod = 0.0
	for buff in unit.Buffs:
		if buff.name == "Freeze":
			mod -= 1.0 * buff.duration
		if buff.name == "Entangle":
			mod -= 1.0 * buff.duration
		if buff.name == "Dream":
			mod -= 1.0 * buff.duration
		if buff.name == "Berserk":
			mod -= 1.0 * buff.duration
		if buff.name == "Evasion":
			mod += 2.0 * buff.duration
		if buff.name == "Anoint":
			mod += 1.0 * buff.duration
		if buff.name == "Snakeform":
			mod += 1.0 * buff.duration
		if buff.name == "Windstrike":
			mod += 30.0
		if buff.name == "Blind":
			mod -= 2.0 * buff.duration
		if traits.has("Mesmer"):
			if buff.name == "Repulsion":
				mod += 1.0 * buff.duration
	
	if traits.has("BheithNochti"):
		var increase = 10.0 * (4.0 - unit.get_armor_list().size())
		mod += increase
	
	if unit == Global.Player:
		if traits.has("Tengri"):
			mod += float(unit.get_SPEED()) * 1.0
	
	if traits.has("MindKnight"):
		var trait = traits.MindKnight
		mod += 1.0 * trait.Level
	
	
	if traits.has("RobeLight"):
		mod += 10.0
	
	if traits.has("MirrorImage"):
		var trait = traits.MirrorImage
		mod += 10.0 * trait.Level
	
	if traits.has("Assassin"):
		var trait = traits.Assassin
		mod += 5.0 * trait.Level
	
	if traits.has("RapidStrikes") == true:
		if translate.is_bare_fist(unit.weapon_main):
				var trait = traits.RapidStrikes
				mod += 2.0 * trait.Level
	if traits.has("Skera"):
		
		var trait = traits.Skera
		mod += 3.0 * trait.Level
	
	
			
	
	return mod


static func attack(unit, traits):
	var mod = 0.0
	
	for buff in unit.Buffs:
		
		
		if buff.name == "Inflame":
			mod += 1.0 * buff.duration
		if buff.name == "Poise":
			mod += 1.0 * buff.duration
		if buff.name == "Blind":
			mod -= 2.0 * buff.duration
		
	if traits.has("Aim"):
		var trait = traits.Aim
		mod += 10.0 * trait.Level
	
	if traits.has("Skera"):
		var trait = traits.Skera
		mod += 5.0 * trait.Level
	if traits.has("Shamsar"):
		var trait = traits.Shamsar
		mod += 5.0 * trait.Level
	
	if traits.has("BheithNochti"):
		var increase = 10.0 * (4.0 - unit.get_armor_list().size())
		mod += increase
	
	
	return mod


static func damage(unit, traits):
	var mod = 0.0
	
	
	
	
	
	for buff in unit.Buffs:
		if buff.name == "Jin-bu":
			mod += 2.0
		
		if buff.name == "Inflame":
			mod += 2.0 * buff.duration
		
		if buff.name == "Sickness":
			mod -= 1.0 * buff.duration
		
		if buff.name == "Attune":
			mod += 1.0 * buff.duration
		if buff.name == "Anoint":
			mod += 2.0 * buff.duration
		
		
		if buff.name == "Stasis":
			if traits.has("NullChausses"):
				mod += 3.0 * buff.duration
		if buff.name == "Berserk":
			if traits.has("Berserker"):
				mod += 2.0 * buff.duration
		
		if buff.name == "Jackalform":
				mod += 1.0 * buff.duration
	
	
	
	if traits.has("BoulderStyle"):
		if translate.is_bare_fist(unit.weapon_main):
			mod += unit.get_total_weight() * 2.0
			if translate.is_bare_fist(unit.weapon_off):
				mod += unit.get_total_weight() * 2.0
		
	if traits.has("Assassin") == true:
		if unit.get_total_weapon_size() < 5:
			var trait = traits.Assassin
			mod += 5.0 * trait.Level
	
	if traits.has("Might") == true:
			var trait = traits.Might
			mod += 10.0 * trait.Level
	
	if traits.has("HelmAmethyst"):
		var increase = 10.0 * (4 - unit.get_armor_list().size())
		mod += increase
	
	if traits.has("Shamsar"):
		var trait = traits.Shamsar
		mod += 1.0 * trait.Level * trait.base
	
	if traits.has("GoreCleave"):
		var trait = traits.GoreCleave
		mod += 5.0 * trait.Level
	
	if traits.has("RapidStrikes") == true:
		if translate.is_bare_fist(unit.weapon_main):
				var trait = traits.RapidStrikes
				mod += 2.0 * trait.Level
	
	
	
	if traits.has("Samnite"):
		var increase = 10.0 * (4 - unit.get_armor_list().size())
		mod += increase
	
	
		
			
			
	
	
	
	return mod

static func block(unit, traits):
	var mod = 0.0
	
	for buff in unit.Buffs:
		if buff.name == "Berserk":
			mod -= 10.0 * buff.duration
		if buff.name == "Corrosion":
			mod -= 10.0 * buff.duration
		if buff.name == "Repulsion":
			if traits.has("MasterRepulsion"):
				mod += buff.duration
		if buff.name == "Poise":
			mod += 5.0 * buff.duration
		if buff.name == "Drakeform":
			mod += 20.0 * buff.duration
		
		if buff.name == "Inflame":
			if traits.has("GoldenSword"):
				mod += 10.0 * buff.duration
	
	if traits.has("MindKnight") == true:
		var trait = traits.MindKnight
		mod += 1.0 * trait.Level * 15.0
	if unit == Global.Player:
		if unit.invokes.has("contemplation"):
			if unit.level >= unit.invokes.contemplation.level_required:
				mod += unit.invokes.contemplation.use * 10
				
	if traits.has("Skeleton") == true:
		var increase = float(unit.bag.size()) * float(unit.level)
		if StateWorld.land == "dust":
			increase = 33.0 * float(unit.level)
			
		mod += increase
			
	if unit == Global.Player:
		if traits.has("Tengri"):
			mod -= float(unit.get_SPEED()) * 10.0
	if traits.has("Weirding") == true:
		var trait = traits.Weirding
		mod += 25.0 * trait.Level
	
	if traits.has("Isaz") == true:
		var trait = traits.Isaz
		mod += 50.0 * trait.Level
	
	
	
	if traits.has("LiRen") == true:
		if unit.Buffs.size() > 0:
			for buff in unit.Buffs:
				mod += float(buff.duration)
	
	if traits.has("Murmillo"):
		var trait = traits.Murmillo
		mod += 60.0 * trait.Level
	
	
	
	return mod

static func armor(unit, traits):
	
	var mod = 0.0
	
	for buff in unit.Buffs:
		if buff.name == "Poise":
			mod += 5.0 * buff.duration
		if buff.name == "Attune":
			mod += 20.0 * buff.duration
		if buff.name == "Refraction":
			mod += 1.0 * buff.duration
		
		if buff.name == "Corrosion":
			mod -= 10.0 * buff.duration
		if buff.name == "Drakeform":
			mod += 10.0 * buff.duration
		if buff.name == "Repulsion":
			if traits.has("Intabah"):
				mod += buff.duration * 1.0
		if buff.name == "Freeze":
			if traits.has("Parafrost"):
				mod += buff.duration * 2.0
		if buff.name == "Inflame":
			if traits.has("FlameKnight"):
				mod += 30.0 * buff.duration
		if buff.name == "Charge":
			if traits.has("Bolga"):
				mod += 10.0 * buff.duration
		if buff.name == "Stasis":
			if traits.has("VoidHelm"):
				mod += 10.0 * buff.duration
		if buff.name == "Doom":
			if traits.has("MasterDoom"):
				mod += 2.0 * buff.duration
		
	if traits.has("chest_green") == true:
		if unit.Buffs.size() > 0:
			for buff in unit.Buffs:
				mod += float(buff.duration)
	
	if traits.has("Skeleton") == true:
		var increase = float(unit.bag.size()) * float(unit.level)
		if StateWorld.land == "dust":
			increase = 33.0 * float(unit.level)
		mod += increase
	
	if unit == Global.Player:
		if traits.has("Oozemancer"):
			for ally in Global.Allies:
				if ally.get_name() == "Ooze":
					mod += 20.0
	
	if unit == Global.Player:
		if traits.has("Tengri"):
			mod -= float(unit.get_SPEED()) * 10.0
	
	
	
	
	
	
		
			
			
	
	if unit == Global.Player:
		if unit.invokes.has("contemplation"):
			if unit.level >= unit.invokes.contemplation.level_required:
				mod += unit.invokes.contemplation.use * 10.0
	
	
	
	if traits.has("Immaculate"):
		if unit.get_hands_used() == 1:
			var increase = 100.0 * (4 - unit.get_armor_list().size())
			mod += increase
	
	if traits.has("SciaAxe"):
		if unit.get_hands_used() == 1:
			var increase = (10.0 * unit.get_total_STR()) * (4 - unit.get_armor_list().size())
			mod += increase
	
	
	
	
	if traits.has("Volkite"):
		var increase = unit.get_total_weight() * 5
		mod += increase
	
	if traits.has("Rampage"):
		var increase = 50.0 * (4 - unit.get_armor_list().size())
		increase *= traits.Rampage.Level
		mod += increase
	
	if traits.has("Samnite"):
		var increase = 200.0 * (4 - unit.get_armor_list().size())
		mod += increase
	
	
	
	if traits.has("Executioner"):
		if unit.weapon_main != null:
			var increase = 5.0 * unit.get_total_STR() * unit.weapon_main.size
			mod += increase
	
	if traits.has("BoulderStyle"):
		if translate.is_bare_fist(unit.weapon_main):
			mod += unit.get_total_weight() * 5.0
		if unit.get_hands_used() == 2:
			if translate.is_bare_fist(unit.weapon_off):
				mod += unit.get_total_weight() * 5.0
	
	if traits.has("Murmillo"):
		var trait = traits.Murmillo
		mod += 50.0 * trait.Level
	
	if traits.has("Tenacity"):
		var trait = traits.Tenacity
		mod += 1.0 * trait.Level * 40.0
	
	
	
	if traits.has("MindKnight") == true:
		var trait = traits.MindKnight
		mod += 1.0 * trait.Level * 10.0
	
	
	
	
	
	if traits.has("Arjuta") == true:
		var trait = traits.Arjuta
		mod += 100.0 * trait.Level
	
	
		
	
	
	
	return mod


static func encumbrance(unit, traits):
	
	var mod = 0.0
	
	for buff in unit.Buffs:
		pass
		
			
	
	if traits.has("Rampage"):
		var increase = 1.0 * (4 - unit.get_armor_list().size())
		increase *= traits.Rampage.Level
		mod += increase
	
	if traits.has("Tenacity"):
		var trait = traits.Tenacity
		mod += 2.0 * trait.Level
	
	if traits.has("Frostpulse"):
		var trait = traits.Frostpulse
		mod += 5.0 * trait.Level
	
	if traits.has("Gallus"):
		
		mod += 50.0
		
	
	if traits.has("FrostKnight"):
		
		mod += unit.get_total_STR() * 2.0
	
	return mod

static func inflex(unit, traits):
	
	var mod = 0.0
	
	for buff in unit.Buffs:
		pass
		
			
	
	if traits.has("Siku") == true:
		mod += 3.0
	
	if traits.has("Imp") == true:
		mod -= 2.0
	
	if traits.has("Astrohunting"):
		var trait = traits.Astrohunting
		mod -= 1.0 * trait.Level
	
	if traits.has("Arjuta") == true:
		var trait = traits.Arjuta
		mod += 1.0 * trait.Level
	
	if traits.has("Kendo") == true:
		var trait = traits.Kendo
		mod -= 1.0 * trait.Level
	if traits.has("Kerjata") == true:
		var trait = traits.Kerjata
		mod -= 1.0 * trait.Level
	if traits.has("MirrorImage") == true:
		var trait = traits.MirrorImage
		mod -= 1.0 * trait.Level
	if unit == Global.Player:
		if traits.has("BeastVisage"):
			if unit.armor_chest == null:
				mod -= 2.0
		if traits.has("Berserker"):
			
				mod -= 2.0
	
	
	
	return mod
