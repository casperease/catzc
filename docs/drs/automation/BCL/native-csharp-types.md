# BCL: Native C# types — one combined assembly, namespace per module

## Rules: ADR-BCL-TYPES

### Rule ADR-BCL-TYPES-ONETYPEPERFILE

One type per file, named for the bare type; its fully-qualified name is `<module>.<filename>` (`types/CliRunner.cs` in
`Catzc.Base.Execution` → `Catzc.Base.Execution.CliRunner`). The file declares the **file-scoped namespace of its module**
(`namespace Catzc.Base.Execution;`), which `Format-Types` writes and `Test-Formatting` checks; the loader identifies the type from the
filename, not by parsing the body. The first comment of the file may be a meta head of derived facts, which the loader ignores like any
comment.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-BCL-TYPES-NAMESPACEISMODULE

Every type's namespace equals its owning module and is **declared in the source** as a file-scoped `namespace <module>;` — but it is
**derived from the folder, not hand-authored**: `Format-Types` writes/repairs the line from the file's `types/` folder, so the folder stays
the single source of truth and a move between modules is a safe refactor. The loader and `Test-Formatting` reject a missing, mismatched, or
block-scoped namespace, and the loader rejects a dotted filename. The FQN is `<module>.<filename>`, making FQN collisions across modules
impossible.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-BCL-TYPES-ONEASSEMBLY

Every module's `types/*.cs` compile together into **one** assembly for the whole repository, so a type in any module can reference a type in
any other — only cross-_namespace_ references inside a single assembly, never cross-_assembly_. The compiler-assigned assembly name is
irrelevant because the assembly is a leaf in the reference graph: nothing references it by assembly identity, and every caller resolves a
type by its fully-qualified name. One runtime compiler builds it, the host's own, with no separate build step.

