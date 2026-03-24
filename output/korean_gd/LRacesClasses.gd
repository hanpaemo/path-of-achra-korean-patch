extends Node


enum RACE{SPRITE, HP, SPEED, STR, DEX, WIL, STR_per_level, DEX_per_level, 
WIL_per_level}

var HUMAN = [load("res://Ham_Sprite/Player/Player_Human.png"), 100.0, 10.0, 5.0, 5.0, 5.0, 0.0, 0.0, 0.0]
var ELF = [load("res://Ham_Sprite/Player/Player_Elf.png"), 75.0, 12.0, 3.0, 7.0, 5.0, 0.0, 0.0, 0.0]
var ORC = [load("res://Ham_Sprite/Player/Player_Orc.png"), 150.0, 8.0, 8.0, 5.0, 2.0, 0.0, 0.0, 0.0]
var UNDEAD = [load("res://Ham_Sprite/Player/Player_Skeleton.png"), 50.0, 6.0, 8.0, 8.0, 8.0, 0.0, 0.0, 0.0]
var WILD = [load("res://Ham_Sprite/Player/Player_Wildling.png"), 100.0, 10.0, 5.0, 4.0, 4.0, 1.0, 0.0, 0.0]
var JINN = [load("res://Ham_Sprite/Player/Player_Jinn.png"), 25.0, 15.0, 1.0, 8.0, 5.0, 0.0, 0.0, 0.0]

var Human = {
	"name": "[color=#bf9f40]인간[/color]"
	, "sprite": "res://Ham_Sprite/Player/Player_Human.png"
	, "hp": 100.0
	, "speed": 10.0
	, "str": 5.0
	, "dex": 5.0
	, "wil": 5.0
	, "description": "[color=#bf9f40]인간[/color] [color=#c0c0c0]세상 각지에서 부와 정화를 찾아 방황하며 들어온다[/color]"
}

var Elf = {
	"name": "[color=#309fbf]엘프[/color]"
	, "sprite": "res://Ham_Sprite/Player/Player_Elf.png"
	, "hp": 75.0
	, "speed": 15.0
	, "str": 3.0
	, "dex": 8.0
	, "wil": 4.0
	, "description": "[color=#309fbf]엘프[/color] [color=#c0c0c0]불멸의 환락가, 곡예의 기량을 뽐내길 열망한다[/color]"
}

var Orc = {
	"sprite": "res://Ham_Sprite/Player/Player_Orc.png"
	, "name": "[color=#609f30]오크[/color]"
	, "hp": 150.0
	, "speed": 7.0
	, "str": 8.0
	, "dex": 5.0
	, "wil": 2.0
	, "description": "[color=#609f30]오크[/color] [color=#c0c0c0]비할 데 없는 힘을 자랑하며, 침략의 사자로 여행한다[/color]"
}

var Undead = {
	"sprite": "res://Ham_Sprite/Player/Player_Skeleton.png"
	, "name": "[color=#a0a000]언데드[/color]"
	, "hp": 50.0
	, "speed": 5.0
	, "str": 6.0
	, "dex": 6.0
	, "wil": 8.0
	, "description": "[color=#a0a000]언데드[/color] [color=#c0c0c0]저주받은 육신, 놀라운 의지로 첫 번째 죽음에서 되돌아왔다[/color]"
}

var Beast = {
	"sprite": "res://Ham_Sprite/Player/Player_Wildling.png"
	, "name": "[color=#df8f50]야수[/color]"
	, "hp": 200.0
	, "speed": 8.0
	, "str": 6.0
	, "dex": 6.0
	, "wil": 1.0
	, "description": "[color=#df8f50]야수[/color] [color=#c0c0c0]본능에 이끌려 지하에서 온 강건한 순례자들이다[/color]"
}

var Jinn = {
	"sprite": "res://Ham_Sprite/Player/Player_Jinn.png"
	, "name": "[color=#8030bf]진[/color]"
	, "hp": 25.0
	, "speed": 30.0
	, "str": 3.0
	, "dex": 3.0
	, "wil": 7.0
	, "description": "[color=#8030bf]진[/color] [color=#c0c0c0]기이한 피와 연기 없는 불로 이루어진, 빠르고 연약한 존재[/color]"
}
