# 컴포넌트 및 페이지 emotion style 가이드

## 왜 필요한가

이 프로젝트는 `@emotion/react`, `@emotion/styled`, `Global` 스타일, Mantine을 함께 사용합니다.
문서 목적은 "emotion을 어디에 어떻게 쓰는가"를 새 코드 기본값으로 고정해 리뷰 비용과 변경 리스크를 줄이는 것입니다.

이 레포의 설정과 코드 패턴을 우선합니다.

## 새 코드 기본값

### MUST

- Mantine UI 라이브러리는 `src/cms`, `src/pages/cms` 디렉토리 하위에서만 사용합니다. 그 외 영역은 `src/components`의 기존 컴포넌트를 재사용하거나 emotion으로 스타일링합니다.
- 컴포넌트 파일은 `PascalCase.tsx`, 훅/유틸은 `camelCase.ts`, 상수는 `UPPER_SNAKE_CASE`를 사용합니다.
- import 경로에는 확장자를 붙이지 않습니다.
- `archive` 폴더는 import 하지 않습니다. 재사용이 필요하면 새 파일로 복사한 뒤 현재 구조에 맞게 정리합니다.
- 재사용되는 UI 뼈대, variant가 있는 컴포넌트, 스타일 props가 필요한 컴포넌트는 `styled`를 우선합니다.
- 한 화면 안에서만 쓰이는 조합 스타일, 상태 기반 덮어쓰기, 조건부 스타일 결합은 `css` prop을 우선합니다.
- 반응형 기준은 `src/main/front-app/src/static/styles/variable.ts`의 `mediaWidth.mobile`, `mediaWidth.desktop`을 기본값으로 사용합니다.
- 전역 스타일은 `src/main/front-app/src/App.tsx`와 `src/main/front-app/src/static/styles/*` 수준에서만 관리합니다. 일반 컴포넌트에서 앱 전역 selector를 새로 만들지 않습니다.
- 스타일은 컴포넌트 책임과 가깝게 둡니다. 단일 컴포넌트면 같은 파일, 여러 컴포넌트가 공유하면 인접한 `style.ts`, `*.style.ts`, `*.styles.ts` 파일로 분리합니다.

### SHOULD

- 스타일 이름은 `wrapperStyle`, `headerStyle`, `StickyPanel`, `TooltipBody`처럼 역할 중심으로 짓습니다.
- 조건부 스타일은 `css={[baseStyle, isActive && activeStyle]}`처럼 조합이 보이는 방식으로 작성합니다. (classnames 라이브러리 사용 하지 않는다.)
- 선택자 깊이는 얕게 유지합니다. pseudo class, pseudo element, 컴포넌트 내부 상태 수준의 중첩까지만 우선 허용합니다.
- 공용 스타일 승격은 실제 재사용이 생긴 뒤에만 진행합니다. 한 페이지에서만 쓰는 스타일을 먼저 전역 유틸로 빼지 않습니다.
- 스타일용 props를 둘 때는 컴포넌트 API로 의미가 분명해야 하며, DOM까지 흘러가지 않도록 주의합니다.
- 기존 파일 문맥상 `style.ts` 계열 분리가 이미 정착한 위치라면 그 패턴을 따릅니다.

### AVOID

- 새 코드에서 `../../../../` 식의 깊은 상대 경로 확장
- 의미가 불분명한 파일명(`index2.tsx`, `temp.ts`, `utilsNew.ts`)
- SCSS/BEM 규칙을 emotion 기본 규칙처럼 문서화하거나 그대로 복제하는 것
- 숫자 브레이크포인트를 컴포넌트마다 직접 쓰는 것
- 깊은 후손 selector, 광범위한 태그 selector, 컴포넌트 경계를 넘는 전역성 selector 남용
- 스타일 블록 안에 비즈니스 규칙을 숨기는 패턴
- 스타일 전용 props를 필터링 없이 DOM에 전달하는 패턴
- 한 화면 전용 스타일을 성급하게 `common.ts`나 전역 스타일로 올리는 것
- 포맷터가 정리할 내용을 별도 수기 규칙으로 운영하는 것

### Component Style File

- 스타일 파일을 분리할 때는 현재 영역 관례를 따릅니다. 컴포넌트 폴더는 `Component.tsx + Component.style.ts (+ Component.types.ts)` 형태를 우선하고, 페이지 단위는 기존처럼 `style.ts`를 사용할 수 있습니다.
- 스타일 파일에는 `styled` 컴포넌트, 재사용 가능한 `css` 블록, 스타일 관련 타입만 둡니다. 비즈니스 로직과 데이터 가공은 넣지 않습니다.
- 파일이 매우 작고 스타일 책임이 단순하면 컴포넌트 파일 내부에 `css` 상수를 같이 둬도 됩니다.