- [One assembly](#one-assembly)

### Rule ADR-BCL-TYPES-REFERENCESFOLLOWDEPS

Cross-module type references are allowed but **governed by the module dependency graph**: a deriving/referencing module must declare the
target in `configs/dependencies.yml`. The compiler does not enforce the layering in one combined assembly, so `Get-CSharpTypeDependency`
extracts the C# edges and the `Test-ModuleDependency` quality gate fails its L1 integrity test on an undeclared one. There is **one** shared
`Catzc.Base.Objects.DictionaryRecord`, not a per-module copy.

- [The `DictionaryRecord` base](#the-dictionaryrecord-base)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-BCL-TYPES-SNAKECASEMIRRORSYAML

Use snake_case property names **only** on a type that mirrors a YAML config (so the YAML key and the C# property are the same identifier);
every other type — results, CLI state, REST shapes such as `CliResult` / `CliRunner` — keeps default .NET PascalCase. snake_case is a
YAML-interop rule scoped to config-mirroring types, not a repository-wide naming convention.

- [snake_case records](#snake_case-records)

### Rule ADR-BCL-TYPES-NATIVETYPEDMODEL

The platform's internal fixed model is authored as native C# types — not loose dictionaries or ad-hoc objects. A first-class concept the
platform's own logic **selects on, branches on, or pins as a parameter or return type at a call site** (for example `Module`, `CliResult`)
is a C# type, so its shape is fixed, discoverable, and validated at construction. Loose dictionaries remain right for config-shaped data
crossing a boundary (a parsed `.yml`, a splat) — but the moment the code acts on the shape as a first-class concept, it is a type.

- [A C# model type](#a-c-model-type)

### Rule ADR-BCL-TYPES-LINEENDINGINSENSITIVEKEY

The compiled-type cache key is byte-exact but line-ending-insensitive: `Import-CSharpTypes` hashes each `types/*.cs` with the
carriage-return bytes stripped, so a CRLF or an LF working tree (git `core.autocrlf`, an editor's format-on-save, a checkout that rewrites
the file) yields the same `Catzc.Types.<hash>.dll` name on every machine. `.cs` sources are additionally pinned to LF in `.gitattributes` so
a checkout materializes identical bytes in the first place. The carriage-return stripping is duplicated in `Clear-ModuleTypeCache` (the
janitor), the drift-guard tests, and the IDE project's stamp task — keep all of them identical, or the janitor will plan the live build for
deletion.

- [The cache-state contract](#the-cache-state-contract)

### Rule ADR-BCL-TYPES-CONSOLEREADYTOSTRING

Every concrete type a caller can hold renders console-ready: it overrides `ToString()`, normally as the one line
`public override string ToString() => this.ToConsoleString();`, so its string form and a table cell read `TypeName { A = 1, B = x }` instead
of the fully-qualified name. The rendering lives once, in `Catzc.Base.Objects.ConsoleText`, and `DictionaryRecord` carries the override for
every record derived from it. A type names its identity properties with `[Catzc.Base.Objects.ConsoleDisplay(...)]`, which narrows both its
text and its default display at the prompt. `Test-ShippedTypes` fails a type that keeps the inherited `ToString()`.

- [Console-ready rendering](#console-ready-rendering)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-BCL-TYPES-DEBUGANYCPU

Every non-vendored `.sln` and `.csproj` declares exactly one build configuration and platform, Debug on Any CPU, and every `dotnet` call a
catzc command makes builds that pair. A solution lists only `Debug|Any CPU` in its `SolutionConfigurationPlatforms` and maps each project
only by `<guid>.Debug|Any CPU.ActiveCfg` and `<guid>.Debug|Any CPU.Build.0`; a project declares `<Configurations>Debug</Configurations>` and
`<Platforms>AnyCPU</Platforms>`. The pair belongs to the BCL language, not to its pwsh host: it is a sensible default declared once on the
`BclConfig` type and read through `bcl.yml`, so every generator of a solution, a project, or a build takes it from there and never names a
configuration of its own.

- [One build configuration](#one-build-configuration)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-BCL-TYPES-REFERENCESET

A type references the Base Class Library and nothing else: that is the BCL language's reference set. A type that binds to its host, such as
one that uses pwsh's `System.Management.Automation`, is a host binding, and a host binding is a configured exception: one row in `bcl.yml`
names the file and its reason. A host-bound type without its row is out of the language.

- [The host binding](#the-host-binding)
- [How this is enforced](#how-this-is-enforced)

## Context

Some logic is better expressed as a native .NET type than as script code: a process runner with background reader threads
(`Catzc.Base.Execution.CliRunner`), or a constrained, validated data record that replaces a loose dictionary. The platform autoloads such
types from each module's `types/` folder, compiling them once per machine into a gitignored, hash-named assembly that later sessions load
without recompiling (see [caching](../caching.md#rule-adr-auto-cache-compiledtypeprebuild) for why this prebuild is the one sanctioned
cross-session cache); git holds only each module's `types.json` contract.

Compilation produces **one assembly for the whole repository**, so any module's types can reference any other's: a single shared base and
records layered across modules. The cost is that the dependency checker, not the compiler, polices layering.

### One assembly

`Why one assembly, not one per module`

The blocker for cross-module references under a per-module design is the runtime compiler: it assigns a **random** assembly name, different
on every rebuild of a source that is unchanged, and has no setting for a stable one. A dependent assembly bakes that random name at compile
time and dangles when the base is rebuilt under a new name.

One combined assembly dissolves the problem entirely rather than working around it:

- **No cross-assembly references exist.** Every type is in one assembly; a base in `Catzc.Base.Objects` and a derived record in
  `Catzc.Azure.Templates` are different _namespaces_ in the _same_ assembly, which the compiler and CLR resolve unconditionally.
- **The random name is harmless.** The assembly is a leaf (Rule ADR-BCL-TYPES-ONEASSEMBLY), so the host's own compiler stays the compiler,
  with no separate build step, no topological compile order, and no transitive references.

A layer inversion (a base-module type referencing a leaf-module type) compiles in one assembly, so the linter catches it instead (Rule
ADR-BCL-TYPES-REFERENCESFOLLOWDEPS).

## Decision

Every module's `types/*.cs` are compiled together into **one** assembly, `Catzc.Types.<combinedHash8>.dll` in the per-user shadow root,
autoloaded before any module's functions. Each file is named for the bare type it must produce and declares the file-scoped
`namespace <module>;` of its folder; the loader compiles the sources **as authored**, one compilation unit per file, all landing in the
single assembly — so the FQN is `<module>.<filename>`. Types may reference each other across modules (one assembly); the dependency graph,
not the compiler, governs those edges.

The mechanism is `Import-CSharpTypes` in `pwsh/.internal/Catzc.Internal.Bootstrap.psm1`, run once as a pre-pass by `Import-AllModules`
before the module loop.

### The host binding

`How the one host compiles, references, and names the types`

BCL and its host are two things. The **language** is C# against the Base Class Library, a subset of .NET, with its own files, its own build
pair, and the BCL as its whole reference set (Rule ADR-BCL-TYPES-REFERENCESET); this record decides it. The **host** is the one engine that
runs the types today, pwsh, which compiles and loads them inside the .NET runtime already running its session. Which compiler builds the
assembly, which host assemblies it guarantees, the short names pwsh callers type, how a running pwsh meets a changed type, when a session
loads the assembly, what its janitors may change, and why the console text has to live in C# are that host's binding, decided in the pwsh
domain.

A type that needs the host itself (a parser over pwsh's syntax tree, a runspace) binds to it on purpose, and that binding is a row in
`bcl.yml` with its reason, so the language's reference set stays the BCL and every exception is named, not found.

### Declared namespaces and the IDE project

`Why the namespace is declared, and an IDE project alongside`

The namespace is **declared in the source** rather than wrapped in by the loader so the same files are valid, analyzable C# to the editor —
[everything-as-code](../../principles/everything-as-code.md). A file that declares no namespace becomes well-formed only after a loader's
textual wrap, so no `.csproj` can compile the raw sources: VS Code's C# Dev Kit treats them as "miscellaneous files", ignores
`.editorconfig` analyzer severities, and raises a false `CA1050 "Declare types in namespaces"` on every file, plus a "No solution file" nag.
Turning the analyzer off, or disabling Dev Kit, would hide the rule instead of expressing it as code — the opposite of EAC.

Declaring `namespace <module>;` makes each file compile cleanly on its own, so a real IDE project can analyze exactly what the runtime
compiles. The repo ships an **IDE-only** `Catzc.Types.csproj` (under `pwsh/.internal/assets/`, a `../../**/types/*.cs` glob over every type
source) and a classic root `catzc.sln` (Dev Kit loads a `.sln`, not a `.slnx`; kept at the repo root so the editor auto-loads it, and it
references the project by relative path) that mirror the runtime compile — `Nullable` and `ImplicitUsings` off, .NET 10 — so the editor's
feedback equals the runtime's: real namespaces (no `CA1050`), with two deliberate opt-outs stated in `.editorconfig` — `IDE1006` (snake_case
config-mirroring props, Rule ADR-BCL-TYPES-SNAKECASEMIRRORSYAML) and `IDE0130` (the namespace mirrors the module, not the project's physical
folder path, Rule ADR-BCL-TYPES-NAMESPACEISMODULE). The runtime never builds the project, and `Invoke-BuildForVsCode` builds the IDE project
on demand for the editor (see below). The [poka-yoke](../../principles/poka-yoke.md) is preserved because the namespace is folder-derived by
`Format-Types` and checked by `Test-Formatting`, not a second source of truth, maintained by hand, that could drift.

To keep that IDE artifact honest, the project **stamps its version from the built `Catzc.Types.<hash>.dll`** — the runtime assembly's own
identity ([ADR-AUTO-CACHE-COMPILEDTYPEPREBUILD](../caching.md#rule-adr-auto-cache-compiledtypeprebuild)) — so its build metadata (the
`deps.json` project entry) reads `Catzc.Types/1.0.0-<hash>`, not the accidental default `1.0.0`. It is trust-but-verify: the build
recomputes the combined source hash with the loader's algorithm and **fails when the built DLL is stale, missing, or ambiguous**, so the
editor's project can never present a version that outruns the sources it claims to describe. That makes the hashing a fourth mirror of the
same algorithm (loader, `Clear-ModuleTypeCache`, the drift-guard tests) that must stay in step.

That editor build is the second of two pathways over the same sources: the host's compiler builds the runtime assembly (Rule
ADR-BCL-TYPES-ONEASSEMBLY), and `dotnet build` compiles for the editor, which makes every `types/*.cs` a navigable Go-to-Symbol target.
`Invoke-BuildForVsCode` drives the editor half — a `dotnet build` of `Catzc.Types.csproj` — and it doubles as a gate: the project's stamp
task fails when the built `Catzc.Types.<hash>.dll` is stale versus the sources (ADR-AUTO-CACHE-COMPILEDTYPEPREBUILD), so a green build also
proves the IDE project matches the runtime prebuild. It runs `dotnet` through `Invoke-Executable`, not the Tooling layer's `Invoke-Dotnet`,
which a `Base` module must not depend on.

### The cache-state contract

The assembly is the per-machine cache of [caching](../caching.md#rule-adr-auto-cache-compiledtypeprebuild): it is named for the combined
hash of every module's sources and built on each machine into the per-user shadow root as `Catzc.Types.<hash>.dll`, with its manifest beside
it. Git keeps no file under `pwsh/.compiled`; what a consumer binds to, each module's types surface (each type's name, aliases, display and
public members), is the provided contract `types.json` in its group under `contracts/catzc/0.1.0/`, regenerated after a compile and written
only when that surface moves. The hash material is per file `<module>|<bare type>|SHA-256(content)`, ordered by `<module>/<type>` ordinally,
so a move between modules (new namespace) or a rename (new type) re-keys even when content is byte-identical, with no dependence on the
repository root. Every process loads the assembly from a per-user shadow copy (`Import-TypesAssembly`: `%LOCALAPPDATA%\catzc\types` on
Windows, `~/.local/share/catzc/types` on Unix), never from the working tree, so no session ever locks a file in the repository
([why](#why-a-shadow-copy)).

Because the DLL filename _is_ the combined source hash, there is no "present but stale" state — a source that changes has a different
filename, so the current-hash DLL is simply absent until built. The loader resolves every state:

- **present**
  - types loaded this session: no
  - Outcome: **Skip compile, load it.** CI / fresh-checkout hot path (no Roslyn).
- **present**
  - types loaded this session: yes
  - Outcome: **No-op.** Types already loaded in the process.
- **absent (source added/changed/deleted)**
  - types loaded this session: no
  - Outcome: **Compile** all sources → the hash-named DLL, load, verify every type.
- **absent (DLL deleted, source unchanged)**
  - types loaded this session: yes
  - Outcome: **Recompile via `-OutputAssembly`** (writes without loading) — self-heals the shadow build; no reload.
- **absent because the source CHANGED**
  - types loaded this session: yes
  - Outcome: **Keep the loaded types; the host decides whether the session warns and goes on or throws.** A loaded copy cannot be swapped,
    so the remedy is a new process; the host's record names the outcome for each kind of session.

A superseded-hash DLL (the old build after a source edit) is pruned by the loader on rebuild and by the post-import janitor
`Clear-ModuleTypeCache` (which deletes on a devbox only; CI makes no source-control changes). Editing any `types/*.cs` re-keys the whole
assembly — one combined hash, one build, paid once on each machine.

The shadow root holds the current build and any superseded one a process still has loaded. Every tree's sessions share it, and each load
refreshes its build's write time, so a build loaded within the loader's prune age (`Get-TypesPruneAfter`, declared once) may be another
tree's current one: the loader's prune and `Clear-ModuleTypeCache` both keep it. `Clear-ModuleTypeCache` removes every deletable superseded
build older than that and names each survivor with, on Windows, its holders (`Get-FileLockingProcess`, via the Restart Manager) in one
yellow line; a silent run says nothing. It never throws for a held build, never stops a holder and never waits for one: the held build is
that process's one types instance, since a loaded assembly cannot be swapped, and it goes on the next run after the holder exits.

What git guards is the types surface, not a build. A devbox import that compiles regenerates the contract from the compiled assembly and
writes it only when the surface moved, so equal content leaves git clean; `Test-GeneratedFiles` fails when the committed contract differs
from the current assembly's surface, naming the added, removed or changed types; a pipeline and a bundle build check it and never write it.

### Stale types in a running process

.NET cannot unload an assembly from a running process, and a second assembly with the same type names would split their identity: a
`[Catzc.…]` literal would resolve to one copy while an object holds the other. So once a type source changes, the process that loaded the
old types keeps them until it ends, and the only remedy is a new process. Stopping other processes does not help: the stale copy is in the
process that asks. How a host measures that drift and answers it, warning or throwing, is the host's record.

### Why a shadow copy

Windows locks a loaded file until its process exits, so loading the built assembly in place lets any live session (a console, an editor
host, an analyzer process, a test worker) block the prune of a superseded build. So a session loads a per-user copy of the build, never the
build itself, and the build stays read-only to every session. The copy is content-addressed (`Catzc.Types.<hash>.dll`), written through a
temp file and an atomic move, shared by every session and clone with the same sources, and pruned once it has gone a day without a load.
Nothing there is committed, so a locked leftover copy is harmless. How a host loads the copy is that host's own record.

### The `DictionaryRecord` base

```text
The `DictionaryRecord` base (dictionary-compatible data records)
```

A data record that replaces a dictionary shape may inherit the single, shared `Catzc.Base.Objects.DictionaryRecord` (the combined assembly
makes the cross-module reference possible). It supplies two things a derived record would otherwise implement:

- A **dictionary view** over the record's own public properties — `Contains(key)`, the `[key]` indexer, `Keys`, and `ToHashtable()` (for
  splatting and `ConvertTo-Json`/`-Yaml`). "Present" means the public property exists **and its value is non-null**, mirroring the
  omitted-key idiom of the dictionaries these records replace — so a producer setting an absent optional to `null` makes
  `Contains('customer')` false. The view reflects only properties the _derived_ record declares, never the base's own members.
- **Protected extraction helpers** (`Req` / `OptStr` / `StrArr`) that derived constructors call to read their source `IDictionary`.

A deriving module must declare `Catzc.Base.Objects` (directly or through the `Base` group) in `dependencies.yml` (every Azure and Tooling
module declares `Base`). A record names its properties to match the dict keys it mirrors (snake_case where the keys are snake_case).
`BicepTemplate` is an example that derives from it.

### snake_case records

`snake_case is for config-mirroring records only`

The "same name inside and outside" snake_case rule is a **YAML-interop** concern, not a repository-wide naming convention: it applies only
to a type whose properties mirror the keys of a `configs/<name>.yml` file, so the YAML key and the C# property are literally the same
identifier (the YAML side is enforced by `Assert-YmlNaming`). A type with no backing YAML file — a result, CLI-state, or REST shape such as
`CliResult` or `CliRunner` — has nothing to mirror, so it keeps default .NET **PascalCase**. For a non-config typed record that already
emits snake keys from an external tool (for example an `az` CLI `logged_in` field), match the existing keys to avoid breaking consumers —
but do not force a universal flip.

### A C# model type

`The model is C#, not a loose dictionary`

There are two kinds of structured data in the platform, and they get different treatment. **Boundary data** — a parsed `configs/*.yml`, an
`az` CLI JSON blob, a splatted parameter set — is shaped by something outside our code; it is validated where it crosses in and then
consumed. A shipped config crosses in through its C# config type (registered in `configs.yml`), which maps and validates it at load; the
rest is fine as a dictionary or a plain object. **Model data** — a first-class concept the platform's _own_ logic operates on — is
different: the moment code selects on it, branches on its kind, or pins it as a parameter/return type at a call site, its shape is part of
the design and must be fixed, discoverable, and enforced. That is a native C# type.

`Module` is the example: `Get-CatzcModule` returns `[Module]`, `Copy-CatzcModule`, the globset derivation and the folder checks read their
module list off it, and callers type against it — so it is a C# type, not a bag of hashtables that every call site re-interprets. A loose
dictionary here would push the shape into scattered string-keys with no single definition and no construction-time check — the opposite of a
fixed model. Config that _feeds_ the model (the layout in `languages.yml`, the tracks in `variants.yml`) crosses the boundary through its
own config type, `LanguagesConfig` or `VariantsConfig`, which validates it at load; the model `Get-CatzcModule` builds from it is typed too.

### Console-ready rendering

`A catzc object reads as one line`

How an object reads at the console is part of its design
([console-output-matters](../console-output-matters.md#rule-adr-auto-console-everylineearnsplace)). A class that keeps `object.ToString()`
renders as its fully-qualified name: a message about a subscription context prints `Catzc.Azure.Cli.SubscriptionContext`, and a collection
property shows `{Catzc.Base.Objects.GlobPattern, …}` in a table. The host's string conversion reads the type's own `ToString()`, so the fix
is in C#.

So the rendering is one shared extension method, `ConsoleText.ToConsoleString()`, and each type opts in with a one-line override. The format
is the C# `record` convention a .NET reader already knows, `TypeName { A = 1, B = x }`, on one line: the bare type name, a null property
omitted (the `DictionaryRecord` "present" rule), strings as-is with newlines escaped, numbers invariant, dates ISO 8601, collections capped
at a few items with the rest counted, and a nested object by its own `ToString()`, with nesting capped so a cycle cannot recurse. A type
whose identity is one domain value (a path, a glob pattern, a dependency edge) writes its own `ToString()` instead, since that value reads
better than a property list.

`[ConsoleDisplay("Id", "Name")]` names a type's identity properties once and drives both console surfaces: `ToConsoleString()` renders only
those, and `Import-CSharpTypes` registers them as the type's default display, so an object shown at the prompt shows those columns instead
of every property.

### One build configuration

`One configuration, one platform, one build`

The C# in this repository is source that runs inside one host or a small agent hook on the machine that built it: the IDE project mirrors
the host's runtime compile, and a hook is published framework-dependent where it runs. Nothing ships a separately optimized build, so a
Release configuration and the x64 and x86 platforms only multiply the matrix a solution carries, the rows an editor offers, and the outputs
that can disagree. One pair, Debug on Any CPU, keeps the editor's build, the hook's publish and the solution's map the same build
([reduce-variability](../../principles/reduce-variability.md)). BCL is a .NET language in this domain, and a language here carries its build
as well as its files, so the pair is the language's configuration, apart from the pwsh host that compiles the types inside its own running
.NET runtime. It is configuration, not code: `BclConfig` declares the default once
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)), and a generator reads it.

### How this is enforced

- **`BclConfig.Tests.ps1`** (in `Catzc.Base.Languages`) pins the default pair, and its integrity test fails a tracked, non-vendored `.sln`
  or `.csproj` that declares any other configuration or platform (Rule ADR-BCL-TYPES-DEBUGANYCPU). `Build-AgentHook` and the IDE-project
  build build the configuration they read from `bcl.yml`.

- **`Test-BclReferences`** (in `Catzc.Base.QualityGates`, a check of the `csharp` language) fails a type source that uses
  `System.Management.Automation` without its `bcl.yml` host-binding row, and a row whose source no longer uses it (Rule
  ADR-BCL-TYPES-REFERENCESET). A value that only crosses from pwsh is unwrapped by its caller through `ConvertTo-BclValue`, so it never
  makes a type host-bound.

- **`Format-Types` + `Test-Formatting`** (in `Catzc.Base.QualityGates`) — `Format-Types` writes/repairs each source's file-scoped
  `namespace <module>;` from its `types/` folder (the formatter, not an ad-hoc sweep); the `Test-Formatting` quality gate runs it in its
  report-only mode, failing on a missing, mismatched, or block-scoped namespace. The folder is the single source of truth, so the namespace
  can never drift from it.

- **`Import-CSharpTypes`** rejects a dotted filename and a source whose declared namespace is missing, mismatched, or block-scoped (the same
  invariant `Test-Formatting` enforces, checked at load), compiles all modules' sources **as authored** into one assembly (one compilation
  unit per file), verifies every `types/*.cs` produced `<module>.<filename>` (else "was not produced"), and registers each
  `[Catzc.Base.Objects.ConsoleDisplay]` property list as the type's default display (Rule ADR-BCL-TYPES-CONSOLEREADYTOSTRING).

- **`Test-ShippedTypes`** (in `Catzc.Base.TypesSystem`) fails a concrete shipped class that keeps the inherited `ToString()`, naming the
  file and the line to add (Rule ADR-BCL-TYPES-CONSOLEREADYTOSTRING); enums, interfaces, abstract and static classes, attributes, and
  exceptions are exempt. `ConsoleText.Tests.ps1` pins the rendering rules.

- **The IDE-project build** drives the editor-facing `dotnet build` of `Catzc.Types.csproj` on demand, so a dev or CI builds and verifies
  the IDE project; the project's stamp task fails the build on a stale built DLL. The command that drives it is the host's.

- **`Get-CSharpTypeDependency` + `Test-ModuleDependency`** — the cross-module C# edges are extracted (a scan that strips comments, string
  literals, and each file's own `namespace <module>;` line, then maps each dotted token to its longest known-module-name prefix) and checked
  against `configs/dependencies.yml` alongside the function-call edges. An undeclared type edge fails L1. `dependencies.yml` supports a
  top-level `groups:` map — a named set of modules with its own internal member→member DAG; an allowed-deps entry may name a GROUP
  (permitting an edge to any member) or a specific MODULE. The `Catzc.Base.*` cluster is held together as the `Base` group.

- **`Import-CSharpTypes.Tests.ps1`** covers the combined compile + cache, intra-module and **cross-module** inheritance, the missing /
  mismatched / block-scoped namespace and dotted-filename throws, the filename-type verification, the changed-after-load fail-fast,
  self-heal of a deleted DLL, the `DictionaryRecord` dictionary view, and a drift guard (the built `Catzc.Types.<hash>.dll` matches the
  current sources). A `shipped C# types` test asserts every shipped type resolves **and** declares its module namespace (via
  `Test-Formatting -Language bcl`), and a `PSTypeAlias accelerators` test asserts a decorated type's accelerator resolves after load.
  `Set-CSharpFileScopedNamespace.Tests.ps1` unit-tests the namespace string engine behind `Format-Types`.

- **`Clear-ModuleTypeCache`** keeps the current build in the shadow root, and any build younger than the prune age, and prunes the older
  superseded ones. A build a process still holds is named with its holders in one yellow line and left for the run after the holder exits.

- **`Import-TypesAssembly`** (in `.internal/Catzc.Internal.Types.psm1`) is the one load path — the bootstrap and the `SpellOutIdentifiers`
  analyzer rule both load through the shadow copy, so no session holds a file in the repository. `Import-TypesAssembly.Tests.ps1` covers the
  copy, its reuse, the atomic write, the concurrent-copy race, pruning, and `Location` pointing into the shadow root.

- **The types contracts** (`contracts/catzc/0.1.0/<group>/types.json`, one per module with types, validated against the one
  `pwsh.base.contracts/types.schema.json`) are the committed surface: `Write-TypesContract` regenerates each after a devbox compile, writing
  only a surface that moved, `Test-BuildArtifact -Facet Types` fails on a surface that differs from the current assembly's, and
  `Test-Contracts` validates each against the schema and every command contract's catzc types against them.

## Disambiguation

The module-dependency graph that governs cross-module C# type edges (ADR-BCL-TYPES-REFERENCESFOLLOWDEPS) is owned by
[controlling-module-dependencies](../controlling-module-dependencies.md) (`ADR-AUTO-DEPM`); this record covers the type system itself.

## Consequences

- The whole repository's types compile together and reference each other freely.

- A type file's module identity lives in its folder; moving a `.cs` to another module is a safe refactor — re-run `Format-Types`.

- The editor analyzes exactly the sources the runtime compiles, with the rules as code, not a disabled analyzer.

- The dependency graph is the one source of truth for both function-call and C# type layering.

- Editing any type re-keys and rebuilds the one assembly (a single sub-second compile, paid once on each machine) and requires a session
  restart to pick up — the documented devbox contract.
