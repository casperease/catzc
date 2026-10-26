# Manual test plan — C# types

The shipped C# types: they parse, compile, resolve, and the committed combined assembly stays current. Part of the
[manual test plan](../manual-test-plan.md), which says how to run a check.

## Index

| #   | Tier | Check                                                                      |
| --- | ---- | -------------------------------------------------------------------------- |
| 1   | L0   | [shipped C# types][c1]                                                     |
| 2   | L1   | [integrity (real repo) — Get-CSharpTypeDependency][c2]                     |
| 3   | L1   | [never plans the live combined build for deletion (real repo, DryRun)][c3] |
| 4   | L2   | [combined types surface matches its contract][c4]                          |
| 5   | L0   | [integrity (shipped bcl.yml and the tracked solutions and projects)][c5]   |
| 6   | L1   | [Test-BclReferences — the shipped bcl.yml over the real type sources][c6]  |
| 7   | L2   | [CodeMetaHead and the types hash agree on every C# type][c7]               |

[c1]: #1-shipped-c-types
[c2]: #2-integrity-real-repo--get-csharptypedependency
[c3]: #3-never-plans-the-live-combined-build-for-deletion-real-repo-dryrun
[c4]: #4-combined-types-surface-matches-its-contract
[c5]: #5-integrity-shipped-bclyml-and-the-tracked-solutions-and-projects
[c6]: #6-test-bclreferences--the-shipped-bclyml-over-the-real-type-sources
[c7]: #7-codemetahead-and-the-types-hash-agree-on-every-c-type

## Checks

### 1. shipped C# types

**Test file:** `pwsh/.internal/tests/Import-CSharpTypes.Shipped.Tests.ps1` (L0), block `shipped C# types`.

**Guards:** every shipped automation C# type compiles and resolves into the process.

**Checks:**

- `Test-ShippedTypes` reports 0 issues: every shipped type's fully-qualified name (`<module>.<typename>`) resolves after import.
- `Test-Formatting -Language bcl` reports 0 issues: every source declares its module's file-scoped namespace.

### 2. integrity (real repo) — Get-CSharpTypeDependency

**Test file:** `pwsh/Base.TypesSystem/tests/Get-CSharpTypeDependency.Tests.ps1` (L1), block `integrity (real repo)`.

**Guards:** every shipped C# type loads and declares its module namespace.

**Checks:**

- The scan finds shipped `types/*.cs` sources, and every shipped type resolves after import.
- `Test-Formatting -Language bcl` reports 0 issues: every source declares its module's file-scoped namespace.

### 3. never plans the live combined build for deletion (real repo, DryRun)

**Test file:** `pwsh/Base.TypesSystem/tests/Clear-ModuleTypeCache.Tests.ps1` (L1), block
`never plans the live combined build for deletion (real repo, DryRun)`.

**Guards:** the type-cache janitor never deletes the live combined types DLL.

**Checks:**

- `Clear-ModuleTypeCache -DryRun` over the real repo never plans the current-hash DLL for deletion.

### 4. combined types surface matches its contract

**Test file:** `pwsh/.internal/tests/Import-CSharpTypes.Shipped.Tests.ps1` (L2), block `combined types surface matches its contract`.

**Guards:** the committed types contract, `contracts/catzc/0.1.0/catzc.internal.types/types.sample.json`, is the surface the current type
sources build to.

**Checks:**

- `Test-BuildArtifact -Facet Types` reports 0 issues: the current sources' build exists in the shadow root, its surface (each type's name,
  aliases and display) is the committed contract with no type added, removed or changed, and the contract has no pending git changes.
- The IDE project's `dotnet build` stamps its version to the current committed hash.

**Prerequisite:** git.

### 5. integrity (shipped bcl.yml and the tracked solutions and projects)

**Test file:** `pwsh/Base.Languages/tests/types/BclConfig.Tests.ps1` (L0), block
`integrity (shipped bcl.yml and the tracked solutions and projects)`.

**Guards:** The shipped `bcl.yml` loads as `BclConfig`, every host binding names an existing type source, and every tracked non-vendored
`.sln` and `.csproj` declares only the configured build pair.

### 6. Test-BclReferences — the shipped bcl.yml over the real type sources

**Test file:** `pwsh/Base.QualityGates/tests/Test-BclReferences.Tests.ps1` (L1), block
`Test-BclReferences — the shipped bcl.yml over the real type sources`.

**Guards:** Every type source that uses `System.Management.Automation` has its `bcl.yml` row, and every row is live.

### 7. CodeMetaHead and the types hash agree on every C# type

**Test file:** `pwsh/Base.CodeMeta/tests/types/CodeMetaHead.Tests.ps1` (L2), block
`CodeMetaHead and the types hash agree on every C# type`.

**Guards:** the bootstrap strip that hashes the types and `CodeMetaHead` read a C# head the same way (ADR-REPO-CODEMETA-CODEFILEHEAD).

**Checks:**

- For every tracked `pwsh/*/types/*.cs`, `CodeMetaHead.Parse` under the bcl form `file-carriers.yml` declares gives the same body as
  `Get-TypeSourceBody`.

**Prerequisite:** git.
