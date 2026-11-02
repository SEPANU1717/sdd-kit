"""Soundtrack for a promo film: a 124 BPM house bed and designed effects, all synthesised from seeded noise and
oscillators (the same file every run). Everything is timed by the film's timeline (timeline.ts), so sound and picture
share one clock.

Usage: python mix.py [path/to/timelineN.ts]   ->  out/audio-<name>.wav (48 kHz stereo)

The timeline prints JSON with: last (last frame), drop (beat of the drop), trust ([from, to] beats with no drums, or
null), lockup (beat), loop (true/false), name (output name), cues ([kind, beat] ...).
Loudness (-14 LUFS, -1 dBTP) is set by the encoder.

Music: a warm detuned pad (Fmaj9 - Am7 - Dm9 - Bbmaj9) through a low-pass that opens into the drop; from the drop a
soft kick with sidechain pump, off-beat sub bass and airy hats; no drums through the trust beat; softer for the
lockup. Effects: a riser into the drop, whooshes on chapter changes, clicks, pops, ticks, swipes, hits, a shimmer; a
short synthetic reverb glues them.
"""
import json
import os
import subprocess
import sys
import wave

import numpy as np

SR = 48000
FPS = 30000 / 1001
BEAT = 60 / 124
T0 = 0.048
HERE = os.path.dirname(os.path.abspath(__file__))
TIMELINE = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "timeline.ts")
table = json.loads(subprocess.run(["node", "--experimental-strip-types", TIMELINE], capture_output=True, text=True, check=True).stdout)
LENGTH = (table["last"] + 1) / FPS
DROP = T0 + table["drop"] * BEAT
# The trust beat: no kick, the pad closes down. A far-away range when the film has none.
BREAK = (T0 + table["trust"][0] * BEAT, T0 + table["trust"][1] * BEAT) if table.get("trust") else (1e9, 1e9)
LOOP = bool(table.get("loop"))
OUT = os.path.join(HERE, "out")
rng = np.random.default_rng(11)

n = int(LENGTH * SR)
t = np.arange(n) / SR


def onepole(x, cutoff):
    a = np.exp(-2 * np.pi * np.broadcast_to(np.asarray(cutoff, float), x.shape) / SR)
    y = np.empty_like(x)
    acc = 0.0
    for i in range(len(x)):
        acc = (1 - a[i]) * x[i] + a[i] * acc
        y[i] = acc
    return y


def lowpass(x, cutoff):
    return onepole(onepole(x, cutoff), cutoff)  # 12 dB/oct, smoother than one pole


def highpass(x, cutoff):
    return x - lowpass(x, cutoff)


def place(buf, start, sig, gain=1.0, pan=0.0):
    i = int(round(start * SR))
    if i < 0:
        sig = sig[-i:]
        i = 0
    if i >= n:
        return
    sig = sig[: n - i]
    if np.ndim(pan) == 0:
        pan = np.full(len(sig), pan)
    else:
        pan = pan[: len(sig)]
    buf[i : i + len(sig), 0] += sig * gain * np.cos((pan + 1) * np.pi / 4) * 1.414
    buf[i : i + len(sig), 1] += sig * gain * np.sin((pan + 1) * np.pi / 4) * 1.414


def hann_env(length, attack, release):
    m = int(length * SR)
    e = np.ones(m)
    a, r = int(attack * SR), int(release * SR)
    if a:
        e[:a] = 0.5 - 0.5 * np.cos(np.linspace(0, np.pi, a))
    if r:
        e[-r:] *= 0.5 + 0.5 * np.cos(np.linspace(0, np.pi, r))
    return e


def midi(m):
    return 440 * 2 ** ((m - 69) / 12)


music = np.zeros((n, 2))
fx = np.zeros((n, 2))

