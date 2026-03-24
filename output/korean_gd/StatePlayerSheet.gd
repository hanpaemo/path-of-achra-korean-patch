extends Node

var HP = 100.0
var HP_max = 100.0
var STR = 5.0
var DEX = 5.0
var WIL = 5.0
var SPEED = 8
var POINTS = 3
var POINTS_TRAITS = 1
var ELEMENTS = []

var TRAITS_UNLOCKED = []

var level = 1
var xp = 0
var xp_needed = 5


var title_name = "Telemachus"
var title_race = "Human"
var title_class = "Phalangite"

var abilities = {
}

var invokes = {
	
}


var score_data = {
	
}
var RACE = null
onready var sprite_skin = LRacesClasses.Human.sprite

var God = null
var bag = []
var weapon_main = null
var weapon_off = null
var armor_head = null
var armor_chest = null
var armor_hands = null
var armor_legs = null

func update():
	HP = Global.Player.HP
	HP_max = Global.Player.HP_max
	POINTS = Global.Player.POINTS
	POINTS_TRAITS = Global.Player.POINTS_TRAITS
	SPEED = Global.Player.SPEED
	STR = Global.Player.STR
	DEX = Global.Player.DEX
	WIL = Global.Player.WIL
	bag = Global.Player.bag
	weapon_main = Global.Player.weapon_main
	weapon_off = Global.Player.weapon_off
	armor_chest = Global.Player.armor_chest
	armor_hands = Global.Player.armor_hands
	armor_legs = Global.Player.armor_legs
	armor_head = Global.Player.armor_head
	xp = Global.Player.xp
	xp_needed = Global.Player.xp_needed
	level = Global.Player.level
	abilities = Global.Player.abilities
	invokes = Global.Player.invokes
	TRAITS_UNLOCKED = Global.Player.TRAITS_UNLOCKED
	ELEMENTS = Global.Player.ELEMENTS

func clear():
	Global.trait_glow = false
	Global.inv_glow = false
	HP = 100.0
	HP_max = 100.0
	STR = 5.0
	DEX = 5.0
	WIL = 5.0
	RACE = LRacesClasses.Human
	bag = []
	TRAITS_UNLOCKED = []
	ELEMENTS = []
	abilities = {
		
	}
	invokes = {
		
	}
	weapon_main = null
	weapon_off = null
	armor_chest = null
	armor_hands = null
	armor_legs = null
	armor_head = null
	
	Global.last_score_data = cloner.clone_dict(score_data)
	score_data = {
		
	}


func violate(label):

	if score_data.has("tracker") == false:

		create_tracker()

	for key in score_data.tracker:
		if key == label:
			score.tracker[key] = false

func create_tracker():

	score_data["tracker"] = {
		"no_pray": true, 
		"no_attack": true
}

func get_tint_number():
	var inta = 0
	var slots = [armor_chest, armor_hands, armor_head, armor_legs, weapon_main, weapon_off]
		
	for item in slots:
		if item != null:
			if item.has("tint"):
				if item.tint == true:
					inta += 1
	
	
	return inta
