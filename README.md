# Rail-Works Boards

Public digital signage for Studio X — promo art, digital posters, merch boards.
Served by GitHub Pages, displayed on Rail-Works display nodes.

Make art, post art, let it play.

## What lives here
Board HTML and art. **Nothing else** — no configuration, no scripts, no addresses,
no credentials. That rule is what makes this repo safe to be public, and it is
checked by `tools/check-clean.sh` before anything is pushed.

## House rules for a board
1. **1920x1080, authored once.** The render pipeline scales it for other targets.
2. **Nothing load-bearing outside the safe area.** Measured on a real panel:
   the outer 5% is eaten by overscan. Keep content inside 1728x972, inset 96x54.
3. **Dark ground, bright type.** Measured on the same panel: highlights crush —
   light-on-light disappears. Type floor 58px headings / 26px body, proven legible
   at 12 feet.
4. **ZERO third-party loads.** No CDN fonts, no analytics, no remote scripts.
   A board that fetches from someone else's host lets that host change what
   appears on a screen in a venue. This is the single most important rule here.

## Boards
- `boards/rail-works.html` — the node status / first-light board
- `boards/merch-portal.html` — merch board layout (placeholders marked TODO)
- `pwa/` — installable offline-capable shell (service worker; needs an HTTPS origin)
