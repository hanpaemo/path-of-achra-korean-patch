extends Node

class_name prestige

static func check():
	var has_prestige = false
	if Global.Player != null:
		has_prestige = false
		var traits = Global.Player.get_traits()
		for key in traits:
			var trait = traits[key]
			if trait.generic == true:
				if trait.organize == "prestige":
					has_prestige = true
	
	return has_prestige


static func look_for_prestige(traits):
	pass
	print("prestige searched")
	var available_prestiges = []
	var martial_total = 0
	var fire_total = 0
	var life_total = 0
	var lightning_total = 0
	var astral_total = 0
	var psychic_total = 0
	var poison_total = 0
	var death_total = 0
	var blood_total = 0
	var ice_total = 0
	var form_total = 0
	
	var ooze_total = 0
	var necro_total = 0
	var gallus_total = 0
	var starjumper_total = 0
	var strijela_total = 0
	var nochti_total = 0
	var lit_total = 0
	var master_total = 0
	var self_damage = 0
	var chant = 0
	var staff_count = 0
	var beast_count = 0
	var mindfight_count = 0
	var gorecleave_count = 0
	var elementalist_count = 0
	
	var ALL_total = 0
	
	var cost_test = 1
	var cost_standard = 25
	
	
	var items = []
	for item in Global.Player.bag:
		items.append(item)
	var slots = [Global.Player.weapon_main, Global.Player.weapon_off, 
	Global.Player.armor_head, Global.Player.armor_chest, 
	Global.Player.armor_hands, Global.Player.armor_legs]
	for slot in slots:
		if slot != null:
			items.append(slot)
	
	for item in items:
		if "staff" in textstrip.strip_bbcode(item.name).to_lower():
			staff_count += 1
	
	for key in traits:
		var trait = traits[key]
		if trait.generic == false:
			var increase = trait.cost * trait.Level
			
			if "self-damage" in textstrip.strip_bbcode(trait.Description).to_lower():
				self_damage += increase
			
			if "chant" in textstrip.strip_bbcode(trait.Name).to_lower():
				chant += increase
			
			if "kinesis" in textstrip.strip_bbcode(trait.Name).to_lower():
				elementalist_count += increase
			
			ALL_total += increase
			
			match trait.Element:
				
				"Body":
					martial_total += increase
				"Fire":
					fire_total += increase
				"Lightning":
					lightning_total += increase
				"Poison":
					poison_total += increase
				"Life":
					life_total += increase
				"Death":
					death_total += increase
				"Astral":
					astral_total += increase
				"Ice":
					ice_total += increase
				"Blood":
					blood_total += increase
				"Psychic":
					psychic_total += increase
				
			match trait.title:
				"Batform":
					form_total += increase
				"Snakeform":
					form_total += increase
				"Wormform":
					form_total += increase
				"Sparkform":
					form_total += increase
				"Geistform":
					form_total += increase
				"Vineform":
					form_total += increase
			
		
				"SummonRedDragon":
					beast_count += increase
				"SummonGrika":
					beast_count += increase
				"PoisonFamiliar":
					beast_count += increase
		
				"Oozemancy":
					ooze_total += increase
				"Slime":
					ooze_total += increase
				"BurningOoze":
					ooze_total += increase
			
			
				"Necromancy":
					necro_total += increase
				"MavetKa":
					necro_total += increase
				"HungryGrave":
					necro_total += increase
				"ChannelDeath":
					necro_total += increase
			
				"Tenacity":
					gallus_total += increase
				
				"Aim":
					strijela_total += increase
				
				"Rampage":
					nochti_total += increase
				
				"GoreCleave":
					gorecleave_count += increase
				
				"MindKnight":
					mindfight_count += increase
				
				
				"Astrostoicism":
					starjumper_total += increase
				"Astrohunting":
					starjumper_total += increase
				"AstralSeeking":
					starjumper_total += increase
				"Shimmergang":
					starjumper_total += increase
				
				
				"BlightCult":
					lit_total += increase
				"MinionFeast":
					lit_total += increase
				"GroveCult":
					lit_total += increase
				"FlameCult":
					lit_total += increase
				"FulminantCult":
					lit_total += increase
				"StarCult":
					lit_total += increase
				
				"MasterEntangle":
					master_total += increase
				"MasterScorch":
					master_total += increase
				"Parafrost":
					master_total += increase
				"MasterDoom":
					master_total += increase
				"MasterBleed":
					master_total += increase
	
	
	var added_prestige = null
	
	
	
	
	if ALL_total >= 25:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Paragon)
		available_prestiges.append(added_prestige)
	
	

	if Global.Player.armor_head != null:
		if Global.Player.armor_head.title == "beast_visage":
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.UrBeast)
			available_prestiges.append(added_prestige)
	if Global.Player.weapon_main != null:
		if Global.Player.weapon_main.dmg >= 30 and "axe" in textstrip.strip_bbcode(Global.Player.weapon_main.name).to_lower():
				added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.UrBeast)
				available_prestiges.append(added_prestige)
	
	if Global.Player.armor_head != null:
		if Global.Player.armor_head.title == "lizard_visage" or Global.Player.armor_head.arm >= 40:
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.LizardLord)
			available_prestiges.append(added_prestige)
	
	if Global.Player.armor_head != null:
		if Global.Player.armor_head.title == "crow_visage":
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.NightCrow)
			available_prestiges.append(added_prestige)
	if staff_count >= 3:
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.NightCrow)
			available_prestiges.append(added_prestige)
	
	if Global.Player.armor_chest != null:
		if Global.Player.armor_chest.arm >= 120:
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Gallus)
			available_prestiges.append(added_prestige)
	if gallus_total >= 20:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Gallus)
		available_prestiges.append(added_prestige)
	
	if Global.Player.weapon_main != null:
		if Global.Player.weapon_main.dmg >= 35 and Global.Player.weapon_main.dmgtype == "slash":
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Windblade)
			available_prestiges.append(added_prestige)
	
	
	if Global.Player.level >= 20:
		if Global.Player.ELEMENTS == []:
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Anroth)
			available_prestiges.append(added_prestige)
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Ogham)
		available_prestiges.append(added_prestige)
		
	if Global.Player.level >= 20 and StateWorld.land == "achra":
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Struggler)
		available_prestiges.append(added_prestige)
	
	
	if martial_total >= cost_standard:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Champion)
		available_prestiges.append(added_prestige)
		
	if astral_total >= cost_standard:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.ArchMagus)
		available_prestiges.append(added_prestige)
	if ice_total >= cost_standard:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Angiok)
		available_prestiges.append(added_prestige)
	if fire_total >= cost_standard:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Pyromaniac)
		available_prestiges.append(added_prestige)
	if life_total >= cost_standard:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.EarthMage)
		available_prestiges.append(added_prestige)
	if lightning_total >= cost_standard:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Gothi)
		available_prestiges.append(added_prestige)
	if death_total >= cost_standard:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Doomsayer)
		available_prestiges.append(added_prestige)
	if poison_total >= cost_standard:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Venite)
		available_prestiges.append(added_prestige)
	if blood_total >= cost_standard:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.BloodMage)
		available_prestiges.append(added_prestige)
	if psychic_total >= cost_standard:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Mesmer)
		available_prestiges.append(added_prestige)
	
	if form_total >= 10:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Shapeshifter)
		available_prestiges.append(added_prestige)
	
	if master_total >= 20:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Torturer)
		available_prestiges.append(added_prestige)
	
	if ooze_total >= 20:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Oozemancer)
		available_prestiges.append(added_prestige)
	
	if necro_total >= 20:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Necromancer)
		available_prestiges.append(added_prestige)
	
	
	if beast_count >= 20:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Beastmaster)
		available_prestiges.append(added_prestige)
	
	if nochti_total >= 20:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.BheithNochti)
		available_prestiges.append(added_prestige)
	
	if lit_total >= 20:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Liturgist)
		available_prestiges.append(added_prestige)
	
	if strijela_total >= 20:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Strijela)
		available_prestiges.append(added_prestige)
	
	if starjumper_total >= 20:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Starjumper)
		available_prestiges.append(added_prestige)
	
	if chant >= 20:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Uhrata)
		available_prestiges.append(added_prestige)
	
	if mindfight_count >= 20:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Aqliyya)
		available_prestiges.append(added_prestige)
	
	if gorecleave_count >= 20:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Suwag)
		available_prestiges.append(added_prestige)
	
	if elementalist_count >= 20:
		added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Elementalist)
		available_prestiges.append(added_prestige)
	
	if poison_total + fire_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Poison") and Global.Player.ELEMENTS.has("Fire"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Hazar)
			available_prestiges.append(added_prestige)
	
	if martial_total + self_damage >= cost_standard:
		if Global.Player.ELEMENTS.has("Body") and self_damage > 0:
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Berserker)
			available_prestiges.append(added_prestige)
	
	if martial_total + astral_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Body") and Global.Player.ELEMENTS.has("Astral"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Sahasi)
			available_prestiges.append(added_prestige)
	
	if poison_total + death_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Poison") and Global.Player.ELEMENTS.has("Death"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Plaguemancer)
			available_prestiges.append(added_prestige)
	
	if poison_total + astral_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Poison") and Global.Player.ELEMENTS.has("Astral"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.IllProphet)
			available_prestiges.append(added_prestige)
	
	if fire_total + lightning_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Fire") and Global.Player.ELEMENTS.has("Lightning"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Tamasa)
			available_prestiges.append(added_prestige)
			
	
	if martial_total + lightning_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Body") and Global.Player.ELEMENTS.has("Lightning"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Shantih)
			available_prestiges.append(added_prestige)
	
	if martial_total + ice_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Body") and Global.Player.ELEMENTS.has("Ice"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.FrostKnight)
			available_prestiges.append(added_prestige)
	
	if martial_total + psychic_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Body") and Global.Player.ELEMENTS.has("Psychic"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.MindKnightPrestige)
			available_prestiges.append(added_prestige)
	if blood_total + fire_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Blood") and Global.Player.ELEMENTS.has("Fire"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Exultite)
			available_prestiges.append(added_prestige)
	if psychic_total + blood_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Blood") and Global.Player.ELEMENTS.has("Psychic"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Mindbreaker)
			available_prestiges.append(added_prestige)
	
	if fire_total + death_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Fire") and Global.Player.ELEMENTS.has("Death"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Topheth)
			available_prestiges.append(added_prestige)
	if life_total + death_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Life") and Global.Player.ELEMENTS.has("Death"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.WormMonk)
			available_prestiges.append(added_prestige)
	if lightning_total + death_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Lightning") and Global.Player.ELEMENTS.has("Death"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Bolga)
			available_prestiges.append(added_prestige)
	if blood_total + life_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Life") and Global.Player.ELEMENTS.has("Blood"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.BloodDrinker)
			available_prestiges.append(added_prestige)
	if fire_total + psychic_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Fire") and Global.Player.ELEMENTS.has("Psychic"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Frenzied)
			available_prestiges.append(added_prestige)
	if ice_total + psychic_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Ice") and Global.Player.ELEMENTS.has("Psychic"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Dreamer)
			available_prestiges.append(added_prestige)
	if ice_total + poison_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Ice") and Global.Player.ELEMENTS.has("Poison"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Uspori)
			available_prestiges.append(added_prestige)
	if ice_total + blood_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Ice") and Global.Player.ELEMENTS.has("Blood"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Anqarak)
			available_prestiges.append(added_prestige)
	if astral_total + ice_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Astral") and Global.Player.ELEMENTS.has("Ice"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Mura)
			available_prestiges.append(added_prestige)
	if lightning_total + life_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Lightning") and Global.Player.ELEMENTS.has("Life"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Ormjarl)
			available_prestiges.append(added_prestige)
	if astral_total + blood_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Astral") and Global.Player.ELEMENTS.has("Blood"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Horror)
			available_prestiges.append(added_prestige)
	if psychic_total + life_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Psychic") and Global.Player.ELEMENTS.has("Life"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Gliva)
			available_prestiges.append(added_prestige)
	if fire_total + life_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Fire") and Global.Player.ELEMENTS.has("Life"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Arsonist)
			available_prestiges.append(added_prestige)
	if death_total + ice_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Death") and Global.Player.ELEMENTS.has("Ice"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.VoidMage)
			available_prestiges.append(added_prestige)
	if lightning_total + ice_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Lightning") and Global.Player.ELEMENTS.has("Ice"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Stormbringer)
			available_prestiges.append(added_prestige)
	if astral_total + fire_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Astral") and Global.Player.ELEMENTS.has("Fire"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Kashra)
			available_prestiges.append(added_prestige)
	if martial_total + life_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Body") and Global.Player.ELEMENTS.has("Life"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Samnite)
			available_prestiges.append(added_prestige)
	if blood_total + martial_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Body") and Global.Player.ELEMENTS.has("Blood"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Executioner)
			available_prestiges.append(added_prestige)
	if blood_total + death_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Death") and Global.Player.ELEMENTS.has("Blood"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.PainCleric)
			available_prestiges.append(added_prestige)
	if astral_total + psychic_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Astral") and Global.Player.ELEMENTS.has("Psychic"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Psychonaut)
			available_prestiges.append(added_prestige)
	if ice_total + life_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Ice") and Global.Player.ELEMENTS.has("Life"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.IceShah)
			available_prestiges.append(added_prestige)
	
	if martial_total + death_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Death") and Global.Player.ELEMENTS.has("Body"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.DeathKnight)
			available_prestiges.append(added_prestige)
	
	if lightning_total + astral_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Lightning") and Global.Player.ELEMENTS.has("Astral"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Alizeh)
			available_prestiges.append(added_prestige)
	if fire_total + ice_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Fire") and Global.Player.ELEMENTS.has("Ice"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Surtmir)
			available_prestiges.append(added_prestige)
	if psychic_total + poison_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Psychic") and Global.Player.ELEMENTS.has("Poison"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Vengati)
			available_prestiges.append(added_prestige)
	if blood_total + poison_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Blood") and Global.Player.ELEMENTS.has("Poison"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Merzot)
			available_prestiges.append(added_prestige)
	if life_total + poison_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Life") and Global.Player.ELEMENTS.has("Poison"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.SnakeCharmer)
			available_prestiges.append(added_prestige)
	if life_total + astral_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Life") and Global.Player.ELEMENTS.has("Astral"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Arborus)
			available_prestiges.append(added_prestige)
	if death_total + psychic_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Death") and Global.Player.ELEMENTS.has("Psychic"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Acolyte)
			available_prestiges.append(added_prestige)
	if psychic_total + lightning_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Psychic") and Global.Player.ELEMENTS.has("Lightning"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Samsi)
			available_prestiges.append(added_prestige)
	if martial_total + poison_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Body") and Global.Player.ELEMENTS.has("Poison"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Dianmai)
			available_prestiges.append(added_prestige)
	if martial_total + fire_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Body") and Global.Player.ELEMENTS.has("Fire"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.FlameKnight)
			available_prestiges.append(added_prestige)
	if astral_total + death_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Astral") and Global.Player.ELEMENTS.has("Death"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Destroyer)
			available_prestiges.append(added_prestige)
	if blood_total + lightning_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Blood") and Global.Player.ELEMENTS.has("Lightning"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Damunja)
			available_prestiges.append(added_prestige)
	if poison_total + lightning_total >= cost_standard:
		if Global.Player.ELEMENTS.has("Poison") and Global.Player.ELEMENTS.has("Lightning"):
			added_prestige = cloner.clone_dict(LTraitsGeneric.trait_data.Shazuza)
			available_prestiges.append(added_prestige)
	
	if Global.testmode == true:
		for key in LTraitsGeneric.trait_data:
			var trait = LTraitsGeneric.trait_data[key]
			if trait.organize == "prestige":
				if available_prestiges.has(trait) == false:
					available_prestiges.append(cloner.clone_dict(trait))
	
	
		
	return available_prestiges

