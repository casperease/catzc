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
This plan holds the proof left and one known gap.

## Decided

- Known gap, a design step not yet taken: the infrastructure track and its type are declared and deployable, but
  `Get-CatzcModule -TrackType infrastructure` returns no module, because the bicep module type's places (`infrastructure/templates`,
  `infrastructure/modules`) sit below the track's place `infrastructure` and the resolver treats a nested place as internal unless
  `-IncludeInternal`.

## Open steps

- [ ] The final session's full run (`. ./importer.ps1` then `Test-Automation`, by hand, after every other task; no earlier step runs it)
      reads the two real-repo failures an agent reported (the drawio.yml live-yaml test and RootConfig New-GitAttributes) (check: that run's
      report lists neither).
- [ ] Delete this plan when the steps above are done and the decisions live in ADR-AUTO-MODULE (check: no file in .claude/plans names it).

## Refs

- docs/adr/automation/module-model.md (ADR-AUTO-MODULE), docs/adr/design/tracks.md
