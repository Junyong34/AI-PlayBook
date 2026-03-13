# AI‑PlayBook

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

AI 제품/에이전트 개발에 필요한 재사용 가능한 스킬(Skills)과 플레이북을 정리한 저장소입니다.

## 개요

AI‑PlayBook은 **Claude Code, Codex CLI/App**과 함께 사용할 수 있는 **재사용 가능한 스킬 모음**입니다. 각 스킬은 특정 작업(Git 커밋 메시지 작성, 코드 검증, 코딩 표준 준수 등)을 일관되게 수행하도록 돕습니다.

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


## Skills 목록

### Git & 버전 관리
| Skill | 설명 | 사용 시점 |
|-------|------|-----------|
| [`git-commit-msg`](./skills/git-commit-msg/SKILL.md) | JIRA 티켓 기반 한글 Git 커밋 메시지 작성 및 검토 | 커밋 메시지 작성 시, prefix 선택과 제목/본문 형식 일관성 필요 시 |

### 검증 & 품질 관리
| Skill | 설명 | 사용 시점 |
|-------|------|-----------|
| [`verify-implementation`](./.claude/skills/verify-implementation/SKILL.md) | 프로젝트의 모든 verify 스킬을 순차 실행하여 통합 검증 | 기능 구현 후, PR 생성 전, 코드 리뷰 시 |
| [`manage-skills`](./.claude/skills/manage-skills/SKILL.md) | 세션 변경사항 분석 및 검증 스킬 생성/업데이트, CLAUDE.md 관리 | 새 패턴 도입 후, 스킬 일관성 점검 시, PR 전 커버리지 확인 시 |

### 코딩 표준 & 패턴
| Skill | 설명 | 적용 범위 |
|-------|------|-----------|
| [`coding-standards`](./.claude/skills/coding-standards.md) | TypeScript, JavaScript, React, Node.js 코딩 표준 | 변수 명명, 에러 처리, 타입 안정성, 코드 품질 원칙 |
| [`frontend-patterns`](./.claude/skills/frontend-patterns.md) | React, Next.js 프론트엔드 개발 패턴 | 컴포넌트 패턴, 커스텀 훅, 상태 관리, 성능 최적화, 접근성 |



## 라이선스

본 저장소는 MIT 라이선스를 따릅니다. 자세한 내용은 [`LICENSE`](./LICENSE) 파일을 참고하세요.

---

**Made with ❤️ for AI-assisted development**

*Compatible with Claude Code, Codex CLI/App, and Agent Skills standard*
