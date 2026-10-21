---
plan:
  status: active
  value: high
  reviewed: 2026-10-22
  class: feature
  targets:
    [
      pwsh/.internal/tests/Test-ScriptAnalyzer.Tests.ps1,
      pwsh/Catzc.Base.Docs/types/GlossaryConcept.cs,
      pwsh/Catzc.Base.QualityGates/configs/terminology.yml,
    ]
---

# Debt red tests: two failing tests green again before the user's full run

Two test files fail today, and a red test blocks the user's one full run. The analyzer test fails on 73 findings in 39 files (run
`out/test-file/20261022-011302-47d32f`, catzc-e9); the glossary type test fails because a rule citation of two segments is accepted (run
`out/test-file/20261022-011721-bf2e60`, catzc-e3). The chunk owns `terminology.yml` (a shared file, named owned here), the files the
analyzer findings name, and `GlossaryConcept.cs`; step 3 is an import-path burst. The analyzer run takes about 199 s, so each step proves
its files with `Test-ScriptAnalyzer -Path` on them and only step 2's end runs the whole test file.

## Open steps

1. [ ] `pwsh/Catzc.Base.QualityGates/configs/terminology.yml`: 40 of the 73 findings are `Measure-SpellOutIdentifiers` flagging the fragment
       `drs` (`Build-DrsIndex`, `Get-CatsDrsRules`, `$DrsPath` and the rest); DRS is the decided name of the decision record system
       (plan-drs-system), so `drs` is genuine vocabulary (ADR-AUTO-SPELL-FLAGGEDTOKENREVIEWED): one `terms` entry with its meaning, never a
       rename. Check: `Test-ShippedConfigs`, and `Test-ScriptAnalyzer -Path` on `pwsh/Catzc.Base.Drs` reports no `drs` fragment.
2. [ ] The other 33 findings, one file at a time, each file re-checked with `Test-ScriptAnalyzer -Path` before the next: `$bpp` in
       `Assert-BicepTemplate.Tests.ps1:61` spelled out; `Get-CatsDrsRules.ps1:18` `-DrsPath` gets `Position = 0`; `Write-Warning` in
       `Get-SyncPoint.ps1:64` and `Write-DiagramMinimapData.ps1:105` becomes `throw` or `Write-Message` as the rule says; 8 positional
       `Add-Commit` calls in `Push-Topic.Flow.Tests.ps1` named; 8 `Measure-NoTrackRootLiteral` strings in
       `Get-ModuleNeighbourhoodMinimapData.Tests.ps1`, `Repair-IdiomaticNames.Tests.ps1` and `EditRemindersConfig.Tests.ps1` resolved or
       exempted as ADR-AUTO-LAYERS allows; 10 `PSReviewUnusedParameter` in `Format-FileMeta.Tests.ps1`,
       `Get-SkippedClassCitationFinding.Tests.ps1`, `Invoke-FileMetaEngine.Tests.ps1` and `Build-RootConfig.Tests.ps1`; the `Get-ChildItem`
       in `Get-DiagramDeclarationText.Tests.ps1:30` becomes `Get-ChildPath`. Read the artifact's full message first, since it names each
       line. Check: `Invoke-TestFile -Path pwsh/.internal/tests/Test-ScriptAnalyzer.Tests.ps1` passes, in the background under its time
       limit.
3. [ ] `pwsh/Catzc.Base.Docs/types/GlossaryConcept.cs:44` checks `defined_by` against `DrsCodeForm.AnyKind.Rule`, which is a kind and two or
       more segments (`DrsCodeForm.cs:30`), so `ADR-COG-GADGET` (an ADR's code) passes where a rule's code is expected
       (`GlossaryConfig.Tests.ps1:147-152`, ADR-REPO-DRSCODE-NAMEDNOTNUMBERED). The check needs the kind-aware form `DrsCodeForm` builds
       from the registry (`DrsCodeForm.cs:47-48`), under which an ADR rule has three segments; if the type cannot reach that form when it
       parses, the step goes back to the coordinator, never a test edit. An import-path burst: `hold` to every live session, the type and
       its callers in one pass, one fresh full import, then `go`. Check:
       `Invoke-TestFile -Path pwsh/Catzc.Base.Docs/tests/types/GlossaryConfig.Tests.ps1` passes, and `Test-Glossary` reports 0 issues.
