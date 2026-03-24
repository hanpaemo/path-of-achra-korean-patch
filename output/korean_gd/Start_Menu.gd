extends Node2D

var menu_shown = false
var scene_disabled = false



var buttons_all = []

var list_races = []
var list_classes = []
var list_gods = []

var is_typing = false

var selected_race = null
var selected_class = null
var selected_god = null

var race_data
var class_data
var god_data
var invokes_data
var merged_data

var victory_markers = []

var hovered_button = null

var saved_game = null
var is_loaded = false

var drawn_continent_sprites = []
var lines = []

var glory_hovered = false

var x_limit = 172



	
var auto_buffer = 0
var auto_buffer_max = 15

var right_click_buffer = 0
var right_click_buffer_max = 5

var skin_variant = 1
var skin_variant_max = 5

var winning_titles = []


func _ready():
	
	skin_variant = Global.rng.randi_range(1, skin_variant_max)
	
	
	Global.start_menu = get_node(".")
	ProcessQueueNongame.paused = false
	$version.text = str(Global.version) + "   " + str(Global.export_type) + "   " + str(Global.os_type)
	if Global.test == false:
		$ClearUnlocks.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$ClearUnlocks.visible = false
	
	
	
	race_data = loader.load_data("res://Data/Table_Races.json")
	
	class_data = loader.load_data("res://Data/Table_Classes.json")
	god_data = loader.load_data("res://Data/Table_Gods.json")
	invokes_data = loader.load_data("res://Data/Table_Invokes.json")
	
	var data_list = [class_data, god_data, race_data]
	merged_data = cloner.clone_and_merge(data_list)
	
	
	
	
	add_new_keys_to_locked()
	
	
	
	saved_game = saveload.loadData()
	
	
	selected_race = race_data[ToolSettings.settings_data.race]
	selected_god = god_data[ToolSettings.settings_data.god]
	selected_class = class_data[ToolSettings.settings_data. class ]
	StateWorld.continent.delete()
	StateWorld.type = "none"
	
	winning_titles = get_winning_titles()
	
	if saved_game.has("EXISTS"):
		if saved_game.EXISTS == false:
			gencont.generate("achra")
		elif saved_game.has("version_number"):
			if saved_game.version_number != Global.version_number:
				print("SAVE FROM INVALID VERSION")
				saved_game = saveload.create_empty_file()
				gencont.generate("achra")
			else:
				is_loaded = true
				gencont.load_continent(saved_game)
		else:
			print("SAVE FROM INVALID VERSION")
			saved_game = saveload.create_empty_file()
			gencont.generate("achra")
	else:
		gencont.generate("achra")
	
	
	custom_update()

func _process(_delta):
	
	if right_click_buffer < right_click_buffer_max:
		right_click_buffer += 1
	
	menu_shown = Global.options_menu_open
	ProcessQueueNongame.process_check()
	if ToolSettings.settings_data.glory_added > 0:
			ToolSettings.settings_data.glory += 1
			ToolSettings.settings_data.glory_added -= 1
			ToolSettings.save_settings()
	if ToolSettings.settings_data.locked_keys.size() > 0:
		pass

		if ToolSettings.settings_data.glory >= ToolSettings.settings_data.glory_needed:
			if ToolSettings.settings_data.locked_keys.size() > 0:
				ToolSettings.settings_data.glory -= ToolSettings.settings_data.glory_needed
				ToolSettings.settings_data.glory_needed += 3
				if ToolSettings.settings_data.glory_needed >= 10:
					ToolSettings.settings_data.glory_needed = 10
			
				ToolSettings.save_settings()
				print(str(ToolSettings.settings_data.glory_needed) + " glory needed")
		
				unlock_random_key()
		
	else:
		pass
	
	var length = int(float((ToolSettings.settings_data.glory / ToolSettings.settings_data.glory_needed) * 500.0))
	if length > 500.0:
		length = 500.0
	
	$glory_progress / meter.rect_size.x = length
	
	write_glorybar()
	
	if Input.is_action_pressed("tab"):
		auto_buffer += 1
		if auto_buffer >= auto_buffer_max:
			auto_buffer = 0
			if Input.is_action_pressed("alt") == false and Input.is_action_pressed("shift") == false:
					press_randomize()
	else:
		auto_buffer = 0
	
	

func reset_selected():
	selected_race = race_data[ToolSettings.settings_data.race]
	selected_god = god_data[ToolSettings.settings_data.god]
	selected_class = class_data[ToolSettings.settings_data. class ]
	is_loaded = false
	StateWorld.continent.delete()
	StateWorld.type = "none"
	gencont.generate("achra")
	update_selected()


func randomize_character():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var unlocked_races = get_unlocked_from_data(race_data)
	var unlocked_gods = get_unlocked_from_data(god_data)
	var unlocked_classes = get_unlocked_from_data(class_data)
	
	selected_class = unlocked_classes[rng.randi_range(0, unlocked_classes.size() - 1)]
	selected_god = unlocked_gods[rng.randi_range(0, unlocked_gods.size() - 1)]
	selected_race = unlocked_races[rng.randi_range(0, unlocked_races.size() - 1)]
	
	
	
	pass

func get_unlocked_from_data(list):
	var dict_array = []
	for key in list:
		if ToolSettings.settings_data.locked_keys.has(key) == false:
		
			dict_array.append(list[key])
	return dict_array

func add_new_keys_to_locked():
	for key in merged_data:
		if ToolSettings.settings_data.locked_keys.has(key) == false:
			if ToolSettings.settings_data.unlocked_keys.has(key) == false:
				ToolSettings.settings_data.locked_keys.append(key)
				
	ToolSettings.save_settings()
	
func update_selected():
	
	for button in buttons_all:
		
		if button.victorious == true and ToolSettings.settings_data.victory_markers == true:
			button.get_node("victory").visible = true
		else:
			button.get_node("victory").visible = false
		
		if button.trait == selected_race:
			$Select_Race.position = button.position
		elif button.trait == selected_class:
			$Select_Class.position = button.position
		elif button.trait == selected_god:
			$Select_God.position = button.position
		
		if is_typing == false:
			button.modulate = Color(1, 1, 1, 1)
			if button.locked == true:
				button.modulate = Color(0.1, 0.1, 0.1, 1)
			elif button.trait != selected_race and button.trait != selected_class and button.trait != selected_god:
				button.modulate = Color(0.7, 0.7, 0.7, 1)
	
	if is_loaded == true:
		$Select_God.position = $Pos_Continue.position
		$Select_Class.position = $Pos_Continue.position
		$Select_Race.position = $Pos_Continue.position
		$Continue / Label.bbcode_text = "[color=#a05050]저장 [color=#ffff50]삭[/color]제[/color]"
		$Button_Start / Label.text = "계속"
	else:
		$Continue / Label.bbcode_text = "[color=#50a050]저장 [color=#ffff50]불[/color]러오기[/color]"
		$Button_Start / Label.text = "시작"
	update_highlight()
	set_player_sheet()
	draw_body()
	write_description()
	pass

func custom_update():
	if saved_game.has("EXISTS"):
		if saved_game.EXISTS == false:
			$Continue.mouse_filter = Control.MOUSE_FILTER_IGNORE
			$Continue.modulate = Color(1, 1, 1, 0.3)
		else:
			if saved_game.has("version_number"):
				if saved_game.version_number != Global.version_number:
					$Continue.mouse_filter = Control.MOUSE_FILTER_IGNORE
					$Continue.modulate = Color(1, 1, 1, 0.3)
				else:
					$Continue.mouse_filter = Control.MOUSE_FILTER_STOP
					$Continue.modulate = Color(1, 1, 1, 1)
		
	
	
	
	for button in buttons_all:
		button.queue_free()
	
	
	
	buttons_all = []
	print(str(buttons_all.size()) + " buttons before stalks grown")
	create_stalks()
	print(str(buttons_all.size()) + " buttons after stalks grown")
	
	
	setup_deckbuttons()
	update_selected()


