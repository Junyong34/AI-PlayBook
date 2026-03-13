---
name: git-commit-msg
description: Generates and reviews Korean Git commit messages for JIRA-based projects. Use when writing commit messages, reviewing staged changes, choosing a commit prefix, reusing a branch JIRA issue number, falling back to the current branch name, or checking commit title/body rules.
---

# Git Commit Message

JIRA 티켓 기반 프로젝트에서 한글 커밋 메시지를 일관되게 작성하고 검토하기 위한 스킬이다.

## 핵심 규칙

- 커밋 메시지는 한글로 작성한다.
- 제목 형식은 `[#JIRA-번호 또는 브랜치명][prefix]: 요약`을 사용한다.
- 제목은 명령문으로 작성한다.
- 제목 끝에 마침표(`.`)를 붙이지 않는다.
- 본문은 선택 사항이며, 제목 다음 한 줄을 비운 뒤 작성한다.
- 한 커밋에는 하나의 목적만 담는다.
- 커밋 메시지는 작업 중인 전체 파일이 아니라 Git 스테이징 영역에 올라간 파일 목록과 변경 내용 기준으로 작성한다.
- 브랜치 이름에 JIRA 이슈 번호가 포함되어 있다면 같은 번호를 커밋 메시지에도 그대로 사용한다.
- 브랜치 이름이 JIRA 티켓 번호가 아니라면 현재 브랜치명을 식별자로 사용해 커밋 메시지를 작성할 수 있다.
- `archive`는 suffix가 아니라 prefix로만 사용한다.

## 기본 형식

```text
[#JIRA-번호 또는 브랜치명][prefix]: 요약

- 변경한 화면 또는 영역
- 추가로 남길 설명
```

본문이 필요 없으면 제목 한 줄만 작성한다.

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

## 제목 작성 규칙

- `[#JIRA-번호]`는 현재 작업한 티켓 번호를 그대로 사용한다.
- 일반적으로 브랜치 이름도 같은 JIRA 이슈 번호로 만들기 때문에, 브랜치에 포함된 번호를 커밋 메시지에 그대로 재사용해도 된다.
- 브랜치 이름이 JIRA 번호 형식이 아니면 `git branch --show-current` 결과를 그대로 첫 식별자 자리에 사용한다.
- `[prefix]`는 변경 성격에 맞는 값 하나만 사용한다.
- `요약`은 무엇을 했는지 바로 이해되도록 짧게 쓴다.
- 제목과 본문은 `git diff --cached --name-only`로 확인한 파일 리스트를 기준으로 정리한다.
- 명령문 예시: `적용`, `추가`, `제거`, `수정`, `정리`, `개선`
- 모호한 표현은 피한다.
  - `수정`
  - `버그 수정`
  - `작업 반영`
- 구체적인 표현을 사용한다.
  - `XSS 필터링 함수 코드 적용`
  - `isApp 체크 로직 제거`
  - `프로모션 기능 명세서 추가`

## Commit Prefix 정리

| Prefix | Description                     |
| --- |---------------------------------|
| `feat` | 새로운 기능 추가                       |
| `add` | 모듈 및 라이브러리 추가                   |
| `fix` | 간단한 수정 사항                       |
| `docs` | 마크다운, 문서 작업                     |
| `refactor` | 코드 리팩토링                         |
| `perf` | 성능 개선                           |
| `test` | 테스트 코드 관련 작업                    |
| `build` | 빌드 시스템 관련 작업                    |
| `ci` | CI 관련 설정 작업                     |
| `revert` | 이전 작업 취소                        |
| `archive` | 코드 아카이빙 작업 및 archive 디렉토리 관련 작업 |

## 예시

### 한 줄 커밋 예시

```text
[#FRONTEND-2086][feat]: XSS 필터링 함수 코드 적용
[#QA-2086][fix]: isApp 체크 로직 제거
[#XXX-2086][docs]: 프로모션 기능 명세서 추가
[#FRONTEND-2086][archive]: XSS 필터링 함수 코드 적용 상태 보관
[feature/login-form][feat]: 로그인 폼 유효성 검사 추가
```

### 본문 포함 커밋 예시

```text
[#FRONTEND-2086][feat]: XSS 필터링 함수 코드 적용

- 1:1 문의 화면
- 리뷰 작성 화면
```

```text
[#FRONTEND-2086][refactor]: 리뷰 작성 화면 입력값 정리 로직 분리

- 공통 유틸로 이동
- 중복 조건문 제거
```

## 잘못된 예시와 올바른 예시

### JIRA 번호 누락

```text
잘못된 예시: [feat]: XSS 필터링 함수 코드 적용
올바른 예시: [#FRONTEND-2086][feat]: XSS 필터링 함수 코드 적용
```

브랜치명이 JIRA 번호가 아닌 경우에는 아래처럼 브랜치명을 사용한다.

```text
예시: [feature/login-form][feat]: 로그인 폼 유효성 검사 추가
```

### 영어 제목 사용

```text
잘못된 예시: [#FRONTEND-2086][feat]: apply xss filter
올바른 예시: [#FRONTEND-2086][feat]: XSS 필터링 함수 코드 적용
```

### 제목 끝 마침표 사용

```text
잘못된 예시: [#QA-2086][fix]: isApp 체크 로직 제거.
올바른 예시: [#QA-2086][fix]: isApp 체크 로직 제거
```

### `archive`를 suffix로 사용

```text
잘못된 예시: [#FRONTEND-2086][feat]: XSS 필터링 함수 코드 적용[archive]
올바른 예시: [#FRONTEND-2086][archive]: XSS 필터링 함수 코드 적용 상태 보관
```

### 제목과 본문 사이 공백 줄 누락

```text
잘못된 예시:
[#FRONTEND-2086][feat]: XSS 필터링 함수 코드 적용
- 1:1 문의 화면
- 리뷰 작성 화면

올바른 예시:
[#FRONTEND-2086][feat]: XSS 필터링 함수 코드 적용

- 1:1 문의 화면
- 리뷰 작성 화면
```

## 빠른 체크리스트

- JIRA 이슈 번호가 제목 앞에 포함되어 있는가
- 변경 성격에 맞는 prefix를 하나만 사용했는가
- JIRA 번호가 없다면 현재 브랜치명을 첫 식별자로 사용했는가
- 제목을 한글 명령문으로 작성했는가
- 제목 끝에 마침표가 없는가
- 커밋 메시지가 스테이징된 파일 목록과 변경 내용 기준으로 작성되었는가
- 본문이 있다면 제목과 본문 사이에 한 줄을 비웠는가
- 본문이 있다면 영향 범위 또는 이유가 짧게 정리되어 있는가
