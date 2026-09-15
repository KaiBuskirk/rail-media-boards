# Rail-Works board spec — for designers

Everything here is **measured on real panels**, not assumed. Follow it and a board
looks right on every surface in the fleet without being redesigned.

---

## Canvas

| use | size | notes |
|---|---|---|
| **POSTER (portrait)** | **1080 × 1920** | the default. A screen turned on its side. |
| **BOARD (landscape)** | **1920 × 1080** | TVs, monitors left flat. |

Author at exactly one of these. **Do not design at 4K** — the pipeline scales up
cleanly, and scaling down loses type weight.

## Safe area — the most important number

Keep everything that matters inside the safe box. Outside it is decoration only.

| surface | safe % | portrait safe box | landscape safe box |
|---|---|---|---|
| **PC monitor** (measured, no overscan) | 98% | 1058 × 1882, inset 11 / 19 | 1882 × 1058 |
| **TV via Apple TV** (measured, eats 5%) | 90% | 972 × 1728, inset 54 / 96 | 1728 × 972 |

**If a board might ever appear on a TV, design to 90%.** The measurement came from
photographing an alignment target on a real Samsung: the outer 5% is simply not
displayed. A PC monitor shows 100%.

## Reserved: the ticker strip

The bottom **96 px** of a portrait board is reserved for the scrolling ticker.
**Leave it empty.** Anything placed there will be covered.

## Type — measured legible at 12 feet

Portrait canvas minimums:

| role | minimum | used in poster-01 |
|---|---|---|
| headline | **90 px** | 118 px |
| sub-head | **34 px** | 38 px |
| body | **28 px** | 30 px |
| smallest legible | **24 px** | 26 px |

Below 24 px nothing reads across a room. This is a measurement, not taste.

## Colour — dark ground, bright type

Measured on two panels: **highlights crush, shadows have range.** Light type on a
light ground disappears; the top three steps of an 11-step ramp merged into one
on the Samsung.

- ground: near-black, `#0b0e14` is the house value
- type: near-white `#e8eaf0`, accent `#ffd166`
- **never** light-on-light
- gradients are fine and look good; flat fills are safer on the worst panels

## Hard rules

1. **ZERO third-party loads.** No CDN fonts, no remote scripts, no analytics, no
   hosted images. Everything embedded or same-origin. A board that fetches from
   someone else's host lets that host change what appears on a screen in a venue —
   and it breaks offline. This is the single most important rule here.
2. **No motion except the ticker.** A poster is read at a glance from across a room.
3. **Nothing load-bearing in the outer 10%** unless you know the surface is a monitor.
4. **Author once.** Do not make a "4K version" — the profile system does that.

## Deliver as

**Best: a single self-contained HTML file.** Inline CSS, inline SVG, images as
data URIs. It renders to every profile automatically and stays editable.

**Also fine: a PNG at exactly 1080 × 1920 or 1920 × 1080.** Flattened, sRGB.

**Not useful:** PSD, AI, PDF, anything needing a font we don't have, anything
that assumes a network.

## How it reaches a screen

```
your file → make-board.sh → profile (canvas, safe area, codec, rotation)
          → MP4 → node → Apple TV → glass
                       ↘ or → browser kiosk (live HTML + live ticker)
```

You never think about that. Author to the canvas and the safe box; the pipeline
handles every surface.
