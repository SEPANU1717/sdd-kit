/**
 * The film's timing: one table, read by the picture (FilmN.tsx) and the sound (mix.py runs
 * `node --experimental-strip-types timelineN.ts` and reads the JSON it prints). Everything lands on the 124 BPM grid.
 * Copy to promo/timelineN.ts and fill in SECTIONS and CUES from the agreed storyboard.
 */

/** Film frames per second (the 59.94 master renders half frames). */
export const FPS = 30000 / 1001;
/** One beat at 124 BPM, in film frames (about 14.5). */
export const BEAT = (60 / 124) * FPS;
/** The first beat, in frames (the music's first kick is at 0.048 s). */
export const T0 = 0.048 * FPS;
/** Frame of beat `k` (fractions allowed). */
export const beat = (k: number) => T0 + k * BEAT;

/** Length in beats: 62 for about 30 s; a loop must be a whole number of beats (66 = 31.9 s). */
export const BEATS = 66;
/** Last frame. */
export const LAST_FRAME = Math.round(BEATS * BEAT) - 1;
/** Does the film loop (the last frame equals frame 0)? */
export const LOOP = true;

export type Chapter = "hook" | "core" | "style" | "featureA" | "featureB" | "more" | "trust" | "end";

export interface Section {
  id: string;
  /** The headline word, lowercase with a full stop (null: none). */
  word: string | null;
  /** One short sentence under the word, no full stop. */
  caption: string | null;
  chapter: Chapter;
  /** First beat and length in beats. */
  b: number;
  n: number;
}

// The Sepadial v5 structure as the starting point: replace the words and captions with the product's own.
export const SECTIONS: Section[] = [
  { id: "hook", word: "one wheel.", caption: "Convert, edit and share any file", chapter: "hook", b: 0, n: 3 },
  { id: "drag", word: "drag.", caption: "Start dragging any file", chapter: "core", b: 3, n: 3 },
  { id: "hold", word: "hold.", caption: "Hold Ctrl and the wheel opens at the cursor", chapter: "core", b: 6, n: 3 },
  { id: "pick", word: "pick.", caption: "JPG, PNG, WEBP, AVIF, PDF, MP4 and more", chapter: "core", b: 9, n: 3 },
  { id: "done", word: "done.", caption: "Saved next to the original, with Undo", chapter: "core", b: 12, n: 3 },
  { id: "yours", word: "yours.", caption: "Colours, shape and spacing, your way", chapter: "style", b: 15, n: 8 },
  { id: "a1", word: "crop.", caption: "The image editor, built in", chapter: "featureA", b: 23, n: 3 },
  { id: "a2", word: "erase.", caption: "Remove the background, offline", chapter: "featureA", b: 26, n: 3 },
  { id: "a3", word: "blur.", caption: "Faces found and hidden for you", chapter: "featureA", b: 29, n: 3 },
  { id: "a4", word: "mark up.", caption: "Arrows, boxes and labels", chapter: "featureA", b: 32, n: 3 },
  { id: "a5", word: "beautify.", caption: "Backgrounds, padding and shadows", chapter: "featureA", b: 35, n: 3 },
  { id: "b", word: "video.", caption: "Music layers you can move and fade", chapter: "featureB", b: 38, n: 10 },
  { id: "more", word: "and more.", caption: "PDF, text, QR codes and shelves", chapter: "more", b: 48, n: 6 },
  { id: "trust", word: "offline.", caption: "Nothing leaves this PC", chapter: "trust", b: 54, n: 4 },
  { id: "end", word: null, caption: null, chapter: "end", b: 58, n: 8 },
];

/** Beat of the music's drop (the hook's payoff), the trust beat range (no drums), the lockup beat. */
export const DROP_BEAT = 1;
export const TRUST: [number, number] | null = [54, 58];
export const LOCKUP_BEAT = 58;

/** Sounds, in beats: [kind, beat]. Kinds: see references/timing-and-sound.md. */
export const CUES: [string, number][] = [
  ["click", 0.52], ["tick", 0.75], ["pop", 1.05], ["chase", 1.7], ["whoosh", 2.85],
  // … one cue per action in the storyboard …
  ["shimmer", 59], ["tick", 60], ["tick", 61], ["click", 62],
  ["fold", 64.2],
];

if (typeof process !== "undefined" && process.argv[1]?.endsWith(".ts")) {
  console.log(JSON.stringify({ name: "film", fps: FPS, beat: BEAT, t0: T0, last: LAST_FRAME, loop: LOOP, drop: DROP_BEAT, trust: TRUST, lockup: LOCKUP_BEAT, sections: SECTIONS, cues: CUES }));
}