static func add_prestige(trait):
	print("prestige added!")
	
	Global.Player.abilities[trait.title] = trait
	Global.Player.title_class = trait.Name
	StatePlayerSheet.title_class = StatePlayerSheet.title_class + " " + trait.Name
	Global.Player.update()
	event_learn.check(trait.title, trait.Name)
				
	



static func trans_prestige_to_cheevo(trait):
	var stringa = ""
	match trait.title:
		"Champion":
			stringa = "champion"
		"Pyromaniac":
			stringa = "pyromaniac"
		"Gothi":
			stringa = "gothi"
		"Shapeshifter":
			stringa = "shapeshifter"
		"EarthMage":
			stringa = "earthmage"
		"Executioner":
			stringa = "executioner"
		"Doomsayer":
			stringa = "doomsayer"
		"Psychonaut":
			stringa = "psychonaut"
		"IceShah":
			stringa = "iceshah"
		"Venite":
			stringa = "venite"
		"VoidMage":
			stringa = "voidmage"
		"ArchMagus":
			stringa = "archmagus"
		"Samnite":
			stringa = "samnite"
		"Sahasi":
			stringa = "sahasi"
		"Angiok":
			stringa = "angiok"
		"Kashra":
			stringa = "kashra"
		"Mindbreaker":
			stringa = "mindbreaker"
		"BloodMage":
			stringa = "bloodmage"
		"Paragon":
			stringa = "paragon"
		"PainCleric":
			stringa = "paincleric"
		"Oozemancer":
			stringa = "oozemancer"
		"Stormbringer":
			stringa = "stormbringer"
		"Arsonist":
			stringa = "arsonist"
		"MindKnightPrestige":
			stringa = "mindknight"
		"Exultite":
			stringa = "exultite"
		"DeathKnight":
			stringa = "DeathKnight"
		"Necromancer":
			stringa = "Necromancer"
		"Alizeh":
			stringa = "Alizeh"
		"Surtmir":
			stringa = "Surtmir"
		"Vengati":
			stringa = "Vengati"
		"Dianmai":
			stringa = "Dianmai"
		"FlameKnight":
			stringa = "FlameKnight"
		"Mesmer":
			stringa = "Mesmer"
		"Gallus":
			stringa = "Gallus"
		"Destroyer":
			stringa = "Destroyer"
		"Liturgist":
			stringa = "Liturgist"
		"FrostKnight":
			stringa = "FrostKnight"
		"BheithNochti":
			stringa = "BheithNochti"
		"Torturer":
			stringa = "Torturer"
		"IllProphet":
			stringa = "IllProphet"
		"Shantih":
			stringa = "Shantih"
		"Tamasa":
			stringa = "Tamasa"
		"Windblade":
			stringa = "Windblade"
		"Strijela":
			stringa = "Strijela"
		"Starjumper":
			stringa = "Starjumper"
		"Hazar":
			stringa = "Hazar"
		"Topheth":
			stringa = "Topheth"
		"LizardLord":
			stringa = "LizardLord"
		"Plaguemancer":
			stringa = "Plaguemancer"
		"Gliva":
			stringa = "Gliva"
		"Frenzied":
			stringa = "Frenzied"
		"Horror":
			stringa = "Horror"
		"Mura":
			stringa = "Mura"
		"Ormjarl":
			stringa = "Ormjarl"
		"SnakeCharmer":
			stringa = "SnakeCharmer"
		"Merzot":
			stringa = "Merzot"
		"Shazuza":
			stringa = "Shazuza"
		"Damunja":
			stringa = "Damunja"
		"Uspori":
			stringa = "Uspori"
		"Dreamer":
			stringa = "Dreamer"
		"Berserker":
			stringa = "Berserker"
		"WormMonk":
			stringa = "WormMonk"
		"BloodDrinker":
			stringa = "BloodDrinker"
		"Bolga":
			stringa = "Bolga"
		"Arborus":
			stringa = "Arborus"
		"Samsi":
			stringa = "Samsi"
		"Acolyte":
			stringa = "Acolyte"
		"UrBeast":
			stringa = "UrBeast"
		"Anqarak":
			stringa = "Anqarak"
		"Uhrata":
			stringa = "Uhrata"
		"NightCrow":
			stringa = "NightCrow"
		"Beastmaster":
			stringa = "Beastmaster"
		"Elementalist":
			stringa = "Elementalist"
		"Aqliyya":
			stringa = "Aqliyya"
		"Suwag":
			stringa = "Suwag"
		"Anroth":
			stringa = "Anroth"
		"Ogham":
			stringa = "Ogham"
		"Struggler":
			stringa = "Struggler"
	
	return stringa
			

