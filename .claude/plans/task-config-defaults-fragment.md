---
task:
  status: open
  plans: [plan-config-defaults]
  value: high
  blocked_on: steps 3 and 4 wait for the user's choice of the .catzc track's type and vendor; steps 5 and 6 can start
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

# Task: config defaults Phases 2 and 3, the repo fragment and the generated defaults contract

Decided: Q3 the shipped variants.yml is deleted and a typed config with no file is built from an empty map plus the fragment; Q5 source mode
reads this repository's own config fragments only; the folder is `.catzc/` with no alias (ADR-CATS#5 supersedes Q6); Q4 a new contract asset
kind `defaults`; Q7 a required key is named in a header comment of the generated file, never given a value. The track folder is resolved
through the one resolver (Get-Track or Get-CatzcModulesRoot), never an `automation` literal, so the later pwsh rename is a data edit.

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
3. Waits for the user (2026-10-18): the world map fails a tracked file in no track, and `.catzc` is a new root folder no track declares.
   Declaring it means choosing its track type and vendor; `vendor-settings` with catzc as its vendor is the nearest fit, which makes catzc
   the vendor of its own settings. Create `.catzc/<track>/Catzc.Base.Variants/configs/variants.yml` with this repository's `tracks`,
   `aspects` and `have_customers: all` (copied from the shipped file). Check: `Get-Config -Config variants` in source mode returns the same
   object as before (compare the two serialisations in a test or a background script).
4. Delete `automation/Catzc.Base.Variants/configs/variants.yml` and its reference page; regenerate heads, READMEs and links
   (Format-FileMeta, Build-Readme in the background). Check: Test-GeneratedFiles, Test-Links clean; the five getters' tests still pass.
5. `automation/Catzc.Base.Contracts/Build-ConfigDefaultsContract.ps1`, new: for a registered overridable config type, writes
   `contracts/catzc/0.0.0/<Module>/configs/<name>.yml` from the type's defaults: defaulted keys with literals, empty-valid keys empty,
   required keys named in the header comment and omitted; header note per ADR-REPO-CONTRACT#9; asset kind `defaults` (direction provided)
   added to the contract asset kinds config with its default declared once on the type. Test with a fixture type. Check: its Pester file
   passes.
6. Run it for variants; `Test-Contracts` and `Test-GeneratedFiles` compare the regenerated defaults to the file; `Build-ContractReference`
   lists it; `.gitattributes` and the `contract-asset` kind already cover the folder (verify by `git check-attr`). Check: both gates clean;
   the reference page lists the asset.
7. `plan-config-defaults.md`: tick Phases 2 and 3. Check: grep `- [ ]` counts Phases 4 and 5 only.

## Report

As report-fixed.
