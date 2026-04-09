#!/usr/bin/env python3
"""
Translate hardcoded English label text in .tscn scene files to Korean.
Extracts .tscn from original PCK, applies translations, outputs modified files.
"""

import struct
from pathlib import Path

WORKSPACE = Path(r"C:\Users\admin\Projects\hanpaemo\path-of-achra")
PCK_PATH = Path(r"D:\SteamLibrary\steamapps\common\Path of Achra\PathofAchra.pck.original")
OUTPUT_DIR = WORKSPACE / "output" / "translated_tscn"

# .tscn files to extract and translate
TSCN_FILES = {
    "res://Scenes/Start_Menu.tscn": "Start_Menu.tscn",
    "res://Scenes/UI_GameMenu.tscn": "UI_GameMenu.tscn",
    "res://Scenes/First_Menu.tscn": "First_Menu.tscn",
    "res://Scenes/Game.tscn": "Game.tscn",
    "res://Scenes/Graveyard.tscn": "Graveyard.tscn",
    "res://Scenes/ScoreScreen.tscn": "ScoreScreen.tscn",
    "res://Scenes/AbilityBook.tscn": "AbilityBook.tscn",
    "res://Scenes/Armory.tscn": "Armory.tscn",
    "res://Scenes/Bestiary.tscn": "Bestiary.tscn",
    "res://Scenes/Credits.tscn": "Credits.tscn",
    "res://Scenes/Feats.tscn": "Feats.tscn",
    "res://Scenes/UI_Inv.tscn": "UI_Inv.tscn",
    "res://Scenes/UI_Level_Up.tscn": "UI_Level_Up.tscn",
    "res://Scenes/UI_Log.tscn": "UI_Log.tscn",
    "res://Scenes/UI_Prestige.tscn": "UI_Prestige.tscn",
    "res://Scenes/UI_Traits_Basic.tscn": "UI_Traits_Basic.tscn",
    "res://Scenes/Universal.tscn": "Universal.tscn",
}

