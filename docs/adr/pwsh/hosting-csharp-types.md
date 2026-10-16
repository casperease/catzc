---
catzc:
  derived:
    path: docs/adr/pwsh/hosting-csharp-types.md
    kind: adr
    language: markdown
    filekind: md
    track: docs
    body_sha: "6fcb534e32be"
    defines:
      - ADR-PWSH-TYPES#{1-7}
    adrs:
      - ADR-AUTO-TYPES#{2-4,7,9,14,15}
      - ADR-FLOW-CD-DETECT#1
    links:
      - docs/adr/automation/BCL/native-csharp-types.md
      - docs/adr/automation/spell-out-names.md
      - docs/adr/flow/pipeline-detection.md#rule-adr-flow-cd-detect1
---

# ADR: Hosting C# types in pwsh — the compiler, the reference set, accelerators, and stale types

## Rules: ADR-PWSH-TYPES

### Rule ADR-PWSH-TYPES:1

Host-guaranteed assemblies only — types reference the BCL plus `System.Management.Automation`, and nothing else. Both are in `Add-Type`'s
default reference set, and both are loaded in every process that can load the compiled assembly, so a `using` namespace is the whole
binding. No external packages, no NuGet.

- [The reference set](#the-reference-set)

### Rule ADR-PWSH-TYPES:2

A type publishes a PowerShell type-accelerator by carrying `[Catzc.Base.Objects.PSTypeAlias("Name")]`; `Import-CSharpTypes` registers each
after loading the assembly, so `[Name]` resolves to that type (`[Catzc.Module.Depm]::Puml`). Names carry a `Catzc.` prefix — a registration
reclaims only our own accelerator — and the alias literal is authored in the source of the type it decorates, so a search for it lands on
the type. This is registration, not compilation: `Add-Type` stays the sole compiler, and the decoration's cross-module edge is governed by
the dependency graph (ADR-AUTO-TYPES#4) like any other.

- [Type-accelerator aliases](#type-accelerator-aliases)

### Rule ADR-PWSH-TYPES:3

`Add-Type` is the one runtime compiler of the combined assembly (ADR-AUTO-TYPES#3): `Import-CSharpTypes` compiles the sources **as
authored** with `Add-Type -Path`, one compilation unit per file, because a file-scoped namespace is illegal once several files are
concatenated into one unit, and it writes a missing committed build with `-OutputAssembly`, which compiles without loading. pwsh resolves
`[Namespace.Type]` by its fully-qualified name, so the random assembly name `Add-Type` assigns is never consulted. No `dotnet` or `csc` step
runs at import.

- [The compiler](#the-compiler)

### Rule ADR-PWSH-TYPES:4

A type that needs a PowerShell primitive — `WildcardPattern`, `TypeAccelerators`, `PSObject` — takes it from `System.Management.Automation`
through a `using` namespace (ADR-PWSH-TYPES#1), never through a copy of its own. The IDE project references `System.Management.Automation`
**compile-time-only**, never copied to output, so the editor analyzes the same reference set `Add-Type` compiles against (ADR-AUTO-TYPES#2).

- [The reference set](#the-reference-set)

### Rule ADR-PWSH-TYPES:5

A loaded assembly cannot be unloaded from the pwsh process (ADR-AUTO-TYPES#7), so the only remedy for stale types is a new pwsh process. The
loader's devbox warning names that remedy (yellow, the changed types by simple name, "restart PowerShell") and the import goes on, its
pipeline check calls `Test-IsRunningInPipeline` like every other caller, and the importer never starts a nested shell itself
(ADR-AUTO-TYPES#15).

- [Stale types in a pwsh process](#stale-types-in-a-pwsh-process)

### Rule ADR-PWSH-TYPES:6

In pwsh, the loose shapes the internal model is never written as are `[pscustomobject]` and `[ordered]@{}` (ADR-AUTO-TYPES#9): a model
concept is a `[Catzc.…]` type that a function takes as a typed parameter and declares as its `[OutputType()]`, while a parsed `.yml`, an
`az` JSON result, or a splat stays a dictionary or `[pscustomobject]` up to the boundary that validates it.

- [Model types in pwsh](#model-types-in-pwsh)

### Rule ADR-PWSH-TYPES:7

The console-ready text of a type (ADR-AUTO-TYPES#14) is its C# `ToString()` override, because pwsh's string interpolation (`"$x"`) and
`[string]` cast call the .NET `ToString()` and ignore a `ToString` registered through the extended type system. `Import-CSharpTypes`
registers each `[Catzc.Base.Objects.ConsoleDisplay(...)]` property list as the type's `DefaultDisplayPropertySet`, which the formatter
honours, so typing `$x` at the prompt shows those properties.

- [ToString for pwsh callers](#tostring-for-pwsh-callers)

## Context

[native-csharp-types](../automation/BCL/native-csharp-types.md) (`ADR-AUTO-TYPES`) decides what the C# types are: one type per file, a
namespace per module, one combined assembly committed under a hash name, a fixed internal model, console-ready text. Every one of those
types runs inside a pwsh process, which compiles the assembly, loads it, and hands its objects to PowerShell code. This ADR is how that host
binds the types: which compiler, which references, which names pwsh callers type, and what a running pwsh can and cannot do with a changed
type.

### The compiler

`Add-Type is the compiler`

`Add-Type` is in every pwsh, needs no SDK, and compiles a source set into the running process in under a second, so the importer can compile
on a fresh edit with nothing installed beyond pwsh. Its limit is the assembly name: `Add-Type` assigns a **random** one (verified —
`Add-Type -OutputAssembly` produces e.g. `khuvslfy.cez`, and a rebuild of a source that is unchanged produces a _different_ random name),
and has no knob for a stable one. One assembly per module would bake a dependency's random name into each dependent and dangle on the next
rebuild, which is why the types compile into one combined assembly (ADR-AUTO-TYPES#3). That assembly is a leaf of the reference graph, and
pwsh resolves `[Namespace.Type]` by fully-qualified name, so its random name is harmless: no `dotnet`/`csc` build step, no topological
compile order, no transitive references.

The editor's `dotnet build` of the IDE project is a second compile of the same sources, for analysis and navigation only; the runtime never
builds the project.

### The reference set

`The reference set: host-guaranteed assemblies`

A type may reference exactly what the host guarantees is present: the BCL and `System.Management.Automation` (SMA). The types compile and
run exclusively inside a `pwsh` session's CLR — `Add-Type` is the only compiler, and its default reference set includes SMA alongside the
shared framework. The compiled assembly is likewise only ever loaded by a `pwsh` process, where SMA is loaded by definition, so an SMA
reference resolves in every process that can load the assembly at all. Using a PowerShell primitive from C# — `WildcardPattern`,
`TypeAccelerators`, `PSObject` — therefore costs a `using` namespace and nothing more: no package, no assembly hint, no build step. That is
what "host-guaranteed" means: the reference is satisfied by the same host that makes the type reachable in the first place.

The boundary is packages, not the SMA line: `Add-Type` has no mechanism to add references beyond its default set, and there is no NuGet in
this toolset. A type that wants `Microsoft.Extensions.*` or any other external package is asking for a dependency the host does not
guarantee — that logic belongs in PowerShell calling a vendored tool, not in `types/`. The IDE mirror carries the SMA reference
**compile-time-only** (never copied to output), so the editor analyzes the same reference set the runtime compiles against and the project
build cannot change what `Add-Type` sees.

### Type-accelerator aliases

`Type-accelerator aliases, and backtracking to source`

A type exposes a short alias for its fully-qualified name by carrying one or more `[Catzc.Base.Objects.PSTypeAlias("Catzc.Module.Depm")]`
attributes (ADR-PWSH-TYPES#2). After loading the combined assembly, `Import-CSharpTypes` reflects for the attribute and registers each name
with `System.Management.Automation.TypeAccelerators` — the table behind `[regex]` and `[ordered]` — so `[Catzc.Module.Depm]::Puml` resolves
to `Catzc.Base.ModuleSystem.ModuleDependencyFormat`. Registration is idempotent (remove-then-add), so a re-import never throws on a
duplicate key, and the `Catzc.` prefix keeps it from reclaiming another module's accelerator.

The terseness carries a backtracking cost the design pays deliberately. A type accelerator is a runtime string-to-`Type` mapping with no
source symbol, so F12 / Go-to-Definition does not jump from `[Catzc.Module.Depm]` to the `.cs` — the same holds for the full
`[Catzc.Base.ModuleSystem.ModuleDependencyFormat]`, because the editor has no source for a compiled .NET type. Two source-anchored paths
restore the trail, and the design leans on both:

- **The alias literal is authored in the C# source.** The name lives in `[PSTypeAlias("Catzc.Module.Depm")]` on the type, so a workspace
  search for `Catzc.Module.Depm` lands on the one declaring `types/*.cs`, and `[Catzc.Module.Depm].FullName` recovers the real type at
  runtime.
- **The IDE project makes the C# navigable.** With `Catzc.Types.csproj` built, every `types/*.cs` is a first-class Dev Kit symbol, so
  Go-to-Symbol on `ModuleDependencyFormat` jumps to source.

A short accelerator trades some of the [spell-out ADR](../automation/spell-out-names.md)'s self-describing-name value for terseness at the
call site; the `Catzc.`-namespaced, source-authored literal is what keeps it discoverable rather than opaque.

### Stale types in a pwsh process

`A changed type needs a new pwsh`

.NET cannot unload an assembly from a running process, and pwsh has no second load context for the types: a second assembly with the same
type names would split their identity, so a `[Catzc.…]` literal would resolve to one copy while an object holds the other. The process that
loaded the old types keeps them until it ends. The loader says so in the words a person acts on — restart PowerShell — and decides
warn-or-throw in the types pre-pass, before any module loads. It asks `Test-IsRunningInPipeline` there like every other caller, so the
detection function is one the importer has loaded before the pre-pass runs, and the pipeline-detection variables are read in one place
([ADR-FLOW-CD-DETECT#1](../flow/pipeline-detection.md#rule-adr-flow-cd-detect1)).

A person who edits a type and imports again keeps the loaded types and sees one yellow line naming the changed types; the import goes on and
never waits on a nested shell.

### Model types in pwsh

`The loose shapes are pwsh's own`

pwsh makes a loose shape cheap to write — an `[ordered]@{}` literal or a `[pscustomobject]` cast — which is exactly why the model rule needs
saying in pwsh terms. A concept the platform's own logic selects on, branches on, or pins at a call site is a `[Catzc.…]` type: the
parameter that takes it is typed, and the function that returns it says so in `[OutputType()]`, so a caller and the analyzer both see the
shape. Boundary data stays loose until the boundary that validates it: a shipped config crosses in through its config type, and an `az` JSON
result or a splat is fine as a dictionary or `[pscustomobject]`.

### ToString for pwsh callers

`Why the console text has to be C#`

A class that keeps `object.ToString()` renders in pwsh as its fully-qualified name: `Write-Message "Switched to $context"` prints
`Switched to Catzc.Azure.Cli.SubscriptionContext`, and a collection property shows `{Catzc.Base.Globs.GlobPattern, …}` in a table. The fix
has to be in C#: PowerShell's interpolation and `[string]` cast call the type's own .NET `ToString()` and ignore a `ToString` registered
through the extended type system, which only `-join`, an explicit `.ToString()`, and the formatter honour.

The default display is the other half, and it is registration: the formatter does honour extended-type-system data, so `Import-CSharpTypes`
turns each `[ConsoleDisplay("Id", "Name")]` into the type's `DefaultDisplayPropertySet`, like the type-accelerator aliases.

## Decision

pwsh hosts the C# types through `Add-Type` alone, against the BCL and `System.Management.Automation`, and registers each type's accelerator
aliases and default display after the load. A changed type in a running pwsh is answered with a message that names the restart (a throw in a
pipeline), never with a nested shell. The console text is C#, because that is the one pwsh's string conversion reads.

### How this is enforced

- **`Import-CSharpTypes`** (`automation/.internal/Catzc.Internal.Bootstrap.psm1`) compiles with `Add-Type -Path`, one compilation unit per
  file, registers each `[Catzc.Base.Objects.PSTypeAlias]` name as a type-accelerator (ADR-PWSH-TYPES#2), and registers each
  `[Catzc.Base.Objects.ConsoleDisplay]` property list as the type's default display (ADR-PWSH-TYPES#7). `Import-CSharpTypes.Tests.ps1`
  asserts a decorated type's accelerator resolves after load.
- **`Catzc.Types.csproj`** carries the `System.Management.Automation` reference compile-time-only (ADR-PWSH-TYPES#4); a reference beyond the
  default set fails the runtime compile, because `Add-Type` cannot see it (ADR-PWSH-TYPES#1).
- **`Test-ShippedTypes`** fails a concrete shipped class that keeps the inherited `ToString()` (ADR-PWSH-TYPES#7).

## Consequences

- A fresh checkout needs nothing beyond pwsh to compile the types, and a C# type can use any PowerShell primitive for the cost of a `using`.
- pwsh callers write `[Catzc.Module.Depm]` instead of the full name, and a search for the alias still lands on its source.
- A type edit costs a devbox session a yellow line that names the changed types, and a pipeline a throw that names the restart.
- No external package can be used from `types/`; logic that needs one lives in PowerShell over a vendored tool.
