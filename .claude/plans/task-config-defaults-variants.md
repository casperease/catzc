---
task:
  status: open
  plans: [plan-config-defaults]
  value: high
  blocked_on:
    nothing; task-module-model-closeout no longer edits VariantsConfig.cs or VariantTrack.cs (2026-10-18), only the user's run is left there
  targets: [automation/Catzc.Base.Variants, automation/Catzc.Base.Modules]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task-config-defaults-variants.md"
    folder: plans
    name: task-config-defaults-variants
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
  edges:
    cites:
      - ADR-AUTO-DEFAULT#6
---

# Task: config defaults Phase 1, the variants type carries its defaults

Decided (Q1 to Q7, Q13 to Q21): a default is declared once on the config type as constants; no getter restates it; every property has one
posture: defaulted, empty-is-valid or required (throws at construction naming the key and the fix). Variants is the pilot: ado_naming
standard, git_workspace main-direct, have_customers false, aspects a per-track universal catch-all, tracks required. ADR-AUTO-DEFAULT#6 is
the rule being repaired. C# edits need a fresh pwsh; tests in the background.

## Steps

1. [x] `git status --short automation/Catzc.Base.Variants`: `Get-Track.ps1` and its test were dirty in the user's tree on 2026-10-16; if
   still dirty, leave them and say so. Check: the status is recorded. 2026-10-18: the module and Catzc.Base.Modules were clean.
2. [x] Locate the five getters (`grep -rln "Get-Variant\b" automation --include=*.ps1`; Get-Variant is private or renamed, Get-Aspect lives in
   Catzc.Base.Modules). List them with their `-Default` literals in the plan. Check: the list has every literal. 2026-10-18: four used
   the private `Get-Variant`: `Get-AdoNaming` ('standard'), `Get-GitWorkspace` ('main-direct'), `Get-EnabledCustomers` ($false),
   `Get-Track` (@()); `Get-Aspect` held the fifth, a built-in `infrastructure` convention built inline. The plan's Phase 1 line records
   them.
3. [x] `automation/Catzc.Base.Variants/types/VariantsConfig.cs`: constants `DefaultAdoNaming = "standard"`,
   `DefaultGitWorkspace = "main-direct"`, `DefaultHaveCustomers = false`, the aspects catch-all built per track when the map has no entry;
   `Tracks` required: construction throws with the key name and "add tracks: to variants.yml or the repo fragment". No other file changes in
   this step. Check: the file compiles (fresh pwsh import); `VariantsConfig.Tests.ps1` fails only on the new behaviour. Done 2026-10-18,
   with one correction (recorded in the plan, Q2 reopened): the aspects default is the built-in `infrastructure` convention moved onto
   the type, laid under the declared ones, not a universal catch-all, since a non-code track's live files and the code-convention
   fallback in `Get-Aspect` depend on it. A null key reads as an omitted one.
4. [x] `automation/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1`: an empty map yields the four defaults; `tracks` omitted throws
   naming the key; null and omitted agree; an unknown key is rejected as before. Neutral fixture names. Check: passes. Done 2026-10-18:
   four new cases (the defaults, null equals omitted, tracks omitted or null throws, a declared convention over the built-in), the
   `make` helper adds one neutral track to a fixture about another key; `[Invoke-TestFile] Passed` (`out/test-file/20261018-122657-c1b4fc`).
5. [x] `VariantTrack.cs` only if task-module-model-closeout did not add `execution_engines` with its default; otherwise no edit. Check: its
   test passes. 2026-10-18: no edit; `execution_engines` is in the type, empty when a track names none.
6. [x] The private variant reader (`Get-Variant` or its successor): drop `-Default`; it returns the typed property. Check: its test passes.
   Done 2026-10-18: it returns `(Get-Config -Config variants)[$Name]`; it has no test file of its own, so the four getters' tests cover it.
7. [x] One getter per step, each with its test: `Get-AdoNaming`, `Get-GitWorkspace`, `Get-EnabledCustomers` (have_customers false means none;
   this repo's fragment will say all, until then the shipped variants.yml keeps `all`), `Get-Aspect` (Catzc.Base.Modules), `Get-Track` (if
   not dirty). Each loses its literal and reads the type. Check: each getter's Pester file passes; `have_customers` agrees across the getter
   and the type test. Done 2026-10-18: each lost its literal; the help of Get-AdoNaming and Get-GitWorkspace names the type's constant
   instead of the value; the three unset cases and Get-Aspect's two fixtures build the real type with one neutral track, and Get-Track's
   no-registry case became a test that construction throws. All five Pester files pass (`out/test-file/20261018-122704` to `-122725`);
   `have_customers` is false on the type and an empty set through the getter; `ANALYZER issues=0`, `SHIPPED issues=0`.
8. [x] `plan-config-defaults.md`: tick the Phase 1 step with the test counts; the scratchpad-copy and paste steps are superseded by this task
   (record that under Done, and why). Check: grep `- [ ]` counts the Phase 2 to 5 steps only. Done 2026-10-18; the count also holds the
   ADR-CATS line and the reopened Q2.

## Report

As report-fixed.
