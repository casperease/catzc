# Catzc.Base.TypesSystem

The native C# type system's support layer: it keeps the single committed combined type assembly under `automation/.compiled/` clean,
computes the cross-module C# type-reference edges that [Catzc.Base.ModuleSystem](catzc-base-modulesystem.md) folds into its dependency
integrity check, and owns the on-disk module enumeration the whole platform reads its module-name list from. It deliberately does **not**
own the _runtime_ type compilation or loading — that is the importer's `Import-CSharpTypes` (in
`automation/.internal/Catzc.Internal.Bootstrap.psm1`), and the authoring gates `Format-Types` / `Test-Types` live in
[Catzc.Base.QualityGates](catzc-base-qualitygates.md). The one build it does drive is the editor-facing MSBuild of those same sources
(`Invoke-BuildForVSCode`), which never feeds the runtime — it exists so VS Code's C# analysis matches the `Add-Type` compile. The full
type-system contract is [native-csharp-types](../../adr/automation/BCL/native-csharp-types.md).

## Domains

| Domain   | Area   | Name                                                                                     |
| -------- | ------ | ---------------------------------------------------------------------------------------- |
| domain:1 | cache  | [Compiled type-assembly cache](#domain1--compiled-type-assembly-cache)                   |
| domain:2 | graph  | [Cross-module type dependency analysis](#domain2--cross-module-type-dependency-analysis) |
| domain:3 | list   | [Automation-module enumeration](#domain3--automation-module-enumeration)                 |
| domain:4 | editor | [Editor type-project build](#domain4--editor-type-project-build)                         |

### domain:1 — Compiled type-assembly cache

Housekeeping for the single committed combined C# type assembly (`automation/.compiled/Catzc.Types.<hash>.dll`). `Clear-ModuleTypeCache` is
the post-import janitor: it keeps the one assembly whose name matches the current combined source hash and prunes every superseded build, so
the committed `.compiled` stays a clean −1/+1 diff when a type changes. Its delete pass is devbox-only (CI makes no source-control changes)
and best-effort about locked files, with an opt-in fail-fast for a stale build the running session still holds. But the one-committed-build
invariant is enforced everywhere: when a second `Catzc.Types.*.dll` coexists it always warns (yellow), and in a pipeline it throws — a
locked stale DLL committed instead of deleted must not reach trunk. Its combined-hash computation mirrors the loader's exactly, so it can
never plan the live build for deletion.

### domain:2 — Cross-module type dependency analysis

Recovering, for the dependency graph, the C# type edges the compiler no longer enforces. Because every module's `types/*.cs` compile into
one assembly (see [native-csharp-types](../../adr/automation/BCL/native-csharp-types.md)), a type in one module may reference a type in
another; `Get-CSharpTypeDependency` scans each module's sources and reports a `From → To` edge for every cross-module fully-qualified
reference, stripping comments, string literals, and each file's own namespace so only real references count.
[Catzc.Base.ModuleSystem](catzc-base-modulesystem.md) folds these edges into its integrity assertion, so the one declared graph in
`dependencies.yml` governs C# type layering as well as PowerShell calls.

### domain:3 — Automation-module enumeration

The platform's single source of the automation-module name list. `Get-AutomationModules` enumerates the non-dot directories under
`automation/` — the same set `Import-AllModules` loads — sorted ordinally. The C# type scan of domain 2 maps its references against this
list; [Catzc.Base.ModuleSystem](catzc-base-modulesystem.md) validates the declared dependency graph against it and drives
`Test-Automation`'s `-Modules` completer and validator from it. It lives here, below `Catzc.Base.ModuleSystem`, so the module-dependency
checks that consume it depend on this module rather than the reverse — which is what keeps the graph acyclic once the C# type edges are
folded in.

### domain:4 — Editor type-project build

The editor-facing build of the native type sources, kept separate from the runtime's `Add-Type` compile. `Invoke-BuildForVSCode` drives
`dotnet build` over the committed IDE-only `Catzc.Types.csproj` (under `automation/.internal/assets/`, auto-loaded in the editor via the
root `catzc.sln`), so VS Code's C# Dev Kit sees the `types/*.cs` exactly as the runtime does — Go-to-Symbol and F12 resolve to source, the
backtrack a bare type accelerator cannot give. The same build runs the Roslyn analyzers `Add-Type` never does and the project's stamp task,
which fails when the committed `.compiled` assembly is stale versus the sources, so a green build doubles as a check that the IDE project
matches the runtime prebuild. It runs `dotnet` through `Invoke-Executable` rather than the Tooling layer's `Invoke-Dotnet`, which this
`Base` module must not depend on.

## What the module does

The module is the part of the native-type system that runs _outside_ the importer. Type compilation and loading happen once, eagerly, in the
bootstrap pre-pass; what remains are the concerns this module owns. Domain 1 keeps the committed artifact tidy after every devbox import, so
a type edit produces a clean single-file swap in `.compiled/` rather than an accumulating pile of stale assemblies. Domain 2 reconstructs
the cross-module type references that a single combined assembly makes invisible to the compiler, handing them to `Catzc.Base.ModuleSystem`
so the same layering contract polices both worlds. Domain 3 is the on-disk module enumeration both of those build on — and the platform's
one module-name source besides.

The module sits in the `Base` group. It depends only on the group's lower layers — `Catzc.Base.Repository` (repository root, pipeline
detection), `Catzc.Base.Files` (file-lock detection), `Catzc.Base.Execution` (running `dotnet` for the editor build), `Catzc.Base.Writers`
(console output), and `Catzc.Base.Asserts` — and is depended on by `Catzc.Base.ModuleSystem` and `Catzc.Base.QualityGates`, which call
`Get-CSharpTypeDependency` and `Get-AutomationModules` from their integrity checks and completers. Placing the module enumeration and the C#
edge scan here, below `Catzc.Base.ModuleSystem`, is what lets the module-dependency graph fold in the type edges without the two modules
forming a cycle.

## Division

The module's public functions, sorted into the domains above.

| Domain                                           | Function                   |
| ------------------------------------------------ | -------------------------- |
| domain:1 — Compiled type-assembly cache          | `Clear-ModuleTypeCache`    |
| domain:2 — Cross-module type dependency analysis | `Get-CSharpTypeDependency` |
| domain:3 — Automation-module enumeration         | `Get-AutomationModules`    |
| domain:4 — Editor type-project build             | `Invoke-BuildForVSCode`    |
