# QA checklist

Check the stills before the full render, then check the final MP4. Report what
failed and what you fixed.

## Story

- [ ] Frame 0 has the brand or product, and something moves within 0.3 s
- [ ] The product does something within 1.5 s
- [ ] Every feature beat shows the edit happening on a real file, not a menu
- [ ] The hero object carries over; no cut back to a dashboard
- [ ] No more than 2 s of logo on an empty background
- [ ] Every claim on screen is true to the product (no unverified "Free", "No account")

## Design

- [ ] One stage colour, one accent, one card style across all scenes
- [ ] The headline word, caption and chrome sit in the same place in every scene
- [ ] No text under 14 px; UI is readable on a phone
- [ ] Nothing clipped by card edges or the frame (check toasts, swatch rows, panels)
- [ ] No overlapping labels (for example a waveform under a track label)
- [ ] Theme overrides actually applied (for example dark tiles *and* a dark base and hub)

## Motion

- [ ] Every entrance and exit uses the shared `presence` motion
- [ ] Words change on the beat; the full stop pops
- [ ] The cursor never pops in; presses line up with the visual change
- [ ] Mid-transition stills look intentional (blurred and fading, not broken)
- [ ] Resting frames are sharp

## File

- [ ] Duration as planned (`ffprobe … format=duration`)
- [ ] 1080×1080, 60000/1001 fps, H.264 + AAC
- [ ] Loudness ≈ −14 LUFS, true peak ≤ −1 dBTP (`ebur128=peak=true`)
- [ ] One-frame-per-second contact sheet of the final MP4 reviewed
- [ ] Loop: first and last PNG difference ≈ 0; the music has no click or gap at the seam
- [ ] Older versions are untouched; the new version has its own files
