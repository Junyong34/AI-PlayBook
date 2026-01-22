---
name: coding-standards
description: TypeScript, JavaScript, React, Node.js 개발을 위한 범용 코딩 표준, 모범 사례 및 패턴
---

# 코딩 표준 및 모범 사례

모든 프로젝트에 적용 가능한 범용 코딩 표준입니다.

## 코드 품질 원칙

### 1. 가독성 우선 (Readability First)
- 코드는 작성보다 읽히는 횟수가 더 많습니다
- 명확한 변수명과 함수명 사용
- 주석보다 자체 문서화 코드를 선호
- 일관된 포매팅 유지

### 2. KISS (Keep It Simple, Stupid - 단순하게 유지하라)
- 작동하는 가장 단순한 솔루션 선택
- 과도한 엔지니어링 지양
- 조기 최적화 금지
- 이해하기 쉬운 코드 > 영리한 코드

### 3. DRY (Don't Repeat Yourself - 반복하지 마라)
- 공통 로직을 함수로 추출
- 재사용 가능한 컴포넌트 생성
- 모듈 간 유틸리티 공유
- 복사-붙여넣기 프로그래밍 지양

### 4. YAGNI (You Aren't Gonna Need It - 필요하지 않을 것이다)
- 필요하기 전에 기능을 구축하지 않음
- 추측성 일반화 지양
- 필요할 때만 복잡성 추가
- 단순하게 시작하고, 필요할 때 리팩토링

## TypeScript/JavaScript 표준

### 변수 명명 규칙

```typescript
// ✅ 좋은 예: 설명적인 이름
const marketSearchQuery = 'election'
const isUserAuthenticated = true
const totalRevenue = 1000

// ❌ 나쁜 예: 불명확한 이름
const q = 'election'
const flag = true
const x = 1000
```

### 함수 명명 규칙

```typescript
// ✅ 좋은 예: 동사-명사 패턴
async function fetchMarketData(marketId: string) { }
function calculateSimilarity(a: number[], b: number[]) { }
function isValidEmail(email: string): boolean { }

// ❌ 나쁜 예: 불명확하거나 명사만 사용
async function market(id: string) { }
function similarity(a, b) { }
function email(e) { }
```

### 불변성 패턴 (중요)

```typescript
// ✅ 항상 스프레드 연산자 사용
const updatedUser = {
  ...user,
  name: 'New Name'
}

const updatedArray = [...items, newItem]

// ❌ 절대 직접 변경하지 말 것
user.name = 'New Name'  // 나쁨
items.push(newItem)     // 나쁨
```

### 에러 처리

```typescript
// ✅ 좋은 예: 포괄적인 에러 처리
async function fetchData(url: string) {
  try {
    const response = await fetch(url)

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`)
    }

    return await response.json()
  } catch (error) {
    console.error('Fetch failed:', error)
    throw new Error('Failed to fetch data')
  }
}

// ❌ 나쁜 예: 에러 처리 없음
async function fetchData(url) {
  const response = await fetch(url)
  return response.json()
}
```

### Async/Await 모범 사례

```typescript
// ✅ 좋은 예: 가능한 경우 병렬 실행
const [users, markets, stats] = await Promise.all([
  fetchUsers(),
  fetchMarkets(),
  fetchStats()
])

// ❌ 나쁜 예: 불필요하게 순차 실행
const users = await fetchUsers()
const markets = await fetchMarkets()
const stats = await fetchStats()
```

### 타입 안정성

```typescript
// ✅ 좋은 예: 적절한 타입 정의
interface Market {
  id: string
  name: string
  status: 'active' | 'resolved' | 'closed'
  created_at: Date
}

function getMarket(id: string): Promise<Market> {
  // 구현
}

// ❌ 나쁜 예: 'any' 사용
function getMarket(id: any): Promise<any> {
  // 구현
}
```

## React 모범 사례

### 컴포넌트 구조

```typescript
// ✅ 좋은 예: 타입이 정의된 함수형 컴포넌트
interface ButtonProps {
  children: React.ReactNode
  onClick: () => void
  disabled?: boolean
  variant?: 'primary' | 'secondary'
}

export function Button({
  children,
  onClick,
  disabled = false,
  variant = 'primary'
}: ButtonProps) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`btn btn-${variant}`}
    >
      {children}
    </button>
  )
}

