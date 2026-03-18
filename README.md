# AI‑PlayBook

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

AI 제품/에이전트 개발에 필요한 재사용 가능한 스킬(Skills)과 플레이북을 정리한 저장소입니다.

## 개요

AI‑PlayBook은 **Claude Code, Codex CLI/App**과 함께 사용할 수 있는 **재사용 가능한 스킬 모음**입니다. 각 스킬은 특정 작업(프론트엔드 코드 가이드 적용, Git 커밋 메시지 작성, 설계 패턴 판단, 구현 검증, 스킬 유지보수 등)을 일관되게 수행하도록 돕습니다.

## 빠르게 시작하기

### 전체 스킬 설치

```bash
npx skills add Junyong34/AI-PlayBook
```

pnpm 사용 시:

```bash
pnpm dlx skills add Junyong34/AI-PlayBook
```

### 특정 스킬만 설치

```bash
npx skills add Junyong34/AI-PlayBook --skill git-commit-msg
```

pnpm 사용 시:

```bash
pnpm dlx skills add Junyong34/AI-PlayBook --skill git-commit-msg
```

## 디렉토리 구조

```text
skills/
├── design-pattern-thinking/
├── front-end-code-guidelines/
├── git-commit-msg/
└── verification/
    ├── manage-skills/
    └── verify-implementation/
```

## Skills 목록

### 프론트엔드 & 아키텍처
| Skill | 설명 | 사용 시점 |
|-------|------|-----------|
| [`front-end-code-guidelines`](./skills/front-end-code-guidelines/SKILL.md) | React/TypeScript 웹 프론트엔드 작업 시 상태 관리, 훅, 타입, Emotion 스타일링, 작업 범위를 일관된 기준으로 판단 | React 컴포넌트/훅 수정, 타입 설계, 스타일링, 레거시 프론트엔드 코드 리뷰 및 리팩터링 시 |
| [`design-pattern-thinking`](./skills/design-pattern-thinking/SKILL.md) | 설계 패턴이 정말 필요한지 먼저 판단하고, 필요 시 이유·비용·대안을 함께 비교 | 디자인 패턴 선택, 구조 리팩터링, 안티패턴 진단, 책임 분리 검토 시 |

### Git & 버전 관리
| Skill | 설명 | 사용 시점 |
|-------|------|-----------|
| [`git-commit-msg`](./skills/git-commit-msg/SKILL.md) | JIRA 티켓 기반 한글 Git 커밋 메시지 작성 및 검토 | 커밋 메시지 작성 시, prefix 선택과 제목/본문 형식 일관성 필요 시 |

### 검증 & 품질 관리
| Skill | 설명 | 사용 시점 |
|-------|------|-----------|
| [`verify-implementation`](./skills/verification/verify-implementation/SKILL.md) | 프로젝트에 등록된 모든 `verify-*` 스킬을 순차 실행해 통합 검증 보고서를 생성 | 기능 구현 후, PR 전, 코드 리뷰 중 규칙 준수 여부를 점검할 때 |
| [`manage-skills`](./skills/verification/manage-skills/SKILL.md) | 세션 변경사항을 분석해 검증 스킬 커버리지 누락과 오래된 참조를 탐지하고 유지보수 | 새 패턴 도입 후, 검증 스킬 정합성 점검 시, PR 전 커버리지 확인 시 |

## 라이선스

본 저장소는 MIT 라이선스를 따릅니다. 자세한 내용은 [`LICENSE`](./LICENSE) 파일을 참고하세요.

---

**Made with ❤️ for AI-assisted development**

*Compatible with Claude Code, Codex CLI/App, and Agent Skills standard*
