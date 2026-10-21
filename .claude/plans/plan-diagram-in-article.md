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

3. [ ] The tree checks of the step-3 tools burst (its code and tests landed: pytest 149, Slides Pester green; the run of the tree checks was
       stopped for low memory; the user frees memory first, then the orchestrator sends catzc-1c on): run `out/gate/article-final.ps1`, or
       by hand `Test-ParameterConsistency`, `Test-Links` and `Test-Diagrams` over the tree (check: all three report 0 issues, so the default
       file carrier is unchanged).
4. [ ] `build-diagrams-runs-five-stages` moved to the article mode as the proof (the user, 2026-10-21) (check: `Build-Diagrams -Path` on it
       re-renders the same png, `Test-Diagrams` and `Test-Links` clean).

## Open questions

- From catzc-1c's finalize (2026-10-22): a staged copy of a public function dot-sourced into its module does not replace the exported
  command. Should the `catzc-verify` capability's staging clause say a public staged copy is proved by the real swap, not by dot-sourcing?
  Recommendation: yes, one merged clause.
- From catzc-1c's finalize (2026-10-22): a tree `Build-Diagrams -Stale` takes about 210 s, so a tree `Test-Diagrams` after it in the same
  call breaks the 360 s roof. Should the `Build-Diagrams` help say the two run as two calls? Recommendation: yes, one sentence in its
  description.
