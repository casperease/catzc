---
plan:
  status: active
  value: high
  reviewed: 2026-10-22
  class: feature
  targets: [python/catzc_diagrams/configs/drawio.yml, docs/explanation, docs/drs, docs/how-to, docs/references]
catzc:
  edges:
    cites:
      - ADR-REPO-SLIDES-DECLARATION
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

- The seven are drawn with `Get-Random -SetSeed 20261022` from the diagrams one article embeds, so the pick is reproducible:
  `docs/explanation/ado/.assets/configured-credential-proves-its-org`,
  `docs/explanation/automation/.assets/a-declared-allow-list-of-layers`, `hook-compiles-module-verdict-and-limits`,
  `invoke-importer-in-code-order`, `one-out-string-two-places` (same folder),
  `docs/explanation/repository/.assets/one-source-one-writer-one-boolean`, `docs/references/pwsh/.assets/tools-yml-install-dispatch`
  (catzc-e3, `out/diagram-carrier-scan.md`).
- `docs/explanation/thesis/product-thesis/.assets/truth-stores` stays file-carried too, by necessity: only a slide shows it, as a bare png
  path, so no article can carry it; it is an eighth file-carried diagram, not one of the seven. `docs/references/BCL/.assets/bcl-language`
  is a ninth: its one article sits outside the folder above `.assets` (catzc-e9's map).
- Slides are never a carrier; a block's `about.adrs` counting as its article's `cites:` is intended (the article embeds a diagram about
  those rules).

## Open steps

- [ ] `pwsh/Catzc.Base.Slides`: `Move-Diagram.ps1` carrier-aware (an article-carried diagram moves its block with it, its `carriers:` key
      re-keyed), and `private/Get-DiagramDeclarationText.ps1` skips `*.slide.md` as the kit's `carry` does (catzc-e9; `carry` landed with 109
      kit tests green). (check: both test files green, with an article-carried move and a slide-block case)
- [ ] `python/catzc_diagrams/configs/drawio.yml`: `renderer.carrier: article`, `carriers:` the seven as `file`. (check: `pytest` on the
      kit's carrier tests green)
- [ ] The move, one `.assets/` folder at a time: each declaration into its article's block, its yml deleted, the folder rebuilt. (check: per
      folder, `Test-Diagrams` at 0, `Build-Diagrams -Path` on each moved diagram clean with its png unchanged, `Test-Formatting` on the
      pages at 0)
