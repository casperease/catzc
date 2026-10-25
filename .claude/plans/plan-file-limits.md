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
  and **config** (`yml`, `yaml`, `json`, `psd1`, `xml`). Prose (`md`) keeps width only, no length.
- Three layers per limit (the user, 2026-10-25): a **global default** per class, a **per-language override** that may push it, and
  **bounds** (`min`/`max`) no override may leave. Resolution: language value if set, else the class default; one lookup, no merging.
- Global defaults: code length 500, config length 300 (≈ p99 of today); code width 120, config width 140, prose width 140.
- Bounds: length `min 100` / `max 1500`; width `min 80` / `max 200`. A default or override outside its bounds fails the config load
  (`FileLimitsConfig` asserts on construction, fail fast), so a wrong number never reaches a gate.
- Shape, one small block:

  ```yaml
  bounds: { length: { min: 100, max: 1500 }, width: { min: 80, max: 200 } }
  defaults: { code: { length: 500, width: 120 }, config: { length: 300, width: 140 }, prose: { width: 140 } }
  languages: { python: { width: 140, length: 800 } }
  ```

- Fast: one streaming pass per file in the compiled `FileShape` type (line count and widest line together), limits resolved once per
  language and cached for the run; the gate reads the tracked list, no folder walk.
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
- `FunctionLength.psm1` reads its 300 from the same config (`max_function_body_length`).

## Open steps

1. [ ] ADR rule `ADR-AUTO-LIMIT-ONEDECLARATION` (new page `docs/drs/automation/file-limits.md`): limits per class, one source, generated
       tool configs. Check: `Test-DrsRegistry`, `Test-Links`.
2. [ ] Module skeleton, `file-limits.yml`, `FileLimitsConfig` with defaults; L0 tests (widget/gadget fixtures). Check: its tests.
3. [ ] `Measure-FileShape`, `Get-FileLimit`, `Test-FileShape` + L0 tests (incl. out-of-bounds config rejected). Check: their Pester files.
4. [ ] `Test-FileLimits` gate; first run fills `exempt:` with every current breach and its reason. Check: gate green.
5. [ ] `Build-WidthConfigs`; re-point `.editorconfig`, `.prettierrc.yml`, `.markdownlint.yml`, `New-PythonProject`, `Get-LinkLineLimit`,
       `FunctionLength.psm1`; delete the sync comments. Check: `Test-GeneratedFiles`, `Test-Formatting`, `Test-ShippedConfigs`.
6. [ ] Register the gate in `Test-Automation` and the timeouts roof. Check: `Test-Plans` sees the new gate exported; the gate's run time
       under its `timeouts.yml` roof.

## Open questions

- Is 500/300 right, or start tighter (400/250) with a larger `exempt:` list to burn down? Are the bounds 100–1500 / 80–200 right?
- Should `md` get a length limit too (p99 459, max 2131)?