func prune_buttons_all():
	var duplicate_titles = []
	var to_erase = []
	for button in buttons_all:
		if duplicate_titles.has(button.trait.title):
			to_erase.append(button)
		duplicate_titles.append(button.trait.title)
	for button in buttons_all:
		if to_erase.has(button) == false:
			buttons_all.erase(button)
			button.queue_free()
	buttons_all = to_erase

func set_player_sheet():
	
	if is_loaded == false:
		StatePlayerSheet.POINTS = 1
		StatePlayerSheet.POINTS_TRAITS = 9
		StatePlayerSheet.xp = 0
		StatePlayerSheet.xp_needed = 5
		StatePlayerSheet.level = 1
		StatePlayerSheet.God = selected_god
		StatePlayerSheet.ELEMENTS = []
		
		StatePlayerSheet.score_data = {}
	
		StatePlayerSheet.title_name = ToolGenerateName.generate_name()
		StatePlayerSheet.RACE = selected_race
		StatePlayerSheet.sprite_skin = randomize_skin(StatePlayerSheet.RACE.sprite)
		
		StatePlayerSheet.HP_max = calc_total("life")
		StatePlayerSheet.HP = calc_total("life")
		StatePlayerSheet.STR = calc_total("str")
		StatePlayerSheet.DEX = calc_total("dex")
		StatePlayerSheet.WIL = calc_total("wil")
		StatePlayerSheet.SPEED = calc_total("speed")
		StatePlayerSheet.title_race = selected_race.name
		StatePlayerSheet.title_class = selected_class.name
		
		StatePlayerSheet.bag = []
		StatePlayerSheet.abilities = {
		
	}
		if selected_race.trait != "none":
			var dict = LTraitsGeneric.trait_data
			var tname = selected_race.trait
			StatePlayerSheet.abilities[tname] = cloner.clone_dict(dict[tname])
	
		if selected_god.trait != "none":
			var dict = LTraitsGeneric.trait_data
			var tname = selected_god.trait
			StatePlayerSheet.abilities[tname] = cloner.clone_dict(dict[tname])
	
		if selected_class.trait != "none":
			var dict = LTraitsGeneric.trait_data
			var tname = selected_class.trait
			StatePlayerSheet.abilities[tname] = cloner.clone_dict(dict[tname])
	
		test_trait()
	
		StatePlayerSheet.invokes = {}
		var invoke = selected_god.invoke_1
		if invoke != "none":
			StatePlayerSheet.invokes[invoke] = cloner.clone_dict(invokes_data[invoke])
		invoke = selected_god.invoke_2
		if invoke != "none":
			StatePlayerSheet.invokes[invoke] = cloner.clone_dict(invokes_data[invoke])
		invoke = selected_god.invoke_3
		if invoke != "none":
			StatePlayerSheet.invokes[invoke] = cloner.clone_dict(invokes_data[invoke])
	
	
		StatePlayerSheet.weapon_main = equip("weapon_main", LWep.weapon_data, selected_class)
		StatePlayerSheet.weapon_off = equip("weapon_off", LWep.weapon_data, selected_class)
		StatePlayerSheet.armor_chest = equip("armor_chest", LArm.armor_data, selected_class)
		StatePlayerSheet.armor_hands = equip("armor_hand", LArm.armor_data, selected_class)
		StatePlayerSheet.armor_head = equip("armor_head", LArm.armor_data, selected_class)
		StatePlayerSheet.armor_legs = equip("armor_leg", LArm.armor_data, selected_class)
	else:
		load_player_sheet()

func load_player_sheet():
	
	
	
	StatePlayerSheet.POINTS = saved_game.POINTS
	StatePlayerSheet.POINTS_TRAITS = saved_game.POINTS_TRAITS
	StatePlayerSheet.xp = saved_game.xp
	StatePlayerSheet.xp_needed = saved_game.xp_needed
	StatePlayerSheet.level = saved_game.level
	StatePlayerSheet.God = saved_game.God
	StatePlayerSheet.ELEMENTS = saved_game.ELEMENTS
	
	StatePlayerSheet.score_data = saved_game.score_data
	
	StatePlayerSheet.title_name = saved_game.title_name
	StatePlayerSheet.RACE = saved_game.RACE
	StatePlayerSheet.sprite_skin = saved_game.sprite_skin
	StatePlayerSheet.HP_max = float(saved_game.HP_max)
	StatePlayerSheet.HP = float(saved_game.HP)
	StatePlayerSheet.STR = float(saved_game.STR)
	StatePlayerSheet.DEX = float(saved_game.DEX)
	StatePlayerSheet.WIL = float(saved_game.WIL)
	StatePlayerSheet.SPEED = float(saved_game.SPEED)
	StatePlayerSheet.title_race = saved_game.title_race
	StatePlayerSheet.title_class = saved_game.title_class
	
	StatePlayerSheet.bag = []
	for item in saved_game.bag:
		StatePlayerSheet.bag.append(cloner.clone_dict(item))
	
	StatePlayerSheet.abilities = {
		
	}
	
	for key in saved_game.abilities:
		StatePlayerSheet.abilities[key] = cloner.clone_dict(saved_game.abilities[key])
	
	StatePlayerSheet.invokes = {}
	for key in saved_game.invokes:
		StatePlayerSheet.invokes[key] = cloner.clone_dict(saved_game.invokes[key])
	
	
	StatePlayerSheet.weapon_main = equip("weapon_main", LWep.weapon_data, saved_game)
	StatePlayerSheet.weapon_off = equip("weapon_off", LWep.weapon_data, saved_game)
	StatePlayerSheet.armor_chest = equip("armor_chest", LArm.armor_data, saved_game)
	StatePlayerSheet.armor_hands = equip("armor_hands", LArm.armor_data, saved_game)
	StatePlayerSheet.armor_head = equip("armor_head", LArm.armor_data, saved_game)
	StatePlayerSheet.armor_legs = equip("armor_legs", LArm.armor_data, saved_game)

	var stringa = ""
	selected_god = {
		"description_start": stringa
	}
	
	
	selected_race = {
		"description": stringa
	}
	
	
	selected_class = {
		"description": stringa
	}


func equip(label, dict, dict2):
	var item = null
	if dict2 == selected_class:
		if dict2[label] != "none":
			if dict.has(dict2[label]):
				item = cloner.clone_dict(dict[dict2[label]])
	
	if dict2 == saved_game:
		if dict2[label] != null:
			item = cloner.clone_dict(dict2[label])
	
	return item
	
func calc_total(label):
	var floata = 0.0
	floata += selected_race[label]
	floata += selected_class[label]
	floata += selected_god[label]
	return floata

func write_glorybar():
	var stringa = "[color=#c0c0c0]"
	stringa += "[center][color=#ffff50]" + str(ToolSettings.settings_data.glory) + "[/color]  [color=#707070]/" + str(ToolSettings.settings_data.glory_needed) + "[/color]"
	stringa += "    "
	stringa += cycler.int_to_cycle_name(ToolSettings.settings_data.cycle_current)
	
	$glory_progress / glory.bbcode_text = stringa