# ── Pad: Fmaj9 – Am7 – Dm9 – Bbmaj9 (one bar each), seven detuned saws per note, slow low-pass, stereo spread. ──
CHORDS = [[53, 60, 64, 67, 69], [57, 60, 64, 67, 71], [50, 57, 60, 64, 65], [46, 53, 57, 62, 64]]
BAR = 4 * BEAT
for side, spread in ((0, -1), (1, 1)):
    pad = np.zeros(n)
    k = 0
    start = T0 - BAR
    while start < LENGTH:
        chord = CHORDS[k % 4]
        m = int(BAR * SR * 1.15)
        st = np.arange(m) / SR
        seg = np.zeros(m)
        for note in chord:
            for v in range(4):
                det = (v - 1.5) * 0.06 * spread
                f = midi(note + 12) * 2 ** (det / 12)
                ph = rng.uniform(0, 1)
                seg += 2 * ((st * f + ph) % 1) - 1
        seg *= hann_env(BAR * 1.15, 0.35, 0.45)[:m] / (len(chord) * 4)
        i = int(start * SR)
        lo, hi = max(0, i), min(n, i + m)
        if hi > lo:
            pad[lo:hi] += seg[lo - i : hi - i]
        start += BAR
        k += 1
    cut = 700 + 1500 * np.clip((t - 0.2) / (DROP - 0.2), 0, 1) ** 1.5
    cut = cut - 1300 * np.clip((t - BREAK[0]) / 0.6, 0, 1) * (1 - np.clip((t - BREAK[1] + 0.3) / 0.6, 0, 1))
    pad = lowpass(pad, cut)
    music[:, side] += pad * 0.5

# ── Kick, sidechain, sub bass, hats: from the drop, silent through the break, softer for the lockup. ──
pump = np.ones(n)
beats = [T0 + j * BEAT for j in range(int(LENGTH / BEAT) + 2) if DROP - 1e-6 <= T0 + j * BEAT < LENGTH - 0.3 and not BREAK[0] - 1e-6 <= T0 + j * BEAT < BREAK[1] - 1e-6]
for b in beats:
    soft = 0.7 if b >= BREAK[1] - 1e-6 else 1.0
    kt = np.arange(int(0.36 * SR)) / SR
    kick = np.sin(2 * np.pi * (48 * kt + 90 * (1 - np.exp(-kt * 32)) / 32)) * np.exp(-kt * 10)
    kick += 0.15 * np.sin(2 * np.pi * 3200 * kt) * np.exp(-kt * 400)
    place(music, b, kick, 0.55 * soft)
    i = int(b * SR)
    m = min(n - i, int(BEAT * SR))
    pump[i : i + m] = np.minimum(pump[i : i + m], 1 - 0.38 * soft * np.exp(-np.arange(m) / SR / 0.11))
    chord = CHORDS[int((b - T0) / BAR) % 4]
    bt = np.arange(int(BEAT * 0.48 * SR)) / SR
    bass = np.sin(2 * np.pi * midi(chord[0] - 12) * bt) + 0.25 * np.sin(4 * np.pi * midi(chord[0] - 12) * bt)
    place(music, b + BEAT / 2, np.tanh(1.3 * bass) * hann_env(BEAT * 0.48, 0.01, 0.12)[: len(bt)], 0.26 * soft)
    hat = highpass(rng.standard_normal(int(0.06 * SR)), 7500) * np.exp(-np.arange(int(0.06 * SR)) / SR * 60)
    place(music, b + BEAT / 2 + 0.012, hat, 0.08 * soft, pan=0.35)
    place(music, b + BEAT / 4 * 3, hat * 0.5, 0.05 * soft, pan=-0.35)
music *= pump[:, None]
# The last two seconds settle: the bed fades to silence on the final frame.
if LOOP:
    # Loop: the bed eases down at the end and starts there again, so the seam is soft.
    music *= (1 - 0.65 * np.clip((t - (LENGTH - 1.6)) / 1.5, 0, 1))[:, None]
    music *= (0.35 + 0.65 * np.clip(t / DROP, 0, 1))[:, None]
