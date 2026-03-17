---
name: vanilla-slide-presentation
description: >
  순수 HTML/CSS/JavaScript(외부 라이브러리 없이)로 웹 기반 슬라이드 프레젠테이션을 구현할 때 사용한다.
  사용자가 "슬라이드", "프레젠테이션", "발표자료", "HTML 슬라이드", "웹 슬라이드" 등을 언급하거나
  Reveal.js / Impress.js 같은 라이브러리 없이 직접 구현하고 싶다고 할 때 반드시 이 스킬을 활성화한다.
  단일 HTML 파일로 완성되는 결과물을 목표로 한다.
user-invocable: true
---

# Vanilla Slide Presentation 스킬

외부 라이브러리 없이 순수 웹 표준(HTML/CSS/JS)으로 슬라이드 프레젠테이션을 구현하는 검증된 아키텍처다.

---

## 1. 핵심 아키텍처 원칙

- **단일 HTML 파일** 완결 구조 (CSS/JS 인라인)
- **16:9 비율 고정** + 뷰포트 중앙 배치
- **슬라이드별 전환 효과** — `data-transition` 속성으로 페이지마다 다른 효과
- **WAAPI** (Web Animations API)로 전환 제어 — Promise 기반 완료 감지
- **반응형**: `clamp()` + `cqw` 단위로 미디어쿼리 없이 유체 스케일
- **접근성**: `aria-roledescription`, `aria-hidden`, `aria-live` 적용

---

## 2. HTML 구조

```html
<body>
  <div class="progress-bar"><div class="progress-bar__fill"></div></div>

  <div class="presentation-stage">           <!-- Grid로 중앙 배치 -->
    <main class="slide-canvas">              <!-- 16:9 캔버스 -->

      <section class="slide is-current"
               data-slide-index="0"
               data-transition="slide"       <!-- fade | slide | zoom | flip -->
               aria-roledescription="슬라이드">
        <!-- 슬라이드 콘텐츠 -->
        <aside class="speaker-notes">화자 노트</aside>
      </section>

      <section class="slide"
               data-slide-index="1"
               data-transition="fade"
               aria-hidden="true">
        <!-- ... -->
      </section>

    </main>
  </div>

  <button class="nav-btn nav-btn--prev">‹</button>
  <button class="nav-btn nav-btn--next">›</button>
  <nav class="dot-nav"></nav>
  <output class="slide-counter"></output>
</body>
```

---

## 3. CSS 핵심 패턴

### 3-1. 스테이지 & 16:9 캔버스

```css
/* 뷰포트 중앙 배치 */
.presentation-stage {
  display: grid;
  place-items: center;
  width: 100vw;
  height: 100vh;
  height: 100dvh;  /* 모바일 주소창 대응 */
}

/* 16:9 고정 — aspect-ratio + padding-top 폴백 */
.slide-canvas {
  position: relative;
  width: 100%;
  padding-top: 56.25%;          /* 구형 브라우저 폴백 */
  overflow: hidden;
  container-type: size;
  container-name: canvas;
}
@supports (aspect-ratio: 16/9) {
  .slide-canvas {
    padding-top: 0;
    width: min(100vw, calc(100dvh * 16 / 9));
    aspect-ratio: 16 / 9;
  }
}
```

### 3-2. 슬라이드 기본 상태

```css
.slide {
  position: absolute; inset: 0;
  display: flex; flex-direction: column;
  align-items: center; justify-content: center;
  padding: clamp(1.5rem, 5cqw, 5rem);
  visibility: hidden;        /* 기본: 숨김 */
  pointer-events: none;
  contain: layout style;
}
.slide.is-current {
  visibility: visible;
  pointer-events: auto;
}
```

### 3-3. 반응형 타이포그래피

```css
.slide__title    { font-size: clamp(1.6rem, 6cqw, 4rem); }
.slide__subtitle { font-size: clamp(0.85rem, 2cqw, 1.3rem); }
.slide__body     { font-size: clamp(0.8rem, 1.8cqw, 1.15rem); }
```

---

## 4. 전환 효과 시스템 (`data-transition`)

