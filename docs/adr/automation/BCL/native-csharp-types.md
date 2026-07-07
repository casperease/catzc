# ADR: Native C# types — one combined assembly, namespace per module

## Rules: ADR-TYPES

### Rule ADR-TYPES:1

One type per file, named for the bare type; its fully-qualified name is `<module>.<filename>` (`types/CliRunner.cs` in
`Catzc.Base.Execution` → `Catzc.Base.Execution.CliRunner`). The file declares the **file-scoped namespace of its module**
(`namespace Catzc.Base.Execution;`), which `Format-Types` writes and `Test-Types` gates; the loader identifies the type from the filename,
not by parsing the body.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-TYPES:2

Every type's namespace equals its owning module and is **declared in the source** as a file-scoped `namespace <module>;` — but it is
**derived from the folder, not hand-authored**: `Format-Types` writes/repairs the line from the file's `types/` folder, so the folder stays
the single source of truth and a move between modules is a safe refactor. The loader and `Test-Types` reject a missing, mismatched, or
block-scoped namespace, and reject a dotted filename. The FQN is `<module>.<filename>`, making FQN collisions across modules impossible.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-TYPES:3

Every module's `types/*.cs` compile together into **one** assembly for the whole repository, so a type in any module can reference a type in
any other — only cross-_namespace_ references inside a single assembly, never cross-_assembly_. The Roslyn-assigned (random) assembly name
is irrelevant because the assembly is a leaf in the reference graph: nothing references it by assembly identity, and PowerShell resolves
`[Namespace.Type]` by FQN. `Add-Type` stays the compiler.

