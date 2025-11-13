
```markdown
# AGENTS.md

## 프로젝트 개요
이 저장소는 AI 제품/에이전트 개발에 필요한 플레이북을 정리한 **문서 중심 저장소**입니다.
실제 빌드나 실행이 필요하지 않으며, 각 프로젝트에서 필요한 규칙과 템플릿을 복사하여 사용합니다.

## 저장소 목적
- AI 코딩 에이전트를 위한 프롬프트 규칙 및 가이드라인 제공
- 코드 리뷰, 리팩토링, 운영 체크리스트 등 재사용 가능한 문서 모음
- 팀이 일관된 방식으로 LLM/에이전트를 설계·구현·운영할 수 있도록 지원

## 폴더 구조

AI-PlayBook/
├── .aiassistant/          # AI 어시스턴트 규칙 파일
│   └── rules/             # 프로젝트 전반에 적용되는 AI 규칙
├── AGENTS.md              # 본 문서 (에이전트 가이드)
├── README.md              # 저장소 소개 및 사용법
└── LICENSE                # MIT 라이선스
```

## 예시

#### 프론트엔드 React 프로젝트
```
markdown
# your-project/AGENTS.md

## Setup commands
- Install deps: `pnpm install`
- Start dev server: `pnpm dev`
- Run tests: `pnpm test`
- Build: `pnpm build`

## Code style
- TypeScript strict mode enabled
- Prettier + ESLint configured
- Use functional components and hooks

## Referenced rules
- Frontend engineering: See `.aiassistant/rules/agents-rule.md`
- Refactoring: See `.aiassistant/rules/code-refactoring.md`

## Project-specific conventions
- State management: Zustand (for global state)
- UI library: Tailwind CSS + shadcn/ui
- Testing: Vitest + React Testing Library
```
#### 백엔드 Node.js 프로젝트
```
markdown
# your-project/AGENTS.md

## Setup commands
- Install deps: `npm install`
- Start dev: `npm run dev`
- Run tests: `npm test`
- Database migration: `npm run migrate`

## Code style
- TypeScript with strict mode
- Functional programming patterns preferred
- Use dependency injection for services

## Testing
- Unit tests: Jest
- Integration tests: Supertest
- E2E tests: Playwright

## Project conventions
- REST API: Follow OpenAPI 3.0 spec
- Database: PostgreSQL with Prisma ORM
- Auth: JWT with refresh tokens
```
### 5. AI 에이전트 호환성

이 저장소의 규칙은 다음 AI 도구들과 호환됩니다:
- **GitHub Copilot** (VS Code, JetBrains)
- **Cursor**
- **Zed**
- **Warp**
- **Aider** (CLI)
- **JetBrains AI Assistant**
- 기타 AGENTS.md 포맷을 지원하는 도구



---

**Important**: 이 파일은 AI 에이전트가 프로젝트를 이해하고 효과적으로 작업할 수 있도록 
컨텍스트를 제공하는 것이 목적입니다. 실제 프로젝트에 적용할 때는 프로젝트별 특성에 맞게 
커스터마이징하여 사용하세요.
```