func write_description():
	
	var stringa = "[color=#c0c0c0]"
	
	
	var invoke_1 = {}
	var invoke_2 = {}
	var invoke_3 = {}
	for key in StatePlayerSheet.invokes:
		var invoke = StatePlayerSheet.invokes[key]
		match str(invoke.hotkey):
			"1":
				invoke_1 = invoke
			"2":
				invoke_2 = invoke
			"3":
				invoke_3 = invoke
	
	
	
	if hovered_button == null:
		
		stringa += "\n\n\n[center][color=#707070]조합[/color]\n"
		stringa += "\n[color=#a0a0a0][color=#ffff50]문[/color]화[/color]"
		stringa += "\n\n[color=#a0a0a0][color=#ffff50]직[/color]업[/color]"
		stringa += "\n\n[color=#a0a0a0][color=#ffff50]신[/color]앙[/color]"
		
		if Global.universal.deck.gamepad_active == true:
			stringa += "\n\n\n\n[color=#707070][img]res://Ham_Sprite/UI/gamepad_b.png[/img] 무작위 선택[/color]"
		else:
			stringa += "\n\n\n\n[color=#707070][color=#ffff50]TAB [/color]무작위 선택[/color]"
	elif hovered_button == $P1 or hovered_button == $P2 or hovered_button == $P3:
		var invoke = invoke_1
		if hovered_button == $P2:
			invoke = invoke_2
		if hovered_button == $P3:
			invoke = invoke_3
		stringa += invoke.name
		stringa += "\n\n[color=#78bca4]기도[/color]\n\n" + str(invoke.use_max) + " 최대 충전"
		stringa += "\n\n" + invoke.description_short
		if invoke.reference != "none":
			var buff = LBuffs.buff_data[invoke.reference]
			stringa += "\n\n" + "[color=#707070]효과[/color]\n" + buff.color + buff.name + "[/color]: "
			stringa += buff.description
	
	elif hovered_button == $bodybuttons / head or hovered_button == $bodybuttons / off or hovered_button == $bodybuttons / main or hovered_button == $bodybuttons / arm or hovered_button == $bodybuttons / arm2 or hovered_button == $bodybuttons / chest or hovered_button == $bodybuttons / leg:
		
		var is_weapon = true
		var item = null
		if hovered_button == $bodybuttons / head:
			stringa += "머리 "
			item = StatePlayerSheet.armor_head
			is_weapon = false
		if hovered_button == $bodybuttons / off:
			stringa += "보조 "
			item = StatePlayerSheet.weapon_off

		if hovered_button == $bodybuttons / main:
			stringa += "주무장 "
			item = StatePlayerSheet.weapon_main

		if hovered_button == $bodybuttons / arm:
			stringa += "팔 "
			item = StatePlayerSheet.armor_hands
			is_weapon = false
		if hovered_button == $bodybuttons / arm2:
			item = StatePlayerSheet.armor_hands
			is_weapon = false
		if hovered_button == $bodybuttons / chest:
			stringa += "가슴 "
			item = StatePlayerSheet.armor_chest
			is_weapon = false
		if hovered_button == $bodybuttons / leg:
			stringa += "다리 "
			item = StatePlayerSheet.armor_legs
			is_weapon = false
		stringa = "[color=#707070]" + stringa + "비어 있음...[/color]"
		if item != null:
			if is_weapon == true:
				stringa = describe_weapon(item)
			else:
				stringa = describe_armor(item)
	elif hovered_button == $Button_Start:
		
		stringa += "[color=#ffff50]아크라의 땅[/color]에 입장..."
		
		
		if saved_game.has("EXISTS"):
			if saved_game.EXISTS == true:
				if is_loaded == false:
					stringa += "\n\n현재 [color=#ffff00]저장된 캐릭터[/color]가 [color=#ff3030]삭제[/color]됩니다"
	elif hovered_button == $Armory:
		
		stringa += "길에서 발견할 수 있는 보물을 확인..."
	
	elif hovered_button == $Nemesis:
		
		stringa += "길의 적을 확인..."
	
	elif hovered_button == $Powers:
		
		stringa += "길에서 선택할 수 있는 능력과 상위 직업을 확인..."
	
	elif hovered_button == $Continue:
		stringa += "[color=#50c050]불러오기[/color] / [color=#c05050]삭제[/color] 기존 캐릭터"
		stringa += "\n\n다음의 경우 이 캐릭터가 [color=#ff3030]삭제[/color]됩니다:\n\n     새 캐릭터로 게임을 시작할 때"
		stringa += "\n\n     진행 중인 게임을 저장하지 않고 종료할 때"
		
	elif hovered_button == $Randomize:
		stringa += "[img]res://Ham_Sprite/UI/Dice.png[/img]\n문화, 직업, 신앙을 조합하여 새 캐릭터를 만듭니다"
		
		
	
	elif hovered_button == $glory_progress / GloryButton:
		stringa += "아크라의 길을 걸으면 [color=#ffff50]영광[/color]을 얻습니다"
		stringa += "\n\n[color=#ff9020]승리![/color]를 달성하면 새로운 순환이 해금됩니다"
		stringa += "\n\n[color=#a0a0a0]첫 번째 이후의 순환은 숙련된 플레이어를 위해 더 빠른 능력과 더 강력한 적을 추가합니다"
		stringa += "\n\n각 순환은 [color=#ffff50]영광[/color] 획득을 가속합니다 [color=#707070]영광 레벨이 " + str(Global.cycle_taper) + "[/color] 을 넘으면 감소하며 [color=#ff8080]최대 체력 보너스[/color]가 추가됩니다 [color=#707070]게임 시작 / 활력 / 힘 상승 시[/color]"
		stringa += "\n\n적은 [color=#af40af]증폭[/color]을 받아 다음에 무작위 보너스를 얻습니다: [color=#ff8030]명중[/color] / [color=#ffa050]명중률[/color] / [color=#ff8080]체력[/color] / [color=#20ff20]속도[/color] / [color=#50ffff]회피[/color] / [color=#5050ff]방어[/color] / [color=#5050ff]방어력[/color] 그리고 [color=#ffff50]적용 효과[/color] 중첩"
		stringa += "\n\n현재 순환: " + cycler.int_to_cycle_name(ToolSettings.settings_data.cycle_current)
		
		print((ToolSettings.settings_data.cycle_current))
	
	elif hovered_button == $God / Button_God_Sprite:
		if is_loaded == false:
				var trait = selected_god
				stringa = "[color=#c0c0c0]"
				stringa += trait.name
				stringa += "\n\n"
				stringa += "[img]" + trait.icon + "[/img]"
				stringa += "\n"
				stringa += "[color=#a070a0]"
				stringa += trait.brief + "[/color]"
				if trait.life + trait.speed > 0:
					stringa += "\n\n"
				if trait.life > 0:
					stringa += "[color=#ff8080]체력[/color] " + "[color=#ffff50]+" + str(int(trait.life)) + "[/color]  "
				if trait.speed > 0:
					stringa += "[color=#20ff20]속도[/color] " + "[color=#ffff50]+" + str(int(trait.speed)) + "[/color]"
				if trait.dex + trait.str + trait.wil > 0:
					stringa += "\n\n"
				if trait.str > 0:
					stringa = stringa + "[color=#ff7050]힘[/color] " + "[color=#ffff50]+" + str(int(trait.str)) + "[/color]  "
				if trait.dex > 0:
					stringa = stringa + "[color=#50ff70]민첩[/color] " + "[color=#ffff50]+" + str(int(trait.dex)) + "[/color]  "
				if trait.wil > 0:
					stringa = stringa + "[color=#c050ff]의지[/color] " + "[color=#ffff50]+" + str(int(trait.wil)) + "[/color]"
				stringa += "\n\n"
				stringa += "[color=#707070]" + trait.description_start + "[/color]"
				stringa += "\n\n"
				stringa += LTraitsGeneric.trait_data[trait.trait].Description
				if LTraitsGeneric.trait_data[trait.trait].reference != "none":
						stringa += "\n\n"
						var abuff = LBuffs.buff_data[LTraitsGeneric.trait_data[trait.trait].reference]
						stringa += "[color=#707070]효과[/color]\n" + abuff.color + abuff.name + ": [/color]" + abuff.description
	
	elif hovered_button == $Sprite / Button_Body_Sprite:
		if is_loaded == false:
				var trait = selected_race
				stringa = "[color=#c0c0c0]"
				stringa += trait.name
				stringa += "\n\n"
				stringa += "[img]" + trait.icon + "[/img]"
				stringa += "\n"
				stringa += "[color=#a070a0]"
				stringa += trait.brief + "[/color]"
				if trait.life + trait.speed > 0:
					stringa += "\n\n"
				if trait.life > 0:
					stringa += "[color=#ff8080]체력[/color] " + "[color=#ffff50]+" + str(int(trait.life)) + "[/color]  "
				if trait.speed > 0:
					stringa += "[color=#20ff20]속도[/color] " + "[color=#ffff50]+" + str(int(trait.speed)) + "[/color]"
				if trait.dex + trait.str + trait.wil > 0:
					stringa += "\n\n"
				if trait.str > 0:
					stringa = stringa + "[color=#ff7050]힘[/color] " + "[color=#ffff50]+" + str(int(trait.str)) + "[/color]  "
				if trait.dex > 0:
					stringa = stringa + "[color=#50ff70]민첩[/color] " + "[color=#ffff50]+" + str(int(trait.dex)) + "[/color]  "
				if trait.wil > 0:
					stringa = stringa + "[color=#c050ff]의지[/color] " + "[color=#ffff50]+" + str(int(trait.wil)) + "[/color]"
				
				stringa += "\n\n"
				var typelist = ["slash", "blunt", "pierce", "fire", "ice", "poison", "lightning", "death", "psychic", "astral", "blood"]
				for label in typelist:
						var resist = trait["resist_" + label]
						if resist != 0:
				
							stringa += translate.damage_type_to_color(label)
							stringa += "저항 "
							stringa += "[/color]"
							stringa += translate.damage_type(label)
							stringa += translate.value_to_color(resist)
							stringa += " " + str(resist) + "%"
							stringa += "[/color]"
							stringa += "\n"
				
				
				
				stringa += "\n"
				stringa += LTraitsGeneric.trait_data[trait.trait].Description
				if LTraitsGeneric.trait_data[trait.trait].reference != "none":
						stringa += "\n\n"
						var abuff = LBuffs.buff_data[LTraitsGeneric.trait_data[trait.trait].reference]
						stringa += "[color=#707070]효과[/color]\n" + abuff.color + abuff.name + ": [/color]" + abuff.description
	else:
		stringa = write_description_hovered()
		
	
	
	$Description.bbcode_text = stringa
	$Description3.bbcode_text = write_description_summary()
	
	stringa = "[color=#c0c0c0][color=#ffff50]" + StatePlayerSheet.title_name + "[/color]의 " + StatePlayerSheet.title_race
	
	
	if is_loaded == true:
		stringa += " [color=#707070](불러옴)[/color]"
	
		
	
	
	
	$Description2.bbcode_text = stringa
	

