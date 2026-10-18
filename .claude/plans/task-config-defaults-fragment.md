---
task:
  status: open
  plans: [plan-config-defaults]
  value: high
  blocked_on: steps 3 and 4 wait for the user's choice of the .catzc track's type and vendor; step 5 can start
  targets:
    [
      automation/Catzc.Base.Config,
      automation/Catzc.Base.Overlay,
      automation/Catzc.Base.Variants/configs/variants.yml,
      automation/Catzc.Base.Contracts,
      .catzc,
      contracts/catzc/0.0.0,
    ]
---

# Task: config defaults Phases 2 and 3, the repo fragment and the defaults check

Decided: D22 (2026-10-18) defaults live in the shipped config assets and on the config types, matching unless a reason says why, which keeps
the shipped variants.yml and replaces Q3's deletion and Q4's defaults asset; a typed config with no file is built from an empty map plus the
fragment; Q5 source mode reads this repository's own config fragments only; the folder is `.catzc/` with no alias (ADR-CATS#5 supersedes
Q6); Q4 a new contract asset kind `defaults`; Q7 a required key is named in a header comment of the generated file, never given a value. The
track folder is resolved through the one resolver (Get-Track or Get-CatzcModulesRoot), never an `automation` literal, so the later pwsh
rename is a data edit.

## Steps

1. [x] `automation/Catzc.Base.Config/private/Get-ConfigOverlayRoot.ps1` (and `Get-CatzcOverlayRoot` where it lives): source mode returns the
       repository's config-fragment root `.catzc/<track>/` resolved through the resolver; no `.cats` branch. Tests: source-mode root,
       build-mode root unchanged, a `.cats/` folder present is ignored and reported once as a finding by the gate that owns folder hygiene.
       Check: the Pester files of both functions pass. Done 2026-10-18. Corrections from the tree: Config and Repository sit below Variants
       in the module graph, so neither may call `Get-Track`; the source-mode root takes the modules folder's name from
       `Get-CatzcModulesRoot`, and the change lives in `Get-ConfigOverlayRoot` only, because `Get-CatzcOverlayRoot` also feeds the
       module-root and overlay functions, which source mode must not see (Q5). `Get-CatzcOverlay` and `Assert-CatzcOverlay` no longer spell
       `.catzc/automation` (the prefix comes from the overlay root), so the folder is spelled once, in `Get-CatzcOverlayRoot` beside the
       bootstrap literal of `Get-CatzcModulesRoot`. No code reads or writes `.cats` (ADR-CATS#5 holds already), so there is no branch to
       remove; the hygiene finding for a stray `.cats/` folder is not built, and stays open here. Verdicts: `[Invoke-TestFile] Passed` for
       Get-ConfigOverlayRoot.Tests (two new source-mode cases, `out/test-file/20261018-124036-6ea3e9`), Get-Config.Tests,
       Get-CatzcOverlay.Tests, Assert-CatzcOverlay.Tests and Import-CatzcOverlay.Tests (`20261018-124045` to `-124107`);
       `ANALYZER issues=0`; no `catzc/automation` literal left in the three files.
2. [x] `Resolve-ConfigEntry.ps1` and `Get-Config.ps1`: a registered type with no shipped file builds from `{}` merged with the fragment; a
       sealed config (`overridable: false`) takes defaults and refuses a fragment with a message naming the key. Tests for both. Check:
       `Get-Config.Tests` passes; `Test-ShippedConfigs` and `Test-ConfigValidators` accept a type without a file. Done 2026-10-18:
       `Resolve-ConfigEntry` lists a registered config with no file under the module its type's namespace names, with no path; `Get-Config`
       builds it from an empty map, merges the fragment and refuses one for a sealed config through the existing check. Two new cases;
       `[Invoke-TestFile] Passed` for Get-Config.Tests (`out/test-file/20261018-124212-7c7ab1`); `SHIPPED issues=0`, `VALIDATORS issues=0`,
       `ANALYZER issues=0`.
3. Waits for the user: the world map fails a tracked file in no track, and `.catzc` is a new root folder no track declares. Declaring it
   means choosing its track type and vendor; `vendor-settings` with catzc as its vendor is the nearest fit, which makes catzc the vendor of
   its own settings (D22 answered the defaults, not this). Create `.catzc/<track>/Catzc.Base.Variants/configs/variants.yml` with this
   repository's own `tracks`, `aspects` and `have_customers: all`. Check: `Get-Config -Config variants` in source mode returns the same
   object as before (compare the two serialisations in a test or a background script).
4. `automation/Catzc.Base.Variants/configs/variants.yml` stays and shows the sensible defaults (D22): the values the `VariantsConfig` type
   declares (`ado_naming: standard`, `git_workspace: main-direct`, `have_customers: false`, the infrastructure aspect), with this
   repository's own values moved to its fragment in step 3; `tracks` is required and has no default, so the shipped file names it in a
   comment and the fragment gives it. Check: the five getters' tests pass; Test-ShippedConfigs clean.
5. [x] The defaults check (D22: defaults live in both the shipped config assets and the config types, and most of the time they match): for
       every registered config type with a shipped file, compare each key the file states with the default the type declares for it, and
       report a key whose two values differ unless the config's entry in `configs.yml` lists it under `differs` with a one-sentence reason
       (configure, don't program; the reason is the data). The type declares a key's default as its `Default<Key>` constant, the key in
       Pascal case (`DefaultAdoNaming` for `ado_naming`), the convention the types follow today; a key with no such constant compares
       nothing, and a typed default (a list or map, such as `DefaultAspects`) compares through its own serialisation or is named as not
       compared. Built as a case of Test-ShippedConfigs with L0 tests over a widget fixture type, never a second gate. Check: its Pester
       file passes; Test-ShippedConfigs on the tree lists the real differences, each then given its reason or its value matched, one config
       per step. Done 2026-10-18: `ConfigDefaultDifference.Compare` (C#, Catzc.Base.Config) compares scalars only; `ConfigsConfig` reads
       `differs` per entry (a reason required); Test-ShippedConfigs reports an unexplained difference and a reason whose values agree. On
       the tree it found one difference, variants `have_customers: all` against the type's false, given its reason in configs.yml (this
       repository enables every customer) until step 3 moves the value to the fragment. Verdicts: `[Invoke-TestFile] Passed` for
       Get-Config.Tests (two new cases) and Test-ShippedConfigs.Tests (three new cases, `out/test-file/20261018-134213-e92d7e`);
       `SHIPPED issues=0`, `VALIDATORS issues=0`, `SHIPPEDTYPES issues=0`, the analyzer and the glossary clean.
6. [x] No generated defaults contract: the shipped config asset is the published default (D22 drops Q4's `defaults` asset kind and
       Build-ConfigDefaultsContract). Done 2026-10-18: ADR-AUTO-DEFAULT#6 and its "Where defaults come from" section say the default is
       programmed on the type as its `Default<Key>` constant and shown in the shipped file, the two agreeing unless `differs` gives the
       reason. Check: `ADRREG issues=0`, `LINKS issues=0` on the ADR.
7. `plan-config-defaults.md`: tick Phases 2 and 3 when steps 3 to 6 are in the tree. Check: grep `- [ ]` counts Phases 4 and 5 only.

## Report

As report-fixed.
