# Manual test plan — C# types

The shipped C# types: they parse, compile, resolve, and the committed combined assembly stays current. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Test file                                                            | FullNameFilter                                                       | Guards                                                                                                                                                                                     |
| --- | ---- | -------------------------------------------------------------------- | -------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1   | L0   | pwsh/.internal/tests/Import-CSharpTypes.Tests.ps1                    | shipped C# types                                                     | Every shipped C# type resolves into the process (`Test-ShippedTypes` reports 0 issues) and declares its module namespace (`Test-Formatting -Language bcl` reports 0 issues).               |
| 2   | L1   | pwsh/Catzc.Base.TypesSystem/tests/Get-CSharpTypeDependency.Tests.ps1 | integrity (real repo)                                                | All shipped C# type sources parse without syntax errors.                                                                                                                                   |
| 3   | L1   | pwsh/Catzc.Base.TypesSystem/tests/Clear-ModuleTypeCache.Tests.ps1    | never plans the live combined build for deletion (real repo, DryRun) | The live combined types DLL is never marked for deletion.                                                                                                                                  |
| 4   | L2   | pwsh/.internal/tests/Import-CSharpTypes.Tests.ps1                    | combined types assembly is committed and current                     | The committed combined types DLL matches current sources (`Test-BuildArtifact -Facet Types` reports 0 issues), and the IDE project stamps the current hash.                                |
| 5   | L0   | pwsh/Catzc.Base.Languages/tests/types/BclConfig.Tests.ps1            | integrity (shipped bcl.yml and the tracked solutions and projects)   | The shipped `bcl.yml` loads as `BclConfig`, every host binding names an existing type source, and every tracked non-vendored `.sln` and `.csproj` declares only the configured build pair. |
| 6   | L1   | pwsh/Catzc.Base.QualityGates/tests/Test-BclReferences.Tests.ps1      | Test-BclReferences — the shipped bcl.yml over the real type sources  | Every type source that uses `System.Management.Automation` has its `bcl.yml` row, and every row is live.                                                                                   |

## Checks

### 1. shipped C# types

**Guards:** every shipped automation C# type compiles and resolves into the process.

**Checks:**

- `Test-ShippedTypes` reports 0 issues: every shipped type's fully-qualified name (`<module>.<typename>`) resolves after import.
- `Test-Formatting -Language bcl` reports 0 issues: every source declares its module's file-scoped namespace.

### 2. integrity (real repo) — Get-CSharpTypeDependency

**Guards:** every shipped C# type loads and declares its module namespace.

**Checks:**

- The scan finds shipped `types/*.cs` sources, and every shipped type resolves after import.
- `Test-Formatting -Language bcl` reports 0 issues: every source declares its module's file-scoped namespace.

### 3. never plans the live combined build for deletion (real repo, DryRun)

**Guards:** the type-cache janitor never deletes the live combined types DLL.

**Checks:**

- `Clear-ModuleTypeCache -DryRun` over the real repo never plans the current-hash DLL for deletion.

### 4. combined types assembly is committed and current

**Guards:** the committed combined types DLL reflects current source.

**Checks:**

- `Test-BuildArtifact -Facet Types` reports 0 issues: exactly one `Catzc.Types.*.dll` exists, its hash matches the current sources, and
  `pwsh/.compiled/` has no pending git changes after import (drift guard).
- The IDE project's `dotnet build` stamps its version to the current committed hash.

**Prerequisite:** git.