# Translation rules for .tscn files: (old_string, new_string)
# These are safe because they only appear in Label text/bbcode properties
TSCN_TRANSLATIONS = [
    # ── First_Menu.tscn (main home screen) ──
    ('text = "The Path"', 'text = "길"'),
    ('text = "Maqbara"', 'text = "마크바라"'),
    ('text = "Lore"', 'text = "전승"'),
    ('text = "Credits"', 'text = "크레딧"'),
    ('text = "Quit"', 'text = "종료"'),
    ('text = "hold SHIFT for clear options"', 'text = "SHIFT 누르면 초기화 옵션 표시"'),

    # ── Start_Menu.tscn ──
    # Menu button labels
    ('text = "Powers"', 'text = "능력"'),
    ('text = "Armory"', 'text = "무기고"'),
    ('text = "Nemesis"', 'text = "숙적"'),
    ('text = "Return"', 'text = "돌아가기"'),
    ('text = "search..."', 'text = "검색..."'),

    # ── UI_GameMenu.tscn ──
    # Controls / Guide / Fullscreen
    ('bbcode_text = "[color=#ffff50]?: [/color][color=#c0c0c0]Controls[/color]"', 'bbcode_text = "[color=#ffff50]?: [/color][color=#c0c0c0]조작법[/color]"'),
    ('text = "?: Controls"', 'text = "?: 조작법"'),
    ('bbcode_text = "[color=#ffff50]g: [/color][color=#c0c0c0]Guide[/color]"', 'bbcode_text = "[color=#ffff50]g: [/color][color=#c0c0c0]안내서[/color]"'),
    ('text = "g: Guide"', 'text = "g: 안내서"'),
    ('bbcode_text = "[color=#ffff50]ctrl-f: [color=#c0c0c0]Fullscreen / Windowed[/color]"', 'bbcode_text = "[color=#ffff50]ctrl-f: [color=#c0c0c0]전체화면 / 창모드[/color]"'),
    ('text = "ctrl-f: Fullscreen / Windowed"', 'text = "ctrl-f: 전체화면 / 창모드"'),

    # Background Color
    ('bbcode_text = "[color=#707070]Background Color[/color]"', 'bbcode_text = "[color=#707070]배경 색상[/color]"'),
    ('text = "Background Color"', 'text = "배경 색상"'),

    # Auto-attribute
    ('bbcode_text = "[center][color=#c0c0c0]auto-attribute\n[color=#707070]on glory rising"',
     'bbcode_text = "[center][color=#c0c0c0]자동 능력치\n[color=#707070]영광 상승 시"'),
    ('text = "auto-attribute\non glory rising"', 'text = "자동 능력치\n영광 상승 시"'),

    # Gamepad support
    ('bbcode_text = "[center][color=#c0c0c0]gamepad support\n[color=#707070]experimental"',
     'bbcode_text = "[center][color=#c0c0c0]게임패드 지원\n[color=#707070]실험적"'),
    ('text = "gamepad support\nexperimental"', 'text = "게임패드 지원\n실험적"'),

    # Uses (gamepad icons line)
    ('bbcode_text = "[center][color=#707070]Uses [img]', 'bbcode_text = "[center][color=#707070]사용 [img]'),
    ('text = "Uses "', 'text = "사용 "'),

    # Show attack range
    ('bbcode_text = "[color=#c0c0c0]show attack range \n[color=#707070]on mouse hover"',
     'bbcode_text = "[color=#c0c0c0]공격 범위 표시\n[color=#707070]마우스 호버 시"'),
    ('text = "show attack range \non mouse hover"', 'text = "공격 범위 표시\n마우스 호버 시"'),

    # Unit speed bars
    ('bbcode_text = "[color=#c0c0c0]unit speed bars \n[color=#707070]"',
     'bbcode_text = "[color=#c0c0c0]유닛 속도 바\n[color=#707070]"'),
    ('text = "unit speed bars \n"', 'text = "유닛 속도 바\n"'),

    # Save winners only
    ('bbcode_text = "[color=#c0c0c0]save winners only \n[color=#707070]in Maqbara"',
     'bbcode_text = "[color=#c0c0c0]승리자만 저장\n[color=#707070]마크바라에서만"'),
    ('text = "save winners only \nin Maqbara"', 'text = "승리자만 저장\n마크바라에서만"'),

    # Fast mode
    ('bbcode_text = "[color=#c0c0c0]fast mode \n[color=#707070]"',
     'bbcode_text = "[color=#c0c0c0]빠른 모드\n[color=#707070]"'),
    ('text = "fast mode \n"', 'text = "빠른 모드\n"'),

    # FPS cap
    ('bbcode_text = "[color=#c0c0c0]FPS cap\n[color=#707070]"',
     'bbcode_text = "[color=#c0c0c0]FPS 제한\n[color=#707070]"'),
    ('text = "FPS cap\n"', 'text = "FPS 제한\n"'),

    # Vsync
    ('bbcode_text = "[color=#c0c0c0]Vsync\n[color=#707070]false for super speed"',
     'bbcode_text = "[color=#c0c0c0]수직동기화\n[color=#707070]끄면 초고속"'),
    ('text = "Vsync\nfalse for super speed"', 'text = "수직동기화\n끄면 초고속"'),

    # Wide message log
    ('bbcode_text = "[color=#c0c0c0]wide message log\n[color=#707070]"',
     'bbcode_text = "[color=#c0c0c0]넓은 메시지 로그\n[color=#707070]"'),
    ('text = "wide message log\n"', 'text = "넓은 메시지 로그\n"'),

    # Detailed numbers
    ('bbcode_text = "[color=#c0c0c0]detailed numbers\n[color=#707070]in message log"',
     'bbcode_text = "[color=#c0c0c0]상세 수치\n[color=#707070]메시지 로그 내"'),
    ('text = "detailed numbers\nin message log"', 'text = "상세 수치\n메시지 로그 내"'),

    # Floating text
    ('bbcode_text = "[color=#c0c0c0]floating text\n[color=#707070]"',
     'bbcode_text = "[color=#c0c0c0]떠다니는 텍스트\n[color=#707070]"'),
    ('text = "floating text\n"', 'text = "떠다니는 텍스트\n"'),

    # Victory markers
    ('bbcode_text = "[color=#c0c0c0]victory markers\n[color=#707070]"',
     'bbcode_text = "[color=#c0c0c0]승리 표시\n[color=#707070]"'),
    ('text = "victory markers\n"', 'text = "승리 표시\n"'),

    # Hide big life bar
    ('bbcode_text = "[color=#c0c0c0]hide big life bar\n[color=#707070]glory & game turn"',
     'bbcode_text = "[color=#c0c0c0]큰 체력 바 숨기기\n[color=#707070]영광 & 게임 턴"'),
    ('text = "hide big life bar\nglory & game turn"', 'text = "큰 체력 바 숨기기\n영광 & 게임 턴"'),

    # Restore defaults
    ('bbcode_text = "[color=#c0c0c0]Restore defaults[/color]"', 'bbcode_text = "[color=#c0c0c0]기본값 복원[/color]"'),
    ('text = "Restore defaults"', 'text = "기본값 복원"'),

    # Quit game tooltip
    ('bbcode_text = "[color=#ffff00]Quit game[/color] -[color=#ff0000]deletes[/color] this character -to [color=#00ff00]SAVE[/color], quit from the [color=#ffff00]world map[/color]"',
     'bbcode_text = "[color=#ffff00]게임 종료[/color] -캐릭터가 [color=#ff0000]삭제[/color]됩니다 -[color=#00ff00]저장[/color]하려면 [color=#ffff00]세계 지도[/color]에서 나가세요"'),
    ('text = "Quit game -deletes this character -to SAVE, quit from the world map"',
     'text = "게임 종료 -캐릭터가 삭제됩니다 -저장하려면 세계 지도에서 나가세요"'),

    # ── CONTROLS window (UI_GameMenu.tscn) ──
    ('"auto play"', '"자동 플레이"'),
    ('automatically attack a targeted enemy, step towards the closest enemy in range, pick up the closest item, go to the exit, walk through the exit',
     '대상 적을 자동 공격, 범위 내 가장 가까운 적에게 이동, 가장 가까운 아이템 줍기, 출구로 이동, 출구 통과'),
    ('also cycles through most menus, randomizes character', '대부분의 메뉴 순환, 캐릭터 무작위 생성에도 사용'),
    ('change target, must be in attack range', '대상 변경, 공격 범위 내여야 함'),
    ('stand still', '제자리 대기'),
    ('walk through exit, enter new land, confirm death, start game', '출구 통과, 새 땅 진입, 사망 확인, 게임 시작'),
    ('recite your 1st, 2nd or 3rd prayer, if available', '1번, 2번 또는 3번 기도 암송 (가능한 경우)'),
    ('step in a direction, or perform an initial attack against an adjacent enemy in a direction',
     '방향으로 이동하거나, 해당 방향의 인접한 적에게 첫 공격 수행'),
    ('"middle direction"', '"가운데 방향"'),

    # ── GUIDE window (UI_GameMenu.tscn) ──
    ('[center]GUIDE[/center]', '[center]안내서[/center]'),
    ('[center]CONTROLS', '[center]조작법'),
    ('The goal is to get to the exit of each level. You may kill enemies by attacking them, but it\'s not necessary. You gain [color=#ffff50]Glory[/color] for killing enemies and for entering new levels. On the last level of every area, you will find one or more [color=#ffff50]items[/color] which can greatly increase your capabilities',
     '각 레벨의 출구에 도달하는 것이 목표입니다. 적을 공격하여 처치할 수 있지만 필수는 아닙니다. 적 처치와 새 레벨 진입 시 [color=#ffff50]영광[/color]을 얻습니다. 각 구역의 마지막 레벨에서 능력을 크게 향상시킬 수 있는 [color=#ffff50]아이템[/color]을 찾을 수 있습니다'),
    ('to spend points on new powers -- you gain +1 point every time your Glory rises',
     '새 능력에 포인트를 사용 -- 영광이 오를 때마다 +1 포인트 획득'),
    ('to view your inventory and equip new items. This will also show your attributes and provide descriptions of their mechanics. Your [color=#50ff50]Speed[/color] is very important -- it determines how many times you act compared to enemies -- and can be reduced by the Encumbrance and Inflexibility of your items',
     '인벤토리를 보고 새 아이템을 장착합니다. 능력치와 역학 설명도 표시됩니다. [color=#50ff50]속도[/color]는 매우 중요합니다 -- 적에 비해 몇 번 행동하는지 결정합니다 -- 아이템의 하중과 경직으로 감소할 수 있습니다'),
    ('To build a strong character, try to select powers and wield items that combine with each other. There are no active abilities aside from your [color=#78bca4]prayers[/color] -- everything is triggered by a particular event -- "on step" "on dealing fire damage" etc',
     '강한 캐릭터를 만들려면 서로 조합되는 능력과 아이템을 선택하세요. [color=#78bca4]기도[/color] 외에 능동 기술은 없습니다 -- 모든 것은 특정 이벤트에 의해 발동됩니다 -- "이동 시" "화염 피해 시" 등'),
    ('"[color=#ffff50]On attack[/color]": when you perform any kind of attack. An "initial attack" is specifically the first basic attack performed by each weapon, and can sometimes generate "extra attacks," such as with the Swift Blade',
     '"[color=#ffff50]공격 시[/color]": 어떤 종류의 공격이든 수행할 때. "첫 공격"은 각 무기의 첫 번째 기본 공격이며, 쾌검 등으로 "추가 공격"을 생성할 수 있습니다'),
    ('"[color=#ffff50]On hit[/color]": an attack that connects and deals damage. Free hits can also be generated by some powers, such as Guard and Projection',
     '"[color=#ffff50]명중 시[/color]": 적중하여 피해를 입히는 공격. 수호와 투사 등 일부 능력으로 추가 명중을 생성할 수 있습니다'),
    ('"[color=#ffff50]On dealing damage[/color]": refers to damage dealt in any way by you',
     '"[color=#ffff50]피해 적용 시[/color]": 어떤 방식으로든 당신이 입힌 피해를 의미합니다'),
    ('"[color=#ffff50]On entrance[/color]": when you first enter a new level',
     '"[color=#ffff50]진입 시[/color]": 새 레벨에 처음 진입할 때'),
    ('"[color=#ffff50]On prayer[/color]": when you click one of the [color=#78bca4]prayers[/color] at the top of the screen. New prayers appear as you gain Glory, and their charges refresh depending on the prayer and your religion',
     '"[color=#ffff50]기도 시[/color]": 화면 상단의 [color=#78bca4]기도[/color]를 클릭할 때. 영광을 얻으면 새 기도가 나타나며, 충전은 기도와 신앙에 따라 회복됩니다'),
    ('"[color=#ffff50]On shrug off[/color]": when you prevent a hit with your armor',
     '"[color=#ffff50]방어력 상쇄 시[/color]": 방어력으로 공격을 막을 때'),
    ('These are some of the triggers to pay attention to when building your character, there are many more to experiment with, and it is possible to create elaborate chain reactions. Have fun!',
     '이것들은 캐릭터를 만들 때 주의해야 할 발동 조건 중 일부입니다. 더 많은 것을 실험할 수 있으며, 정교한 연쇄 반응을 만들 수 있습니다. 즐기세요!'),

    # ── First_Menu.tscn additional ──
    ('text = "All data"', 'text = "모든 데이터"'),
    ('text = "Current character"', 'text = "현재 캐릭터"'),
    ('text = "Start"', 'text = "시작"'),

    # ── Start_Menu.tscn additional ──
    ('text = "Culture"', 'text = "문화"'),
    ('text = "Class"', 'text = "직업"'),
    ('text = "Religion"', 'text = "신앙"'),
    ('text = "Load Save"', 'text = "저장 불러오기"'),
    ('text = "Randomize"', 'text = "무작위"'),
    ('text = "RESET"', 'text = "초기화"'),
    ('text = "TAB random"', 'text = "TAB 무작위"'),
    ('text = "Next Unlock"', 'text = "다음 해금"'),
    ('text = "Choose culture, class and religion..."', 'text = "문화, 직업, 신앙을 선택하세요..."'),

    # ── Game.tscn ──
    ('text = "You die"', 'text = "당신은 죽었다"'),
    ('text = "Hide"', 'text = "숨기기"'),
    ('text = "DROP"', 'text = "버리기"'),
    ('[color=#ff5050]Attack[/color]', '[color=#ff5050]공격[/color]'),
    ('text = "30/30  Attack', 'text = "30/30  공격'),

    # ── Graveyard.tscn ──
    ('text = "Forget"', 'text = "잊기"'),

    # ── ScoreScreen.tscn ──
    ('text = "Stats"', 'text = "통계"'),

    # ── AbilityBook.tscn ──
    ('text = "Imagine thy power..."', 'text = "그대의 힘을 상상하라..."'),

    # ── Armory.tscn ──
    ('text = "Treasures line the path..."', 'text = "보물이 길 위에 늘어서..."'),

    # ── Bestiary.tscn ──
    ('text = "Enemies fill the land..."', 'text = "적이 땅을 메우고 있다..."'),

    # ── Feats.tscn ──
    ('text = "O legend..."', 'text = "오 전설이여..."'),
    ('text = "Clear steam achievements (click while holding ALT)"', 'text = "Steam 업적 초기화 (ALT 누른 채 클릭)"'),

    # ── UI_Inv.tscn ──
    ('text = "Main"', 'text = "주무장"'),
    ('text = "Off"', 'text = "보조"'),
    ('text = "Traits & Powers"', 'text = "특성 & 능력"'),
    ('text = "Body"', 'text = "몸"'),
    ('text = "Equip from bag"', 'text = "가방에서 장착"'),
    ('text = "Effects:"', 'text = "효과:"'),
    ('text = "search bag..."', 'text = "가방 검색..."'),

    # ── UI_Level_Up.tscn ──
    ('bbcode_text = "[center]Your Glory rises!"', 'bbcode_text = "[center]영광이 오른다!"'),
    ('text = "Your Glory rises!"', 'text = "영광이 오른다!"'),
    ('text = "Choose one:"', 'text = "하나 선택:"'),
    ('text = "You get:"', 'text = "획득:"'),
    ('text = "Unlocked"', 'text = "해금"'),
    ('text = "O little pilgrim..."', 'text = "오 작은 순례자여..."'),

    # ── UI_Traits_Basic.tscn ──
    ('text = "Strength"', 'text = "힘"'),
    ('text = "Dexterity"', 'text = "민첩"'),
    ('text = "Willpower"', 'text = "의지"'),
    ('bbcode_text = "[right]5 points available"', 'bbcode_text = "[right]5 포인트 남음"'),
    ('text = "5 points available"', 'text = "5 포인트 남음"'),
    ('bbcode_text = "Prestige class unlocked!\n\nYou are now a Champion"', 'bbcode_text = "상위 직업 해금!\n\n당신은 이제 챔피언입니다"'),
    ('text = "Prestige class unlocked!\n\nYou are now a Champion"', 'text = "상위 직업 해금!\n\n당신은 이제 챔피언입니다"'),

    # ── UI_Prestige.tscn ──
    ('text = "Make thy choice..."', 'text = "선택하라..."'),
    ('text = "Become"', 'text = "전직"'),

    # ── Universal.tscn ──
    ('text = "Enter"', 'text = "입장"'),

    # ── bbcode Return label (Feats.tscn etc.) ──
    ('bbcode_text = "[center]Return"', 'bbcode_text = "[center]돌아가기"'),

    # ── Gamepad button labels (appear in multiple files) ──
    ('text = "select"', 'text = "선택"'),
    ('text = "switch', 'text = "전환'),

    # ── UI_Popup.tscn ──
    ('text = "OK"', 'text = "확인"'),

    # ── bbcode_text duplicates (AbilityBook, Armory, Bestiary, Feats) ──
    ('bbcode_text = "[color=#c0c0c0]Imagine thy power...[/color]"',
     'bbcode_text = "[color=#c0c0c0]그대의 힘을 상상하라...[/color]"'),
    ('bbcode_text = "[color=#c0c0c0]Treasures line the path...[/color]"',
     'bbcode_text = "[color=#c0c0c0]보물이 길 위에 늘어서...[/color]"'),
    ('bbcode_text = "[color=#c0c0c0]Enemies fill the land...[/color]"',
     'bbcode_text = "[color=#c0c0c0]적이 땅을 메우고 있다...[/color]"'),
    ('bbcode_text = "[color=#c0c0c0]O legend...[/color]"',
     'bbcode_text = "[color=#c0c0c0]오 전설이여...[/color]"'),
    ('bbcode_text = "[center][color=#a00000]Clear steam achievements [color=#707070](click while holding ALT)"',
     'bbcode_text = "[center][color=#a00000]Steam 업적 초기화 [color=#707070](ALT 누른 채 클릭)"'),

    # ── UI_GameMenu.tscn / UI_Log.tscn — volume labels ──
    ('bbcode_text = "[color=#50af50]Sounds[/color] | | | | |"',
     'bbcode_text = "[color=#50af50]효과음[/color] | | | | |"'),
    ('text = "Sounds | | | | |"', 'text = "효과음 | | | | |"'),
    ('bbcode_text = "[color=#5050af]Music[/color]  | | | | |"',
     'bbcode_text = "[color=#5050af]음악[/color]  | | | | |"'),
    ('text = "Music  | | | | |"', 'text = "음악  | | | | |"'),

    # ── First_Menu.tscn ──
    ('text = "< options"', 'text = "< 설정"'),

    # ══════════════════════════════════════════════════════
    # Round 3: bbcode_text missing where text= was translated
    # ══════════════════════════════════════════════════════

    # ── Game.tscn ──
    ('bbcode_text = "[center]Quit"', 'bbcode_text = "[center]종료"'),
    ('bbcode_text = "[color=#a0a0a0]Hide[/color]"', 'bbcode_text = "[color=#a0a0a0]숨기기[/color]"'),

    # ── Graveyard.tscn ──
    ('bbcode_text = "[center][color=#ff8080]Start[/color]"', 'bbcode_text = "[center][color=#ff8080]시작[/color]"'),
    ('bbcode_text = "[center]Forget"', 'bbcode_text = "[center]잊기"'),

    # ── ScoreScreen.tscn ──
    ('bbcode_text = "[center]Stats"', 'bbcode_text = "[center]통계"'),

    # ── Start_Menu.tscn ──
    ('bbcode_text = "[color=#a0a0a0]Load [color=#ffff50]S[/color]ave[/color]"',
     'bbcode_text = "[color=#a0a0a0]저장 [color=#ffff50]불[/color]러오기[/color]"'),

    # ── UI_Inv.tscn ──
    ('bbcode_text = "[color=#ffff40]Traits & Powers[/color]"',
     'bbcode_text = "[color=#ffff40]특성 & 능력[/color]"'),
    ('bbcode_text = "[color=#a0a0a0]Effects:[/color]"',
     'bbcode_text = "[color=#a0a0a0]효과:[/color]"'),

    # ── UI_Prestige.tscn ──
    ('bbcode_text = "[color=#c0c0c0]Make thy choice...',
     'bbcode_text = "[color=#c0c0c0]선택하라...'),
    ('bbcode_text = "[center]Become"', 'bbcode_text = "[center]전직"'),

    # ── UI_Traits_Basic.tscn ──
    ('bbcode_text = "[color=#ff7050]Strength[/color]"',
     'bbcode_text = "[color=#ff7050]힘[/color]"'),
    ('bbcode_text = "[color=#50ff70]Dexterity[/color]"',
     'bbcode_text = "[color=#50ff70]민첩[/color]"'),
    ('bbcode_text = "[color=#c050ff]Willpower[/color]"',
     'bbcode_text = "[color=#c050ff]의지[/color]"'),

    # ── Start_Menu.tscn — Culture/Class/Religion bbcode labels ──
    ('bbcode_text = "[color=#a0a0a0][color=#ffff50]C[/color]ulture[/color]"',
     'bbcode_text = "[color=#a0a0a0][color=#ffff50]문[/color]화[/color]"'),
    ('bbcode_text = "[color=#a0a0a0]C[color=#ffff50]l[/color]ass[/color]"',
     'bbcode_text = "[color=#a0a0a0][color=#ffff50]직[/color]업[/color]"'),
    ('bbcode_text = "[color=#a0a0a0][color=#ffff50]R[/color]eligion[/color]"',
     'bbcode_text = "[color=#a0a0a0][color=#ffff50]신[/color]앙[/color]"'),
    ('bbcode_text = "[color=#a0a0a0][color=#ffff50]TAB [/color]random[/color]"',
     'bbcode_text = "[color=#a0a0a0][color=#ffff50]TAB [/color]무작위[/color]"'),

    # ── UI_Level_Up.tscn — Vigor button label ──
    ('bbcode_text = "[color=#a0a0a0][[color=#ffff50]4[/color]] [color=#ff8080]Vigor[/color]',
     'bbcode_text = "[color=#a0a0a0][[color=#ffff50]4[/color]] [color=#ff8080]활력[/color]'),

    # ══════════════════════════════════════════════════════
    # Round 5 (2차 감수): Additional TSCN translations
    # ══════════════════════════════════════════════════════

    # ── First_Menu.tscn — crash help text ──
    ('text = "*if crashing, try deleting:"', 'text = "*크래시 발생 시 삭제 시도:"'),

    # ══════════════════════════════════════════════════════
    # Round 6 (5차 감수): TSCN bbcode/text consistency fixes
    # ══════════════════════════════════════════════════════

    # ── UI_Level_Up.tscn — "O little pilgrim" bbcode missing translation ──
    ('bbcode_text = "[color=#909090][center]O little pilgrim..."',
     'bbcode_text = "[color=#909090][center]오 작은 순례자여..."'),

    # ── UI_Level_Up.tscn — Vigor text= fallback (bbcode already translated) ──
    ('text = "[4] Vigor"', 'text = "[4] 활력"'),
]


