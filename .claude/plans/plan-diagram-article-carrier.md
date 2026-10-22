---
plan:
  status: active
  value: high
  reviewed: 2026-10-22
  class: feature
  targets: [python/catzc_diagrams/configs/drawio.yml, docs/explanation, docs/drs, docs/how-to, docs/references]
---

# Diagram article carrier: every declaration lives in its article, seven stay files

A diagram's declaration moves from `<name>.drawio.yml` beside its png into the article that embeds the png, as the one `yml drawio` block
directly above the image (the article carrier, ADR-REPO-SLIDES-DECLARATION). Seven diagrams stay file-carried, so the file carrier stays a
live, tested source.

## Why its value

A reader and an agent see a diagram's source where the diagram is explained, in one file, and 169 sidecar files leave the tree; the
frontmatter re-imprint then has no diagram declaration files to head.

## Decided (the user, 2026-10-22)

- The default carrier is `article` (`renderer.carrier` in the kit's `drawio.yml`); seven diagrams, picked at random, stay file-carried,
  named in `carriers:`.
- A moved declaration's text is its `content` as the printer writes it, in a ` ```yml drawio ` block above the image; its `.drawio.yml` is
  deleted, its png stays in `.assets/`.

## Decided (the orchestrator, delegated, 2026-10-22)

- The seven are drawn with `Get-Random -SetSeed 20261022` from the diagrams one article embeds, so the pick is reproducible.

## Open steps

- [ ] The scan: per declaration, which pages embed its png (one article, only slides, several, none), and the seven drawn (catzc-e3,
      `out/diagram-carrier-scan.md`). (check: every one of the 176 classified, the seven listed)
- [ ] The mechanism: how the kit and the pwsh readers read and write the article carrier, and whether a command moves a declaration between
      carriers or one is needed (catzc-e9, `out/diagram-carrier-mechanism.md`). (check: the map names each reader and writer by path)
- [ ] `python/catzc_diagrams/configs/drawio.yml`: `renderer.carrier: article`, `carriers:` the seven as `file`. (check: `pytest` on the
      kit's carrier tests green)
- [ ] The move, one `.assets/` folder at a time: each declaration into its article's block, its yml deleted, the folder rebuilt. (check: per
      folder, `Test-Diagrams` at 0, `Build-Diagrams -Path` on each moved diagram clean with its png unchanged, `Test-Formatting` on the
      pages at 0)
- [ ] The diagrams the scan finds embedded by no page, only by slides or by several pages: each resolved before its folder moves (the user's
      call where a rule does not decide it). (check: none left unclassified in the scan)
