/**
 * The film kit: the stage, the chrome, the headline words, the card, chips and the cursor, in one design system
 * (references/design-system.md) with one motion language (references/motion.md). Copy to promo/kit.tsx, set the
 * tokens to the product's own, and build every scene from these pieces.
 */
import type * as React from "react";
import { clamp, easeIn, expoOut, ramp, spring } from "./anim";
import { beat, type Chapter, type Section } from "./timeline";

// ── Tokens: replace with the product's own. Keep exactly one accent. ──────────────────────────────────────────────
export const INK = "#141618";
export const MUTED = "#6B7280";
export const FAINT = "#9AA1AC";
export const ACCENT = "#f26722";
export const HAIR = "rgba(20,22,24,0.08)";
export const CARD_SHADOW = "0 40px 80px -30px rgba(30,47,82,0.28), 0 12px 24px -12px rgba(30,47,82,0.12), 0 0 0 1px rgba(20,22,24,0.06)";
export const FONT = '"Inter Variable", Inter, sans-serif';
export const stage: React.CSSProperties = { position: "absolute", inset: 0, overflow: "hidden" };
export const px = (n: number) => `${String(n)}px`;
/** The main card (windows, editors, File Explorer). */
export const CARD = { x: 70, y: 330, w: 940, h: 660 };

/** The one entrance and exit: in at frame `a`, out by frame `b`. Use it for every card and group. */
export function presence(f: number, a: number, b: number, opts: { enter?: boolean; exit?: boolean; dy?: number } = {}): React.CSSProperties {
  const i = opts.enter === false ? 1 : ramp(f, a - 3, a + 15, expoOut);
  const o = opts.exit === false ? 0 : ramp(f, b - 9, b + 1, easeIn);
  const dy = opts.dy ?? 46;
  const blur = (1 - i) * 14 + o * 14;
  return {
    opacity: i * (1 - o),
    transform: `translateY(${px((1 - i) * dy - o * 34)}) scale(${String(1 - (1 - i) * 0.035 - o * 0.03)})`,
    filter: blur > 0.25 ? `blur(${px(blur)})` : undefined,
  };
}

/** The stage: one background for the whole film. */
export function Backdrop() {
  return (
    <>
      <div style={{ ...stage, background: "#F4F6F9" }} />
      <div style={{ ...stage, top: "auto", height: 520, background: "radial-gradient(70% 100% at 50% 100%, #DCEBFB, transparent 75%)" }} />
    </>
  );
}

/** Chrome: chapter label (top left), progress ticks (top right), brand (bottom left), platform (bottom right). */
export function Chrome({ f, sections, chapters, brand, platform, from = 0, until }: { f: number; sections: Section[]; chapters: [Chapter, string][]; brand: React.ReactNode; platform: string; from?: number; until: number }) {
  const start = (c: Chapter) => sections.find((s) => s.chapter === c)?.b ?? 0;
  const inn = ramp(f, beat(from) - 4, beat(from) + 10, expoOut);
  const out = ramp(f, beat(until) - 10, beat(until) + 2, easeIn);
  return (
    <div style={{ ...stage, opacity: inn * (1 - out), fontFamily: FONT }}>
      {chapters.map(([c, name], i) => {
        const a = beat(start(c));
        const b = beat(chapters[i + 1] ? start(chapters[i + 1]![0]) : until);
        if (f < a - 8 || f > b + 8) return null;
        const t = ramp(f, a - 2, a + 12, expoOut) * (1 - ramp(f, b - 6, b + 2, easeIn));
        return (
          <div key={c} style={{ position: "absolute", left: 56, top: 48, display: "flex", alignItems: "center", gap: 12, opacity: t, transform: `translateY(${px((1 - t) * 10)})` }}>
            <span style={{ width: 8, height: 8, borderRadius: 4, background: ACCENT }} />
            <span style={{ fontSize: 15, fontWeight: 600, letterSpacing: "0.14em", textTransform: "uppercase", color: MUTED }}>{name}</span>
          </div>
        );
      })}
      <div style={{ position: "absolute", right: 56, top: 54, display: "flex", gap: 6 }}>
        {chapters.map(([c], i) => {
          const a = beat(start(c));
          const b = beat(chapters[i + 1] ? start(chapters[i + 1]![0]) : until);
          const fill = clamp((f - a) / (b - a));
          return (
            <span key={c} style={{ position: "relative", width: 28, height: 4, borderRadius: 2, background: "rgba(20,22,24,0.10)", overflow: "hidden" }}>
              <span style={{ position: "absolute", inset: 0, width: `${String(fill * 100)}%`, background: INK, borderRadius: 2 }} />
            </span>
          );
        })}
      </div>
      <div style={{ position: "absolute", left: 56, bottom: 44, display: "flex", alignItems: "center", gap: 10, color: INK, fontSize: 18, fontWeight: 650 }}>{brand}</div>
      <div style={{ position: "absolute", right: 56, bottom: 47, fontSize: 15, fontWeight: 500, color: MUTED }}>{platform}</div>
    </div>
  );
}

