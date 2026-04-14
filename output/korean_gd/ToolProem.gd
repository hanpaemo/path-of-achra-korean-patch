extends Node

class_name proem

static func get_continent_line():
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var lines = ["O glimmering path...", 
	"O law of violence...", 
	"Thy hurried step...", 
	"O wandering fire...", 
	"O destroying hand...", 
	"Like a silver cord...", 
	"O unfurling spirit...", 
	"O dark flame...", 
	"The doomed lands are silent...", 
	"O fearful tread...", 
	"O ruined history...", 
	"O wretched hunger...", 
	"O creation, O despair...", 
	"By glorious step...", 
	"By passage of blood...", 
	"O divided night", 
	"O encircling dark", 
	"O honor, O debasement"
	]
	
	
	if StateWorld.land == "void":
		lines = ["Who rules the touchless dark?..", 
		"Beyond all constraint...", 
		"O whisper of control...", 
		"Every part divided, O hand...", 
		"O horror of abstraction...", 
		"O fleck of light...", 
		"Struggler...", 
		"O diremption...", 
		"In the house of night...", 
		"O thundering dark...", 
		"By what obliteration?", 
		"O broken path", 
		"O King...", 
		"O devouring law", 
		"By what nameless refraction?", 
		"O distorting spirit...", 
		"Every shackle abandoned...", 
		"At the end of the mind...", 
		"By what shattered law?", 
		"Every truth disrupted"]
	
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
	
	var first = ["pilgrim", "striver", "warrior", "nomad", "servant", "wretch", "seeker", "disciple", "witness", "wanderer"]
	var second = ["tarnished", "broken", "inflamed", "perpetual", "disintegrated", "divided"]
	var third = ["light", "night", "victory", "rage", "desire", "holiness", "power", "yearning"]
	var fourth = ["glory", "peace", "reward", "dignity", "life", "strength", "this prayer"]
	var fifth = ["brush", "overtake", "abandon", "heal", "redeem", "raise", "lift"]
	var sixth = ["violent", "depraved", "suffering", "hungry", "distracted", "indolent", "unstoppable"]
	var seventh = ["heart", "soul", "law", "journey", "quest", "faith", "blade", "weapon"]
	var eighth = ["on the road", "on the path", "on the bridge", "on the edge", "on the border", "on the sea", 
	"in the temple", "at the shrine", "in the presence", "in the age", "in the hour"]
	var ninth = ["glimmering", "wild", "abyssal", "delirious", "nameless", "degraded", "disrupted", "multifoliate"]
	var tenth = ["stars", "annihilation", "exctinction", "mystery", "monstrosity", "pain", "flood", "resurrection", "war"]
	

	

	
	var stringa = ""
	stringa = "'O "
	stringa += random_string(rng, first)
	stringa += " of "
	stringa += random_string(rng, second)
	stringa += " "
	stringa += random_string(rng, third)
	stringa += "\n\nmay "
	stringa += random_string(rng, fourth)
	stringa += " "
	stringa += random_string(rng, fifth)
	stringa += " thy "
	stringa += random_string(rng, sixth)
	stringa += " "
	stringa += random_string(rng, seventh)
	stringa += "\n\n"
	stringa += random_string(rng, eighth)
	stringa += " of "
	stringa += random_string(rng, ninth)
	stringa += " "
	stringa += random_string(rng, tenth)
	stringa += "'"
	return stringa
	
