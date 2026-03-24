extends Node

class_name proem

static func get_continent_line():
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var lines = ["오 빛나는 길이여...",
	"오 폭력의 법칙이여...",
	"그대의 급한 발걸음...",
	"오 떠도는 불꽃이여...",
	"오 파괴하는 손이여...",
	"은빛 실처럼...",
	"오 펼쳐지는 영혼이여...",
	"오 어두운 불꽃이여...",
	"저주받은 땅은 고요하고...",
	"오 두려운 발걸음이여...",
	"오 폐허가 된 역사여...",
	"오 비참한 굶주림이여...",
	"오 창조여, 오 절망이여...",
	"영광의 발걸음으로...",
	"피의 통로를 지나...",
	"오 갈라진 밤이여",
	"오 에워싸는 어둠이여",
	"오 명예여, 오 타락이여"
	]
	
	
	if StateWorld.land == "void":
		lines = ["누가 닿을 수 없는 어둠을 다스리는가?..",
		"모든 속박을 넘어...",
		"오 지배의 속삭임이여...",
		"모든 것이 갈라지니, 오 손이여...",
		"오 추상의 공포여...",
		"오 한 점 빛이여...",
		"투쟁자여...",
		"오 분열이여...",
		"밤의 집에서...",
		"오 천둥치는 어둠이여...",
		"어떤 소멸로?",
		"오 부서진 길이여",
		"오 왕이여...",
		"오 삼키는 법칙이여",
		"어떤 이름 없는 굴절로?",
		"오 왜곡하는 영혼이여...",
		"모든 족쇄가 버려지고...",
		"정신의 끝에서...",
		"어떤 산산이 부서진 법칙으로?",
		"모든 진실이 와해되다"]
	
	var line = lines[rng.randi_range(0, lines.size() - 1)]
	
	
	
	return line
	
	
static func compose():
	
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var form = rng.randi_range(1, 3)
	
	
	var stringa = ""
	
	match form:
		1:
			stringa += form1(rng)
		2:
			stringa += form2(rng)
		3:
			stringa += form3(rng)
	
	
	return stringa

static func form1(rng):
	
	var first = ["순례자", "투쟁자", "전사", "유랑자", "하인", "비천한 자", "탐구자", "제자", "증인", "방랑자"]
	var second = ["빛바랜", "부서진", "타오르는", "끝없는", "해체된", "갈라진"]
	var third = ["빛", "밤", "승리", "분노", "욕망", "신성", "힘", "갈망"]
	var fourth = ["영광", "평화", "보상", "존엄", "생명", "힘", "이 기도"]
	var fifth = ["스치고", "앞지르고", "버리고", "치유하고", "구원하고", "일으키고", "들어올리고"]
	var sixth = ["난폭한", "타락한", "고통받는", "굶주린", "흐트러진", "나태한", "멈출 수 없는"]
	var seventh = ["심장", "영혼", "법칙", "여정", "탐색", "신앙", "칼날", "무기"]
	var eighth = ["길 위에서", "오솔길 위에서", "다리 위에서", "끝자락에서", "경계에서", "바다 위에서",
	"신전에서", "사당에서", "면전에서", "시대 속에서", "그 시각에"]
	var ninth = ["빛나는", "거친", "심연의", "광란의", "이름 없는", "퇴락한", "와해된", "무수한"]
	var tenth = ["별", "소멸", "절멸", "신비", "괴물", "고통", "홍수", "부활", "전쟁"]
	

	

	
	var stringa = ""
	stringa = "'오 "
	stringa += random_string(rng, second)
	stringa += " "
	stringa += random_string(rng, third)
	stringa += "의 "
	stringa += random_string(rng, first)
	stringa += "여\n\n"
	stringa += random_string(rng, fourth)
	stringa += "이(가) 그대의 "
	stringa += random_string(rng, sixth)
	stringa += " "
	stringa += random_string(rng, seventh)
	stringa += "을(를) "
	stringa += random_string(rng, fifth)
	stringa += "\n\n"
	stringa += random_string(rng, ninth)
	stringa += " "
	stringa += random_string(rng, tenth)
	stringa += "의 "
	stringa += random_string(rng, eighth)
	stringa += "'"
	return stringa
	