func write_description_summary():
	var stringa = "[color=#c0c0c0]"
	
	stringa += StatePlayerSheet.title_class + " " + StatePlayerSheet.God.name
	stringa = stringa + "\n\n"
	
	
	
	stringa = stringa + "[color=#ff8080]체력[/color] " + "[color=#ffff50]" + str(int(StatePlayerSheet.HP)) + "[/color]"
	stringa = stringa + "  [color=#20ff20]속도[/color] " + "[color=#ffff50]" + str(int(StatePlayerSheet.SPEED + (StatePlayerSheet.DEX * 2))) + "[/color]"
	stringa = stringa + "\n\n[color=#ff7050]힘[/color] " + "[color=#ffff50]" + str(int(StatePlayerSheet.STR)) + "[/color]"
	stringa = stringa + "  [color=#50ff70]민첩[/color] " + "[color=#ffff50]" + str(int(StatePlayerSheet.DEX)) + "[/color]"
	stringa = stringa + "  [color=#c050ff]의지[/color] " + "[color=#ffff50]" + str(int(StatePlayerSheet.WIL)) + "[/color]"
	
	stringa += "\n\n"
	stringa += write_equipment()
	if is_loaded == true:
		stringa += write_loaded_powers()
	
	return stringa


func write_loaded_powers():
	var stringa = "\n\n"
	for key in StatePlayerSheet.abilities:
		var trait = StatePlayerSheet.abilities[key]
		if trait.generic == false:
			stringa += trait.Name + " " + str(trait.Level)
			stringa += "\n"
		pass
	return stringa

func write_description_hovered():
	var stringa = "[color=#c0c0c0]"
	stringa += hovered_button.trait.name
	if winning_titles.has(hovered_button.trait.title):
		stringa += "   [color=#707070]~승리~[/color]"
	stringa += "\n\n"
	stringa += "[img]" + hovered_button.trait.icon + "[/img]"
	stringa += "\n"
	match hovered_button.type:
		"race":
			stringa += "[color=#a070a0]"
		"class":
			stringa += "[color=#a070a0]"
		"god":
			stringa += "[color=#a070a0]"
	
	stringa += hovered_button.trait.brief + "[/color]"
	
	if hovered_button.trait.life + hovered_button.trait.speed > 0:
		stringa += "\n\n"
	if hovered_button.trait.life > 0:
		stringa += "[color=#ff8080]체력[/color] " + "[color=#ffff50]+" + str(int(hovered_button.trait.life)) + "[/color]  "
	if hovered_button.trait.speed > 0:
		stringa += "[color=#20ff20]속도[/color] " + "[color=#ffff50]+" + str(int(hovered_button.trait.speed)) + "[/color]"
	
	if hovered_button.trait.dex + hovered_button.trait.str + hovered_button.trait.wil > 0:
		stringa += "\n\n"
	if hovered_button.trait.str > 0:
		stringa = stringa + "[color=#ff7050]힘[/color] " + "[color=#ffff50]+" + str(int(hovered_button.trait.str)) + "[/color]  "
	if hovered_button.trait.dex > 0:
		stringa = stringa + "[color=#50ff70]민첩[/color] " + "[color=#ffff50]+" + str(int(hovered_button.trait.dex)) + "[/color]  "
	if hovered_button.trait.wil > 0:
		stringa = stringa + "[color=#c050ff]의지[/color] " + "[color=#ffff50]+" + str(int(hovered_button.trait.wil)) + "[/color]"
	
	if hovered_button.type == "class":
		stringa += "\n\n"
		if hovered_button.trait.weapon_main != "none":
			
			if LWep.weapon_data[hovered_button.trait.weapon_main].abilities != ["none", "none"]:
					stringa += "[color=#a020c0]*[/color]"
			stringa += LWep.weapon_data[hovered_button.trait.weapon_main].name + "\n"
		if hovered_button.trait.weapon_off != "none":
			if LWep.weapon_data[hovered_button.trait.weapon_off].abilities != ["none", "none"]:
					stringa += "[color=#a020c0]*[/color]"
			
			stringa += LWep.weapon_data[hovered_button.trait.weapon_off].name + "\n"
		if hovered_button.trait.armor_head != "none":
			if LArm.armor_data[hovered_button.trait.armor_head].abilities != ["none", "none"]:
					stringa += "[color=#a020c0]*[/color]"
			
			stringa += LArm.armor_data[hovered_button.trait.armor_head].name + "\n"
		if hovered_button.trait.armor_chest != "none":
			if LArm.armor_data[hovered_button.trait.armor_chest].abilities != ["none", "none"]:
					stringa += "[color=#a020c0]*[/color]"
			
			stringa += LArm.armor_data[hovered_button.trait.armor_chest].name + "\n"
		if hovered_button.trait.armor_hand != "none":
			if LArm.armor_data[hovered_button.trait.armor_hand].abilities != ["none", "none"]:
					stringa += "[color=#a020c0]*[/color]"
			
			stringa += LArm.armor_data[hovered_button.trait.armor_hand].name + "\n"
		if hovered_button.trait.armor_leg != "none":
			if LArm.armor_data[hovered_button.trait.armor_leg].abilities != ["none", "none"]:
					stringa += "[color=#a020c0]*[/color]"
			
			stringa += LArm.armor_data[hovered_button.trait.armor_leg].name + "\n"
	
	stringa += "\n"
	if hovered_button.type != "class":
		stringa += "\n"
	
	if hovered_button.type == "god":
		stringa += "[color=#707070]" + hovered_button.trait.description_start + "[/color]"
		stringa += "\n\n"
	
	if hovered_button.type == "race":
		var typelist = ["slash", "blunt", "pierce", "fire", "ice", "poison", "lightning", "death", "psychic", "astral", "blood"]
		for label in typelist:
			var resist = hovered_button.trait["resist_" + label]
			if resist != 0:
				
				stringa += translate.damage_type_to_color(label)
				stringa += "저항 "
				stringa += "[/color]"
				stringa += translate.damage_type(label)
				stringa += translate.value_to_color(resist)
				stringa += " " + str(resist) + "%"
				stringa += "[/color]"
				stringa += "\n"
		stringa += "\n"
		
	stringa += LTraitsGeneric.trait_data[hovered_button.trait.trait].Description
	if LTraitsGeneric.trait_data[hovered_button.trait.trait].reference != "none":
					stringa += "\n\n"
					var abuff = LBuffs.buff_data[LTraitsGeneric.trait_data[hovered_button.trait.trait].reference]
					stringa += "[color=#707070]효과[/color]\n" + abuff.color + abuff.name + ": [/color]" + abuff.description
	
	return stringa
	

