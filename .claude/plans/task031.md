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
  edges:
    cites:
      - ADR-AUTO-TYPES#16
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
2. [x] `Build-RootConfig`: the input set is the declared `sources` plus every file a wildcard entry scans plus the inputs of
       `New-GitAttributes`; make the stamp cover that set (a stamp over the scanned tree is acceptable). A test proves a change in any
       scanned file invalidates it. Check: `Build-RootConfig.Tests.ps1` passes (its four fixture-head failures are task032's); a warm run
       skips. Done 2026-10-17: `Get-RootConfigInputStamp` (declared sources, the loaded RootConfig, VSCode and Git modules and the two
       Languages generators, every existing target, the folders a wildcard entry can render into and each link's existence as salt), the
       memo `out/cache/build-rootconfig.json`, skipped under -Target, -DryRun and -PassThru; `[Invoke-TestFile] Passed` for
       Get-RootConfigInputStamp.Tests (`out/test-file/20261017-212144-de548c`) and Build-RootConfig.Tests, all of it, the four fixture-head
       cases included (`out/test-file/20261017-212149-adc484`); `MODDEP issues=0` after Folders joined RootConfig's dependencies. Warm, in
       process: 140 ms before, 31 ms after (the stamp alone 32 ms; `out/t031-b.ps1`).
3. [x] `Build-GitKeep`: depends on the folder structure; stamp over the folder listing it walks (bounded, Catzc.Base.Folders). Test as
       step 2. Check: a warm run skips; adding an empty folder invalidates. Done 2026-10-17 as the bounded walk: the PowerShell stack loop
       over the tree (100 of the 122 ms) is `Get-ChildPath -Depth 32 -File -Filter '.gitkeep'`, out/ pruned and its own keep file added by
       hand; a stamp would need the same walk, so there is none to skip. `[Invoke-TestFile] Passed`
       (`out/test-file/20261017-211836-4ad5c8`), Folders joined Docs' dependencies; warm 122 ms before, 78 ms after.
4. [x] `Sync-SessionTools`: not a generated file; its own skip check (compare the tool manifest's hash to a stamp beside the synced copy).
       Check: a warm run skips; a changed source copies again. Done 2026-10-17. Correction from the tree: the janitor copies nothing, it
       probes each tool and moves hosts and hints to the front of the session PATH, so the skip is a memo (`out/cache/session-tools.json`)
       keyed by the SHA-256 of the tool registry, the PATH the pass starts from and PATHEXT, holding the PATH the pass left and its
       advisory; a hit re-applies that PATH (announced on the information stream) and repeats the advisory without a probe, and the PATH the
       pass left is a key too, so the next pass in the same session hits. `[Invoke-TestFile] Passed` for Sync-SessionTools.Tests
       (`out/test-file/20261017-213024-44f984`, three memo cases: hit without probing, a changed PATH and a changed registry or unreadable
       memo run anew); `ANALYZER issues=0` (`out/test-script-analyzer/20261017-213032`); `FILEMETA issues=0`. Warm, in process: 388 ms
       before, 8 to 9 ms on a memo hit (`out/t031-e.ps1`).
5. [x] `Invoke-TypeCacheJanitor` and `Invoke-AgentHookJanitor`: profile both with `out/profile-janitors.ps1`; wire a skip only if one
       exceeds 100 ms warm; record the numbers. Check: numbers in the plan. Done 2026-10-17 (`out/t031-measure.ps1`, the profile script
       cannot see them since the importer module is removed after import, so the measure imports it by path): Invoke-TypeCacheJanitor 125 ms
       first, 99 ms warm (the every-byte hash the janitor keeps by ADR-AUTO-TYPES#16); Invoke-AgentHookJanitor 36 ms first, 13 ms warm.
       Neither exceeds the bar, so no skip is wired.
6. [x] New files through `Format-FileMeta`, the `.psd1` `CatzcFiles` regenerated, Test-FileMeta and Test-GeneratedFiles on the touched
       modules. Check: both clean. Done 2026-10-17: `FILEMETA issues=0` and `GENERATED issues=0` (`out/t031-d.ps1`, the import regenerates
       the manifests); the GitKeep comment page `docs/references/automation/catzc-base-docs/Build-GitKeep.ps1.md` carries its head and intro
       only now that the walk comment is one line, and `Test-Comments` reports nothing for it.
7. [x] Re-measure with `out/profile-janitors.ps1`; record the total on an unchanged tree in the plan next to the 2.6 s figure. Check: the
       number. Done 2026-10-17 (`out/t031-profile.ps1`, the same list with the two importer janitors reached by module path): 1,206 ms on
       the first call of each janitor in a fresh process, 398 ms warm; recorded in the plan.
8. [x] Tick the plan's steps; it is deleted in T036. Check: grep `- [ ]` counts zero. 2026-10-17: one line stays open, `Build-Readme`, on
       D12 (step 1); every other line is ticked.

## Report

As report-fixed, with the before and after totals.
