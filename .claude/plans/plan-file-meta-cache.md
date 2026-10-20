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
      docs/adr/automation/caching.md,
    ]
---

# File-meta result cache: the last inputs a head reads

Format-FileMeta and Format-Code's file-meta step share one result cache. A file's key holds its own bytes, the step's settings files and a
stamp of the files beside it (its comment page, its relations' candidates, Get-FileMetaInputStamp). Two things are left: a help line
Format-Code flags, and one input the key still lacks.

## Why its value is low

Test-FileMeta keeps no cache, so it still catches a stale head; `-NoCache` repairs one.

## Open questions

- **Q1: Does the ADR citation map join the file-meta step's stamp?** A head's `cites` keep only the codes the ADR index registers
  (Get-AdrCitationMap), so a change to the index can leave a cached head stale. Recommendation: yes, add the index's source files to the
  file-meta step's `settings:` in `languages.yml`. It is a config change that rechecks every file once whenever the index changes.
- **Q2: Does ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS name a per-file input beside the file?** The rule's context says a verdict is "a pure
  function of the file's bytes, the tool version, and the tool's settings", but the file-meta step also reads files beside each file.
  Recommendation: yes, one sentence: a check whose verdict reads files beside the file stamps them into that file's key, with
  Get-FileMetaInputStamp as the exemplar.
- **Q3: Does the `catzc-run` capability carry the probe pattern for a private function?** A probe script calls a module's private function
  with `& (Get-Module <name>) { … }`, where a script-scope variable of the caller is not visible. Recommendation: no; it costs one failed
  probe to rediscover, and the capability roof is tight.

## Open steps

1. [ ] `docs/references/pwsh/catzc-base-qualitygates/private/Get-RelativeEdgesFileMetaFact.ps1.md`: reword the "It rests on" sentence of the
       description so that no wrapped line holds only a citation link. Check:
       `Format-Code -Path pwsh/Catzc.Base.QualityGates/private/Get-RelativeEdgesFileMetaFact.ps1` reports no hand edit.
2. [ ] `pwsh/Catzc.Base.Languages/configs/languages.yml`: once Q1 is answered yes, add the ADR index's source files to
       `steps.file-meta.settings`. Check: `Invoke-TestFile pwsh/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1` passes.
3. [ ] `docs/adr/automation/caching.md`: once Q2 is answered yes, add the sentence to "Result caches for quality checks". Check:
       `Test-Links -Path docs/adr/automation/caching.md` and `Test-Spelling` pass.