/** The headline word: letters rise out of a line, the full stop is the accent and pops. In at `a`, out by `b`. */
export function Word({ text, f, a, b, size = 148, y = 196 }: { text: string; f: number; a: number; b: number; size?: number; y?: number }) {
  const chars = [...text];
  return (
    <div style={{ position: "absolute", left: 0, right: 0, top: y - size * 0.62, height: size * 1.24, overflow: "hidden", display: "flex", justifyContent: "center", alignItems: "center", fontSize: size, fontWeight: 700, letterSpacing: "-0.055em", lineHeight: 1, color: INK, whiteSpace: "pre", fontFamily: FONT }}>
      {chars.map((c, i) => {
        const tIn = ramp(f, a - 2 + i * 1.1, a + 13 + i * 1.1, expoOut);
        const tOut = ramp(f, b - 8 + i * 0.6, b + i * 0.6, easeIn);
        const dot = c === ".";
        const pop = dot ? spring(clamp((f - (a + 4 + i * 1.1)) / 16)) : 1;
        const yy = (1 - tIn) * size * 0.7 - tOut * size * 0.55;
        const blur = (1 - tIn) * 8 + tOut * 8;
        return (
          <span key={i} style={{ display: "inline-block", transform: `translateY(${px(yy)}) scale(${String(dot ? Math.max(0, pop) : 1)})`, transformOrigin: "50% 80%", opacity: tIn * (1 - tOut), filter: blur > 0.3 ? `blur(${px(blur)})` : undefined, color: dot ? ACCENT : undefined }}>
            {c === " " ? " " : c}
          </span>
        );
      })}
    </div>
  );
}

export function Caption({ text, f, a, b, y = 288, size = 26 }: { text: string; f: number; a: number; b: number; y?: number; size?: number }) {
  const t = ramp(f, a + 2, a + 16, expoOut) * (1 - ramp(f, b - 7, b, easeIn));
  return (
    <div style={{ position: "absolute", left: 0, right: 0, top: y, textAlign: "center", fontSize: size, fontWeight: 500, letterSpacing: "-0.01em", color: MUTED, opacity: t, transform: `translateY(${px((1 - t) * 12)})`, filter: t < 0.98 ? `blur(${px((1 - t) * 6)})` : undefined, fontFamily: FONT }}>
      {text}
    </div>
  );
}

/** Every section's word and caption, placed and timed from the timeline. `big` sections (the trust beat) sit lower and larger. */
export function Headlines({ f, sections, big = ["trust"] }: { f: number; sections: Section[]; big?: string[] }) {
  return (
    <>
      {sections.map((s) => {
        if (!s.word) return null;
        const a = beat(s.b);
        const b = beat(s.b + s.n);
        if (f < a - 4 || f > b + 6) return null;
        const large = big.includes(s.id) || big.includes(s.chapter);
        return (
          <div key={s.id} style={stage}>
            <Word text={s.word} f={f} a={a} b={b} size={large ? 210 : 148} y={large ? 470 : 196} />
            {s.caption ? <Caption text={s.caption} f={f} a={a} b={b} y={large ? 600 : 288} size={large ? 34 : 26} /> : null}
          </div>
        );
      })}
    </>
  );
}

