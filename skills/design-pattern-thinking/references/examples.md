# TypeScript 실전 예시

아래 예시는 패턴 이름보다 "왜 이 경계를 분리하는가"를 보여주기 위한 샘플이다. 코드 자체를 그대로 복사하기보다, 어떤 압력을 줄이려는지에 집중한다.

## 1. 생성 책임 분리: Factory Method

문제: 결제 수단이 늘어날 때마다 호출자가 구체 구현을 직접 선택하고 초기화 규칙까지 알아야 한다.

```ts
interface PaymentGateway {
  charge(amount: number): Promise<void>;
}

class TossGateway implements PaymentGateway {
  async charge(amount: number) {
    console.log("toss", amount);
  }
}

class PaypalGateway implements PaymentGateway {
  async charge(amount: number) {
    console.log("paypal", amount);
  }
}

class PaymentGatewayFactory {
  static create(provider: "toss" | "paypal"): PaymentGateway {
    switch (provider) {
      case "toss":
        return new TossGateway();
      case "paypal":
        return new PaypalGateway();
    }
  }
}
```

설명:
- 호출자는 어떤 구현을 생성해야 하는지 몰라도 된다.
- 새 구현체 추가 지점이 한 곳으로 모인다.
- 구현이 더 늘어나면 설정 기반 등록이나 Abstract Factory로 확장할 수 있다.

## 2. 런타임 전략 교체: Strategy

문제: 할인 정책이 고객군, 캠페인, 시즌별로 자주 바뀌는데 조건문이 서비스 내부에 퍼져 있다.

```ts
interface DiscountStrategy {
  apply(price: number): number;
}

class FixedDiscount implements DiscountStrategy {
  constructor(private readonly amount: number) {}

  apply(price: number) {
    return Math.max(price - this.amount, 0);
  }
}

class RateDiscount implements DiscountStrategy {
  constructor(private readonly rate: number) {}

  apply(price: number) {
    return price * (1 - this.rate);
  }
}

class CheckoutService {
  constructor(private readonly discountStrategy: DiscountStrategy) {}

  checkout(price: number) {
    return this.discountStrategy.apply(price);
  }
}
```

설명:
- 정책 변경이 `CheckoutService` 내부 분기 증가로 이어지지 않는다.
- 테스트에서 전략만 갈아 끼워 다양한 케이스를 검증할 수 있다.
- 정책 선택 자체가 복잡해지면 Strategy + Factory 조합이 자연스럽다.

## 3. 상태 전이 분리: State

문제: 주문 상태별 허용 동작이 달라지고 취소, 결제, 배송 전이 규칙이 한 클래스에 뒤섞여 있다.

```ts
interface OrderState {
  pay(context: OrderContext): void;
  ship(context: OrderContext): void;
  cancel(context: OrderContext): void;
}

class PendingState implements OrderState {
  pay(context: OrderContext) {
    context.changeState(new PaidState());
  }

  ship() {
    throw new Error("결제 전에는 배송할 수 없습니다.");
  }

  cancel(context: OrderContext) {
    context.changeState(new CancelledState());
  }
}

class PaidState implements OrderState {
  pay() {
    throw new Error("이미 결제되었습니다.");
  }

  ship(context: OrderContext) {
    context.changeState(new ShippedState());
  }

  cancel() {
    throw new Error("배송 전 취소 정책을 확인하세요.");
  }
}

class CancelledState implements OrderState {
  pay() {
    throw new Error("취소된 주문입니다.");
  }

  ship() {
    throw new Error("취소된 주문입니다.");
  }

  cancel() {
    throw new Error("이미 취소되었습니다.");
  }
}

class ShippedState implements OrderState {
  pay() {
    throw new Error("이미 배송되었습니다.");
  }

  ship() {
    throw new Error("이미 배송되었습니다.");
  }

  cancel() {
    throw new Error("배송 후 취소는 반품 절차를 사용하세요.");
  }
}

class OrderContext {
  constructor(private state: OrderState = new PendingState()) {}

  pay() {
    this.state.pay(this);
  }

  ship() {
    this.state.ship(this);
  }

  cancel() {
    this.state.cancel(this);
  }

  changeState(nextState: OrderState) {
    this.state = nextState;
  }
}
```

설명:
- 상태별 규칙과 전이 로직이 각 상태 객체로 모인다.
- 분기문보다 상태별 책임이 선명해진다.
- 상태 수가 2개뿐이면 분기문이 더 단순할 수 있으니 남용하지 않는다.

## 4. 외부 SDK 적응: Adapter

문제: 외부 분석 SDK의 API가 우리 도메인 인터페이스와 맞지 않아 서비스 코드에 SDK 세부사항이 퍼진다.

```ts
interface AnalyticsTracker {
  track(eventName: string, properties: Record<string, unknown>): void;
}

class LegacyAnalyticsSdk {
  send(payload: { name: string; attrs: Record<string, unknown> }) {
    console.log(payload);
  }
}

class AnalyticsAdapter implements AnalyticsTracker {
  constructor(private readonly sdk: LegacyAnalyticsSdk) {}

  track(eventName: string, properties: Record<string, unknown>) {
    this.sdk.send({ name: eventName, attrs: properties });
  }
}
```

설명:
- 서비스 코드는 `AnalyticsTracker`만 알면 된다.
- SDK 교체 비용이 서비스 전반으로 번지지 않는다.
- 인터페이스 정합성 문제라면 Adapter가 맞고, 복잡한 여러 SDK 호출을 감싸 단순 진입점을 만들고 싶다면 Facade를 검토한다.

## 5. 복잡한 하위 시스템 단순화: Facade

문제: 보고서 생성에 조회, 권한 검사, 포맷팅, 업로드가 얽혀 있어 호출자가 절차를 모두 알아야 한다.

```ts
class ReportRepository {
  fetch(reportId: string) {
    return { reportId, rows: [1, 2, 3] };
  }
}

class PermissionService {
  ensureCanRead(userId: string, reportId: string) {
    console.log("permission check", userId, reportId);
  }
}

class CsvFormatter {
  format(data: { reportId: string; rows: number[] }) {
    return `${data.reportId}\n${data.rows.join(",")}`;
  }
}

class StorageClient {
  upload(content: string) {
    return `https://storage.local/${content.length}`;
  }
}

class ReportExportFacade {
  constructor(
    private readonly repository: ReportRepository,
    private readonly permissionService: PermissionService,
    private readonly formatter: CsvFormatter,
    private readonly storageClient: StorageClient
  ) {}

  exportCsv(userId: string, reportId: string) {
    this.permissionService.ensureCanRead(userId, reportId);
    const report = this.repository.fetch(reportId);
    const csv = this.formatter.format(report);
    return this.storageClient.upload(csv);
  }
}
```

설명:
- 호출자는 `exportCsv`만 알면 된다.
- 하위 시스템의 절차적 복잡도가 한 경계 안으로 모인다.
- Facade는 내부 복잡도를 감추는 데 좋지만, 내부 하위 서비스의 세부 책임까지 대신 떠안도록 비대해지지 않게 주의한다.
