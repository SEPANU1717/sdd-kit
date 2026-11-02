# Timing and sound

## Beat grid

- 124 BPM. One beat = 60/124 s = 14.5 frames at 29.97 fps. One bar = 4 beats.
- `beat(k) = T0 + k * BEAT`, with `T0 = 0.048 s` (the first kick).
- 30 s ≈ 62 beats. A loop must be a whole number of beats: 66 beats = 31.93 s
  (957 frames).
- Every section starts on a beat. Actions inside a section land on beats or
  half beats.

## One table drives both

`timeline.ts` exports `SECTIONS` (word, caption, chapter, start beat, length)
and `CUES` (`[kind, beat]`). The film imports it; `mix.py` runs
`node --experimental-strip-types timeline.ts` and reads the JSON. Change the
timing in one place only. Use explicit `.ts` extensions in imports so Node can
run it.

## Sound palette (all synthesised, seeded: same output every run)

| Cue kind | Sound | Use |
| --- | --- | --- |
| `click` | short tick + thump | cursor presses, swatch picks |
| `key` | heavier click | modifier key down |
| `pop` | glassy pop | the hero opens |
| `tick` | 2.9 kHz blip | hovers, panels landing, tagline words |
| `chase` | 8 quick ticks | a highlight running round |
| `done` | pop + small shimmer | a job finished |
| `count` | falling ticks | a number counting down |
| `slide` | soft filtered swipe | sliders, drags |
| `sweep` | long whoosh | a wipe (background removal) |
| `draw` | scribble noise | an annotation drawing |
| `hit` / `drop` | sub thump + air | an edit applied, a layer dropped |
| `whoosh` | band-passed noise, panned | chapter changes (alternate the direction) |
| `shimmer` | bell chord | the lockup |
| `fold` | short reversed whoosh | the loop fold |

## Music bed

A warm detuned pad (Fmaj9 – Am7 – Dm9 – B♭maj9), a riser into the **drop** on the
hook's payoff, then kick + sidechain pump + off-beat sub bass + hats. Take the
kick and bass out for the trust beat (the pad closes down), bring them back
softer for the lockup. Effects get a short synthetic reverb.

## Loudness

Mix at 0.85 peak. The encoder applies `loudnorm=I=-14:TP=-1:LRA=11`. Verify with
`ffmpeg -af ebur128=peak=true` and report the real integrated loudness and peak.

## Seamless loop

- Picture: the last frame equals frame 0. Check by diffing the first and last
  PNGs (mean difference ≈ 0).
- Make frame 0 a still pose that motion leaves from (the cursor enters from off
  screen), and make the ending move into that pose.
- Sound: the bed eases down to about 35 % over the last 1.5 s and starts at
  35 %. Place the riser twice, ending at `DROP` and at `LENGTH + DROP`, so it
  wraps around the seam. Fade only 5 ms at each end.
