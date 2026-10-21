---
plan:
  status: active
  value: high
  reviewed: 2026-10-21
  class: meta
  targets: [python/catzc_diagrams/drawio_png.py]
---

# Debt diagram render

On 2026-10-21 the glyph library png lost every fill and colour: `drawio_png.py` ran on `glyphs.xml` with its `@tokens` unresolved, and its
`color()` fell back to the default for any non-hex value without a word (catzc-61). The repair re-rendered through a throwaway
`out/w61/render_glyphs.py`, so the one build command does not render the glyph library today.

## Open steps

1. [ ] `python/catzc_diagrams/drawio_png.py`: a style value that is neither hex nor a known keyword (an unresolved `@token`) is an error
       naming the cell and the key, never a silent default. Check: `Invoke-PythonTest Catzc.Base.Slides -Folder python/catzc_diagrams/tests`
       with a case that an `@token` fill fails.
2. [ ] The glyph library renders through the kit's one path (paint, then render) from `Build-Diagrams`, so `out/w61/render_glyphs.py` is not
       needed. Check: `Build-Diagrams -Path docs/explanation/.assets/glyphs` re-renders a png equal in every cell's style to the committed
       one, and `Test-Diagrams` on it is clean.
3. [ ] The two subtitle drifts `Test-Diagrams` reports after today's ADR changes, `rule-and-gate-per-load-stage` and
       `bicep-template-is-a-folder`, re-synced from their cited ADRs. Check: `Test-Diagrams` on both folders reports 0.
