# PowerShell: Hosting C# types — the compiler, the reference set, accelerators, and stale types

## Rules: ADR-PWSH-TYPES

### Rule ADR-PWSH-TYPES-HOSTGUARANTEEDASSEMBLIES

Host-guaranteed assemblies only — a type references the BCL language's reference set, the BCL (ADR-BCL-TYPES-REFERENCESET), plus
`System.Management.Automation` for a type that is a configured host binding, one with its row in `bcl.yml`, and nothing else. Both are in
`Add-Type`'s default reference set, and both are loaded in every process that can load the compiled assembly, so a `using` namespace is the
whole binding. No external packages, no NuGet.

- [The reference set](#the-reference-set)

### Rule ADR-PWSH-TYPES-TYPEACCELERATORATTRIBUTE

A type publishes a PowerShell type-accelerator by carrying `[Catzc.Base.Objects.PSTypeAlias("Name")]`; `Import-CSharpTypes` registers each
after loading the assembly, so `[Name]` resolves to that type (`[Catzc.Module.Depm]::Puml`). Names carry a `Catzc.` prefix — a registration
reclaims only a catzc accelerator — and the alias literal is authored in the source of the type it decorates, so a search for it lands on
the type. This is registration, not compilation: `Add-Type` stays the sole compiler, and the decoration's cross-module edge is governed by
the dependency graph (ADR-BCL-TYPES-REFERENCESFOLLOWDEPS) like any other.

- [Type-accelerator aliases](#type-accelerator-aliases)

### Rule ADR-PWSH-TYPES-ACCELERATORSNOTFULLNAMES

Code names a catzc type by its `Catzc.*` accelerator, not by its full type name, wherever builds can stack. Two builds of the same sources
load side by side with the same full type names, and a full name keeps resolving to the first-loaded build, silently; a re-pointed
accelerator resolves to the newest build. An object of the old build does not convert to the new build's type, so code that mixes the two
fails far from the cause.

- [Type-accelerator aliases](#type-accelerator-aliases)
- [Stale types in a pwsh process](#stale-types-in-a-pwsh-process)

### Rule ADR-PWSH-TYPES-ADDTYPECOMPILES

`Add-Type` is the one runtime compiler of the combined assembly (ADR-BCL-TYPES-ONEASSEMBLY): `Import-CSharpTypes` compiles the sources **as
authored** with `Add-Type -Path`, one compilation unit per file, because a file-scoped namespace is illegal once several files are
concatenated into one unit, and it writes a missing committed build with `-OutputAssembly`, which compiles without loading. pwsh resolves
`[Namespace.Type]` by its fully-qualified name, so the random assembly name `Add-Type` assigns is never consulted. No `dotnet` or `csc` step
runs at import.

- [The compiler](#the-compiler)

### Rule ADR-PWSH-TYPES-POWERSHELLPRIMITIVES

A type that needs a PowerShell primitive — `WildcardPattern`, `TypeAccelerators`, `PSObject` — is a host binding: it has its row in
`bcl.yml` and takes the primitive from `System.Management.Automation` through a `using` namespace (ADR-PWSH-TYPES-HOSTGUARANTEEDASSEMBLIES),
never through a copy of its own. A value that only crosses from pwsh, such as a `PSObject` to unwrap, is unwrapped by its pwsh caller, so
the type stays in the BCL language. The IDE project references `System.Management.Automation` **compile-time-only**, never copied to output,
so the editor analyzes the same reference set `Add-Type` compiles against (ADR-BCL-TYPES-NAMESPACEISMODULE).

- [The reference set](#the-reference-set)

### Rule ADR-PWSH-TYPES-RESTARTTORELOAD

A loaded assembly cannot be unloaded from the pwsh process, so the only remedy for stale types is a new pwsh process, and the loader answers
a changed type by where it runs. In a **pipeline** it throws "restart PowerShell": CI never runs on stale types. On a **devbox** a changed
or removed type warns in yellow, naming the changed types by simple name and the remedy, keeps the loaded types and goes on, so a person
editing a type mid-session is never blocked; it returns without recording the new hash, so the warning repeats on every re-import until the
restart. A type the loaded assembly lacks (added since load, or not loaded on behalf of another root) throws on a devbox too, since the old
types cannot serve code that uses it and continuing would only move the failure to a cast error far from the cause. The loader tells a
pipeline from a devbox by calling `Test-IsRunningInPipeline` like every other caller, and that check comes first. After it, and ahead of the
devbox paths, a developer's console session in the source tree loads the changed build beside the old one, up to the `generations` cap that
`types-load.yml` declares for that cell, and re-points the `Catzc.*` accelerators to it (ADR-PWSH-TYPES-ACCELERATORSNOTFULLNAMES); past the
cap, the paths above hold. Inside VS Code the instance rule decides (ADR-PWSH-TYPES-ONEINSTANCEPERSESSION). The importer never starts a
nested shell and never waits.

- [Stale types in a pwsh process](#stale-types-in-a-pwsh-process)

### Rule ADR-PWSH-TYPES-ONEDRIFTMEASURE

Whether the C# types loaded in a pwsh process are current is measured in one place, `Get-LoadedTypeDrift` (`Catzc.Internal.Types`), and
asked through one test/assert pair, `Test-LoadedTypesCurrent` and `Assert-LoadedTypesCurrent` (`Catzc.Base.TypesSystem`). The loader reads
the same measure for its warn-or-throw (ADR-PWSH-TYPES-RESTARTTORELOAD), so every caller agrees on whether the types are stale.

- [Stale types in a pwsh process](#stale-types-in-a-pwsh-process)

### Rule ADR-PWSH-TYPES-STALETYPESGUARD

The stale-types guard — the source changed since it was loaded, so restart — is keyed by `ModulesRoot`. `Import-CSharpTypes` takes the tree
as a parameter, and one session may load more than one tree (the real code root plus the test-fixture trees), so the per-session record of
loaded hash and file snapshot is stored per resolved root. A load from one root therefore never makes a re-import of another root falsely
report a change, so a test run that loads fixture trees leaves the next real import's guard intact. The thrown message names the drifted
files and both hashes, so the cause is diagnosable from the error text alone.

- [Stale types in a pwsh process](#stale-types-in-a-pwsh-process)

### Rule ADR-PWSH-TYPES-CONSOLEVERIFIESONLY

In a console session the importer verifies the types assembly and loads nothing: `Import-CSharpTypes` registers the assembly as deferred,
and the first lookup of a catzc command loads it (`Enable-DeferredTypesLoad`, `Initialize-Types`), so an import that runs no command pays no
load. A headless session loads at import, so a pipeline or a test worker fails on stale or missing types where it starts
(ADR-PWSH-TYPES-ONEDRIFTMEASURE). Which cell loads how is the `types-load.yml` table, host by operating system by run mode, with its default
row declared once in the `TypesLoadDefault` variable of `Catzc.Internal.Types`: the policy is read while the types assembly is unloaded, so
it cannot sit on a config type, the one exception to
[ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../sensible-defaults.md#rule-adr-auto-default-oneresolutionorder). The combined hash of the sources is
memoised per machine beside the shadow copies, by each file's length and last write (`Get-CombinedTypeHash -StampPath`); only the importer
reads the memo, and the builder, the janitor and the gates hash every byte.

- [Loaded by the first use](#loaded-by-the-first-use)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-PWSH-TYPES-ONEINSTANCEPERSESSION

A pwsh session is bound to **one types instance**: the `Catzc.Types.<hash>.dll` it loaded first is the one it runs on until it exits, and
nothing in the toolset fights that. No janitor stops a process that holds a superseded build, waits for it, or throws over it
(ADR-PWSH-TYPES-JANITORSBYCALLER); no file outside the loader claims to know which build is current from a copy of the hash algorithm, since
`Get-CombinedTypeHash` is the one measure (ADR-PWSH-TYPES-ONEDRIFTMEASURE); and inside VS Code no drift throws, for the extension host and
the integrated terminal alike: a throw cannot restart either, and an import that dies there leaves the editor's session without cats, so the
loader keeps the loaded assembly whatever drifted and writes one yellow line, "loaded inside VS Code with non-current types dll", naming the
loaded hash and the source hash. It asks `Test-IsRunningInVsCode`, the loader's one reader of VS Code's terminal mark, after the pipeline
check, so a pipeline is never softened by the mark. What a session may ask about its own binding is a toolset command that runs from inside
it, `Get-VsCodeSession`, guarded by `Assert-IsRunningInVsCode`, which names the instance, the sources' hash, the committed builds and their
holders, and the editor's own logs. No alarm of the editor is silenced to hide a symptom: the terminal's environment-change indicator stays
on. A hung session is described first by `Get-VsCodeSession` run in a sibling terminal of the same window, and a stack capture comes only
after that line shows what it lacks.

- [One instance per session](#one-instance-per-session)

### Rule ADR-PWSH-TYPES-JANITORSBYCALLER

Who runs the importer decides what its janitors may change outside the session, read from one place: `Get-SessionActor` → `Person`, `Agent`,
or `Pipeline` (a pipeline wins over an agent running in it). No switch overrides it.

- **Delete a superseded build another process still holds**: a person, no (named in one line, gone when its holder exits); an agent, no
  (named in one line); a pipeline, no (it asserts exactly one build).
- **Commit the regenerated types contracts** (`contracts/catzc/0.1.0/<group>/types.json`): a person, yes; an agent, no (it announces what
  changed, to be committed); a pipeline, no (it checks the committed contract against the build).
- **Regenerate the gitignored generated files**: a person, an agent and a pipeline, yes.

The repository is the person's: their session commits to it. An agent leaves it to the person and says what it left; a pipeline only
asserts. No session of any actor stops another process (ADR-PWSH-TYPES-ONEINSTANCEPERSESSION). A test-run snapshot
(`Test-RepositorySnapshot`) is never committed to, whoever runs it.

- [One instance per session](#one-instance-per-session)

### Rule ADR-PWSH-TYPES-NOLOOSESHAPES

In pwsh, the loose shapes the internal model is never written as are `[pscustomobject]` and `[ordered]@{}` (ADR-BCL-TYPES-NATIVETYPEDMODEL):
a model concept is a `[Catzc.…]` type that a function takes as a typed parameter and declares as its `[OutputType()]`, while a parsed
`.yml`, an `az` JSON result, or a splat stays a dictionary or `[pscustomobject]` up to the boundary that validates it.

- [Model types in pwsh](#model-types-in-pwsh)

### Rule ADR-PWSH-TYPES-TOSTRINGOVERRIDE

The console-ready text of a type (ADR-BCL-TYPES-CONSOLEREADYTOSTRING) is its C# `ToString()` override, because pwsh's string interpolation
(`"$x"`) and `[string]` cast call the .NET `ToString()` and ignore a `ToString` registered through the extended type system.
`Import-CSharpTypes` registers each `[Catzc.Base.Objects.ConsoleDisplay(...)]` property list as the type's `DefaultDisplayPropertySet`,
which the formatter honours, so typing `$x` at the prompt shows those properties.

- [ToString for pwsh callers](#tostring-for-pwsh-callers)

## Context

[native-csharp-types](../BCL/native-csharp-types.md) (`ADR-BCL-TYPES`) decides what the C# types are: one type per file, a namespace per
module, one combined assembly committed under a hash name, a fixed internal model, console-ready text. Every one of those types runs inside
a pwsh process, which compiles the assembly, loads it, and hands its objects to PowerShell code. This record is how that host binds the
types: which compiler, which references, which names pwsh callers type, and what a running pwsh can and cannot do with a changed type.

### The compiler

`Add-Type is the compiler`

`Add-Type` is in every pwsh, needs no SDK, and compiles a source set into the running process in under a second, so the importer can compile
on a fresh edit with nothing installed beyond pwsh. Its limit is the assembly name: `Add-Type` assigns a **random** one (verified —
`Add-Type -OutputAssembly` produces e.g. `khuvslfy.cez`, and a rebuild of a source that is unchanged produces a _different_ random name),
and has no knob for a stable one. One assembly per module would bake a dependency's random name into each dependent and dangle on the next
rebuild, which is why the types compile into one combined assembly (ADR-BCL-TYPES-ONEASSEMBLY). That assembly is a leaf of the reference
graph, and pwsh resolves `[Namespace.Type]` by fully-qualified name, so its random name is harmless: no `dotnet`/`csc` build step, no
topological compile order, no transitive references.

The editor's `dotnet build` of the IDE project is a second compile of the same sources, for analysis and navigation only; the runtime never
builds the project.

### The reference set

`The reference set: host-guaranteed assemblies`

A type may reference exactly what the host guarantees is present: the BCL, which is the BCL language's whole reference set, and
`System.Management.Automation` (SMA) for a configured host binding. The types compile and run only inside a `pwsh` session's CLR: `Add-Type`
is the only compiler, its default reference set includes SMA beside the shared framework, and only a `pwsh` process, where SMA is loaded by
definition, loads the compiled assembly. A PowerShell primitive used from C# — `WildcardPattern`, `TypeAccelerators`, `PSObject` — costs a
`using` namespace and nothing more: no package, no assembly hint, no build step. That is "host-guaranteed": the reference is satisfied by
the same host that makes the type reachable.

The boundary is packages, not the SMA line: `Add-Type` has no mechanism to add references beyond its default set, and there is no NuGet in
this toolset. A type that wants `Microsoft.Extensions.*` or any other external package is asking for a dependency the host does not
guarantee — that logic belongs in PowerShell calling a vendored tool, not in `types/`. The IDE mirror carries the SMA reference
**compile-time-only** (never copied to output), so the editor analyzes the same reference set the runtime compiles against and the project
build cannot change what `Add-Type` sees.

### Type-accelerator aliases

`Type-accelerator aliases, and backtracking to source`

A type exposes a short alias for its fully-qualified name by carrying one or more `[Catzc.Base.Objects.PSTypeAlias("Catzc.Module.Depm")]`
attributes (ADR-PWSH-TYPES-TYPEACCELERATORATTRIBUTE). After loading the combined assembly, `Import-CSharpTypes` reflects for the attribute
and registers each name with `System.Management.Automation.TypeAccelerators` — the table behind `[regex]` and `[ordered]` — so
`[Catzc.Module.Depm]::Puml` resolves to `Catzc.Base.ModuleSystem.ModuleDependencyFormat`. Registration is idempotent (remove-then-add), so a
re-import never throws on a duplicate key, and the `Catzc.` prefix keeps it from reclaiming another module's accelerator.

The terseness carries a backtracking cost the design pays deliberately. A type accelerator is a runtime string-to-`Type` mapping with no
source symbol, so F12 / Go-to-Definition does not jump from `[Catzc.Module.Depm]` to the `.cs` — the same holds for the full
`[Catzc.Base.ModuleSystem.ModuleDependencyFormat]`, because the editor has no source for a compiled .NET type. Two source-anchored paths
restore the trail, and the design leans on both:

- **The alias literal is authored in the C# source.** The name lives in `[PSTypeAlias("Catzc.Module.Depm")]` on the type, so a workspace
  search for `Catzc.Module.Depm` lands on the one declaring `types/*.cs`, and `[Catzc.Module.Depm].FullName` recovers the real type at
  runtime.
- **The IDE project makes the C# navigable.** With `Catzc.Types.csproj` built, every `types/*.cs` is a first-class Dev Kit symbol, so
  Go-to-Symbol on `ModuleDependencyFormat` jumps to source.

A short accelerator trades some of the [spell-out record](../spell-out-names.md)'s self-describing-name value for terseness at the call
site; the `Catzc.`-namespaced, source-authored literal is what keeps it discoverable rather than opaque.

### Stale types in a pwsh process

`A changed type needs a new pwsh`

.NET cannot unload an assembly from a running process, and pwsh has no second load context for the types: a second assembly with the same
type names would split their identity, so a `[Catzc.…]` literal would resolve to one copy while an object holds the other. The process that
loaded the old types keeps them until it ends. The loader says so in the words a person acts on — restart PowerShell — and decides
warn-or-throw in the types pre-pass, before any module loads. It asks `Test-IsRunningInPipeline` there like every other caller, so the
detection function is one the importer has loaded before the pre-pass runs, and the pipeline-detection variables are read in one place.

A person who edits a type and imports again keeps the loaded types and sees one yellow line naming the changed types; the import goes on and
never waits on a nested shell. The importer starts none: a process cannot replace itself on every platform, and an agent or a script would
block on a nested one. A pipeline must never run on stale types, so it throws. A VS Code terminal is the one devbox host where even a
missing type does not throw: the person cannot restart that host from the import, and the loader's line names the hash of the assembly the
session runs on, so the next terminal they open is the fix.

That limit is measured once, so every caller agrees on it. `Get-LoadedTypeDrift` compares the session record of what was loaded with the
sources on disk and names each drifted type; the loader reads it to warn or throw, and `Test-LoadedTypesCurrent` /
`Assert-LoadedTypesCurrent` give the same answer to any code that needs current types, such as a test of a type just edited. The record is
kept per code root, since a test run loads fixture trees beside the real one.

Where a developer's console stacks a changed build beside the old one, both builds carry the same full type names. A full name resolves to
the first-loaded build for the life of the process, while the `Catzc.*` accelerators are re-pointed to the newest, so code that names its
types by accelerator follows the rebuild and code that spells the full name silently stays behind.

### Loaded by the first use

`Verify at import, load at the first command`

An interactive session imports catzc to have its commands at hand, and most sessions then run a few of them or none. Loading the types
assembly costs a shadow copy and an `Add-Type` on every import, and the import already proves the assembly current by its metadata
(ADR-PWSH-TYPES-ONEDRIFTMEASURE), so the load is deferred to the moment a command needs a type: a name-filtered command-lookup hook,
installed once every command name is known, loads the assembly on the first lookup of one of them and removes itself. A literal type name
typed at the console before any command stays unresolved until then, which a console user sees and a script never does: a headless session
is eager, so a pipeline, a test worker or `cats` fails at import on a stale or missing assembly rather than later in a cast. The table that
says which cell is lazy and which eager is data, one row per host, operating system and run mode, flipped by editing a row and never by
code. The import-time janitors are catzc commands, so a console import would load the assembly through them before the prompt appeared; a
console session therefore runs them once the first prompt has shown, through a prompt hook the loader installs and removes after that one
run, and a headless session runs them at import.

The hash that names the assembly is the costliest step of a warm import: every `types/*.cs` read and hashed. A machine-local memo keyed by
each file's length and last write skips the read for a file that shows the same pair, and rewrites itself when any file was read; it lives
beside the shadow copies, never in the tree, since it holds this machine's write times. Only the importer trusts it: the builder that names
a release, the janitor that prunes the cache and the gates that compare the build hash every byte, so the memo can speed up a session but
never decide what ships.

### One instance per session

`The editor's sessions are long-lived; the sources are not`

A devbox with several sessions, the editor's extension host among them, rebuilds the types many times a day, and every session that was
alive before a rebuild holds an earlier instance. That is not a fault to repair from outside: a process stopped for holding a build loses
its unsaved work and its history, a janitor that waits for a release waits on a session that may be the person's own, and a copy of the hash
algorithm in an editor project or an extension drifts the first time the loader's measure changes, and then calls every build stale. Each
session therefore owns its binding. The loader names a non-current instance once, in yellow, and inside VS Code never throws for it, because
a throw cannot restart the extension host or the terminal that threw; the janitor names a held build once and leaves it; and the editor's
own artifacts, the IDE project and the compiled-info extension, ask the loader for the hash rather than carry one.

What a janitor may change outside its session follows who runs it, a person, an agent or a pipeline, read once from `Get-SessionActor`
(ADR-PWSH-TYPES-JANITORSBYCALLER): the repository is the person's, so only a person's session leaves a commit-ready change behind, and no
actor's session stops another process.

The question a session can answer is about itself. `Get-VsCodeSession` runs inside the session it describes, where `$Host`, the loaded
assembly, the environment the extensions contributed and the editor's log folder are all in reach, so a diagnosis is a command in the
toolset, not a probe run from another process against this one.

### Why a shadow copy loads from a path

`The copy is loaded by path, not by bytes`

The per-user shadow copy of [the BCL record](../BCL/native-csharp-types.md#why-a-shadow-copy) is loaded in pwsh by its path. A byte load
(`[Reflection.Assembly]::Load([byte[]])`) would avoid the file lock, but it leaves `Assembly.Location` empty, and anything that later
compiles against the types (`Add-Type -ReferencedAssemblies`) needs a real path. A path load of the copy keeps `Location` valid and still
leaves the built assembly unlocked. Inside the VS Code PowerShell host the same rule holds: the host is one more live session that loads the
copy, never the build.

### Model types in pwsh

`The loose shapes are pwsh's own`

pwsh makes a loose shape cheap to write — an `[ordered]@{}` literal or a `[pscustomobject]` cast — so the model rule is stated in pwsh
terms. A concept the platform's own logic selects on, branches on, or pins at a call site is a `[Catzc.…]` type: the parameter that takes it
is typed, and the function that returns it says so in `[OutputType()]`, so a caller and the analyzer both see the shape. Boundary data stays
loose until the boundary that validates it: a shipped config crosses in through its config type, and an `az` JSON result or a splat is fine
as a dictionary or `[pscustomobject]`.

### ToString for pwsh callers

`Why the console text has to be C#`

A class that keeps `object.ToString()` renders in pwsh as its fully-qualified name: `Write-Message "Switched to $context"` prints
`Switched to Catzc.Azure.Cli.SubscriptionContext`, and a collection property shows `{Catzc.Base.Objects.GlobPattern, …}` in a table. The
text lives in C#, since PowerShell's interpolation and `[string]` cast call the type's own .NET `ToString()` and ignore a `ToString`
registered through the extended type system, which only `-join`, an explicit `.ToString()`, and the formatter honour.

The default display is the other half, and it is registration: the formatter does honour extended-type-system data, so `Import-CSharpTypes`
turns each `[ConsoleDisplay("Id", "Name")]` into the type's `DefaultDisplayPropertySet`, like the type-accelerator aliases.

## Decision

pwsh hosts the C# types through `Add-Type` alone, against the BCL and `System.Management.Automation`, and registers each type's accelerator
aliases and default display after the load. A changed type in a running pwsh is answered with a message that names the restart (a throw in a
pipeline), never with a nested shell, a stopped process or a wait: each session keeps the one instance it loaded. The console text is C#,
because that is the one pwsh's string conversion reads.

### How this is enforced

- **`Import-CSharpTypes`** (`pwsh/.internal/Catzc.Internal.Bootstrap.psm1`) compiles with `Add-Type -Path`, one compilation unit per file,
  registers each `[Catzc.Base.Objects.PSTypeAlias]` name as a type-accelerator (ADR-PWSH-TYPES-TYPEACCELERATORATTRIBUTE), and registers each
  `[Catzc.Base.Objects.ConsoleDisplay]` property list as the type's default display (ADR-PWSH-TYPES-TOSTRINGOVERRIDE).
  `Import-CSharpTypes.Tests.ps1` asserts a decorated type's accelerator resolves after load.
- **`Catzc.Types.csproj`** carries the `System.Management.Automation` reference compile-time-only (ADR-PWSH-TYPES-POWERSHELLPRIMITIVES); a
  reference beyond the default set fails the runtime compile, because `Add-Type` cannot see it (ADR-PWSH-TYPES-HOSTGUARANTEEDASSEMBLIES).
- **`Invoke-BuildForVsCode`** (in `Catzc.Base.TypesSystem`) drives the editor-facing `dotnet build` of `Catzc.Types.csproj` through
  `Invoke-Executable`, so a dev or CI builds and verifies the IDE project on demand; a `Base` module reaching the Tooling layer's
  `Invoke-Dotnet` would invert the dependency graph, so it does not.
- **`Get-LoadedTypeDrift`** (in `Catzc.Internal.Types`) is the one measure of stale types; the loader and the `Test-LoadedTypesCurrent` /
  `Assert-LoadedTypesCurrent` pair read it (ADR-PWSH-TYPES-ONEDRIFTMEASURE).
- **`Import-CSharpTypes.Tests.ps1` and `Get-CombinedTypeHash.Tests.ps1`** (`pwsh/.internal/tests`) — the console cell verifies and defers,
  the first `Initialize-Types` loads, the eager cell loads at import, and the hash memo rehashes exactly the files whose length or last
  write changed (ADR-PWSH-TYPES-CONSOLEVERIFIESONLY).
- **`Test-ShippedTypes`** fails a concrete shipped class that keeps the inherited `ToString()` (ADR-PWSH-TYPES-TOSTRINGOVERRIDE).
- **`Clear-ModuleTypeCache`** names a held superseded build and leaves it; `Clear-ModuleTypeCache.Tests.ps1` holds a build open and asserts
  no throw, no stop and no wait. **`Get-VsCodeSession`** (`Catzc.Base.VSCode`) is the one diagnosis of a session's binding and refuses to
  run outside VS Code (ADR-PWSH-TYPES-ONEINSTANCEPERSESSION).

## Consequences

- A fresh checkout needs nothing beyond pwsh to compile the types, and a C# type can use any PowerShell primitive for the cost of a `using`.
- pwsh callers write `[Catzc.Module.Depm]` instead of the full name, and a search for the alias still lands on its source.
- A type edit costs a devbox session a yellow line that names the changed types, and a pipeline a throw that names the restart.
- A session that holds an earlier build is never stopped or waited for; the superseded build stays in the shadow root until that session
  exits, and the next run removes it.
- No external package can be used from `types/`; logic that needs one lives in PowerShell over a vendored tool.
