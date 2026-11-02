# Design system (1080 × 1080)

Take the product's own tokens (ink, text colours, accent, radius). These are the
Sepadial values; replace them, and keep the structure.

## Tokens

| Token | Value | Use |
| --- | --- | --- |
| Stage | `#F4F6F9` + floor glow `radial-gradient(70% 100% at 50% 100%, #DCEBFB, transparent 75%)`, 520 px tall | Every scene, every frame |
| Ink | `#141618` | Words, titles, primary buttons, playheads |
| Muted | `#6B7280` | Captions, secondary text |
| Faint | `#9AA1AC` | Meta text, struck-through values |
| Hairline | `rgba(20,22,24,0.08)` | Card dividers |
| Accent | the product's accent (Sepadial `#f26722`) | The full stop, the active state, annotations, selection. Only one. |
| Success | bg `#E7F7EE`, text `#15803D` | "−74%" style results |
| Card | `#fff`, radius 28 (26 on tall panels), shadow `0 40px 80px -30px rgba(30,47,82,.28), 0 12px 24px -12px rgba(30,47,82,.12), 0 0 0 1px rgba(20,22,24,.06)` | All windows and panels |
| Font | Inter Variable (or the product's font) | Everything |

## Layout grid

| Element | Position |
| --- | --- |
| Chapter label | left 56, top 48: 8 px accent dot + 15 px 600 uppercase, tracking .14em, muted |
| Progress ticks | right 56, top 54: one 28×4 tick per chapter, the current one fills with ink |
| Brand | left 56, bottom 44: 22 px mark + name 18 px 650 |
| Platform | right 56, bottom 47: "for Windows", 15 px muted |
| Headline word | centred, middle at y 196, 148 px 700, tracking −0.055em |
| Caption | centred, top 288, 26 px 500, muted |
| Main card | x 70, y 330, 940 × 660 |
| Title bar inside a card | 56 px, hairline below, file name 18 px 650 + meta faint, ink "Save" button at right |
| Tool rail | 64 px on the left, 40 px buttons 12 px apart, active = `rgba(20,22,24,.07)` |
| Canvas | `#F7F8FA` with an 18 px dot grid `rgba(20,22,24,.09)` |
| Hero centre | (540, 650), 560 px wide |
| Hero + settings panel | hero at (312, 668), 500 px; panel x 594, y 398, 430 × 540 |
| Four panels | x 55 + i·250, y 340, 220 × 620 |
| Trust word | centred at y 470, 210 px; caption at 600, 34 px |

## Type scale

148 (word) · 112 (lockup name) · 40 (tagline) · 32 (key number) · 26 (caption, card
title) · 22–24 (panel title) · 16–19 (UI text) · 14–15 (meta, minimum).

## Consistency rules

- Every window, panel, toast and chip uses the same card, radius family and shadow.
- Chips: radius 999, 15–17 px 600. Dark chips (`rgba(20,22,24,.86)`, white text) on photos, white chips on UI.
- Draw OS context (File Explorer, desktop) in the film's card style, not the OS's own style.
- Use the real product component when you can. Override its theme with CSS
  variables when needed, both the raw token and the `--color-*` token, because
  Tailwind v4 inlines them.
- Pictures are drawn for the film (an SVG scene in the brand's palette). No stock photos.
