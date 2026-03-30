---
name: commit
description: JIRA Issue Key 기반 프로젝트에서 한글 Git 커밋 메시지를 작성하거나 검토할 때 사용한다. 커밋 메시지 작성, 스테이징된 변경사항 확인, prefix 선택, 브랜치의 JIRA Issue Key 재사용, 커밋 제목/본문 규칙 확인이 필요할 때 호출한다.
argument-hint: [선택사항: 작업 설명 또는 포커스 영역]
disable-model-invocation: false
---

# Git Commit Message

JIRA Issue Key 기반 프로젝트에서 한글 커밋 메시지를 일관되게 작성하고 코드 의도를 명확히 표현한다.

## 작성 전 확인 명령어

커밋 메시지를 쓰기 전에 실제 커밋 대상이 무엇인지 먼저 확인한다.

```bash
git branch --show-current
git diff --cached --name-only
git diff --cached
```

- `git branch --show-current`로 현재 브랜치명을 확인한다.
- `git diff --cached --name-only`로 현재 스테이징된 파일 목록을 확인한다.
- `git diff --cached`로 실제 커밋될 변경 내용을 확인한다.
- 커밋 메시지 제목과 본문은 이 스테이징 기준으로 작성한다.
- 아직 스테이징되지 않은 변경 사항은 커밋 메시지 기준에 포함하지 않는다.

## 핵심 규칙

- 커밋 메시지는 한글로 작성한다.
- 제목 형식은 `[JIRA-Issue Key][prefix]: 요약`을 사용한다. JIRA Issue Key가 없다면 `[브랜치명][prefix]: 요약`을 사용한다.
- 제목은 명령문으로 작성한다.
- 제목 끝에 마침표(`.`)를 붙이지 않는다.
- 본문 작성은 권장 사항이며, 내용상 필요한 경우에만 선택적으로 작성한다.
- 본문을 작성할 때는 제목 다음 한 줄을 비운 뒤 시작한다.
- 한 커밋에는 하나의 목적만 담는다.
- 브랜치 이름에 JIRA Issue Key가 포함되어 있다면 같은 번호를 커밋 메시지에도 그대로 사용한다.
- 브랜치 이름이 JIRA Issue Key가 아니라면 현재 브랜치명을 식별자로 사용한다.

## 기본 형식

```text
[JIRA-Issue Key][prefix]: 요약

- 변경한 화면 또는 영역
- 추가로 남길 설명
```

본문이 필요 없으면 제목 한 줄만 작성한다.

## 제목 작성 규칙

- `[JIRA-Issue Key]`는 현재 작업한 Issue Key를 그대로 사용한다.
- 브랜치에 포함된 번호를 커밋 메시지에 그대로 재사용해도 된다.
- 브랜치 이름이 JIRA 번호 형식이 아니면 `git branch --show-current` 결과를 그대로 첫 식별자 자리에 사용한다.
- `[prefix]`는 변경 성격에 맞는 값 하나만 사용한다.
- `요약`은 무엇을 했는지 바로 이해되도록 짧게 쓴다.
- 명령문 예시: `적용`, `추가`, `제거`, `수정`, `정리`, `개선`
- 모호한 표현 (`수정`, `버그 수정`, `작업 반영`) 대신 구체적인 표현을 사용한다.

## Commit Prefix 정리

| Prefix | Description |
| --- | --- |
| `feat` | 새로운 기능 추가 |
| `add` | 모듈 및 라이브러리 추가 |
| `fix` | 간단한 수정 사항 |
| `docs` | 마크다운, 문서 작업 |
| `refactor` | 코드 리팩토링 |
| `perf` | 성능 개선 |
| `test` | 테스트 코드 관련 작업 |
| `build` | 빌드 시스템 관련 작업 |
| `ci` | CI 관련 설정 작업 |
| `revert` | 이전 작업 취소 |
| `archive` | 코드 아카이빙 작업 및 archive 디렉토리 관련 작업 |

## 예시

### 한 줄 커밋 예시

```text
[FRONTEND-2086][feat]: XSS 필터링 함수 코드 적용
[QA-2086][fix]: isApp 체크 로직 제거
[XXX-2086][docs]: 프로모션 기능 명세서 추가
[FRONTEND-2086][archive]: XSS 필터링 함수 코드 적용 상태 보관
[feature/login-form][feat]: 로그인 폼 유효성 검사 추가
```

### 본문 포함 커밋 예시

```text
[FRONTEND-2086][feat]: XSS 필터링 함수 코드 적용

- 1:1 문의 화면
- 리뷰 작성 화면
```

