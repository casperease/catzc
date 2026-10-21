---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: feature
  targets: [python/catzc_diagrams/declaration.py]
---

# Diagram in article

A diagram's declaration may live inside its article, in a fenced block the kit renders the way a `mermaid` block renders, instead of in
`.assets/<name>.drawio.yml`. The rendered png stays in `.assets/<name>.drawio.png` either way.

## Decided (the user, 2026-10-21)

- The block is fenced with the info string `yml drawio` (` ```yml drawio `): GitHub shows it as YAML, and the kit finds exactly that block
  by the word `drawio`; "like mermaid".
- `.assets/<name>.drawio.yml` stays the default carrier; the in-article block is a second mode chosen per diagram, one config entry with its
  default declared once on its type (configure, don't program).

## Decided (delegated, the orchestrator, 2026-10-21)

- A block names no diagram: it sits directly above the image embedding `.assets/<name>.drawio.png` (only blank lines between), the mermaid
  way, and declares that png's diagram; no `name:` key.
- The config mirrors `roles:`: `renderer.carrier: file` declared once in the kit's `drawio.yml` (Python reads it; no C# type) and
  `carriers: { <stem>: article }`.
- `Test-Diagrams` findings: a block with no image under it; an article-mode diagram with zero or two blocks; a diagram declared both in a
  block and in `.assets/<name>.drawio.yml`.

## Open steps

3. [ ] The kit and the Slides tools read and write the block, one mechanism, as one staged burst: `declaration.py` `source_of` finds the
       `yml drawio` block in the article; save, tidy and `declare_minimaps` write it back in place keeping the page intact; discovery in
       `drawio_forward.py`, `Build-Diagrams` and `Test-Diagrams` finds articles carrying a block; the gate's drift, conflict and committed
       base read the block from git; Supports and the embedder still pair the article with `.assets/<name>.drawio.png` (check: pytest with a
       fixture article, the Slides Pester, `Test-Diagrams` on the fixture).
4. [ ] `build-diagrams-runs-five-stages` moved to the article mode as the proof (the user, 2026-10-21) (check: `Build-Diagrams -Path` on it re-renders the same
       png, `Test-Diagrams` and `Test-Links` clean).
