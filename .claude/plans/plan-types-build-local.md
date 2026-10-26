---
plan:
  status: active
  value: high
  reviewed: 2026-10-25
  class: feature
  targets: [docs/drs/automation/caching.md, pwsh/.internal/assets/bootstrap/Import-CSharpTypes.ps1]
---

# Types build local: commit the manifest, build the DLL per machine, stack builds in a developer session

A developer's pwsh session sees many file changes, and every C# edit renames a tracked binary in `pwsh/.compiled`. Git keeps only
`Catzc.Types.<hash>.json`; the DLL is built per machine into the per-user shadow cache, keyed by the hash. In the `console.*.source` cell
only, a re-import after a C# edit loads the new build beside the old one and re-points the `Catzc.*` accelerators, up to a cap. Every other
cell keeps its behaviour. Nothing spawns a process.

## Decided (the user, 2026-10-25)

- No production path changes: the side-by-side load asserts engine `pwsh` and cell `console.*.source` first; the pipeline throw in
  `Import-CSharpTypes.ps1` stays ahead of it.
- No child processes, ever, for a types reload.
- The cap is a `generations:` key in `pwsh/.internal/assets/types-load.yml`, default 1; a value above 1 in any other cell is a config error.
- The probe's facts land as ADR-BCL-TYPES-ACCELERATORSNOTFULLNAMES: code names a catzc type by its `Catzc.*` accelerator once builds can
  stack (the orchestrator, 2026-10-26).

## Facts (probe, 2026-10-25)

- Two `Add-Type`-built assemblies with the same type full names load side by side; each gets its own random assembly name.
- A full type name keeps resolving to the first-loaded build, silently; a type only the new build has resolves.
- An accelerator re-pointed with `TypeAccelerators::Remove`/`Add` resolves to the new build.
- An object of the old build does not convert to the new build's type.

## Open steps

1. [ ] Untrack the committed `pwsh/.compiled/*.dll` and commit the current manifest: the user's git step. Check: the user's commit
       (task-user-runs-and-commits), then `Import-CSharpTypes.Shipped.Tests.ps1` green.
