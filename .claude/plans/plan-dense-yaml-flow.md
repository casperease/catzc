---
plan:
  status: active
  value: medium
  reviewed: 2026-10-22
  class: feature
  targets:
    [
      docs/explanation/design/.assets,
      docs/explanation/flow/.assets,
      docs/explanation/automation/.assets,
      docs/explanation/azure/.assets,
      docs/references/pwsh/.assets,
      docs/explanation/repository/.assets,
      docs/explanation/configuration/.assets,
      docs/explanation/ado/.assets,
      docs/explanation/thesis/.assets,
      docs/explanation/thesis/product-thesis/.assets,
      docs/drs/flow/.assets,
      docs/drs/automation/BCL/.assets,
      docs/how-to/pwsh/.assets,
      docs/explanation/repository/build-diagrams-runs-five-stages.md,
    ]
---

# Dense yaml flow

A diagram declaration is high-density data: `azure-name-assembly.drawio.yml` spent 374 lines on glyphs, edges and groups of three to four
short keys each, one key per line. The default block style suits most yml; a declaration reads better with each small record on one line.

## Why its value

The declaration is the one source a person and an agent read and edit by hand (ADR-REPO-SLIDES-DECLARATION, ADR-REPO-SLIDES-TWODIRECTIONS).
A glyph or edge on one line reads as one row of a table, and the file shrinks to roughly a third, which is less to read for every agent that
opens one of the 176 declarations.

## Decided

- **What flattens:** a node whose children are all scalars, a leaf mapping or a leaf list (a glyph, an edge, a group, a band, `adrs:`, a
  minimap's `by:`), is printed in flow style: `- { id: c-env, kind: set, label: 1 env, in: grp-name }`, `adrs: [ADR-AZ-NAMING]`. A node with
  a nested mapping or list keeps block style; its leaf children flatten on their own.
- **When it flattens:** only when the whole flow line, its indent and key included, is at most the limit; a longer one stays block style.
- **The limit:** `max_line_length` of the `[*.md]` section of the root `.editorconfig` (140), read at print time, never a second copy in the
  kit's `drawio.yml` or the code (PDR-CONFIG-VARYINGBEHAVIOURISCONFIG, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER). Prettier's `printWidth` is the
  same 140, so Prettier leaves a flow line that fits as it is.
- **The print form is Prettier's:** `{ a: b, c: d }` with inner spaces, `[a, b]` without, quoting as `yaml.safe_dump` gives a scalar, so a
  printed declaration passes Test-Formatting unchanged.
- **Reading does not change:** YAML parses flow and block alike, so `read_source`, `load` and the pwsh readers (`Write-DiagramMinimapData`,
  `Get-DiagramDeclarationText`) stay as they are.
- **The other 175 declarations are reflowed, one `.assets/` folder at a time** (the user, 2026-10-22), each write guarded by the `load()`
  parity check, so the tree holds one print form (PDR-ONELIVE).
- **No other yml flattens** (the user, 2026-10-22): configs are hand-authored and Prettier keeps a flow line a person writes; a second dense
  file kind opens its own plan.

## Open steps

Each step runs `declaration.py reflow` on every declaration of one folder (or the one article carrier), one file at a time, then
`Format-Code -Path` on the reflowed files, which refreshes the generated head's `with_body_sha` that reflow keeps as read (the file-meta
imprint owns that sha; decided by the orchestrator as delegated, 2026-10-22). Its check, the same for each: every `.drawio.yml` of the
folder shorter or equal, `Test-Formatting -Path <folder>` at 0, `Build-Diagrams -Path` on each `.drawio.yml` clean (it refuses a folder),
and `git status --short <folder>` lists `.drawio.yml` files only, so no png changed. A folder an earlier, unfixed reflow left in the working
tree is reflowed again.

- [ ] `docs/explanation/flow/.assets` (35). (check: as above)
- [ ] `python/catzc_diagrams/declaration.py`: `minimaps_block()` writes what Prettier leaves unchanged, so a `declaration.py minimaps`
      write needs `Format-Code` only for the head's `with_body_sha` (after the ten automation re-declares, `Format-Code` reported 10 of 10
      changed in content, catzc-a0, 2026-10-22; whether more than the sha changed is not known). (check: on one stem, `declaration.py
      minimaps` then `Format-Code -Path` changes head lines only, by `git diff`; if more, the block fixed and pytest
      `test_declaration.py` green with a case for it)

## Refs

- The writers: `dump()` and `minimaps_block()` in `python/catzc_diagrams/declaration.py`; `save()` (sync) and `declare_minimaps()` call
  them; `reflow` rewrites one declaration and refuses a write whose `load()` differs.
- The pilot: `docs/drs/azure/.assets/azure-name-assembly.drawio.yml`, committed in 4870b9a4d at 155 lines.
- The limit: `pwsh/Catzc.Base.RootConfig/assets/root/.editorconfig` `[*.md]`, materialised to the root by Build-RootConfig;
  `.prettierrc.yml` `printWidth` holds the same 140.
