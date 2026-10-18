---
plan:
  status: active
  value: high
  reviewed: 2026-10-18
  waits_on: the final session's full run (task-user-runs-and-commits, last step)
  targets: [pwsh/Catzc.Base.Modules, pwsh/Catzc.Base.ModuleSystem, docs/adr/automation/module-model.md, docs/references/pwsh]
---

# Module model: close-out after the implement run

The module model is in the tree: Get-CatzcModule and Get-Aspect in Catzc.Base.Modules, Get-ModuleOrder in ModuleSystem, ADR-AUTO-MODULE.
This plan holds the proof left. The infrastructure-track gap is closed: the track's places are the bicep places (`variants.yml`), 22
modules resolve, and `Get-CatzcModule.Tests.ps1` pins it (`out/proposal-infrastructure-module-places.md`).

## Open steps

- [ ] The final session's full run (`. ./importer.ps1` then `Test-Automation`, by hand, after every other task; no earlier step runs it)
      reads the two real-repo failures an agent reported (the drawio.yml live-yaml test and RootConfig New-GitAttributes) (check: that run's
      report lists neither).
  - Run alone 2026-10-18, both green: "[Invoke-TestFile] Passed (in-place)" for
    `pwsh/Catzc.Base.RootConfig/tests/New-GitAttributes.Tests.ps1` (`out/test-file/20261018-193802-4b4e05`) and for `pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1`, whose repository run holds the
    `.claude/drawio/drawio.yml` stack check (`out/test-file/20261018-193827-ca7b54`). The box still closes on the final run.
- [ ] Delete this plan when the steps above are done and the decisions live in ADR-AUTO-MODULE (check: no file in .claude/plans names it).

## Refs

- docs/adr/automation/module-model.md (ADR-AUTO-MODULE), docs/adr/design/tracks.md