// ❌ 나쁜 예: 타입 없고 불명확한 구조
export function Button(props) {
  return <button onClick={props.onClick}>{props.children}</button>
}
```

### 커스텀 훅

```typescript
// ✅ 좋은 예: 재사용 가능한 커스텀 훅
export function useDebounce<T>(value: T, delay: number): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value)

  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedValue(value)
    }, delay)

    return () => clearTimeout(handler)
  }, [value, delay])

  return debouncedValue
}

// 사용 예시
const debouncedQuery = useDebounce(searchQuery, 500)
```

### 상태 관리

```typescript
// ✅ 좋은 예: 올바른 상태 업데이트
const [count, setCount] = useState(0)

// 이전 상태를 기반으로 하는 함수형 업데이트
setCount(prev => prev + 1)

// ❌ 나쁜 예: 직접 상태 참조
setCount(count + 1)  // 비동기 시나리오에서 오래된 값 참조 가능
```

### 조건부 렌더링

```typescript
// ✅ 좋은 예: 명확한 조건부 렌더링
{isLoading && <Spinner />}
{error && <ErrorMessage error={error} />}
{data && <DataDisplay data={data} />}

// ❌ 나쁜 예: 삼항 연산자 중첩 지옥
{isLoading ? <Spinner /> : error ? <ErrorMessage error={error} /> : data ? <DataDisplay data={data} /> : null}
```


### 파일 명명 규칙

```
components/Button.tsx          # 컴포넌트는 PascalCase
hooks/useAuth.ts              # 훅은 'use' 접두사와 camelCase
lib/formatDate.ts             # 유틸리티는 camelCase
types/market.types.ts         # 타입은 camelCase + .types 접미사
```

## 주석 및 문서화

### 주석 작성 시점

```typescript
// ✅ 좋은 예: 무엇(WHAT)이 아닌 왜(WHY)를 설명
// 장애 시 API 과부하를 방지하기 위해 지수 백오프 사용
const delay = Math.min(1000 * Math.pow(2, retryCount), 30000)

// 대용량 배열의 성능을 위해 의도적으로 변경(mutation) 사용
items.push(newItem)

// ❌ 나쁜 예: 자명한 내용을 설명
// 카운터를 1 증가
count++

// 사용자 이름을 name에 설정
name = user.name
```



### 지연 로딩 (Lazy Loading)

```typescript
import { lazy, Suspense } from 'react'

// ✅ 좋은 예: 무거운 컴포넌트 지연 로딩
const HeavyChart = lazy(() => import('./HeavyChart'))

export function Dashboard() {
  return (
    <Suspense fallback={<Spinner />}>
      <HeavyChart />
    </Suspense>
  )
}
```
## 코드 스멜 감지

다음 안티 패턴들을 주의하세요:

### 1. 긴 함수
```typescript
// ❌ 나쁜 예: 50줄 이상의 함수
function processMarketData() {
  // 100줄의 코드
}

// ✅ 좋은 예: 작은 함수로 분리
function processMarketData() {
  const validated = validateData()
  const transformed = transformData(validated)
  return saveData(transformed)
}
```

### 2. 깊은 중첩
```typescript
// ❌ 나쁜 예: 5단계 이상의 중첩
if (user) {
  if (user.isAdmin) {
    if (market) {
      if (market.isActive) {
        if (hasPermission) {
          // 작업 수행
        }
      }
    }
  }
}

// ✅ 좋은 예: 조기 반환
if (!user) return
if (!user.isAdmin) return
if (!market) return
if (!market.isActive) return
if (!hasPermission) return

// 작업 수행
```

### 3. 매직 넘버
```typescript
// ❌ 나쁜 예: 설명되지 않은 숫자
if (retryCount > 3) { }
setTimeout(callback, 500)

// ✅ 좋은 예: 명명된 상수
const MAX_RETRIES = 3
const DEBOUNCE_DELAY_MS = 500

if (retryCount > MAX_RETRIES) { }
setTimeout(callback, DEBOUNCE_DELAY_MS)
```

**기억하세요**: 코드 품질은 타협할 수 없습니다. 명확하고 유지보수 가능한 코드는 빠른 개발과 자신감 있는 리팩토링을 가능하게 합니다.
