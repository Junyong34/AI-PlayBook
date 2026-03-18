---
name: front-end-code-guidelines
description: |
  mfront-web 프론트엔드 코드 가이드라인을 적용합니다.

  Use this skill whenever the user is writing, modifying, debugging, or reviewing React/TypeScript web frontend code. This includes:
  - React 컴포넌트·훅·페이지를 새로 만들거나 수정할 때
  - 상태 관리 위치 결정 (React Query vs Rematch vs local state)
  - useEffect, 의존성 배열, 무한 렌더링 등 훅 관련 문제 해결
  - Emotion/CSS 스타일링 작업 (styled vs css prop, 반응형, 테마)
  - TypeScript 타입 설계, any/as 처리, 제네릭 패턴
  - 레거시 코드 수정 전략 (함수형 전환 vs 최소 수정)
  - 코드 리뷰 범위, PR 범위, 리팩터링 범위 판단
  - 컴포넌트 패턴 선택 (headless, compound, render props 등)
  - 커스텀 훅 반환 타입, 에러 처리, 로딩 상태 설계

  Does NOT apply to: Next.js, React Native, Vue, infra, or non-React-web projects.
---

# 프론트엔드 코드 가이드라인

이 프로젝트(`mfront-web`)는 React 18, React Query, Rematch(Redux), Emotion, TypeScript가 함께 사용되는 대형 프론트엔드입니다.
가이드라인의 핵심 원칙은 **"올바른 위치에 올바른 패턴을 최소한의 변경으로"** 입니다.

레거시 코드가 섞여 있으므로 기존 패턴을 참고하되, 새 코드는 아래 가이드 기준을 따릅니다.

---

## 참조 파일 안내

작업 유형에 따라 아래 파일을 읽고 적용합니다. 경로는 이 스킬 디렉토리 기준입니다.

| 작업 유형 | 읽을 파일 |
|-----------|-----------|
| React 컴포넌트, 상태 관리, 훅 | `references/react.md` |
| TypeScript 타입 설계, any/as/! 처리 | `references/typescript.md` |
| Emotion 스타일링, styled/css prop, 반응형 | `references/style-emotion-css.md` |
| 작업 범위 판단, 리뷰 코멘트, 개발 방법론 | `references/development.md` |

여러 영역에 걸치는 작업이라면 관련 파일을 모두 읽습니다.

---

## 핵심 원칙 요약

### 상태 위치 결정 기준

| 상황 | 위치 |
|------|------|
| 입력값, 열림/닫힘, hover, 탭 상태 | local state |
| API 조회 / 캐시 / 동기화 | React Query |
| 여러 화면에서 공유되는 클라이언트 상태 | Rematch / Redux |

### TypeScript 핵심

- 새 코드는 strict 모드 통과를 기본값으로 작성
- 외부 입력 경계는 `unknown`에서 시작해 narrowing 후 사용
- 공개 함수·커스텀 훅·재사용 유틸은 반환 타입 명시
- 불법 상태(loading + error + data 동시 optional)는 판별 유니온으로 막기

### Emotion 스타일링 핵심

- 재사용되는 UI 본체 → `styled`
- 한 화면 안에서만 쓰이는 배치/조건부 스타일 → `css` prop
- 반응형은 `mediaWidth.mobile`, `mediaWidth.desktop` 기본값 사용

### 개발 방법론 핵심

- 구현은 **요청과 직접 연결된 최소 변경**을 기본값으로
- 작업 순서: `동작 확보 → 정확성 보강 → 필요한 범위의 정리`
- 요청되지 않은 광범위한 리팩터링·공통화는 하지 않기

---

## 기존 코드 예외 공통 원칙

- 레거시 파일에는 오래된 패턴이 섞여 있습니다. **기존 예외를 새 코드에 복제하지 않습니다.**
- 작은 수정이라면 전체 현대화보다 현재 변경을 안전하게 끝내는 것이 우선입니다.
- 내가 만든 변경이 새로운 dead code, 중복 코드, 미사용 import를 만들었다면 그것은 함께 정리합니다.
