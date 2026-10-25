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

## Facts (probe, 2026-10-25)

- Two `Add-Type`-built assemblies with the same type full names load side by side; each gets its own random assembly name.
- A full type name keeps resolving to the first-loaded build, silently; a type only the new build has resolves.
- An accelerator re-pointed with `TypeAccelerators::Remove`/`Add` resolves to the new build.
- An object of the old build does not convert to the new build's type.

## Open questions

- Should the probe's facts (full names stick to the first build, accelerators re-point) land as a short rule in ADR-BCL-TYPES
  (native-csharp-types.md), so code is told to use `Catzc.*` accelerators, not full names, once builds can stack? Recommendation: yes, with
  step 8.

## Open steps

1. [ ] `docs/drs/automation/caching.md`, rule ADR-AUTO-CACHE-COMPILEDTYPEPREBUILD: rewritten so the committed artefact is the manifest and
       the DLL is a per-machine cache under the shadow root, named for the combined hash. Check: `Test-Links` and `Test-Spelling` on the
       page.
2. [ ] Importer: when no DLL exists for the current hash, `Build-CombinedTypeAssembly` compiles it into the shadow root, and
       `Import-TypesAssembly` loads it from there. Check: `pwsh/.internal/tests/Import-TypesAssembly.Tests.ps1`,
       `Build-CombinedTypeAssembly.Tests.ps1`, then a fresh full import.
3. [ ] `pwsh/.scriptanalyzer/SpellOutIdentifiers.psm1:27` and `pwsh/Catzc.Base.VSCode/types/VscodeSession.cs` find the DLL through the
       importer's lookup, not `pwsh/.compiled`. Check: their tests.
4. [ ] `pwsh/Catzc.Base.TypesSystem/Clear-ModuleTypeCache.ps1`: the "more than one committed" throw goes; it prunes the local cache. Check:
       `Clear-ModuleTypeCache.Tests.ps1`.
5. [ ] `Invoke-ModuleBuild` compiles the DLL into the bundle instead of copying a committed one; `Assert-CatzcBundle` keeps its
       one-DLL-one-manifest check. Check: `pwsh/.internal/tests/Invoke-ModuleBuild.Tests.ps1`, `Assert-CatzcBundle.Tests.ps1`.
6. [ ] `pwsh/Catzc.Base.Git/configs/gitignore.yml`: ignore `pwsh/.compiled/*.dll`; regenerate `.gitignore`; align `.gitattributes`,
       `Get-AutoControlledGlobs.ps1:49` and `Catzc.Base.TypesSystem/configs/generated.yml:9`. Check: `Get-AutoControlledGlobs.Tests.ps1`.
7. [ ] `types-load.yml` gains `generations:` (default 1, `console.*.source` rows 4); `Get-TypesLoadPolicy` validates it and rejects >1
       outside `console.*.source`. Check: the policy's L0 tests.
8. [ ] `Import-CSharpTypes.ps1:97-135`, the drift branch: after the pipeline throw, when the policy allows another generation, load the new
       build, re-point the accelerators and the display data (as `Initialize-Types` does), record the build per root in
       `$global:__CatzcDeferredTypes`, and announce it; at the cap, the existing "restart PowerShell" line. Check: an L0 test with two
       widget builds, then a fresh full import.
9. [ ] A pipeline cache of the DLL keyed by the combined hash, so CI does not compile every run. Check: one pipeline run.
