---
plan:
  status: active
  value: high
  reviewed: 2026-10-25
  class: feature
  targets: [pwsh/Catzc.Base.RootConfig/assets/root/.editorconfig]
---

# File limits: one declared length and width per file class, one toolkit that measures and gates them

Today the widths live in five places kept "in sync" by comments (`.editorconfig` 120/140, `.prettierrc.yml` printWidth 140,
`.markdownlint.yml` MD013 140, `New-PythonProject` ruff `line-length = 140`, `links.yml` fallback 140), and file length is held only per
function (`FunctionLength.psm1`, 300 body lines, hard-coded). No file length is gated. One declaration with a sensible default per class,
read by one resolver, replaces all of it (ADR-AUTO-DEFAULT-DEFAULTSFROMCONFIG, ADR-AUTO-DEFAULT-ONERESOLUTIONORDER, PDR-ONELIVE).

## Why its value is high

Long files are where agents lose context and reviews lose focus; widths drift silently between formatter and linter. Measured 2026-10-25
(tracked, excl. vendor and `.unordered`): ps1 p95 176 / p99 310 / max 1574 lines; cs p95 323 / p99 534 / max 1041; py p99 1591 / max 3906
(`declaration.py`); yml p99 289 / max 1376. Widest lines: ps1 852, cs 507, yml 568.

## Decided (proposed defaults, declared once on the config type)

- Two classes, picked by the file kind registry, never by a second extension list: **code** (`ps1`, `psm1`, `cs`, `py`, `go`, `js`, `sh`)
  and **config** (`yml`, `yaml`, `json`, `psd1`, `xml`), and **prose** (`md`). Every file in a track is limited in both length and width
  (the user, 2026-10-25): every kind the registry places in a track maps to exactly one class, and a track kind with no class fails the
  config load, so no tracked file escapes by being unlisted.
- Markdown is measured as written: length counts every line, front matter included; width counts every line, tables, headings and fenced
  code included, with no URL exemption (MD013 rendered with `code_blocks`, `tables` and `headings` on and `strict`), so the gate and
  markdownlint measure the same lines; a long URL moves to a reference-style link definition, which counts too. Generated md (`Build-*`
  output with a warning head) is out by its track.
- Three layers per limit (the user, 2026-10-25): a **global default** per class, a **per-language override** that may push it, and
  **bounds** (`min`/`max`) no override may leave. Resolution: language value if set, else the class default; one lookup, no merging.
- Global defaults: code length 400, config length 300 (under the cap, so a language has room to push); prose length 400; code width 120,
  config width 140, prose width 140. Measured md today: p99 459, max 2131, so the first gate run puts the over-400 pages in `exempt:` and
  each splits by section into a folder of linked pages.
- Bounds: length `min 100` / `max 500` (the user, 2026-10-25: the outer cap is 500 lines, no language goes past it); width `min 80` /
  `max 200`. A default or override outside its bounds fails the config load (`FileLimitsConfig` asserts on construction, fail fast), so a
  wrong number never reaches a gate.
- Shape, one small block:

  ```yaml
  bounds: { length: { min: 100, max: 500 }, width: { min: 80, max: 200 } }
  defaults: { code: { length: 400, width: 120 }, config: { length: 300, width: 140 }, prose: { length: 400, width: 140 } }
  languages: { python: { width: 140, length: 500 } }
  ```

- Fast: one streaming pass per file in the compiled `FileShape` type (line count and widest line together), limits resolved once per
  language and cached for the run; the gate reads the tracked list, no folder walk.
- A config past the cap splits into a folder of disjoint parts, `configs/<name>/<part>.yml`, merged by `Get-Config` (the user, 2026-10-25:
  split by category); `terminology/` per category and the Docs `glossary/` per domain are the first two.
- Over-limit files today go in an `exempt:` map with a reason each, the `source-conventions.yml` shape; the list only shrinks.
- Generated, vendor and `.unordered` files are out of scope by their track, not by a list.

## Toolkit: `Catzc.Base.FileLimits` (the `Test-EacFileProperties` idea, from eac, split by job)