```text
[FRONTEND-2086][refactor]: 리뷰 작성 화면 입력값 정리 로직 분리

- 공통 유틸로 이동
- 중복 조건문 제거
```

## 잘못된 예시와 올바른 예시

### JIRA Issue Key 누락

```text
잘못된 예시: [feat]: XSS 필터링 함수 코드 적용
올바른 예시: [FRONTEND-2086][feat]: XSS 필터링 함수 코드 적용
```

브랜치명이 JIRA Issue Key가 아닌 경우:

```text
예시: [feature/login-form][feat]: 로그인 폼 유효성 검사 추가
```

### 영어 제목 사용

```text
잘못된 예시: [FRONTEND-2086][feat]: apply xss filter
올바른 예시: [FRONTEND-2086][feat]: XSS 필터링 함수 코드 적용
```

### 제목 끝 마침표 사용

```text
잘못된 예시: [QA-2086][fix]: isApp 체크 로직 제거.
올바른 예시: [QA-2086][fix]: isApp 체크 로직 제거
```

### `archive`를 suffix로 사용

```text
잘못된 예시: [FRONTEND-2086][feat]: XSS 필터링 함수 코드 적용[archive]
올바른 예시: [FRONTEND-2086][archive]: XSS 필터링 함수 코드 적용 상태 보관
```

### 제목과 본문 사이 공백 줄 누락

```text
잘못된 예시:
[FRONTEND-2086][feat]: XSS 필터링 함수 코드 적용
- 1:1 문의 화면

올바른 예시:
[FRONTEND-2086][feat]: XSS 필터링 함수 코드 적용

- 1:1 문의 화면
```

## 빠른 체크리스트

- JIRA Issue Key가 제목 앞에 포함되어 있는가
- 변경 성격에 맞는 prefix를 하나만 사용했는가
- JIRA Issue Key가 없다면 현재 브랜치명을 첫 식별자로 사용했는가
- 제목을 한글 명령문으로 작성했는가
- 제목 끝에 마침표가 없는가
- 커밋 메시지가 스테이징된 파일 목록과 변경 내용 기준으로 작성되었는가
- 본문이 있다면 제목과 본문 사이에 한 줄을 비웠는가
- 본문이 있다면 영향 범위 또는 이유가 짧게 정리되어 있는가

## 실행 흐름

커밋 메시지를 제안한 뒤 아래 순서로 진행한다.

### 1단계: 메시지 제안

스테이징된 변경 내용을 분석하여 커밋 메시지 제목과 본문을 제안한다.
제안은 코드 블록으로 명확하게 출력한다.

```text
[ISSUE-KEY][prefix]: 요약

- 변경 내용 1
- 변경 내용 2
```

### 2단계: 수정 여부 확인 (루프)

제안 후 반드시 AskUserQuestion 도구를 사용해 다음 질문을 제시한다:

- question: "수정할 내용이 있으신가요?"
- header: "커밋 메시지 검토"
- options:
  - label: "수정 있음", description: "커밋 메시지를 수정합니다 (다음 입력에서 수정 내용을 알려주세요)"
  - label: "없음 (다음 단계로)", description: "현재 메시지로 진행합니다"

- 사용자가 "수정 있음"을 선택하면 → 수정 내용을 입력받아 커밋 메시지를 다시 제안하고 2단계로 돌아간다.
- 사용자가 "없음 (다음 단계로)"을 선택하면 → 3단계로 넘어간다.

### 3단계: 실행 방식 선택

반드시 AskUserQuestion 도구를 사용해 다음 질문을 제시한다:

- question: "어떻게 진행할까요?"
- header: "실행 방식"
- options:
  - label: "커밋만 하기", description: "git commit 만 실행합니다"
  - label: "커밋 + push", description: "git commit 후 git push 까지 실행합니다"
  - label: "취소", description: "아무것도 실행하지 않고 종료합니다"

- **"커밋만 하기" 선택**: `git commit -m "..."` 실행
- **"커밋 + push" 선택**: `git commit -m "..."` 실행 후 `git push` 실행
- **"취소" 선택**: 아무것도 실행하지 않고 종료

### 4단계: 실행 및 결과 출력

명령어 실행 결과를 그대로 출력한다.

- 성공 시: 완료 메시지와 함께 커밋 해시 또는 push 결과를 출력한다.
- 실패 시: 오류 로그 전문을 출력하고 원인을 설명한다. 추가 조치가 필요하면 다음 단계를 안내한다.