static func form2(rng):
	
	
	var second = ["tarnished", "broken", "inflamed", "unending", "disintegrated", "divided"]
	var third = ["light", "night", "victory", "rage", "desire", "holiness", "power", "yearning"]

	var fifth = ["brush", "overtake", "abandon", "heal", "redeem", "raise", "lift"]
	var sixth = ["violent", "depraved", "suffering", "hungry", "distracted", "indolent", "unstoppable"]
	
	var eighth = ["on the road", "on the path", "on the bridge", "on the edge", "on the border", "on the sea", 
	"in the temple", "at the shrine", "in the presence", "in the age", "in the hour"]
	
	var tenth = ["stars", "annihilation", "exctinction", "mystery", "monstrosity", "pain", "flood", "resurrection", "war"]
	
	var eleventh = ["terror", "save us", "beware", "turn back", "go forth"]
	var color = ["violet", "black", "red", "turquoise", "emerald", "grey"]
	var object = ["death", "sword", "axe", "knife", "scepter", "mask"]
	
	var name1 = ToolGenerateName.generate_name()
	
	
	var stringa = ""
	stringa += "'O "
	stringa += name1
	stringa += " of the "
	stringa += random_string(rng, color)
	stringa += " "
	stringa += random_string(rng, object)
	stringa += "\n\n"
	stringa += random_string(rng, eighth)
	stringa += " of "
	stringa += random_string(rng, sixth)
	stringa += " "
	stringa += random_string(rng, tenth)
	stringa += "\n\n"
	stringa += random_string(rng, eleventh)
	stringa += "!\n\n"
	stringa += random_string(rng, fifth)
	stringa += " thy "
	stringa += random_string(rng, second)
	stringa += " "
	stringa += random_string(rng, third)
	stringa += "!'"

	return stringa


static func form3(rng):
	
	var verb = ["destroyed", "rescued", "restored", "anointed", "defeated", "once loved", "broke"]
	var action = ["find", "obliterate", "erase", "seek", "smother", "reveal", "bless"]
	var name1 = ToolGenerateName.generate_name()
	var name2 = ToolGenerateName.generate_name()
	var fifth = ["brush", "overtake", "abandon", "heal", "redeem", "raise", "lift"]
	var color = ["violet", "black", "red", "turquoise", "emerald", "grey"]
	var object = ["death", "sword", "axe", "knife", "scepter", "mask"]
	var sixth = ["violent", "depraved", "suffering", "hungry", "distracted", "indolent", "unstoppable"]
	var tenth = ["stars", "annihilation", "exctinction", "mystery", "monstrosity", "pain", "flood", "resurrection", "war"]
	var eighth = ["on the road", "on the path", "on the bridge", "on the edge", "on the border", "on the sea", 
	"in the temple", "at the shrine", "in the presence", "in the age", "in the hour"]
	var third = ["light", "night", "victory", "rage", "desire", "holiness", "power", "yearning"]
	
	
	
	
	
	var stringa = ""
	stringa += "'O "
	stringa += name1
	stringa += " who "
	stringa += random_string(rng, verb)
	stringa += " "
	stringa += name2
	stringa += "\n\n"
	stringa += random_string(rng, fifth)
	stringa += " thy "
	stringa += random_string(rng, color)
	stringa += " "
	stringa += random_string(rng, object)
	stringa += "\n\nmay "
	stringa += random_string(rng, sixth)
	stringa += " "
	stringa += random_string(rng, tenth)
	stringa += " "
	stringa += random_string(rng, action)
	stringa += " you\n\n"
	stringa += random_string(rng, eighth)
	stringa += " of "
	stringa += random_string(rng, third)
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

"Body": ["[color=#af8f50]", "skill", "war-dance", "unstoppable"], 
"Fire": ["[color=#ff8000]", "heat", "burning hand", "inflamed"], 
"Lightning": ["[color=#0060ff]", "charge", "thunderbolt", "storm-wrought"], 
"Poison": ["[color=#70ff00]", "sickness", "dissolving arts", "envenomed"], 
"Life": ["[color=#00a000]", "vim", "emerald way", "brimming"], 
"Ice": ["[color=#5080ff]", "cold", "frozen way", "unfractured"], 
"Astral": ["[color=#8030af]", "hue", "astral beam", "ascended"], 
"Death": ["[color=#a0a000]", "doom", "vile arts", "befouled"], 
"Psychic": ["[color=#ffaf30]", "focus", "glinting mind", "unbounded"], 
"Blood": ["[color=#ff1010]", "bloodthirst", "gore-cloud", "painted red"]
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
			stringa = "\n\nof legendary " + first
			stringa += "\n\nmaster of the " + second
			stringa += "\n\nthy spirit " + third
		else:
			stringa = "\n\nof rising " + first
			stringa += "\n\nseeker of the " + second
			
	
	return stringa