```tsx
// ProductCard.style.ts
import { css } from '@emotion/react';
import styled from '@emotion/styled';
import type { ProductCardProps } from './ProductCard.types';

export const ProductCardRoot = styled.article<Pick<ProductCardProps, 'selected'>>`
    border: 1px solid ${(props) => (props.selected ? '#111' : '#ddd')};
    background: #fff;
`;

export const priceStyle = css`
    font-weight: 700;
`;
```

### Basic Usage

- 재사용 가능한 UI 본체는 `styled`, 현재 화면에서만 붙는 배치/상태 스타일은 `css` prop으로 나눠 씁니다.
- 기본 hover, focus, disabled 같은 상태 처리는 컴포넌트 선언 안에서 같이 정의합니다.
- 스타일 목적이 명확한 작은 단위로 나누고, 한 선언에 너무 많은 책임을 넣지 않습니다.

```tsx
import styled from '@emotion/styled';

export const Button = styled.button`
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 8px 16px;
    border: none;
    border-radius: 4px;
    background: #111;
    color: #fff;
    cursor: pointer;

    &:hover {
        background: #000;
    }

    &:disabled {
        opacity: 0.5;
        cursor: not-allowed;
    }
`;
```

### Styling

- 반복되는 스타일 조각은 `css` 헬퍼로 분리해 `styled`와 `css` prop 양쪽에서 재사용합니다.
- props 기반 스타일 분기는 필요한 variant와 state만 노출합니다. boolean prop이 계속 늘어나면 variant 문자열이나 별도 컴포넌트로 재구성합니다.
- 반응형 스타일은 `mediaWidth.mobile`, `mediaWidth.desktop`을 조합해 선언합니다.

```tsx
import { css } from '@emotion/react';
import styled from '@emotion/styled';

const ellipsisStyle = css`
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
`;

export const Title = styled.h2<{ emphasized?: boolean }>`
    ${ellipsisStyle}
    color: ${(props) => (props.emphasized ? '#111' : '#666')};
`;
```

### Extending Components

- 공통 베이스가 분명할 때만 `styled(BaseComponent)`로 확장합니다.
- 확장이 2~3단계를 넘기기 시작하면 상속보다 composition이나 variant prop으로 다시 정리합니다.
- 라우터 링크, 공용 버튼처럼 동작은 유지하고 겉모습만 바꾸고 싶을 때 확장이 유효합니다.

```tsx
import styled from '@emotion/styled';

const BaseButton = styled.button`
    padding: 8px 16px;
    border-radius: 4px;
`;

export const PrimaryButton = styled(BaseButton)`
    background: #111;
    color: #fff;
`;
```

### Animations

- 애니메이션은 `@emotion/react`의 `keyframes`를 사용합니다.
- 기본값은 `opacity`, `transform` 중심의 짧은 애니메이션입니다. 레이아웃을 흔드는 `width`, `height`, `top`, `left` 중심 애니메이션은 기본값으로 두지 않습니다.
- 반복 애니메이션은 로딩, 강조점 같은 명확한 목적이 있을 때만 사용합니다.

