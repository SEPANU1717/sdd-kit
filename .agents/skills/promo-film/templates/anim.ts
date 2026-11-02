/**
 * Motion helpers for the film. Everything is a pure function of the frame number (29.97 fps frames; the 59.94 master
 * renders half frames), so a frame always looks the same however it is reached.
 */

export type Ease = (t: number) => number;

export const linear: Ease = (t) => t;
export const easeOut: Ease = (t) => 1 - (1 - t) ** 3;
export const easeIn: Ease = (t) => t ** 3;
export const easeInOut: Ease = (t) => (t < 0.5 ? 4 * t ** 3 : 1 - (-2 * t + 2) ** 3 / 2);
/** Exponential ease-out: covers ~15 % of the remaining distance per frame (the brief's "enters already moving"). */
export const expoOut: Ease = (t) => (t >= 1 ? 1 : 1 - 2 ** (-10 * t));
export const expoIn: Ease = (t) => (t <= 0 ? 0 : 2 ** (10 * t - 10));
/** A spring that overshoots once and settles. */
export const spring: Ease = (t) => 1 - Math.cos(t * Math.PI * 2.5) * Math.exp(-6 * t);

export const clamp = (v: number, lo = 0, hi = 1) => Math.min(hi, Math.max(lo, v));
export const mix = (a: number, b: number, t: number) => a + (b - a) * t;

/** Keyframes: `[[frame, value], …]` in frame order; each segment eased with `ease`; held before the first and after the last. */
export function kf(frame: number, table: [number, number][], ease: Ease = easeInOut): number {
  const first = table[0];
  const last = table[table.length - 1];
  if (!first || !last) return 0;
  if (frame <= first[0]) return first[1];
  if (frame >= last[0]) return last[1];
  for (let i = 1; i < table.length; i++) {
    const a = table[i - 1];
    const b = table[i];
    if (a && b && frame <= b[0]) return mix(a[1], b[1], ease((frame - a[0]) / (b[0] - a[0])));
  }
  return last[1];
}

/** 0 → 1 over `[from, to]`, eased. */
export const ramp = (frame: number, from: number, to: number, ease: Ease = easeInOut) => ease(clamp((frame - from) / (to - from)));

/** A seeded hash in [0, 1) (no Math.random: frames must repeat exactly). */
export function hash(n: number): number {
  const x = Math.sin(n * 127.1 + 311.7) * 43758.5453;
  return x - Math.floor(x);
}

/** Frame (29.97 fps) of a time in seconds. */
export const at = (seconds: number) => seconds * 29.97;
