---
plan:
  status: active
  value: high
  reviewed: 2026-10-22
  class: feature
  targets: [pwsh/Catzc.Base.QualityGates, pwsh/Catzc.Base.Folders, pwsh/Catzc.Base.RootConfig]
---

# BCL path sets: hand-built path lists move into helpers on the types that own them

Functions in the non-internal modules assemble file-path sets by hand: a module base from `(Get-Module …).ModuleBase`, `Join-Path` with
literal file names, a raw `[System.IO.Directory]::GetFiles` scan, then a sort-unique list for `Get-InputStamp` (`Get-FileMetaEngineStamp` is
the sample). The knowledge of which files make up a set lives in PowerShell literals, while the types it describes know nothing of it.

## Why its value

One mechanism per kind (configure, don't program): the type that owns a set of files says which files they are, compiled and tested once,
and a scan goes through the bounded walker; the functions shrink or go, and a new input is one line on its type.

## Decided (the user, 2026-10-22)

- **In scope:** every public and private `.ps1` of the non-internal modules (`pwsh/Catzc.*`, not `pwsh/.internal`) that builds a path set
  from module bases, literal file names and folder scans, or enumerates folders with raw `[System.IO.Directory]` calls.
- **Where:** each set is a method on the type that owns it (for example `FileMetaConfig.EngineInputs(qualityGatesBase, languagesBase)`),
  built on one shared BCL path-set helper (sorted, unique, scanning through the bounded walker of `Catzc.Base.Folders`).
- **Functions:** one that only forwards to its type is deleted and its callers call the type (PDR-ONELIVE); a public command keeps a thin
  wrapper only where it is a user-facing contract.

## The scan

`out/bcl-path-sets-scan.md` (catzc-e3, 2026-10-22): 124 functions, 78 with a hand-built path set, 57 with a raw scan, 5 reading a module
base, 3 feeding `Get-InputStamp`; 7 become pass-throughs. `Catzc.Base.QualityGates` holds 44. The owner type is confirmed per row in each
module's step, since the scan guesses it from a file's `Get-Config` calls and also catches joins for output and temporary files, which stay.

## Open steps

- [ ] The shared helper: a BCL path-set type (add a file under a base, add a pattern through the bounded walker, sorted unique result) in
      the module that owns path facts, with its type tests. Import-path, a burst. (check: its type test file green, one fresh full import)
- [ ] The pilot: `FileMetaConfig.EngineInputs` replaces the body of `Get-FileMetaEngineStamp`, which goes if only a pass-through; the stamp
      measured before and after (same hash, timing compared, as type-first changes are measured). (check:
      `Get-FileMetaEngineStamp.Tests.ps1` or its successor green, the same stamp value for the same tree)
- [ ] The rest, one module at a time in the scan's order, each module's sets moved to their types and its pass-throughs deleted with their
      callers. (check: per module, its test files green, `Test-ScriptAnalyzer` at 0, and the scan's hits for it at 0 by grep)