else:
    # The last two seconds settle to silence on the final frame.
    music *= (1 - np.clip((t - (LENGTH - 2.2)) / 2.1, 0, 1) ** 1.5)[:, None]


# ── Effects. ──
def whoosh(peak, width=0.45, gain=0.32, sweep=(-0.6, 0.6)):
    m = int(width * 2 * SR)
    x = rng.standard_normal(m)
    k = np.linspace(-1, 1, m)
    shape = np.exp(-((k * 2.0) ** 2)) * (1 - 0.5 * np.clip(k, 0, 1))  # rises, then trails off softly
    band = lowpass(x, 300 + 5200 * shape) - lowpass(x, 120 + 900 * shape)
    place(fx, peak - width, band * shape, gain, pan=np.linspace(sweep[0], sweep[1], m))


def riser(end, length=1.1, gain=0.22):
    m = int(length * SR)
    rt = np.arange(m) / SR
    p = rt / length
    noise = highpass(lowpass(rng.standard_normal(m), 600 + 7000 * p**2), 300)
    tone = np.sin(2 * np.pi * np.cumsum(200 + 900 * p**2) / SR) * 0.25
    place(fx, end - length, (noise + tone) * p**2.2 * hann_env(length, 0.0, 0.03), gain)


def sub(at, gain=0.6):
    st = np.arange(int(0.9 * SR)) / SR
    place(fx, at, np.sin(2 * np.pi * (36 * st + 30 * (1 - np.exp(-st * 8)) / 8)) * np.exp(-st * 3.5), gain)


def click(at, gain=0.22, pan=0.0):
    m = int(0.025 * SR)
    ct = np.arange(m) / SR
    tick = highpass(rng.standard_normal(m), 2500) * np.exp(-ct * 500) + 0.6 * np.sin(2 * np.pi * 1800 * ct) * np.exp(-ct * 300)
    thump = np.sin(2 * np.pi * 140 * ct) * np.exp(-ct * 120) * 0.5
    place(fx, at, tick + thump, gain, pan)


def pop(at, gain=0.24):
    m = int(0.35 * SR)
    pt = np.arange(m) / SR
    freq = 520 + 900 * (1 - np.exp(-pt * 30))
    body = np.sin(2 * np.pi * np.cumsum(freq) / SR) * np.exp(-pt * 14)
    glass = sum(np.sin(2 * np.pi * f * pt) * np.exp(-pt * d) for f, d in ((2637, 9), (3951, 12), (5274, 16))) * 0.18
    place(fx, at, body + glass, gain)


def tick(at, gain=0.18):
    m = int(0.05 * SR)
    pt = np.arange(m) / SR
    place(fx, at, np.sin(2 * np.pi * 2900 * pt) * np.exp(-pt * 140), gain, 0.25)


def hit(at, gain=0.3):
    st = np.arange(int(0.6 * SR)) / SR
    body = np.sin(2 * np.pi * (60 * st + 40 * (1 - np.exp(-st * 14)) / 14)) * np.exp(-st * 7)
    air = highpass(rng.standard_normal(len(st)), 3000) * np.exp(-st * 18) * 0.25
    place(fx, at, body + air, gain)


def shimmer(at, gain=0.16):
    for j, m in enumerate((77, 81, 84, 88, 89)):
        st = np.arange(int(1.6 * SR)) / SR
        place(fx, at + j * 0.045, np.sin(2 * np.pi * midi(m) * st) * np.exp(-st * 3.2) * (0.5 + 0.5 * np.sin(2 * np.pi * 5 * st)), gain / (1 + j * 0.35), pan=-0.4 + j * 0.2)




def slide(at, gain=0.14):
    m = int(0.32 * SR)
    p = np.linspace(0, 1, m)
    x = lowpass(rng.standard_normal(m), 900 + 2600 * p) * np.sin(np.pi * p) ** 1.5
    place(fx, at - 0.05, highpass(x, 400), gain, pan=np.linspace(-0.3, 0.3, m))


