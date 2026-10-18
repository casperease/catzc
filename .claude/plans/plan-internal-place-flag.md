---
plan:
  status: active
  value: medium
  reviewed: 2026-10-18
  targets: [pwsh/Catzc.Base.Modules, pwsh/Catzc.Base.Variants/configs/module-types.yml, docs/adr/automation/module-model.md]
---

# Internal module places are declared, not inferred

`Get-CatzcModule` treats a module-type place nested below a track place as internal (`pwsh/.internal` under `pwsh`): a rule in code, not a
declared fact. Decided by the orchestrator 2026-10-18 on the user's delegation (ADR-PRIN-CONFIG; configure, don't program): a module-type
place declares `internal: true`, its default `false` on the config type, and the resolver reads the flag. Source:
`out/proposal-infrastructure-module-places.md`.

## Open steps

- [x] `ModuleTypesConfig`: the place key `internal` with its default declared once on the type (check: the config type's test file passes;
      Test-ShippedConfigs clean). Done 2026-10-18: `ModulePlace.internal` with `DefaultInternal = false`, a non-boolean refused;
      "[Invoke-TestFile] Passed (in-place)" for `ModuleTypesConfig.Tests.ps1`, 36 tests 0 failed (`out/test-file/20261018-194149-c2e001`);
      "No shipped-configs issues found." (`out/test-shipped-configs/20261018-194223`).
- [x] `module-types.yml`: `internal: true` on the place(s) that are internal today (`pwsh/.internal`), nothing else (check: the config's
      own test file passes). Done 2026-10-18: the `pwsh-folder` and `pwsh-psm1` places under `pwsh/.internal`; `ModuleTypesConfig.Tests.ps1`
      with `Get-PathModule.Tests.ps1` (the shipped registry) "PESTER files=2 passed=64 failed=0".
- [x] `Get-CatzcModule.ps1:42-45`: read the flag instead of comparing roots; the two `-IncludeInternal` callers in `Get-ModuleGlobSet.ps1`
      return what they return today (check: `Get-CatzcModule.Tests.ps1` with a new L0 case, a nested place with no flag is public and a
      flagged place is skipped without `-IncludeInternal`, passes; `Get-ModuleGlobSet`'s test file passes; neutral fixture names). Done
      2026-10-18: the resolver reads `$place.internal`; every real place keeps its answer (`out/probe-internal-places.ps1`: 5 places
      "same", 69 public and 78 modules with `-IncludeInternal`), so no caller changes; `Get-CatzcModule.Tests.ps1` (new case, its own
      tree) with `Get-ModuleGlobSet.Tests.ps1` "PESTER files=2 passed=28 failed=0".
- [x] ADR-AUTO-MODULE: the rule that names internal places says they are declared (check: Test-AdrRegistry, Test-Links on the page clean).
      Done 2026-10-18: no rule named internal places, so ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE now says a place declares `internal: true`
      (public by default) and the resolver never infers it from where a place sits, with its reason in "One resolver through the track";
      Test-AdrRegistry issues=0 (`out/test-adr-registry/20261018-194520`), Test-Links issues=0 (`out/test-links/20261018-194520`).
- [ ] Delete this plan (check: no file in .claude/plans names it).
