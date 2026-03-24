extends Node

var ratman_archer = {
	"object_type": "enemy"
	, "family": "Humanoid"
	, "name": "Rat-man Archer"
	, "description": "[color=#c0c040]쥐인간 궁수[/color][color=#c0c0c0]\n\n떼지어 사는 인간형 설치류로, 세상의 찌꺼기를 먹고 산다. 조잡한 활과 화살을 든다.[/color]"
	, "quant": Vector2(2, 5)
	, "size": 1
	, "lvl": 1
	, "hp": 30.0
	, "str": 2.0
	, "dex": 4.0
	, "wil": 1.0
	, "speed": 8.0
	, "arm": 0.0
	
	, "dodge": [3.0, 10.0]
	, "deflect": [1.0, 5.0, 5.0]
	, "accuracy": [4.0, 20.0]
	, "damage": [5.0, 5.0]
	, "dmgtype": "pierce"
	, "range_attack": 3
	, "abilities": {
		
			
		
	}
	, "proj_art": "res://Ham_Sprite/Props/Object_Arrow.png"
	, "sprite": "res://Ham_Sprite/Enemies/Enemy_RatManArcher.png"
	
}

var ratman_guard = {
	"object_type": "enemy"
	, "family": "Humanoid"
	, "name": "Rat-man Guard"
	, "description": "[color=#c0c040]쥐인간[/color][color=#c0c0c0]\n\n떼지어 사는 인간형 설치류로, 세상의 찌꺼기를 먹고 산다. 굽은 칼을 든다.[/color]"
	, "quant": Vector2(4, 6)
	, "size": 1
	, "lvl": 1
	, "hp": 30.0
	, "str": 2.0
	, "dex": 5.0
	, "wil": 1.0
	, "speed": 8.0
	, "arm": 0.0
	
	, "dodge": [4.0, 20.0]
	, "deflect": [1.0, 5.0, 10.0]
	, "accuracy": [5.0, 20.0]
	, "damage": [5.0, 5.0]
	, "dmgtype": "slash"
	, "range_attack": 1
	, "abilities": {
		
	}
	, "proj_art": ""
	, "sprite": "res://Ham_Sprite/Enemies/Enemy_RatMan.png"
	
}

var bugbear = {
	"object_type": "enemy"
	, "family": "Humanoid"
	, "name": "Bugbear"
	, "description": "[color=#ffa050]버그베어[/color][color=#c0c0c0]\n\n아이를 잡아먹는 인간형 야수. 무거운 곤봉을 든다.[/color]"
	, "quant": Vector2(1, 4)
	, "size": 4
	, "lvl": 2
	, "hp": 200.0
	, "str": 8.0
	, "dex": 5.0
	, "wil": 1.0
	, "speed": 4.0
	, "arm": 10.0

	, "dodge": [1.0, 5.0]
	, "deflect": [5.0, 5.0, 50.0]
	, "accuracy": [4.0, 15.0]
	, "damage": [20.0, 8.0]
	, "dmgtype": "blunt"
	, "range_attack": 1
	, "abilities": {
		
	}
	, "proj_art": ""
	, "sprite": "res://Ham_Sprite/Enemies/Enemy_Bugbear.png"
	
}

var boga = {
	"object_type": "enemy"
	, "family": "Humanoid"
	, "name": "Boga"
	, "description": "[color=#af4040]보가[/color][color=#c0c0c0]\n\n꿈틀거리는 점토빛 심연의 뱀. 경화된 주둥이로 공격한다.[/color]"
	, "quant": Vector2(2, 3)
	, "size": 3
	, "lvl": 2
	, "hp": 200.0
	, "str": 5.0
	, "dex": 8.0
	, "wil": 1.0
	, "speed": 10.0
	, "arm": 30.0
	
	, "dodge": [8.0, 10.0]
	, "deflect": [1.0, 5.0, 10.0]
	, "accuracy": [8.0, 20.0]
	, "damage": [7.0, 5.0]
	, "dmgtype": "blunt"
	, "range_attack": 1
	, "abilities": {
		
	}
	, "proj_art": ""
	, "sprite": "res://Ham_Sprite/Enemies/Enemy_Serpent.png"
	
}

var firedrake = {
	"object_type": "enemy"
	, "family": "Beast"
	, "name": "Firedrake"
	, "description": "[color=#ff7000]파이어드레이크[/color][color=#c0c0c0]\n\n광대한 지하 용암지대의 거대한 기어다니는 야수. 불을 뿜는다.[/color]"
	, "quant": Vector2(1, 1)
	, "size": 5
	, "lvl": 10
	, "hp": 1000.0
	, "str": 5.0
	, "dex": 8.0
	, "wil": 1.0
	, "speed": 10.0
	, "arm": 60.0
	
	, "dodge": [3.0, 10.0]
	, "deflect": [8.0, 10.0, 60.0]
	, "accuracy": [10.0, 30.0]
	, "damage": [10.0, 10.0]
	, "dmgtype": "fire"
	, "range_attack": 3
	, "abilities": {
		"ResistFire": true, 
		"Incinerate": true
	}
	, "proj_art": "res://Ham_Sprite/Proj/Proj_Fireball.png"
	, "sprite": "res://Ham_Sprite/Enemies/Enemy_FireDrake.png"
	
}

var enemies = [ratman_archer, ratman_guard, bugbear, boga]
var bosses = [firedrake]

var enemies_world0 = [ratman_archer, ratman_guard]
var bosses_world0 = [firedrake]

var enemies_world1 = [bugbear, boga]

var enemy_list
var bosses_list

var total_worlds = 2

var enemy_data



func _ready():
	
	enemy_data = loader.load_data("res://Data/Table_Enemies.json")
	set_world_lists()
	





func set_world_lists():
	bosses_list = []
	for n in total_worlds:
		var array = create_enemy_list(n, true)
		if array != null:
			bosses_list.append(array)
	enemy_list = []
	for n in total_worlds:
		var array = create_enemy_list(n, false)
		if array != null:
			enemy_list.append(array)
	

func create_enemy_list(world_number, is_it_boss):
	var array = []
	for key in enemy_data:
		if enemy_data[key].world == world_number and enemy_data[key].boss == is_it_boss:
			array.append(enemy_data[key])
	if array.size() > 0:
		return array
	else:
		return null

func get_enemies_of_tier(tier, is_boss):
	var array = []
	for key in enemy_data:
		if enemy_data[key].summoned == false:
			if enemy_data[key].tier == tier and enemy_data[key].boss == is_boss:
				var dict = cloner.clone_dict(enemy_data[key])
				dict["map_hidden"] = false
				array.append(dict)
			elif enemy_data[key].tier_special == tier and enemy_data[key].boss == is_boss:
				var dict = cloner.clone_dict(enemy_data[key])
				dict["map_hidden"] = false
				array.append(dict)
	return array

func get_enemies_for_dust(tier):
	var array = []
	for key in enemy_data:
		if enemy_data[key].summoned == false:
			if enemy_data[key].tier <= tier and enemy_data[key].tier > 0:
				var dict = cloner.clone_dict(enemy_data[key])
				dict["map_hidden"] = false
				array.append(dict)
	return array