def scribble(at, length=0.55, gain=0.1):
    m = int(length * SR)
    p = np.arange(m) / SR
    x = highpass(rng.standard_normal(m), 1800) * (0.6 + 0.4 * np.sin(2 * np.pi * 9 * p)) * hann_env(length, 0.03, 0.12)[:m]
    place(fx, at, x, gain, 0.15)


# ── Effects from the picture's cue table (timeline4.ts). ──
at_beat = lambda k: T0 + k * BEAT
# The riser wraps round the loop point: its start ends the film, its end opens it.
riser(DROP - 0.02, length=1.1)
if LOOP:
    riser(LENGTH + DROP - 0.02, length=1.1)
sub(DROP - 2 / FPS)
flip = 1
for kind, k in table["cues"]:
    a = at_beat(k)
    if kind == "click":
        click(a, 0.22, -0.15 * flip)
    elif kind == "key":
        click(a, 0.3, -0.3)
    elif kind == "pop":
        pop(a, 0.24)
    elif kind == "tick":
        tick(a, 0.15)
    elif kind == "done":
        pop(a, 0.2)
        shimmer(a + 0.05, 0.08)
    elif kind == "count":
        for j in range(6):
            tick(a + j * 0.055, 0.07 * (1 - j / 7))
    elif kind == "whoosh":
        whoosh(a, sweep=(-0.6 * flip, 0.6 * flip))
        flip = -flip
    elif kind == "slide":
        slide(a)
    elif kind == "hit":
        hit(a, 0.22)
    elif kind == "sweep":
        whoosh(a + 0.55, width=0.6, gain=0.16, sweep=(-0.7, 0.7))
    elif kind == "draw":
        scribble(a)
    elif kind == "drop":
        hit(a, 0.16)
    elif kind == "chase":
        for j in range(8):
            tick(a + j * 1.9 / FPS, 0.06 + 0.01 * j)
    elif kind == "fold":
        whoosh(a + 0.35, width=0.35, gain=0.14, sweep=(0.4, -0.4))
    elif kind == "shimmer":
        shimmer(a, 0.16)
if table.get("trust"):
    sub(at_beat(table["trust"][0]), 0.5)  # the trust beat
if table.get("lockup") is not None:
    sub(at_beat(table["lockup"]), 0.4)  # the lockup

# ── A short synthetic reverb on the effects (exponentially decaying stereo noise, 1.1 s). ──
ir_len = int(1.1 * SR)
for side in (0, 1):
    ir = rng.standard_normal(ir_len) * np.exp(-np.arange(ir_len) / SR * 5.5)
    ir = lowpass(ir, 5000)
    ir /= np.sqrt(np.sum(ir**2))
    size = 1 << int(np.ceil(np.log2(n + ir_len)))
    wet = np.fft.irfft(np.fft.rfft(fx[:, side], size) * np.fft.rfft(ir, size), size)[:n]
    fx[:, side] += wet * 0.28

mixed = music * 0.55 + fx * 0.8
# Smooth ends: 20 ms in, 60 ms out.
# Ends: 5 ms fades for a loop (no click, no dip); 20 ms in and 60 ms out otherwise.
fade_in, fade_out = (0.005, 0.005) if LOOP else (0.02, 0.06)
mixed[: int(fade_in * SR)] *= np.linspace(0, 1, int(fade_in * SR))[:, None]
mixed[-int(fade_out * SR) :] *= np.linspace(1, 0, int(fade_out * SR))[:, None]
mixed /= max(1e-9, np.max(np.abs(mixed))) / 0.85

os.makedirs(OUT, exist_ok=True)
with wave.open(os.path.join(OUT, f"audio-{table.get('name', 'film')}.wav"), "wb") as w:
    w.setnchannels(2)
    w.setsampwidth(2)
    w.setframerate(SR)
    w.writeframes((np.clip(mixed, -1, 1) * 32767).astype("<i2").tobytes())
print("audio", round(n / SR, 3), "s")
