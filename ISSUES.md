### [Translated Buff Names Broke Runtime Buff Matching]
**Date:** 2026-06-23
**Symptom:** With the Korean patch installed, buff-driven stat changes did not update correctly in the character sheet, inventory sheet, or character hover UI. A reported example was Champion's Poise-based speed bonus not appearing even with hundreds of Poise stacks.
**Cause:** `Table_Buffs.name` is translated for display, but many GDScript paths used `buff.name` as an internal key and compared it to shipped English identifiers such as `"Poise"`, `"Freeze"`, and `"Protection"`. Once `name` became Korean, those comparisons failed. This affects stat display and can also affect gameplay logic that depends on buff-name matching.
**Resolution:** `translate_gdc_strings.py` now postprocesses generated GDScript so internal buff matching uses `buff.title` while display strings keep using translated `buff.name`. It also recompiles every mapped GDC so unchanged-but-required scripts such as `StatePlayerSheet.gdc` are present. `build_korean_patch.py` now fails if a mapped GDC replacement is missing instead of silently omitting it.

### [Translated Internal Enums Broke Runtime Matching]
**Date:** 2026-04-09
**Symptom:** 한글 패치 적용 후 특성 화면 컬럼이 비어 보이거나 기도 충전이 전혀 되지 않았다.
**Cause:** 데이터 테이블의 사용자 표시용 텍스트만 번역해야 하는데, 내부 식별자 역할을 하는 `Element` 와 `use_recharge_type` 같은 enum 값까지 한글로 바뀌어 GDScript의 문자열 비교가 실패했다.
**Resolution:** `build_korean_patch.py`에서 내부 식별자 필드를 번역 대상에서 제외했고, 보호 필드 검증을 추가해 빌드 중 해당 값이 바뀌면 즉시 실패하도록 했다. 표시용 한국어는 GDScript 쪽 별도 매핑으로 처리했다.
