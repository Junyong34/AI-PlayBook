# Vanilla Slide Presentation — 전체 HTML 템플릿

이 파일을 복사해 슬라이드를 만들 때 시작점으로 사용한다.
슬라이드 추가 시 `<!-- SLIDE N -->` 블록을 복사하고 `data-slide-index`, `data-transition`, `aria-label`만 수정하면 된다.

---

## 슬라이드 전환 효과 목록

| `data-transition` 값 | 효과 |
|----------------------|------|
| `slide` | translateX 슬라이드 인/아웃 (기본값) |
| `fade` | opacity 크로스페이드 |
| `zoom` | scale 확대/축소 + opacity |
| `flip` | perspective rotateY 3D 뒤집기 |

## 배경 테마 클래스

| 클래스 | 배경 |
|--------|------|
| `slide--dark` | 단색 어두운 배경 |
| `slide--blue` | 파란 그라디언트 |
| `slide--purple` | 보라 그라디언트 |
| `slide--green` | 초록 그라디언트 |
| `slide--accent` | 인디고 그라디언트 |

---

## 전체 템플릿

```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>슬라이드 제목</title>
  <style>
    /* ── Reset ── */
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    html, body { width: 100%; height: 100%; overflow: hidden; background: #0d0d1a; font-family: 'Segoe UI', system-ui, sans-serif; }

    /* ── 진행 표시바 ── */
    .progress-bar { position: fixed; top: 0; left: 0; width: 100%; height: 4px; z-index: 200; background: rgba(255,255,255,0.1); }
    .progress-bar__fill { height: 100%; background: linear-gradient(90deg, #4f8ef7, #a855f7); width: 0%; transition: width 0.4s ease; }

    /* ── 슬라이드 번호 ── */
    .slide-counter { position: fixed; bottom: 1.25rem; right: 1.75rem; color: rgba(255,255,255,0.45); font-size: 0.8rem; letter-spacing: 0.1em; z-index: 200; }
    .slide-counter span { color: #fff; font-weight: 700; }

    /* ── 키 힌트 ── */
    .key-hint { position: fixed; bottom: 1.25rem; left: 1.75rem; color: rgba(255,255,255,0.3); font-size: 0.72rem; letter-spacing: 0.05em; z-index: 200; }

    /* ── 스테이지 ── */
    .presentation-stage { display: grid; place-items: center; width: 100vw; height: 100vh; height: 100dvh; }

    /* ── 슬라이드 캔버스 (16:9) ── */
    .slide-canvas { position: relative; width: 100%; padding-top: 56.25%; overflow: hidden; container-type: size; container-name: canvas; border-radius: 8px; box-shadow: 0 32px 80px rgba(0,0,0,0.6); }
    @supports (aspect-ratio: 16/9) {
      .slide-canvas { padding-top: 0; width: min(100vw, calc(100dvh * 16 / 9)); aspect-ratio: 16 / 9; }
    }

    /* ── 슬라이드 공통 ── */
    .slide { position: absolute; inset: 0; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: clamp(1.5rem, 5cqw, 5rem); visibility: hidden; pointer-events: none; contain: layout style; overflow: hidden; }
    .slide.is-current { visibility: visible; pointer-events: auto; }

    /* ── 배경 테마 ── */
    .slide--dark   { background: #0f0f23; }
    .slide--blue   { background: linear-gradient(135deg, #0f0f23 0%, #1a1a3e 100%); }
    .slide--purple { background: linear-gradient(135deg, #1a0a2e 0%, #2d1b4e 100%); }
    .slide--green  { background: linear-gradient(135deg, #0a1f1a 0%, #0d2e22 100%); }
    .slide--accent { background: linear-gradient(135deg, #1a1060 0%, #0d1535 100%); }

    /* ── 타이포그래피 ── */
    .slide__eyebrow { font-size: clamp(0.6rem, 1.2cqw, 0.85rem); text-transform: uppercase; letter-spacing: 0.2em; color: #4f8ef7; margin-bottom: clamp(0.5rem, 1.5cqh, 1rem); }
    .slide__title { font-size: clamp(1.6rem, 6cqw, 4rem); font-weight: 800; line-height: 1.15; color: #fff; text-align: center; margin-bottom: clamp(0.75rem, 2cqh, 1.5rem); }
    .slide__title .accent { color: #4f8ef7; }
    .slide__title .accent-purple { color: #a855f7; }
    .slide__subtitle { font-size: clamp(0.85rem, 2cqw, 1.3rem); color: rgba(255,255,255,0.6); text-align: center; max-width: 70cqw; line-height: 1.6; }
    .slide__body { font-size: clamp(0.8rem, 1.8cqw, 1.15rem); color: rgba(255,255,255,0.8); text-align: center; max-width: 75cqw; line-height: 1.7; }

    /* ── 리스트 ── */
    .feature-list { list-style: none; display: flex; flex-direction: column; gap: clamp(0.4rem, 1.2cqh, 0.9rem); align-items: flex-start; width: min(85cqw, 600px); }
    .feature-list li { display: flex; align-items: center; gap: 0.75em; font-size: clamp(0.8rem, 1.8cqw, 1.1rem); color: rgba(255,255,255,0.85); }
    .feature-list li::before { content: ''; flex-shrink: 0; width: 6px; height: 6px; border-radius: 50%; background: #4f8ef7; }

    /* ── 카드 그리드 ── */
    .card-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: clamp(0.5rem, 1.5cqw, 1.25rem); width: 90cqw; }
    .card { background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 10px; padding: clamp(0.75rem, 2cqw, 1.5rem); display: flex; flex-direction: column; gap: 0.5em; transition: border-color 0.25s, background 0.25s; }
    .card:hover { background: rgba(79,142,247,0.1); border-color: rgba(79,142,247,0.4); }
    .card__icon { font-size: clamp(1.2rem, 2.5cqw, 1.8rem); }
    .card__title { font-size: clamp(0.75rem, 1.5cqw, 1rem); font-weight: 700; color: #fff; }
    .card__desc { font-size: clamp(0.65rem, 1.2cqw, 0.82rem); color: rgba(255,255,255,0.5); line-height: 1.5; }

    /* ── 구분선 ── */
    .divider { width: clamp(2rem, 5cqw, 4rem); height: 3px; background: linear-gradient(90deg, #4f8ef7, #a855f7); border-radius: 2px; margin: clamp(0.5rem, 1.5cqh, 1.25rem) 0; }

    /* ── 배지 ── */
    .badge-row { display: flex; flex-wrap: wrap; gap: 0.6rem; justify-content: center; }
    .badge { padding: 0.3em 0.9em; border-radius: 999px; font-size: clamp(0.6rem, 1.2cqw, 0.8rem); font-weight: 600; letter-spacing: 0.05em; border: 1px solid; }
    .badge--blue   { color: #4f8ef7; border-color: rgba(79,142,247,0.4);  background: rgba(79,142,247,0.1); }
    .badge--purple { color: #a855f7; border-color: rgba(168,85,247,0.4);  background: rgba(168,85,247,0.1); }
    .badge--green  { color: #22c55e; border-color: rgba(34,197,94,0.4);   background: rgba(34,197,94,0.1); }
    .badge--amber  { color: #f59e0b; border-color: rgba(245,158,11,0.4);  background: rgba(245,158,11,0.1); }

    /* ── Fragment (빌드 효과 OFF: 활성 슬라이드에서만 즉시 표시) ── */
    /* 빌드 효과를 켜려면 이 블록을 제거하고 .fragment 기본 스타일을 추가한다 */
    .slide.is-current .fragment { opacity: 1 !important; visibility: visible !important; transform: none !important; transition: none !important; }

    /* ── 화자 노트 ── */
    .speaker-notes { display: none; }

    /* ── 스크린리더 전용 ── */
    .sr-only { position: absolute; width: 1px; height: 1px; overflow: hidden; clip: rect(0,0,0,0); white-space: nowrap; border: 0; }

    /* ── 네비게이션 화살표 ── */
    .nav-btn { position: fixed; top: 50%; transform: translateY(-50%); width: 44px; height: 44px; border-radius: 50%; background: rgba(255,255,255,0.08); border: 1px solid rgba(255,255,255,0.15); color: rgba(255,255,255,0.6); font-size: 1.2rem; cursor: pointer; z-index: 200; display: flex; align-items: center; justify-content: center; transition: background 0.2s, color 0.2s, opacity 0.2s; }
    .nav-btn:hover { background: rgba(255,255,255,0.18); color: #fff; }
    .nav-btn:focus-visible { outline: 2px solid #4f8ef7; outline-offset: 2px; }
    .nav-btn--prev { left: 1.25rem; }
    .nav-btn--next { right: 1.25rem; }
    .nav-btn[disabled] { opacity: 0; pointer-events: none; }

    /* ── 도트 인디케이터 ── */
    .dot-nav { position: fixed; bottom: 1.1rem; left: 50%; transform: translateX(-50%); display: flex; gap: 0.45rem; z-index: 200; }
    .dot { width: 6px; height: 6px; border-radius: 50%; background: rgba(255,255,255,0.25); border: none; cursor: pointer; padding: 0; transition: background 0.25s, transform 0.25s, width 0.25s; }
    .dot.active { background: #fff; width: 20px; border-radius: 3px; }
    .dot:focus-visible { outline: 2px solid #4f8ef7; }

    /* ── 모션 감소 ── */
    @media (prefers-reduced-motion: reduce) {
      .slide, .progress-bar__fill, .dot { transition: opacity 0.1s !important; transform: none !important; animation: none !important; }
    }

    /* ── 모바일 세로 모드 ── */
    @media (orientation: portrait) and (max-width: 768px) {
      @supports (aspect-ratio: 16/9) {
        .slide-canvas { width: 100vw; aspect-ratio: unset; height: 100dvh; border-radius: 0; }
      }
      .nav-btn { display: none; }
    }
  </style>
</head>
<body>

  <div class="progress-bar" role="progressbar" aria-valuenow="1" aria-valuemin="1" aria-valuemax="3" aria-label="프레젠테이션 진행도">
    <div class="progress-bar__fill" id="progress-fill"></div>
  </div>

  <div class="presentation-stage">
    <main class="slide-canvas" id="slide-canvas" aria-label="슬라이드 프레젠테이션">

      <!-- SLIDE 1 ── data-transition: slide | fade | zoom | flip -->
      <section class="slide slide--blue is-current"
               data-slide-index="0"
               data-transition="slide"
               aria-roledescription="슬라이드"
               aria-label="슬라이드 1 / 3: 제목">
        <p class="slide__eyebrow">소제목</p>
        <h1 class="slide__title">슬라이드 <span class="accent">제목</span></h1>
        <div class="divider"></div>
        <p class="slide__subtitle">부제목 또는 설명 텍스트</p>
        <aside class="speaker-notes">화자 노트</aside>
      </section>

      <!-- SLIDE 2 -->
      <section class="slide slide--dark"
               data-slide-index="1"
               data-transition="fade"
               aria-roledescription="슬라이드"
               aria-label="슬라이드 2 / 3: 내용"
               aria-hidden="true">
        <p class="slide__eyebrow">Section</p>
        <h2 class="slide__title">내용 슬라이드</h2>
        <ul class="feature-list">
          <li>항목 1</li>
          <li>항목 2</li>
          <li>항목 3</li>
        </ul>
        <aside class="speaker-notes">화자 노트</aside>
      </section>

      <!-- SLIDE 3 -->
      <section class="slide slide--purple"
               data-slide-index="2"
               data-transition="zoom"
               aria-roledescription="슬라이드"
               aria-label="슬라이드 3 / 3: 마무리"
               aria-hidden="true">
        <p class="slide__eyebrow">Thank You</p>
        <h2 class="slide__title">마무리 슬라이드</h2>
        <div class="divider"></div>
        <div class="badge-row">
          <span class="badge badge--blue">태그 1</span>
          <span class="badge badge--purple">태그 2</span>
          <span class="badge badge--green">태그 3</span>
        </div>
        <aside class="speaker-notes">화자 노트</aside>
      </section>

    </main>
  </div>

  <button class="nav-btn nav-btn--prev" id="btn-prev" aria-label="이전 슬라이드">&#8249;</button>
  <button class="nav-btn nav-btn--next" id="btn-next" aria-label="다음 슬라이드">&#8250;</button>
  <nav class="dot-nav" aria-label="슬라이드 목록" id="dot-nav"></nav>

  <output class="slide-counter" id="slide-counter" role="status" aria-live="polite">
    <span id="counter-current">1</span> / <span id="counter-total">3</span>
  </output>

  <p class="key-hint">← → Space · 스와이프</p>
  <div class="sr-only" aria-live="assertive" id="slide-announcer"></div>

  <script>
  (() => {
    'use strict';

    class Presentation {
      #slides; #cur = 0; #busy = false;
      #DURATION = 420;

      constructor() {
        this.#slides = [...document.querySelectorAll('[data-slide-index]')];
        this.#buildDots();
        this.#bindEvents();
        this.#restoreHash();
        this.#syncUI();
      }

      forward()  { this.#go(this.#cur + 1, 'fwd'); }
      backward() { this.#go(this.#cur - 1, 'bwd'); }
      goTo(idx)  { this.#go(idx, idx > this.#cur ? 'fwd' : 'bwd'); }

      #getKeyframes(entering, dir) {
        const type   = entering.dataset.transition || 'slide';
        const fwd    = dir === 'fwd';
        const easing = 'cubic-bezier(0.4,0,0.2,1)';
        const opts   = { duration: this.#DURATION, easing, fill: 'forwards' };

        switch (type) {
          case 'fade':
            return { leave: [{ opacity:1 },{ opacity:0 }], enter: [{ opacity:0 },{ opacity:1 }], leaveOpts: opts, enterOpts: opts, willChange: 'opacity' };
          case 'zoom':
            return {
              leave: [{ opacity:1, transform:'scale(1)' },{ opacity:0, transform: fwd?'scale(0.85)':'scale(1.15)' }],
              enter: [{ opacity:0, transform: fwd?'scale(1.15)':'scale(0.85)' },{ opacity:1, transform:'scale(1)' }],
              leaveOpts: opts, enterOpts: opts, willChange: 'transform, opacity'
            };
          case 'flip': {
            const half = this.#DURATION / 2;
            return {
              leave: [{ transform:`perspective(1200px) rotateY(0deg)`, opacity:1 },{ transform:`perspective(1200px) rotateY(${fwd?-90:90}deg)`, opacity:0 }],
              enter: [{ transform:`perspective(1200px) rotateY(${fwd?90:-90}deg)`, opacity:0 },{ transform:`perspective(1200px) rotateY(0deg)`, opacity:1 }],
              leaveOpts: { duration:half, easing:'ease-in', fill:'forwards' },
              enterOpts: { duration:half, easing:'ease-out', fill:'forwards', delay:half },
              willChange: 'transform, opacity'
            };
          }
          default: // slide
            return {
              leave: [{ transform:'translateX(0)' },{ transform:`translateX(${fwd?'-100%':'100%'})` }],
              enter: [{ transform:`translateX(${fwd?'100%':'-100%'})` },{ transform:'translateX(0)' }],
              leaveOpts: opts, enterOpts: opts, willChange: 'transform'
            };
        }
      }

      async #go(idx, dir) {
        if (this.#busy) return;
        const next = Math.max(0, Math.min(idx, this.#slides.length - 1));
        if (next === this.#cur) return;

        this.#busy = true;
        const leaving  = this.#slides[this.#cur];
        const entering = this.#slides[next];
        const { leave, enter, leaveOpts, enterOpts, willChange } = this.#getKeyframes(entering, dir);

        leaving.style.willChange = entering.style.willChange = willChange;
        entering.style.visibility = 'visible';
        leaving.style.zIndex  = '1';
        entering.style.zIndex = '2';

        const leaveAnim = leaving.animate(leave, leaveOpts);
        const enterAnim = entering.animate(enter, enterOpts);

        await Promise.all([leaveAnim.finished, enterAnim.finished]);

        leaving.classList.remove('is-current');
        leaving.style.cssText = '';
        leaveAnim.cancel();

        entering.classList.add('is-current');
        entering.style.cssText = '';
        enterAnim.cancel();

        leaving.setAttribute('aria-hidden', 'true');
        entering.removeAttribute('aria-hidden');

        this.#cur = next;
        this.#busy = false;
        this.#syncUI();
      }

      #syncUI() {
        const n = this.#cur + 1, t = this.#slides.length;
        document.getElementById('progress-fill').style.width = `${n / t * 100}%`;
        document.querySelector('.progress-bar').setAttribute('aria-valuenow', n);
        document.getElementById('counter-current').textContent = n;
        document.querySelectorAll('.dot').forEach((d, i) => {
          d.classList.toggle('active', i === this.#cur);
          d.setAttribute('aria-current', String(i === this.#cur));
        });
        document.getElementById('btn-prev').disabled = this.#cur === 0;
        document.getElementById('btn-next').disabled = this.#cur === t - 1;
        history.replaceState(null, '', `#${n}`);
        document.getElementById('slide-announcer').textContent = `슬라이드 ${n} / ${t}`;
      }

      #buildDots() {
        const nav = document.getElementById('dot-nav');
        document.getElementById('counter-total').textContent = this.#slides.length;
        this.#slides.forEach((_, i) => {
          const btn = document.createElement('button');
          btn.className = 'dot' + (i === 0 ? ' active' : '');
          btn.setAttribute('aria-label', `슬라이드 ${i + 1}`);
          btn.setAttribute('aria-current', String(i === 0));
          btn.addEventListener('click', () => this.goTo(i));
          nav.appendChild(btn);
        });
      }

      #bindEvents() {
        document.addEventListener('keydown', e => {
          if (['INPUT','TEXTAREA'].includes(document.activeElement?.tagName)) return;
          switch (e.key) {
            case 'ArrowRight': case ' ': case 'PageDown': e.preventDefault(); this.forward();  break;
            case 'ArrowLeft':  case 'PageUp':             e.preventDefault(); this.backward(); break;
            case 'Home': e.preventDefault(); this.goTo(0); break;
            case 'End':  e.preventDefault(); this.goTo(this.#slides.length - 1); break;
            case 'f': case 'F': document.documentElement.requestFullscreen?.().catch(()=>{}); break;
          }
        });

        document.getElementById('btn-prev').addEventListener('click', () => this.backward());
        document.getElementById('btn-next').addEventListener('click', () => this.forward());

        let sx = 0, sy = 0, dragging = false;
        const stage = document.querySelector('.presentation-stage');
        stage.addEventListener('pointerdown', e => { if (e.isPrimary) { sx=e.clientX; sy=e.clientY; dragging=true; } });
        stage.addEventListener('pointermove', e => { if (e.isPrimary && dragging && Math.abs(e.clientY-sy) > Math.abs(e.clientX-sx)*1.5) dragging=false; });
        stage.addEventListener('pointerup',   e => { if (!e.isPrimary||!dragging) return; dragging=false; const dx=e.clientX-sx; if(Math.abs(dx)>50) dx<0?this.forward():this.backward(); });
        stage.addEventListener('pointercancel', () => { dragging=false; });

        window.addEventListener('hashchange', () => {
          const m = location.hash.match(/^#(\d+)$/);
          if (m) { const idx = Math.max(0, parseInt(m[1])-1); if (idx !== this.#cur) this.goTo(idx); }
        });
      }

      #restoreHash() {
        const m = location.hash.match(/^#(\d+)$/);
        if (m) {
          const idx = Math.max(0, Math.min(parseInt(m[1])-1, this.#slides.length-1));
          if (idx > 0) {
            this.#slides[0].classList.remove('is-current');
            this.#slides[0].setAttribute('aria-hidden', 'true');
            this.#slides[idx].classList.add('is-current');
            this.#slides[idx].removeAttribute('aria-hidden');
            this.#cur = idx;
          }
        }
      }
    }

    new Presentation();
  })();
  </script>
</body>
</html>
```
