---
plan:
  status: active
  value: high
  reviewed: 2026-10-21
  class: meta
  targets: [pwsh/Catzc.Base.Slides/Build-Diagrams.ps1, pwsh/Catzc.Base.Asserts/tests/types/ValidatePathGivenAttribute.Tests.ps1]
---

# Debt empty path

On 2026-10-21 `pwsh -File` passed a comma-joined path list as one string (twice: the orchestrator's plan rename and catzc-05's verify
script), and an empty `-Path` reached `Format-Code`, which then formatted the whole tree (1,931 files) unannounced, with no hold. An empty
`-Path` must never mean "everything"; "everything" is said by leaving `-Path` out.

## Open steps

1. [ ] `pwsh/Catzc.Base.Slides/`: after catzc-1c's diagram hold, `[Catzc.Base.Asserts.ValidatePathGiven()]` on the `-Path` of
       `Build-Diagrams`, `Test-Diagrams` and `Test-Slides`, their names added to the L1 list in `ValidatePathGivenAttribute.Tests.ps1`, and
       `Move-Diagram` (`$pages`) and `Build-Diagrams` (`$folders`) call `Format-Code`/`Test-Diagrams` only when the list holds a path
       (check: that test file, the Slides tests, a fresh import).
