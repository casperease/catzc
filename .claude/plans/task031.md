---
task:
  id: "031"
  status: open
  plans: [plan-skip-unchanged-generators]
  value: medium
  blocked_on: D12 for step 1
  targets:
    [
      automation/Catzc.Base.Files,
      automation/Catzc.Base.RootConfig,
      automation/Catzc.Base.Docs,
      automation/.internal/Catzc.Internal.Importer.psm1,
    ]
catzc:
  immutable:
    with_body_sha: efc6ba8ade0b
    repo_status: clean
    path: ".claude/plans/task031.md"
    folder: plans
    name: task031
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# task031: skip unchanged inputs in the remaining import-time generators

Landed: `Get-InputStamp` over the compiled `InputStamp`, `Format-GeneratedFileHead -InputsSha`, `with_inputs_sha`,
`Test-GeneratedFileCurrent`; wired into Build-Glossary, Build-AdrIndex, Build-TerminologyDictionary, Build-ContractReference (25 to 67 ms
each on a skip). Measured 2026-10-17: Build-RootConfig 562 ms, Sync-SessionTools 403 ms, Build-Readme 315 ms, Build-GitKeep 312 ms; the
finalizer 2.6 s. Done when `out/profile-janitors.ps1` is re-measured and every generator is wired with its inputs proven complete or
recorded as not skippable.

## Steps

1. D12 Build-Readme: record "not skippable" with the profile (200 of 315 ms is first-call JIT), or if the user chose the stamp, add
   `with_inputs_sha` to the README meta block through `Build-Readme`, `Test-GeneratedReadmes` and the meta gates, regenerating the about 55
   copies. Check: the Decided line, or Test-GeneratedReadmes clean.
2. `Build-RootConfig`: the input set is the declared `sources` plus every file a wildcard entry scans plus the inputs of
   `New-GitAttributes`; make the stamp cover that set (a stamp over the scanned tree is acceptable). A test proves a change in any scanned
   file invalidates it. Check: `Build-RootConfig.Tests.ps1` passes (its four fixture-head failures are task032's); a warm run skips.
3. `Build-GitKeep`: depends on the folder structure; stamp over the folder listing it walks (bounded, Catzc.Base.Folders). Test as step 2.
   Check: a warm run skips; adding an empty folder invalidates.
4. `Sync-SessionTools`: not a generated file; its own skip check (compare the tool manifest's hash to a stamp beside the synced copy).
   Check: a warm run skips; a changed source copies again.
5. `Invoke-TypeCacheJanitor` and `Invoke-AgentHookJanitor`: profile both with `out/profile-janitors.ps1`; wire a skip only if one exceeds
   100 ms warm; record the numbers. Check: numbers in the plan.
6. New files through `Format-FileMeta`, the `.psd1` `CatzcFiles` regenerated, Test-FileMeta and Test-GeneratedFiles on the touched modules.
   Check: both clean.
7. Re-measure with `out/profile-janitors.ps1`; record the total on an unchanged tree in the plan next to the 2.6 s figure. Check: the
   number.
8. Tick the plan's steps; it is deleted in T036. Check: grep `- [ ]` counts zero.

## Report

As report-fixed, with the before and after totals.
