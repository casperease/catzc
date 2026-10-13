# docs/how-to/automation/manual-test-plan/csharp-types.md

`Manual test plan — C# types`

The shipped C# types: they parse, compile, resolve, and the committed combined assembly stays current. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Test file                                                                  | FullNameFilter                                                       | Guards                                                                  |
| --- | ---- | -------------------------------------------------------------------------- | -------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| 1   | L0   | automation/.internal/tests/Import-CSharpTypes.Tests.ps1                    | shipped C# types                                                     | Every shipped C# type compiles and resolves into the process, and declares its module namespace (`Test-Formatting -Formatter Format-Types` reports 0 issues). |
| 2   | L0   | automation/.internal/tests/Import-CSharpTypes.Tests.ps1                    | DictionaryRecord (shared cross-module base)                          | The shared cross-module `DictionaryRecord` base and its dict-view work. |
| 3   | L1   | automation/Catzc.Base.TypesSystem/tests/Get-CSharpTypeDependency.Tests.ps1 | integrity (real repo)                                                | All shipped C# type sources parse without syntax errors.                |
| 4   | L1   | automation/Catzc.Base.TypesSystem/tests/Clear-ModuleTypeCache.Tests.ps1    | never plans the live combined build for deletion (real repo, DryRun) | The live combined types DLL is never marked for deletion.               |
| 5   | L2   | automation/.internal/tests/Import-CSharpTypes.Tests.ps1                    | combined types assembly is committed and current                     | The committed combined types DLL matches current sources (`Test-BuildArtifact -Facet Types` reports 0 issues), and the IDE project stamps the current hash. |

## Checks

### 1. shipped C# types

**Guards:** every shipped automation C# type compiles and resolves into the process.

**Checks:**

- At least one C# type source exists (guards against a vacuous pass).
- Every shipped type's fully-qualified name (`<module>.<typename>`) resolves after import.

### 2. DictionaryRecord (shared cross-module base)

**Guards:** the shared cross-module `Catzc.Base.Utils`-era `DictionaryRecord` base and its dictionary view.

**Checks:**

- A derived record (`BicepTemplate`) inherits `DictionaryRecord`.
- `Contains`, the indexer, `Keys`, and `ToHashtable` expose only non-null data properties (not base members).
- A derived type in another module can call the inherited extraction helpers.

### 3. integrity (real repo) — Get-CSharpTypeDependency

**Guards:** every shipped C# type loads and declares its module namespace.

**Checks:**

- The scan finds shipped `types/*.cs` sources, and every shipped type resolves after import.
- `Test-Formatting -Formatter Format-Types` reports 0 issues: every source declares its module's file-scoped namespace.

### 4. never plans the live combined build for deletion (real repo, DryRun)

**Guards:** the type-cache janitor never deletes the live combined types DLL.

**Checks:**

- `Clear-ModuleTypeCache -DryRun` over the real repo never plans the current-hash DLL for deletion.

### 5. combined types assembly is committed and current

**Guards:** the committed combined types DLL reflects current source.

**Checks:**

- `Test-BuildArtifact -Facet Types` reports 0 issues: exactly one `Catzc.Types.*.dll` exists, its hash matches the current sources, and
  `automation/.compiled/` has no pending git changes after import (drift guard).
- The IDE project's `dotnet build` stamps its version to the current committed hash.

**Prerequisite:** git.
