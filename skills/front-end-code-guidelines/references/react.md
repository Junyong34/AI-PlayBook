# React 문법 및 베스트 사용법 가이드

이 프로젝트는 React 18, React Query, Rematch(Redux), Emotion이 함께 사용되는 대형 프론트엔드입니다.
React 가이드는 상태를 어디에 두고, 어떤 훅 패턴을 기본값으로 삼을지 빠르게 판단하기 위한 기준입니다.

> 이 문서는 React 18 기준입니다. React 19 전용 패턴은 현재 기본 가이드에 포함하지 않습니다.

## 새 코드 기본값

### MUST

- 상태 위치는 아래 순서로 판단합니다.

| 상황 | 기본 위치 |
| --- | --- |
| 입력값, 열림/닫힘, hover, 탭 상태 | local state |
| API 조회/캐시/동기화 | React Query |
| 여러 화면에서 공유되는 클라이언트 상태 | Rematch / Redux |

- 서버 상태는 React Query에 둡니다.
- 공유 클라이언트 상태는 Rematch에 둡니다.
- 새 React Query 코드는 object syntax를 기본값으로 사용합니다.
- `useEffect`는 외부 시스템과 동기화할 때만 사용합니다.
- 렌더링 컴포넌트와 복잡한 조합/오케스트레이션 로직은 필요 시 분리합니다.

### SHOULD

- 파생값은 먼저 일반 계산으로 해결 가능한지 확인하고, 정말 비용이 있거나 참조 안정성이 필요할 때만 `useMemo`를 사용합니다.
- 이벤트 핸들러는 실제로 props 안정성이나 리렌더 비용에 의미가 있을 때만 `useCallback`을 사용합니다.
- 재사용되는 조회/변환/이펙트 로직은 커스텀 훅으로 올립니다.
- 불리언 props를 계속 늘리기보다 명시적 variant, 래퍼 컴포넌트, composition을 우선합니다.
- `useSelector`, `useDispatch`는 프로젝트 타입과 함께 사용합니다.

### AVOID

- 서버 응답을 의미 없이 다시 Redux나 local state에 복사하는 패턴
- 파생 상태를 `useEffect + setState`로 만드는 패턴
- 검증 없이 모든 컴포넌트에 `memo`, `useMemo`, `useCallback` 추가
- 하나의 컴포넌트 안에 UI, API 호출, 라우팅, 전역 상태 갱신, 트래킹을 끝없이 섞는 구조
- `isA`, `isB`, `isC` 같은 boolean prop으로 모드를 계속 늘리는 API

## 기존 코드 예외

- 현재 코드베이스에는 React Query array syntax와 object syntax가 혼재합니다.
- 레거시 컴포넌트는 `useEffect`, `useMemo`, `useCallback`을 비교적 넓게 사용합니다.
- ESLint에서 `react-hooks/exhaustive-deps`가 꺼져 있으므로, effect 의존성은 도구가 아니라 작성자가 직접 검토해야 합니다.
- 기존 코드 수정 시 모든 패턴을 한 번에 현대화하려 하지 말고, 변경 목적과 직접 연결된 부분만 개선합니다.

## 짧은 예시

### 1. 서버 상태는 React Query로 관리

```ts
// good
const { data, isFetched } = useQuery({
    queryKey: ['categoryPlusOne', storeId],
    queryFn: fetchCategory,
    enabled: Boolean(storeId),
    staleTime: 1000 * 60 * 10
});
```

### 2. 파생값을 effect로 만들지 않기

```ts
// bad
const [isSoldOut, setIsSoldOut] = useState(false);

useEffect(() => {
    setIsSoldOut(stock <= 0);
}, [stock]);

// good
const isSoldOut = stock <= 0;
```

### 3. 새 코드에서는 object syntax 우선

```ts
// legacy allowed
const result = useQuery(['banner'], fetchBanner, { staleTime: 1000 });

// new default
const result = useQuery({
    queryKey: ['banner'],
    queryFn: fetchBanner,
    staleTime: 1000
});
```

### 4. boolean prop 증식보다 명시적 컴포넌트

```tsx
// avoid
<Button primary compact danger />

// prefer
<PrimaryButton />
<DangerButton />
```

## 참고

- `src/main/front-app/package.json`
- `src/main/front-app/AGENTS.md`
- `src/main/front-app/src/pages/plusOne/hooks/useCategoryFetch.ts`
- `src/main/front-app/src/common/utils/hooks/useSeoThemeItemFetch.tsx`
- `.agents/skills/vercel-react-best-practices/SKILL.md`
- `/Users/junyongpark/.codex/skills/frontend-programming-principles/SKILL.md`
- [react-patterns](https://github.com/sickn33/antigravity-awesome-skills/blob/main/skills/react-patterns/SKILL.md)
- [cc-skill-frontend-patterns](https://github.com/sickn33/antigravity-awesome-skills/blob/main/skills/cc-skill-frontend-patterns/SKILL.md)

## 결론

React 기본값은 "상태를 올바른 위치에 두고, effect와 memoization을 과용하지 않는 것"입니다.
