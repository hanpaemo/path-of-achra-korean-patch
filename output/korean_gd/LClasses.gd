extends Node

var random_bag = ["longaxe", "bow", "buckler"
, "cloth_hand", "cloth_leg", "cloth_head"
, "leather_leg", "leather_head"]

var rng = RandomNumberGenerator.new()

var Survivor = {
	"name": "[color=#df4f4f]생존자[/color]"
	, "hp": 25.0
	, "speed": 0.0
	, "str": 1.0
	, "dex": 1.0
	, "wil": 1.0
	, "trait": null
	, "weapon": "devilaxe"
	, "description": "[color=#c0c0c0]균형 잡힌 능력치와 토마호크, 장비 보따리를 들고 오벨리스크에 도착한다[/color]"
	, "bag": 5
}

var Mobad = {
	"name": "[color=#ff8000]모바드[/color]"
	, "hp": - 15.0
	, "speed": 0.0
	, "str": 0.0
	, "dex": 0.0
	, "wil": 1.0
	, "trait": null
	, "weapon": "transalspear"
	, "description": "[color=#ff8000]모바드[/color] [color=#c0c0c0]화염 신전의 사제, 아자르의 불꽃을 소환할 수 있다[/color]"
}


var Jallaad = {
	"name": "[color=#ff3070]잘라드[/color]"
	, "hp": 50.0
	, "speed": 0.0
	, "str": 3.0
	, "dex": - 1.0
	, "wil": - 1.0
	, "trait": null
	, "weapon": null
	, "description": "[color=#ff3070]잘라드[/color] [color=#c0c0c0]호사스럽고 오만한 처형인, 무거운 의식검을 휘두른다[/color]"
}

func ready():
	rng.randomize()
	
	Survivor.bag = [random_bag[rng.randi_range(0, random_bag.size() - 1)]
	, random_bag[rng.randi_range(0, random_bag.size() - 1)]
	, random_bag[rng.randi_range(0, random_bag.size() - 1)]
	, random_bag[rng.randi_range(0, random_bag.size() - 1)]]