각 슬라이드에 `data-transition` 속성으로 전환 효과를 지정한다.
**진입하는 슬라이드**의 `data-transition` 값을 기준으로 효과가 결정된다.

| 값 | 효과 |
|----|------|
| `slide` | translateX 슬라이드 인/아웃 (기본값) |
| `fade` | opacity 크로스페이드 |
| `zoom` | scale 확대/축소 + opacity |
| `flip` | perspective rotateY 3D 뒤집기 |

```javascript
#getKeyframes(leaving, entering, dir) {
  const type = entering.dataset.transition || 'slide';
  const fwd  = dir === 'fwd';
  const easing = 'cubic-bezier(0.4,0,0.2,1)';

  switch (type) {
    case 'fade':
      return {
        leave: [{ opacity: 1 }, { opacity: 0 }],
        enter: [{ opacity: 0 }, { opacity: 1 }],
        opts: { duration: 420, easing, fill: 'forwards' },
        willChange: 'opacity',
      };
    case 'zoom':
      return {
        leave: [{ opacity:1, transform:'scale(1)' },
                { opacity:0, transform: fwd ? 'scale(0.85)' : 'scale(1.15)' }],
        enter: [{ opacity:0, transform: fwd ? 'scale(1.15)' : 'scale(0.85)' },
                { opacity:1, transform:'scale(1)' }],
        opts: { duration: 420, easing, fill: 'forwards' },
        willChange: 'transform, opacity',
      };
    case 'flip': {
      const half = 210;
      return {
        leave: [{ transform:'perspective(1200px) rotateY(0deg)', opacity:1 },
                { transform:`perspective(1200px) rotateY(${fwd?-90:90}deg)`, opacity:0 }],
        enter: [{ transform:`perspective(1200px) rotateY(${fwd?90:-90}deg)`, opacity:0 },
                { transform:'perspective(1200px) rotateY(0deg)', opacity:1 }],
        leaveOpts: { duration: half, easing:'ease-in', fill:'forwards' },
        enterOpts: { duration: half, easing:'ease-out', fill:'forwards', delay: half },
        willChange: 'transform, opacity',
      };
    }
    default: // slide
      return {
        leave: [{ transform:'translateX(0)' },
                { transform:`translateX(${fwd?'-100%':'100%'})` }],
        enter: [{ transform:`translateX(${fwd?'100%':'-100%'})` },
                { transform:'translateX(0)' }],
        opts: { duration: 420, easing, fill: 'forwards' },
        willChange: 'transform',
      };
  }
}
```

### WAAPI 전환 실행 패턴

```javascript
async #go(idx, dir) {
  if (this.#busy) return;
  this.#busy = true;

  const leaving  = this.#slides[this.#cur];
  const entering = this.#slides[idx];
  const { leave, enter, opts, leaveOpts, enterOpts, willChange } =
    this.#getKeyframes(leaving, entering, dir);

  leaving.style.willChange = entering.style.willChange = willChange;
  entering.style.visibility = 'visible';
  leaving.style.zIndex  = '1';
  entering.style.zIndex = '2';  /* fade/zoom/flip은 겹쳐야 효과가 보임 */

  const leaveAnim = leaving.animate(leave,   leaveOpts ?? opts);
  const enterAnim = entering.animate(enter,  enterOpts ?? opts);

  await Promise.all([leaveAnim.finished, enterAnim.finished]);

  /* 완료 후 DOM 정리 */
  leaving.classList.remove('is-current');
  leaving.style.cssText = '';           /* willChange, zIndex 일괄 초기화 */
  leaveAnim.cancel();

  entering.classList.add('is-current');
  entering.style.cssText = '';
  enterAnim.cancel();

  this.#cur = idx;
  this.#busy = false;
}
```

---

## 5. 네비게이션 시스템

### 키보드

```javascript
document.addEventListener('keydown', e => {
  if (['INPUT','TEXTAREA'].includes(document.activeElement?.tagName)) return;
  switch (e.key) {
    case 'ArrowRight': case ' ': case 'PageDown': e.preventDefault(); forward(); break;
    case 'ArrowLeft':  case 'PageUp':             e.preventDefault(); backward(); break;
    case 'Home': goTo(0); break;
    case 'End':  goTo(slides.length - 1); break;
    case 'f':    document.documentElement.requestFullscreen?.(); break;
  }
});
```