def extract_tscn_from_pck(pck_path: Path, targets: dict[str, str], output_dir: Path) -> dict[str, Path]:
    """Extract .tscn files from PCK. Returns {res_path: disk_path}."""
    output_dir.mkdir(parents=True, exist_ok=True)
    extracted = {}

    with open(pck_path, "rb") as f:
        f.read(4)  # magic
        f.read(16)  # version fields
        f.read(16 * 4)  # reserved
        file_count = struct.unpack("<I", f.read(4))[0]

        entries = []
        for _ in range(file_count):
            nl = struct.unpack("<I", f.read(4))[0]
            name = f.read(nl).decode("utf-8", errors="replace").rstrip("\x00")
            pad = (4 - (nl % 4)) % 4
            if pad:
                f.read(pad)
            offset = struct.unpack("<Q", f.read(8))[0]
            size = struct.unpack("<Q", f.read(8))[0]
            f.read(16)  # md5
            if name in targets:
                entries.append((name, offset, size))

        for name, offset, size in entries:
            f.seek(offset)
            data = f.read(size)
            out_path = output_dir / targets[name]
            out_path.write_bytes(data)
            extracted[name] = out_path
            print(f"  Extracted: {name} ({size} bytes)")

    return extracted


def translate_tscn(path: Path) -> bool:
    """Apply translations to a .tscn file. Returns True if changed."""
    # Use binary read/write to preserve original \n line endings (not \r\n).
    # Windows write_text() converts \n → \r\n, causing \r to render as '?' in Godot.
    raw = path.read_bytes()
    text = raw.decode("utf-8")
    original = text
    for old, new in TSCN_TRANSLATIONS:
        text = text.replace(old, new)
    if text != original:
        path.write_bytes(text.encode("utf-8"))
        return True
    return False


def main():
    print("Extracting .tscn files from PCK...")
    extracted = extract_tscn_from_pck(PCK_PATH, TSCN_FILES, OUTPUT_DIR)

    print("\nTranslating .tscn files...")
    translated = []
    for res_path, disk_path in extracted.items():
        if translate_tscn(disk_path):
            translated.append(res_path)
            print(f"  Translated: {res_path}")
        else:
            print(f"  No changes: {res_path}")

    print(f"\nTranslated {len(translated)} .tscn files")

    # Output the TSCN_REPLACE_MAP for build_korean_patch.py
    if translated:
        print("\n# Add to build_korean_patch.py TSCN_REPLACE_MAP:")
        print("TSCN_REPLACE_MAP = {")
        for res_path in translated:
            print(f'    "{res_path}": "{TSCN_FILES[res_path]}",')
        print("}")


if __name__ == "__main__":
    main()
