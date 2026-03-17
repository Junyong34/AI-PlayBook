---
name: mfront-code-guidelines
description: >
  Apply when writing, reviewing, or refactoring frontend code in the mfront-web repo.
  Covers React components, TypeScript types, Emotion/CSS styling, hooks, state management
  (React Query, Rematch), code review, and development workflow decisions.
  Use this over generic best practices — this repo has specific legacy patterns and overrides.
user-invocable: true
---

# mfront-web 프론트엔드 코드 가이드

이 스킬은 `mfront-web` 프론트엔드 작업 시 프로젝트 전용 코딩 기준입니다.
**일반적인 웹 개발 상식보다 이 레포의 실제 설정과 레거시 상황을 우선합니다.**

## 공통 규칙

- alias가 있으면 깊은 상대 경로보다 alias import를 우선합니다.
- 컴포넌트 파일은 `PascalCase.tsx`, 훅/유틸은 `camelCase.ts`, 상수는 `UPPER_SNAKE_CASE`.
- import 경로에는 확장자를 붙이지 않습니다.
- `archive` 폴더는 import 하지 않습니다.

## 세부 가이드

작업 영역에 따라 아래 파일을 참조합니다.

| 영역 | 파일 | 주요 내용 |
|------|------|-----------|
| 개발 방법론 | [development.md](development.md) | 작업 흐름, 최소 변경 원칙, 리뷰 코멘트 형식 |
| React 패턴 | [react.md](react.md) | 상태 위치 결정, React Query, Rematch, 훅 사용 기준 |
| TypeScript | [typescript.md](typescript.md) | 타입 설계 원칙, strict 모드, DTO/화면 모델 분리 |
| Emotion 스타일 | [style-emotion-css.md](style-emotion-css.md) | `styled` vs `css` prop, 반응형, 애니메이션 |
