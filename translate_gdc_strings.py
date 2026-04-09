#!/usr/bin/env python3
"""
Translate hardcoded English UI strings in decompiled GDScript files to Korean.
Applies context-aware string replacements to create Korean .gd files,
then compiles them to .gdc for inclusion in the Korean patch PCK.
"""

import re
import shutil
import subprocess
from pathlib import Path

WORKSPACE = Path(r"C:\Users\admin\Projects\hanpaemo\path-of-achra")
DECOMPILED_DIR = WORKSPACE / "output" / "decompiled_all"
KOREAN_DIR = WORKSPACE / "output" / "korean_gd"
COMPILED_DIR = WORKSPACE / "output" / "compiled"
GDRE_TOOLS = Path(r"C:\Users\admin\Tools\gdre_tools\gdre_tools.exe")

# Files that need translation (res:// path -> local filename)
FILES_TO_TRANSLATE = {
    "res://Scenes/Start_Menu.gdc": "Start_Menu.gd",
    "res://Scenes/UI_GameMenu.gdc": "UI_GameMenu.gd",
    "res://Scenes/DeathScreen.gdc": "DeathScreen.gd",
    "res://Scenes/ScoreScreen.gdc": "ScoreScreen.gd",
    "res://Scenes/UI_Level_Up.gdc": "UI_Level_Up.gd",
    "res://Scenes/UI_Inventory.gdc": "UI_Inventory.gd",
    "res://Scenes/Armory.gdc": "Armory.gd",
    "res://Scenes/Bestiary.gdc": "Bestiary.gd",
    "res://Scenes/Graveyard.gdc": "Graveyard.gd",
    "res://Scenes/Player.gdc": "Player.gd",
    "res://Scenes/Enemy.gdc": "Enemy.gd",
    "res://Scenes/UI_Enemies.gdc": "UI_Enemies.gd",
    "res://Scenes/GameBars.gdc": "GameBars.gd",
    "res://Scenes/UI_Traits_Basic.gdc": "UI_Traits_Basic.gd",
    "res://Scenes/Feats.gdc": "Feats.gd",
    "res://Scenes/AbilityBook.gdc": "AbilityBook.gd",
    "res://Scenes/Game.gdc": "Game.gd",
    "res://Scenes/Continent.gdc": "Continent.gd",
    "res://Scenes/UI_Inv.gdc": "UI_Inv.gd",
    "res://Scenes/Button.gdc": "Button.gd",
    "res://Scenes/Button_Bag.gdc": "Button_Bag.gd",
    "res://ToolMessageCreator.gdc": "ToolMessageCreator.gd",
    "res://ToolCycler.gdc": "ToolCycler.gd",
    "res://ToolPrestigeGiver.gdc": "ToolPrestigeGiver.gd",
    "res://ToolInvokes.gdc": "ToolInvokes.gd",
    "res://ToolMagicMaker.gdc": "ToolMagicMaker.gd",
    "res://ToolProem.gdc": "ToolProem.gd",
    "res://ToolLevelUp.gdc": "ToolLevelUp.gd",
    "res://ToolStatMods.gdc": "ToolStatMods.gd",
    "res://ProcessBuffs.gdc": "ProcessBuffs.gd",
    "res://Process_Text.gdc": "Process_Text.gd",
    "res://Process_Queue.gdc": "Process_Queue.gd",
    "res://RouterEvents_OnAttack.gdc": "RouterEvents_OnAttack.gd",
    "res://RouterEvents_OnDamage.gdc": "RouterEvents_OnDamage.gd",
    "res://RouterEvents_OnDeath.gdc": "RouterEvents_OnDeath.gd",
    "res://RouterEvents_OnHit.gdc": "RouterEvents_OnHit.gd",
    "res://RouterEvents_OnDodge.gdc": "RouterEvents_OnDodge.gd",
    "res://RouterEvents_OnBlock.gdc": "RouterEvents_OnBlock.gd",
    "res://RouterEvents_OnHeal.gdc": "RouterEvents_OnHeal.gd",
    "res://RouterEvents_OnInvoke.gdc": "RouterEvents_OnInvoke.gd",
    "res://RouterEvents_OnMove.gdc": "RouterEvents_OnMove.gd",
    "res://RouterEvents_OnEnterLevel.gdc": "RouterEvents_OnEnterLevel.gd",
    "res://RouterEvents_OnSpawned.gdc": "RouterEvents_OnSpawned.gd",
    "res://RouterEvents_Summon.gdc": "RouterEvents_Summon.gd",
    "res://RouterEvents_GameTurn.gdc": "RouterEvents_GameTurn.gd",
    "res://RouterEvents_OnLearn.gdc": "RouterEvents_OnLearn.gd",
    "res://RouterEvents_OnLevelUp.gdc": "RouterEvents_OnLevelUp.gd",
    "res://RouterEvents_OnApplyBuff.gdc": "RouterEvents_OnApplyBuff.gd",
    "res://RouterEvents_OnPickup.gdc": "RouterEvents_OnPickup.gd",
    "res://RouterEvents_OnIntervention.gdc": "RouterEvents_OnIntervention.gd",
    "res://RouterEvents_OnShrugOff.gdc": "RouterEvents_OnShrugOff.gd",
    "res://StatePlayerSheet.gdc": "StatePlayerSheet.gd",
    "res://Scenes/UI_Prestige.gdc": "UI_Prestige.gd",
    "res://Scenes/UI_God.gdc": "UI_God.gd",
    "res://Scenes/UI_Popup.gdc": "UI_Popup.gd",
    "res://ToolSpawnUnit.gdc": "ToolSpawnUnit.gd",
    "res://RouterEvents_OnApplyBuff.gdc": "RouterEvents_OnApplyBuff.gd",
    "res://translate.gdc": "translate.gd",
    "res://RouterEvents_OnRemoveBuff.gdc": "RouterEvents_OnRemoveBuff.gd",
    "res://Scenes/Tile.gdc": "Tile.gd",
    "res://Scenes/UI_Log.gdc": "UI_Log.gd",
    "res://Scenes/DeckbuttonGrid.gdc": "DeckbuttonGrid.gd",
    "res://Scenes/SummonButton.gdc": "SummonButton.gd",
    "res://Scenes/Verse.gdc": "Verse.gd",
    "res://Scenes/InfoButtons.gdc": "InfoButtons.gd",
    "res://ButtonAutoLevel.gdc": "ButtonAutoLevel.gd",  # Scenes/ prefix stripped by gdre
    "res://Scenes/ButtonAutoLevel.gdc": "ButtonAutoLevel.gd",
    # ── New: race/class/enemy/ally/preta/menu/effects ──
    "res://LRacesClasses.gdc": "LRacesClasses.gd",
    "res://LClasses.gdc": "LClasses.gd",
    "res://LEnemies.gdc": "LEnemies.gd",
    "res://LAllies.gdc": "LAllies.gd",
    "res://ToolPretaMaker.gdc": "ToolPretaMaker.gd",
    "res://Scenes/First_Menu.gdc": "First_Menu.gd",
    "res://Process_Queue_Actions_Effects.gdc": "Process_Queue_Actions_Effects.gd",
    "res://Process_Fight.gdc": "Process_Fight.gd",
    # ── UI.gd (title bar), UI_Log.gd already included ──
    "res://Scenes/UI.gdc": "UI.gd",
}

# ──────────────────────────────────────────────────────
#  Translation rules: (old_string, new_string)
#  Applied as literal replacements in order.
#  Be VERY specific to avoid replacing code identifiers.
# ──────────────────────────────────────────────────────