func draw_body():
	$God.texture = load(StatePlayerSheet.God.sprite)
	$Sprite.texture = load(StatePlayerSheet.sprite_skin)
	
	$bodybuttons / headsprite.modulate = Color(0.2, 0.2, 0.2, 1)
	$bodybuttons / offsprite.modulate = Color(0.2, 0.2, 0.2, 1)
	$bodybuttons / mainsprite.modulate = Color(0.2, 0.2, 0.2, 1)
	$bodybuttons / armsprite.modulate = Color(0.2, 0.2, 0.2, 1)
	$bodybuttons / chestsprite.modulate = Color(0.2, 0.2, 0.2, 1)
	$bodybuttons / legsprite.modulate = Color(0.2, 0.2, 0.2, 1)
	
	if StatePlayerSheet.weapon_main != null:
		$Sprite / weapon_main.texture = load(StatePlayerSheet.weapon_main.sprite)
		$bodybuttons / mainsprite.modulate = Color(1, 1, 1, 1)
		if StatePlayerSheet.weapon_main.abilities[0] != "none":
			$bodybuttons / mainsprite.modulate = Color(1, 0, 1, 1)
	else:
		$Sprite / weapon_main.texture = null
		
	if StatePlayerSheet.weapon_off != null:
		$Sprite / weapon_off.texture = load(StatePlayerSheet.weapon_off.sprite)
		$bodybuttons / offsprite.modulate = Color(1, 1, 1, 1)
		if StatePlayerSheet.weapon_off.abilities[0] != "none":
			$bodybuttons / offsprite.modulate = Color(1, 0, 1, 1)
	else:
		$Sprite / weapon_off.texture = null
	
	if StatePlayerSheet.armor_chest != null:
		$Sprite / armor_chest.texture = load(StatePlayerSheet.armor_chest.sprite)
		$bodybuttons / chestsprite.modulate = Color(1, 1, 1, 1)
		if StatePlayerSheet.armor_chest.abilities[0] != "none":
			$bodybuttons / chestsprite.modulate = Color(1, 0, 1, 1)
	else:
		$Sprite / armor_chest.texture = null
		
	if StatePlayerSheet.armor_legs != null:
		$Sprite / armor_leg.texture = load(StatePlayerSheet.armor_legs.sprite)
		$bodybuttons / legsprite.modulate = Color(1, 1, 1, 1)
		if StatePlayerSheet.armor_legs.abilities[0] != "none":
			$bodybuttons / legsprite.modulate = Color(1, 0, 1, 1)
	else:
		$Sprite / armor_leg.texture = null
		
	if StatePlayerSheet.armor_hands != null:
		$Sprite / armor_hand.texture = load(StatePlayerSheet.armor_hands.sprite)
		$bodybuttons / armsprite.modulate = Color(1, 1, 1, 1)
		if StatePlayerSheet.armor_hands.abilities[0] != "none":
			$bodybuttons / armsprite.modulate = Color(1, 0, 1, 1)
	else:
		$Sprite / armor_hand.texture = null
		
	if StatePlayerSheet.armor_head != null:
		$Sprite / armor_head.texture = load(StatePlayerSheet.armor_head.sprite)
		$bodybuttons / headsprite.modulate = Color(1, 1, 1, 1)
		if StatePlayerSheet.armor_head.abilities[0] != "none":
			$bodybuttons / headsprite.modulate = Color(1, 0, 1, 1)
	else:
		$Sprite / armor_head.texture = null


func write_equipment():
	var stringa = ""
	if StatePlayerSheet.weapon_main != null:
		
		
		if StatePlayerSheet.weapon_main.abilities != ["none", "none"] and is_loaded == false:
			stringa += "[color=#a020c0]*[/color]"
		stringa += StatePlayerSheet.weapon_main.name
		stringa += "\n"
		
	if StatePlayerSheet.weapon_off != null:
		
		if StatePlayerSheet.weapon_off.abilities != ["none", "none"] and is_loaded == false:
			stringa += "[color=#a020c0]*[/color]"
		stringa += StatePlayerSheet.weapon_off.name
		stringa += "\n"
	if StatePlayerSheet.armor_head != null:
		
		if StatePlayerSheet.armor_head.abilities != ["none", "none"] and is_loaded == false:
			stringa += "[color=#a020c0]*[/color]"
		stringa += StatePlayerSheet.armor_head.name
		stringa += "\n"
	if StatePlayerSheet.armor_chest != null:
		
		if StatePlayerSheet.armor_chest.abilities != ["none", "none"] and is_loaded == false:
			stringa += "[color=#a020c0]*[/color]"
		stringa += StatePlayerSheet.armor_chest.name
		stringa += "\n"
	if StatePlayerSheet.armor_hands != null:
		
		if StatePlayerSheet.armor_hands.abilities != ["none", "none"] and is_loaded == false:
			stringa += "[color=#a020c0]*[/color]"
		stringa += StatePlayerSheet.armor_hands.name
		stringa += "\n"
	if StatePlayerSheet.armor_legs != null:
		
		if StatePlayerSheet.armor_legs.abilities != ["none", "none"] and is_loaded == false:
			stringa += "[color=#a020c0]*[/color]"
		stringa += StatePlayerSheet.armor_legs.name

		

	
	return stringa

func create_stalks():
	print("stalks created")
	var pos = $Races.global_position
	var list = race_data
	var type = "race"
	grow_stalk(pos, list, type)
	
	
	pos = $Classes.global_position
	list = class_data
	type = "class"
	grow_stalk(pos, list, type)
	

	pos = $Gods.global_position
	list = god_data
	type = "god"
	grow_stalk(pos, list, type)
	
	
		
	
	

func grow_stalk(pos, list, type):
	print("stalk grown from list of size" + str(list.size()))
	var deck_index_x = 0
	var used_traits = []
	for trait in list:
		if used_traits.has(trait) == false:
			used_traits.append(trait)
			create_button(pos, list[trait], buttons_all, type, deck_index_x)
			if pos.x < x_limit:
				deck_index_x += 1
				pos.x += 32
			else:
				pos.x = $Races.global_position.x
				deck_index_x = 0

				pos.y += 32
	

func create_button(pos, trait, special_array, type, deck_index_x):
	var b = Global.ButtonStartNode.instance()
	$Buttons.add_child(b)
	b.global_position = pos
	b.trait = trait
	b.type = type
	b.context = get_node(".")
	b.deck_index_x = deck_index_x
	
	special_array.append(b)
	if winning_titles.has(trait.trait):
				b.victorious = true
				
				
	b.create()
	
	

func randomize_skin(label):
	
	label = label.substr(0, label.length() - 4)
	label += str(skin_variant)
	label += ".png"
	skin_variant += 1
	if skin_variant > skin_variant_max: skin_variant = 1
	
	return label

func unlock_random_key():
	
	var rng = RandomNumberGenerator.new()
	
	rng.randomize()
	var list = ToolSettings.settings_data.locked_keys
	var key = list[rng.randi_range(0, list.size() - 1)]
	list.erase(key)
	print("Unlock " + key)
	ToolSettings.settings_data.locked_keys = list
	ToolSettings.settings_data.unlocked_keys.append(key)
	ToolSettings.save_settings()
	custom_update()
	var action = {
		"name": "unlock", 
		"data": merged_data[key]
	}
	ProcessQueueNongame.queue.append(action)
	
	


