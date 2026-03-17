# TypeScript 가이드

## 왜 필요한가

이 문서는 TypeScript 스킬 본문이 아니라 `프로젝트`에서 빠르게 참고하는 압축형 기준 문서입니다.
긴 타입 이론을 다시 설명하기보다, 새 코드에서 무엇을 기본값으로 삼을지 빨리 판단하게 하는 데 목적이 있습니다.
자주 쓰는 타입 설계 원칙과 `bad -> good` 예제를 본문 안에 최대한 모아둡니다.

## 새 코드 기본값

### MUST

- 새 코드는 strict 모드 통과를 기본값으로 작성합니다.
- 구현보다 타입 계약을 먼저 정합니다. 데이터 모델, 함수 시그니처, 상태 shape를 먼저 만들고 구현은 그 계약을 만족시키는 방향으로 작성합니다.
- API 응답, 브라우저 입력, 서드파티 데이터처럼 외부 입력 경계는 바로 믿지 말고 `unknown`에서 시작해 narrowing 후 사용합니다.
- 공개 함수, 커스텀 훅, 재사용 유틸은 반환 타입을 명시해 고정합니다.
- `RootState`, `Dispatcher`처럼 프로젝트 공통 타입을 기준으로 상태와 액션을 타이핑합니다.
- DTO와 화면 전용 모델은 같은 의미로 취급하지 말고, 필요하면 매핑 단계를 둡니다.

### SHOULD

- 지역 변수와 단순 표현식은 타입 추론을 우선합니다.
- 객체 계약과 확장은 `interface`, 유니온·매핑·조합은 `type`으로 표현합니다.
- 문자열 상수 집합은 `as const`와 리터럴 유니온으로 관리합니다.
- `Partial`, `Pick`, `Omit`, `Record`, `ReturnType` 같은 내장 유틸리티 타입을 먼저 사용합니다.
- 조건부 타입, 매핑된 타입, 템플릿 리터럴 타입 같은 고급 타입은 반복되는 패턴일 때만 추출합니다.
- 식별자, 상태, 가격, 표시명처럼 도메인에서 중요한 개념은 `string`, `number`로 흘리지 말고 의미 있는 타입 이름을 먼저 부여합니다.
- 생성/수정/조회 모델은 한 타입으로 뭉개지 말고 단계별로 분리합니다. optional은 "없을 수도 있음"이 실제로 맞을 때만 둡니다.
- 상호 배타적인 상태는 boolean 조합보다 판별 유니온으로 모델링하고, 분기에서는 exhaustive check를 사용합니다.
- 불필요한 `?` 사용은 제거하고 해당 타입을 사용하는 코드 리팩토링도 함께 진행합니다.

### AVOID

- 새 코드에 의미 없는 `any` 추가
- 설명 없는 `as SomeType` 연쇄 사용
- 안전성 검토 없이 `!`로 null 가능성 제거
- `userId: string`, `price: number`처럼 의미가 다른 값을 전부 같은 원시 타입으로만 두는 설계
- `loading?: boolean`, `error?: Error`, `data?: T`처럼 불법 상태를 허용하는 상태 모델
- 한 번만 쓰는 복잡한 제네릭 유틸 추상화
- 깊게 중첩된 조건부 타입, 재귀 타입처럼 IDE와 컴파일 비용을 키우는 과한 타입 퍼즐
- 화면 로직 안에서 API 응답 타입을 그대로 재조합하며 의미를 섞는 패턴
- 본문 가이드 안에 긴 타입 퍼즐이나 문법 해설을 계속 누적하는 것

## 기존 코드 예외

- 기존 코드에 `any`, `!`, 반환 타입 생략이 있어도 수정 범위를 불필요하게 넓히지 않는 것이 더 중요할 수 있습니다.
- 다만 새 코드에서는 기존 예외를 기본값처럼 복제하지 않습니다.

## 짧은 예시

### 1. `any` 대신 `unknown + guard`

```ts
// bad
function getValue(data: any) {
  return data.value;
}

// good
function getValue(data: unknown): number {
  if (typeof data === "object" && data !== null && "value" in data) {
    return Number((data as { value: number }).value);
  }

  throw new Error("Invalid data");
}
```

### 2. 공개 훅과 재사용 유틸은 반환 타입을 고정

```ts
export function useIsAdult(age?: number): boolean {
  return Boolean(age && age >= 19);
}

export function toPriceText(price?: number): string {
  return price == null ? "-" : price.toLocaleString();
}
```

### 3. 도메인 핵심 값은 의미 있는 타입 이름으로 드러내기

```ts
// bad
function updateProfile(id: string, name: string) {
  // id가 UserId인지 ProfileId인지 알기 어렵다.
}

// good
type ProfileId = string;
type DisplayName = string;

function updateProfile(id: ProfileId, name: DisplayName) {
  // 함수 시그니처 자체가 문서 역할을 한다.
}
```

### 4. 불법 상태는 판별 유니온으로 막기

```ts
// bad
type RequestState<T> = {
  loading: boolean;
  data?: T;
  error?: Error;
};

// good
type RequestState<T> =
  | { status: "idle" }
  | { status: "loading" }
  | { status: "success"; data: T }
  | { status: "error"; error: Error };
```

### 5. optional은 단계별 모델 분리로 줄이기

```ts
// bad
type UserForm = {
  id?: string;
  email?: string;
  name?: string;
};

// good
type CreateUserInput = {
  email: string;
  name: string;
};

type UpdateUserInput = Partial<CreateUserInput>;

type User = CreateUserInput & {
  id: string;
  createdAt: Date;
};
```

### 6. DTO와 화면 모델은 매핑 단계로 분리

```ts
type ProductCardModel = {
  id: string;
  name: string;
  priceText: string;
};

function toProductCardModel(dto: ProductDto): ProductCardModel {
  return {
    id: String(dto.itemId),
    name: dto.itemNm,
    priceText: dto.frontDcPriceInfo?.salePriceText ?? "-",
  };
}
```

### 7. `as const`로 런타임 상수와 타입을 함께 관리

```ts
const ORDER_STATUS = {
  READY: "READY",
  PAID: "PAID",
  CANCELED: "CANCELED",
} as const;

type OrderStatus = (typeof ORDER_STATUS)[keyof typeof ORDER_STATUS];
```

### 8. 상태 분기는 `never`로 빠진 케이스를 막기

```ts
function renderStatus(status: OrderStatus): string {
  switch (status) {
    case "READY":
      return "준비 중";
    case "PAID":
      return "결제 완료";
    case "CANCELED":
      return "취소됨";
    default: {
      const exhaustive: never = status;
      throw new Error(`Unhandled status: ${exhaustive}`);
    }
  }
}
```




