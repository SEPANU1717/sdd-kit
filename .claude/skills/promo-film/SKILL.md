---
name: promo-film
description: Make a clean, professional product promo film (a 15–35 s motion UI video) rendered from code, frame by frame, with the product's real UI, one headline word per beat, a music bed and sound effects on the same beat grid, and an optional seamless loop. Use when the user asks for a promo video, launch video, product film, motion UI video, feature showcase video, social media video of an app, or to remake or improve an existing promo with the same look.
metadata:
  sdd-steps: none
  sdd-when: the user asks for a promo, launch or showcase video
---

# Promo film

## Goal

Every promo film comes out with the same quality bar and the same look: a hook in
the first second, the product's real features shown working (not menus), one
consistent design system, motion that lands on the music's beat, and a file
ready to post. The method comes from the Sepadial film (v4 and v5).

## When to use

- "Make a promo / launch / showcase video for <app>"
- "Make it like the last video", "same style", "remake this reference"
- Improving the hook, the ending, the pacing or the loop of an existing film

Not for: editing filmed footage, or voice-heavy explainers (use a video editor).

## Steps

1. **Collect.** The product's real UI (components or screenshots), its feature
   list, and the user's references. Watch each reference as a contact sheet
   (`templates/sheet.py`). Write down what each one does well, in one line each.
   Never copy a reference's layout.
2. **Storyboard.** Use `references/creative-direction.md`. Fill in the beat table:
   hook, one chapter per feature group, a privacy/trust beat, and a lockup.
   Each section gets one headline word and one short caption. Show the user the
   table and agree on it before you build anything.
3. **Lock the timing** in `templates/timeline.ts`: sections in beats, plus one cue
   per sound. The picture and the sound both read this one table
   (`references/timing-and-sound.md`).
4. **Build the picture** from `templates/kit.tsx`, following
   `references/design-system.md` and `references/motion.md`. Use the product's
   real components where you can. Draw everything else in the same tokens.
5. **Stills first.** Render 15–25 key frames (the peak of each scene plus a few
   mid-transition frames), make a contact sheet, and check them against
   `references/qa-checklist.md`. Fix, then render the stills again. Show the
   user the sheet before the full render.
6. **Sound.** `templates/mix.py` builds the music bed and places an effect on
   every cue. Encode with `templates/encode.ps1` (H.264, AAC, −14 LUFS).
7. **Verify the output.** Probe the duration and loudness, make a contact sheet
   of the final MP4 (one frame per second), and check the loop seam if it loops.
   Report the real numbers to the user.

## Output

- `out/<name>-vN.mp4`: 1080×1080 (1:1) master at 60 fps (59.94), H.264 4:2:0, AAC
  256k 48 kHz, −14 LUFS, true peak ≤ −1 dBTP.
- Optional: a 9:16 version (1080×1920) for Reels, TikTok and Shorts, and a 4:5
  version (1080×1350) for the Instagram feed. These are layout passes on the
  same timeline.
- The source next to it: `FilmN.tsx`, `timelineN.ts`, `mixN.py`. Each version
  is a new file; never overwrite a version the user liked.

## Rules

- **The hook is in the first second.** Something moves on frame 0. Show the
  product doing something, not just a logo.
- **Show results, not menus.** Every feature beat shows the edit happening on a
  real file (crop handles closing in, a background wiping away, a face blurring).
- **One hero object.** The product's signature UI carries over between scenes
  (it moves, shrinks or reopens) instead of hard cuts back to a dashboard.
- **One design system** (`references/design-system.md`): one stage, one accent,
  one card style, one type scale, the same chrome everywhere.
- **One headline word per section, landing on the beat.** The word names what
  the picture is doing; the full stop is the accent colour.
- **Readable at phone size.** UI is shown 2–3× larger and cropped tight. No text
  under 14 px at 1080.
- **Deterministic frames.** Every value is a pure function of the frame number:
  no timers, no `Math.random`, and no live animations in the real components
  (set reduced motion).
- **Never claim what the product doesn't do.** End-card claims ("Free", "No
  account") need evidence in the code or the docs. Otherwise ask the user.
- **Never overwrite** a version the user approved. Make vN+1.
- **Loops:** the last frame equals frame 0, and the music's build-up wraps
  around the loop point (`references/timing-and-sound.md`).

## References

- `references/creative-direction.md`: hook patterns, structure, storyboard table
- `references/design-system.md`: tokens, layout grid, chrome, cards, type
- `references/motion.md`: easing, entrances and exits, word animation, cursor, camera
- `references/timing-and-sound.md`: beat grid, cue table, sound palette, loudness, loop
- `references/pipeline.md`: file layout, rendering, encoding, commands
- `references/qa-checklist.md`: what to check on stills and on the final file
- `templates/`: `anim.ts`, `timeline.ts`, `kit.tsx`, `shoot.mjs`, `encode.ps1`, `mix.py`, `sheet.py`
