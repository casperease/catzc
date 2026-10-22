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
- Slides are never a carrier.
- A `yml drawio` block's codes do not appear in its article's `cites:` (the user, 2026-10-22, reversing the orchestrator's earlier call):
  `cites:` lists the codes cited outside the blocks and `edges.drs_total` counts every distinct code in the page; the fact behind the head
  keeps all codes (plan-frontmatter-less-is-more).
- The move runs per folder in parallel: a background drone has `drs/flow`, `thesis`, `ado` and `repository`; catzc-e3 has `automation`;
  catzc-e9 has `configuration`; the rest goes to the next free drone. Re-declaring minimaps runs `Build-Diagrams` first, since
  `declaration.py minimaps` reads the computed data only a build refreshes (catzc-e3, 2026-10-22).

## Open steps

- [ ] `python/catzc_diagrams/configs/drawio.yml`, after the move: `renderer.carrier: article`, `carriers:` only the nine file-carried
      diagrams (the seven, `truth-stores`, `bcl-language`) as `file`, the per-diagram `article` entries `carry` wrote removed. (check:
      `pytest` on the kit's carrier tests green, `Test-Diagrams` at 0)
- [ ] The kit tidy from the rules review (decided as delegated): `declaration.py` `carrier_of` calls `carrier_key` instead of copying it;
      `Move-Diagram.ps1` 106-121 and 176-184 re-key `carriers:` through the kit's one line editor (`declaration.py`), not its own regex, so
      one writer holds the format (PDR-ONELIVE); `docs/drs/repository/slides-as-markdown.md` ADR-REPO-SLIDES-DECLARATION gains `carry` (one
      command moves a declaration between carriers, merges its `cspell:ignore` words into the page and rolls every file back on a parity
      loss). (check: the kit's pytest and `Move-Diagram.Tests.ps1` green, `Test-DrsRegistry` at 0)