- `configs/file-limits.yml` + `FileLimitsConfig` C# type carrying the defaults.
- `Get-FileLimit -Path` — the resolved limits for one file (class, length, width, source of each value).
- `Measure-FileShape -Path` — lines, widest line and its number; a compiled `FileShape` type, streaming, no `Get-Content` arrays
  (type-first).
- `Test-FileShape` — one finding per breach (length or width), `path:line` + limit + rule code; pure, takes paths.
- `Test-FileLimits` — the gate: tracked files, both checks, `Write-QualityGateReport`, joins `Test-Automation`.
- `Build-WidthConfigs` — renders `.editorconfig` `max_line_length`, prettier `printWidth`, markdownlint MD013 and the ruff line from the one
  config, so the "keep in sync" comments are deleted; `New-PythonProject` and `Get-LinkLineLimit` read `Get-FileLimit`.

## Over the 500-line cap today (2026-10-25, tracked code and config)

Only files out of scope by track (vendor or generated): `pwsh/.compiled/Catzc.Types.*.json` (generated),
`pwsh/Catzc.Tooling.Toolchain/assets/scripts/dotnet-install.sh` and `.ps1` (third-party installers). Every other file is under the cap, so
step 4's `exempt:` map starts empty.

## Open steps

No class has a width count of 0 yet (2026-10-26, catzc-5c, `out/catzc-5c-widths/count.ps1`: one breach per file), so every class stays
`report`. Each step below flips its class's `width_mode` to `fail` once its count reaches 0 and, in the same step, moves `Get-LinkLineLimit`
from the rendered `.editorconfig` to `Get-FileLimit` for that class's extensions (catzc-f2, 2026-10-26).

7. [ ] **prose, fences**: 99 files with fenced lines over 140 (369 lines, `out/catzc-5c-widths/list-fence.txt`), shortened by hand. Check:
       no fenced line over 140 in the folder, `Test-Markdownlint` on it.
8. [ ] **prose, manual test plan** (catzc-5c, after step 6): `Test-ManualTestPlan` reads each check from its `### N. <block>` section, which
       carries a `Test file: <path>` line and its Guards, instead of an index row holding the file and the block on one line; the index
       shrinks to `# | Tier | [check](#anchor)`, and the row form is removed. The gate, its test of the new reading and the 14 pages
       (`docs/how-to/pwsh/manual-test-plan.md` and `manual-test-plan/*.md`) land as one staged burst (catzc-f2, 2026-10-26). Check:
       `Test-ManualTestPlan.Tests.ps1` passes, `Test-ManualTestPlan` reports 0 issues, and no line of the 14 pages is over 140.
9. [ ] **prose, leftover** (tables done elsewhere, catzc-5c, 2026-10-26): the 3 `.claude/plans/` files (`plan-slim-agents.md`,
       `plan-vscode-extensions.md`, `value-of-plan.md`); `docs/drs/design/visual-design.md` and `docs/drs/azure/azure-naming-standard.md`
       (another session's, skipped while dirty); `docs/explanation/thesis/product-thesis/nowaste.slide.md` (its `## Rows` table is slide-kit
       input, catzc-2f's); and `docs/references/pwsh/index.md`, whose 240-column module table is a table by the authoring guide
       `docs/references/pwsh/CLAUDE.md` ("add a row to the table in `index.md`"): it becomes a list once that guide says so, a CLAUDE.md
       edit the user makes. Check: none of them over 140.
10. [ ] **prose, the flip**: once steps 7 to 9 leave 0, `width_mode.prose: fail`, the MD013 `tables` and `code_blocks` true in the
        `.markdownlint.yml` template (Build-WidthConfigs), and `Get-LinkLineLimit` moved to `Get-FileLimit` for `.md`. Check: the prose
        width count is 0, `Test-FileLimits` and `Test-Markdownlint` over the tree pass, and `Test-Links` over the tree passes.
11. [ ] **config**: 155 files over 140 columns (pipeline YAML, configs). Check: as for prose, with `width_mode.config: fail`.
12. [ ] **code**: 1830 files over 120 columns (the `.cs`, `.go` and `.js` link-wrap widths change with the move, from 140 to 120). Check: as
        for prose, with `width_mode.code: fail`.
