# ADR: Conventional folders — every folder in the repository, by convention

## Rules: ADR-FOLDERS

### Rule ADR-FOLDERS:1

Every folder in the repository is conventional: its name infers its contents and purpose, for humans and for tooling. No folder needs a
mapping file or a README to be understood — the name is the meaning. At the root this goes further: every root folder names a **track** —
the repository's unit of root concern — so adding a root folder is the decision to open a track (see [tracks](../design/tracks.md), code
`ADR-TRACK`).

- [The thesis: every folder infers its meaning](#the-thesis-every-folder-infers-its-meaning)

### Rule ADR-FOLDERS:2

Two kinds of conventional folder. **Contract** folders have their literal name hardcoded by tooling — a wrong name makes the content
structurally invisible or non-functional. **Semantic** folders carry meaning a reader infers, with a freeform internal layout no tool
depends on. Know which kind a folder is before renaming it or adding to it.

- [Contract folders and semantic folders](#contract-folders-and-semantic-folders)

### Rule ADR-FOLDERS:3

The root set is closed. Adding a top-level directory is a deliberate architectural decision — an amendment to this ADR — not a casual act.

- [Level 1: Repository root](#level-1-repository-root)

### Rule ADR-FOLDERS:4

Dot-prefix means infrastructure/tooling, everywhere — `.github/`, `.vscode/`, `.claude/`, `.git/`, `.sha-markers/`, and
`automation/.internal|.scriptanalyzer|.vendor/`. Under `automation/` it is enforced mechanically by `Import-AllModules` (dot-prefixed
directories are excluded from module discovery); elsewhere it is the same convention applied repo-wide.

- [Level 1: Repository root](#level-1-repository-root)
- [Level 2: `automation/` — modules vs. infrastructure](#level-2-automation--modules-vs-infrastructure)

### Rule ADR-FOLDERS:5

Semantic documentation folders are markdown-only. `docs/` and `docs/notes/**` organize their subfolders freely (the names and casing are the
author's), but they hold only `.md` files.

- [Level 1: Repository root](#level-1-repository-root)

### Rule ADR-FOLDERS:6

Module-internal folder names are fixed. Private helpers go in `private/`, tests in `tests/`, consumable assets in `assets/`, the module's
own internal config in `configs/`, native C# sources in `types/` — never `internal/`, `helpers/`, `test/`, `spec/`, `resources/`, `config/`,
etc. The name is the contract; a different name means tooling will not find the content.

- [Level 3: Module internals](#level-3-module-internals)
- [Violation patterns](#violation-patterns)

### Rule ADR-FOLDERS:7

Tooling hardcodes the conventional names as literal strings, not parameters or configuration: `Join-Path $ModulePath 'private'`, not
`Join-Path $ModulePath $privateFolderName`.

- [Why hardcoding paths is a feature](#why-hardcoding-paths-is-a-feature)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-FOLDERS:8

No module-level override of conventions. A module cannot opt out of the structure or rename a conventional folder; if `private/` means
different things in different modules, tooling cannot rely on it.

- [Why conventional structure matters](#why-conventional-structure-matters)

### Rule ADR-FOLDERS:9

New module-level folders require an ADR amendment. Adding a well-known folder name beyond `private/`, `tests/`, `assets/`, `configs/`,
`types/` is a structural change to the contract all tooling programs against.

- [Level 3: Module internals](#level-3-module-internals)

### Rule ADR-FOLDERS:10

Unknown folders are ignored, not errors. A non-conventional folder is silently skipped by the bootstrap module and test runner; the module
just cannot expect tooling to interact with it.

- [Level 3: Module internals](#level-3-module-internals)

### Rule ADR-FOLDERS:11

Versioned contracts live under the root `contracts/` folder. A contract is a **named boundary** — `contracts/<contract-name>/`, the unit,
exactly as `infrastructure/templates/<name>/` is — and inside it each version is its own folder `v<N>`, where `<N>` is an integer with no
leading zeros (`v1`, `v2`, … `v10`). Declared, live versions start at `v1`; `v0` is reserved for internal/draft use and is never declared as
a live version, and zero-padded forms (`v01`, `v000`) are never used. Each version folder is a self-contained copy of that version —
coexisting versions are deliberate and equally live (see [one-living-version](../principles/one-living-version.md#rule-adr-onelive7)), not
legacy — and carries a checked-in `.gitkeep` so an otherwise-empty version folder stays tracked. What the contracts _are_ — the
external-facing API surface and its contract-testing discipline — is the [api-contracts](api-contracts.md) ADR (code `ADR-CONTRACT`).

- [Level 1: Repository root](#level-1-repository-root)

### Rule ADR-FOLDERS:12

Deployable-unit sha-marker files live under the root `.sha-markers/` folder — one `<globset>.yml` per globset, written only by the owning
tooling and never hand-edited. The dot-prefix marks the folder as tooling-owned state, the same convention as every other dot-prefixed root
(`ADR-FOLDERS:4`), and the dot also sorts the folder to the top of a PR's file view — the changed markers are the first thing a reviewer
sees. What the marker files _are_ — the globset model, the durable-SHA identity, and the registration-only trigger discipline — is the
[durable-sha-globs](../pipelines/durable-sha-globs.md) ADR (code `ADR-GLOBS`).

- [Level 1: Repository root](#level-1-repository-root)

## Context

A mono-repository without a fixed folder structure degenerates into a naming negotiation. Every new module, every new config file, every new
test suite raises the same questions: where does this go? What do I call the folder? Do I need to tell something about it? The answers
depend on who you ask, what existed before, and what the last person did. Over time the layout drifts — one module puts helpers in
`internal/`, another in `helpers/`, a third in `util/`. Tooling cannot program against a layout that changes per module, so configuration
files, path arguments, and environment variables proliferate to bridge the gap.

This platform takes the opposite approach. The folder structure is fixed, semantic, and the same everywhere. Tooling hardcodes the
well-known names directly. There are no path parameters, no configuration files mapping folder names to meanings, and no per-module
overrides. The folder name IS the contract.

### The thesis: every folder infers its meaning

This is the organizing principle of the whole repository, not just of `automation/`: **every folder is conventional.** You can tell what a
folder holds — and what new content belongs in it — from its name alone, without opening a README or consulting a mapping file. The
repository is a tree of names that mean things, top to bottom: the root folders separate concerns, `automation/` separates modules from
infrastructure, and a module's internals separate public from private from tests from assets. The same idea repeats at every depth.

### Contract folders and semantic folders

Conventional folders come in two kinds, and the difference is _who relies on the name_:

- **Contract folders** — a tool hardcodes the literal name and programs against it, so a wrong name makes the content structurally invisible
  or non-functional. `automation/`, `private/`, `tests/`, `configs/`, `types/`, `.vendor/`, `out/`, `pipelines/steps/`, `.sha-markers/`, and
  `infrastructure/templates/<name>/configuration/[<customer>/]` are contract folders.
- **Semantic folders** — a _reader_ infers the meaning; no tool hardcodes the name, and the internal layout is freeform. `docs/`,
  `docs/notes/**`, `infrastructure/modules/`, and the ad-hoc workspaces under `out/` are semantic folders.

Both are conventional — the name infers the meaning either way. The distinction tells you the cost of getting a name wrong: renaming a
contract folder breaks tooling; renaming a semantic folder is harmless. Know which kind you are touching.

### Why conventional structure matters

**Tooling becomes trivial.** When every module puts private functions in `private/`, the bootstrap module can hardcode
`Join-Path $ModulePath 'private'` and be done. No parameter, no config, no "discover the helpers folder" heuristic. `New-DynamicManifest`
does not ask where private functions are — it knows, because the structure is a contract.

**Onboarding is instant.** A new contributor opening any module sees the same layout: root `.ps1` files are public, `private/` is private,
`tests/` is tests, `assets/` is everything else. There is nothing to learn per module. The structure is self-documenting because it is
uniform.

**Violations are obvious.** When a module puts tests in `specs/` instead of `tests/`, the deviation is visible at a glance. More
importantly, `Test-Automation` will not find those tests, because it scans `tests/`. The structure enforces itself — non-conforming content
is invisible to tooling. This is poka-yoke: the wrong thing does not silently work, it visibly does not work.

**Configuration disappears.** Alternative designs require a mapping layer: a `module.yml` that says `helpers_dir: internal`, or a parameter
`-PrivatePath 'helpers'`, or a convention file at the root. Every mapping layer is a source of truth that must stay in sync with the actual
folders. When the folder name IS the meaning, there is no mapping to maintain, no configuration to drift, no abstraction to debug.

### Why hardcoding paths is a feature

The instinct from application development is that hardcoded paths are a smell. In application code, that instinct is correct — you want to
inject dependencies so you can test against fakes. In a mono-repo's internal tooling, the calculus is different:

- **The paths are not external dependencies.** They are internal conventions under our control. Nobody is going to swap in a different
  `private/` folder the way you swap a database connection. The flexibility that injection provides has no consumer.

- **Indirection hides the contract.** If the bootstrap module takes a `$PrivatePath` parameter, every caller must know what to pass. The
  parameter _looks_ like flexibility but in practice every call site passes `'private'`. The parameter adds noise without adding capability.

- **Hardcoded names are greppable.** When tooling hardcodes `'private'`, you can search the codebase for `'private'` and find every place
  that depends on that convention. When the name comes from a variable, you must trace the variable to its source — which is inevitably a
  constant defined somewhere else.

- **The convention is the documentation.** `Join-Path $ModulePath 'tests'` is self-evident. `Join-Path $ModulePath $testFolderName` requires
  you to find where `$testFolderName` is defined and confirm it is `'tests'`.

The codebase does this consistently: `New-DynamicManifest` hardcodes `'private'`, `Test-Automation` hardcodes `'tests'`, `Import-AllModules`
filters on `'^\.'`, `Install-VendorModule` hardcodes `'automation/.vendor'`, and `importer.ps1` hardcodes `'.internal'` and `'.vendor'`.

### Three levels of structure

The repository has three nested levels of conventional structure, each with its own rules:

1. **Repository root** — top-level directories that separate concerns (automation, docs, output, config, CI).
2. **`automation/`** — the module system root, where dot-prefix separates infrastructure from modules.
3. **Module internals** — the layout inside each module, where folder names determine function visibility and content semantics.

Each level is defined below in the Decision section.

## Decision

The repository uses a fixed, semantic folder layout at three levels. Tooling programs directly against these well-known paths. Folder names
are contracts, not suggestions.

### Level 1: Repository root

The root is a closed set of folders, each with a fixed meaning. The **Kind** column marks whether tooling hardcodes the name (_contract_) or
a reader infers it (_semantic_).

| Directory         | Kind     | Meaning                                                                                                                     | Programmed against by                                     |
| ----------------- | -------- | --------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------- |
| `automation/`     | contract | Module system root — all PowerShell modules and infrastructure (Levels 2–3)                                                 | `importer.ps1`, `Test-Automation`, `Install-VendorModule` |
| `docs/`           | semantic | Documentation — `adr/` decision records and `notes/` working notes                                                          | Human consumption; ADR section + file-naming convention   |
| `infrastructure/` | mixed    | Bicep IaC — reusable `modules/` and deployable `templates/<name>/`                                                          | Bicep build/deploy tooling, `Get-BicepTemplates`          |
| `pipelines/`      | contract | Azure DevOps YAML pipelines, per-kind templates, and the runner                                                             | Azure DevOps runner, `Invoke-AdoScript.ps1`               |
| `contracts/`      | contract | External-facing API contracts (versioned) — `<name>/v<N>/`; see [api-contracts](api-contracts.md)                           | Contract tests; contract producers/consumers              |
| `.sha-markers/`   | contract | Deployable-unit sha-marker files — `<globset>.yml`; see [durable-sha-globs](../pipelines/durable-sha-globs.md)              | ADO/GH path filters; `Update-ShaMarker`, `Test-ShaMarker` |
| `out/`            | contract | All output files (gitignored) — see [dedicated-output-directory](dedicated-output-directory.md)                             | Output functions, CI artifacts, cleanup scripts           |
| `.github/`        | contract | GitHub Actions — `workflows/`, actions, templates                                                                           | GitHub Actions runner                                     |
| `.vscode/`        | contract | Managed, generated editor config — every file reproduced on import; see [generated-root-configs](generated-root-configs.md) | VS Code; `Build-RootConfig`                               |
| `.claude/`        | contract | Claude Code project config — `CLAUDE.md`, `CLAUDE.local.md`, `settings.json`                                                | Claude Code                                               |
| `.git/`           | —        | Git's own store. The boundary of _our_ conventions: git owns it, we do not document it.                                     | Git                                                       |

`automation/` is the only root the module system interacts with; its internals are Levels 2–3 below. The rest separate concerns at the repo
level, and each has its own conventional sub-layout:

**`docs/`** holds `adr/` — Architecture Decision Records grouped into the six sections `principles/`, `design/`, `automation/`,
`pipelines/`, `azure/`, and `repository/` (this ADR) — and `notes/`, freeform working notes. Both are **markdown-only**: the subfolders
under `docs/notes/` (`Architecture/`, `hubspoke/`, `systemet/`, …) are author-organized topic buckets whose names and casing are the
author's, but the files are `.md`.

**`infrastructure/`** splits into `modules/` (reusable Bicep modules — flat `*.bicep`, _not_ discovered as templates) and
`templates/<name>/` (deployable units: `main.bicep`, `options.yml`, optional `PrePost.psm1`). A template's
`configuration/[<customer>/]<env>[-<slot>].yml` tree is the resource-group inventory — one config file is one resource group; a config at
the configuration root is the shared platform's, and a subfolder is always a customer key. The folder name is the readable label; the Azure
identity is a separate `short_name`. See [the data model](../azure/data-model.md) and [the naming standard](../azure/naming-standard.md).

**`pipelines/`** is flat: pipelines are named `<type>-<name>.yaml` (`cron`/`ci`/`cd`/`deploy`/`input`) directly in the folder, the runner
`Invoke-AdoScript.ps1` sits at the root, and reusable fragments live in per-kind folders whose names are the include-kind contract —
`steps/`, `jobs/`, `stages/`, `variables/`, `extends/`. See [pipeline-naming-and-placement](../pipelines/pipeline-naming-and-placement.md).

**`contracts/`** holds the repository's **external-facing API contracts** — binding interface definitions used for **contract testing**,
versioned (`v1`, `v2`, …) so external consumers that pin a version keep working as the platform evolves. Each version is a separate, live
contract, not legacy: this is the one place the repo deliberately carries backwards compatibility, because here — unlike the internal code —
external consumers genuinely exist (see [one-living-version](../principles/one-living-version.md#rule-adr-onelive7)). A contract is a
**named boundary** — `contracts/<contract-name>/`, the unit, exactly as `infrastructure/templates/<name>/` is — and inside it each version
is its own folder: `contracts/<contract-name>/v<N>/`, where `<N>` is an integer with no leading zeros (`v1`, `v2`, … `v10`). Declared, live
versions start at `v1`; `v0` is reserved for internal/draft use and is never declared as a live version, and zero-padded forms (`v01`,
`v000`) are never used. Each version folder is a self-contained copy of that version of the contract; coexisting versions are deliberate and
equally live (see [one-living-version](../principles/one-living-version.md#rule-adr-onelive7)), not legacy to be collapsed. Every contract
version folder carries a checked-in `.gitkeep` marker — a committed, dot-prefixed git marker (the `.gitkeep` analogue) that keeps the
directory tracked when otherwise empty and marks it as a conventional contract folder.

**`.sha-markers/`** holds the committed sha-marker files — one `<globset>.yml` per globset, each carrying the set's canonical definition
plus its durable SHA. The files are generated by the owning module's tooling and never hand-edited; ADO pipelines, ADO build-validation
policies, and GH workflows path-filter on these paths and on nothing else. The folder name and the `<globset>.yml` naming are the contract
both vendors' path filters register against. The full model — globsets, the durable-SHA identity, the commit discipline — is the
[durable-sha-globs](../pipelines/durable-sha-globs.md) ADR.

**`out/`** is the single home for all generated and transient files, gitignored except `.gitkeep`. The _root_ is the contract
(`Get-OutputRoot`); the subfolders inside are ad-hoc workspaces with no fixed names. Nothing under `out/` is source. See
[dedicated-output-directory](dedicated-output-directory.md).

**Dot-prefixed roots** (`.github/`, `.vscode/`, `.claude/`, `.git/`, `.sha-markers/`) are infrastructure/tooling — the same convention the
dot-prefix carries inside `automation/` (Level 2): a leading dot means "infrastructure, not content."

The repository _root_ is itself conventional beyond its folders: `importer.ps1` (the entry point), `.editorconfig`, `.gitattributes`,
`.gitignore`, `.mcp.json`, `dotnet-tools.json`, `cspell.yml` (the repo-wide spell-check dictionary), and `LICENSE` each have a fixed,
name-inferred role. (The authored PSScriptAnalyzer config lives under `automation/.internal/assets/`, alongside the IDE-only C# project —
see [native-csharp-types](../automation/BCL/native-csharp-types.md) — not at the root.) Adding a new top-level directory is a conscious
architectural decision — an amendment to this ADR — not a casual act.

### Level 2: `automation/` — modules vs. infrastructure

| Convention             | Meaning                                         | Examples                                                            |
| ---------------------- | ----------------------------------------------- | ------------------------------------------------------------------- |
| Dot-prefixed directory | Infrastructure — invisible to module discovery  | `.internal/`, `.vendor/`, `.scriptanalyzer/`                        |
| Non-dot directory      | Module — auto-discovered by `Import-AllModules` | `Catzc.Base.Asserts/`, `Catzc.Base.Writers/`, `Catzc.Tooling.Core/` |

`Import-AllModules` filters with `$_.Name -notmatch '^\.'`. This is the entire module discovery mechanism: if the folder name starts with a
dot, it is infrastructure; otherwise, it is a module. No registration, no manifest, no list of module names.

**Why dot-prefix:** The dot-prefix convention is borrowed from Unix (dotfiles are hidden by default) and from this repository's own
`.github/` and `.vscode/` patterns. It communicates "infrastructure, not content" at a glance. It also sorts infrastructure to the top of
directory listings, visually separating it from modules.

### Level 3: Module internals

Every module directory follows the same internal layout:

| Directory/Pattern | Meaning                                                                                                           | Programmed against by                                          |
| ----------------- | ----------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------- |
| `*.ps1` (root)    | Public exported functions — file name = function name                                                             | `New-DynamicManifest` (derives `FunctionsToExport`)            |
| `private/`        | Private helper functions — loaded, not exported                                                                   | `New-DynamicManifest` (scans for `NestedModules`)              |
| `tests/`          | Pester test files (`*.Tests.ps1`) plus their fixtures in `tests/assets/`                                          | `Test-Automation` (discovers test paths)                       |
| `assets/`         | Consumable assets the module ships — templates, scripts, schemas (not test fixtures, not the module's own config) | Module functions via `$PSScriptRoot`                           |
| `configs/`        | The module's own internal config (flat kebab-case `.yml`) the module loads to configure itself                    | Module functions via `$PSScriptRoot`                           |
| `types/`          | Native C# sources (`*.cs`) autoloaded as .NET types                                                               | `Import-CSharpTypes` (one combined assembly, loaded at import) |

**`private/`** contains `.ps1` files that follow the same one-function-per-file convention as root files. They are loaded into the module's
session state via `NestedModules` but excluded from `FunctionsToExport`. The folder name `private/` means "non-exported" everywhere, in
every module, without exception.

**`types/`** contains C# source files (`*.cs`) compiled and loaded as .NET types at import time by the bootstrap module's
`Import-CSharpTypes`, before any module's functions. **The filename is the bare type name** the file must produce, and **the file declares a
file-scoped `namespace <module>;`** — derived from its `types/` folder, written and repaired by `Format-Types` and gated by `Test-Types`, so
the fully-qualified type is `<module>.<filename>` (`types/CliRunner.cs` in `Catzc.Base.Execution` → `Catzc.Base.Execution.CliRunner`). The
loader identifies the type from the filename with no source parsing — one type per file (the analogue of one-function-per-file) — and
rejects a dotted filename or a missing, mismatched, or block-scoped namespace. Every module's sources compile together into **one**
committed assembly for the whole repository, `automation/.compiled/Catzc.Types.<hash>.dll` (vendored, hash-keyed, like `.vendor/`), so a
fresh checkout and CI load it without invoking Roslyn. A module with no native types has no `types/` folder. The full contract — the single
combined assembly, `namespace = module`, the cross-module references governed by the dependency graph, the cache-state behaviour, the
fail-fast on edit, and the one shared `DictionaryRecord` data-record base — lives in its own ADR,
[native-csharp-types](../automation/BCL/native-csharp-types.md).

**`tests/`** contains `*.Tests.ps1` files. `Test-Automation` scans `Join-Path $moduleDir 'tests'` for every module. Tests go here and
nowhere else. A test file outside `tests/` will not be discovered. Test-only fixtures — the inputs a test owns (fixture templates, identity
configs, golden files, sample CSV/JSON/YAML) — live in `tests/assets/`, packaged with the tests that consume them rather than mixed into the
module's shipped `assets/`. Tests reference them relative to `$PSScriptRoot` (e.g. `Join-Path $PSScriptRoot 'assets/<fixture>'`, since
`$PSScriptRoot` is the `tests/` folder). The internal layout under `tests/assets/` is freeform. One constraint: no fixture may be named
`*.Tests.ps1` — `Test-Automation` recurses the whole `tests/` tree, so a fixture with that suffix would be collected and run as a test. The
shipped, runtime-consumable assets stay in `assets/`; test fixtures never do.

**`tests/types/`** holds the tests for a module's native C# types (`types/*.cs`). A type test is named for its type
(`<TypeName>.Tests.ps1`), not `Verb-Noun.Tests.ps1` — a type has no verb — so it lives in this dedicated sub-folder instead of directly
under `tests/`, where the `Verb-Noun` rule applies. Because `Test-Automation` recurses the whole `tests/` tree, these tests still run,
format, and lint like any other; its convention check additionally requires every file here to name a real `types/*.cs` in the same module,
so the folder cannot collect a mislocated or misnamed test.

**`assets/`** is for consumable assets the module ships at runtime that are not a function, a test, or the module's own config: vendored
scripts, templates, JSON schemas, reference data, embedded resources. Test-only fixtures do **not** belong here — they live in
`tests/assets/`, packaged with the tests that use them. The bootstrap module does not scan this folder. `New-DynamicManifest` does not look
here. `Test-Automation` does not look here. The one-function-per-file validator does not look here. Module functions reference assets via
`$PSScriptRoot` (e.g., `Join-Path $PSScriptRoot 'assets/template.bicep'`, or `Join-Path $PSScriptRoot '../assets/template.bicep'` from
`private/`). Module authors may create subdirectories inside `assets/` to organize content — the internal structure is freeform. The
module's own configuration does **not** belong here; it lives in `configs/`.

**`configs/`** holds the module's own internal configuration — the checked-in YAML a module loads to configure its own behaviour. Each entry
is a flat, kebab-case `.yml` file (`<kebab-name>.yml`, never `.yaml`); the folder is flat, with no subdirectories. Module functions read
these files via `$PSScriptRoot` (e.g., `Join-Path $PSScriptRoot 'configs/tools.yml'` resolving to
`automation/Catzc.Tooling.Core/configs/tools.yml`, or `Join-Path $PSScriptRoot '../configs/tools.yml'` from `private/`). A module's own
config goes in `configs/`, and `assets/` is reserved for templates, scripts, schemas, fixtures, and other consumable assets. Live examples:
`Catzc.Tooling.Core/configs/tools.yml`, `Catzc.Base.ModuleSystem/configs/dependencies.yml`,
`Catzc.Azure.DevOps/configs/{ado,pipeline-env}.yml`, `Catzc.Azure.Templates/configs/{azure,network}.yml`. This is enforced by
`Test-FolderConventions.Tests.ps1`, which allows `configs/` as a module subdirectory, requires every entry to be a flat kebab-case `.yml`
file, and fails any module that still keeps an `assets/config/` directory. Files in `configs/` are read through the shared
`Get-Config -Config <name>` reader rather than bespoke per-reader loaders — see
[module-config-loading](../automation/module-config-loading.md).

Not every module needs every folder. A module with no private helpers has no `private/`. A module with no assets has no `assets/`, and a
module that loads no internal config has no `configs/`. The convention defines what the name means when the folder exists, not that every
folder must exist.

### Violation patterns

| Pattern                                                             | Problem                                                                                              | Fix                                                |
| ------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | -------------------------------------------------- |
| Private helpers in `internal/`, `helpers/`, or `util/`              | Bootstrap does not scan these — functions are invisible                                              | Rename to `private/`                               |
| Tests in `test/`, `spec/`, or the module root                       | Test runner does not find them — they never execute                                                  | Move to `tests/` with `*.Tests.ps1` naming         |
| The module's own config in the module root alongside `.ps1` files   | Config files could collide with function naming; unclear boundaries                                  | Move to `configs/` as a kebab-case `.yml`          |
| Standalone scripts in the module root                               | Bootstrap treats them as public functions                                                            | Move to `assets/`                                  |
| Using `config/` or `scripts/` as module subdirectories              | Not a conventional folder — tooling ignores them, convention test fails                              | Module config → `configs/`; scripts → `assets/`    |
| The module's own config under `assets/config/` or bare in `assets/` | Internal config belongs in `configs/`, not `assets/`; the convention test fails on `assets/config/`  | Move to `configs/` as a flat kebab-case `.yml`     |
| Test fixtures under `assets/test/`                                  | Fixtures and the tests that use them drift apart; the convention test fails on `assets/test/`        | Move to `tests/assets/` (packaged with the tests)  |
| A non-dot folder under `automation/` that is not a module           | `Import-AllModules` discovers it and tries to build a manifest                                       | Dot-prefix it (infrastructure) or make it a module |
| A dot-prefixed module that should be discovered                     | `Import-AllModules` skips it — module is invisible                                                   | Remove the dot prefix                              |
| Passing `-PrivatePath` or similar parameters to Bootstrap           | Adds indirection; the path is always `'private'`                                                     | Hardcode the name; remove the parameter            |
| A `module.yml` mapping folder names to meanings                     | Second source of truth that drifts from the actual structure                                         | Remove the mapping; use the convention directly    |
| Putting output files in `assets/`                                   | Mixes transient output with source — see [dedicated-output-directory](dedicated-output-directory.md) | Write to `out/`                                    |

### How this is enforced

- **`New-DynamicManifest`** — hardcodes `private/` when scanning for non-exported functions. Files not in `private/` or the module root are
  not included in the manifest. A file in `helpers/` is structurally invisible.

- **`Import-AllModules`** — hardcodes the dot-prefix filter (`$_.Name -notmatch '^\.'`). Dot-prefixed folders are infrastructure. Non-dot
  folders are modules. No configuration.

- **`Test-Automation`** — hardcodes `tests/` when discovering test paths. Test files outside `tests/` are never executed.

- **`Test-Automation.Tests.ps1`** — validates that every `.ps1` file in a module follows the one-function-per-file convention. It scans only
  the module root and `private/` — files in `assets/` or other folders are not subject to this validation.

- **`importer.ps1`** — hardcodes `automation/`, `.internal/`, and `.vendor/`. These are the bootstrapping paths. They do not come from
  configuration.

- **`Test-FolderConventions.Tests.ps1`** — enforces the module-internal layout: every module subdirectory must be one of `private/`,
  `tests/`, `assets/`, `configs/`, or `types/`; every entry in `configs/` must be a flat, kebab-case `.yml` file (no subdirectories, never
  `.yaml`); no module may have an `assets/config/` directory; and no module may have an `assets/test/` directory — test fixtures live in
  `tests/assets/`.

- **Repo-wide conventions** — the closed root set (`ADR-FOLDERS:3`), the dot-prefixed roots (`ADR-FOLDERS:4`), the markdown-only rule for
  `docs/` (`ADR-FOLDERS:5`), and the `contracts/` versioned-contract layout with its `.gitkeep` marker (`ADR-FOLDERS:11`) — are enforced by
  **code review** against this ADR; the deep `automation/` conventions above are additionally enforced mechanically by the tooling listed
  here. The `.sha-markers/` layout (`ADR-FOLDERS:12`) is enforced mechanically: the marker-freshness integrity gate fails on a stale,
  missing, or orphaned marker file.

- **Code review.** Structural conventions that tooling cannot enforce (e.g., "this YAML file belongs in `configs/`, not the module root")
  are caught in review. The uniform structure makes deviations visually obvious.

## Consequences

- One place to learn what any folder means and where new content belongs — for the whole repository, not just `automation/`. No per-folder
  README, no mapping file.
- The contract/semantic distinction tells a contributor whether a folder name is load-bearing (renaming it breaks tooling) or a free label
  (renaming it is harmless).
- The folder structure is self-documenting. Opening any module reveals the same layout. `private/` is private, `tests/` is tests, `assets/`
  is everything else — no per-module learning curve.
- Tooling is simple and stable. The bootstrap module, test runner, and importer have no configuration for folder names. They hardcode the
  names, and the names do not change.
- New modules are created by copying the folder layout. There is no registration, no configuration file to update, no "folder structure"
  section in a setup guide. The layout is the same everywhere because the names are the same everywhere.
- Adding a new conventional folder is a deliberate, documented decision. It changes the contract, so it goes through an ADR amendment.
- Non-conforming content is structurally invisible, not an error. A module with helpers in `internal/` does not crash the bootstrap module —
  it just has no private functions. This is poka-yoke: the wrong name does not cause a confusing failure, it causes a predictable absence
  that is easy to diagnose.
- The tradeoff is rigidity. You cannot call the test folder `spec/` because you prefer RSpec conventions. You cannot call the private folder
  `internal/` because Go uses that name. The platform's consistency is worth more than individual naming preferences.
