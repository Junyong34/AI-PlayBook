# React 개발 패턴 및 베스트 프랙티스 가이드

이 프로젝트는 React 18, React Query, Rematch(Redux), Emotion이 함께 사용되는 대형 프론트엔드입니다.
이 가이드는 React 개발 시 유용한 패턴과 피해야 할 안티패턴을 제시합니다.

> 이 문서는 React 18 기준입니다. React 19 전용 패턴은 현재 기본 가이드에 포함하지 않습니다.

## 목차

1. [상태 관리 패턴](#상태-관리-패턴)
2. [컴포넌트 설계 패턴](#컴포넌트-설계-패턴)
3. [Hooks 사용 패턴](#hooks-사용-패턴)
4. [성능 최적화 패턴](#성능-최적화-패턴)
5. [안티패턴 (피해야 할 패턴)](#안티패턴-피해야-할-패턴)
6. [코드 예시](#코드-예시)
7. [참고 자료](#참고-자료)

---

## 상태 관리 패턴

### 상태 위치 결정 기준

| 상황 | 기본 위치 | 이유 |
| --- | --- | --- |
| 입력값, 열림/닫힘, hover, 탭 상태 | local state | 컴포넌트 생명주기와 함께 관리 |
| API 조회/캐시/동기화 | React Query | 서버 상태는 클라이언트 상태와 분리 |
| 여러 화면에서 공유되는 클라이언트 상태 | Rematch / Redux | 전역 상태 관리 및 예측 가능한 상태 변경 |

### MUST (필수 규칙)

- **서버 상태는 React Query에 둡니다.**
  - 캐싱, 동기화, 재시도 등을 자동으로 처리
  - Redux/local state로 복사하지 않기
- **새 React Query 코드는 object syntax를 기본값으로 사용합니다.**
- **`useEffect`는 외부 시스템과 동기화할 때만 사용합니다.**
  - 예: WebSocket, DOM API, 써드파티 라이브러리
  - 파생 상태 계산에는 사용하지 않기
- **렌더링 컴포넌트와 복잡한 로직은 분리합니다.**
  - UI 컴포넌트 / 비즈니스 로직 컴포넌트 분리
  - 커스텀 훅으로 로직 추출

### SHOULD (권장 사항)

- **파생값은 먼저 일반 계산으로 해결**
  - 비용이 크거나 참조 안정성이 필요할 때만 `useMemo` 사용
- **이벤트 핸들러는 필요할 때만 `useCallback`**
  - props 안정성이나 리렌더 비용이 실제로 의미 있을 때
- **재사용 로직은 커스텀 훅으로 추출**
  - 조회/변환/이펙트 로직의 재사용성 향상
- **불리언 props 대신 명시적 variant 사용**
  - Composition, 래퍼 컴포넌트 우선

### AVOID (피해야 할 패턴)

- 서버 응답을 Redux나 local state에 중복 저장
- 파생 상태를 `useEffect + setState`로 생성
- 무분별한 `memo`, `useMemo`, `useCallback` 추가
- 하나의 컴포넌트에 너무 많은 책임 부여
- UI, API, 라우팅, 전역 상태, 트래킹 등을 모두 섞지 않기
- `isA`, `isB`, `isC` 같은 boolean prop 증식

---

## 컴포넌트 설계 패턴

### 1. Compound Components (복합 컴포넌트)

관련된 컴포넌트들을 하나의 API로 묶어 사용하는 패턴입니다.

```tsx
// good - 명시적이고 유연한 구조
<Tabs>
  <TabList>
    <Tab>탭 1</Tab>
    <Tab>탭 2</Tab>
  </TabList>
  <TabPanels>
    <TabPanel>내용 1</TabPanel>
    <TabPanel>내용 2</TabPanel>
  </TabPanels>
</Tabs>

// bad - 불투명하고 제한적
<Tabs tabs={[{label: '탭 1', content: '내용 1'}]} />
```

**장점:**
- 유연한 레이아웃 구성
- 명시적인 구조
- 각 하위 컴포넌트의 독립적 커스터마이징

### 2. Headless UI Pattern

UI와 로직을 분리하여 재사용성을 높이는 패턴입니다.

```tsx
// 로직만 제공하는 커스텀 훅
function useDropdown() {
  const [isOpen, setIsOpen] = useState(false);
  const toggle = () => setIsOpen(prev => !prev);
  const close = () => setIsOpen(false);

  return { isOpen, toggle, close };
}

// UI는 사용처에서 자유롭게 구성
function MyDropdown() {
  const { isOpen, toggle, close } = useDropdown();

  return (
    <div>
      <button onClick={toggle}>메뉴</button>
      {isOpen && <div onClick={close}>메뉴 내용</div>}
    </div>
  );
}
```

### 3. Container/Presenter Pattern

비즈니스 로직과 표현 로직을 분리하는 패턴입니다.

```tsx
// Container - 로직 담당
function UserListContainer() {
  const { data, isLoading } = useQuery({
    queryKey: ['users'],
    queryFn: fetchUsers
  });

  if (isLoading) return <Loading />;
  return <UserListPresenter users={data} />;
}

// Presenter - UI만 담당
function UserListPresenter({ users }: { users: User[] }) {
  return (
    <ul>
      {users.map(user => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}
```

### 4. Composition over Configuration

설정보다 조합을 우선하는 패턴입니다.

```tsx
// bad - boolean props 증식
<Button primary large disabled loading />

// good - 명시적 컴포넌트
<PrimaryButton size="large" disabled loading />

// better - composition
<Button variant="primary" size="large">
  {loading ? <Spinner /> : '저장'}
</Button>
```

---

## Hooks 사용 패턴

### 커스텀 훅 설계 원칙

#### 1. 단일 책임 원칙
```tsx
// bad - 너무 많은 책임
function useUserPage() {
  const user = useUser();
  const posts = usePosts();
  const analytics = useAnalytics();
  // ...
}

// good - 각각 분리
function useUser() { /* ... */ }
function usePosts() { /* ... */ }
function useAnalytics() { /* ... */ }
```

#### 2. 명시적 반환 타입
```tsx
// good - 반환 타입 명시
function useToggle(initial = false): {
  isOn: boolean;
  toggle: () => void;
  setOn: () => void;
  setOff: () => void;
} {
  const [isOn, setIsOn] = useState(initial);

  return {
    isOn,
    toggle: () => setIsOn(prev => !prev),
    setOn: () => setIsOn(true),
    setOff: () => setIsOn(false)
  };
}
```

#### 3. useEffect 의존성 관리
```tsx
// bad - 의존성 누락 (react-hooks/exhaustive-deps 꺼져있음)
useEffect(() => {
  fetchData(userId);
}, []); // userId 변경 시 재실행 안됨

// good - 정확한 의존성
useEffect(() => {
  fetchData(userId);
}, [userId]);

// better - React Query로 대체
useQuery({
  queryKey: ['user', userId],
  queryFn: () => fetchData(userId)
});
```

#### 4. Cleanup 함수 패턴
```tsx
// good - cleanup으로 메모리 누수 방지
useEffect(() => {
  const subscription = api.subscribe(userId);

  return () => {
    subscription.unsubscribe();
  };
}, [userId]);
```

### 자주 사용하는 커스텀 훅 패턴

#### 비동기 상태 관리
```tsx
function useAsync<T>(asyncFn: () => Promise<T>) {
  const [state, setState] = useState<{
    status: 'idle' | 'loading' | 'success' | 'error';
    data?: T;
    error?: Error;
  }>({ status: 'idle' });

  const execute = useCallback(async () => {
    setState({ status: 'loading' });
    try {
      const data = await asyncFn();
      setState({ status: 'success', data });
    } catch (error) {
      setState({ status: 'error', error: error as Error });
    }
  }, [asyncFn]);

  return { ...state, execute };
}
```

#### 이전 값 추적
```tsx
function usePrevious<T>(value: T): T | undefined {
  const ref = useRef<T>();

  useEffect(() => {
    ref.current = value;
  }, [value]);

  return ref.current;
}
```

---

## 성능 최적화 패턴

### 1. 메모이제이션 전략

#### useMemo - 언제 사용할까?
```tsx
// bad - 불필요한 useMemo
const fullName = useMemo(() => `${firstName} ${lastName}`, [firstName, lastName]);

// good - 일반 계산으로 충분
const fullName = `${firstName} ${lastName}`;

// good - 비용이 큰 계산
const expensiveValue = useMemo(() => {
  return heavyComputation(data);
}, [data]);

// good - 참조 안정성이 중요한 경우
const filterOptions = useMemo(() => ({
  category: selectedCategory,
  priceRange: priceRange
}), [selectedCategory, priceRange]);
```

#### useCallback - 언제 사용할까?
```tsx
// bad - 불필요한 useCallback
const handleClick = useCallback(() => {
  console.log('clicked');
}, []);

// good - 자식 컴포넌트가 memo되어 있고 props로 전달될 때
const MemoizedChild = memo(Child);

function Parent() {
  const handleClick = useCallback(() => {
    // 복잡한 로직
  }, [dependency]);

  return <MemoizedChild onClick={handleClick} />;
}

// good - useEffect 의존성으로 사용될 때
const fetchData = useCallback(() => {
  api.fetch(userId);
}, [userId]);

useEffect(() => {
  fetchData();
}, [fetchData]);
```

### 2. React.memo 사용 전략
```tsx
// bad - 모든 컴포넌트에 memo
export default memo(SimpleComponent);

// good - props가 자주 변하지 않고, 렌더링 비용이 큰 경우
export default memo(ExpensiveList, (prevProps, nextProps) => {
  return prevProps.items === nextProps.items;
});
```

### 3. 리스트 렌더링 최적화
```tsx
// bad - index를 key로 사용
{items.map((item, index) => <Item key={index} {...item} />)}

// good - 고유한 id 사용
{items.map(item => <Item key={item.id} {...item} />)}

// better - 가상화 라이브러리 사용 (긴 리스트)
import { useVirtualizer } from '@tanstack/react-virtual';

function VirtualList({ items }) {
  const virtualizer = useVirtualizer({
    count: items.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 50
  });

  // ...
}
```

### 4. Code Splitting
```tsx
// lazy loading
const HeavyComponent = lazy(() => import('./HeavyComponent'));

function App() {
  return (
    <Suspense fallback={<Loading />}>
      <HeavyComponent />
    </Suspense>
  );
}
```

---

## 안티패턴 (피해야 할 패턴)

### 1. Prop Drilling
```tsx
// bad - 5단계 prop 전달
<A user={user}>
  <B user={user}>
    <C user={user}>
      <D user={user}>
        <E user={user} />
      </D>
    </C>
  </B>
</A>

// good - Context 사용
const UserContext = createContext<User | null>(null);

function App() {
  return (
    <UserContext.Provider value={user}>
      <A />
    </UserContext.Provider>
  );
}

function E() {
  const user = useContext(UserContext);
  return <div>{user?.name}</div>;
}
```

### 2. Context 과용
```tsx
// bad - 너무 많은 Context
<ThemeContext>
  <UserContext>
    <AuthContext>
      <LanguageContext>
        <NotificationContext>
          <App />
        </NotificationContext>
      </LanguageContext>
    </AuthContext>
  </UserContext>
</ThemeContext>

// better - 관련된 것끼리 묶거나, 전역 상태 관리 도구 사용
<AppProvider> {/* Theme, Language 등 통합 */}
  <App />
</AppProvider>
```

### 3. 파생 상태를 useEffect로 생성
```tsx
// bad
const [fullName, setFullName] = useState('');

useEffect(() => {
  setFullName(`${firstName} ${lastName}`);
}, [firstName, lastName]);

// good
const fullName = `${firstName} ${lastName}`;
```

### 4. 서버 상태 중복 저장
```tsx
// bad
const { data } = useQuery({ queryKey: ['users'], queryFn: fetchUsers });

useEffect(() => {
  if (data) {
    dispatch(setUsers(data)); // Redux에 중복 저장
  }
}, [data]);

// good - React Query 상태를 직접 사용
const { data: users } = useQuery({
  queryKey: ['users'],
  queryFn: fetchUsers
});
```

### 5. useState 초기값으로 props 사용
```tsx
// bad - props 변경이 반영 안됨
function Component({ initialValue }: { initialValue: number }) {
  const [value, setValue] = useState(initialValue);
  // initialValue가 바뀌어도 value는 안 바뀜
}

// good - controlled component
function Component({ value, onChange }: {
  value: number;
  onChange: (v: number) => void;
}) {
  return <input value={value} onChange={e => onChange(+e.target.value)} />;
}

// or - key로 리셋
<Component key={userId} initialValue={user.score} />
```

### 6. 무한 리렌더링 함정
```tsx
// bad - 매 렌더마다 새 객체 생성
function Component() {
  return <Child config={{ theme: 'dark' }} />; // 매번 새 객체
}

// good
const config = { theme: 'dark' }; // 컴포넌트 밖으로
function Component() {
  return <Child config={config} />;
}

// or
function Component() {
  const config = useMemo(() => ({ theme: 'dark' }), []);
  return <Child config={config} />;
}
```

### 7. useEffect 남용
```tsx
// bad - 이벤트 핸들러로 충분
useEffect(() => {
  if (submitted) {
    navigate('/success');
  }
}, [submitted]);

// good
function handleSubmit() {
  setSubmitted(true);
  navigate('/success');
}
```

## 기존 코드 예외

- 현재 코드베이스에는 React Query array syntax와 object syntax가 혼재합니다.
- 레거시 컴포넌트는 `useEffect`, `useMemo`, `useCallback`을 비교적 넓게 사용합니다.
- ESLint에서 `react-hooks/exhaustive-deps`가 꺼져 있으므로, effect 의존성은 도구가 아니라 작성자가 직접 검토해야 합니다.
- 기존 코드 수정 시 모든 패턴을 한 번에 현대화하려 하지 말고, 변경 목적과 직접 연결된 부분만 개선합니다.
