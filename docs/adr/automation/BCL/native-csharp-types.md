---
catzc:
  immutable:
    with_body_sha: "0fe8fb47f375"
    repo_status: clean
    path: docs/adr/automation/BCL/native-csharp-types.md
    folder: docs/adr/automation/BCL
    name: native-csharp-types
    filetype: md
    kind: adr
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    defines:
      - ADR-AUTO-TYPES#{1-4,7-9,11-15}
    cites:
      - ADR-AUTO-CACHE#8
    links:
      - docs/adr/automation/caching.md#rule-adr-auto-cache8
      - docs/adr/automation/console-output-matters.md#rule-adr-auto-console1
      - docs/adr/automation/controlling-module-dependencies.md
      - docs/adr/flow/pipeline-detection.md#rule-adr-flow-cd-detect1
      - docs/adr/principles/everything-as-code.md
      - docs/adr/principles/poka-yoke.md
      - docs/adr/pwsh/hosting-csharp-types.md
      - docs/adr/repository/conventional-folders.md
---

# ADR: Native C# types — one combined assembly, namespace per module

## Rules: ADR-AUTO-TYPES

### Rule ADR-AUTO-TYPES:1

One type per file, named for the bare type; its fully-qualified name is `<module>.<filename>` (`types/CliRunner.cs` in
`Catzc.Base.Execution` → `Catzc.Base.Execution.CliRunner`). The file declares the **file-scoped namespace of its module**
(`namespace Catzc.Base.Execution;`), which `Format-Types` writes and `Test-Formatting` checks; the loader identifies the type from the
filename, not by parsing the body. The first comment of the file may be a meta head of derived facts, which the loader ignores like any
comment.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-TYPES:2

Every type's namespace equals its owning module and is **declared in the source** as a file-scoped `namespace <module>;` — but it is
**derived from the folder, not hand-authored**: `Format-Types` writes/repairs the line from the file's `types/` folder, so the folder stays
the single source of truth and a move between modules is a safe refactor. The loader and `Test-Formatting` reject a missing, mismatched, or
block-scoped namespace, and the loader rejects a dotted filename. The FQN is `<module>.<filename>`, making FQN collisions across modules
impossible.

- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-TYPES:3

Every module's `types/*.cs` compile together into **one** assembly for the whole repository, so a type in any module can reference a type in
any other — only cross-_namespace_ references inside a single assembly, never cross-_assembly_. The compiler-assigned assembly name is
irrelevant because the assembly is a leaf in the reference graph: nothing references it by assembly identity, and every caller resolves a
type by its fully-qualified name. One runtime compiler builds it, the host's own, with no separate build step.

