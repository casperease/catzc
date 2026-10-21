---
plan:
  status: active
  value: high
  reviewed: 2026-10-21
  class: feature
  targets: [python/catzc_diagrams/declaration.py]
---

# Diagram flat files

Every diagram becomes two files beside its page's `.assets/`: `<name>.drawio.png` and `<name>.drawio.yml`, never a folder of its own. The
177 folders `.assets/<name>/diagram.drawio.png|yml` (2026-10-18 layout) are flattened, for all.

## Decided (the user, 2026-10-21)

- Example: `docs/explanation/automation/.assets/a-declared-allow-list-of-layers/` becomes
  `docs/explanation/automation/.assets/a-declared-allow-list-of-layers.drawio.png` and `.../a-declared-allow-list-of-layers.drawio.yml`.
- The declaration keeps the `.drawio.yml` extension, so discovery and the file-kind globs find a diagram by one pattern.
- For all diagrams; nothing else lives per diagram (minimap data is in the yml).

## Open steps

1. [ ] The rules: ADR-REPO-SLIDES and the conventional-folders rule say a diagram is the pair `<name>.drawio.png` + `<name>.drawio.yml` in
       `.assets/`, named by the diagram; the how-to and `add-a-doc-chapter.md` follow (check: `Test-AdrRegistry`, `Test-Links`).
2. [ ] The tools read and write the pair, one mechanism, staged and swapped as one burst: `declaration.py` (put/get/save/check/minimaps,
       legend), `drawio_forward.py`, `Build-Diagrams` (`-Path` takes a `.drawio.yml`, `-Stale` finds pairs), `Test-Diagrams`,
       `Write-DiagramMinimapData` (its `out/minimaps/<name>/` key), `Move-Diagram`, the `file-kinds.yml` / globs / `drawio.yml` entries that
       name `diagram.drawio.*` (check: pytest, the Slides Pester, `Test-Diagrams` on a fixture pair).
3. [ ] The move: every `.assets/<name>/diagram.drawio.{png,yml}` moved on disk to `.assets/<name>.drawio.{png,yml}` and every link and
       embed re-pointed by the tool (a dry run first, counts reported), the empty folders removed, the glyph library included (check:
       `Test-Links`, `Test-Diagrams` over the tree: 0 issues, 0 stale).
