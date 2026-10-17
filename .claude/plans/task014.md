---
task:
  id: "014"
  status: open
  plans: [plan-config-defaults]
  value: high
  blocked_on: task011 (shared VariantsConfig.cs and VariantTrack.cs, Q20); the module-model plan owns those files first
  targets: [automation/Catzc.Base.Variants, automation/Catzc.Base.Modules]
---

# task014: config defaults Phase 1, the variants type carries its defaults

Decided (Q1 to Q7, Q13 to Q21): a default is declared once on the config type as constants; no getter restates it; every property has one
posture: defaulted, empty-is-valid or required (throws at construction naming the key and the fix). Variants is the pilot: ado_naming
standard, git_workspace main-direct, have_customers false, aspects a per-track universal catch-all, tracks required. ADR-AUTO-DEFAULT#6 is
the rule being repaired. C# edits need a fresh pwsh; tests in the background.

## Steps

1. `git status --short automation/Catzc.Base.Variants`: `Get-Track.ps1` and its test were dirty in the user's tree on 2026-10-16; if still
   dirty, leave them and say so. Check: the status is recorded.
2. Locate the five getters (`grep -rln "Get-Variant\b" automation --include=*.ps1`; Get-Variant is private or renamed, Get-Aspect lives in
   Catzc.Base.Modules). List them with their `-Default` literals in the plan. Check: the list has every literal.
3. `automation/Catzc.Base.Variants/types/VariantsConfig.cs`: constants `DefaultAdoNaming = "standard"`, `DefaultGitWorkspace = "main-direct"`,
   `DefaultHaveCustomers = false`, the aspects catch-all built per track when the map has no entry; `Tracks` required: construction throws
   with the key name and "add tracks: to variants.yml or the repo fragment". No other file changes in this step. Check: the file compiles
   (fresh pwsh import); `VariantsConfig.Tests.ps1` fails only on the new behaviour.
4. `automation/Catzc.Base.Variants/tests/types/VariantsConfig.Tests.ps1`: an empty map yields the four defaults; `tracks` omitted throws
   naming the key; null and omitted agree; an unknown key is rejected as before. Neutral fixture names. Check: passes.
5. `VariantTrack.cs` only if T011 did not add `execution_engines` with its default; otherwise no edit. Check: its test passes.
6. The private variant reader (`Get-Variant` or its successor): drop `-Default`; it returns the typed property. Check: its test passes.
7. One getter per step, each with its test: `Get-AdoNaming`, `Get-GitWorkspace`, `Get-EnabledCustomers` (have_customers false means none;
   this repo's fragment will say all in T015, until then the shipped variants.yml keeps `all`), `Get-Aspect` (Catzc.Base.Modules), `Get-Track`
   (if not dirty). Each loses its literal and reads the type. Check: each getter's Pester file passes; `have_customers` agrees across the
   getter and the type test.
8. `plan-config-defaults.md`: tick the Phase 1 step with the test counts; the scratchpad-copy and paste steps are superseded by this task
   (record that under Done, and why). Check: grep `- [ ]` counts the Phase 2 to 5 steps only.

## Report

As report-fixed.