- [Why one assembly, not one per module](#why-one-assembly-not-one-per-module)

### Rule ADR-TYPES:4

Cross-module type references are allowed but **governed by the module dependency graph**: a deriving/referencing module must declare the
target in `configs/dependencies.yml`. The compiler does not enforce the layering in one combined assembly, so `Get-CSharpTypeDependency`
extracts the C# edges and `Assert-ModuleDependency` fails the L2 suite on an undeclared one. There is **one** shared
`Catzc.Base.Objects.DictionaryRecord`, not a per-module copy.

- [The `DictionaryRecord` base](#the-dictionaryrecord-base-dictionary-compatible-data-records)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-TYPES:5

Host-guaranteed assemblies only — types reference the BCL plus `System.Management.Automation`, and nothing else. Both are in `Add-Type`'s
default reference set, and both are loaded in every process that can load the compiled assembly, so a `using` namespace is the whole
binding. No external packages, no NuGet.

- [The reference set: host-guaranteed assemblies](#the-reference-set-host-guaranteed-assemblies)

### Rule ADR-TYPES:6

The assembly is named for the combined hash of every module's sources and committed to `automation/.compiled/Catzc.Types.<hash>.dll`, so a
fresh checkout and CI load it without Roslyn; editing any source re-keys it. The hash material is per file
`<module>|<bare type>|SHA-256(content)`, ordered by `<module>/<type>` ordinally — so a move between modules (new namespace) or a rename (new
type) re-keys even when content is byte-identical, with no dependence on the repo root.

- [The cache-state contract](#the-cache-state-contract)

### Rule ADR-TYPES:7

Handle changed-after-load by context — a loaded assembly cannot be swapped in the AppDomain. In a **pipeline** the loader throws (CI must
never run on stale types); on a **devbox** it degrades gracefully — warns in orange ("Using old cached C# types … restart PowerShell") and
keeps the already-loaded types this session, so a dev editing a type mid-session is never blocked. It returns without recording the new
hash, so the warning repeats on every re-import until you restart. The pipeline check is inlined (`$env:TF_BUILD`/`$env:GITHUB_ACTIONS`)
because this pre-pass runs before `Catzc.Base.Repository` (Test-IsRunningInPipeline) loads.

- [The cache-state contract](#the-cache-state-contract)

### Rule ADR-TYPES:8

Use snake_case property names **only** on a type that mirrors a YAML config (so the YAML key and the C# property are the same identifier);
every other type — results, CLI state, REST shapes such as `CliResult` / `CliRunner` — keeps default .NET PascalCase. snake_case here is a
YAML-interop concern, not a house style.

- [snake_case is for config-mirroring records only](#snake_case-is-for-config-mirroring-records-only)

### Rule ADR-TYPES:9

The internal fixed domain model is authored as native C# types — not `[pscustomobject]` / `[ordered]@{}`. A first-class domain concept the
platform's own logic **selects on, branches on, or pins as a parameter or return type at a call site** (for example `BaseModule` and its
kinds, `CliResult`) is a C# type, so its shape is fixed, discoverable, and validated at construction. Loose dictionaries remain right for
config-shaped data crossing a boundary (a parsed `.yml`, a splat) — but the moment the code acts on the shape as a domain concept, it is a
type.

- [The domain model is C#, not a loose dictionary](#the-domain-model-is-c-not-a-loose-dictionary)

### Rule ADR-TYPES:10

A type publishes a PowerShell type-accelerator by carrying `[Catzc.Base.Objects.PSTypeAlias("Name")]`; `Import-CSharpTypes` registers each
after loading the assembly, so `[Name]` resolves to that type (`[Catzc.Module.Depm]::Puml`). Names carry a `Catzc.` prefix — a registration
reclaims only our own accelerator — and the alias literal is authored in the decorated source, so a search for it lands on the type. This is
registration, not compilation: `Add-Type` stays the sole compiler, and the decoration's cross-module edge is governed by the dependency
graph (Rule ADR-TYPES:4) like any other.

- [Type-accelerator aliases, and backtracking to source](#type-accelerator-aliases-and-backtracking-to-source)

### Rule ADR-TYPES:11

The compiled-type cache key is byte-exact but line-ending-insensitive: `Import-CSharpTypes` hashes each `types/*.cs` with the
carriage-return bytes stripped, so a CRLF or an LF working tree (git `core.autocrlf`, an editor's format-on-save, a checkout that rewrites
the file) yields the same `Catzc.Types.<hash>.dll` name on every machine. `.cs` sources are additionally pinned to LF in `.gitattributes` so
a checkout materializes identical bytes in the first place. The carriage-return stripping is duplicated in `Clear-ModuleTypeCache` (the
janitor), the drift-guard tests, and the IDE project's stamp task — keep all of them identical, or the janitor will plan the live build for
deletion.

- [The cache-state contract](#the-cache-state-contract)

### Rule ADR-TYPES:12

The "source changed since loaded — restart PowerShell" guard is keyed by `ModulesRoot`. `Import-CSharpTypes` takes the tree as a parameter,
and one session may load more than one tree (the real `automation/` plus the test-fixture trees), so the per-session record of loaded hash
and file snapshot is stored per resolved root. A load from one root therefore never makes a re-import of another root falsely report a
change — without this, running the test suite (which loads fixture trees) would poison the next real import's guard. The thrown message
names the drifted files and both hashes so the cause is diagnosable from the error text alone.

- [The cache-state contract](#the-cache-state-contract)

## Context

Some logic is better expressed as a native .NET type than as PowerShell: a process runner with background reader threads
(`Catzc.Base.Execution.CliRunner`), or a constrained, validated data record that replaces a loose `[pscustomobject]` / `[ordered]@{}`. The
platform autoloads such types from each module's `types/` folder (see [conventional-folders](../../repository/conventional-folders.md) for
where `types/` sits) and commits the compiled assembly so a fresh checkout and CI load it without invoking Roslyn (see
[caching](../caching.md#rule-adr-cache8) for why committed prebuilds are the one sanctioned cross-session cache).

Compilation produces **one assembly for the whole repository**, so any module's types can reference any other's: a single shared base (a
dictionary-compatible data-record base) and layered records (a record in one module building on a record in another) — the thing static data
classes want most. Compiling one assembly per module would forbid those cross-module references; the cost of the single assembly is that
layering discipline is policed by the dependency checker rather than structurally by the compiler.

### Why one assembly, not one per module

The blocker for cross-module references under the per-module design was `Add-Type`: it assigns a **random** assembly name (verified —
`Add-Type -OutputAssembly` produces e.g. `khuvslfy.cez`, and a rebuild of identical source produces a _different_ random name). A dependent
assembly bakes that random name at compile time and dangles when the base is rebuilt under a new name. There is no `Add-Type` knob for a
stable assembly name, and no NuGet to reach the Roslyn API cleanly.

One combined assembly dissolves the problem entirely rather than working around it:

- **No cross-assembly references exist.** Every type is in one assembly; a base in `Catzc.Base.Objects` and a derived record in
  `Catzc.Azure.Templates` are different _namespaces_ in the _same_ assembly, which the compiler and CLR resolve unconditionally.
- **The random name is harmless.** The combined assembly is a leaf in the assembly-reference graph — nothing references it by assembly
  identity. PowerShell resolves `[Namespace.Type]` by fully-qualified name, so the Roslyn-assigned name is never consulted. `Add-Type`
  therefore stays the compiler, with no `dotnet`/`csc` build step, no topological compile order, and no transitive references.

The cost is that the compiler does not structurally forbid a layer inversion (a base-module type referencing a leaf-module type) — in one
compilation unit that just compiles. That enforcement moves to the linter (see Rule ADR-TYPES:4): `Get-CSharpTypeDependency` reports the
cross-module C# edges and the existing acyclic allow-list in `configs/dependencies.yml` governs them, failing L2 on an undeclared edge.

## Decision

Every module's `types/*.cs` are compiled together into **one** assembly, `automation/.compiled/Catzc.Types.<combinedHash8>.dll`, autoloaded
before any module's functions. Each file is named for the bare type it must produce and declares the file-scoped `namespace <module>;` of
its folder; the loader compiles the sources **as authored** — `Add-Type -Path` over the files, one compilation unit each (a file-scoped
namespace is illegal once several are concatenated into one unit), all landing in the single assembly — so the FQN is `<module>.<filename>`.
Types may reference each other across modules (one assembly); the dependency graph, not the compiler, governs those edges.

The mechanism is `Import-CSharpTypes` in `automation/.internal/Catzc.Internal.Bootstrap.psm1`, run once as a pre-pass by `Import-AllModules`
before the module loop.

### The reference set: host-guaranteed assemblies

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

### Why the namespace is declared, and an IDE project alongside

The namespace is **declared in the source** rather than wrapped in by the loader so the same files are valid, analyzable C# to the editor —
[everything-as-code](../../principles/everything-as-code.md). A file that declared no namespace only became well-formed after the loader's
textual wrap, so no `.csproj` could compile the raw sources: VS Code's C# Dev Kit treated them as "miscellaneous files", ignored
`.editorconfig` analyzer severities, and raised a false `CA1050 "Declare types in namespaces"` on every file, plus a "No solution file" nag.
Turning the analyzer off, or disabling Dev Kit, would hide the rule instead of expressing it as code — the opposite of EAC.

Declaring `namespace <module>;` makes each file compile cleanly on its own, so a real IDE project can analyze exactly what the runtime
compiles. The repo ships an **IDE-only** `Catzc.Types.csproj` (under `automation/.internal/assets/`, a `../../**/types/*.cs` glob over every
type source) and a classic root `catzc.sln` (Dev Kit loads a `.sln`, not a `.slnx`; kept at the repo root so the editor auto-loads it, and
it references the project by relative path) that mirror `Add-Type`'s compile — `Nullable` and `ImplicitUsings` off, .NET 10 — so the
editor's feedback equals the runtime's: real namespaces (no `CA1050`), with two deliberate opt-outs stated in `.editorconfig` — `IDE1006`
(snake_case config-mirroring props, Rule ADR-TYPES:8) and `IDE0130` (the namespace mirrors the module, not the project's physical folder
path, Rule ADR-TYPES:2). The runtime never builds the project; `Add-Type` stays the compiler, and `Invoke-BuildForVSCode` builds the IDE
project on demand for the editor (see below). The [poka-yoke](../../principles/poka-yoke.md) is preserved because the namespace is
folder-derived by `Format-Types` and gated by `Test-Types`, not a second hand-maintained source of truth that could drift.

To keep that IDE artifact honest, the project **stamps its version from the committed `Catzc.Types.<hash>.dll`** — the runtime assembly's
own identity (Rule ADR-TYPES:6) — so its build metadata (the `deps.json` project entry) reads `Catzc.Types/1.0.0-<hash>`, not the accidental
default `1.0.0`. It is trust-but-verify: the build recomputes the combined source hash with the loader's algorithm and **fails when the
committed DLL is stale, missing, or ambiguous**, so the editor's project can never present a version that outruns the sources it claims to
describe. That makes the hashing a fourth mirror of the same algorithm (loader, `Clear-ModuleTypeCache`, the drift-guard tests) that must
stay in step.

### Type-accelerator aliases, and backtracking to source

A type exposes a short alias for its fully-qualified name by carrying one or more `[Catzc.Base.Objects.PSTypeAlias("Catzc.Module.Depm")]`
attributes (Rule ADR-TYPES:10). After loading the combined assembly, `Import-CSharpTypes` reflects for the attribute and registers each name
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

That editor build is the second of two pathways over the same sources: `Add-Type` compiles for the runtime (Rule ADR-TYPES:3), and
`dotnet build` compiles for the editor. `Invoke-BuildForVSCode` drives the editor half — a `dotnet build` of `Catzc.Types.csproj` — and it
doubles as a gate: the project's stamp task fails when the committed `Catzc.Types.<hash>.dll` is stale versus the sources (Rule
ADR-TYPES:6), so a green build also proves the IDE project matches the runtime prebuild. It runs `dotnet` through `Invoke-Executable`, not
the Tooling layer's `Invoke-Dotnet`, which a `Base` module must not depend on.

A short accelerator trades some of the [spell-out ADR](../powershell/spell-out-names.md)'s self-describing-name value for terseness at the
call site; the `Catzc.`-namespaced, source-authored literal is what keeps it discoverable rather than opaque.

### The cache-state contract

Because the DLL filename _is_ the combined source hash, there is no "present but stale" state — a changed source has a different filename,
so the current-hash DLL is simply absent until built. The loader resolves every state:

| current-hash DLL                       | types loaded this session | Outcome                                                                                                                                                                                                      |
| -------------------------------------- | ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| present                                | no                        | **Skip compile, load it.** CI / fresh-checkout hot path (no Roslyn).                                                                                                                                         |
| present                                | yes                       | **No-op.** Types already in the AppDomain.                                                                                                                                                                   |
| absent (new/changed/deleted source)    | no                        | **Compile** all sources → the hash-named DLL, load, verify every type.                                                                                                                                       |
| absent (DLL deleted, source unchanged) | yes                       | **Recompile via `-OutputAssembly`** (writes without loading) — self-heals the committed artifact; no reload.                                                                                                 |
| absent because source CHANGED          | yes                       | **Devbox: warn (orange) + keep the old types** this session (return, don't record the new hash). **Pipeline: throw "restart PowerShell"** — CI must not run on stale types. A loaded copy cannot be swapped. |

A superseded-hash DLL (the old build after a source edit) is pruned by the loader on rebuild and by the post-import janitor
`Clear-ModuleTypeCache` (which deletes on a devbox only; CI makes no source-control changes). Editing any `types/*.cs` re-keys the whole
assembly — one combined hash, one committed DLL, paid once by the editor.

`.compiled` must hold **exactly one** `Catzc.Types.*.dll`. Whenever a second one coexists, `Clear-ModuleTypeCache` reacts before its
delete/skip pass, in both runtimes: it always emits a yellow warning ("Two dll exists in .compiled - is a console session locking it?"),
because the usual devbox cause is another console session holding the old DLL so it could not be deleted (a Windows lock the janitor can
only skip). In a **pipeline** the same coexistence is a hard `throw`: two committed builds mean a locked stale DLL was committed instead of
deleted, so CI is the gate that stops it reaching trunk — the fix is to restart PowerShell on the devbox (releasing the lock), re-run
`Clear-ModuleTypeCache`, and commit the single remaining build.

### The `DictionaryRecord` base (dictionary-compatible data records)

A data record backed by an `[ordered]@{}` / `[pscustomobject]` shape may inherit the single, shared `Catzc.Base.Objects.DictionaryRecord`
(the combined assembly makes the cross-module reference possible). It supplies two things a derived record would otherwise implement:

- A **dictionary view** over the record's own public properties — `Contains(key)`, the `[key]` indexer, `Keys`, and `ToHashtable()` (for
  splatting and `ConvertTo-Json`/`-Yaml`). "Present" means the public property exists **and its value is non-null**, mirroring the
  omitted-key idiom of the dictionaries these records replace — so a producer setting an absent optional to `null` makes
  `Contains('customer')` false. The view reflects only properties the _derived_ record declares, never the base's own members.
- **Protected extraction helpers** (`Req` / `OptStr` / `StrArr`) that derived constructors call to read their source `IDictionary`.

A deriving module must declare `Catzc.Base.Objects` in `dependencies.yml` (every Azure/DevBox module does). A record names its properties to
match the dict keys it mirrors (snake_case where the keys are snake_case). `BicepTemplate` is an example that derives from it.

### snake_case is for config-mirroring records only

The "same name inside and outside" snake_case rule is a **YAML-interop** concern, not a universal house style: it applies only to a type
whose properties mirror the keys of a `configs/<name>.yml` file, so the YAML key and the C# property are literally the same identifier (the
YAML side is enforced by `Assert-YmlNaming`). A type with no backing YAML file — a result, CLI-state, or REST shape such as `CliResult` or
`CliRunner` — has nothing to mirror, so it keeps default .NET **PascalCase**. For a non-config domain object that already emits snake keys
from an external tool (for example an `az` CLI `logged_in` field), match the existing keys to avoid breaking consumers — but do not force a
universal flip.

### The domain model is C#, not a loose dictionary

There are two kinds of structured data in the platform, and they get different treatment. **Boundary data** — a parsed `configs/*.yml`, an
`az` CLI JSON blob, a splatted parameter set — is shaped by something outside our code and is fine as an `[ordered]@{}` /
`[pscustomobject]`; it is validated where it crosses in (an `Assert-*Config`, a typed config record) and then consumed. **Domain model** — a
first-class concept the platform's _own_ logic operates on — is different: the moment code selects on it, branches on its kind, or pins it
as a parameter/return type at a call site, its shape is part of the design and must be fixed, discoverable, and enforced. That is a native
C# type.

`BaseModule` (and its `named`/`hidden`/`imported`/`residue` kinds) is the example: `Get-BaseModule` returns `[BaseModule]`,
`Copy-Automation` filters modules and packages off it, and callers type against it — so it is a C# hierarchy, not a bag of hashtables that
every call site re-interprets. A loose dictionary here would push the shape into scattered string-keys with no single definition and no
construction-time check — the opposite of a fixed model. Config that _feeds_ the model (the `files.yml` package bindings) stays loose YAML
crossing the boundary; the model built from it is typed.

- **`Format-Types` + `Test-Types`** (in `Catzc.Base.QualityGates`) — `Format-Types` writes/repairs each source's file-scoped
  `namespace <module>;` from its `types/` folder (the formatter, not an ad-hoc sweep); `Test-Types` is the gate, failing on a missing,
  mismatched, or block-scoped namespace. The folder is the single source of truth, so the namespace can never drift from it.

- **`Import-CSharpTypes`** rejects a dotted filename and a source whose declared namespace is missing, mismatched, or block-scoped (the same
  invariant `Test-Types` enforces, checked at load), compiles all modules' sources **as authored** into one assembly (`Add-Type -Path`, one
  compilation unit per file), verifies every `types/*.cs` produced `<module>.<filename>` (else "was not produced"), and registers each
  `[Catzc.Base.Objects.PSTypeAlias]` name as a type-accelerator (Rule ADR-TYPES:10).

- **`Invoke-BuildForVSCode`** (in `Catzc.Base.TypesSystem`) drives the editor-facing `dotnet build` of `Catzc.Types.csproj` through
  `Invoke-Executable`, so a dev or CI builds and verifies the IDE project on demand; the project's stamp task fails the build on a stale
  committed DLL, and a `Base` module reaching the Tooling layer's `Invoke-Dotnet` would invert the dependency graph, so it does not.

- **`Get-CSharpTypeDependency` + `Assert-ModuleDependency`** — the cross-module C# edges are extracted (a scan that strips comments, string
  literals, and each file's own `namespace <module>;` line, then maps each dotted token to its longest known-module-name prefix) and checked
  against `configs/dependencies.yml` alongside the function-call edges. An undeclared type edge fails L2. `dependencies.yml` supports a
  top-level `groups:` map — a named set of modules with its own internal member→member DAG; an allowed-deps entry may name a GROUP
  (permitting an edge to any member) or a specific MODULE. The ex-`Catzc.Base.Utils` cluster is held together as the `Base` group.

- **`Import-CSharpTypes.Tests.ps1`** covers the combined compile + cache, intra-module and **cross-module** inheritance, the missing /
  mismatched / block-scoped namespace and dotted-filename throws, the filename-type verification, the changed-after-load fail-fast,
  self-heal of a deleted DLL, the `DictionaryRecord` dictionary view, and a drift guard (the committed `Catzc.Types.<hash>.dll` matches the
  current sources, with no pending git changes). A `shipped C# types` test asserts every committed type resolves **and** declares its module
  namespace (via `Test-Types`), and a `PSTypeAlias accelerators` test asserts a decorated type's accelerator resolves after load.
  `Set-CSharpFileScopedNamespace.Tests.ps1` unit-tests the namespace string engine behind `Format-Types`.

- **`Clear-ModuleTypeCache`** keeps the current `automation/.compiled/Catzc.Types.<hash>.dll` and prunes the rest (deleting on a devbox
  only). It also enforces the one-committed-build invariant: when a second `Catzc.Types.*.dll` coexists it always warns (yellow), and in a
  pipeline it throws — a stale committed build must not reach trunk.

## Disambiguation

The module-dependency graph that governs cross-module C# type edges (ADR-TYPES:4) is owned by
[controlling-module-dependencies](../controlling-module-dependencies.md) (`ADR-MODDEPS`); this ADR covers the type system itself.

## Consequences

- The whole repository's types form one cohesive, committed assembly — a single shared base, layered records, and nested graphs compile
  together and reference each other freely.

- A type file's module identity lives in its folder; the declared `namespace <module>;` is a folder-derived mirror that `Format-Types`
  maintains and `Test-Types` gates. Moving a `.cs` to another module stays a safe refactor — re-run `Format-Types` and the line follows the
  folder (and `Test-Types`/the loader fail loudly if it didn't).

- The editor compiles and analyzes the exact sources the runtime does: with C# Dev Kit enabled, `Catzc.Types.csproj`/`catzc.sln` give real
  in-IDE analysis (no false `CA1050`, no "No solution file") that equals the `Add-Type` compile — the rules live as code, not as a disabled
  analyzer.

- A type can publish a short call-site alias (`[Catzc.Module.Depm]`) by decorating its source, without giving up the trail back to it: the
  alias literal greps to the declaring `.cs`, and the IDE project — built with `Invoke-BuildForVSCode` — makes the C# a navigable
  Go-to-Symbol target.

- The dependency graph is a single source of truth for _both_ function-call and C# type layering. The cost of one combined assembly — the
  compiler does not block a layer inversion — is paid back by the linter, which fails L2 on an undeclared edge.

- Editing any type re-keys and rebuilds the one assembly (a single sub-second `Add-Type` compile, one committed DLL) and requires a session
  restart to pick up — the documented devbox contract.

## Dora explains

DORA research links code maintainability and loosely coupled architecture to faster delivery and fewer defects. This ADR encodes domain
models as native types with fixed shapes, versioned assemblies, and dependency-governed layering, reducing the cognitive load of loose
dictionaries.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — fixed, discoverable type shapes and standardized namespace
  patterns.
- [Loosely coupled teams](https://dora.dev/capabilities/loosely-coupled-teams/) — dependency graph governs cross-module type references and
  enforces layering.
- [Version control](https://dora.dev/capabilities/version-control/) — committed prebuilt assembly; everything-as-code principle enables
  reproducible builds.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
