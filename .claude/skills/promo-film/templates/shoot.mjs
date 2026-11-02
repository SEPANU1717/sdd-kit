// Renders film frames with Playwright, from the page vN.html (which mounts FilmN and exposes window.seek / filmReady).
//   FILM=5 LAST=956 node promo/shoot.mjs stills 0 40 120   -> promo/out/v5/still-<f>.png
//   FILM=5 LAST=956 node promo/shoot.mjs film              -> promo/out/v5/frames/00000.png … (every half frame, 59.94 fps)
// CHROME may point at a Chromium/Chrome executable; otherwise Playwright's installed Chromium is used.
import { spawn } from "node:child_process";
import { mkdirSync, rmSync } from "node:fs";
import { join } from "node:path";
import { chromium } from "playwright-core";

const here = import.meta.dirname;
const film = process.env.FILM ?? "1";
const last = Number(process.env.LAST ?? "899");
const out = join(here, "out", `v${film}`);
const [mode = "stills", ...rest] = process.argv.slice(2);
const port = 1500 + Number(film);

// Vite from the project root's node_modules, with promo/vite.config.ts (root = promo/, alias @ -> ../src).
const vite = spawn(process.execPath, [join(here, "..", "node_modules", "vite", "bin", "vite.js"), "--config", join(here, "vite.config.ts"), "--port", String(port), "--strictPort"], { stdio: ["ignore", "pipe", "inherit"] });
await new Promise((resolve) => vite.stdout.on("data", (d) => String(d).includes(String(port)) && resolve()));

const browser = await chromium.launch(process.env.CHROME ? { executablePath: process.env.CHROME } : {});
const page = await browser.newPage({ viewport: { width: 1080, height: 1080 }, deviceScaleFactor: 1 });
page.on("pageerror", (e) => console.log("pageerror:", e.message));
await page.goto(`http://localhost:${String(port)}/v${film}.html?f=0`, { timeout: 180000 });
await page.evaluate(() => window.filmReady);

try {
  mkdirSync(out, { recursive: true });
  if (mode === "stills") {
    for (const f of rest.map(Number)) {
      await page.evaluate((n) => window.seek(n), f);
      await page.screenshot({ path: join(out, `still-${String(f)}.png`) });
      console.log("still", f);
    }
  } else {
    const dir = join(out, "frames");
    rmSync(dir, { recursive: true, force: true });
    mkdirSync(dir, { recursive: true });
    for (let i = 0; i <= last * 2 + 1; i++) {
      // Vite may reload the page once while it bundles dependencies: wait for the film again and retry the frame.
      for (let attempt = 0; ; attempt++) {
        try {
          await page.evaluate((n) => window.seek(n), i / 2);
          break;
        } catch (error) {
          if (attempt >= 3) throw error;
          await page.waitForLoadState("load");
          await page.waitForFunction(() => typeof window.seek === "function" && window.filmReady);
          await page.evaluate(() => window.filmReady);
        }
      }
      await page.screenshot({ path: join(dir, `${String(i).padStart(5, "0")}.png`) });
      if (i % 120 === 0) console.log("frame", i / 2);
    }
  }
} finally {
  await browser.close();
  vite.kill();
}
