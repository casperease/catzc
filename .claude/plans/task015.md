---
task:
  id: "015"
  status: open
  plans: [plan-config-defaults]
  value: high
  blocked_on: task006 (ADR-CATS#5 names the folder) and task014
  targets:
    [
      automation/Catzc.Base.Config,
      automation/Catzc.Base.Overlay,
      automation/Catzc.Base.Variants/configs/variants.yml,
      automation/Catzc.Base.Contracts,
      .catzc,
      contracts/catzc/0.0.0,
    ]
catzc:
  immutable:
    with_body_sha: "234ff4c248d2"
    repo_status: clean
    path: ".claude/plans/task015.md"
    folder: plans
    name: task015
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
      - ADR-REPO-CONTRACT#9
---

# task015: config defaults Phases 2 and 3, the repo fragment and the generated defaults contract

Decided: Q3 the shipped variants.yml is deleted and a typed config with no file is built from an empty map plus the fragment; Q5 source
mode reads this repository's own config fragments only; the folder is `.catzc/` with no alias (ADR-CATS#5 from task006 supersedes Q6);
Q4 a new contract asset kind `defaults`; Q7 a required key is named in a header comment of the generated file, never given a value. The
track folder is resolved through the one resolver (Get-Track or Get-CatzcModulesRoot), never an `automation` literal, so the later pwsh
rename is a data edit.

## Steps

1. `automation/Catzc.Base.Config/private/Get-ConfigOverlayRoot.ps1` (and `Get-CatzcOverlayRoot` where it lives): source mode returns the
   repository's config-fragment root `.catzc/<track>/` resolved through the resolver; no `.cats` branch. Tests: source-mode root, build-mode
   root unchanged, a `.cats/` folder present is ignored and reported once as a finding by the gate that owns folder hygiene. Check: the
   Pester files of both functions pass.
2. `Resolve-ConfigEntry.ps1` and `Get-Config.ps1`: a registered type with no shipped file builds from `{}` merged with the fragment; a sealed
   config (`overridable: false`) takes defaults and refuses a fragment with a message naming the key. Tests for both. Check: `Get-Config.Tests`
   passes; `Test-ShippedConfigs` and `Test-ConfigValidators` accept a type without a file.
3. Create `.catzc/<track>/Catzc.Base.Variants/configs/variants.yml` with this repository's `tracks`, `aspects` and `have_customers: all`
   (copied from the shipped file). Check: `Get-Config -Config variants` in source mode returns the same object as before (compare the two
   serialisations in a test or a background script).
4. Delete `automation/Catzc.Base.Variants/configs/variants.yml` and its reference page; regenerate heads, READMEs and links (Format-FileMeta,
   Build-Readme in the background). Check: Test-GeneratedFiles, Test-Links clean; the five getters' tests still pass.
5. `automation/Catzc.Base.Contracts/Build-ConfigDefaultsContract.ps1`, new: for a registered overridable config type, writes
   `contracts/catzc/0.0.0/<Module>/configs/<name>.yml` from the type's defaults: defaulted keys with literals, empty-valid keys empty, required
   keys named in the header comment and omitted; header note per ADR-REPO-CONTRACT#9; asset kind `defaults` (direction provided) added to
   the contract asset kinds config with its default declared once on the type. Test with a fixture type. Check: its Pester file passes.
6. Run it for variants; `Test-Contracts` and `Test-GeneratedFiles` compare the regenerated defaults to the file; `Build-ContractReference`
   lists it; `.gitattributes` and the `contract-asset` kind already cover the folder (verify by `git check-attr`). Check: both gates clean;
   the reference page lists the asset.
7. `plan-config-defaults.md`: tick Phases 2 and 3. Check: grep `- [ ]` counts Phases 4 and 5 only.

## Report

As report-fixed.