### 터치 스와이프 (Pointer Events)

```javascript
let sx = 0, dragging = false;
stage.addEventListener('pointerdown', e => { if (e.isPrimary) { sx = e.clientX; dragging = true; }});
stage.addEventListener('pointermove', e => {
  if (!e.isPrimary || !dragging) return;
  // 수직 스크롤 의도 감지 시 취소
  if (Math.abs(e.clientY - sy) > Math.abs(e.clientX - sx) * 1.5) dragging = false;
});
stage.addEventListener('pointerup', e => {
  if (!e.isPrimary || !dragging) return;
  dragging = false;
  const dx = e.clientX - sx;
  if (Math.abs(dx) > 50) dx < 0 ? forward() : backward();
});
```

### URL 해시 동기화

```javascript
// 이동 시: history.replaceState(null, '', `#${currentIndex + 1}`)
// 복원 시: location.hash.match(/^#(\d+)$/)
// 뒤로가기: window.addEventListener('hashchange', ...)
```

---

## 6. Fragment 빌드 효과 (선택적)

슬라이드 내 콘텐츠를 클릭마다 하나씩 등장시키려면 `data-fi` 속성을 사용한다.
**빌드 효과가 필요 없을 때**는 아래 CSS를 추가하면 모든 콘텐츠가 즉시 표시된다.

```css
/* 빌드 효과 OFF — 활성 슬라이드 안에서만 스코프 */
.slide.is-current .fragment {
  opacity: 1 !important;
  visibility: visible !important;
  transform: none !important;
  transition: none !important;
}
```

> ⚠️ `.fragment { visibility: visible !important }` 를 전역으로 적용하면
> 숨겨진 슬라이드의 fragment가 visibility 상속을 뚫고 화면에 겹쳐 보인다.
> **반드시 `.is-current` 스코프 안에 작성한다.**

---

## 7. 접근성 체크리스트

```html
<!-- 슬라이드 -->
<section aria-roledescription="슬라이드"
         aria-label="슬라이드 N / 전체: 제목"
         aria-hidden="true">  <!-- 비활성 슬라이드 -->

<!-- 진행 표시 -->
<output role="status" aria-live="polite">1 / 7</output>

<!-- 스크린리더 전용 알림 -->
<div class="sr-only" aria-live="assertive" id="announcer"></div>
```

```javascript
// 슬라이드 전환 시 스크린리더에 알림
document.getElementById('announcer').textContent = `슬라이드 ${n} / ${total}`;
```

---

## 8. 브라우저 호환성 요약

| 기능 | 지원율 | 폴백 |
|------|--------|------|
| `aspect-ratio` | ~96% | `padding-top: 56.25%` |
| `dvh` 단위 | ~93% | `100vh` 선언 후 덮어쓰기 |
| Container Queries / `cqw` | ~93% | `clamp()` + `vw` |
| Web Animations API | ~97% | CSS transition + transitionend |
| Pointer Events | ~98% | Touch Events 폴백 |

모든 기능은 `@supports` 점진적 강화 패턴으로 작성한다.

---

## 9. 구현 시 주의사항

- **`will-change`**: 애니메이션 직전에만 설정하고 완료 후 즉시 해제. 전체 슬라이드에 고정 적용 시 모바일 OOM 위험.
- **`left/top`** 대신 **`transform`** 사용: reflow 없이 GPU Composite 단계만 사용.
- **`transitionend` 복수 발생**: `opacity`+`transform` 동시 transition 시 이벤트가 두 번 발생. WAAPI `.finished` Promise 사용으로 회피.
- **z-index**: fade/zoom/flip 전환은 두 슬라이드가 겹쳐야 하므로 leaving=1, entering=2 설정. 전환 완료 후 반드시 초기화.
- **`contain: layout style`**: 슬라이드에 적용하여 레이아웃 변경이 다른 슬라이드에 영향 주지 않도록 격리.

---

## 참고 파일

- `references/demo-template.md` — 전체 슬라이드 HTML 템플릿 (복사해서 사용)
