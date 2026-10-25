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
- **Out of scope** (decided as delegated, catzc-a0): joins for output and temporary files, and paths outside the repository (install
  folders, user profiles, temp staging, as in `Catzc.Tooling.Provisioning`); the bounded walker is for repository walks.
- **The config reader stays raw** (decided as delegated, catzc-e3): `Resolve-ConfigEntry`'s three listings in `Catzc.Base.Config` keep their
  raw `[System.IO.Directory]` calls, since `Catzc.Base.Folders` depends on `Catzc.Base.Config` and the walker stands on the reader
  (ADR-AUTO-DEPM); the scan's three hits there are kept for that reason.
- **`Catzc.Base.QualityGates` owners** (decided as delegated, from catzc-e3's `out/bcl-qg-prep.md`): the analyzer settings path and its rule
  modules go on `AnalyzerDrsMapConfig`, the analyzer's config type, the English dictionary pair on `SpellingOracle`, and the root tool
  configs `cspell.yml` and `.markdownlint.yml` on `RootConfigFiles`; `importer.ps1`, spelled once as the entry point, stays a literal.
- **Functions:** one that only forwards to its type is deleted and its callers call the type (PDR-ONELIVE); a public command keeps a thin
  wrapper only where it is a user-facing contract.

## The scan

`out/bcl-path-sets-scan.md` (catzc-e3, 2026-10-22): 124 functions, 78 with a hand-built path set, 57 with a raw scan, 5 reading a module
base, 3 feeding `Get-InputStamp`; 7 functions only forward. `Catzc.Base.QualityGates` holds 44. The owner type is confirmed per row in each
module's step, since the scan guesses it from a file's `Get-Config` calls and also catches joins for output and temporary files, which stay.

## Open steps

- [ ] `Catzc.Base.Overlay` and `Catzc.Base.TypesSystem` landed (catzc-a0, 2026-10-22: their other test files green, `Test-ScriptAnalyzer` at
      0 on the five files); left: `Import-CSharpTypes.Tests.ps1` (waits on the commit of `pwsh/.compiled`) and `Build-AgentHook.Tests.ps1`
      (its published-hook setups, see plan-debt-full-run-failures) green. (check: those two test files green)