# These are applied via simple string replacement in quoted strings only
TRANSLATIONS = [
    # ── Cycle names (ToolCycler.gd) ──
    ("First[/color] Cycle of [color=#c09050]Humility", "첫 번째[/color] 겸손의 [color=#c09050]순환"),
    ("Second[/color] Cycle of [color=#9050c0]Degradation", "두 번째[/color] 타락의 [color=#9050c0]순환"),
    ("Third[/color] Cycle of [color=#50b050]Hope", "세 번째[/color] 희망의 [color=#50b050]순환"),
    ("Fourth[/color] Cycle of [color=#b03090]Despair", "네 번째[/color] 절망의 [color=#b03090]순환"),
    ("Fifth[/color] Cycle of [color=#3030e0]Enlightenment", "다섯 번째[/color] 깨달음의 [color=#3030e0]순환"),
    ("Sixth[/color] Cycle of [color=#a02020]Annihilation", "여섯 번째[/color] 소멸의 [color=#a02020]순환"),
    ("Seventh[/color] Cycle of [color=#f06030]Apocalypse", "일곱 번째[/color] 종말의 [color=#f06030]순환"),
    ("Eighth[/color] Cycle of [color=#f03090]Passion", "여덟 번째[/color] 열정의 [color=#f03090]순환"),
    ("Ninth[/color] Cycle of [color=#2020a0]Disintegration", "아홉 번째[/color] 분열의 [color=#2020a0]순환"),
    ("Tenth[/color] Cycle of [color=#408040]Consumption", "열 번째[/color] 탐식의 [color=#408040]순환"),
    ("Eleventh[/color] Cycle of [color=#908060]Revelation", "열한 번째[/color] 계시의 [color=#908060]순환"),
    ("Twelfth[/color] Cycle of [color=#ffaf20]Glory", "열두 번째[/color] 영광의 [color=#ffaf20]순환"),
    # Cycles 13-32 (different bbcode pattern)
    ("Thirteenth [color=#c0c0c0]Cycle of[/color] Obsession", "열세 번째 [color=#c0c0c0]순환:[/color] 집착"),
    ("Fourteenth [color=#c0c0c0]Cycle of[/color] Solitude", "열네 번째 [color=#c0c0c0]순환:[/color] 고독"),
    ("Fifteenth [color=#c0c0c0]Cycle of[/color] Arrogance", "열다섯 번째 [color=#c0c0c0]순환:[/color] 오만"),
    ("Sixteenth [color=#c0c0c0]Cycle of[/color] Rupture", "열여섯 번째 [color=#c0c0c0]순환:[/color] 파열"),
    ("Seventeenth [color=#c0c0c0]Cycle of[/color] Ablation", "열일곱 번째 [color=#c0c0c0]순환:[/color] 삭마"),
    ("Eighteenth [color=#c0c0c0]Cycle of[/color] Elision", "열여덟 번째 [color=#c0c0c0]순환:[/color] 소거"),
    ("Nineteenth [color=#c0c0c0]Cycle of[/color] Conception", "열아홉 번째 [color=#c0c0c0]순환:[/color] 태동"),
    ("Twentieth [color=#c0c0c0]Cycle of[/color] Eminence", "스무 번째 [color=#c0c0c0]순환:[/color] 탁월"),
    ("Twenty-first [color=#c0c0c0]Cycle of[/color] Indifference", "스물한 번째 [color=#c0c0c0]순환:[/color] 무관심"),
    ("Twenty-second [color=#c0c0c0]Cycle of[/color] Resentment", "스물두 번째 [color=#c0c0c0]순환:[/color] 원한"),
    ("Twenty-third [color=#c0c0c0]Cycle of[/color] Massacre", "스물세 번째 [color=#c0c0c0]순환:[/color] 학살"),
    ("Twenty-fourth [color=#c0c0c0]Cycle of[/color] Divinity", "스물네 번째 [color=#c0c0c0]순환:[/color] 신성"),
    ("Twenty-fifth [color=#c0c0c0]Cycle of[/color] Grim Revision", "스물다섯 번째 [color=#c0c0c0]순환:[/color] 암울한 수정"),
    ("Twenty-sixth [color=#c0c0c0]Cycle of[/color] Shattered Law", "스물여섯 번째 [color=#c0c0c0]순환:[/color] 깨진 율법"),
    ("Twenty-seventh [color=#c0c0c0]Cycle of[/color] Cosmic Rage", "스물일곱 번째 [color=#c0c0c0]순환:[/color] 우주적 분노"),
    ("Twenty-eighth [color=#c0c0c0]Cycle of[/color] Swollen Fear", "스물여덟 번째 [color=#c0c0c0]순환:[/color] 부풀은 공포"),
    ("Twenty-ninth [color=#c0c0c0]Cycle of[/color] Twisted Light", "스물아홉 번째 [color=#c0c0c0]순환:[/color] 뒤틀린 빛"),
    ("Thirtieth [color=#c0c0c0]Cycle of[/color] the Sunken World", "서른 번째 [color=#c0c0c0]순환:[/color] 가라앉은 세계"),
    ("Thirty-first [color=#c0c0c0]Cycle of[/color] the Broken Tower", "서른한 번째 [color=#c0c0c0]순환:[/color] 부서진 탑"),
    ("Thirty-second [color=#c0c0c0]Cycle of[/color] the Outer Dark", "서른두 번째 [color=#c0c0c0]순환:[/color] 외부의 어둠"),

    # ── Amplification stats (ToolCycler.gd) ──
    ("[color=#ff8030]+ Hit[/color]", "[color=#ff8030]+ 명중[/color]"),
    ("[color=#ffa050]+ Accuracy[/color]", "[color=#ffa050]+ 명중률[/color]"),
    ("[color=#50ffff]+ Dodge[/color]", "[color=#50ffff]+ 회피[/color]"),
    ("[color=#5050ff]+ Block[/color]", "[color=#5050ff]+ 방어[/color]"),
    ("[color=#5050ff]+ Armor[/color]", "[color=#5050ff]+ 방어력[/color]"),
    ("[color=#20ff20]+ Speed[/color]", "[color=#20ff20]+ 속도[/color]"),
    ("[color=#ff8080]+ max Life[/color]", "[color=#ff8080]+ 최대 체력[/color]"),

    # ── Stats display (used everywhere) ──
    # Careful: only replace stat labels in display strings, not code identifiers
    ("[color=#ff7050]STR[/color]", "[color=#ff7050]힘[/color]"),
    ("[color=#50ff70]DEX[/color]", "[color=#50ff70]민첩[/color]"),
    ("[color=#c050ff]WIL[/color]", "[color=#c050ff]의지[/color]"),
    ("[color=#ff8080]Life[/color]", "[color=#ff8080]체력[/color]"),
    ("[color=#20ff20]Speed[/color]", "[color=#20ff20]속도[/color]"),
    ("[color=#ffa050]Accuracy[/color]", "[color=#ffa050]명중률[/color]"),
    ("[color=#ff8030]Hit[/color]", "[color=#ff8030]명중[/color]"),
    ("[color=#5050ff]Block[/color]", "[color=#5050ff]방어[/color]"),
    ("[color=#50ffff]Dodge[/color]", "[color=#50ffff]회피[/color]"),
    ("[color=#5050ff]Armor[/color]", "[color=#5050ff]방어력[/color]"),

    # ScoreScreen stat labels
    ("[color=#ff7050]Strength[/color]", "[color=#ff7050]힘[/color]"),
    ("[color=#50ff70]Dexterity[/color]", "[color=#50ff70]민첩[/color]"),
    ("[color=#c050ff]Willpower[/color]", "[color=#c050ff]의지[/color]"),

    # Settings auto-attribute options
    ("[color=#ff7050]Strength[/color]\"", "[color=#ff7050]힘[/color]\""),
    ("[color=#50ff70]Dexterity[/color]\"", "[color=#50ff70]민첩[/color]\""),
    ("[color=#c050ff]Willpower[/color]\"", "[color=#c050ff]의지[/color]\""),
    ("[color=#ff8080]Vigor[/color]\"", "[color=#ff8080]활력[/color]\""),
    ("[color=#ff2090]Random[/color]\"", "[color=#ff2090]무작위[/color]\""),

    # ── Stat labels in gray (Armory, ToolMessageCreator) ──
    ("[color=#a0a0a0]Accuracy[/color]", "[color=#a0a0a0]명중률[/color]"),
    ("[color=#a0a0a0]Hit[/color]", "[color=#a0a0a0]명중[/color]"),
    ("[color=#a0a0a0]Block[/color]", "[color=#a0a0a0]방어[/color]"),
    ("[color=#a0a0a0]Range[/color]", "[color=#a0a0a0]사거리[/color]"),
    ("[color=#a0a0a0]Armor[/color]", "[color=#a0a0a0]방어력[/color]"),
    ("[color=#a0a0a0]Encumbrance[/color]", "[color=#a0a0a0]하중[/color]"),
    ("[color=#a0a0a0]Weapon Size[/color]", "[color=#a0a0a0]무기 크기[/color]"),
    ("[color=#a0a0a0]Inflexibility[/color]", "[color=#a0a0a0]경직[/color]"),

    # ── Resist text ──
    # ── UI_Inv.gd — Sacrifice button ──
    ("[color=#a0a0a0][[color=#ffff50]3[/color]] [color=#ff4000]Sacrifice[/color]",
     "[color=#a0a0a0][[color=#ffff50]3[/color]] [color=#ff4000]제물[/color]"),
    ("[color=#a0a0a0][[color=#ffff50]1[/color]] Put in bag[/color]",
     "[color=#a0a0a0][[color=#ffff50]1[/color]] 가방에 넣기[/color]"),
    ("[color=#a0a0a0][[color=#ffff50]1[/color]] Put in bag",
     "[color=#a0a0a0][[color=#ffff50]1[/color]] 가방에 넣기"),
    ("[color=#a0a0a0][[color=#ffff50]1[/color]] [color=#c0c0c0]Put in bag[/color]",
     "[color=#a0a0a0][[color=#ffff50]1[/color]] [color=#c0c0c0]가방에 넣기[/color]"),
    ("[color=#a0a0a0][[color=#ffff50]2[/color]] Swap hands",
     "[color=#a0a0a0][[color=#ffff50]2[/color]] 손 교체"),
    ("[color=#c0c0c0]Support Hand\\n\\nMain Hand is 'two-handing'",
     "[color=#c0c0c0]보조손\\n\\n주무장이 '양손 장착' 중"),
    ("[center][color=#c0c0c0]Support Hand",
     "[center][color=#c0c0c0]보조손"),
    ("[color=#c0c0c0]Naked Head[/color]", "[color=#c0c0c0]빈 머리[/color]"),
    ("[color=#c0c0c0]Naked Chest[/color]", "[color=#c0c0c0]빈 가슴[/color]"),
    ("[color=#c0c0c0]Naked Arm[/color]", "[color=#c0c0c0]빈 팔[/color]"),
    ("[color=#c0c0c0]Naked Leg[/color]", "[color=#c0c0c0]빈 다리[/color]"),
    ("[color=#a0a0a0][[color=#ffff50]2[/color]] [color=#c0c0c0]Wield in Off hand[/color]",
     "[color=#a0a0a0][[color=#ffff50]2[/color]] [color=#c0c0c0]보조손에 장착[/color]"),
    ("[color=#a0a0a0][[color=#ffff50]1[/color]] Wield in Main hand[/color]",
     "[color=#a0a0a0][[color=#ffff50]1[/color]] 주무장에 장착[/color]"),
    ("[color=#a0a0a0][[color=#ffff50]1[/color]] Wear as armor[/color]",
     "[color=#a0a0a0][[color=#ffff50]1[/color]] 방어구로 착용[/color]"),
    ("[center][color=#ffff50]Bare Fist[/color]",
     "[center][color=#ffff50]맨주먹[/color]"),
    ("[color=#ffff50]Bare Fist[/color]\" + \"\\n\"",
     "[color=#ffff50]맨주먹[/color]\" + \"\\n\""),

    # ── Process_Fight.gd — combat penetration messages ──
    # guard break
    ("\" break \" + \"the \" + name_d + \"'s guard!\"", "\"(이)가 \" + name_d + \"의 방어를 돌파!\""),
    ("\" breaks \" + name_d + \" guard!\"", "\"(이)가 \" + name_d + \" 방어를 돌파!\""),
    # armor penetrate
    ("\" penetrate \" + \"the \" + name_d + \"'s armor!\"", "\"(이)가 \" + name_d + \"의 방어구를 관통!\""),
    ("\" penetrates \" + name_d + \" armor!\"", "\"(이)가 \" + name_d + \" 방어구를 관통!\""),
    # dodge anticipate
    ("\" anticipate \" + \"the \" + name_d + \"'s dodge!\"", "\"(이)가 \" + name_d + \"의 회피를 간파!\""),
    ("\" anticipates \" + name_d + \" dodge!\"", "\"(이)가 \" + name_d + \" 회피를 간파!\""),
    # dodge message
    ("\" dodges \" + name_a + \" attack\"", "\"(이)가 \" + name_a + \" 공격을 회피\""),
    ("\" [color=#50ffff]dodge[/color] \" + \"the \" + name_a + \"'s attack\"",
     "\"(이)가 \" + name_a + \"의 공격을 [color=#50ffff]회피[/color]\""),
    # block message
    ("\" blocks \" + name_a + \" attack\"", "\"(이)가 \" + name_a + \" 공격을 방어\""),
    ("\" [color=#5050ff]block[/color] \" + \"the \" + name_a + \"'s attack\"",
     "\"(이)가 \" + name_a + \"의 공격을 [color=#5050ff]방어[/color]\""),
    # shrug off message
    ("\" shrugs off \" + name_a + \" attack\"", "\"(이)가 \" + name_a + \" 공격을 상쇄\""),
    ("\" [color=#5050ff]shrug off[/color] \" + \"the \" + name_a + \"'s attack\"",
     "\"(이)가 \" + name_a + \"의 공격을 [color=#5050ff]상쇄[/color]\""),

    # ── RouterEvents_OnHit.gd — hit messages ──
    # Player attacks: "You hit the [name]"
    ("name_a = \"You\"\n\t\tstringa = name_a + \" \" + damage_text + \" the \" + name_d + \" \"",
     "name_a = \"\"\n\t\tstringa = name_a + name_d + \"을(를) \" + damage_text + \" \""),
    # Player self-hit: "You hit yourself"
    ("name_a = \"You\"\n\t\tname_d = \"yourself\"\n\t\tstringa = name_a + \" \" + damage_text + \" \" + name_d + \" \"",
     "name_a = \"\"\n\t\tname_d = \"자신\"\n\t\tstringa = name_a + name_d + \"을(를) \" + damage_text + \" \""),
    # Enemy attacks player: "[name] hits you"
    ("name_d = \"you\"\n\t\tstringa = \"\" + name_a + \" \" + damage_text + \"[color=#ff8030]s[/color] \" + name_d + \" \"",
     "name_d = \"\"\n\t\tstringa = name_a + \"(이)가 당신을 \" + damage_text + \" \""),
    # ── UI_Inv.gd — States header ──
    ("\"[color=#707070]States[/color]\"", "\"[color=#707070]상태[/color]\""),

    # ── UI_Inv.gd — status labels ──
    ("[color=#ffff50]Two-handing[/color]", "[color=#ffff50]양손 장착[/color]"),
    ("[color=#50ffff]Single-handing[/color]", "[color=#50ffff]한손 장착[/color]"),
    ("[color=#ff0000]Encumbered[/color]", "[color=#ff0000]과중량[/color]"),
    ("[color=#00ff00]Unencumbered[/color]", "[color=#00ff00]경량[/color]"),
    ("[color=#ff0000]Inflexible[/color]", "[color=#ff0000]경직[/color]"),
    ("[color=#00ff00]Flexible[/color]", "[color=#00ff00]유연[/color]"),

    # UI_Inv.gd — status descriptions
    (": your Off-hand is empty and supports your Main-hand, adding Hit and Accuracy",
     ": 보조손이 비어 주무장을 지지하여 명중과 명중률이 추가됩니다"),
    (": your Off-hand holds a weapon, or your Main-hand is a bare fist; you attack with both hands",
     ": 보조손에 무기가 있거나 주무장이 맨주먹이면 양손으로 공격합니다"),
    (": your Speed and Dodge are reduced because your Encumbrance is higher than your Strength",
     ": 하중이 힘보다 높아 속도와 회피가 감소합니다"),
    (": your Encumbrance is lower than or equal to your Strength, and accrues no penalty",
     ": 하중이 힘 이하로 페널티가 없습니다"),
    (": your Inflexibility is above 1, usually due to certain equipped armor; your Speed and Willpower damage bonus are heavily penalized, while your Block is raised",
     ": 경직이 1을 초과하여 (보통 특정 방어구 장착 시) 속도와 의지 피해 보너스가 크게 감소하고 방어가 상승합니다"),
    (": your Inflexibility is at 1 and accrues no penalty",
     ": 경직이 1로 페널티가 없습니다"),

    # UI_Inv.gd — popup messages
    ("\"Bag full!\"", "\"가방이 가득 참!\""),
    ("\"Enemies are at hand!\"", "\"적이 가까이 있다!\""),

    # UI_Inv.gd — Sacrifice messages
    ("[color=#a0a0a0][color=#ff4000]Sacrifice[/color] ",
     "[color=#a0a0a0][color=#ff4000]제물[/color] "),
    ("[color=#ff4000]Sacrifice![/color] You",
     "[color=#ff4000]제물![/color]"),
    ("\" upgrade \"", "\" 강화: \""),

    # ── ToolInvokes.gd — prayer cast message ──
    ("\"[color=#ffff50]You[/color] recite the \" + invoke.name",
     "\"[color=#ffff50]기도 암송:[/color] \" + invoke.name"),

    # ── RouterEvents_OnMove.gd — stand still ──
    ("\"You stand still\"", "\"제자리 대기\""),

    # ── RouterEvents_OnDamage.gd / RouterEvents_OnAttack.gd — immunity & shatter ──
    ("\" is immune!\"", "\" 면역!\""),
    ("\"Your protection is shattered!\"", "\"보호막이 파괴되었다!\""),
    ("\" protection is shattered!\"", "\" 보호막이 파괴됨!\""),

    # ── GameBars.gd — turn indicator ──
    ("\"[right]-> turn\"", "\"[right]-> 턴\""),

    # ── RouterEvents_OnEnterLevel.gd / RouterEvents_OnLearn.gd / ToolInvokes.gd / ToolLevelUp.gd ──
    ("\"You are invigorated by the cycle...", "\"순환의 기운이 충전된다..."),

    # ── Player.gd — divine intervention ──
    ("\"[color=#78bca4]Divine intervention[/color]! \"", "\"[color=#78bca4]신의 개입[/color]! \""),
    ("\" preserves your life!...\"", "\"(이)가 생명을 보존!...\""),

    # ── UI_GameMenu.gd — true/false settings display ──
    ("\"[center][color=#80a080]true[/color]\"", "\"[center][color=#80a080]켜짐[/color]\""),
    ("\"[center][color=#a08080]false[/color]\"", "\"[center][color=#a08080]꺼짐[/color]\""),

    # ── ScoreScreen.gd — day and cycle ──
    ("\"It was day [color=#ffff00]\" + str(data.day) + \"[/color]\"",
     "\"[color=#ffff00]\" + str(data.day) + \"[/color]일차\""),
    ("\"In the \" + cycler.int_to_cycle_name(data.cycle)",
     "cycler.int_to_cycle_name(data.cycle)"),

    # ── RouterEvents_OnHeal.gd — Willpower heal bonus label ──
    ("\"Willpower +\"", "\"의지 +\""),
    # Heal messages (SVO structure — complex, but some are safe)
    ("\"You heal \" + \"for [color=#50ff50]\"", "\"회복: [color=#50ff50]\""),
    ("\"The \" + name_d + \" heals you \" + \"for [color=#50ff50]\"",
     "name_d + \"(이)가 회복: [color=#50ff50]\""),
    ("\"You heal the \" + name_a + \" for [color=#50af50]\"",
     "name_a + \" 회복: [color=#50af50]\""),
    ("\"The \" + name_d + \" heals itself for [color=#50af50]\"",
     "name_d + \"(이)가 자가 회복: [color=#50af50]\""),
    ("\"The \" + name_d + \" heals the \" + name_a + \" for [color=#50af50]\"",
     "name_d + \"(이)가 \" + name_a + \" 회복: [color=#50af50]\""),

    ("\"Resist \"", "\"저항 \""),
    ("\"Resists:[/color]\"", "\"저항:[/color]\""),
    ("\"Resists:\"", "\"저항:\""),
    ("[color=#707070]Resists [/color]", "[color=#707070]저항 [/color]"),
    ("[color=#808080]Resists... ", "[color=#808080]저항... "),
    ("[color=#808080]Resists:\\n", "[color=#808080]저항:\\n"),
    ("[color=#808080]Resists:\\n\"", "[color=#808080]저항:\\n\""),
    ("[color=#707070]Resists:[/color]", "[color=#707070]저항:[/color]"),

    # ── UI_GameMenu.gd ──
    ("[color=#5050af]Music[/color]", "[color=#5050af]음악[/color]"),
    ("[color=#50af50]Sounds[/color]", "[color=#50af50]효과음[/color]"),
    ("[color=#ff4000]Abandon[/color]", "[color=#ff4000]포기[/color]"),
    ("[color=#00ff00]Save[/color] & [color=#ff4000]Quit[/color]", "[color=#00ff00]저장[/color] 후 [color=#ff4000]종료[/color]"),
    ("[color=#ff4000]Quit[/color]", "[color=#ff4000]종료[/color]"),
    ("you cannot save on the Path of Dust", "먼지의 길에서는 저장할 수 없습니다"),
    ("to Save, quit from the world map", "저장하려면 세계 지도에서 나가세요"),
    ("[color=#50ff50]active", "[color=#50ff50]활성"),
    ("[color=#ff5050]off", "[color=#ff5050]비활성"),
    ("[color=#808080]none[/color]", "[color=#808080]없음[/color]"),

    # ── Start_Menu.gd ──
    ("\"Start\"", "\"시작\""),
    ("\"Continue\"", "\"계속\""),
    ("[color=#a05050]Clear [color=#ffff50]S[/color]ave[/color]", "[color=#a05050]저장 [color=#ffff50]삭[/color]제[/color]"),
    ("[color=#50a050]Load [color=#ffff50]S[/color]ave[/color]", "[color=#50a050]저장 [color=#ffff50]불[/color]러오기[/color]"),
    ("\"Head \"", "\"머리 \""),
    ("\"Off hand \"", "\"보조 \""),
    ("\"Main hand \"", "\"주무장 \""),
    ("\"Arms \"", "\"팔 \""),
    ("\"Chest \"", "\"가슴 \""),
    ("\"Legs \"", "\"다리 \""),
    ("empty...[/color]", "비어 있음...[/color]"),
    ("Enter the [color=#ffff50]land of Achra[/color]...", "[color=#ffff50]아크라의 땅[/color]에 입장..."),
    ("Your [color=#ffff00]currently saved character[/color] will be [color=#ff3030]deleted[/color]", "현재 [color=#ffff00]저장된 캐릭터[/color]가 [color=#ff3030]삭제[/color]됩니다"),
    ("View possible treasures that can be found on the path...", "길에서 발견할 수 있는 보물을 확인..."),
    ("View possible enemies of the path...", "길의 적을 확인..."),
    ("View powers and prestige classes that can be selected on the path...", "길에서 선택할 수 있는 능력과 상위 직업을 확인..."),
    ("[color=#50c050]Load[/color] / [color=#c05050]Clear[/color] an existing character.", "[color=#50c050]불러오기[/color] / [color=#c05050]삭제[/color] 기존 캐릭터"),
    ("This character will be [color=#ff3030]deleted[/color] if:", "다음의 경우 이 캐릭터가 [color=#ff3030]삭제[/color]됩니다:"),
    ("You start the game with a new character", "새 캐릭터로 게임을 시작할 때"),
    ("You close an in-progress game without saving", "진행 중인 게임을 저장하지 않고 종료할 때"),
    ("Combine culture, class and religion to create a new character", "문화, 직업, 신앙을 조합하여 새 캐릭터를 만듭니다"),
    ("[color=#707070]Combine[/color]", "[color=#707070]조합[/color]"),
    ("[color=#ffff50]C[/color]ulture[/color]", "[color=#ffff50]문[/color]화[/color]"),
    ("C[color=#ffff50]l[/color]ass[/color]", "[color=#ffff50]직[/color]업[/color]"),
    ("[color=#ffff50]R[/color]eligion[/color]", "[color=#ffff50]신[/color]앙[/color]"),
    ("to randomize[/color]", "무작위 선택[/color]"),
    ("[color=#78bca4]Prayer[/color]", "[color=#78bca4]기도[/color]"),
    ("max charges", "최대 충전"),
    ("[color=#707070]Effect[/color]", "[color=#707070]효과[/color]"),
    ("[color=#ffff50]Glory[/color] is gained when you walk the path of Achra", "아크라의 길을 걸으면 [color=#ffff50]영광[/color]을 얻습니다"),
    ("When you achieve [color=#ff9020]Victory![/color], a new Cycle is unlocked", "[color=#ff9020]승리![/color]를 달성하면 새로운 순환이 해금됩니다"),
    ("Cycles beyond the first add faster powers and more volatile enemies for experienced players", "첫 번째 이후의 순환은 숙련된 플레이어를 위해 더 빠른 능력과 더 강력한 적을 추가합니다"),
    ("Each Cycle accelerates [color=#ffff50]Glory[/color] gain", "각 순환은 [color=#ffff50]영광[/color] 획득을 가속합니다"),
    ("slows when glory-level passes ", "영광 레벨이 "),
    ("and adds bonuses to [color=#ff8080]max Life gain[/color]", "을 넘으면 감소하며 [color=#ff8080]최대 체력 보너스[/color]가 추가됩니다"),
    ("on game start / raising vigor / strength", "게임 시작 / 활력 / 힘 상승 시"),
    ("Enemies receive [color=#af40af]Amplification[/color], providing random bonuses to", "적은 [color=#af40af]증폭[/color]을 받아 다음에 무작위 보너스를 얻습니다:"),
    ("and stacks of [color=#ffff50]applied effects[/color]", "그리고 [color=#ffff50]적용 효과[/color] 중첩"),
    ("You are in the ", "현재 순환: "),
    ("(Loaded)", "(불러옴)"),
    ("~victorious~", "~승리~"),
    # NOTE: " the " and " of " are too broad for global replacement.
    # They are handled specifically in the title format strings below.
    ("[/color] the ", "[/color]의 "),
    ("\" the \"", "\"의 \""),
    ("+ \" of \" +", "+ \" \" +"),

    # ── DeathScreen.gd ──
    ("[color=#ff3030] You die...[/color]", "[color=#ff3030] 당신은 죽었습니다...[/color]"),
    ("\"You won \"", "\"영광 \""),
    ("\" Glory\"", "\" 획득\""),
    ("[color=#ff9020]Victory![/color]", "[color=#ff9020]승리![/color]"),
    ("Praise ", "찬양하라 "),
    ("You enter the ", "다음 순환에 입장: "),
    ("A strange portal beckons, but a path has yet to be revealed...", "기이한 차원문이 부르지만, 아직 길이 드러나지 않았습니다..."),

    # ── ScoreScreen.gd ──
    ("[color=#ff3000]Victory![/color]", "[color=#ff3000]승리![/color]"),
    ("Killed by a ", "사인: "),
    ("[color=#ff5050]Abandoned the path...[/color]", "[color=#ff5050]길을 포기했습니다...[/color]"),
    # ScoreScreen "It was day X" and "In the Y cycle" — these are very specific lines
    # Don't use overly broad rules. Keep original for now.
    # ("It was day ", ""),  # too broad
    # ("[/color]\"", "일[/color]\""),  # EXTREMELY broad, breaks everything
    # ("In the ", ""),  # too broad
    ("[color=#707070]Equipped[/color]", "[color=#707070]장착[/color]"),
    ("[color=#707070]Learned[/color]", "[color=#707070]습득[/color]"),
    ("[color=#707070]Feats", "[color=#707070]업적"),

    # ── Feats.gd ──
    # Order matters: longer/specific matches BEFORE shorter/partial ones
    ("Yet to be achieved...", "아직 달성하지 못함..."),
    ("[color=#ff80ff]Achieved!", "[color=#ff80ff]달성!"),
    (" achieved...", " 달성..."),
    ("\"\\n\\nVictory with the \"", "\"\\n\\n\""),
    ("\" prestige class\"", "\" 상위 직업으로 승리\""),
    ("Lore impending...", "전승 준비 중..."),
    ("O glorious Achra...", "오 영광스러운 아크라여..."),
    ("Clear all prestige-related steam achievements", "모든 상위 직업 관련 Steam 업적 초기화"),

    # Score details - use longer context strings to avoid false matches
    ("game turns passed", "턴 경과"),
    ("[/color] attacks", "[/color]회 공격"),
    ("[/color] times", "[/color]회"),
    ("[/color] divine interventions", "[/color]회 신의 개입"),
    ("[/color] total damage", "[/color] 피해"),
    ("[/color] total healing", "[/color] 회복"),
    ("Applied [color=#ff5050]no effects[/color]", "[color=#ff5050]효과 없음[/color]"),
    (" enemies were killed by allies", "마리 적이 아군에 의해 처치됨"),

    # ── Graveyard.gd ──
    ("None have yet walked the path...", "아직 아무도 길을 걷지 않았습니다..."),
    ("O Pilgrim, recline in thy Glory...", "순례자여, 영광 속에 쉬어라..."),
    ("Has reached [color=#a08060]Dust[/color]", "[color=#a08060]먼지[/color]에 도달함"),
    ("Walk the [color=#a08060]Path of Dust[/color]...", "[color=#a08060]먼지의 길[/color]을 걸어라..."),
    ("O ancient dead...", "오 고대의 망자여..."),
    ("[color=#ff3000]Victorious![/color]", "[color=#ff3000]승리![/color]"),
    ("[color=#ffa000]Glory ", "[color=#ffa000]영광 "),

    # ── Bestiary.gd ──
    ("Visible enemies...", "보이는 적..."),
    ("Visible treasures...", "보이는 보물..."),
    # Bestiary tier descriptions
    ("...wanders the ", "...을 떠돌고 있다 "),
    ("...inhabits the ", "...에 서식한다 "),
    ("...rules the ", "...을 지배한다 "),
    ("[color=#00ff70]green tower[/color]", "[color=#00ff70]초록 탑[/color]"),
    ("[color=#00ff70]early[/color] lands", "[color=#00ff70]초반[/color] 땅"),
    ("[color=#8000af]violet tower[/color]", "[color=#8000af]보라 탑[/color]"),
    ("[color=#8000af]middle[/color] lands", "[color=#8000af]중반[/color] 땅"),
    ("[color=#ff5030]red tower[/color]", "[color=#ff5030]빨강 탑[/color]"),
    ("[color=#ff5030]late[/color] lands", "[color=#ff5030]후반[/color] 땅"),
    ("[color=#ff90a0]obelisk[/color]", "[color=#ff90a0]오벨리스크[/color]"),
    ("[color=#ff90a0]final[/color] lands", "[color=#ff90a0]최종[/color] 땅"),
    ("[color=#8030ff]astrolith[/color]", "[color=#8030ff]성석[/color]"),
    ("[color=#9000a0]void[/color]", "[color=#9000a0]공허[/color]"),
    ("[color=#ffff80]mind-warren[/color]", "[color=#ffff80]정신 미로[/color]"),
    ("[color=#ff2020]blood-void[/color]", "[color=#ff2020]혈공[/color]"),
    ("[color=#30af50]forbidden trod[/color]", "[color=#30af50]금단의 길[/color]"),
    ("[color=#5070ff]blue tower[/color]", "[color=#5070ff]파랑 탑[/color]"),
    ("[color=#ff00a0]astral swamps[/color]", "[color=#ff00a0]성계 늪[/color]"),
    ("[color=#B0E0E6]eaten star[/color]", "[color=#B0E0E6]삼켜진 별[/color]"),
    ("[color=#a070ff]summoned[/color]", "[color=#a070ff]소환[/color]"),
    ("found in the ", "에서 발견: "),
    ("+ cycle[/color]", "+ 순환[/color]"),
    # These are safe enough with the bbcode context
    (") + \" damage\"", ") + \" 피해\""),

    # ── UI_Inventory.gd ──
    ("\"Accuracy: \"", "\"명중률: \""),
    ("\"   Damage: \"", "\"   피해: \""),
    ("\"   Range: \"", "\"   사거리: \""),
    ("\"Bare fist\"", "\"맨주먹\""),
    ("[color=#ff9090]Attacks an area[/color]", "[color=#ff9090]범위 공격[/color]"),
    ("You fight [color=#ff4040]naked[/color]", "[color=#ff4040]맨몸[/color]으로 싸운다"),
    ("You wear:", "착용 중:"),
    ("\"Weight: \"", "\"무게: \""),
    ("\"   Inflexibility: \"", "\"   경직: \""),
    ("\"Armor: \"", "\"방어력: \""),
    ("\"   Block: \"", "\"   방어: \""),
    ("\"   Dodge: \"", "\"   회피: \""),
    ("\"   Speed: \"", "\"   속도: \""),
    ("[color=grey] the[/color]", "[color=grey]의[/color]"),

    # ── UI_Level_Up.gd ──
    ("Choose an attribute to increase...", "올릴 능력치를 선택하세요..."),
    ("*will raise minimum Speed", "*최소 속도가 상승합니다"),
    ("*min speed 'tied,' neither STR / DEX will raise it", "*최소 속도가 동률이라 힘/민첩 모두 올리지 않습니다"),
    ("Spd. ", "속도 "),
    ("Enc. ", "하중 "),
    ("You gain ", ""),
    # NOTE: STR/DEX/WIL are already translated to 힘/민첩/의지 by earlier rules,
    # so match the post-translation forms here.
    (" because [color=#ff7050]힘[/color] is your highest attribute", " [color=#ff7050]힘[/color]이 가장 높아 획득"),
    (" because [color=#50ff70]민첩[/color] is your highest attribute", " [color=#50ff70]민첩[/color]이 가장 높아 획득"),
    (" because [color=#c050ff]의지[/color] is your highest attribute", " [color=#c050ff]의지[/color]가 가장 높아 획득"),
    ("base [color=#20ff20]Speed[/color]", "기본 [color=#20ff20]속도[/color]"),
    # Post-translation fixup: rule 43 translates Speed→속도 before this rule matches
    ("base [color=#20ff20]속도[/color]", "기본 [color=#20ff20]속도[/color]"),

    # ── ToolMessageCreator.gd ──
    ("\"You use \"", "\"당신이 사용: \""),
    ("\" uses \"", "\"(이)가 사용: \""),
    ("Your damage is increased by ", "피해가 증가: "),
    ("damage increased ", "피해 증가: "),
    ("The damage is reduced by ", "피해가 감소: "),
    ("[color=#ff5050]Enemy[/color]", "[color=#ff5050]적[/color]"),
    ("[color=#50ff50]Ally[/color]", "[color=#50ff50]아군[/color]"),
    ("[color=#c050ff]familiar[/color]", "[color=#c050ff]사역마[/color]"),
    ("\"Main  \"", "\"주무장  \""),
    ("\"Acc \"", "\"명중률 \""),
    ("\"  Hit \"", "\"  명중 \""),
    ("\"  Two-Handing\"", "\"  양손 장착\""),
    ("\"  /  Off  Acc \"", "\"  /  보조  명중률 \""),
    ("\"Speed \"", "\"속도 \""),
    ("\"  Dodge \"", "\"  회피 \""),
    ("\"  Armor \"", "\"  방어력 \""),
    ("\"  Block \"", "\"  방어 \""),
    ("\"  Encumb. \"", "\"  하중 \""),
    ("\"  Inflex. \"", "\"  경직 \""),
    ("\"Range [color=#ffff50]\"", "\"사거리 [color=#ffff50]\""),
    ("This is the [color=#ffff50]Exit[/color]", "[color=#ffff50]출구[/color]입니다"),
    ("On the ground you see: ", "바닥에 보이는 것: "),
    ("[color=#589c84]Recite the[/color] ", "[color=#589c84]암송:[/color] "),
    ("requires Glory ", "영광 필요: "),
    (" Inventory, attributes, equip weapons and armor", " 인벤토리, 능력치, 무기 및 방어구 장착"),
    ("Press [color=#a0a0a0][[color=#ffff50]5[/color]] to swap Main hand and Off hand weapons", "[color=#a0a0a0][[color=#ffff50]5[/color]]를 눌러 주무장과 보조 무기를 교체"),
    ("does not count as an action, can also be performed in the inventory", "행동으로 치지 않으며, 인벤토리에서도 수행 가능"),
    (" Learn and level up new powers", " 새로운 능력을 배우고 레벨업"),
    (" Options menu, change settings", " 설정 메뉴"),
    (" Extended log of events", " 이벤트 로그 확장"),
    ("Your [color=#ff5050]vital essence[/color]...", "당신의 [color=#ff5050]생명력[/color]..."),
    ("[color=#ff3030]Death[/color] will be prevented by your deity through [color=#78bca4]divine intervention[/color]", "[color=#78bca4]신의 개입[/color]으로 [color=#ff3030]죽음[/color]을 막아줍니다"),
    ("at the cost of all the charges of a random [color=#78bca4]fully-charged prayer[/color]", "무작위 [color=#78bca4]완충된 기도[/color]의 모든 충전을 소모합니다"),
    ("gained from entering new areas and killing non-summoned enemies", "새 지역 진입과 비소환 적 처치로 획득"),
    ("to next 'game turn,' progresses relative to your Speed; turns [color=#50ff50]green[/color] if 'game turn' about to occur", "다음 '게임 턴'까지, 속도에 비례하여 진행; '게임 턴' 직전에 [color=#50ff50]초록[/color]으로 변함"),
    ("Toggles an attribute to [color=#ff9000]automatically select[/color] when your Glory rises", "영광이 오르면 [color=#ff9000]자동 선택[/color]할 능력치를 설정합니다"),
    ("Ally order, current: ", "아군 명령, 현재: "),
    ("move to [color=#ff5050]Attack[/color]", "[color=#ff5050]공격[/color]으로 이동"),
    ("[color=#ffff50]Hold[/color] position", "[color=#ffff50]위치[/color] 고수"),
    # SummonButton.gd — standalone Attack/Hold toggle labels
    ("\"[color=#ff5050]Attack[/color]\"", "\"[color=#ff5050]공격[/color]\""),
    ("\"[color=#ffff50]Hold[/color]\"", "\"[color=#ffff50]대기[/color]\""),

    # ── ToolMessageCreator.gd — summon info tooltip ──
    ("\"\\n\\nYou have [color=#b050b0]\"", "\"\\n\\n소환 아군: [color=#b050b0]\""),
    ("\", limited to [color=#707070]\"", "\", 한계: [color=#707070]\""),
    ("\"\\nYou have [color=#703080]\"", "\"\\n사역마: [color=#703080]\""),
    ("\", unlimited\"", "\", 무제한\""),
    (" summoned[/color] allies", " 소환된[/color] 아군"),
    ("(Willpower)[/color]", "(의지)[/color]"),
    (" summoned Familiars[/color], unlimited", " 소환된 사역마[/color], 무제한"),
    ("The current floor on the Path of Dust", "먼지의 길 현재 층"),
    ("Enemies gain [color=#af40af]Amplification[/color]", "적이 [color=#af40af]증폭[/color]을 획득"),
    ("Will only gain [color=#a0a000]death glory[/color] on floor >5", "5층 이상에서만 [color=#a0a000]사후 영광[/color]을 얻습니다"),
    ("\" switch lands\"", "\" 땅 전환\""),
    ("Attacks with ", "공격 속성: "),
    ("for detailed information", "상세 정보 보기"),
    ("for detailed trait information", "상세 특성 정보 보기"),
    ("\"Traits:\\n\"", "\"특성:\\n\""),
    (" you resist[/color] ", " 당신의 저항[/color] "),

    # ── Bestiary tier stat labels ──
    ("[/color] Life", "[/color] 체력"),
    ("[/color] Speed, ", "[/color] 속도, "),
    ("[/color] Accuracy", "[/color] 명중률"),
    ("[/color] Damage", "[/color] 피해"),
    ("[/color] Dodge", "[/color] 회피"),
    ("[/color] Block", "[/color] 방어"),
    ("[/color] Armor", "[/color] 방어력"),
    ("[/color] range", "[/color] 사거리"),

    # ── Weapon description labels ──
    ("\"\\nAccuracy: \"", "\"\\n명중률: \""),
    ("\"   Damage: \"", "\"   피해: \""),
    ("\"   Range: \"", "\"   사거리: \""),
    ("\" Range \"", "\" 사거리 \""),

    # ── Encumbrance / Weight ──
    ("\"Weight: \"", "\"무게: \""),
    ("\"Encumbrance[/color]\"", "\"하중[/color]\""),
    ("\"Weapon Size[/color]\"", "\"무기 크기[/color]\""),
    ("\"Inflexibility[/color][/color]\"", "\"경직[/color][/color]\""),
    ("\"Inflexibility[/color]\"", "\"경직[/color]\""),

    # ── ...in / found in (Armory item locations) ──
    ("\"...in \"", "\"...위치: \""),

    # ── UI_Popup.gd (tutorial) ──
    ("\"Your journey begins...\"", "\"여정이 시작됩니다...\""),
    ("\"Try pressing [[color=#c0c050]TAB[/color] / [color=#c0c050]right click[/color]] to perform auto-moves\\n\\n\"",
     "\"[color=#c0c050]TAB[/color] / [color=#c0c050]우클릭[/color]으로 자동 이동\\n\\n\""),
    ("\" lets you [color=#ffff50]acquire new powers[/color]\"",
     "\"에서 [color=#ffff50]새 능력 습득[/color] 가능\""),
    ("\"[color=#c0c0c0]A \"", "\"[color=#c0c0c0]\""),
    ("\" appears...\"", "\" 출현...\""),
    ("\"\\n\\nDrawn to your \"", "\"\\n\\n이끌려 온 대상: \""),
    ("\"O hungry ghost...\"", "\"오 아귀여...\""),

    # ── RouterEvents_OnMove.gd ──
    ("\"You take a step\"", "\"한 걸음 이동\""),

    # ── RouterEvents_GameTurn.gd ──
    ("\"A game turn passes...\"", "\"게임 턴 경과...\""),

    # ── Player.gd ──
    ("\"! Your Glory rises!\"", "\"! 영광이 오른다!\""),

    # ── Game.gd ──
    ("\"Vanquished!\"", "\"섬멸!\""),
    ("\"enemies defeated\"", "\"적 처치\""),
    ("\"The [color=#60af20]entangling vines[/color] begin to fall away...\"",
     "\"[color=#60af20]덩굴[/color]이 풀리기 시작한다...\""),
    ("\"The [color=#ff1010]bleeding[/color] begins to stop...\"",
     "\"[color=#ff1010]출혈[/color]이 멎기 시작한다...\""),

    # ── Continent.gd ──
    ("\"Day \"", "\"일차 \""),
    ("\"\\nShimmering [color=#9000a0]Void[/color]\"", "\"\\n일렁이는 [color=#9000a0]공허[/color]\""),
    ("\"\\nLand of [color=#ffff50]Achra[/color]\"", "\"\\n[color=#ffff50]아크라[/color]의 땅\""),
    ("\"You gaze upon \"", "\"바라보는 대상: \""),
    ("\"There is a vast and silent dark...\"", "\"광대하고 고요한 어둠이 있다...\""),
    ("\"[color=#ff5050]A forbidden place... \"", "\"[color=#ff5050]금단의 장소... \""),
    ("\"You walk the path...\"", "\"길을 걷는다...\""),
    ("\"The [color=#9000a0]shimmering darkness[/color] rises...\"",
     "\"[color=#9000a0]일렁이는 어둠[/color]이 밀려온다...\""),
    ("\"The [color=#0000ff]ocean[/color] rises...\"",
     "\"[color=#0000ff]바다[/color]가 밀려온다...\""),

    # ── RouterEvents_OnDamage.gd ──
    ("\"Deeply pierced!\"", "\"깊이 관통!\""),

    # ── ToolLevelUp.gd / Enemy.gd / Player.gd (rises! messages) ──
    # Remove "Your " before stat colors in level-up messages
    ("\"Your [color=#ff7050]", "\"[color=#ff7050]"),
    ("\"Your [color=#50ff70]", "\"[color=#50ff70]"),
    ("\"Your [color=#c050ff]", "\"[color=#c050ff]"),
    ("\"Your [color=#ff8080]", "\"[color=#ff8080]"),
    # "rises!" → "상승!"
    (" rises!", " 상승!"),
    # life → 체력
    ("+25 life", "+25 체력"),
    ("+75 life", "+75 체력"),

    # ── ToolMessageCreator.gd write_unit() — HUD stat bar ──
    # These match the ACTUAL patterns including color codes
    ("\"  Range [color=#ffff50]\"", "\"  사거리 [color=#ffff50]\""),
    ("\"Acc [color=#ffa050]\"", "\"명중률 [color=#ffa050]\""),
    ("\"  Hit [color=#ff8030]\"", "\"  명중 [color=#ff8030]\""),
    ("\"\\nSpeed [color=#20ff20]\"", "\"\\n속도 [color=#20ff20]\""),
    ("\"  Dodge [color=#50ffff]\"", "\"  회피 [color=#50ffff]\""),
    ("\"  Armor [color=#5050ff]\"", "\"  방어력 [color=#5050ff]\""),
    ("\"  Block [color=#5050ff]\"", "\"  방어 [color=#5050ff]\""),
    ("\"  Block [color=#5050ff]50% \"", "\"  방어 [color=#5050ff]50% \""),
    ("\"\\nMain  \"", "\"\\n주무장  \""),
    ("\"  /  Off  Acc [color=#ffa050]\"", "\"  /  보조  명중률 [color=#ffa050]\""),
    ("\"  Encumb. \"", "\"  하중 \""),
    ("\"  Inflex. \"", "\"  경직 \""),
    ("\"  Two-Handing\"", "\"  양손 장착\""),

    # ── ToolSpawnUnit.gd (summon messages) ──
    ("\"a \" + unit.get_name_color()", "unit.get_name_color()"),
    ("name_k = \"You\"", "name_k = \"\""),
    ("\" summon \"", "\" 소환: \""),
    ("\" summons \"", "\"(이)가 소환: \""),
    ("\"Summoning failed! Not enough Willpower...\"", "\"소환 실패! 의지력 부족...\""),
    ("\"Summoning failed, enemies vanquished...\"", "\"소환 실패, 적이 섬멸됨...\""),

    # ── RouterEvents_OnApplyBuff.gd (buff messages) ──
    ("\" apply \"", "\"(이)가 부여: \""),
    ("\" applies \"", "\"(이)가 부여: \""),
    ("\" to the \"", "\" → \""),
    ("\" to itself\"", "\" → 자신\""),
    ("\" to \"", "\" → \""),

    # ── Enemy.gd (attack message) ──
    ("\"Attack with \"", "\"공격: \""),

    # ── Enemy.gd (apply_bonus log: Familiar/Summoned display) ──
    # Replace all 3 occurrences of strip_bbcode(msg) with Korean label lookup
    ("textstrip.strip_bbcode(msg)", '({"Familiar": "사역마", "Summoned": "소환됨", "Initial": "최초", "Hit": "명중", "공격": "공격", "Being hit": "피격", "enemy Purges you": "적의 정화"}.get(textstrip.strip_bbcode(msg), textstrip.strip_bbcode(msg)))'),

    # ── Game.tscn Attack label ──

    # ── translate.gd — damage_type() display names ──
    ("[color=#af8f50]Pierce[/color]", "[color=#af8f50]관통[/color]"),
    ("[color=#af8f50]Slash[/color]", "[color=#af8f50]참격[/color]"),
    ("[color=#af8f50]Blunt[/color]", "[color=#af8f50]타격[/color]"),
    ("[color=#ff1010]Blood[/color]", "[color=#ff1010]혈[/color]"),
    ("[color=#ff7000]Fire[/color]", "[color=#ff7000]화염[/color]"),
    ("[color=#0060ff]Lightning[/color]", "[color=#0060ff]번개[/color]"),
    ("[color=#8030af]Astral[/color]", "[color=#8030af]성계[/color]"),
    ("[color=#70ff00]Poison[/color]", "[color=#70ff00]독[/color]"),
    ("[color=#ffaf30]Psychic[/color]", "[color=#ffaf30]정신[/color]"),
    ("[color=#a0a000]Death[/color]", "[color=#a0a000]죽음[/color]"),
    ("[color=#5080ff]Ice[/color]", "[color=#5080ff]냉기[/color]"),

    # ── translate.gd — element() display names (different colors) ──
    ("[color=#ff8000]Fire[/color]", "[color=#ff8000]화염[/color]"),
    ("[color=#00a000]Life[/color]", "[color=#00a000]생명[/color]"),
    ("[color=#af8f50]Martial[/color]", "[color=#af8f50]무술[/color]"),

    # ── translate.gd — element_to_resist_description() ──
    ("\"[color=#707070]Each point spent in \"", "\"[color=#707070]\""),
    ("\" grants you \"", "\"에 투자한 각 포인트당 \""),
    ("\" resistance\"", "\" 저항\""),
    ("\"[color=#af8f50]Pierce[/color], [color=#af8f50]Slash[/color] and [color=#af8f50]Blunt[/color] resistance\"",
     "\"[color=#af8f50]관통[/color], [color=#af8f50]참격[/color], [color=#af8f50]타격[/color] 저항\""),
    ("\"[color=#70ff00]Poison[/color], [color=#a0a000]Death[/color] and [color=#ff1010]Blood[/color] resistance\"",
     "\"[color=#70ff00]독[/color], [color=#a0a000]죽음[/color], [color=#ff1010]혈[/color] 저항\""),
    # Post-translation fixup: individual damage type rules + "and"->"+" run before combined rules
    ("[color=#af8f50]타격[/color] resistance", "[color=#af8f50]타격[/color] 저항"),
    ("[color=#ff1010]혈[/color] resistance", "[color=#ff1010]혈[/color] 저항"),

    # ── translate.gd — armor_position() display output only ──
    # IMPORTANT: "chest" and "head" are also used as code identifiers (item.position),
    # so only translate the display output lines (stringa +=), not the match arms.
    ('stringa += "chest"', 'stringa += "가슴"'),
    ('stringa += "head"', 'stringa += "머리"'),
    ("\"arms\"", "\"팔\""),
    ("\"legs\"", "\"다리\""),

    # ── translate.gd — misc ──
    ("\"[color=#707070]Counts as a '[color=#8040a0]Bare Fist[/color]'\"",
     "\"[color=#707070]'[color=#8040a0]맨주먹[/color]'으로 취급\""),
    ("\"[color=#ffff50]Bare fist[/color]\"", "\"[color=#ffff50]맨주먹[/color]\""),
    ("\"[color=#707070]effect:[/color]\\n\\n\"", "\"[color=#707070]효과:[/color]\\n\\n\""),
    ("\"[color=#ff9090]Attacks area[/color]\"", "\"[color=#ff9090]범위 공격[/color]\""),
    ("\" [color=#a0a0a0]if Two-Handing[/color]\"", "\" [color=#a0a0a0]양손 장착 시[/color]\""),
    ("\"[color=#707070]requires empty Off-hand[/color]\"", "\"[color=#707070]보조 손 비어야 함[/color]\""),
    ("\"[color=#a0a0a0]Gain +50% [color=#5050ff]Block chance[/color][/color] [color=#707070]unique[/color]\"",
     "\"[color=#a0a0a0]+50% [color=#5050ff]방어 확률[/color] 획득[/color] [color=#707070]고유[/color]\""),

    # ── Tile.gd — item pickup ──
    ("\"[color=#808080]You pick up a [/color]\"", "\"[color=#808080]획득: [/color]\""),
    ("\"Bag is full\"", "\"가방이 가득 참\""),

    # ── RouterEvents_OnRemoveBuff.gd ──
    ("\" [color=#c05050]remove[/color] \"", "\"(이)가 [color=#c05050]제거[/color]: \""),
    ("\" [color=#c05050]removes[/color] \"", "\"(이)가 [color=#c05050]제거[/color]: \""),
    ("\" from yourself\"", "\" (자신)\""),
    ("\" from itself\"", "\" (자신)\""),

    # ── UI_Log.gd ──
    ("\" game turns have passed\"", "\" 게임 턴 경과\""),
    ("\" highest damage dealt\"", "\" 최대 피해\""),

    # ══════════════════════════════════════════════════════
    # LRacesClasses.gd — Race descriptions (BEFORE name rules!)
    # ══════════════════════════════════════════════════════
    ("[color=#bf9f40]Humans[/color] [color=#c0c0c0]wander in from all corners of the world, seeking wealth or purification[/color]",
     "[color=#bf9f40]인간[/color] [color=#c0c0c0]세상 각지에서 부와 정화를 찾아 방황하며 들어온다[/color]"),
    ("[color=#309fbf]Elves[/color] [color=#c0c0c0]are immortal revelers, eager to display their acrobatic techniques[/color]",
     "[color=#309fbf]엘프[/color] [color=#c0c0c0]불멸의 환락가, 곡예의 기량을 뽐내길 열망한다[/color]"),
    ("[color=#609f30]Orcs[/color] [color=#c0c0c0]travel as emissaries of invasion, with boasts of unmatched strength[/color]",
     "[color=#609f30]오크[/color] [color=#c0c0c0]비할 데 없는 힘을 자랑하며, 침략의 사자로 여행한다[/color]"),
    ("[color=#a0a000]Undead[/color] [color=#c0c0c0]are cursed bodies, returned from their first death through incredible will[/color]",
     "[color=#a0a000]언데드[/color] [color=#c0c0c0]저주받은 육신, 놀라운 의지로 첫 번째 죽음에서 되돌아왔다[/color]"),
    ("[color=#df8f50]Beasts[/color] [color=#c0c0c0]are vigorous pilgrims from underground, led by instinct[/color]",
     "[color=#df8f50]야수[/color] [color=#c0c0c0]본능에 이끌려 지하에서 온 강건한 순례자들이다[/color]"),
    ("[color=#8030bf]Jinn[/color] [color=#c0c0c0]are swift, fragile beings of strange blood and smokeless fire[/color]",
     "[color=#8030bf]진[/color] [color=#c0c0c0]기이한 피와 연기 없는 불로 이루어진, 빠르고 연약한 존재[/color]"),

    # Race names (after descriptions)
    ("[color=#bf9f40]Human[/color]", "[color=#bf9f40]인간[/color]"),
    ("[color=#309fbf]Elf[/color]", "[color=#309fbf]엘프[/color]"),
    ("[color=#609f30]Orc[/color]", "[color=#609f30]오크[/color]"),
    ("[color=#a0a000]Undead[/color]", "[color=#a0a000]언데드[/color]"),
    ("[color=#df8f50]Beast[/color]", "[color=#df8f50]야수[/color]"),
    ("[color=#8030bf]Jinn[/color]", "[color=#8030bf]진[/color]"),

    # ══════════════════════════════════════════════════════
    # LClasses.gd — Class descriptions (BEFORE name rules!)
    # ══════════════════════════════════════════════════════
    ("[color=#c0c0c0]You come to the obelisk with well-rounded attributes, a tomahawk, and a bag of equipment[/color]",
     "[color=#c0c0c0]균형 잡힌 능력치와 토마호크, 장비 보따리를 들고 오벨리스크에 도착한다[/color]"),
    ("[color=#ff8000]Mobads[/color] [color=#c0c0c0]are priests of the fire temple, able to summon Azar's flame[/color]",
     "[color=#ff8000]모바드[/color] [color=#c0c0c0]화염 신전의 사제, 아자르의 불꽃을 소환할 수 있다[/color]"),
    ("[color=#ff3070]Jallaads[/color] [color=#c0c0c0]are pampered, arrogant executioners that wield a heavy ritual sword[/color]",
     "[color=#ff3070]잘라드[/color] [color=#c0c0c0]호사스럽고 오만한 처형인, 무거운 의식검을 휘두른다[/color]"),
    # Class names
    ("[color=#df4f4f]Survivor[/color]", "[color=#df4f4f]생존자[/color]"),
    ("[color=#ff8000]Mobad[/color]", "[color=#ff8000]모바드[/color]"),
    ("[color=#ff3070]Jallaad[/color]", "[color=#ff3070]잘라드[/color]"),

    # ══════════════════════════════════════════════════════
    # LEnemies.gd — Enemy descriptions (legacy hardcoded data)
    # NOTE: File contains literal \n (backslash-n), NOT actual newlines.
    #       Must use \\n in patterns to match literal \n in the source.
    # ══════════════════════════════════════════════════════
    ("[color=#c0c040]Rat-man Archer[/color][color=#c0c0c0]\\n\\nA humanoid rodent that lives in swarming colonies, feeding off the world's detritus. Wields a crude bow & arrow.[/color]",
     "[color=#c0c040]쥐인간 궁수[/color][color=#c0c0c0]\\n\\n떼지어 사는 인간형 설치류로, 세상의 찌꺼기를 먹고 산다. 조잡한 활과 화살을 든다.[/color]"),
    ("[color=#c0c040]Rat-man[/color][color=#c0c0c0]\\n\\nA humanoid rodent that lives in swarming colonies, feeding off the world's detritus. Wields a curved knife.[/color]",
     "[color=#c0c040]쥐인간[/color][color=#c0c0c0]\\n\\n떼지어 사는 인간형 설치류로, 세상의 찌꺼기를 먹고 산다. 굽은 칼을 든다.[/color]"),
    ("[color=#ffa050]Bugbear[/color][color=#c0c0c0]\\n\\nA humanoid brute and child-eater. Wields a heavy club.[/color]",
     "[color=#ffa050]버그베어[/color][color=#c0c0c0]\\n\\n아이를 잡아먹는 인간형 야수. 무거운 곤봉을 든다.[/color]"),
    # Note: "Attacks with" already replaced to "공격 속성:" by earlier rule, so match the post-replacement text
    ("[color=#af4040]Boga[/color][color=#c0c0c0]\\n\\nA writhing, clay-colored serpent of the deep world. 공격 속성: its hardened muzzle.[/color]",
     "[color=#af4040]보가[/color][color=#c0c0c0]\\n\\n꿈틀거리는 점토빛 심연의 뱀. 경화된 주둥이로 공격한다.[/color]"),
    ("[color=#ff7000]Firedrake[/color][color=#c0c0c0]\\n\\nAn enormous, slithering beast of the vast underground lava flats. Spits fire.[/color]",
     "[color=#ff7000]파이어드레이크[/color][color=#c0c0c0]\\n\\n광대한 지하 용암지대의 거대한 기어다니는 야수. 불을 뿜는다.[/color]"),

    # ══════════════════════════════════════════════════════
    # LAllies.gd — Ally descriptions
    # ══════════════════════════════════════════════════════
    ("[color=#20af20]Gorseling[/color][color=#c0c0c0]\\n\\nAn arcane servant conjured from plants. Lashes out with vines.[/color]",
     "[color=#20af20]가시덩굴[/color][color=#c0c0c0]\\n\\n식물로부터 불러낸 비전 하인. 덩굴로 후려친다.[/color]"),
    ("[color=#a0a000]Skeleton[/color][color=#c0c0c0]\\n\\nA reanimated warrior, bound to its master.[/color]",
     "[color=#a0a000]스켈레톤[/color][color=#c0c0c0]\\n\\n되살아난 전사, 주인에게 묶여 있다.[/color]"),

    # ══════════════════════════════════════════════════════
    # ToolPretaMaker.gd — Preta description and taunt
    # ══════════════════════════════════════════════════════
    ("A [color=#af40af]Preta[/color] of chaotic form, a hungry ghost from the land of dust...",
     "혼돈의 형상을 한 [color=#af40af]아귀[/color], 먼지의 땅에서 온 굶주린 망령..."),
    ("\"The \" + name_colored + \" rips you from existence...\"",
     "name_colored + \"(이)가 너를 존재에서 찢어낸다...\""),

    # ══════════════════════════════════════════════════════
    # First_Menu.gd — Data management popup messages
    # ══════════════════════════════════════════════════════
    ("\"SAVED CHARACTER ERASED\"", "\"저장된 캐릭터 삭제됨\""),
    ("\"ALL DATA ERASED\"", "\"모든 데이터 삭제됨\""),

    # ── UI.gd / UI_Log.gd — character title format ──
    # "X the Y of Z" → "Z의 Y X" (Korean word order)
    ("[/color][color=#c0c0c0] the[/color] ", "[/color] "),
    (" [color=#c0c0c0]of[/color] ", " [color=#c0c0c0]-[/color] "),
    ("\" the \" + data.title_race", "\" \" + data.title_race"),
    # Post-translation fixup: rule 193 translates " the " → "의 " before this rule matches
    ("\"의 \" + data.title_race", "\" \" + data.title_race"),
    ("\" of \" + data.title_god", "\" - \" + data.title_god"),

    # ── UI_Enemies.gd (enemy info popup) ──
    ("\"[color=#c0c0c0]Attacks with \"", "\"[color=#c0c0c0]공격 속성: \""),
    ("\" damage\"", "\" 피해\""),
    ("\" at [color=#ffff50]\"", "\" [color=#ffff50]\""),
    ("\" range[/color]\"", "\" 사거리[/color]\""),
    ("\" in [color=#ffff50]melee[/color]\"", "\" [color=#ffff50]근접[/color]\""),
    ("\"\\n\\nHas a \"", "\"\\n\\n\""),
    ("\" chance to [color=#9010cf]recover[/color] from harmful effects on game turn\"",
     "\" 확률로 게임 턴에 해로운 효과에서 [color=#9010cf]회복[/color]\""),
    ("\"Resist \"", "\"저항 \""),

    # ── search placeholder (must match TSCN translation "검색...") ──
    ("\"search...\"", "\"검색...\""),

    # ══════════════════════════════════════════════════════
    # Round 2: Additional untranslated strings
    # ══════════════════════════════════════════════════════

    # ── AbilityBook.gd — Cost label ──
    ("\"\\n\\nCost [color=#ffff50]\"", "\"\\n\\n비용 [color=#ffff50]\""),

    # ── Continent.gd — Day label ──
    ("[right][color=#c0c0c0]Day ", "[right][color=#c0c0c0]일차 "),

    # ── Bestiary.gd — speed min label ──
    ("+ \" min\"", "+ \" 최소\""),

    # ── ButtonAutoLevel.gd — VIG/Rand abbreviations ──
    ("[color=#ff8080]VIG[/color]\"", "[color=#ff8080]활력[/color]\""),
    ("[color=#ff2090]Rand[/color]\"", "[color=#ff2090]무작위[/color]\""),

    # ── Feats.gd — English explanatory text for Steam achievement reset ──
    ("\"\\n\\n[color=#707070]Achievements for prestige classes were recently changed on 1/10/24 to require victory, and their wording on steam was also changed (from just having to unlock them)\"",
     "\"\\n\\n[color=#707070]상위 직업 업적이 2024/1/10에 승리 필수로 변경되었으며, Steam 문구도 변경됨 (해금만으로는 불충분)\""),
    ("\"\\n\\nIf you'd like to re-earn them on steam, this should [color=#a00000]clear all the achievements for prestige classes[/color] that you HAVEN'T since won with\"",
     "\"\\n\\n Steam에서 다시 달성하려면 이 버튼으로 [color=#a00000]아직 승리하지 못한 상위 직업의 모든 업적을 초기화[/color]할 수 있습니다\""),
    ("\" after Version 0.9.4.6  'Feats'\"", "\" (버전 0.9.4.6 '업적' 이후)\""),

    # ── ScoreScreen.gd — stat detail lines ──
    ("\"Performed [color=#ffff00]\"", "\"[color=#ffff00]\""),
    ("\"[/color]회 공격\"", "\"[/color]회 공격 수행\""),
    ("\"Stood still [color=#ffff00]\"", "\"제자리 대기 [color=#ffff00]\""),
    ("\"Prayed [color=#ffff00]\"", "\"기도 [color=#ffff00]\""),
    ("\"Received [color=#ffff00]\" + translate.add_commas(str(data.times_intervention)) + \"[/color]회 신의 개입\"",
     "\"신의 개입 [color=#ffff00]\" + translate.add_commas(str(data.times_intervention)) + \"[/color]회\""),
    ("\"Dealt [color=#ffff00]\"", "\"피해 [color=#ffff00]\""),
    ("\"Highest damage was [color=#ffff00]\"", "\"최대 피해 [color=#ffff00]\""),
    ("\"Took [color=#ffff00]\"", "\"받은 피해 [color=#ffff00]\""),
    ("\"Received [color=#ffff00]\" + translate.add_commas(str(data.amount_healed)) + \"[/color] 회복\"",
     "\"회복량 [color=#ffff00]\" + translate.add_commas(str(data.amount_healed)) + \"[/color]\""),
    ("\"Highest applied effect [color=#ffff00]\"", "\"최고 적용 효과 [color=#ffff00]\""),
    ("\"Killed [color=#ffff00]\" + translate.add_commas(str(data.enemies_killed)) + \"[/color] enemies\"",
     "\"적 처치 [color=#ffff00]\" + translate.add_commas(str(data.enemies_killed)) + \"[/color]\""),
    ("\"Summoned [color=#ffff00]\" + translate.add_commas(str(data.allies_summoned)) + \"[/color] allies\"",
     "\"아군 소환 [color=#ffff00]\" + translate.add_commas(str(data.allies_summoned)) + \"[/color]\""),
    ("\"Killed [color=#ffff00]\" + translate.add_commas(str(data.allies_killed)) + \"[/color] allies\"",
     "\"아군 사망 [color=#ffff00]\" + translate.add_commas(str(data.allies_killed)) + \"[/color]\""),

    # ── RouterEvents_OnDeath.gd — kill messages ──
    ("name_k + \" kill \" + name_d + \"!\"", "name_k + \"(이)가 \" + name_d + \"을(를) 처치!\""),
    ("name_k + \" kills \" + name_d + \"!\"", "name_k + \"(이)가 \" + name_d + \"을(를) 처치!\""),

    # ── RouterEvents_OnDeath.gd — performs stand still ──
    ("\" performs 'stand still' actions...\"", "\"(이)가 '제자리 대기' 행동 수행...\""),

    # ── RouterEvents_GameTurn.gd — recovers from ──
    ("\" [color=#9010cf]recovers[/color] from \"", "\"(이)가 [color=#9010cf]회복[/color]: \""),

    # ── RouterEvents_OnIntervention.gd — remain ──
    ("\" remain[/color]\"", "\" 남음[/color]\""),
    ("\"찬양하라 [color=#ff9000]Phoenix[/color]! Your [color=#c050ff]의지[/color] 상승!\"",
     "\"찬양하라 [color=#ff9000]Phoenix[/color]! [color=#c050ff]의지[/color] 상승!\""),

    # ── RouterEvents_OnDamage.gd — damage log labels ──
    ("\"Inflexibility -\"", "\"경직 -\""),
    ("\"Resistance -\"", "\"저항 -\""),
    ("\"Negative Resistance +\"", "\"역저항 +\""),
    ("\"Dread Axe ignores resistance\"", "\"공포의 도끼: 저항 무시\""),
    ("\"Protection -\"", "\"보호 -\""),
    ("\" [color=#af2020]Critical![/color] +\"", "\" [color=#af2020]치명타![/color] +\""),
    ("\"Cut open!\"", "\"베어 가르다!\""),
    ("\" (self damage)\"", "\" (자해 피해)\""),

    # ── RouterEvents_OnEnterLevel.gd / OnLearn.gd — life in messages ──
    ("+ \" life[/color]\"", "+ \" 체력[/color]\""),
    # +N life patterns (hardcoded values: +25, +50)
    ("+25 life[/color]", "+25 체력[/color]"),
    ("+50 life[/color]", "+50 체력[/color]"),

    # ── RouterEvents_OnEnterLevel.gd — Apophis "Your" removal ──
    ("! Your [color=#ff7050]", "! [color=#ff7050]"),

    # ── RouterEvents_OnLearn.gd — Anroth message ──
    ("\"The spirit of Anroth surges through you![/color]\"",
     "\"Anroth의 정기가 온몸에 퍼진다![/color]\""),

    # ── RouterEvents_OnLevelUp.gd / OnInvoke.gd — weapon upgrade messages ──
    ("\"You upgrade your \" + stringa + \" [color=#ff8030]+20 Hit[/color]\"",
     "\"무기 강화: \" + stringa + \" [color=#ff8030]+20 명중[/color]\""),
    ("\"You upgrade your \" + stringa + \" [color=#ff8030]+100 Hit[/color] / [color=#5050ff]+100 Block[/color]\"",
     "\"무기 강화: \" + stringa + \" [color=#ff8030]+100 명중[/color] / [color=#5050ff]+100 방어[/color]\""),
    ("\" [color=#707070]to \" + str(item.dmg * 10) + \" Hit / \" + str(item.arm) + \" Block[/color]\"",
     "\" [color=#707070]→ \" + str(item.dmg * 10) + \" 명중 / \" + str(item.arm) + \" 방어[/color]\""),
    ("\" [color=#707070]to \" + str(item.dmg * 10)", "\" [color=#707070]→ \" + str(item.dmg * 10)"),
    ("\" <- Bheith Nochti\"", "\" ← Bheith Nochti\""),

    # ── RouterEvents_OnMove.gd — performs game turn actions ──
    ("\" performs your 'game turn' actions...\"", "\"(이)가 '게임 턴' 행동 수행...\""),

    # ── RouterEvents_OnPickup.gd — item transformation rumor texts ──
    ("\" transformed by Mordok...\"", "\" Mordok에 의해 변형...\""),
    ("\" transformed by Dumuzi...\"", "\" Dumuzi에 의해 변형...\""),
    ("\" reforged by Vyranism...\"", "\" Vyranism에 의해 재련...\""),
    ("\" transformed by Pallas...\"", "\" Pallas에 의해 변형...\""),
    ("\" transformed by your Sublime Body...\"", "\" 숭고한 육체에 의해 변형...\""),
    ("\" transformed by Oros...\"", "\" Oros에 의해 변형...\""),
    ("\" reforged by [color=#c03090]Viryanism[/color]...\"", "\" [color=#c03090]Viryanism[/color]에 의해 재련...\""),

    # ── RouterEvents_OnApplyBuff.gd — buff log messages ──
    ("\" stacks inherited from \"", "\" 스택 계승: \""),
    ("\" (set to max \"", "\" (최대 \""),
    ("\"Amplification +\"", "\"증폭 +\""),

    # ── ScoreScreen.gd — place suffix line (already partially translated) ──
    # data.place_suffix + " " + data.place is dynamic — leave as is

    # ══════════════════════════════════════════════════════
    # Round 3: Multi-angle review — consistency & completeness
    # ══════════════════════════════════════════════════════

    # ── UI_Inv.gd — trait organize category labels ──
    ("[color=#808080]Culture[/color]", "[color=#808080]문화[/color]"),
    ("[color=#808080]Class[/color]", "[color=#808080]직업[/color]"),
    ("[color=#808080]Religion[/color]", "[color=#808080]신앙[/color]"),
    ("[color=#808080]Prestige class[/color]", "[color=#808080]상위 직업[/color]"),
    ("[color=#808080]Item[/color]", "[color=#808080]아이템[/color]"),
    ("[color=#808080]Level [/color]", "[color=#808080]레벨 [/color]"),
    ("[color=#808080] element[/color]", "[color=#808080] 원소[/color]"),
    ("[color=#c07070]*Redundant[/color]", "[color=#c07070]*중복[/color]"),
    ("[center][color=#a0a0a0]Empty", "[center][color=#a0a0a0]비어 있음"),

    # ── UI_Inv.gd — buff Effect label (808080 color variant) ──
    ("[color=#808080]Effect[/color]", "[color=#808080]효과[/color]"),

    # ── UI_Inv.gd — sacrifice stat bonus display (preview & applied) ──
    ("+ str(acc_amount * 10) + \" Accuracy\"", "+ str(acc_amount * 10) + \" 명중률\""),
    ("+ str(hit_amount * 10) + \" Hit\"", "+ str(hit_amount * 10) + \" 명중\""),
    ("+ str(block_amount) + \" Block\"", "+ str(block_amount) + \" 방어\""),
    ("+ str(arm_amount) + \" Armor\"", "+ str(arm_amount) + \" 방어력\""),
    ("+ str(acc_amount * 10) + \" Acc\"", "+ str(acc_amount * 10) + \" 명중률\""),
    ("+ str(hit_amount * 10) + \" Hit\"", "+ str(hit_amount * 10) + \" 명중\""),
    ("+ str(block_amount) + \" Block\"", "+ str(block_amount) + \" 방어\""),
    ("+ str(arm_amount) + \" Armor\"", "+ str(arm_amount) + \" 방어력\""),
    ("[color=#ff8080]+20 max Life[/color]", "[color=#ff8080]+20 최대 체력[/color]"),
    ("[color=#ff8080]+20 max Life", "[color=#ff8080]+20 최대 체력"),
    ("[color=#ff8080]+25 max Life[/color]", "[color=#ff8080]+25 최대 체력[/color]"),
    ("[color=#90ff50]Goblin's Way[/color]:", "[color=#90ff50]고블린의 길[/color]:"),
    ("[color=#90ff50]Goblin's Way![/color]", "[color=#90ff50]고블린의 길![/color]"),
    ("[color=#707070]base[/color]", "[color=#707070]기본[/color]"),
    ("[color=#fff0a0]Eris[/color] transfers 100% of item attributes",
     "[color=#fff0a0]에리스[/color]가 아이템 속성 100% 전달"),
    ("Bonuses equal 25% of sacrificed item", "보너스는 제물 아이템의 25%"),
    ("No corresponding item equipped", "대응하는 장착 아이템 없음"),
    ("\" gain\"", "\" 획득\""),

    # ── ToolMessageCreator.gd — Glory label in HUD tooltip (ffff50 color) ──
    ("[color=#ffff50]Glory ", "[color=#ffff50]영광 "),

    # ── ToolMessageCreator.gd — bestiary Traits header (embedded in larger string) ──
    ("[color=#808080]Traits:\\n", "[color=#808080]특성:\\n"),

    # ── ToolMessageCreator.gd — bestiary Hit stat label (line 461 context) ──
    ("\"[/color] Hit\"", "\"[/color] 명중\""),

    # ── Start_Menu.gd — requires Off-hand (without [/color] closing) ──
    ("\"\\n[color=#707070]requires empty Off-hand\"", "\"\\n[color=#707070]보조손 비어야 함\""),

    # ══════════════════════════════════════════════════════
    # Round 4: Remaining display-facing strings
    # ══════════════════════════════════════════════════════

    # ── ToolPrestigeGiver.gd — prestige class requirements ──
    ("\"[color=#a0a0a0]Requires \"", "\"[color=#a0a0a0]필요조건: \""),
    ("\"20 [color=#ffff50]Glory[/color] with [color=#ff5050]no powers[/color]\"",
     "\"[color=#ff5050]능력 없이[/color] [color=#ffff50]영광[/color] 20\""),
    ("\"20 [color=#ffff50]Glory[/color] while in the Land of Achra\"",
     "\"아크라의 땅에서 [color=#ffff50]영광[/color] 20\""),
    ("\"20 [color=#ffff50]Glory[/color]\"", "\"[color=#ffff50]영광[/color] 20\""),
    ("\"10 points in any [color=#ffff50]transformation[/color]\"",
     "\"아무 [color=#ffff50]변신[/color]에 10 포인트\""),
    ("\"20 points in any [color=#ff5050]harmful[/color] [color=#ffff50]master[/color]\"",
     "\"아무 [color=#ff5050]유해[/color] [color=#ffff50]마스터[/color]에 20 포인트\""),
    ("\"20 points in any [color=#ffff50]beast familiar[/color]\"",
     "\"아무 [color=#ffff50]야수 사역마[/color]에 20 포인트\""),
    ("\"20 points in any [color=#ffff50]kinesis[/color]\"",
     "\"아무 [color=#ffff50]키네시스[/color]에 20 포인트\""),
    ("\"20 points in any [color=#a030b0]teleportation[/color]\"",
     "\"아무 [color=#a030b0]순간이동[/color]에 20 포인트\""),

    # ── ToolLevelUp.gd — Vigor and Robe of Vigor messages ──
    ("\"[color=#ff8080]Vigor[/color] 상승! [color=#707070]+75 체력[/color]\"",
     "\"[color=#ff8080]활력[/color] 상승! [color=#707070]+75 체력[/color]\""),
    ("\"[color=#30ff30]Robe of Vigor[/color] grants [color=#707070]+50 체력[/color]\"",
     "\"[color=#30ff30]활력의 로브[/color] 부여: [color=#707070]+50 체력[/color]\""),

    # ── ToolMagicMaker.gd — buff duration messages ──
    ("\"Your \" + buff.color + buff.name + \"[/color] is reduced by \"",
     "buff.color + buff.name + \"[/color](이)가 \" + \"감소: \""),
    ("\"Your \" + buff.color + buff.name + \"[/color] is increased by \"",
     "buff.color + buff.name + \"[/color](이)가 \" + \"증가: \""),

    # ── ToolMessageCreator.gd — click labels ──
    ("[[color=#ffff50]click[/color]]", "[[color=#ffff50]클릭[/color]]"),

    # ── ToolInvokes.gd — Pallas upgrade message ──
    ("\"[color=#ff7070]Pallas[/color] upgrades your \" + stringa + \" [color=#ff8030]+30 Hit[/color] / [color=#5050ff]+30 Block[/color]\"",
     "\"[color=#ff7070]Pallas[/color] 무기 강화: \" + stringa + \" [color=#ff8030]+30 명중[/color] / [color=#5050ff]+30 방어[/color]\""),
    ("\" Hit / \" + str(item.arm) + \" Block <- Tekton[/color]\"",
     "\" 명중 / \" + str(item.arm) + \" 방어 ← Tekton[/color]\""),

    # ── ToolInvokes.gd — Takhal message ──
    ("\"O mighty [color=#80af00]Takhal[/color]! [color=#707070]+20 life[/color]\"",
     "\"오 강대한 [color=#80af00]Takhal[/color]! [color=#707070]+20 체력[/color]\""),

    # ── RouterEvents_OnRemoveBuff.gd — player self-remove ──
    ("\"You [color=#c05050]remove[/color] \" + buff.color + buff.name + \"[/color] from yourself\"",
     "\"[color=#c05050]제거[/color]: \" + buff.color + buff.name + \"[/color] (자신)\""),
    ("\"[/color] from itself\"", "\"[/color] (자신)\""),

    # ── RouterEvents_OnDeath.gd — Eris/Struggler item upgrade ──
    ("\"[color=#fff0a0]Struggler! Eris[/color] upgrades your \"",
     "\"[color=#fff0a0]투사! Eris[/color] 무기 강화: \""),

    # ── RouterEvents_OnDamage.gd — Struggler endures ──
    ("\"Struggler [color=#ff7030]endures[/color] -\"", "\"투사 [color=#ff7030]인내[/color] -\""),

    # ── Player.gd — debug/error string ──
    ("\"[color=#ff0000]mistake[/color]\"", "\"[color=#ff0000]오류[/color]\""),

    # ══════════════════════════════════════════════════════
    # Round 5 (2차 감수): Remaining English pronouns in combat messages
    # ══════════════════════════════════════════════════════

    # ── Process_Fight.gd — guard_break_message: "You" as subject ──
    # name_a = "You" → empty string (Korean drops subject in "X(이)가 Y의 방어를 돌파!")
    ("func guard_break_message(attacker, defender, label):\n\tvar name_a = attacker.get_name_color()\n\tif attacker == Global.Player:\n\t\tname_a = \"You\"",
     "func guard_break_message(attacker, defender, label):\n\tvar name_a = attacker.get_name_color()\n\tif attacker == Global.Player:\n\t\tname_a = \"\""),
    # name_d = "You" fallback (self-attack edge case)
    ("func guard_break_message(attacker, defender, label):\n\tvar name_a = attacker.get_name_color()\n\tif attacker == Global.Player:\n\t\tname_a = \"\"\n\tvar name_d = defender.get_name_color()\n\tif defender == Global.Player:\n\t\tname_d = \"You\"",
     "func guard_break_message(attacker, defender, label):\n\tvar name_a = attacker.get_name_color()\n\tif attacker == Global.Player:\n\t\tname_a = \"\"\n\tvar name_d = defender.get_name_color()\n\tif defender == Global.Player:\n\t\tname_d = \"당신\""),
    # name_d = "your" → "당신의" in guard_break defender branches
    ("name_d = \"your\"\n\t\t\tToolMessageCreator.add_message(txcolor, \"\" + name_a + \"(이)가 \" + name_d + \" 방어를 돌파!\")",
     "name_d = \"당신의\"\n\t\t\tToolMessageCreator.add_message(txcolor, \"\" + name_a + \"(이)가 \" + name_d + \" 방어를 돌파!\")"),
    ("name_d = \"your\"\n\t\t\tToolMessageCreator.add_message(txcolor, \"\" + name_a + \"(이)가 \" + name_d + \" 방어구를 관통!\")",
     "name_d = \"당신의\"\n\t\t\tToolMessageCreator.add_message(txcolor, \"\" + name_a + \"(이)가 \" + name_d + \" 방어구를 관통!\")"),
    ("name_d = \"your\"\n\t\t\tToolMessageCreator.add_message(txcolor, \"\" + name_a + \"(이)가 \" + name_d + \" 회피를 간파!\")",
     "name_d = \"당신의\"\n\t\t\tToolMessageCreator.add_message(txcolor, \"\" + name_a + \"(이)가 \" + name_d + \" 회피를 간파!\")"),

    # ── Process_Fight.gd — combat_message: "You" as subject/object ──
    ("func combat_message(attacker, defender, _hit):\n\t\n\tvar name_a = attacker.get_name_color()\n\tif attacker == Global.Player:\n\t\tname_a = \"You\"\n\tvar name_d = defender.get_name_color()\n\tif defender == Global.Player:\n\t\tname_d = \"You\"",
     "func combat_message(attacker, defender, _hit):\n\t\n\tvar name_a = attacker.get_name_color()\n\tif attacker == Global.Player:\n\t\tname_a = \"\"\n\tvar name_d = defender.get_name_color()\n\tif defender == Global.Player:\n\t\tname_d = \"당신\""),
    # name_a = "your" → "당신의" in combat_message attacker branches
    ("name_a = \"your\"\n\t\t\tToolMessageCreator.add_message(txcolor, \"\" + name_d + \"(이)가 \" + name_a + \" 공격을 회피\")",
     "name_a = \"당신의\"\n\t\t\tToolMessageCreator.add_message(txcolor, \"\" + name_d + \"(이)가 \" + name_a + \" 공격을 회피\")"),
    ("name_a = \"your\"\n\t\t\tToolMessageCreator.add_message(txcolor, \"\" + name_d + \"(이)가 \" + name_a + \" 공격을 방어\")",
     "name_a = \"당신의\"\n\t\t\tToolMessageCreator.add_message(txcolor, \"\" + name_d + \"(이)가 \" + name_a + \" 공격을 방어\")"),
    ("name_a = \"your\"\n\t\t\tToolMessageCreator.add_message(txcolor, \"\" + name_d + \"(이)가 \" + name_a + \" 공격을 상쇄\")",
     "name_a = \"당신의\"\n\t\t\tToolMessageCreator.add_message(txcolor, \"\" + name_d + \"(이)가 \" + name_a + \" 공격을 상쇄\")"),

    # ── RouterEvents_OnApplyBuff.gd — "You" / "yourself" / "you" ──
    ("name_a = \"You\"\n\t\tname_d = \"yourself\"\n\t\tstringa = name_a + \"(이)가 부여: \"",
     "name_a = \"\"\n\t\tname_d = \"자신\"\n\t\tstringa = name_a + \"부여: \""),
    ("elif caster == Global.Player:\n\t\tname_a = \"You\"\n\t\tstringa = name_a + \"(이)가 부여: \"",
     "elif caster == Global.Player:\n\t\tname_a = \"\"\n\t\tstringa = name_a + \"부여: \""),
    ("elif target == Global.Player:\n\t\tname_d = \"you\"\n\t\tstringa = \"\" + name_a + \"(이)가 부여: \"",
     "elif target == Global.Player:\n\t\tname_d = \"당신\"\n\t\tstringa = \"\" + name_a + \"(이)가 부여: \""),

    # ── RouterEvents_OnAttack.gd — hit message: "you" as defender ──
    # English SVO: "[enemy] [damage]s you" → Korean SOV: "[enemy](이)가 당신을 [damage]"
    ("name_d = \"you\"\n\t\tstringa = \"\" + name_a + \" \" + damage_text + \"[color=#ffa050]s[/color] \" + name_d + \" \"",
     "name_d = \"당신\"\n\t\tstringa = \"\" + name_a + \"(이)가 \" + name_d + \"을(를) \" + damage_text + \" \""),

    # ── RouterEvents_OnDamage.gd — damage message: "you" as defender ──
    ("name_d = \"you\"\n\t\tstringa = \"\" + name_a + \" \" + damage_text + \" \" + name_d + \" \"",
     "name_d = \"당신\"\n\t\tstringa = \"\" + name_a + \"(이)가 \" + name_d + \"을(를) \" + damage_text + \" \""),

    # ── RouterEvents_OnDeath.gd — kill messages: "yourself" / "you" ──
    ("name_d = \"yourself\"\n\t\tToolMessageCreator.add_message(txtcolor, name_k + \"(이)가 \" + name_d + \"을(를) 처치!\")",
     "name_d = \"자신\"\n\t\tToolMessageCreator.add_message(txtcolor, name_k + \"(이)가 \" + name_d + \"을(를) 처치!\")"),
    ("name_d = \"you\"\n\t\tToolMessageCreator.add_message(txtcolor, name_k + \"(이)가 \" + name_d + \"을(를) 처치!\")",
     "name_d = \"당신\"\n\t\tToolMessageCreator.add_message(txtcolor, name_k + \"(이)가 \" + name_d + \"을(를) 처치!\")"),

    # ── ToolMagicMaker.gd — magic damage messages ──
    # Player casts: "You harm 의 [enemy]" → "[enemy]에게 [damage] (N)"
    ("name_a = \"You\"\n\t\tToolMessageCreator.add_message(txcolor, name_a + \" \" + damage_text + \" \" + \"의 \" + name_d + \" (\" + str(int(damage)) + \").\")",
     "name_a = \"\"\n\t\tToolMessageCreator.add_message(txcolor, name_d + \"에게 \" + damage_text + \" (\" + str(int(damage)) + \").\")"),
    # Enemy casts on player: "The [enemy] burns you" → "[enemy](이)가 당신에게 [damage] (N)"
    ("name_d = \"you\"\n\t\tToolMessageCreator.add_message(txcolor, \"The \" + name_a + \" \" + damage_text + \"s \" + name_d + \" (\" + str(int(damage)) + \").\")",
     "name_d = \"당신\"\n\t\tToolMessageCreator.add_message(txcolor, name_a + \"(이)가 \" + name_d + \"에게 \" + damage_text + \" (\" + str(int(damage)) + \").\")"),
    # Enemy casts on other: "The [A] burns 의 [B]" → "[A](이)가 [B]에게 [damage] (N)"
    ("ToolMessageCreator.add_message(txcolor, \"The \" + name_a + \" \" + damage_text + \"s\" + \"의 \" + name_d + \" (\" + str(int(damage)) + \").\")",
     "ToolMessageCreator.add_message(txcolor, name_a + \"(이)가 \" + name_d + \"에게 \" + damage_text + \" (\" + str(int(damage)) + \").\")"),

    # ── RouterEvents_OnAttack.gd — "itself" in self-attack ──
    ("stringa = \"[color=#707070]\" + name_a + \" \" + damage_text + \"[color=#ffa050]s[/color] itself \"",
     "stringa = \"[color=#707070]\" + name_a + \"(이)가 자신을 \" + damage_text + \" \""),
    # ── RouterEvents_OnDamage.gd — "itself" in self-damage ──
    ("stringa = \"[color=#707070]\" + name_a + \" \" + damage_text + \" itself \"",
     "stringa = \"[color=#707070]\" + name_a + \"(이)가 자신을 \" + damage_text + \" \""),

    # ── RouterEvents_OnAttack.gd — enemy-vs-enemy message (still English SVO + "의") ──
    ("stringa = \"[color=#707070]\" + name_a + \" \" + damage_text + \"[color=#ffa050]s[/color]의 \" + name_d + \" \"",
     "stringa = \"[color=#707070]\" + name_a + \"(이)가 \" + name_d + \"을(를) \" + damage_text + \" \""),
    # ── RouterEvents_OnDamage.gd — enemy-vs-enemy message ──
    ("stringa = \"[color=#707070]\" + name_a + \" \" + damage_text + \"의 \" + name_d + \" \"",
     "stringa = \"[color=#707070]\" + name_a + \"(이)가 \" + name_d + \"을(를) \" + damage_text + \" \""),

    # ── UI_Popup.gd — remaining "O hungry ghost" inside bbcode ──
    ("[color=#707070]O hungry ghost...[/color]", "[color=#707070]오 아귀여...[/color]"),

    # ── TSCN gamepad labels (handled via GD since they're in the TSCN already) ──
    # These are tiny gamepad help text, keep as-is (universal gaming terms)

    # ══════════════════════════════════════════════════════
    # Round 6 (3차 감수): Remaining English UI strings
    # ══════════════════════════════════════════════════════

    # ── UI_Inv.gd — Equip button label ──
    ('.bbcode_text = "Equip"', '.bbcode_text = "장착"'),

    # ── UI_Inv.gd — Bag description label ──
    ('"[color=#9f6040]Bag[/color]"', '"[color=#9f6040]가방[/color]"'),

    # ── UI_Inv.gd — Goblin's Way: "+1 Speed" ──
    ("+1 Speed[/color]", "+1 속도[/color]"),

    # ── UI_God.gd — prayer info: Requires Glory / maximum charge / Trait ──
    ("[color=#ff6c64]Requires Glory ", "[color=#ff6c64]필요 영광 "),
    ("\" maximum [color=#78bca4]charge[/color]\\n\\n\"", "\" 최대 [color=#78bca4]충전[/color]\\n\\n\""),
    ("[color=#c0c0c0]Trait[/color]", "[color=#c0c0c0]특성[/color]"),

    # ── UI_Traits_Basic.gd — trait organize category labels (c0c0c0 color variant) ──
    ("[color=#c0c0c0]Prestige class", "[color=#c0c0c0]상위 직업"),
    ("[color=#c0c0c0]Culture", "[color=#c0c0c0]문화"),
    ("[color=#c0c0c0]Religion", "[color=#c0c0c0]신앙"),
    ("[color=#c0c0c0]Item", "[color=#c0c0c0]아이템"),
    ("[color=#c0c0c0]Class", "[color=#c0c0c0]직업"),

    # ── UI_Traits_Basic.gd — Level Up / Learn button labels ──
    ("[color=#c0c0c0]Level Up[/color] ", "[color=#c0c0c0]레벨 업[/color] "),
    ("[color=#c0c0c0]Learn[/color] ", "[color=#c0c0c0]습득[/color] "),

    # ── translate.gd — Attacks area (without "an", different from UI_Inventory.gd) ──
    ("[color=#ff9090]Attacks area[/color]", "[color=#ff9090]범위 공격[/color]"),

    # ── translate.gd — requires empty Off-hand (inside concatenated string) ──
    ("[color=#707070]requires empty Off-hand[/color]", "[color=#707070]보조손 비어야 함[/color]"),

    # ── ToolPrestigeGiver.gd — prestige class requirement descriptions ──
    # These are UI-facing requirement texts. Ability names are left as-is (JSON proper nouns).
    # "points in any" / "points in" / "points between ... and"
    (" points in any ", " 포인트, 아무 "),
    (" points in ", " 포인트, "),
    (" points between ", " 포인트, "),
    # "and [color=..." connector between two elements
    ("[/color] and [color=", "[/color] + [color="),
    # Prestige category nouns (in bbcode context)
    ("[color=#a0a000]undead[/color]", "[color=#a0a000]언데드[/color]"),
    ("[color=#78bca4]chant[/color]", "[color=#78bca4]성가[/color]"),
    ("[color=#8050f0]cult[/color]", "[color=#8050f0]교단[/color]"),
    ("[color=#70ff00]Ooze[/color]\"", "[color=#70ff00]점액[/color]\""),
    ("[color=#ffff50]anything[/color]", "[color=#ffff50]아무 것[/color]"),
    # Windblade
    ("Main-hand [color=#af8f50]참격[/color] weapon with at least 350 base [color=#ff8030]명중[/color]",
     "주무장 [color=#af8f50]참격[/color] 무기, 기본 [color=#ff8030]명중[/color] 350 이상"),
    # UrBeast
    ("[color=#a07040]Beast Visage[/color] equipped, or Main-hand [color=#ffff50]'Axe'[/color] weapon with at least 300 base [color=#ff8030]명중[/color]",
     "[color=#a07040]Beast Visage[/color] 장착, 또는 주무장 [color=#ffff50]'Axe'[/color] 무기 기본 [color=#ff8030]명중[/color] 300 이상"),
    # LizardLord
    ("[color=#40a000]Lizard Visage[/color] equipped, or head armor with at least 40 base [color=#5050ff]방어력[/color]",
     "[color=#40a000]Lizard Visage[/color] 장착, 또는 머리 방어구 기본 [color=#5050ff]방어력[/color] 40 이상"),
    # NightCrow
    ("[color=#7050a0]Crow Visage[/color] equipped, or at least 3 [color=#ffff50]'Staff'[/color] weapons in inventory",
     "[color=#7050a0]Crow Visage[/color] 장착, 또는 인벤토리에 [color=#ffff50]'Staff'[/color] 무기 3개 이상"),
    # Gallus
    (", or chest armor with at least 120 base [color=#5050ff]방어력[/color]",
     ", 또는 가슴 방어구 기본 [color=#5050ff]방어력[/color] 120 이상"),
    # 'self-damage' label
    ("[color=#ff5050]'self-damage'[/color]", "[color=#ff5050]'자해 피해'[/color]"),

    # ── UI_Traits_Basic.gd — prestige unlock popup ──
    ("상위 직업 unlocked!\\n\\nYou become a ",
     "상위 직업 해금!\\n\\n전직: "),

    # ── UI_Traits_Basic.gd — prestige class button placeholder ──
    ("\"[color=#c0c0c0]A prestige class\"", "\"[color=#c0c0c0]상위 직업\""),

    # ── UI_Traits_Basic.gd — random power tooltip ──
    ("\"[color=#c0c0c0][[color=#ffff50]0[/color]] Learn a new random power from available elements\\n\\nIf at power limit, randomly level up a known power[/color]\"",
     "\"[color=#c0c0c0][[color=#ffff50]0[/color]] 사용 가능한 원소에서 새 능력 무작위 습득\\n\\n능력 한도 시 보유 능력 무작위 레벨업[/color]\""),
    (" + \" [color=#808080]element[/color]\"", " + \" [color=#808080]원소[/color]\""),
    ("stringa += \"[color=#808080]Unknown[/color]\"", "stringa += \"[color=#808080]미습득[/color]\""),
    (
        "stringa += \"\\n\\n[color=#808080]Costs [color=#ffff00]\"\n\t\t\tstringa += str(trait.cost)\n\t\t\tstringa += \"[/color] to \"\n\t\t\tif Global.Player.abilities.has(trait.title):\n\t\t\t\tstringa += \"level up[/color]\"\n\t\t\telse:\n\t\t\t\tstringa += \"learn[/color]\"",
        "stringa += \"\\n\\n[color=#808080]비용 [color=#ffff00]\"\n\t\t\tstringa += str(trait.cost)\n\t\t\tstringa += \"[/color] / \"\n\t\t\tif Global.Player.abilities.has(trait.title):\n\t\t\t\tstringa += \"강화[/color]\"\n\t\t\telse:\n\t\t\t\tstringa += \"습득[/color]\"",
    ),
    ("stringa += \"[color=#707070]Acquire powers from 3 elements...[/color]\"", "stringa += \"[color=#707070]3개 원소에서 능력을 습득하라...[/color]\""),
    ("stringa += \" [color=#c0c0c0]points available\"", "stringa += \" [color=#c0c0c0]포인트 남음\""),

    # ── Process_Fight.gd / RouterEvents_OnHit.gd — combat log msg ──
    ('msg = "Attack"', 'msg = "공격"'),
    ('msg = "Hit"', 'msg = "명중"'),

    # ── ToolProem.gd — death/victory/abandon poems ──
    ('"O pilgrim!\\n\\npride of "', '"오 순례자여!\\n\\n"'),
    ('"\\n\\nof the cosmic struggle..."', '"\\n\\n우주의 투쟁 속에서..."'),
    ('"\\n\\nof the receding waters..."', '"\\n\\n물러나는 파도 위에서..."'),
    ('"\\n\\ndeep was the suffering of night"', '"\\n\\n깊었도다, 밤의 고통이여"'),
    ('"\\n\\nglorious Achra!"', '"\\n\\n영광스러운 아크라!"'),
    ('"O struggler..."', '"오 투쟁자여..."'),
    ('"\\n\\nthy death passes to legend\\n\\non the glimmering path..."', '"\\n\\n그대의 죽음은 전설이 되리니\\n\\n빛나는 길 위에서..."'),
    ('"O pilgrim...\\n\\nthy name vanishes..."', '"오 순례자여...\\n\\n그대의 이름이 사라진다..."'),

    # ── RouterEvents_OnHit.gd — self-hit and enemy-vs-enemy messages ──
    ("stringa = \"[color=#707070]\" + name_a + \" \" + damage_text + \"[color=#ff8030]s[/color] itself \"",
     "stringa = \"[color=#707070]\" + name_a + \"(이)가 자신을 \" + damage_text + \" \""),
    ("stringa = \"[color=#707070]\" + name_a + \" \" + damage_text + \"[color=#ff8030]s[/color]의 \" + name_d + \" \"",
     "stringa = \"[color=#707070]\" + name_a + \"(이)가 \" + name_d + \"을(를) \" + damage_text + \" \""),

    # ── Process_Fight.gd — debug log strings ──
    ('"//accuracy roll "', '"//명중 굴림 "'),
    ('", dodge roll "', '", 회피 굴림 "'),
    ('", initial hit roll "', '", 초기 피해 굴림 "'),
    ('", block -"', '", 방어 -"'),
    ('", result = Block"', '", 결과 = 방어"'),
    ('", block failed"', '", 방어 실패"'),
    ('", armor -"', '", 방어력 -"'),
    ('", armor failed"', '", 방어력 실패"'),
    ('", result = Shrug off"', '", 결과 = 상쇄"'),
    ('", result = Dodge"', '", 결과 = 회피"'),
    ('", result = Hit "', '", 결과 = 명중 "'),

    # ══════════════════════════════════════════════════════
    # Round 7: Combat log remaining English strings
    # ══════════════════════════════════════════════════════

    # ── Process_Fight.gd — "dodge anticipated" debug string ──
    ('", dodge anticipated"', '", 회피 간파"'),

    # ── RouterEvents_OnHit.gd — "hit" verb in message_hit (display text) ──
    ('var damage_text = "[color=#ff8030]hit[/color]"',
     'var damage_text = "[color=#ff8030]명중[/color]"'),

    # ── RouterEvents_OnDamage.gd — message_damage_value "for N" format ──
    ('stringa = "for [color=#df5050]" + damage_string + "[/color]"',
     'stringa = "[color=#df5050]" + damage_string + "[/color] 피해"'),
    ('stringa = "for [color=#ffff50]" + damage_string + "[/color]"',
     'stringa = "[color=#ffff50]" + damage_string + "[/color] 피해"'),
    ('stringa = "for " + damage_string + ""',
     'stringa = damage_string + " 피해"'),

    # ── RouterEvents_OnDamage.gd — get_damage_text() damage type verbs ──
    # These are display-facing verbs shown in combat messages
    ('var stringa = "hit"\n\tif dmg_type == "pierce":\n\t\tstringa = "pierce"\n\tif dmg_type == "slash":\n\t\tstringa = "cut"\n\tif dmg_type == "blunt":\n\t\tstringa = "pummel"\n\tif dmg_type == "blood":\n\t\tstringa = "rend"\n\tif dmg_type == "fire":\n\t\tstringa = "burn"\n\tif dmg_type == "poison":\n\t\tstringa = "poison"\n\tif dmg_type == "astral":\n\t\tstringa = "blast"\n\tif dmg_type == "lightning":\n\t\tstringa = "shock"\n\tif dmg_type == "psychic":\n\t\tstringa = "psyblast"\n\tif dmg_type == "death":\n\t\tstringa = "curse"\n\tif dmg_type == "ice":\n\t\tstringa = "chill"\n\tif attacker != Global.Player:\n\t\tstringa += "s"',
     'var stringa = "타격"\n\tif dmg_type == "pierce":\n\t\tstringa = "관통"\n\tif dmg_type == "slash":\n\t\tstringa = "참격"\n\tif dmg_type == "blunt":\n\t\tstringa = "강타"\n\tif dmg_type == "blood":\n\t\tstringa = "찢기"\n\tif dmg_type == "fire":\n\t\tstringa = "화상"\n\tif dmg_type == "poison":\n\t\tstringa = "중독"\n\tif dmg_type == "astral":\n\t\tstringa = "폭발"\n\tif dmg_type == "lightning":\n\t\tstringa = "감전"\n\tif dmg_type == "psychic":\n\t\tstringa = "정신파"\n\tif dmg_type == "death":\n\t\tstringa = "저주"\n\tif dmg_type == "ice":\n\t\tstringa = "냉기"'),

    # ── ToolMagicMaker.gd — magic damage text verbs ──
    ('var damage_text = "harm"\n\tif damage_type == "fire":\n\t\tdamage_text = "burn"',
     'var damage_text = "피해"\n\tif damage_type == "fire":\n\t\tdamage_text = "화상"'),

    # ── Enemy.gd — "Area attack with" ──
    ('"Area attack with " + translate.get_weapon_name(weapon) + "...x" + str(count)',
     '"범위 공격: " + translate.get_weapon_name(weapon) + "...x" + str(count)'),

    # ── RouterEvents_OnAttack.gd — "Extra <- " prefix ──
    ('msg = "Extra <- " + msg', 'msg = "추가 <- " + msg'),

    # ── RouterEvents_OnDamage.gd — "Phoenix Krasota" in mod_info ──
    ('"Phoenix Krasota" + " +" + str(int(dmg * 1.0 * trait.Level))',
     'trait.Name + " +" + str(int(dmg * 1.0 * trait.Level))'),

    # ── RouterEvents_OnHit.gd — "enemy Purges you" msg ──
    ('"msg": "enemy Purges you"', '"msg": "적의 정화"'),

    # ── RouterEvents_OnHit.gd — "Being hit" msg ──
    ('"msg": "Being hit"', '"msg": "피격"'),

]