```tsx
import { keyframes } from '@emotion/react';
import styled from '@emotion/styled';

const fadeIn = keyframes`
    from {
        opacity: 0;
        transform: translateY(4px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
`;

export const FadeInPanel = styled.div`
    animation: ${fadeIn} 0.2s ease-out;
`;
```

### Transition

- `transition: all`보다 실제로 바뀌는 속성만 명시합니다.
- 열림/닫힘 UI는 `opacity`, `transform`, `visibility` 조합을 우선합니다.
- hover 전환 시간은 짧게 유지하고, 모달/패널 같은 상태 전환은 enter/exit가 읽히는 수준까지만 둡니다.

```tsx
import styled from '@emotion/styled';

export const ModalLayer = styled.div<{ open: boolean }>`
    opacity: ${(props) => (props.open ? 1 : 0)};
    visibility: ${(props) => (props.open ? 'visible' : 'hidden')};
    transform: ${(props) => (props.open ? 'scale(1)' : 'scale(0.98)')};
    transition:
        opacity 0.2s ease,
        visibility 0.2s ease,
        transform 0.2s ease;
`;
```

### Performance Optimization

- 정적인 값은 템플릿 리터럴 안에 그대로 씁니다. 불필요한 interpolation은 줄입니다.
- `styled(...)` 선언과 큰 `css` 블록 생성은 render 함수 바깥에 둡니다.
- 드래그, 스크롤, progress처럼 값이 매우 자주 바뀌는 스타일은 Emotion class를 계속 새로 만들기보다 CSS 변수나 inline `style`로 넘기는 편이 낫습니다.
- 공용 스타일은 실제 재사용 이후에만 추출하고, 너무 이른 추출로 파일 탐색 비용을 늘리지 않습니다.

```tsx
import { css } from '@emotion/react';

const progressBarStyle = css`
    height: 4px;
    background: #111;
`;

function ProgressBar({ width }: { width: number }): JSX.Element {
    return <div css={progressBarStyle} style={{ width }} />;
}
```

### Best Practices

- 스타일 컴포넌트는 작고 집중된 책임을 가져야 합니다.
- semantic tag와 역할 중심 이름을 우선합니다. `StyledDiv1` 같은 이름은 피합니다.
- 깊은 selector 체인보다 작은 스타일 조각과 composition을 우선합니다.
- 전역 스타일은 `App.tsx`와 `src/static/styles/*`에만 두고, 일반 화면 코드에서는 지역 스타일을 기본값으로 사용합니다.
- 접근성 스타일을 기본으로 포함합니다. `:focus-visible`, 충분한 클릭 영역, `ir` 같은 시각적 숨김 패턴 재사용을 우선합니다.
- 텍스트 요소에서 `font-size`를 직접 선언할 때는 `line-height`도 함께 선언합니다.
- 스타일 테스트가 정말 중요할 때만 Emotion serializer나 style assertion을 사용하고, 기본값은 사용자에게 보이는 동작과 상태를 먼저 검증합니다.

## 기존 코드 예외

- 현재 코드베이스에는 `style.ts`, `*.style.ts`, `*.styles.ts`가 혼재합니다.
- 레거시 영역에는 `className + nested selector` 패턴이 많이 남아 있습니다.
- 일부 파일은 `jsx`를 `@emotion/react`에서 함께 import하는 오래된 패턴을 유지합니다.
- 페이지 단위의 큰 스타일 파일과 긴 nested selector도 실제로 존재합니다.
- 오래된 파일을 작게 수정할 때는 전체 스타일 구조를 한 번에 현대화하기보다 현재 변경을 안전하게 끝내는 것이 우선일 수 있습니다.
- 다만 새 파일이나 큰 수정에서는 위 `새 코드 기본값`을 따르고, 레거시 패턴을 새 코드에 복제하지 않습니다.
- 레거시 코드를 수정하는 경우 리팩토링 진행합니다.

## 짧은 예시

### 1. `styled`와 `css` prop 역할 분리

```tsx
import { css } from '@emotion/react';
import styled from '@emotion/styled';

const Card = styled.section<{ selected: boolean }>`
    border: 1px solid ${(props) => (props.selected ? '#111' : '#ddd')};
    background: #fff;
`;

const bodyStyle = css`
    display: flex;
    flex-direction: column;
    gap: 8px;
`;

export default function ProductCard(): JSX.Element {
    return (
        <Card selected={false}>
            <div css={bodyStyle}>...</div>
        </Card>
    );
}
```

### 2. 조건부 스타일은 배열 조합으로 드러내기

```tsx
import { css } from '@emotion/react';

const tabStyle = css`
    color: #666;
`;

const activeTabStyle = css`
    color: #111;
    font-weight: 700;
`;

function Tab({ active }: { active: boolean }): JSX.Element {
    return <button css={[tabStyle, active && activeTabStyle]}>탭</button>;
}
```

### 3. 반응형은 `mediaWidth` 기본값 사용

```ts
import { css } from '@emotion/react';
import { mediaWidth } from '@styles/variable';

export const wrapperStyle = css`
    padding: 16px;

    ${mediaWidth.desktop} {
        padding: 24px;
    }

    ${mediaWidth.mobile} {
        padding: 12px;
    }
`;
```

### 4. 레거시 class selector는 새 기본값으로 복제하지 않기

```tsx
// legacy allowed
const legacyStyle = css`
    .title {
        font-size: 18px;
    }
`;

// new default
const titleStyle = css`
    font-size: 18px;
`;

function Title(): JSX.Element {
    return <strong css={titleStyle}>제목</strong>;
}
```

## 결론

이 레포의 emotion 기본값은 `styled`와 `css` prop을 역할별로 나누고, 전역성 및 레거시성 스타일의 확산을 막는 것입니다.
