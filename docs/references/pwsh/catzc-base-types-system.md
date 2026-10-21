# Catzc.Base.TypesSystem

The native C# type system's support layer: it keeps the single committed combined type assembly under `pwsh/.compiled/` clean, computes the
cross-module C# type-reference edges that [Catzc.Base.ModuleSystem](catzc-base-module-system.md) folds into its dependency integrity check.
It deliberately does **not** own the _runtime_ type compilation or loading — that is the importer's `Import-CSharpTypes` (in
`pwsh/.internal/Catzc.Internal.Bootstrap.psm1`), and the namespace formatter `Format-Types` and the `Test-Formatting` gate that checks it
live in [Catzc.Base.QualityGates](catzc-base-quality-gates.md). The one build it does drive is the editor-facing MSBuild of those same
sources (`Invoke-BuildForVsCode`), which never feeds the runtime — it exists so VS Code's C# analysis matches the `Add-Type` compile. The
full type-system contract is [native-csharp-types](../../drs/automation/BCL/native-csharp-types.md).

## Responsibilities

| Responsibility   | Area   | Name                                                                                             |
| ---------------- | ------ | ------------------------------------------------------------------------------------------------ |
| responsibility:1 | cache  | [Compiled type-assembly cache](#responsibility1--compiled-type-assembly-cache)                   |
| responsibility:2 | graph  | [Cross-module type dependency analysis](#responsibility2--cross-module-type-dependency-analysis) |
| responsibility:3 | editor | [Editor type-project build](#responsibility3--editor-type-project-build)                         |
| responsibility:4 | gate   | [Shipped-type coverage](#responsibility4--shipped-type-coverage)                                 |
| responsibility:5 | hook   | [Agent hook build](#responsibility5--agent-hook-build)                                           |

### responsibility:1 — Compiled type-assembly cache

Housekeeping for the single committed combined C# type assembly (`pwsh/.compiled/Catzc.Types.<hash>.dll`). `Clear-ModuleTypeCache` is the
post-import janitor: it keeps the one assembly whose name matches the current combined source hash and prunes every superseded build, so the
committed `.compiled` stays a clean −1/+1 diff when a type changes. Its delete pass is devbox-only (CI makes no source-control changes) and
best-effort about locked files, with an opt-in fail-fast for a stale build the running session still holds. But the one-committed-build
invariant is enforced everywhere: when a second `Catzc.Types.*.dll` coexists it always warns (yellow), and in a pipeline it throws — a
locked stale DLL committed instead of deleted must not reach trunk. Its combined-hash computation mirrors the loader's exactly, so it can
never plan the live build for deletion.

The other half of the cache is the copy in the running process, which cannot be swapped once loaded. A test/assert pair asks whether the
types this process loaded are still those its sources declare, from the one measurement the loader and the importer use
([ADR-BCL-TYPES-ONEDRIFTMEASURE](../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-onedriftmeasure)); the assert names
every drifted type and the one remedy, a new PowerShell.

### responsibility:2 — Cross-module type dependency analysis

Recovering, for the dependency graph, the C# type edges the compiler no longer enforces. Because every module's `types/*.cs` compile into
one assembly (see [native-csharp-types](../../drs/automation/BCL/native-csharp-types.md)), a type in one module may reference a type in
another; `Get-CSharpTypeDependency` scans each module's sources and reports a `From → To` edge for every cross-module fully-qualified
reference, stripping comments, string literals, and each file's own namespace so only real references count.
[Catzc.Base.ModuleSystem](catzc-base-module-system.md) folds these edges into its integrity assertion, so the one declared graph in
`dependencies.yml` governs C# type layering as well as PowerShell calls.

### responsibility:3 — Editor type-project build

The editor-facing build of the native type sources, kept separate from the runtime's `Add-Type` compile. `Invoke-BuildForVsCode` drives
`dotnet build` over the committed IDE-only `Catzc.Types.csproj` (under `pwsh/.internal/assets/`, auto-loaded in the editor via the root
`catzc.sln`), so VS Code's C# Dev Kit sees the `types/*.cs` exactly as the runtime does — Go-to-Symbol and F12 resolve to source, the
backtrack a bare type accelerator cannot give. The same build runs the Roslyn analyzers `Add-Type` never does and the project's stamp task,
which fails when the committed `.compiled` assembly is stale versus the sources, so a green build doubles as a check that the IDE project
matches the runtime prebuild. It runs `dotnet` through `Invoke-Executable` rather than the Tooling layer's `Invoke-Dotnet`, which this
`Base` module must not depend on.

### responsibility:4 — Shipped-type coverage

Proving every shipped type is present in the session: each `<module>/types/<Name>.cs` under the loaded code root declares `<module>.<Name>`,
so after import that full name must resolve. The quality gate lists every type that does not, in either run mode; how the files are written
(their file-scoped namespace) is the concern of `Test-Formatting`.

### responsibility:5 — Agent hook build

Publishing the C# programs the platform runs outside PowerShell: the Claude Code hooks under `.claude/hooks/`, one folder each. One holds
every agent Bash call to the time safeguard ([fail-fast-with-asserts](../../drs/automation/fail-fast-with-asserts.md),
`ADR-AUTO-FAILFAST-BOUNDEVERYWAIT`); another records what each agent session writes, so the listen mode tells it from the editor's changes
([ai-agent-contract](../../drs/repository/ai-agent-contract.md)). They run around every such call, so they are compiled rather than
scripted. The importer asks for them on every import; each publishes with `dotnet` only when its sources' hash differs from the one recorded
beside its published program, is found by its project's own assembly name, and is asserted to exist after the publish.

## What the module does

The module is the part of the native-type system that runs _outside_ the importer. Type compilation and loading happen once, eagerly, in the
bootstrap pre-pass; what remains are the concerns this module owns. Responsibility 1 keeps the committed artifact tidy after every devbox
import, so a type edit produces a clean single-file swap in `.compiled/` rather than an accumulating pile of stale assemblies.
Responsibility 2 reconstructs the cross-module type references that a single combined assembly makes invisible to the compiler, handing them
to `Catzc.Base.ModuleSystem` so the same layering contract polices both worlds. The module names the scan maps its references against come
from the module resolver (`Get-CatzcModule`, `Catzc.Base.Modules`).

The module sits in the `Base` group. It depends only on the layers below it in the group — `Catzc.Base.Repository` (repository root,
pipeline detection), `Catzc.Base.Files` (file-lock detection), `Catzc.Base.Execution` (running `dotnet` for the editor build),
`Catzc.Base.Writers` (console output), and `Catzc.Base.Asserts` — and is depended on by `Catzc.Base.ModuleSystem` and
`Catzc.Base.QualityGates`, which call `Get-CSharpTypeDependency` from their integrity checks. Placing the C# edge scan here, below
`Catzc.Base.ModuleSystem`, is what lets the module-dependency graph fold in the type edges without the two modules forming a cycle.

## Division

The module's public functions, sorted into the responsibilities above.

| Responsibility                                           | Function                    |
| -------------------------------------------------------- | --------------------------- |
| responsibility:1 — Compiled type-assembly cache          | `Clear-ModuleTypeCache`     |
|                                                          | `Assert-LoadedTypesCurrent` |
|                                                          | `Test-LoadedTypesCurrent`   |
| responsibility:2 — Cross-module type dependency analysis | `Get-CSharpTypeDependency`  |
| responsibility:3 — Editor type-project build             | `Invoke-BuildForVsCode`     |
| responsibility:4 — Shipped-type coverage                 | `Test-ShippedTypes`         |
| responsibility:5 — Agent hook build                      | `Build-AgentHook`           |