func save_loadout():
	if is_loaded == false:
		var race_string = selected_race.title
		var class_string = selected_class.title
		var god_string = selected_god.title
		ToolSettings.save_loadout(race_string, class_string, god_string)

func slide_player_sprite():
	var tween = Tween.new()
	$Sprite.add_child(tween)
	tween.interpolate_property($Sprite, "position", 
			$Sprite.position, $StartSprite.position, 0.3, 
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _on_Button_Start_pressed():
	Global.sound.new_sound("Wave")
	
	start()
	

func start():
	if menu_shown == false:
		
		
			
		
		save_loadout()
		
		StateWorld.cycle = ToolSettings.settings_data.cycle_current
		
		scene_disabled = true
		if is_loaded == false:
			StateWorld.restart()
			
		else:
			pass
			
	
		Global.sound.new_sound("Wave")
		
		if is_loaded == true:
			Global.universal.transition("game")
		else:
			
			
			Global.universal.transition("verse")

func _input(event):
	if scene_disabled == false and is_typing == false:
		if ProcessQueueNongame.queue.size() == 0 and ProcessQueueNongame.paused == false:
			
			if event.is_action_pressed("mouse_right"):
				if is_loaded == false:
					if right_click_buffer >= right_click_buffer_max and glory_hovered == true:
						right_click_buffer = 0
						toggle_cycle_down()
			
			if event.is_action_pressed("enter"):
				start()
			if event.is_action_pressed("gamepad_y"):
				if ToolSettings.settings_data.gamepad_mode == "full":
					quit()
			if event.is_action_pressed("tab"):
				if Input.is_action_pressed("alt") == false and Input.is_action_pressed("shift") == false:
					press_randomize()
					
			if event.is_action_pressed("gamepad_b"):
				if ToolSettings.settings_data.gamepad_mode == "full":
					press_randomize()
			
			if event.is_action_pressed("c"):
				cycle_selection("culture")
			if event.is_action_pressed("l"):
				cycle_selection("class")
			if event.is_action_pressed("r"):
				cycle_selection("religion")
			if event.is_action_pressed("escape"):
				show_menu()
			if event.is_action_pressed("clear_unlocks"):
				if Global.test == true:
					clear_unlocks()
			if event.is_action_pressed("s"):
				if saved_game.has("EXISTS"):
					if saved_game.EXISTS == true:
						if saved_game.has("version_number"):
							if saved_game.version_number == Global.version_number:
								if $Continue.mouse_filter == Control.MOUSE_FILTER_STOP:
									press_continue()
			Global.universal.deck.input_handler(event)
			
func test_trait():
	
	pass


func draw_continent():
	for sprite in drawn_continent_sprites:
		sprite.queue_free()
	drawn_continent_sprites = []
	var tile_list = Global.continent.tile_list
	for tile in tile_list:
		var s = Sprite.new()
		$Continent_Preview.add_child(s)
		s.position.x = tile.x * 7
		s.position.y = tile.y * 7
		s.z_index = (1 + tile.x) * tile.y
		s.texture = load(tile.data.sprite)
		drawn_continent_sprites.append(s)


func _on_Button_Start_mouse_entered():
	Global.sound.new_sound("Hover")
	
	

func _on_Button_Start_mouse_exited():
	hovered_button = null
	write_description()
		


func _on_Continue_mouse_entered():
	Global.sound.new_sound("Hover")
	hovered_button = $Continue
	write_description()


func _on_Continue_mouse_exited():
	hovered_button = null
	write_description()


func _on_Continue_pressed():
	press_continue()
			

func press_continue():
	
	if is_loaded == true:
		is_loaded = false
		reset_selected()
		
		
	elif saved_game.has("EXISTS"):
		if saved_game.EXISTS == true:
			effectmaker.create_effect_animated_ui_context(get_node("."), $Sprite.get_global_position() + Vector2( - 16, - 16), "Dumuzi")
			is_loaded = true
			StateWorld.continent.delete()
			gencont.load_continent(saved_game)
			update_selected()

func show_menu():
	
	if menu_shown == false:
		Global.sound.new_sound("Hover")
		var d = Global.UIMenu.instance()
		$CanvasLayer.add_child(d)
		d.write_menu("start")
		ProcessQueue.PAUSED = true

func _on_Menu_pressed():
	show_menu()








func _on_Randomize_mouse_entered():
	Global.sound.new_sound("Hover")
	hovered_button = $Randomize
	write_description()

func press_randomize():
	Global.sound.new_sound("Hover")
	
	if is_loaded == true:
		is_loaded = false
		StateWorld.continent.delete()
		StateWorld.type = "none"
		gencont.generate("achra")
	
	randomize_character()
	update_selected()

func cycle_selection(label):
	
	if is_loaded == true:
		is_loaded = false
		StateWorld.continent.delete()
		StateWorld.type = "none"
		gencont.generate("achra")
	
		
		
		
		selected_race = race_data[ToolSettings.settings_data.race]
		selected_god = god_data[ToolSettings.settings_data.god]
		selected_class = class_data[ToolSettings.settings_data. class ]
		update_selected()
	else:
		cycle_selection_2(label)
	Global.sound.new_sound("Hover")
	
func cycle_selection_2(label):
	match label:
		"culture":
			var choices = get_unlocked_from_data(race_data)
			var index = 0
			if choices.has(selected_race) == true:
				
				for n in choices.size():
					if choices[n] == selected_race:
						index = n
				index += 1
				if index >= choices.size():
					index = 0
				elif index < 0:
					index = choices.size() - 1
			
				selected_race = choices[index]
				
		"class":
			var choices = get_unlocked_from_data(class_data)
			var index = 0
			if choices.has(selected_class) == true:
				
				for n in choices.size():
					if choices[n] == selected_class:
						index = n
				index += 1
				if index >= choices.size():
					index = 0
				elif index < 0:
					index = choices.size() - 1
			
				selected_class = choices[index]
				
		"religion":
			var choices = get_unlocked_from_data(god_data)
			var index = 0
			if choices.has(selected_god) == true:
				
				for n in choices.size():
					if choices[n] == selected_god:
						index = n
				index += 1
				if index >= choices.size():
					index = 0
				elif index < 0:
					index = choices.size() - 1
			
				selected_god = choices[index]
	
	
	update_selected()


func _on_Randomize_pressed():
	press_randomize()
	


func _on_Randomize_mouse_exited():
	hovered_button = null
	write_description()


func _on_Menu_mouse_entered():
	Global.sound.new_sound("Hover")


func _on_Menu_mouse_exited():
	pass


func _on_ClearUnlocks_pressed():
	clear_unlocks()

func clear_unlocks():
	selected_race = race_data["Stran"]
	selected_god = god_data["Ashem"]
	selected_class = class_data["Amir"]
	
	ToolSettings.clear_unlocks()
	add_new_keys_to_locked()
	ToolSettings.save_settings()
	custom_update()
	
	print(ToolSettings.settings_data)

func _on_Quit_mouse_entered():
	Global.sound.new_sound("Hover")

func quit():
	if scene_disabled == false and menu_shown == false:
		scene_disabled = true
		Global.universal.transition("first")

func _on_Quit_pressed():
	quit()


func _on_GloryButton_mouse_entered():
	glory_hovered = true
	Global.sound.new_sound("Hover")
	hovered_button = $glory_progress / GloryButton
	write_description()


func _on_GloryButton_pressed():
	if is_loaded == false:
		toggle_cycle()

func toggle_cycle():
	Global.sound.new_sound("Hover")
	cycler.toggle_current_cycle()
	ToolSettings.save_settings()
	
	write_description()

func toggle_cycle_down():
	Global.sound.new_sound("Hover")
	cycler.toggle_current_cycle_down()
	ToolSettings.save_settings()
	
	write_description()

func _on_GloryButton_mouse_exited():
	glory_hovered = false
	hovered_button = null
	write_description()


func _on_P1_mouse_entered():
	hovered_button = $P1
	Global.sound.new_sound("Hover")
	write_description()


func _on_P1_mouse_exited():
	hovered_button = null
	write_description()


func _on_P2_mouse_entered():
	hovered_button = $P2
	Global.sound.new_sound("Hover")
	write_description()


func _on_P2_mouse_exited():
	hovered_button = null
	write_description()


func _on_P3_mouse_entered():
	hovered_button = $P3
	Global.sound.new_sound("Hover")
	write_description()


func _on_P3_mouse_exited():
	hovered_button = null
	write_description()


func _on_head_mouse_entered():
	hovered_button = $bodybuttons / head
	Global.sound.new_sound("Hover")
	write_description()


func _on_head_mouse_exited():
	hovered_button = null
	write_description()







func _on_off_mouse_entered():
	hovered_button = $bodybuttons / off
	Global.sound.new_sound("Hover")
	write_description()


func _on_off_mouse_exited():
	hovered_button = null
	write_description()







func _on_main_mouse_entered():
	hovered_button = $bodybuttons / main
	Global.sound.new_sound("Hover")
	write_description()


func _on_main_mouse_exited():
	hovered_button = null
	write_description()





func _on_arm_mouse_entered():
	hovered_button = $bodybuttons / arm
	Global.sound.new_sound("Hover")
	write_description()


func _on_arm_mouse_exited():
	hovered_button = null
	write_description()





func _on_arm2_mouse_entered():
	hovered_button = $bodybuttons / arm2
	Global.sound.new_sound("Hover")
	write_description()


func _on_arm2_mouse_exited():
	hovered_button = null
	write_description()





func _on_chest_mouse_entered():
	hovered_button = $bodybuttons / chest
	Global.sound.new_sound("Hover")
	write_description()


func _on_chest_mouse_exited():
	hovered_button = null
	write_description()





func _on_leg_mouse_entered():
	hovered_button = $bodybuttons / leg
	Global.sound.new_sound("Hover")
	write_description()


func _on_leg_mouse_exited():
	hovered_button = null
	write_description()
	


func describe_weapon(weapon):
	var stringa = ""


	
	if weapon != null:
		
		stringa += "\n[color=#ffa050]" + str(weapon.acc * 10) + " [color=#a0a0a0]명중률[/color][/color]"
		stringa += "\n[color=#ff8030]" + str(weapon.dmg * 10) + " [color=#a0a0a0]명중[/color][/color]"
		stringa += " " + translate.damage_type(weapon["dmgtype"])
		stringa = stringa + "\n[color=#5050ff]" + str(weapon.arm) + " [color=#a0a0a0]방어[/color][/color]"
	
	
	
		stringa += "\n"
		var range_string = ""
		range_string = str(int(weapon.range))
		stringa = stringa + "\n[color=#ffff50]" + range_string + "[/color] [color=#a0a0a0]사거리[/color] "
	
	
	
		stringa = stringa + "\n"
	
	
		
		stringa = stringa + "\n[color=#ff0000]" + str(weapon.weight) + " [/color][color=#a0a0a0]하중[/color]"
		stringa = stringa + "\n[color=#ff0000]" + str(weapon.size) + " [/color][color=#a0a0a0]무기 크기[/color]"
	

		stringa += "\n"
		var typelist = ["slash", "blunt", "pierce", "fire", "ice", "poison", "lightning", "death", "psychic", "astral", "blood"]
		for label in typelist:
			var resist = weapon["resist_" + label]
			if resist != 0:
				stringa += "\n"
				stringa += translate.damage_type_to_color(label)
				stringa += "저항 "
				stringa += "[/color]"
				stringa += translate.damage_type(label)
				stringa += translate.value_to_color(resist)
				stringa += " " + str(resist) + "%"
				stringa += "[/color]"
	
		stringa += "\n"
		if weapon.has("shield"):
			if weapon.shield == true:
				stringa += translate.get_shield_or_aoe_text(weapon)
		stringa += "\n"
		
		if weapon.aoe > 1:
		
			stringa += "\n[img]res://Ham_Sprite/TraitIcons/aoe.png[/img]\n[color=#ff9090]범위 공격[/color]"
			stringa += " [color=#a0a0a0]양손 장착 시[/color]"
			stringa += "\n[color=#707070]보조손 비어야 함"
	
		stringa = stringa + "\n"
		
		for trait in weapon.abilities:
			if trait != "none":
				var traitreal = LTraitsGeneric.trait_data[trait]
				
				stringa = stringa + "\n[img]" + traitreal.sprite + "[/img]"
			
				stringa = stringa + "\n[color=#c0c0c0]" + traitreal.Description
				
				if traitreal.reference != "none":
					stringa += "\n\n"
					var abuff = LBuffs.buff_data[traitreal.reference]
					stringa += "[color=#707070]효과[/color]\n" + abuff.color + abuff.name + ": [/color]" + abuff.description
				
				
				stringa = stringa + "\n"
		
		
		
		stringa = weapon["name"] + "\n" + stringa

	
	return stringa

func describe_armor(armor):
	var stringa = ""
	
	
	
	if armor != null:
		
		stringa = armor.name + stringa
		
		stringa = stringa + "\n\n[color=#5050ff]" + "+" + str(armor.arm) + " [color=#a0a0a0]방어력[/color][/color]\n"
		stringa = stringa + "\n[color=#ff0000]" + "+" + str(armor.weight) + " [color=#a0a0a0]하중[/color][/color]"
		
		
		
		if armor.inflex > 0:
			stringa = stringa + "\n[color=#ff0000]" + "+" + str(armor.inflex) + " [color=#a0a0a0]경직[/color][/color]"
			
		else:
			stringa = stringa + "\n[color=#50ff50]" + str(armor.inflex) + "[/color] [color=#a0a0a0]경직[/color]"
		
		stringa = stringa + "\n"
		
		var typelist = ["slash", "blunt", "pierce", "fire", "ice", "poison", "lightning", "death", "psychic", "astral", "blood"]
		for label in typelist:
			var resist = armor["resist_" + label]
			if resist != 0:
				stringa += "\n"
				stringa += translate.damage_type_to_color(label)
				stringa += "저항 "
				stringa += "[/color]"
				stringa += translate.damage_type(label)
				stringa += translate.value_to_color(resist)
				stringa += " " + str(resist) + "%"
				stringa += "[/color]"
				
		
		
		stringa += "\n[color=#c0c0c0]"
		for trait in armor.abilities:
			if trait != "none":
				var traitreal = LTraitsGeneric.trait_data[trait]
				
				stringa = stringa + "\n[img]" + traitreal.sprite + "[/img]"
				
				stringa = stringa + "\n" + traitreal.Description
				
				if traitreal.reference != "none":
					stringa += "\n\n"
					var abuff = LBuffs.buff_data[traitreal.reference]
					stringa += "[color=#707070]효과[/color]\n" + abuff.color + abuff.name + ": [/color]" + abuff.description
				
			
				
				stringa = stringa + "\n"
	else:
		pass
	
	return stringa


func _on_Powers_pressed():
	save_loadout()
	if scene_disabled == false and menu_shown == false:
		scene_disabled = true
		
		Global.universal.transition("ability_book")


func _on_Powers_mouse_entered():
	Global.sound.new_sound("Hover")
	hovered_button = $Powers
	write_description()


func _on_Button_Body_Sprite_mouse_entered():
	if is_loaded == false:
		Global.sound.new_sound("Hover")
		hovered_button = $Sprite / Button_Body_Sprite
		write_description()
	





func _on_Button_Body_Sprite_mouse_exited():
	
	hovered_button = null
	write_description()


func _on_Button_God_Sprite_mouse_entered():
	if is_loaded == false:
		Global.sound.new_sound("Hover")
		hovered_button = $God / Button_God_Sprite
		write_description()


func _on_Button_God_Sprite_mouse_exited():
	
	hovered_button = null
	write_description()


func _on_Armory_mouse_entered():
	Global.sound.new_sound("Hover")
	hovered_button = $Armory
	write_description()


func _on_Armory_pressed():
	save_loadout()
	if scene_disabled == false and menu_shown == false:
		scene_disabled = true
		
		Global.universal.transition("armory")


func _on_Powers_mouse_exited():
	hovered_button = null
	write_description()


func _on_Armory_mouse_exited():
	hovered_button = null
	write_description()


func _on_Nemesis_mouse_exited():
	hovered_button = null
	write_description()


func _on_Nemesis_mouse_entered():
	Global.sound.new_sound("Hover")
	hovered_button = $Nemesis
	write_description()


func _on_Nemesis_pressed():
	save_loadout()
	if scene_disabled == false and menu_shown == false:
		scene_disabled = true
		
		Global.universal.transition("bestiary")


func setup_deckbuttons():
	if Global.universal.deck.allowed == true:
		Global.universal.deck.deckbuttons = [[$Menu], 
		[$glory_progress / GloryButton], 
		[$glory_progress / GloryButton], 
		[$glory_progress / GloryButton], 
		[$glory_progress / GloryButton], 
		[$glory_progress / GloryButton], 
		[$Button_Start, $Continue, $Powers, $Armory, $Nemesis, $Quit, $bodybuttons / head], 
		[$Button_Start, $Continue, $Powers, $Armory, $Nemesis, $Quit, $bodybuttons / main], 
		[$Button_Start, $Continue, $Powers, $Armory, $Nemesis, $Quit, $bodybuttons / off], 
		[$Button_Start, $Continue, $Powers, $Armory, $Nemesis, $Quit, $bodybuttons / arm], 
		[$Button_Start, $Continue, $Powers, $Armory, $Nemesis, $Quit, $bodybuttons / chest], 
		[$Button_Start, $Continue, $Powers, $Armory, $Nemesis, $Quit, $bodybuttons / leg], 
		[$Button_Start, $Continue, $Powers, $Armory, $Nemesis, $Quit, $P1], 
		[$Button_Start, $Continue, $Powers, $Armory, $Nemesis, $Quit, $P2], 
		[$Button_Start, $Continue, $Powers, $Armory, $Nemesis, $Quit, $P3]]
		Global.universal.deck.deckbutton_selected = null
		
	
	
	
		var races = []
		var classes = []
		var gods = []
	
		for button in buttons_all:
		
			match button.type:
				"race":
					races.append(button)
				"class":
					classes.append(button)
				"god":
					gods.append(button)
			
		print(buttons_all.size())
	
	
		var arrays = [races, classes, gods]
		for array in arrays:
			var total = 24
			var current_index = 0
			for button in array:
				total -= 1
				Global.universal.deck.deckbuttons[button.deck_index_x].append(button)
				current_index = button.deck_index_x
			for n in total:
				current_index += 1
				Global.universal.deck.deckbuttons[current_index].append(null)
	
	
		Global.universal.deck.index_x = 6
		Global.universal.deck.index_y = 0
		Global.universal.deck.set_first_button()
	
	


func _on_TextEdit_text_changed(_new_text):
	var caret_location = $TextEdit.caret_position
	$TextEdit.text = $TextEdit.text.to_lower()
	$TextEdit.caret_position = caret_location
	update_highlight()
	
	
func _on_TextEdit_focus_entered():
	$TextEdit.text = ""
	is_typing = true
	update_highlight()


func _on_TextEdit_focus_exited():
	is_typing = false

func update_highlight():
	if $TextEdit.text != "" and $TextEdit.text != "검색...":
		
		for button in buttons_all:
			if button.trait != null and button.locked == false:
				var atrait = LTraitsGeneric.trait_data[button.trait.trait]
				var abuff = {
				"description": ""
			}
				if atrait.reference != "none":
					abuff = LBuffs.buff_data[atrait.reference]
				button.modulate = Color(1, 1, 1, 1)
				if $TextEdit.text in textstrip.strip_bbcode(atrait.Description).to_lower():
					pass
				elif $TextEdit.text in textstrip.strip_bbcode(abuff.description).to_lower() and abuff.description != "":
					pass
				elif $TextEdit.text in textstrip.strip_bbcode(atrait.Name).to_lower():
					pass
				else:
					button.modulate = Color(0.3, 0.1, 0.1, 1)
				
				
				if button.trait.has("weapon_main"):
					var positions = ["weapon_main", "weapon_off"]
					for key in positions:
						if button.trait[key] != "none":
							var item = LWep.weapon_data[button.trait[key]]
							if $TextEdit.text in textstrip.strip_bbcode(item.name).to_lower():
										button.modulate = Color(1, 1, 1, 1)
							for ability in item.abilities:
								if ability != "none":
									var bbuff = {
									"description": ""
										}
									var btrait = LTraitsGeneric.trait_data[ability]
									if btrait.reference != "none":
										bbuff = LBuffs.buff_data[btrait.reference]
										
									if $TextEdit.text in textstrip.strip_bbcode(btrait.Description).to_lower():
										button.modulate = Color(1, 1, 1, 1)
									elif $TextEdit.text in textstrip.strip_bbcode(bbuff.description).to_lower() and abuff.description != "":
										button.modulate = Color(1, 1, 1, 1)
									elif $TextEdit.text in textstrip.strip_bbcode(btrait.Name).to_lower():
										button.modulate = Color(1, 1, 1, 1)
									
									
									
					
					positions = ["armor_head", "armor_hand", "armor_chest", "armor_leg"]
					for key in positions:
						if button.trait[key] != "none":
							var item = LArm.armor_data[button.trait[key]]
							if $TextEdit.text in textstrip.strip_bbcode(item.name).to_lower():
										button.modulate = Color(1, 1, 1, 1)
							for ability in item.abilities:
								if ability != "none":
									var bbuff = {
									"description": ""
										}
									var btrait = LTraitsGeneric.trait_data[ability]
									if btrait.reference != "none":
										bbuff = LBuffs.buff_data[btrait.reference]
										
									if $TextEdit.text in textstrip.strip_bbcode(btrait.Description).to_lower():
										button.modulate = Color(1, 1, 1, 1)
									elif $TextEdit.text in textstrip.strip_bbcode(bbuff.description).to_lower() and abuff.description != "":
										button.modulate = Color(1, 1, 1, 1)
									elif $TextEdit.text in textstrip.strip_bbcode(btrait.Name).to_lower():
										button.modulate = Color(1, 1, 1, 1)
									
			
				if button.trait.has("invoke_1"):
					
					var invoke_keys = ["invoke_1", "invoke_2", "invoke_3"]
					for key in invoke_keys:
						var btrait = invokes_data[button.trait[key]]
						var bbuff = {
									"description": ""
										}
						if btrait.reference != "none":
							bbuff = LBuffs.buff_data[btrait.reference]
						
						if $TextEdit.text in textstrip.strip_bbcode(btrait.description_short).to_lower():
										button.modulate = Color(1, 1, 1, 1)
						elif $TextEdit.text in textstrip.strip_bbcode(bbuff.description).to_lower() and abuff.description != "":
										button.modulate = Color(1, 1, 1, 1)
						elif $TextEdit.text in textstrip.strip_bbcode(btrait.name).to_lower():
										button.modulate = Color(1, 1, 1, 1)
	else:
		for button in buttons_all:
			if button.locked == false:
				button.modulate = Color(1, 1, 1, 1)






func get_winning_titles():
	var titles = []
	
	var graveyard_var = graveyard.loadData()
	if graveyard_var.EXISTS != false:
			
				for key in graveyard_var:
					if key != "EXISTS":
						var data = cloner.clone_dict(graveyard_var[key])
						if data.score_data.condition == "victory":
							for title in data.abilities:
								var trait = data.abilities[title]
								if trait.generic == true:
									if trait.organize == "racial" or trait.organize == "god" or trait.organize == "class":
									
								
									
										var label = trait.title
										ToolFeatGiver.add_victory_tag(label)
										
										
										
	for label in ToolSettings.settings_data.winning_tags:
		titles.append(label)
										
	
	return titles