static func trans_prestige_to_requirement_text(trait):
	var stringa = "[color=#a0a0a0]필요조건: "
	var cost_standard = "25"
	match trait.title:
		
		"Anroth":
			stringa += "[color=#ff5050]능력 없이[/color] [color=#ffff50]영광[/color] 20"
		
		"Ogham":
			stringa += "[color=#ffff50]영광[/color] 20"
		
		"Struggler":
			stringa += "아크라의 땅에서 [color=#ffff50]영광[/color] 20"
		
		"Shapeshifter":
			stringa += "아무 [color=#ffff50]변신[/color]에 10 포인트"
			stringa += "\n\n  [color=#a0a000]Batform[/color]"
			stringa += "\n  [color=#ff8000]Newtform[/color]"
			stringa += "\n  [color=#70ff00]Snakeform[/color]"
			stringa += "\n  [color=#0060ff]Sparkform[/color]"
			stringa += "\n  [color=#FFC0CB]Crystalform[/color]"
			stringa += "\n  [color=#00a000]Vineform[/color]"
		
		"Torturer":
			stringa += "아무 [color=#ff5050]유해[/color] [color=#ffff50]마스터[/color]에 20 포인트"
			stringa += "\n\n  [color=#ff8000]Master Scorch[/color]"
			stringa += "\n  [color=#5080ff]Master Freeze[/color]"
			stringa += "\n  [color=#a0a000]Master Doom[/color]"
			stringa += "\n  [color=#ff1010]Master Bleed[/color]"
			stringa += "\n  [color=#00a000]Master Entangle[/color]"
		
		"Beastmaster":
			stringa += "아무 [color=#ffff50]야수 사역마[/color]에 20 포인트"
			stringa += "\n\n  [color=#ff8000]Fire Familiar[/color]"
			stringa += "\n  [color=#5080ff]Ice Familiar[/color]"
			stringa += "\n  [color=#70ff00]Poison Familiar[/color]"
			
		"Elementalist":
			stringa += "아무 [color=#ffff50]키네시스[/color]에 20 포인트"
			stringa += "\n\n  [color=#00a000]Vinakinesis[/color]  [color=#ff8000]Pyrokinesis[/color]"
			stringa += "\n  [color=#70ff00]Toxokinesis[/color]  [color=#8030af]Astrokinesis[/color]"
			stringa += "\n  [color=#0060ff]Electrokinesis[/color]  [color=#ffaf30]Psychokinesis[/color]"
			stringa += "\n  [color=#5080ff]Cryokinesis[/color]  [color=#a0a000]Necrokinesis[/color]"
			stringa += "\n  [color=#ff1010]Hemokinesis[/color]"
			
		"Starjumper":
			stringa += "아무 [color=#a030b0]순간이동[/color]에 20 포인트"
			stringa += "\n\n  [color=#8030af]Astrostoicism[/color]"
			stringa += "\n  [color=#8030af]Astrohunting[/color]"
			stringa += "\n  [color=#8030af]Master Teleport[/color]"
			stringa += "\n  [color=#8030af]Shimmergang[/color]"
		
		"Necromancer":
			stringa += "20" + " 포인트, 아무 [color=#a0a000]언데드[/color]"
			stringa += "\n\n  [color=#a0a000]Necrokinesis[/color]"
			stringa += "\n  [color=#a0a000]Necromancy[/color]"
			stringa += "\n  [color=#a0a000]Dread Legion[/color]"
			stringa += "\n  [color=#a0a000]Grave Chant[/color]"
		
		"Uhrata":
			stringa += "20" + " 포인트, 아무 [color=#78bca4]성가[/color]"
		
		"Gallus":
			stringa += "20" + " 포인트, [color=#af8f50]Heavyweight[/color], 또는 가슴 방어구 기본 [color=#5050ff]방어력[/color] 120 이상"
		
		"Aqliyya":
			stringa += "20" + " 포인트, [color=#ffaf30]Mindfighter[/color]"
		
		"Suwag":
			stringa += "20" + " 포인트, [color=#ff1010]Gore Cleave[/color]"
		
		"Strijela":
			stringa += "20" + " 포인트, [color=#af8f50]Aim[/color]"
		
		"Windblade":
			stringa += "주무장 [color=#af8f50]참격[/color] 무기, 기본 [color=#ff8030]명중[/color] 350 이상"
		
		"UrBeast":
			stringa += "[color=#a07040]Beast Visage[/color] 장착, 또는 주무장 [color=#ffff50]'Axe'[/color] 무기 기본 [color=#ff8030]명중[/color] 300 이상"
		
		"LizardLord":
			stringa += "[color=#40a000]Lizard Visage[/color] 장착, 또는 머리 방어구 기본 [color=#5050ff]방어력[/color] 40 이상"
		
		"NightCrow":
			stringa += "[color=#7050a0]Crow Visage[/color] 장착, 또는 인벤토리에 [color=#ffff50]'Staff'[/color] 무기 3개 이상"
		
		"BheithNochti":
			stringa += "20" + " 포인트, [color=#af8f50]Bheith Nocht[/color]"
		
		"Paragon":
			stringa += "25" + " 포인트, [color=#ffff50]아무 것[/color]"
			
		"Liturgist":
			stringa += "20" + " 포인트, 아무 [color=#8050f0]교단[/color]"
			stringa += "\n\n  [color=#a0a000]Blight Cult[/color]"
			stringa += "\n  [color=#ff1010]Gore Cult[/color]"
			stringa += "\n  [color=#00a000]Grove Cult[/color]"
			stringa += "\n  [color=#ff8000]Flame Cult[/color]"
			stringa += "\n  [color=#0060ff]Fulminant Cult[/color]"
			stringa += "\n  [color=#8030af]Star Cult[/color]"
		
		"Oozemancer":
			stringa += "20" + " 포인트, 아무 [color=#70ff00]점액[/color]"
			stringa += "\n\n  [color=#70ff00]Oozemancy[/color]"
			stringa += "\n  [color=#70ff00]Burning Ooze[/color]"
			stringa += "\n  [color=#70ff00]Acidify[/color]"
	
		"Champion":
			stringa += cost_standard + " 포인트, [color=#af8f50]무술[/color]"
		"Pyromaniac":
			stringa += cost_standard + " 포인트, [color=#ff7000]화염[/color]"
		"Gothi":
			stringa += cost_standard + " 포인트, [color=#0060ff]번개[/color]"
		"EarthMage":
			stringa += cost_standard + " 포인트, [color=#00a000]생명[/color]"
		"Hazar":
			stringa += cost_standard + " 포인트, [color=#ff7000]화염[/color] + [color=#70ff00]독[/color]"
		"Executioner":
			stringa += cost_standard + " 포인트, [color=#ff1010]혈[/color] + [color=#af8f50]무술[/color]"
		"Doomsayer":
			stringa += cost_standard + " 포인트, [color=#a0a000]죽음[/color]"
		"Psychonaut":
			stringa += cost_standard + " 포인트, [color=#ffaf30]정신[/color] + [color=#8030af]성계[/color]"
		"IceShah":
			stringa += cost_standard + " 포인트, [color=#5080ff]냉기[/color] + [color=#00a000]생명[/color]"
		"Venite":
			stringa += cost_standard + " 포인트, [color=#70ff00]독[/color]"
		"Uspori":
			stringa += cost_standard + " 포인트, [color=#5080ff]냉기[/color] + [color=#70ff00]독[/color]"
		"Anqarak":
			stringa += cost_standard + " 포인트, [color=#5080ff]냉기[/color] + [color=#ff1010]혈[/color]"
		"Berserker":
			stringa += cost_standard + " 포인트, [color=#af8f50]무술[/color] + [color=#ff5050]'자해 피해'[/color]"
		"Dreamer":
			stringa += cost_standard + " 포인트, [color=#5080ff]냉기[/color] + [color=#ffaf30]정신[/color]"
		"WormMonk":
			stringa += cost_standard + " 포인트, [color=#00a000]생명[/color] + [color=#a0a000]죽음[/color]"
		"Bolga":
			stringa += cost_standard + " 포인트, [color=#0060ff]번개[/color] + [color=#a0a000]죽음[/color]"
		"Samsi":
			stringa += cost_standard + " 포인트, [color=#0060ff]번개[/color] + [color=#ffaf30]정신[/color]"
		"Acolyte":
			stringa += cost_standard + " 포인트, [color=#a0a000]죽음[/color] + [color=#ffaf30]정신[/color]"
		"BloodDrinker":
			stringa += cost_standard + " 포인트, [color=#00a000]생명[/color] + [color=#ff1010]혈[/color]"
		"VoidMage":
			stringa += cost_standard + " 포인트, [color=#5080ff]냉기[/color] + [color=#a0a000]죽음[/color]"
		"Destroyer":
			stringa += cost_standard + " 포인트, [color=#8030af]성계[/color] + [color=#a0a000]죽음[/color]"
		"Arborus":
			stringa += cost_standard + " 포인트, [color=#8030af]성계[/color] + [color=#00a000]생명[/color]"
		"SnakeCharmer":
			stringa += cost_standard + " 포인트, [color=#70ff00]독[/color] + [color=#00a000]생명[/color]"
		"Merzot":
			stringa += cost_standard + " 포인트, [color=#70ff00]독[/color] + [color=#ff1010]혈[/color]"
		"Plaguemancer":
			stringa += cost_standard + " 포인트, [color=#70ff00]독[/color] + [color=#a0a000]죽음[/color]"
		"IllProphet":
			stringa += cost_standard + " 포인트, [color=#8030af]성계[/color] + [color=#70ff00]독[/color]"
		"Mura":
			stringa += cost_standard + " 포인트, [color=#8030af]성계[/color] + [color=#5080ff]냉기[/color]"
		"Horror":
			stringa += cost_standard + " 포인트, [color=#8030af]성계[/color] + [color=#ff1010]혈[/color]"
		"Stormbringer":
			stringa += cost_standard + " 포인트, [color=#5080ff]냉기[/color] + [color=#0060ff]번개[/color]"
		"Damunja":
			stringa += cost_standard + " 포인트, [color=#ff1010]혈[/color] + [color=#0060ff]번개[/color]"
		"Shazuza":
			stringa += cost_standard + " 포인트, [color=#70ff00]독[/color] + [color=#0060ff]번개[/color]"
		"ArchMagus":
			stringa += cost_standard + " 포인트, [color=#8030af]성계[/color]"
		"Shantih":
			stringa += cost_standard + " 포인트, [color=#0060ff]번개[/color] + [color=#af8f50]무술[/color]"
		"Ormjarl":
			stringa += cost_standard + " 포인트, [color=#0060ff]번개[/color] + [color=#00a000]생명[/color]"
		"Frenzied":
			stringa += cost_standard + " 포인트, [color=#ffaf30]정신[/color] + [color=#ff7000]화염[/color]"
		"Tamasa":
			stringa += cost_standard + " 포인트, [color=#0060ff]번개[/color] + [color=#ff7000]화염[/color]"
		"Samnite":
			stringa += cost_standard + " 포인트, [color=#00a000]생명[/color] + [color=#af8f50]무술[/color]"
		"Sahasi":
			stringa += cost_standard + " 포인트, [color=#8030af]성계[/color] + [color=#af8f50]무술[/color]"
		"Angiok":
			stringa += cost_standard + " 포인트, [color=#5080ff]냉기[/color]"
		"Topheth":
			stringa += cost_standard + " 포인트, [color=#ff7000]화염[/color] + [color=#a0a000]죽음[/color]"
		"Kashra":
			stringa += cost_standard + " 포인트, [color=#ff7000]화염[/color] + [color=#8030af]성계[/color]"
		"FlameKnight":
			stringa += cost_standard + " 포인트, [color=#ff7000]화염[/color] + [color=#af8f50]무술[/color]"
		"FrostKnight":
			stringa += cost_standard + " 포인트, [color=#5080ff]냉기[/color] + [color=#af8f50]무술[/color]"
		"Mesmer":
			stringa += cost_standard + " 포인트, [color=#ffaf30]정신[/color]"
		"Gliva":
			stringa += cost_standard + " 포인트, [color=#ffaf30]정신[/color] + [color=#00a000]생명[/color]"
		"Mindbreaker":
			stringa += cost_standard + " 포인트, [color=#ffaf30]정신[/color] + [color=#ff1010]혈[/color]"
		"BloodMage":
			stringa += cost_standard + " 포인트, [color=#ff1010]혈[/color]"
		"PainCleric":
			stringa += cost_standard + " 포인트, [color=#ff1010]혈[/color] + [color=#a0a000]죽음[/color]"
		"Arsonist":
			stringa += cost_standard + " 포인트, [color=#ff7000]화염[/color] + [color=#00a000]생명[/color]"
		"MindKnightPrestige":
			stringa += cost_standard + " 포인트, [color=#af8f50]무술[/color] + [color=#ffaf30]정신[/color]"
		"Exultite":
			stringa += cost_standard + " 포인트, [color=#ff7000]화염[/color] + [color=#ff1010]혈[/color]"
		"DeathKnight":
			stringa += cost_standard + " 포인트, [color=#af8f50]무술[/color] + [color=#a0a000]죽음[/color]"
		"Alizeh":
			stringa += cost_standard + " 포인트, [color=#8030af]성계[/color] + [color=#0060ff]번개[/color]"
		"Surtmir":
			stringa += cost_standard + " 포인트, [color=#ff7000]화염[/color] + [color=#5080ff]냉기[/color]"
		"Vengati":
			stringa += cost_standard + " 포인트, [color=#70ff00]독[/color] + [color=#ffaf30]정신[/color]"
		"Dianmai":
			stringa += cost_standard + " 포인트, [color=#af8f50]무술[/color] + [color=#70ff00]독[/color]"
		
		
	return stringa
