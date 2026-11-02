# Pipeline

A React page draws frame `f` when `window.seek(f)` is called. Playwright
screenshots each half frame, ffmpeg encodes. No video editor is involved.

## Folder (inside the product's repo, for example `promo/`)

```
promo/
  anim.ts            motion helpers (templates/anim.ts)
  kit.tsx            stage, chrome, words, cards, cursor (templates/kit.tsx)
  timelineN.ts       sections + cues (templates/timeline.ts)
  FilmN.tsx          the film: groups of scenes, each a function of the frame
  mainN.tsx, vN.html the page: mounts FilmN, exposes window.seek / filmReady
  vite.config.ts     root = promo/, alias @ -> ../src, ignore out/**
  shoot.mjs          stills or full render (templates/shoot.mjs)
  mixN.py            soundtrack (templates/mix.py)
  encode.ps1         MP4 (templates/encode.ps1)
  out/vN/            stills, frames/, contact sheets
```

## The page

```tsx
let setFrameOut = (f: number) => {};
function Root() { const [frame, setFrame] = useState(0); setFrameOut = setFrame; return <Film frame={frame} />; }
createRoot(root).render(<Root />);
const paint = () => new Promise<void>((r) => requestAnimationFrame(() => requestAnimationFrame(() => r())));
window.filmReady = document.fonts.load('600 64px "Inter Variable"').then(() => document.fonts.ready).then(paint);
window.seek = async (f) => { flushSync(() => setFrameOut(f)); await paint(); };
```

`vN.html`: `<html data-reduce-motion="true">`, body 1080×1080, `overflow:hidden`,
black background.

## Commands

```
FILM=N LAST=<last frame> node promo/shoot.mjs stills 0 40 120 …   # key frames -> out/vN/still-*.png
cd promo/out/vN && python ../../sheet.py sheet.png 0 40 120 …     # contact sheet of those stills
FILM=N LAST=<last frame> node promo/shoot.mjs film               # every half frame -> out/vN/frames
python promo/mix.py promo/timelineN.ts                           # out/audio-<name>.wav
pwsh promo/encode.ps1 -Film N -Name <product> -Audio promo/out/audio-<name>.wav
```

Checks on the final file:

```
ffprobe -v error -show_entries format=duration out/<product>-film-vN.mp4
ffmpeg -i out/<product>-film-vN.mp4 -af ebur128=peak=true -f null - 2>&1 | grep -E "I:|Peak:"
ffmpeg -i out/<product>-film-vN.mp4 -vf "fps=1,scale=320:-1,tile=6x6" -frames:v 1 out/vN/final-contact.png
```

The full render takes a few minutes. Run it in the background and wait on the
frame count, watching for `pageerror`. Don't edit files the page imports while
it renders: Vite reloads, and `shoot.mjs` retries, but it's wasted time.

## Gotchas

- Circular imports (`FilmN` ⇄ a scene file): never build JSX from imported values
  at module top level. Build it inside functions.
- SVG `id`s must be unique per instance (prefix them) or gradients and filters collide.
- Use a conic-gradient mask for "sweep open" reveals; size and position the
  mask so its centre follows the object.
- Bash heredocs with many quotes break in some shells. Write scripts to a file, then run them.