- [One assembly](#one-assembly)

### Rule ADR-AUTO-TYPES:4

Cross-module type references are allowed but **governed by the module dependency graph**: a deriving/referencing module must declare the
target in `configs/dependencies.yml`. The compiler does not enforce the layering in one combined assembly, so `Get-CSharpTypeDependency`
extracts the C# edges and the `Test-ModuleDependency` quality gate fails its L1 integrity test on an undeclared one. There is **one** shared
`Catzc.Base.Objects.DictionaryRecord`, not a per-module copy.

- [The `DictionaryRecord` base](#the-dictionaryrecord-base)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-TYPES:7

Handle changed-after-load by context — a loaded assembly cannot be swapped in a running process. In a **pipeline** the loader throws (CI
must never run on stale types). On a **devbox** a changed or removed type degrades gracefully — the loader warns in orange that it is using
the old cached types until the session restarts, and keeps the already-loaded types this session, so a dev editing a type mid-session is
never blocked. It returns without recording the new hash, so the warning repeats on every re-import until you restart. A type the loaded
assembly lacks (added since load, or not loaded on behalf of another root) throws on a devbox too: the old types cannot serve code that uses
it, so continuing would only move the failure to a confusing cast error far from the cause. The loader tells a pipeline from a devbox by
asking `Test-IsRunningInPipeline`, like every other caller.

- [The cache-state contract](#the-cache-state-contract)

### Rule ADR-AUTO-TYPES:8

Use snake_case property names **only** on a type that mirrors a YAML config (so the YAML key and the C# property are the same identifier);
every other type — results, CLI state, REST shapes such as `CliResult` / `CliRunner` — keeps default .NET PascalCase. snake_case is a
YAML-interop rule scoped to config-mirroring types, not a repository-wide naming convention.

- [snake_case records](#snake_case-records)

### Rule ADR-AUTO-TYPES:9

The platform's internal fixed model is authored as native C# types — not loose dictionaries or ad-hoc objects. A first-class concept the
platform's own logic **selects on, branches on, or pins as a parameter or return type at a call site** (for example `Module`, `CliResult`)
is a C# type, so its shape is fixed, discoverable, and validated at construction. Loose dictionaries remain right for config-shaped data
crossing a boundary (a parsed `.yml`, a splat) — but the moment the code acts on the shape as a first-class concept, it is a type.

- [A C# model type](#a-c-model-type)

### Rule ADR-AUTO-TYPES:11

The compiled-type cache key is byte-exact but line-ending-insensitive: `Import-CSharpTypes` hashes each `types/*.cs` with the
carriage-return bytes stripped, so a CRLF or an LF working tree (git `core.autocrlf`, an editor's format-on-save, a checkout that rewrites
the file) yields the same `Catzc.Types.<hash>.dll` name on every machine. `.cs` sources are additionally pinned to LF in `.gitattributes` so
a checkout materializes identical bytes in the first place. The carriage-return stripping is duplicated in `Clear-ModuleTypeCache` (the
janitor), the drift-guard tests, and the IDE project's stamp task — keep all of them identical, or the janitor will plan the live build for
deletion.

- [The cache-state contract](#the-cache-state-contract)

### Rule ADR-AUTO-TYPES:12

The stale-types guard — the source changed since it was loaded, so restart — is keyed by `ModulesRoot`. `Import-CSharpTypes` takes the tree
as a parameter, and one session may load more than one tree (the real `automation/` plus the test-fixture trees), so the per-session record
of loaded hash and file snapshot is stored per resolved root. A load from one root therefore never makes a re-import of another root falsely
report a change — without this, a test run (which loads fixture trees) would poison the next real import's guard. The thrown message names
the drifted files and both hashes so the cause is diagnosable from the error text alone.

- [The cache-state contract](#the-cache-state-contract)

### Rule ADR-AUTO-TYPES:13

Who runs the importer decides what its janitors may change outside the session, read from one place: `Get-SessionActor` → `Person`, `Agent`,
or `Pipeline` (a pipeline wins over an agent running in it). No switch overrides it.

| Janitor action                              | Person | Agent                                        | Pipeline                       |
| ------------------------------------------- | ------ | -------------------------------------------- | ------------------------------ |
| Stop processes holding a superseded build   | yes    | no — the stale build is reported             | no — asserts exactly one build |
| Commit the generated `automation/.compiled` | yes    | no — announces what changed, to be committed | no                             |
| Regenerate the gitignored generated files   | yes    | yes                                          | yes                            |

The stale sessions and the repository are the person's: their session may stop the one and commit to the other. An agent leaves both to the
person and says what it left; a pipeline only asserts. A test-run snapshot (`Test-RepositorySnapshot`) is never committed to, whoever runs
it.

- [The cache-state contract](#the-cache-state-contract)

### Rule ADR-AUTO-TYPES:14

Every concrete type a caller can hold renders console-ready: it overrides `ToString()`, normally as the one line
`public override string ToString() => this.ToConsoleString();`, so its string form and a table cell read `TypeName { A = 1, B = x }` instead
of the fully-qualified name. The rendering lives once, in `Catzc.Base.Objects.ConsoleText`, and `DictionaryRecord` carries the override for
every record derived from it. A type names its identity properties with `[Catzc.Base.Objects.ConsoleDisplay(...)]`, which narrows both its
text and its default display at the prompt. `Test-ShippedTypes` fails a type that keeps the inherited `ToString()`.

- [Console-ready rendering](#console-ready-rendering)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-AUTO-TYPES:15

Whether the C# types loaded in a process are current is measured in one place, `Get-LoadedTypeDrift` (`Catzc.Internal.Types`), and asked
through one test/assert pair, `Test-LoadedTypesCurrent` and `Assert-LoadedTypesCurrent` (`Catzc.Base.TypesSystem`). When they are stale, the
importer never starts a nested shell and never waits: the loader's warn-or-throw (ADR-AUTO-TYPES#7) applies to every session. On a devbox
that is one yellow line naming the changed types by simple name, and the import goes on with the loaded types; a pipeline throws.

- [The cache-state contract](#the-cache-state-contract)
- [Stale types in a running process](#stale-types-in-a-running-process)

## Context

Some logic is better expressed as a native .NET type than as script code: a process runner with background reader threads
(`Catzc.Base.Execution.CliRunner`), or a constrained, validated data record that replaces a loose dictionary. The platform autoloads such
types from each module's `types/` folder (see [conventional-folders](../../repository/conventional-folders.md) for where `types/` sits) and
commits the compiled assembly so a fresh checkout and CI load it without invoking Roslyn (see [caching](../caching.md#rule-adr-auto-cache8)
for why committed prebuilds are the one sanctioned cross-session cache).

Compilation produces **one assembly for the whole repository**, so any module's types can reference any other's: a single shared base (a
dictionary-compatible data-record base) and layered records (a record in one module building on a record in another) — the thing static data
classes want most. Compiling one assembly per module would forbid those cross-module references; the cost of the single assembly is that
layering discipline is policed by the dependency checker rather than structurally by the compiler.

### One assembly

`Why one assembly, not one per module`

The blocker for cross-module references under a per-module design is the runtime compiler: it assigns a **random** assembly name, different
on every rebuild of a source that is unchanged, and has no setting for a stable one. A dependent assembly bakes that random name at compile
time and dangles when the base is rebuilt under a new name.

One combined assembly dissolves the problem entirely rather than working around it:

- **No cross-assembly references exist.** Every type is in one assembly; a base in `Catzc.Base.Objects` and a derived record in
  `Catzc.Azure.Templates` are different _namespaces_ in the _same_ assembly, which the compiler and CLR resolve unconditionally.
- **The random name is harmless.** The combined assembly is a leaf in the assembly-reference graph — nothing references it by assembly
  identity, and every caller resolves a type by its fully-qualified name, so the compiler-assigned name is never consulted. The host's own
  compiler therefore stays the compiler, with no separate build step, no topological compile order, and no transitive references.

The cost is that the compiler does not structurally forbid a layer inversion (a base-module type referencing a leaf-module type) — in one
compilation unit that just compiles. That enforcement moves to the linter (see Rule ADR-AUTO-TYPES#4): `Get-CSharpTypeDependency` reports
the cross-module C# edges and the acyclic allow-list in `configs/dependencies.yml` governs them, failing L1 on an undeclared edge.

## Decision

Every module's `types/*.cs` are compiled together into **one** assembly, `automation/.compiled/Catzc.Types.<combinedHash8>.dll`, autoloaded
before any module's functions. Each file is named for the bare type it must produce and declares the file-scoped `namespace <module>;` of
its folder; the loader compiles the sources **as authored**, one compilation unit per file, all landing in the single assembly — so the FQN
is `<module>.<filename>`. Types may reference each other across modules (one assembly); the dependency graph, not the compiler, governs
those edges.

The mechanism is `Import-CSharpTypes` in `automation/.internal/Catzc.Internal.Bootstrap.psm1`, run once as a pre-pass by `Import-AllModules`
before the module loop.

### The host binding

`How the one host compiles, references, and names the types`

The types run inside the process of the one engine that hosts them, pwsh. Which compiler builds the assembly, which assemblies a type may
reference, the short names pwsh callers type, how a running pwsh meets a changed type, and why the console text has to live in C# are that
host's binding, decided in [hosting-csharp-types](../../pwsh/hosting-csharp-types.md). This ADR decides what the types are; that one decides
how the host carries them.

### Declared namespaces and the IDE project

`Why the namespace is declared, and an IDE project alongside`

The namespace is **declared in the source** rather than wrapped in by the loader so the same files are valid, analyzable C# to the editor —
[everything-as-code](../../principles/everything-as-code.md). A file that declares no namespace becomes well-formed only after a loader's
textual wrap, so no `.csproj` can compile the raw sources: VS Code's C# Dev Kit treats them as "miscellaneous files", ignores
`.editorconfig` analyzer severities, and raises a false `CA1050 "Declare types in namespaces"` on every file, plus a "No solution file" nag.
Turning the analyzer off, or disabling Dev Kit, would hide the rule instead of expressing it as code — the opposite of EAC.

Declaring `namespace <module>;` makes each file compile cleanly on its own, so a real IDE project can analyze exactly what the runtime
compiles. The repo ships an **IDE-only** `Catzc.Types.csproj` (under `automation/.internal/assets/`, a `../../**/types/*.cs` glob over every
type source) and a classic root `catzc.sln` (Dev Kit loads a `.sln`, not a `.slnx`; kept at the repo root so the editor auto-loads it, and
it references the project by relative path) that mirror the runtime compile — `Nullable` and `ImplicitUsings` off, .NET 10 — so the editor's
feedback equals the runtime's: real namespaces (no `CA1050`), with two deliberate opt-outs stated in `.editorconfig` — `IDE1006` (snake_case
config-mirroring props, Rule ADR-AUTO-TYPES#8) and `IDE0130` (the namespace mirrors the module, not the project's physical folder path, Rule
ADR-AUTO-TYPES#2). The runtime never builds the project, and `Invoke-BuildForVSCode` builds the IDE project on demand for the editor (see
below). The [poka-yoke](../../principles/poka-yoke.md) is preserved because the namespace is folder-derived by `Format-Types` and checked by
`Test-Formatting`, not a second source of truth, maintained by hand, that could drift.

To keep that IDE artifact honest, the project **stamps its version from the committed `Catzc.Types.<hash>.dll`** — the runtime assembly's
own identity ([ADR-AUTO-CACHE#8](../caching.md#rule-adr-auto-cache8)) — so its build metadata (the `deps.json` project entry) reads
`Catzc.Types/1.0.0-<hash>`, not the accidental default `1.0.0`. It is trust-but-verify: the build recomputes the combined source hash with
the loader's algorithm and **fails when the committed DLL is stale, missing, or ambiguous**, so the editor's project can never present a
version that outruns the sources it claims to describe. That makes the hashing a fourth mirror of the same algorithm (loader,
`Clear-ModuleTypeCache`, the drift-guard tests) that must stay in step.

That editor build is the second of two pathways over the same sources: the host's compiler builds the runtime assembly (Rule
ADR-AUTO-TYPES#3), and `dotnet build` compiles for the editor, which makes every `types/*.cs` a navigable Go-to-Symbol target.
`Invoke-BuildForVSCode` drives the editor half — a `dotnet build` of `Catzc.Types.csproj` — and it doubles as a gate: the project's stamp
task fails when the committed `Catzc.Types.<hash>.dll` is stale versus the sources (ADR-AUTO-CACHE#8), so a green build also proves the IDE
project matches the runtime prebuild. It runs `dotnet` through `Invoke-Executable`, not the Tooling layer's `Invoke-Dotnet`, which a `Base`
module must not depend on.

### The cache-state contract

The assembly is the one committed, cross-session cache of [caching](../caching.md#rule-adr-auto-cache8) (ADR-AUTO-CACHE#8): it is named for
the combined hash of every module's sources and committed to `automation/.compiled/Catzc.Types.<hash>.dll`, so a fresh checkout and CI load
it without Roslyn. The hash material is per file `<module>|<bare type>|SHA-256(content)`, ordered by `<module>/<type>` ordinally, so a move
between modules (new namespace) or a rename (new type) re-keys even when content is byte-identical, with no dependence on the repository
root. Every process loads the assembly from a per-user shadow copy (`Import-TypesAssembly`: `%LOCALAPPDATA%\catzc\types` on Windows,
`~/.local/share/catzc/types` on Unix), never in place, so no session ever locks `automation/.compiled` ([why](#why-a-shadow-copy)).

Because the DLL filename _is_ the combined source hash, there is no "present but stale" state — a source that changes has a different
filename, so the current-hash DLL is simply absent until built. The loader resolves every state:

| current-hash DLL                       | types loaded this session | Outcome                                                                                                                                                                                                                                                                                                                                                 |
| -------------------------------------- | ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| present                                | no                        | **Skip compile, load it.** CI / fresh-checkout hot path (no Roslyn).                                                                                                                                                                                                                                                                                    |
| present                                | yes                       | **No-op.** Types already loaded in the process.                                                                                                                                                                                                                                                                                                         |
| absent (source added/changed/deleted)  | no                        | **Compile** all sources → the hash-named DLL, load, verify every type.                                                                                                                                                                                                                                                                                  |
| absent (DLL deleted, source unchanged) | yes                       | **Recompile via `-OutputAssembly`** (writes without loading) — self-heals the committed artifact; no reload.                                                                                                                                                                                                                                            |
| absent because the source CHANGED      | yes                       | **Devbox, whoever runs: warn (yellow, the changed types by simple name) + keep the old types and go on** this session (ADR-AUTO-TYPES#15) (return, don't record the new hash) — unless a type was added, which throws "restart PowerShell". **Pipeline: throw "restart PowerShell"** — CI must not run on stale types. A loaded copy cannot be swapped. |

A superseded-hash DLL (the old build after a source edit) is pruned by the loader on rebuild and by the post-import janitor
`Clear-ModuleTypeCache` (which deletes on a devbox only; CI makes no source-control changes). Editing any `types/*.cs` re-keys the whole
assembly — one combined hash, one committed DLL, paid once by the editor.

`.compiled` must hold **exactly one** `Catzc.Types.*.dll`. Because every load goes through the shadow copy, a superseded build is always
expected to delete. When a delete still fails, something outside catzc holds the file (an antivirus scan, an indexer, a session started
before shadow loading). `Clear-ModuleTypeCache` then removes every deletable build first and throws one error naming each surviving file
and, on Windows, its holders (`Get-FileLockingProcess`, via the Restart Manager). The importer catches that error into one red line, so the
load completes. `-StopLockingProcesses` on `Clear-ModuleTypeCache` stops each holder, announcing each stop, then retries the delete over a
short window (Windows releases an exited process's mapped image a moment after the exit). It never stops the session asking or any of its
parents. A hand-run `Clear-ModuleTypeCache` stops nothing unless asked, because a stopped process loses its unsaved work; the importer
decides by who is running it (ADR-AUTO-TYPES#13) — a person's import stops the holders, an agent's import and a pipeline never do. The
invariant is guarded at three points:

- **Devbox auto-commit:** `Sync-GeneratedFile` holds `automation/.compiled` back, with one red line naming the surplus DLLs, while
  `Clear-ModuleTypeCache -DryRun` lists anything but the current build. A surviving build never rides along as the +1 without its −1. It
  also holds the build back, with one yellow line, while any `types/*.cs` differs from HEAD: the build is named for the working tree's
  sources, so committing it first would leave HEAD with a build its own sources do not produce.
- **Pipeline:** two `Catzc.Types.*.dll` are a hard `throw` in `Clear-ModuleTypeCache`. CI makes no source-control changes, so two builds
  there were committed; the fix is to run `Clear-ModuleTypeCache` on the devbox and commit the single remaining build.
- **IDE project:** the `Catzc.Types.csproj` stamp task warns when the git index's `.compiled` does not hold exactly the current DLL.

### Stale types in a running process

.NET cannot unload an assembly from a running process, and a second assembly with the same type names would split their identity: a
`[Catzc.…]` literal would resolve to one copy while an object holds the other. So once a type source changes, the process that loaded the
old types keeps them until it ends, and the only remedy is a new process. Stopping other processes does not help: the stale copy is in the
process that asks.

That limit is measured once, so every caller agrees on it. `Get-LoadedTypeDrift` compares the session record of what was loaded with the
sources on disk and names each drifted type; the loader reads it to warn or throw, and `Test-LoadedTypesCurrent` /
`Assert-LoadedTypesCurrent` give the same answer to any code that needs current types, such as a test of a type just edited.

Whether a stale load warns or throws depends on where the process runs, and the loader asks `Test-IsRunningInPipeline`, the one reader of
the pipeline variables ([pipeline-detection](../../flow/pipeline-detection.md#rule-adr-flow-cd-detect1)), like every other caller (Rule
ADR-AUTO-TYPES#7). The detection function is therefore loaded before the types pre-pass runs.

A person who edits a type and imports again keeps the loaded types and gets one yellow line naming the changed types by simple name; the
import goes on and never waits. The importer starts no nested shell: a process cannot replace itself on every platform, and an agent or a
script would block on a nested one. A pipeline must never run on stale types, so it throws.

### Why a shadow copy

Windows locks a loaded file until its process exits, so loading `.compiled` in place lets any live session (a console, the VS Code
PowerShell host, an analyzer process, a test worker) block the prune of a superseded build — and a blocked prune is how a stale build
reached a commit. A byte load (`[Reflection.Assembly]::Load([byte[]])`) avoids the lock but leaves `Assembly.Location` empty, and anything
that later compiles against the types (`Add-Type -ReferencedAssemblies`) needs a real path. A copy keeps `Location` valid and leaves
`.compiled` read-only to every session. The copy is content-addressed (`Catzc.Types.<hash>.dll`), written through a temp file and an atomic
move, shared by every session and clone with the same sources, and pruned once it has gone a day without a load. Nothing there is committed,
so a locked leftover copy is harmless.

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

`Module` is the example: `Get-CatzcModule` returns `[Module]`, `Copy-Automation`, the globset derivation and the folder checks read their
module list off it, and callers type against it — so it is a C# type, not a bag of hashtables that every call site re-interprets. A loose
dictionary here would push the shape into scattered string-keys with no single definition and no construction-time check — the opposite of a
fixed model. Config that _feeds_ the model (the layout in `languages.yml`, the tracks in `variants.yml`) crosses the boundary through its
own config type, `LanguagesConfig` or `VariantsConfig`, which validates it at load; the model `Get-CatzcModule` builds from it is typed too.

### Console-ready rendering

`A catzc object reads as one line`

How an object reads at the console is part of its design ([console-output-matters](../console-output-matters.md#rule-adr-auto-console1)). A
class that keeps `object.ToString()` renders as its fully-qualified name: a message about a subscription context prints
`Catzc.Azure.Cli.SubscriptionContext`, and a collection property shows `{Catzc.Base.Globs.GlobPattern, …}` in a table. The host's string
conversion reads the type's own `ToString()`, so the fix is in C#.

So the rendering is one shared extension method, `ConsoleText.ToConsoleString()`, and each type opts in with a one-line override. The format
is the C# `record` convention a .NET reader already knows, `TypeName { A = 1, B = x }`, on one line: the bare type name, a null property
omitted (the `DictionaryRecord` "present" rule), strings as-is with newlines escaped, numbers invariant, dates ISO 8601, collections capped
at a few items with the rest counted, and a nested object by its own `ToString()`, with nesting capped so a cycle cannot recurse. A type
whose identity is one domain value (a path, a glob pattern, a dependency edge) writes its own `ToString()` instead, since that value reads
better than a property list.

`[ConsoleDisplay("Id", "Name")]` names a type's identity properties once and drives both console surfaces: `ToConsoleString()` renders only
those, and `Import-CSharpTypes` registers them as the type's default display, so an object shown at the prompt shows those columns instead
of every property.

### How this is enforced

- **`Format-Types` + `Test-Formatting`** (in `Catzc.Base.QualityGates`) — `Format-Types` writes/repairs each source's file-scoped
  `namespace <module>;` from its `types/` folder (the formatter, not an ad-hoc sweep); the `Test-Formatting` quality gate runs it in its
  report-only mode, failing on a missing, mismatched, or block-scoped namespace. The folder is the single source of truth, so the namespace
  can never drift from it.

- **`Import-CSharpTypes`** rejects a dotted filename and a source whose declared namespace is missing, mismatched, or block-scoped (the same
  invariant `Test-Formatting` enforces, checked at load), compiles all modules' sources **as authored** into one assembly (one compilation
  unit per file), verifies every `types/*.cs` produced `<module>.<filename>` (else "was not produced"), and registers each
  `[Catzc.Base.Objects.ConsoleDisplay]` property list as the type's default display (Rule ADR-AUTO-TYPES#14).

- **`Get-LoadedTypeDrift`** (in `Catzc.Internal.Types`) is the one measure of stale types; the loader and the `Test-LoadedTypesCurrent` /
  `Assert-LoadedTypesCurrent` pair read it (Rule ADR-AUTO-TYPES#15).

- **`Test-ShippedTypes`** (in `Catzc.Base.TypesSystem`) fails a concrete shipped class that keeps the inherited `ToString()`, naming the
  file and the line to add (Rule ADR-AUTO-TYPES#14); enums, interfaces, abstract and static classes, attributes, and exceptions are exempt.
  `ConsoleText.Tests.ps1` pins the rendering rules.

- **`Invoke-BuildForVSCode`** (in `Catzc.Base.TypesSystem`) drives the editor-facing `dotnet build` of `Catzc.Types.csproj` through
  `Invoke-Executable`, so a dev or CI builds and verifies the IDE project on demand; the project's stamp task fails the build on a stale
  committed DLL, and a `Base` module reaching the Tooling layer's `Invoke-Dotnet` would invert the dependency graph, so it does not.

- **`Get-CSharpTypeDependency` + `Test-ModuleDependency`** — the cross-module C# edges are extracted (a scan that strips comments, string
  literals, and each file's own `namespace <module>;` line, then maps each dotted token to its longest known-module-name prefix) and checked
  against `configs/dependencies.yml` alongside the function-call edges. An undeclared type edge fails L1. `dependencies.yml` supports a
  top-level `groups:` map — a named set of modules with its own internal member→member DAG; an allowed-deps entry may name a GROUP
  (permitting an edge to any member) or a specific MODULE. The `Catzc.Base.*` cluster is held together as the `Base` group.

- **`Import-CSharpTypes.Tests.ps1`** covers the combined compile + cache, intra-module and **cross-module** inheritance, the missing /
  mismatched / block-scoped namespace and dotted-filename throws, the filename-type verification, the changed-after-load fail-fast,
  self-heal of a deleted DLL, the `DictionaryRecord` dictionary view, and a drift guard (the committed `Catzc.Types.<hash>.dll` matches the
  current sources, with no pending git changes). A `shipped C# types` test asserts every committed type resolves **and** declares its module
  namespace (via `Test-Formatting -Language csharp`), and a `PSTypeAlias accelerators` test asserts a decorated type's accelerator resolves
  after load. `Set-CSharpFileScopedNamespace.Tests.ps1` unit-tests the namespace string engine behind `Format-Types`.

- **`Clear-ModuleTypeCache`** keeps the current `automation/.compiled/Catzc.Types.<hash>.dll` and prunes the rest (deleting on a devbox
  only). A delete that fails throws after every deletable build is gone, naming the file and its holders; the importer reports it as one red
  line. In a pipeline it throws when a second `Catzc.Types.*.dll` is committed — a stale committed build must not reach trunk.

- **`Import-TypesAssembly`** (in `.internal/Catzc.Internal.Types.psm1`) is the one load path — the bootstrap and the `SpellOutIdentifiers`
  analyzer rule both load through the shadow copy, so no session holds `.compiled`. `Import-TypesAssembly.Tests.ps1` covers the copy, its
  reuse, the atomic write, the concurrent-copy race, pruning, and `Location` pointing into the shadow root.

- **`Sync-GeneratedFile`** (in `Catzc.Base.ModuleSystem`, the importer's auto-commit) refuses to commit `automation/.compiled` while it
  holds anything but the current build (the `Clear-ModuleTypeCache -DryRun` surplus). It skips with a red line, so a superseded DLL is never
  committed next to the new one, and while a type source differs from HEAD, with a yellow line, so HEAD never holds a build ahead of its
  sources. `Sync-GeneratedFile.Tests.ps1` covers the probes, both hold-backs, and the no-probe case when nothing changed.

## Disambiguation

The module-dependency graph that governs cross-module C# type edges (ADR-AUTO-TYPES#4) is owned by
[controlling-module-dependencies](../controlling-module-dependencies.md) (`ADR-AUTO-DEPM`); this ADR covers the type system itself.

## Consequences

- The whole repository's types form one cohesive, committed assembly — a single shared base, layered records, and nested graphs compile
  together and reference each other freely.

- A type file's module identity lives in its folder; the declared `namespace <module>;` is a folder-derived mirror that `Format-Types`
  maintains and `Test-Formatting` checks. Moving a `.cs` to another module stays a safe refactor — re-run `Format-Types` and the line
  follows the folder (and `Test-Formatting`/the loader fail loudly if it didn't).

- The editor compiles and analyzes exactly the sources the runtime does: with C# Dev Kit enabled, `Catzc.Types.csproj`/`catzc.sln` give real
  in-IDE analysis (no false `CA1050`, no "No solution file") that equals the runtime compile — the rules live as code, not as a disabled
  analyzer.

- The dependency graph is a single source of truth for _both_ function-call and C# type layering. The cost of one combined assembly — the
  compiler does not block a layer inversion — is paid back by the linter, which fails L1 on an undeclared edge.

- Editing any type re-keys and rebuilds the one assembly (a single sub-second compile, one committed DLL) and requires a session restart to
  pick up — the documented devbox contract.