static func form2(rng):
	
	
	var second = ["빛바랜", "부서진", "타오르는", "끝없는", "해체된", "갈라진"]
	var third = ["빛", "밤", "승리", "분노", "욕망", "신성", "힘", "갈망"]

	var fifth = ["스치고", "앞지르고", "버리고", "치유하고", "구원하고", "일으키고", "들어올리고"]
	var sixth = ["난폭한", "타락한", "고통받는", "굶주린", "흐트러진", "나태한", "멈출 수 없는"]
	
	var eighth = ["길 위에서", "오솔길 위에서", "다리 위에서", "끝자락에서", "경계에서", "바다 위에서",
	"신전에서", "사당에서", "면전에서", "시대 속에서", "그 시각에"]
	
	var tenth = ["별", "소멸", "절멸", "신비", "괴물", "고통", "홍수", "부활", "전쟁"]

	var eleventh = ["공포", "구원을", "조심하라", "돌아가라", "나아가라"]
	var color = ["보라빛", "검은", "붉은", "비취빛", "에메랄드빛", "회색"]
	var object = ["죽음", "검", "도끼", "단검", "홀", "가면"]
	
	var name1 = ToolGenerateName.generate_name()
	
	
	var stringa = ""
	stringa += "'오 "
	stringa += random_string(rng, color)
	stringa += " "
	stringa += random_string(rng, object)
	stringa += "의 "
	stringa += name1
	stringa += "여\n\n"
	stringa += random_string(rng, sixth)
	stringa += " "
	stringa += random_string(rng, tenth)
	stringa += "의 "
	stringa += random_string(rng, eighth)
	stringa += "\n\n"
	stringa += random_string(rng, eleventh)
	stringa += "!\n\n그대의 "
	stringa += random_string(rng, second)
	stringa += " "
	stringa += random_string(rng, third)
	stringa += "을(를) "
	stringa += random_string(rng, fifth)
	stringa += "!'"

	return stringa


static func form3(rng):
	
	var verb = ["파괴한", "구출한", "복원한", "성별한", "패배시킨", "한때 사랑한", "부순"]
	var action = ["찾으리라", "소멸시키리라", "지우리라", "추구하리라", "삼키리라", "드러내리라", "축복하리라"]
	var name1 = ToolGenerateName.generate_name()
	var name2 = ToolGenerateName.generate_name()
	var fifth = ["스치고", "앞지르고", "버리고", "치유하고", "구원하고", "일으키고", "들어올리고"]
	var color = ["보라빛", "검은", "붉은", "비취빛", "에메랄드빛", "회색"]
	var object = ["죽음", "검", "도끼", "단검", "홀", "가면"]
	var sixth = ["난폭한", "타락한", "고통받는", "굶주린", "흐트러진", "나태한", "멈출 수 없는"]
	var tenth = ["별", "소멸", "절멸", "신비", "괴물", "고통", "홍수", "부활", "전쟁"]
	var eighth = ["길 위에서", "오솔길 위에서", "다리 위에서", "끝자락에서", "경계에서", "바다 위에서",
	"신전에서", "사당에서", "면전에서", "시대 속에서", "그 시각에"]
	var third = ["빛", "밤", "승리", "분노", "욕망", "신성", "힘", "갈망"]
	
	
	
	
	
	var stringa = ""
	stringa += "'오 "
	stringa += name2
	stringa += "을(를) "
	stringa += random_string(rng, verb)
	stringa += " "
	stringa += name1
	stringa += "여\n\n그대의 "
	stringa += random_string(rng, color)
	stringa += " "
	stringa += random_string(rng, object)
	stringa += "을(를) "
	stringa += random_string(rng, fifth)
	stringa += "\n\n"
	stringa += random_string(rng, sixth)
	stringa += " "
	stringa += random_string(rng, tenth)
	stringa += "이(가) 그대를 "
	stringa += random_string(rng, action)
	stringa += "\n\n"
	stringa += random_string(rng, third)
	stringa += "의 "
	stringa += random_string(rng, eighth)
	stringa += "...'"
	
	
	return stringa


