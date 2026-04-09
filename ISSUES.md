### [Translated Internal Enums Broke Runtime Matching]
**Date:** 2026-04-09
**Symptom:** 한글 패치 적용 후 특성 화면 컬럼이 비어 보이거나 기도 충전이 전혀 되지 않았다.
**Cause:** 데이터 테이블의 사용자 표시용 텍스트만 번역해야 하는데, 내부 식별자 역할을 하는 `Element` 와 `use_recharge_type` 같은 enum 값까지 한글로 바뀌어 GDScript의 문자열 비교가 실패했다.
**Resolution:** `build_korean_patch.py`에서 내부 식별자 필드를 번역 대상에서 제외했고, 보호 필드 검증을 추가해 빌드 중 해당 값이 바뀌면 즉시 실패하도록 했다. 표시용 한국어는 GDScript 쪽 별도 매핑으로 처리했다.
