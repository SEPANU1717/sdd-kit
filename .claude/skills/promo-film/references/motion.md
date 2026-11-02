# Motion

Everything is a pure function of the frame (29.97 fps frame numbers; the 59.94
master renders half frames). Helpers are in `templates/anim.ts`: `ramp`, `kf`,
`mix`, `clamp`, `expoOut`, `easeInOut`, `easeIn`, `spring`, `hash`.

## Easing

| Use | Ease | Length |
| --- | --- | --- |
| Entrances (cards, words, chips) | `expoOut` | 12–18 frames |
| Exits | `easeIn` | 8–10 frames, ending on the next section's beat |
| Moves (cursor, camera, sliders, a hero travelling) | `easeInOut` | 8–20 frames |
| Pops (accent dot, badge, a check, a file dropping in) | `spring` | 14–18 frames |
| Progress, counters | `easeInOut` / `expoOut` | 15–25 frames |

## The one entrance and exit (`presence`)

In: opacity 0→1, rise 46 px, scale 0.965→1 and blur 14→0 over `[a−3, a+15]`
with `expoOut`. Out: opacity →0, rise −34 px, scale →0.97, blur →14 over
`[b−9, b+1]` with `easeIn`. Use it for every card and group so the whole film
moves the same way.

## Headline word

Letters rise from behind a line (overflow hidden). Each letter starts 1.1 frames
after the previous one, rises 0.7× the font size and blurs in from 8 px. The
full stop pops with `spring` 4 frames after its letter. On exit, letters lift
0.55× the font size and blur out, 0.6 frames apart. The next word enters as
this one leaves (a 3–6 frame overlap).

## Scene changes

- Within a chapter, keep the card and crossfade its content over 8 frames
  (fade in from scale 1.015).
- Between chapters, the old group exits with `presence` as the new one enters.
  They overlap by about 6 frames, so the screen is never empty.
- Hero continuity: the progress ring flies into the result, the wheel reopens
  where the next scene needs it, and the logo folds back to frame 0.

## Cursor

- A single cursor per group, driven by one keyframe table `[frame, x, y]` with
  `easeInOut`.
- It arrives 1–2 frames before the action's beat and presses for 3–4 frames
  (scale 0.9). While dragging it stays pressed for the whole drag.
- It enters and leaves from off screen or fades out. It never pops in.
- Hover states come from the cursor's real position (for example, hit-test which
  slice is under it), so hovers always match what's on screen.

## Camera

- A slow push in a hook: scale 1 → 1.035 over the hook.
- Blur only while something moves fast. The first frame and every resting frame
  are sharp.

## Making real components deterministic

Set `data-reduce-motion="true"` on `<html>`. Drive state through props per
frame. When a component jumps between states (for example running vs open),
render both and crossfade them over 4–6 frames.
