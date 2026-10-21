---
plan:
  status: active
  value: low
  reviewed: 2026-10-21
  class: feature
  targets:
    [
      docs/references/pwsh/catzc-base-qualitygates/private/Get-RelativeEdgesFileMetaFact.ps1.md,
      pwsh/Catzc.Base.QualityGates/private/Get-FileMetaInputStamp.ps1,
      pwsh/Catzc.Base.QualityGates/private/Get-RelativeEdgesFileMetaFact.ps1,
      docs/adr/automation/caching.md,
    ]
---

# File-meta result cache: the last inputs a head reads

Format-FileMeta and Format-Code's file-meta step share one result cache. A file's key holds its own bytes, the step's settings files and a
stamp of the files beside it (its comment page, its relations' candidates, Get-FileMetaInputStamp). Left: a help line Format-Code flags, one
input the key still lacks, its sentence in the ADR, and one strict-mode finding.

## Why its value is low

Test-FileMeta keeps no cache, so it still catches a stale head; `-NoCache` repairs one.

## Decided (the user, 2026-10-21, decision round)

- **The ADR code map joins the key as a code stamp**: `Get-FileMetaInputStamp` adds a hash of the registered codes (`Get-AdrCitationMap`),
  so only a change to the codes rechecks a file. A `languages.yml` settings line is too coarse: the map is built from the index and every
  ADR's rule headings, so it would name every ADR file and recheck the tree on any ADR edit.
- **The beside-file input is one sentence in caching.md's "Result caches for quality checks" section**, not in the rule: a check whose
  verdict reads files beside the file stamps them into that file's key, with `Get-FileMetaInputStamp` as the exemplar.

## Open steps

1. [ ] `docs/references/pwsh/catzc-base-qualitygates/private/Get-RelativeEdgesFileMetaFact.ps1.md`: reword the "It rests on" sentence of the
       description so that no wrapped line holds only a citation link. Check:
       `Format-Code -Path pwsh/Catzc.Base.QualityGates/private/Get-RelativeEdgesFileMetaFact.ps1` reports no hand edit.
2. [ ] `pwsh/Catzc.Base.QualityGates/private/Get-FileMetaInputStamp.ps1`: add the hash of the registered ADR codes to the stamp of a file
       whose kinds include `adr-codes`. Check: `Invoke-TestFile` on its tests with a case where a new code changes the stamp, then
       `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1`.
3. [ ] `docs/adr/automation/caching.md`: add the sentence to "Result caches for quality checks". Check:
       `Test-Links -Path docs/adr/automation/caching.md` and `Test-Spelling` pass.
4. [ ] `pwsh/Catzc.Base.QualityGates/private/Get-RelativeEdgesFileMetaFact.ps1`: fix the strict-mode collapse the
       `Measure-NoCollapsingAssignment` rule flags (reported at line 44; from plan-listen-agent, held while a peer had the file open).
       Check: `Invoke-ScriptAnalyzer` on the file reports no `Measure-NoCollapsingAssignment` finding, and `Invoke-TestFile` on its test
       passes.