def apply_translations(text: str) -> str:
    """Apply all translation rules to the text."""
    for old, new in TRANSLATIONS:
        text = text.replace(old, new)
    return text


def translate_file(src: Path, dst: Path) -> bool:
    """Read a .gd file, translate, and write to dst. Return True if changed."""
    original = src.read_text(encoding="utf-8")
    translated = apply_translations(original)
    dst.parent.mkdir(parents=True, exist_ok=True)
    dst.write_text(translated, encoding="utf-8")
    return translated != original


def compile_gd(gd_path: Path, output_dir: Path) -> Path | None:
    """Compile a .gd file to .gdc using gdre_tools."""
    result = subprocess.run(
        [
            str(GDRE_TOOLS),
            "--headless",
            f"--compile={gd_path}",
            "--bytecode=3.5.2",
            f"--output={output_dir}/",
        ],
        capture_output=True,
        text=True,
        timeout=30,
    )
    gdc_path = output_dir / gd_path.with_suffix(".gdc").name
    if gdc_path.exists():
        return gdc_path
    print(f"  COMPILE FAILED: {gd_path.name}")
    print(f"  stderr: {result.stderr[:200]}")
    return None


def main():
    KOREAN_DIR.mkdir(parents=True, exist_ok=True)
    COMPILED_DIR.mkdir(parents=True, exist_ok=True)

    translated_files = []
    skipped_files = []
    failed_files = []

    for res_path, local_name in sorted(FILES_TO_TRANSLATE.items()):
        src = DECOMPILED_DIR / local_name
        if not src.exists():
            skipped_files.append((res_path, local_name, "source not found"))
            continue

        dst = KOREAN_DIR / local_name
        changed = translate_file(src, dst)

        if changed:
            gdc = compile_gd(dst, COMPILED_DIR)
            if gdc:
                translated_files.append((res_path, local_name, gdc.name))
            else:
                failed_files.append((res_path, local_name, "compile failed"))
        else:
            skipped_files.append((res_path, local_name, "no changes"))

    print("\n" + "=" * 60)
    print(f"TRANSLATED & COMPILED: {len(translated_files)}")
    for res_path, local_name, gdc_name in translated_files:
        print(f"  {res_path} -> {gdc_name}")

    print(f"\nSKIPPED: {len(skipped_files)}")
    for res_path, local_name, reason in skipped_files:
        print(f"  {local_name}: {reason}")

    print(f"\nFAILED: {len(failed_files)}")
    for res_path, local_name, reason in failed_files:
        print(f"  {local_name}: {reason}")

    # Generate GDC_REPLACE_MAP for build_korean_patch.py
    print("\n\n# Add to build_korean_patch.py GDC_REPLACE_MAP:")
    print("GDC_REPLACE_MAP = {")
    print('    "res://translate.gdc": "translate-ko.gdc",')
    for res_path, local_name, gdc_name in translated_files:
        print(f'    "{res_path}": "{gdc_name}",')
    print("}")


if __name__ == "__main__":
    main()
