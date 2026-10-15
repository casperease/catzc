# Plan: the world-map processor, open items

`Catzc.Base.Maps` (P1–P7: tracks and languages in `variants.yml`, `Get-WorldMap`, `Get-WorldMapHighlight`, `Export-WorldMapPdf`,
`Test-WorldMap`) is built, and Flow B's placement heuristics are retired. Still open, for the user:

- Re-render wave-7 and the `docs/.assets/explanation` minimaps (catzc-8d's area) from `Get-WorldMapHighlight`, the same way P7 re-rendered
  the fan-out.
- Remove the stale `_placements.json` references in the wave-5/6 briefs and in `selection/_make_round1.py`.
- The minimaps partly repeat `WorldMapPdf` in Python. Should they be images rasterised from highlight PDFs instead?
- Add citations or `maps.yml` pins where a drawing shows code that doesn't cite its ADR (for example, the ADO auth code doesn't cite
  ADR-PIPE-AUTH).
