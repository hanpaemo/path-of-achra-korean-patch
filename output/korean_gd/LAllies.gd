extends Node


var gorse = {
	"object_type": "ally"
	, "family": "Elemental"
	, "name": "Vine-man"
	, "description": "[color=#20af20]가시덩굴[/color][color=#c0c0c0]\n\n식물로부터 불러낸 비전 하인. 덩굴로 후려친다.[/color]"
	, "quant": Vector2(1, 1)
	, "size": 1
	, "lvl": 1
	, "hp": 25.0
	, "str": 5.0
	, "dex": 5.0
	, "wil": 1.0
	, "speed": 7.0
	, "arm": 10.0
	
	, "dodge": [5.0, 5.0]
	, "deflect": [3.0, 7.0, 10.0]
	, "accuracy": [8.0, 40.0]
	, "damage": [3.0, 10.0]
	, "dmgtype": "blunt"
	, "range_attack": 1
	, "abilities": {
		
	}
	, "proj_art": "none"
	, "sprite": "res://Ham_Sprite/Allies/Ally_Gorse.png"
	
}


var skeleton = {
	"object_type": "ally"
	, "family": "Undead"
	, "name": "Skeleton"
	, "description": "[color=#a0a000]스켈레톤[/color][color=#c0c0c0]\n\n되살아난 전사, 주인에게 묶여 있다.[/color]"
	, "quant": Vector2(1, 1)
	, "size": 1
	, "lvl": 1
	, "hp": 50.0
	, "str": 5.0
	, "dex": 5.0
	, "wil": 1.0
	, "speed": 7.0
	, "arm": 20.0
	
	, "dodge": [5.0, 5.0]
	, "deflect": [3.0, 20.0, 30.0]
	, "accuracy": [8.0, 20.0]
	, "damage": [8.0, 10.0]
	, "dmgtype": "slash"
	, "range_attack": 1
	, "abilities": {
		
	}
	, "proj_art": "none"
	, "sprite": "res://Ham_Sprite/Allies/Ally_Skeleton.png"
	
}


var ally_data

func _ready():
	
	ally_data = loader.load_data("res://Data/Table_Allies.json")