/** A window card with the shared title bar. */
export function Card({ title, meta, right, children, style }: { title: string; meta?: string; right?: React.ReactNode; children?: React.ReactNode; style?: React.CSSProperties }) {
  return (
    <div style={{ position: "absolute", left: CARD.x, top: CARD.y, width: CARD.w, height: CARD.h, borderRadius: 28, background: "#fff", boxShadow: CARD_SHADOW, overflow: "hidden", fontFamily: FONT, ...style }}>
      <div style={{ position: "absolute", left: 0, right: 0, top: 0, height: 56, borderBottom: `1px solid ${HAIR}`, display: "flex", alignItems: "center", gap: 12, padding: "0 20px 0 24px" }}>
        <span style={{ fontSize: 18, fontWeight: 650, color: INK, whiteSpace: "nowrap" }}>
          {title}
          {meta ? <span style={{ fontWeight: 500, color: FAINT, marginLeft: 8 }}>{meta}</span> : null}
        </span>
        <span style={{ marginLeft: "auto", display: "flex", alignItems: "center", gap: 12 }}>{right}</span>
      </div>
      <div style={{ position: "absolute", left: 0, right: 0, top: 56, bottom: 0 }}>{children}</div>
    </div>
  );
}

/** The canvas inside an editor card: light grey with a dot grid. */
export const canvasStyle: React.CSSProperties = { background: "#F7F8FA", backgroundImage: "radial-gradient(rgba(20,22,24,0.09) 1.2px, transparent 1.3px)", backgroundSize: "18px 18px" };

/** A chip, centred on (x, y): white on UI, `dark` on photos. */
export function Pill({ children, x, y, show, dark = false }: { children: React.ReactNode; x: number; y: number; show: number; dark?: boolean }) {
  return (
    <div style={{ position: "absolute", left: x, top: y, transform: `translate(-50%, ${px((1 - show) * 10)}) scale(${String(0.9 + 0.1 * show)})`, opacity: show, padding: "9px 16px", borderRadius: 999, background: dark ? "rgba(20,22,24,0.86)" : "rgba(255,255,255,0.94)", color: dark ? "#fff" : INK, fontSize: 17, fontWeight: 600, whiteSpace: "nowrap", boxShadow: "0 8px 20px rgba(10,20,40,0.22)", display: "flex", alignItems: "center", gap: 8, fontFamily: FONT }}>
      {children}
    </div>
  );
}

/** The arrow cursor; (x, y) is the tip. Press with scale 0.9 for 3–4 frames on each action. */
export function Cursor({ x, y, scale = 1, opacity = 1 }: { x: number; y: number; scale?: number; opacity?: number }) {
  if (opacity <= 0.001) return null;
  return (
    <svg width={32} height={39} viewBox="0 0 32 39" style={{ position: "absolute", left: x - 3, top: y - 2, opacity, transform: `scale(${String(scale)})`, transformOrigin: "3px 2px", filter: "drop-shadow(0 3px 4px rgba(0,0,0,0.28))", zIndex: 50 }}>
      <path d="M3 2 L3 31 L10.5 24 L15.5 35.5 L20.5 33.3 L15.6 22 L25.5 22 Z" fill="#111" stroke="#fff" strokeWidth={2.2} strokeLinejoin="round" />
    </svg>
  );
}

/** A cursor path: one keyframe table [frame, x, y]; pressed while any [from, to] range holds. */
export function cursorAt(f: number, keys: [number, number, number][], presses: [number, number][] = []) {
  const at = (axis: 1 | 2) => {
    if (keys.length === 0) return 0;
    if (f <= keys[0]![0]) return keys[0]![axis];
    for (let i = 1; i < keys.length; i++) {
      const a = keys[i - 1]!;
      const b = keys[i]!;
      if (f <= b[0]) {
        const t = (f - a[0]) / (b[0] - a[0] || 1);
        const e = t < 0.5 ? 4 * t ** 3 : 1 - (-2 * t + 2) ** 3 / 2;
        return a[axis] + (b[axis] - a[axis]) * e;
      }
    }
    return keys[keys.length - 1]![axis];
  };
  return { x: at(1), y: at(2), pressed: presses.some(([p0, p1]) => f >= p0 && f < p1) };
}
