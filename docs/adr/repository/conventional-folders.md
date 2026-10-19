# ADR: Conventional folders — every folder in the repository, by convention

## Rules: ADR-REPO-FOLDERS

### Rule ADR-REPO-FOLDERS-EVERYFOLDERCONVENTIONAL

Every folder in the repository is conventional: its name infers its contents and purpose, for humans and for tooling. No folder needs a
mapping file or a README to be understood — the name is the meaning. At the root this goes further: every root folder git tracks a file
under names a **track** — the repository's unit of root concern — except `out/`, which holds gitignored output (`ADR-REPO-OUTDIR`); so
adding a root folder is the decision to open a track (see [tracks](../design/tracks.md), code `ADR-DSGN-TRACK`).

- [The thesis](#the-thesis)

### Rule ADR-REPO-FOLDERS-TWOKINDS

Two kinds of conventional folder. **Contract** folders have their literal name hardcoded by tooling — a wrong name makes the content
structurally invisible or non-functional. **Semantic** folders carry meaning a reader infers, with a freeform internal layout no tool
depends on. Know which kind a folder is before renaming it or adding to it.

- [Contract folders and semantic folders](#contract-folders-and-semantic-folders)

### Rule ADR-REPO-FOLDERS-CLOSEDROOTSET

The root set is closed. Adding a top-level directory is a deliberate architectural decision — an amendment to this ADR — not a casual act.
`go/`, `python/`, and `bash/`, the roots of the repository's black-box tests, are such amendments.

- [Level 1: Repository root](#level-1-repository-root)

### Rule ADR-REPO-FOLDERS-DOTMEANSTOOLING

Dot-prefix means infrastructure/tooling, everywhere — `.github/`, `.vscode/`, `.claude/`, `.cspell/`, `.git/`, `.go/` (the default Go root
when the repository has no `go/` folder), and `pwsh/.internal|.scriptanalyzer|.vendor|.compiled/`. Under `pwsh/` it is enforced mechanically
by `Import-AllModules` (dot-prefixed directories are excluded from module discovery); elsewhere it is the same convention applied repo-wide.

- [Level 1: Repository root](#level-1-repository-root)
- [Level 2: `pwsh/`](#level-2-pwsh)

### Rule ADR-REPO-FOLDERS-DOCUMENTATIONMARKDOWNONLY

Documentation folders are markdown-only. `docs/` organizes its subfolders freely (the names and casing are the author's), but it holds only
`.md` files — except the dot-prefixed `.assets/` folders, which hold the diagrams the markdown embeds. An `.assets/` folder sits beside the
pages that embed its diagrams and holds one folder per diagram, `<page-folder>/.assets/<name>/`, whose name is the diagram's only name. The
folder holds everything the diagram owns under role names: the slide `diagram.drawio.png`, its description `diagram.drawio.md` (what it
draws in words), the minimaps `grid.png`, `tree.png` and `chain.png` each beside its own `.md` naming why every lit cell is lit, and a
`diagram.drawio.verify.md` record where the diagram has one (each drawn claim, the `file:line` that backs it, and its status). Each
subfolder of `docs/adr/` is an ADR **domain**: a group of ADRs that `adrs.yml` declares with its role and the domains it depends on.

- [Level 1: Repository root](#level-1-repository-root)

### Rule ADR-REPO-FOLDERS-FIXEDMODULEFOLDERS

Module-internal folder names are fixed. Private helpers go in `private/`, tests in `tests/`, consumable assets in `assets/`, the module's
own internal config in `configs/`, native C# sources in `types/` — never `internal/`, `helpers/`, `test/`, `spec/`, `resources/`, `config/`,
etc. The name is the contract; a different name means tooling will not find the content.

- [Level 3: Module internals](#level-3-module-internals)
- [Violation patterns](#violation-patterns)

### Rule ADR-REPO-FOLDERS-LITERALNAMES

Tooling hardcodes the conventional names as literal strings, not parameters or configuration: `Join-Path $ModulePath 'private'`, not
`Join-Path $ModulePath $privateFolderName`. One exception: the root of every test language is a setting, by one convention. Its conventional
names are the setting's sensible defaults — `<language>/` when the repository has that folder, else the dot-prefixed `.<language>/` —
declared once on the language's config type, and one resolver returns the root, which every caller uses. The Go root (`go.yml`'s `root`,
`GoConfig.ResolveRoot`), the Python root (`python.yml`'s `root`, `PythonConfig.ResolveRoot`) and the Bash root (`bash.yml`'s `root`,
`BashConfig.ResolveRoot`) follow it.

- [Hardcoded paths](#hardcoded-paths)
- [A test-language root as a setting](#a-test-language-root-as-a-setting)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-REPO-FOLDERS-NOMODULEOVERRIDE

No module-level override of conventions. A module cannot opt out of the structure or rename a conventional folder; if `private/` means
different things in different modules, tooling cannot rely on it.

- [Why convention](#why-convention)

### Rule ADR-REPO-FOLDERS-NEWFOLDERNEEDSADR

New module-level folders require an ADR amendment. Adding a well-known folder name beyond `private/`, `tests/`, `assets/`, `configs/`,
`types/` is a structural change to the contract all tooling programs against.

- [Level 3: Module internals](#level-3-module-internals)

### Rule ADR-REPO-FOLDERS-UNKNOWNFOLDERSIGNORED

Unknown folders are ignored, not errors. A non-conventional folder is silently skipped by the bootstrap module and test runner; the module
just cannot expect tooling to interact with it.

- [Level 3: Module internals](#level-3-module-internals)

### Rule ADR-REPO-FOLDERS-CONTRACTSFOLDER

Contracts live under the root `contracts/` folder, laid out as `contracts/<unit>/<version>/<module>/<path>`: `<unit>` is the deployable-unit
that carries the contracts (`catzc`, the bundle, [ADR-REPO-CONTRACT-LAYOUT](api-contracts.md#rule-adr-repo-contract-layout)), `<version>` is
that unit's version (`MAJOR.MINOR.PATCH`), `<module>` is the owning catzc module, and `<path>` is the path of the real file a contract asset
constrains, relative to the owning module's target root — the repository root unless `contracts.yml` declares another folder
([ADR-REPO-CONTRACT-LAYOUT](api-contracts.md#rule-adr-repo-contract-layout)) — and no folder under `contracts/` is dot-prefixed
([ADR-REPO-CONTRACT-NODOTFOLDERS](api-contracts.md#rule-adr-repo-contract-nodotfolders)). There is no repository-wide version folder. Each
unit's `0.0.0` is its one mutable draft, frozen only when that unit is released; every other version folder is frozen, a self-contained
snapshot of that unit's contracts at that version — kept for a consumer that pins it, deliberately and equally live (see
[one-living-version](../principles/one-living-version.md#rule-adr-prin-onelive-pinnedversionnotlegacy)), not legacy. The root carries a
checked-in `.gitkeep`, so it stays tracked before any contract exists. What the contracts _are_ — the binding interfaces at the repository
boundary, in both directions, and their testing discipline — is the [api-contracts](api-contracts.md) ADR (code `ADR-REPO-CONTRACT`).

- [Level 1: Repository root](#level-1-repository-root)

### Rule ADR-REPO-FOLDERS-STABLEFILENAMES

A file name is a **stable locator**: it never encodes an order, a rank or a priority. Sorting is an overlay, an index or a head key, never a
prefix, and the delivered default sort of any folder is the semantic name order. There is no exception: an execution order, such as the
order of the plans folder's task files ([ADR-REPO-PLANS-MASTERANDTASKS](plans.md#rule-adr-repo-plans-masterandtasks)), is carried by the
list that orders them.

- [Stable locators](#stable-locators)

## Context

A mono-repository without a fixed folder structure degenerates into a naming negotiation. Every new module, every new config file, every new
test file raises the same questions: where does this go? What do I call the folder? Do I need to tell something about it? The answers depend
on who you ask, what existed before, and what the last person did. Over time the layout drifts — one module puts helpers in `internal/`,
another in `helpers/`, a third in `util/`. Tooling cannot program against a layout that changes per module, so configuration files, path
arguments, and environment variables proliferate to bridge the gap.

This platform takes the opposite approach. The folder structure is fixed, semantic, and the same everywhere. Tooling hardcodes the
well-known names directly. There are no path parameters, no configuration files mapping folder names to meanings, and no per-module
overrides. The folder name IS the contract.

### The thesis

`The thesis: every folder infers its meaning`

This is the organizing principle of the whole repository, not just of `pwsh/`: **every folder is conventional.** You can tell what a folder
holds — and what new content belongs in it — from its name alone, without opening a README or consulting a mapping file. The repository is a
tree of names that mean things, top to bottom: the root folders separate concerns (each a track, except the gitignored `out/`), `pwsh/`
separates modules from infrastructure, and a module's internals separate public from private from tests from assets. The same idea repeats
at every depth.

### Contract folders and semantic folders

Conventional folders come in two kinds, and the difference is _who relies on the name_:

- **Contract folders** — a tool hardcodes the literal name and programs against it, so a wrong name makes the content structurally invisible
  or non-functional. `pwsh/`, `private/`, `tests/`, `configs/`, `types/`, `.vendor/`, `out/`, `go/`, `python/`, `ado/steps/`,
  `docs/adr/`, `docs/references/`, and `infrastructure/templates/<name>/configuration/[<customer>/]` are contract folders.
- **Semantic folders** — a _reader_ infers the meaning; no tool hardcodes the name, and the internal layout is freeform. The topic
  subfolders of `docs/`, `docs/how-to/`, `infrastructure/modules/`, and the ad-hoc workspaces under `out/` are semantic folders.

Both are conventional — the name infers the meaning either way. The distinction tells you the cost of getting a name wrong: renaming a
contract folder breaks tooling; renaming a semantic folder is harmless. Know which kind you are touching.

### Why convention

`Why conventional structure matters`

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

### Hardcoded paths

`Why hardcoding paths is a feature`

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
filters on `'^\.'`, `Install-VendorModule` hardcodes `'pwsh/.vendor'`, and the importer (`importer.ps1` and its `Invoke-Importer` overlay)
hardcodes `'.internal'` and `'.vendor'`.

### A test-language root as a setting

The arguments above hold for names catzc invents. A test language's root is different: it is where another ecosystem's code lives, and
repositories disagree on where that is. Go repositories put Go code under a `go/` root when Go is one language among several, and keep it
out of the way under a dot folder when Go is a guest; Python and the languages after it face the same choice. Both places are reasonable,
and an editor must handle either. Hardcoding one would force the other repositories to move their code, and deciding it language by language
would give every test language its own rule. So there is one convention for all of them.

The root of every test language is a setting, held to three conditions that keep what hardcoding gives:

- **The conventional names are the defaults, the same for every language.** `<language>/` when the repository has that folder (a root
  track), else `.<language>/` (a dot-prefixed tooling folder). They are declared once, on the language's config type
  ([sensible-defaults](../automation/sensible-defaults.md)), so a repository that declares nothing gets a conventional name.
- **One resolver.** Every caller asks the same function for the root, so the setting is greppable through that one name, just as a hardcoded
  literal is.
- **Only the track root.** The folders inside the root (`tests/<module>/`) stay hardcoded.

Three test languages follow it: Go (`go.yml`'s `root`, the defaults `go/` and `.go/`, `GoConfig.ResolveRoot`), Python (`python.yml`'s
`root`, the defaults `python/` and `.python/`, `PythonConfig.ResolveRoot`), and Bash (`bash.yml`'s `root`, the defaults `bash/` and
`.bash/`, `BashConfig.ResolveRoot`).

### Three levels of structure

The repository has three nested levels of conventional structure, each with its own rules:

1. **Repository root** — top-level directories that separate concerns (automation, docs, output, config, CI).
2. **`pwsh/`** — the module system root, where dot-prefix separates infrastructure from modules.
3. **Module internals** — the layout inside each module, where folder names determine function visibility and content semantics.

Each level is defined below in the Decision section.

## Decision

The repository uses a fixed, semantic folder layout at three levels. Tooling programs directly against these well-known paths. Folder names
are contracts, not suggestions.

### Level 1: Repository root

The root is a closed set of folders, each with a fixed meaning. The **Kind** column marks whether tooling hardcodes the name (_contract_) or
a reader infers it (_semantic_).

| Directory         | Kind     | Meaning                                                                                                                                                                | Programmed against by                                               |
| ----------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| `pwsh/`           | contract | Module system root — all PowerShell modules and infrastructure (Levels 2–3)                                                                                            | `importer.ps1`, `Test-Automation`, `Install-VendorModule`           |
| `docs/`           | mixed    | Documentation — `adr/` decision records, `references/` reference articles, `how-to/` guides, `explanation/` articles, `.assets/` diagrams                              | `Build-AdrIndex`, `Build-Readme`; human consumption                 |
| `infrastructure/` | mixed    | Bicep IaC — reusable `modules/` and deployable `templates/<name>/`                                                                                                     | Bicep build/deploy tooling, `Get-BicepTemplates`                    |
| `ado/`      | contract | Azure DevOps YAML ado, per-kind templates, and the runner                                                                                                        | Azure DevOps runner, `Invoke-AdoScript.ps1`                         |
| `contracts/`      | contract | Binding contracts at the repository boundary, both directions — `<unit>/<version>/<module>/<path>`; see [api-contracts](api-contracts.md)                              | The owning modules' contract tests; outside consumers and platforms |
| `go/`             | contract | The Go root: black-box Go tests, `tests/<module>/`; see [go-test-artifacts](../automation/go/go-test-artifacts.md)                                                     | `GoConfig`, `New-GoWorkspace`, `Invoke-GoTest`                      |
| `python/`         | contract | The Python root: black-box Python tests, `tests/<module>/`, and the generated test project; see [python-test-artifacts](../automation/python/python-test-artifacts.md) | `PythonConfig`, `New-PythonProject`, `Invoke-PythonTest`            |
| `bash/`           | contract | The Bash root: black-box Bash tests, `tests/<module>/`, and the vendored bats runner; see [bash-test-artifacts](../automation/bash/bash-test-artifacts.md)             | `BashConfig`, `Invoke-BashTest`                                     |
| `out/`            | contract | All output files (gitignored) — see [dedicated-output-directory](dedicated-output-directory.md)                                                                        | Output functions, CI artifacts, cleanup scripts                     |
| `.github/`        | contract | GitHub Actions — `workflows/`, actions, templates                                                                                                                      | GitHub Actions runner                                               |
| `.vscode/`        | contract | Managed, generated editor config — every file reproduced on import; see [generated-root-configs](generated-root-configs.md)                                            | VS Code; `Build-RootConfig`                                         |
| `.claude/`        | contract | Claude Code project config — `CLAUDE.md`, `settings.json`, the `agents/`, `hooks/`, and `drawio/` folders                                                              | Claude Code                                                         |
| `.cspell/`        | contract | Generated cspell dictionaries — one `<category>.txt` per `terminology.yml` category; only `.gitkeep` is committed                                                      | `cspell.yml`; `Build-TerminologyDictionary`                         |
| `.go/`            | contract | The Go root when the repository has no `go/` folder — the same layout as `go/`, dot-prefixed as tooling                                                                | `GoConfig`, `New-GoWorkspace`, `Invoke-GoTest`                      |
| `.python/`        | contract | The Python root when the repository has no `python/` folder — the same layout as `python/`, dot-prefixed as tooling                                                    | `PythonConfig`, `New-PythonProject`, `Invoke-PythonTest`            |
| `.bash/`          | contract | The Bash root when the repository has no `bash/` folder — the same layout as `bash/`, dot-prefixed as tooling                                                          | `BashConfig`, `Invoke-BashTest`                                     |
| `.git/`           | —        | Git's own store. The boundary of _our_ conventions: git owns it, we do not document it.                                                                                | Git                                                                 |

`pwsh/` is the only root the module system interacts with; its internals are Levels 2–3 below. The rest separate concerns at the repo level,
and each has its own conventional sub-layout:

**`docs/`** holds five folders. `adr/` is the Architecture Decision Records, one subfolder per domain declared in
`pwsh/Catzc.Base.Docs/configs/adrs.yml`: `thesis/`, `principles/`, `process/`, `design/`, `flow/`, `automation/`, `pwsh/`, `configuration/`,
`ado/`, `github/`, `azure/`, `repository/` (this ADR), and `research/`. Its `index.md` is generated from that registry and describes
each domain, so the registry — not this paragraph — is the authoritative list of domains. `references/` holds the authored reference
articles, including the sources the generated READMEs are copied from ([generated-readmes](generated-readmes.md)) and the DORA research
reference under `references/dora/`. `how-to/` holds task-oriented guides. `explanation/` holds the explanation articles: each narrates one
diagram of how cats works and why, in a subfolder per ADR domain. These four are **markdown-only**; their subfolders are author-organized
topic buckets. The dot-prefixed `.assets/` holds the binary diagram assets (`*.drawio.png`) the markdown embeds — the one non-markdown
content under `docs/`, set apart by the dot-prefix convention (ADR-REPO-FOLDERS-DOTMEANSTOOLING). A diagram is one folder in the `.assets/`
beside the page that embeds it, so moving the diagram moves the folder and the page finds it by locality. The folder holds the diagram's
companions under role names: its description, so its words travel with the slide; its verify record, so every drawn claim stays checkable
against the code; and its minimap images, each with a sister `.md` that gives the reason for every lit cell.

**`infrastructure/`** splits into `modules/` (reusable Bicep modules — flat `*.bicep`, _not_ discovered as templates) and
`templates/<name>/` (deployable units: `main.bicep`, `options.yml`, optional `PrePost.psm1`). A template's
`configuration/[<customer>/]<env>[-<slot>].yml` tree is the resource-group inventory — one config file is one resource group; a config at
the configuration root is the shared platform's, and a subfolder is always a customer key. The folder name is the readable label; the Azure
identity is a separate `short_name`. See [the data model](../azure/azure-data-model.md) and
[the naming standard](../azure/azure-naming-standard.md).

**`ado/`** is flat: ado are named `<type>-<name>.yaml` (`cron`/`ci`/`cd`/`cde`/`deploy`/`input`) directly in the folder, the
runner `Invoke-AdoScript.ps1` sits at the root, and reusable fragments live in per-kind folders whose names are the include-kind contract —
`steps/`, `jobs/`, `stages/`, `variables/`, `extends/`. See [pipeline-naming-and-placement](../ado/pipeline-naming-and-placement.md).

**`contracts/`** holds the repository's contracts — the binding interfaces at its boundary, proven by tests, in both directions: provided
(what an outside consumer may rely on) and depended-on (what an outside platform, such as GitHub or Azure DevOps, expects of our files and
calls). It has four levels. The first is the unit: `contracts/<unit>/`, the deployable-unit that carries the contracts — `catzc`, the
bundle, the one unit a consumer pins; another unit that carries contracts gets its own folder beside it. The second is that unit's version:
`contracts/<unit>/<version>/`, where the unit's `0.0.0` is its one mutable draft, frozen only when that unit is released, and every other
version folder is frozen; there is no repository-wide version. The third is the owning catzc module: `contracts/<unit>/<version>/<module>/`,
the module that talks to the outside party and holds the tests. The fourth repeats the real file's repository-relative path, so a contract
asset and the file it constrains are found from each other without a mapping. Provided and depended-on contracts both version with their
unit. A frozen version folder kept for a consumer that pins it is a separate, live set of contracts, not legacy: this is the one place the
repo deliberately carries backwards compatibility, because here — unlike the internal code — external consumers genuinely exist (see
[one-living-version](../principles/one-living-version.md#rule-adr-prin-onelive-pinnedversionnotlegacy)). The root carries a checked-in
`.gitkeep`, so it stays tracked before any contract exists.

**`go/`** is the Go root: the repository's Go code, which is black-box tests of the engine and never ships
([go-test-artifacts](../automation/go/go-test-artifacts.md)). It holds `tests/<module>/`, one Go test module per catzc module, named for
that module in kebab case; `go.work` sits at the repository root, beside it. Every file Go needs besides the `*_test.go` files is generated
and gitignored. A repository with no `go/` folder keeps the same layout under the dot-prefixed `.go/`, and `go.yml`'s `root` places the Go
root elsewhere when declared; the two names are the sensible defaults of that one setting
([sensible-defaults](../automation/sensible-defaults.md)), and the code that reads them is `GoConfig.ResolveRoot`.

**`python/`** is the Python root: the repository's Python tests, which are black-box tests of the engine and never ship
([python-test-artifacts](../automation/python/python-test-artifacts.md)). It holds `tests/<module>/`, one Python test folder per catzc
module, named for that module in kebab case, and the generated uv workspace — the root `pyproject.toml`, one member `pyproject.toml` per
test folder, and the one environment and lock uv makes from them — all gitignored. A repository with no `python/` folder keeps the same
layout under the dot-prefixed `.python/`, and `python.yml`'s `root` places the Python root elsewhere when declared, by the convention every
test-language root follows ([rule 7](#rule-adr-repo-folders-literalnames)); the code that reads it is `PythonConfig.ResolveRoot`.

**`bash/`** is the Bash root: the repository's Bash tests, which are black-box tests of the engine through `importer.sh` and `cats`, and
never ship ([bash-test-artifacts](../automation/bash/bash-test-artifacts.md)). It holds `tests/<module>/`, one Bash test folder per catzc
module, named for that module in kebab case, and the vendored bats-core runner under `.vendor/bats-core/`, committed. A repository with no
`bash/` folder keeps the same layout under the dot-prefixed `.bash/`, and `bash.yml`'s `root` places the Bash root elsewhere when declared,
by the convention every test-language root follows ([rule 7](#rule-adr-repo-folders-literalnames)); the code that reads it is
`BashConfig.ResolveRoot`.

**`out/`** is the single home for all generated and transient files, gitignored except `.gitkeep`. The _root_ is the contract
(`Get-OutputRoot`); the subfolders inside are ad-hoc workspaces with no fixed names. Nothing under `out/` is source. See
[dedicated-output-directory](dedicated-output-directory.md).

**Dot-prefixed roots** (`.github/`, `.vscode/`, `.claude/`, `.cspell/`, `.go/`, `.python/`, `.bash/`, `.git/`) are infrastructure/tooling —
the same convention the dot-prefix carries inside `pwsh/` (Level 2): a leading dot means "infrastructure, not content."

The repository _root_ is itself conventional beyond its folders: `importer.ps1` and `importer.sh` (the entry points), `.editorconfig`,
`.gitattributes`, `.gitignore`, `dotnet-tools.json`, `catzc.sln`, `cspell.yml` (the repo-wide spell-check dictionary), and `LICENSE` each
have a fixed, name-inferred role. (The authored PSScriptAnalyzer config lives under `pwsh/.internal/assets/`, alongside the IDE-only C#
project — see [native-csharp-types](../automation/BCL/native-csharp-types.md) — not at the root.) Adding a new top-level directory is a
conscious architectural decision — an amendment to this ADR — not a casual act.

### Level 2: `pwsh/`

```text
Level 2: `pwsh/` — modules vs. infrastructure
```

| Convention             | Meaning                                         | Examples                                                            |
| ---------------------- | ----------------------------------------------- | ------------------------------------------------------------------- |
| Dot-prefixed directory | Infrastructure — invisible to module discovery  | `.internal/`, `.vendor/`, `.scriptanalyzer/`, `.compiled/`          |
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
| `private/`        | Private helper functions — loaded, not exported                                                                   | `New-DynamicManifest` (lists the files the loader dot-sources) |
| `tests/`          | Pester test files (`*.Tests.ps1`) plus their fixtures in `tests/assets/`                                          | `Test-Automation` (discovers test paths)                       |
| `assets/`         | Consumable assets the module ships — templates, scripts, schemas (not test fixtures, not the module's own config) | Module functions via `Get-CatzcModuleRoot`                     |
| `configs/`        | The module's own internal config (flat kebab-case `.yml`) the module loads to configure itself                    | `Get-Config` (via `Get-CatzcModuleRoot`)                       |
| `types/`          | Native C# sources (`*.cs`) autoloaded as .NET types                                                               | `Import-CSharpTypes` (one combined assembly, loaded at import) |

**`private/`** contains `.ps1` files that follow the same one-function-per-file convention as root files. They are loaded into the module's
session state by the module's loader but excluded from `FunctionsToExport`. The folder name `private/` means "non-exported" everywhere, in
every module, without exception.

**`types/`** contains C# source files (`*.cs`) compiled and loaded as .NET types at import time by the bootstrap module's
`Import-CSharpTypes`, before any module's functions. **The filename is the bare type name** the file must produce, and **the file declares a
file-scoped `namespace <module>;`** — derived from its `types/` folder, written and repaired by `Format-Types` and checked by
`Test-Formatting`, so the fully-qualified type is `<module>.<filename>` (`types/CliRunner.cs` in `Catzc.Base.Execution` →
`Catzc.Base.Execution.CliRunner`). The loader identifies the type from the filename with no source parsing — one type per file (the analogue
of one-function-per-file) — and rejects a dotted filename or a missing, mismatched, or block-scoped namespace. Every module's sources
compile together into **one** committed assembly for the whole repository, `pwsh/.compiled/Catzc.Types.<hash>.dll` (vendored, hash-keyed,
like `.vendor/`), so a fresh checkout and CI load it without invoking Roslyn. A module with no native types has no `types/` folder. The full
contract — the single combined assembly, `namespace = module`, the cross-module references governed by the dependency graph, the cache-state
behaviour, the fail-fast on edit, and the one shared `DictionaryRecord` data-record base — lives in its own ADR,
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
`Get-CatzcModuleRoot` (e.g., `Get-CatzcModuleRoot -ChildPath 'assets/template.bicep'`, the same call from a root or a `private/` function),
which resolves under the active code root in source mode and in the installed build alike
([working-directory-mechanics](../pwsh/working-directory-mechanics.md#rule-adr-pwsh-pwd-modulelocatescontent),
[internal-asset-dependencies](../automation/internal-asset-dependencies.md)). Module authors may create subdirectories inside `assets/` to
organize content — the internal structure is freeform. The module's own configuration does **not** belong here; it lives in `configs/`.

**`configs/`** holds the module's own internal configuration — the checked-in YAML a module loads to configure its own behaviour. Each entry
is a flat, kebab-case `.yml` file (`<kebab-name>.yml`, never `.yaml`); the folder is flat, with no subdirectories. Module functions read
these files through `Get-Config`, which locates them under the module's folder in the active code root (in source mode,
`Get-CatzcModuleRoot -ChildPath 'configs/tools.yml'` in `Catzc.Base.Execution` resolves to `pwsh/Catzc.Base.Execution/configs/tools.yml`). A
module's own config goes in `configs/`, and `assets/` is reserved for templates, scripts, schemas, fixtures, and other consumable assets.
Live examples: `Catzc.Base.Execution/configs/tools.yml`, `Catzc.Base.ModuleSystem/configs/dependencies.yml`,
`Catzc.Azure.DevOps/configs/{ado,pipeline-env}.yml`, `Catzc.Azure/configs/{azure,network}.yml`. This is enforced by
`Test-FolderConventions.Tests.ps1`, which allows `configs/` as a module subdirectory, requires every entry to be a flat kebab-case `.yml`
file, and fails any module that keeps an `assets/config/` directory. Files in `configs/` are read through the shared
`Get-Config -Config <name>` reader rather than bespoke per-reader loaders — see
[module-config-loading](../configuration/module-config-loading.md).

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
| A non-dot folder under `pwsh/` that is not a module                 | `Import-AllModules` discovers it and tries to build a manifest                                       | Dot-prefix it (infrastructure) or make it a module |
| A dot-prefixed module that should be discovered                     | `Import-AllModules` skips it — module is invisible                                                   | Remove the dot prefix                              |
| Passing `-PrivatePath` or similar parameters to Bootstrap           | Adds indirection; the path is always `'private'`                                                     | Hardcode the name; remove the parameter            |
| A `module.yml` mapping folder names to meanings                     | Second source of truth that drifts from the actual structure                                         | Remove the mapping; use the convention directly    |
| Putting output files in `assets/`                                   | Mixes transient output with source — see [dedicated-output-directory](dedicated-output-directory.md) | Write to `out/`                                    |

### Stable locators

A name that carries a rank, `01-first.md` or `plan-A-urgent.md`, is wrong the moment the order changes, and every link to it breaks with the
rename. A name that says what the file is stays true for the file's whole life, and the order a reader wants today is a view: a table that
sorts by value, an index, a head key a tool reads. The folders of this repository therefore sort by name, and the name means the thing. The
task files of the plans folder hold to it too: each is named by its topic, and the execution order is the master plan's list
([plans](plans.md#rule-adr-repo-plans-masterandtasks)), so reordering the list renames nothing.

### How this is enforced

- **`New-DynamicManifest`** — hardcodes `private/` when scanning for non-exported functions. Files not in `private/` or the module root are
  not included in the manifest. A file in `helpers/` is structurally invisible.

- **`Import-AllModules`** — hardcodes the dot-prefix filter (`$_.Name -notmatch '^\.'`). Dot-prefixed folders are infrastructure. Non-dot
  folders are modules. No configuration.

- **`Test-Automation`** — hardcodes `tests/` when discovering test paths. Test files outside `tests/` are never executed.

- **`Test-Automation.Tests.ps1`** — validates that every `.ps1` file in a module follows the one-function-per-file convention. It scans only
  the module root and `private/` — files in `assets/` or other folders are not subject to this validation.

- **`importer.ps1`** and its **`Invoke-Importer`** overlay — hardcode `pwsh/`, `.internal/`, and `.vendor/`. These are the bootstrapping
  paths. They do not come from configuration.

- **`Test-FolderConventions.Tests.ps1`** — enforces the module-internal layout: every module subdirectory must be one of `private/`,
  `tests/`, `assets/`, `configs/`, or `types/`; every entry in `configs/` must be a flat, kebab-case `.yml` file (no subdirectories, never
  `.yaml`); no module may have an `assets/config/` directory; and no module may have an `assets/test/` directory — test fixtures live in
  `tests/assets/`.

- **Repo-wide conventions** — the closed root set (ADR-REPO-FOLDERS-CLOSEDROOTSET), the dot-prefixed roots
  (ADR-REPO-FOLDERS-DOTMEANSTOOLING), the markdown-only rule for `docs/` (ADR-REPO-FOLDERS-DOCUMENTATIONMARKDOWNONLY), and the
  `contracts/<unit>/<version>/<module>/` layout with its root `.gitkeep` (ADR-REPO-FOLDERS-CONTRACTSFOLDER) — are enforced by **code
  review** against this ADR; the deep `pwsh/` conventions above are additionally enforced mechanically by the tooling listed here.

- **Code review.** Structural conventions that tooling cannot enforce (e.g., "this YAML file belongs in `configs/`, not the module root")
  are caught in review. The uniform structure makes deviations visually obvious.

## Consequences

- One place to learn what any folder means and where new content belongs — for the whole repository, not just `pwsh/`. No per-folder README,
  no mapping file.
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