static func random_string(rng, array):
	var stringa = array[rng.randi_range(0, array.size() - 1)]
	return stringa




static func compose_end_poem(data):
	var stringa = "[center][img]res://Ham_Sprite/World/Sea2.png[/img][color=#a0a0a0]\n"
	var god = "nothing"
	var god_data = loader.load_data("res://Data/Table_Gods.json")
	
	for trait in data.traits:
		if trait.organize == "god":
			god = god_data[trait.title].name
	
			
	match data.condition:
		"victory":
			stringa += "오 순례자여!\n\n" + god
			stringa += "\n\n우주의 투쟁 속에서..."
			stringa += "\n\n물러나는 파도 위에서..."
			
			stringa += compose_elemental_portion(data)
			
			stringa += "\n\n깊었도다, 밤의 고통이여"
			stringa += "\n\n영광스러운 아크라!"

			
		"death":
			stringa += "오 투쟁자여..."
			stringa += compose_elemental_portion(data)
			stringa += "\n\n그대의 죽음은 전설이 되리니\n\n빛나는 길 위에서..."
			stringa += "\n\n[img]" + data.killer_sprite + "[/img]"
			stringa += "[img]" + data.place_sprite + "[/img]"
			
			
		"abandon":
			stringa += "오 순례자여...\n\n그대의 이름이 사라진다..."
	
	stringa += "\n[img]res://Ham_Sprite/World/Sea2.png[/img]"
	
	
	return stringa

static func compose_elemental_portion(data):
	var stringa = ""
	

	
	var elements = []
	for trait in data.powers:
			if elements.has(trait.Element) == false:
				elements.append(trait.Element)
	
	var elemental_word_dict = {

"Body": ["[color=#af8f50]", "기술", "전쟁의 춤", "멈출 수 없는"],
"Fire": ["[color=#ff8000]", "열기", "타오르는 손", "불타는"],
"Lightning": ["[color=#0060ff]", "전하", "벼락", "폭풍에 벼려진"],
"Poison": ["[color=#70ff00]", "병독", "용해의 술법", "독에 물든"],
"Life": ["[color=#00a000]", "활력", "에메랄드의 길", "넘치는"],
"Ice": ["[color=#5080ff]", "냉기", "얼어붙은 길", "깨지지 않는"],
"Astral": ["[color=#8030af]", "색조", "성광", "승천한"],
"Death": ["[color=#a0a000]", "파멸", "사악한 술법", "더럽혀진"],
"Psychic": ["[color=#ffaf30]", "집중", "번뜩이는 정신", "무한한"],
"Blood": ["[color=#ff1010]", "갈혈", "핏빛 구름", "붉게 물든"]
	}
	
	
	if elements.size():
		
		var first = ""
		var second = ""
		var third = ""
		first = elemental_word_dict[elements[0]][0] + elemental_word_dict[elements[0]][1] + "[/color]"
		
		if elements.size() == 1:
			second = elemental_word_dict[elements[0]][0] + elemental_word_dict[elements[0]][2] + "[/color]"
			third = elemental_word_dict[elements[0]][0] + elemental_word_dict[elements[0]][3] + "[/color]"
		
		if elements.size() == 2:
			second = elemental_word_dict[elements[1]][0] + elemental_word_dict[elements[1]][2] + "[/color]"
			third = elemental_word_dict[elements[0]][0] + elemental_word_dict[elements[0]][3] + "[/color]"
		
		if elements.size() == 3:
			second = elemental_word_dict[elements[1]][0] + elemental_word_dict[elements[1]][2] + "[/color]"
			third = elemental_word_dict[elements[2]][0] + elemental_word_dict[elements[2]][3] + "[/color]"
	
		if data.condition == "victory":
			stringa = "\n\n전설적인 " + first + "의"
			stringa += "\n\n" + second + "의 지배자"
			stringa += "\n\n그대의 영혼 " + third
		else:
			stringa = "\n\n떠오르는 " + first + "의"
			stringa += "\n\n" + second + "의 탐구자"
			
	
	return stringa
