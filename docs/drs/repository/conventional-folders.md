# ADR: Conventional folders — every folder semantic, its name the conventional default

## Rules: ADR-REPO-FOLDERS

### Rule ADR-REPO-FOLDERS-EVERYFOLDERSEMANTIC

Every folder in the repository is **conventional** and **semantic**. Conventional, because its name is a known, good locator for the data
that rests in it, and that convention is encoded — as settings whose defaults are the conventional names
(ADR-REPO-FOLDERS-DEFAULTCONFIGURATION) — so it can be enforced. Semantic, because the tooling does something with that meaning: the loader
keeps `private/` private, the test runner runs `tests/`, a gate checks `configs/` as configuration. No folder needs a mapping file or a
README to be understood: the encoded model says what each name means, and the semantics act on it. A repository that overrides a name
changes the model, not the principle — the overridden folder is still conventional and still semantic, under its new name. At the root this
goes further: every root folder names a **track** — the repository's unit of root concern — `out/` included, the `output` track git ignores
and the tools operate on (`ADR-REPO-OUTDIR`); so adding a root folder is the decision to open a track (see [tracks](../design/tracks.md),
code `DDR-TRACK`).

- [The thesis](#the-thesis)

### Rule ADR-REPO-FOLDERS-DEFAULTCONFIGURATION

The convention model is encoded as the **sensible default configuration** of an ordered repository. A folder name the model gives meaning to
is a setting whose default is the conventional name, declared once
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)) at one of three layers:
a track's places (`variants.yml` `tracks`, [DDR-TRACKTYPE-TYPESDECLAREDONCE][r1]), the places of a track's modules (`module-types.yml`), or
the folders a language lays out inside a module (`languages.yml` `layout`, each folder with its role). A repository renames any of them —
`out/`, `pwsh/`, `private/` — by overriding that setting, and every tool follows the setting. A subfolder the model does not reach gets what
its parent's role does with it, and its own name and layout are free.

- [The default configuration of an ordered repository](#the-default-configuration-of-an-ordered-repository)

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

### Rule ADR-REPO-FOLDERS-DOCSMARKDOWNONLY

Documentation folders are markdown-only. `docs/` organizes its subfolders freely (the names and casing are the author's), but it holds only
`.md` files — except the dot-prefixed `.assets/` folders, which hold the diagrams the markdown embeds. An `.assets/` folder sits beside the
pages that embed its diagrams and holds each diagram as flat files named by the diagram, never a folder of its own: the render
`<page-folder>/.assets/<name>.drawio.png` and, by default, its one source `<name>.drawio.yml` put to it (a diagram the kit's `drawio.yml`
puts in the article carrier keeps its source as a `yml drawio` block in the article instead), so `<name>` is the diagram's only name; the
projections it shows are embedded in the render, drawn from computed data, never kept as files of their own. Each subfolder of `docs/drs/`
is a decision-record **domain**: a group of decision records that `drs.yml` declares with its role and the domains it depends on.

- [Level 1: Repository root](#level-1-repository-root)

### Rule ADR-REPO-FOLDERS-DEFAULTMODULEFOLDERS

Module-internal folder names default to the conventional set the module's language layout declares: private helpers in `private/`, tests in
`tests/`, consumable assets in `assets/`, the module's own internal config in `configs/`, native C# sources in `types/`. A module never
invents another name for the same role (`internal/`, `helpers/`, `test/`, `spec/`, `resources/`, `config/`); a repository that wants another
name overrides the layout's setting, and the name changes for every module of the track at once.

- [Level 3: Module internals](#level-3-module-internals)
- [Violation patterns](#violation-patterns)

### Rule ADR-REPO-FOLDERS-NAMESARESETTINGS

Tooling reads every folder name it relies on from its setting, through one resolver per setting that every caller uses, never from a literal
of its own: the conventional name is the setting's default, declared once on its config type, so a repository that declares nothing gets the
conventional layout and one that overrides a name gets it everywhere. The root of every test language already follows it: its defaults are
`<language>/` when the repository has that folder, else the dot-prefixed `.<language>/` — the Go root (`go.yml`'s `root`,
`GoConfig.ResolveRoot`), the Python root (`python.yml`'s `root`, `PythonConfig.ResolveRoot`) and the Bash root (`bash.yml`'s `root`,
`BashConfig.ResolveRoot`). A literal folder name still in code is a setting not yet resolved, and it spells the setting's default.

- [Names are settings](#names-are-settings)
- [How this is enforced](#how-this-is-enforced)

### Rule ADR-REPO-FOLDERS-NOMODULEOVERRIDE

No module-level override of conventions. A module cannot opt out of the structure or rename a conventional folder on its own; a name is
overridden for the whole repository or track, in its setting, so `private/` — or whatever the repository renamed it to — means the same in
every module, and tooling can rely on it.

- [Why convention](#why-convention)

### Rule ADR-REPO-FOLDERS-NEWFOLDERNEEDSADR

New module-level folder roles require an ADR amendment. Adding a role beyond those of `private/`, `tests/`, `assets/`, `configs/`, `types/`
adds a setting to a track's default configuration, which every tool serving the track reads; renaming an existing one is an override, not an
amendment.

- [Level 3: Module internals](#level-3-module-internals)

### Rule ADR-REPO-FOLDERS-UNKNOWNFOLDERSIGNORED

Unknown folders are ignored, not errors. A module folder that no layout role names is silently skipped by the bootstrap module and test
runner; the module just cannot expect tooling to interact with it.

- [Level 3: Module internals](#level-3-module-internals)

### Rule ADR-REPO-FOLDERS-CONTRACTSFOLDER

Contracts live under the root `contracts/` folder, laid out as `contracts/<root>/<version>/[<group>/]<asset>`
([ADR-REPO-CONTRACT-LAYOUT](api-contracts.md#rule-adr-repo-contract-layout)): `<root>` names who made the promise — `catzc` for what we
promise the world, a vendor's plain moniker (`github`, `ado`, `azure`) for what that vendor promised us — `<version>` is `0.1.0`, the
current contracts every internal binding points at, or a frozen `catzc` release from `1.0.0` up
([ADR-REPO-CONTRACT-CURRENTVERSION](api-contracts.md#rule-adr-repo-contract-currentversion)), and the optional `<group>` is one folder, the
owning module in `catzc` or the vendor's area in a vendor root; no folder under `contracts/` is dot-prefixed
([ADR-REPO-CONTRACT-NODOTFOLDERS](api-contracts.md#rule-adr-repo-contract-nodotfolders)). A release folder kept for a consumer that pins it
is deliberately and equally live (see [one-living-version](../principles/one-living-version.md#rule-pdr-onelive-pinnedversionnotlegacy)),
not legacy. The root carries a checked-in `.gitkeep`, so it stays tracked before any contract exists. What the contracts _are_ — the binding
interfaces at the repository boundary, in both directions, and their testing discipline — is the [api-contracts](api-contracts.md) ADR (code
`ADR-REPO-CONTRACT`).

- [Level 1: Repository root](#level-1-repository-root)

### Rule ADR-REPO-FOLDERS-STABLEFILENAMES

A file name is a **stable locator**: it never encodes an order, a rank or a priority. Sorting is an overlay, an index or a head key, never a
prefix, and the delivered default sort of any folder is the semantic name order. There is no exception: an execution order, such as the
order of the plans folder's task files ([ADR-REPO-PLANS-MASTERANDTASKS](plans.md#rule-adr-repo-plans-masterandtasks)), is carried by the
list that orders them.

- [Stable locators](#stable-locators)

## Context

A product mono-repository ([ADR-REPO-REPOKIND-THREEREPOKINDS][r2]) without a fixed folder structure degenerates into a naming negotiation.
Every new module, every new config file, every new test file raises the same questions: where does this go? What do I call the folder? Do I
need to tell something about it? The answers depend on who you ask, what existed before, and what the last person did. Over time the layout
drifts — one module puts helpers in `internal/`, another in `helpers/`, a third in `util/`. Tooling cannot program against a layout that
changes per module, so configuration files, path arguments, and environment variables proliferate to bridge the gap.

This platform takes the opposite approach. The folder structure is semantic and the same everywhere, because it ships as a sensible default
configuration: every name that carries meaning for tooling is a setting whose default is the conventional name, declared once. A repository
that declares nothing gets the ordered layout described here; a repository that wants `output/` instead of `out/`, or `src/` instead of
`pwsh/`, overrides one setting and every tool follows. There are no per-module overrides and no path parameters.

### The thesis

`The thesis: every folder infers its meaning`

This is the organizing principle of the whole repository, not just of `pwsh/`: **every folder is conventional and semantic.** A folder's
name is a known locator for its data, encoded so it can be enforced, and the tooling acts on what that data is, so you can tell what a
folder holds, what new content belongs in it, and what will be done with it, from its name alone, without opening a README or consulting a
mapping file. The repository is a tree of names that mean things, top to bottom: the root folders separate concerns (each a track, the
gitignored `out/` included), `pwsh/` separates modules from infrastructure, and a module's internals separate public from private from tests
from assets. The same idea repeats at every depth.

### The default configuration of an ordered repository

`The convention model is encoded as settings; the conventional names are their defaults`

The convention model is what makes the names both conventional and semantic: it encodes each name as the locator of one kind of data, which
can be enforced, and the tooling acts on what is found there. It is encoded as settings, each with the conventional name as its default,
declared once at one of three layers, from the widest to the narrowest:

- **A track's place** — a root folder or a path a track covers, in `variants.yml` `tracks`: `pwsh/`, `pwsh/.vendor/`, `infrastructure/`,
  `contracts/`, `.github/workflows/`, `go/`, `python/`. A vendor's own convention, such as `.github/workflows/` or `.vscode/`, enters the
  tree here, as the place of the track that vendor reads. `out/` is the place of the `output` track, which git ignores and the tools operate
  on.
- **A module place** — where the modules of a track sit inside it, in `module-types.yml`: a folder under `pwsh/` is a module named by its
  folder, `pwsh/.internal/` holds the internal ones, and a language track's `tests/` is its test holder, not a module.
- **A language's layout** — the folders a language lays out inside a module, each with its role, in `languages.yml` `layout`: `private/`
  holds private functions, `types/` C# types, `configs/` configuration, `accosted/` run lists.

Inside a folder the model names, a subfolder the model does not reach — the topic subfolders of `docs/`, `docs/how-to/`,
`infrastructure/modules/`, the ad-hoc workspaces under `out/` — gets what its parent's role does with it, and its own name and layout are
free. Renaming one is harmless; renaming a folder the model names is overriding its setting, at the layer that declares it, and every tool
serving the track follows.

### Why convention

`Why conventional structure matters`

**Tooling becomes trivial.** When every module of a track puts private functions in the same folder, the bootstrap module reads that one
setting and is done. No per-module parameter, no "discover the helpers folder" heuristic: `New-DynamicManifest` does not ask a module where
its private functions are — it knows, because the structure is declared once, for the whole track.

**Onboarding is instant.** A new contributor opening any module sees the same layout: root `.ps1` files are public, `private/` is private,
`tests/` is tests, `assets/` is everything else. There is nothing to learn per module. The structure is self-documenting because it is
uniform.

**Violations are obvious.** When a module puts tests in `specs/` instead of `tests/`, the deviation is visible at a glance. More
importantly, `Test-Automation` will not find those tests, because it scans `tests/`. The structure enforces itself — non-conforming content
is invisible to tooling. This is poka-yoke: the wrong thing does not silently work, it visibly does not work.

**Configuration lives in one place per name.** Alternative designs scatter the mapping: a `module.yml` per module that says
`helpers_dir: internal`, a parameter `-PrivatePath 'helpers'` at every call site, a convention file per tool. Each is a source of truth that
drifts from the folders. Here each name is declared once, in its track's configuration, and holds for every module of the track, so there is
one place to read it and one place to change it.

### Names are settings

`A name tooling reads is a setting with the conventional default`

Repositories disagree on where things go: one keeps Go under a `go/` root, another keeps it out of the way under `.go/`; one calls its
output `out/`, another `artifacts/`. Both are reasonable, and catzc must serve either without moving anyone's files. So every folder name
tooling relies on is a setting, held to three conditions that keep what a literal gave:

- **The conventional names are the defaults.** They are declared once, on the setting's config type
  ([sensible-defaults](../automation/sensible-defaults.md)), so a repository that declares nothing gets the ordered layout of this ADR.
- **One resolver per setting.** Every caller asks the same function for the name, so the setting is greppable through that one function,
  just as a literal was, and it is self-evident: the resolver's name says what the folder is.
- **Overridden for the repository or the track, never per module.** A module does not choose its own names
  (ADR-REPO-FOLDERS-NOMODULEOVERRIDE), so a name means the same in every module it reaches.

The test-language roots follow it (the rule names their settings and resolvers), and a track's places are read through the track
([DDR-TRACK-SUBSCRIBABLENOTPATH](../design/tracks.md#rule-ddr-track-subscribablenotpath)). The module-internal names are read from the
layout through `LanguagesConfig.FolderOf`, and the bootstrap, which runs before any type loads, reads the same `languages.yml` row through
`Get-PrivateFunctionFolder`. Only the importer spells its names: `pwsh/`, `.internal/` and `.vendor/` are the bootstrapping paths, read
before any setting can be.

### Three levels of structure

The repository has three nested levels of conventional structure, each with its own rules:

1. **Repository root** — top-level directories that separate concerns (automation, docs, output, config, CI).
2. **`pwsh/`** — the module system root, where dot-prefix separates infrastructure from modules.
3. **Module internals** — the layout inside each module, where folder names determine function visibility and content semantics.

Each level is defined below in the Decision section.

## Decision

The repository uses a semantic folder layout at three levels. Every name tooling relies on is declared once, as configuration of the track
it belongs to — a track's place, a module place, or a language's layout — and tooling reads it from there. Declared names are not
suggestions.

### Level 1: Repository root

The root is a closed set of folders, each with a fixed meaning. The **Kind** column marks whether the name is declared as a track's place in
`variants.yml` (_declared_) or a reader infers it (_free_); `out/` is declared too, the place of the `output` track.

- **`pwsh/`**
  - Kind: declared
  - Meaning: Module system root — all PowerShell modules and infrastructure (Levels 2–3)
  - Programmed against by: `importer.ps1`, `Test-Automation`, `Install-VendorModule`
- **`docs/`**
  - Kind: mixed
  - Meaning: Documentation — `drs/` decision records, `references/` reference articles, `how-to/` guides, `explanation/` articles,
    `.assets/` diagrams
  - Programmed against by: `Build-DrsIndex`, `Build-Readme`; human consumption
- **`infrastructure/`**
  - Kind: mixed
  - Meaning: Bicep IaC — reusable `modules/` and deployable `templates/<name>/`
  - Programmed against by: Bicep build/deploy tooling, `Get-BicepTemplates`
- **`contracts/`**
  - Kind: declared
  - Meaning: Thin, binding promises at the repository boundary, both directions — `<root>/<version>/[<group>/]<asset>`; see
    [api-contracts](api-contracts.md)
  - Programmed against by: The owning modules' contract tests; outside consumers and platforms
- **`go/`**
  - Kind: declared
  - Meaning: The Go root: black-box Go tests, `tests/<module>/`; see [go-test-artifacts](../automation/go/go-test-artifacts.md)
  - Programmed against by: `GoConfig`, `New-GoWorkspace`, `Invoke-GoTest`
- **`python/`**
  - Kind: declared
  - Meaning: The Python root: black-box Python tests, `tests/<module>/`, and the generated test project; see
    [python-test-artifacts](../automation/python/python-test-artifacts.md)
  - Programmed against by: `PythonConfig`, `New-PythonProject`, `Invoke-PythonTest`
- **`bash/`**
  - Kind: declared
  - Meaning: The Bash root: black-box Bash tests, `tests/<module>/`, and the vendored bats runner; see
    [bash-test-artifacts](../automation/bash/bash-test-artifacts.md)
  - Programmed against by: `BashConfig`, `Invoke-BashTest`
- **`out/`**
  - Kind: declared
  - Meaning: All output files (gitignored) — see [dedicated-output-directory](dedicated-output-directory.md)
  - Programmed against by: Output functions, CI artifacts, cleanup scripts
- **`.github/`**
  - Kind: declared
  - Meaning: GitHub Actions — `workflows/`, actions, templates
  - Programmed against by: GitHub Actions runner
- **`.ado/`**
  - Kind: declared
  - Meaning: Azure DevOps — `pipelines/` holds the ado pipelines, per-kind templates, and the runner
  - Programmed against by: Azure DevOps runner, `Invoke-AdoScript.ps1`
- **`.vscode/`**
  - Kind: declared
  - Meaning: Managed, generated editor config — every file reproduced on import; see [generated-root-configs](generated-root-configs.md)
  - Programmed against by: VS Code; `Build-RootConfig`
- **`.claude/`**
  - Kind: declared
  - Meaning: Claude Code project config — `CLAUDE.md`, `settings.json`, the `agents/`, `hooks/`, and `drawio/` folders
  - Programmed against by: Claude Code
- **`.cspell/`**
  - Kind: declared
  - Meaning: Generated cspell dictionaries — one `<category>.txt` per `terminology.yml` category; only `.gitkeep` is committed
  - Programmed against by: `cspell.yml`; `Build-TerminologyDictionary`
- **`.go/`**
  - Kind: declared
  - Meaning: The Go root when the repository has no `go/` folder — the same layout as `go/`, dot-prefixed as tooling
  - Programmed against by: `GoConfig`, `New-GoWorkspace`, `Invoke-GoTest`
- **`.python/`**
  - Kind: declared
  - Meaning: The Python root when the repository has no `python/` folder — the same layout as `python/`, dot-prefixed as tooling
  - Programmed against by: `PythonConfig`, `New-PythonProject`, `Invoke-PythonTest`
- **`.bash/`**
  - Kind: declared
  - Meaning: The Bash root when the repository has no `bash/` folder — the same layout as `bash/`, dot-prefixed as tooling
  - Programmed against by: `BashConfig`, `Invoke-BashTest`
- **`.git/`**
  - Kind: —
  - Meaning: Git's own store. The boundary of _our_ conventions: git owns it, we do not document it.
  - Programmed against by: Git

`pwsh/` is the only root the module system interacts with; its internals are Levels 2–3 below. The rest separate concerns at the repo level,
and each has its own conventional sub-layout:

**`docs/`** holds five folders. `drs/` is the decision records, one subfolder per domain declared in `pwsh/Base.Drs/configs/drs.yml`:
`thesis/`, `principles/`, `process/`, `design/`, `flow/`, `automation/`, `pwsh/`, `configuration/`, `ado/`, `github/`, `azure/`,
`repository/` (this ADR), and `external/dora/`. Its `index.md` is generated from that registry and describes each domain, so the registry —
not this paragraph — is the authoritative list of domains. `references/` holds the authored reference articles, including the sources the
generated READMEs are copied from ([generated-readmes](generated-readmes.md)) and the DORA research reference under `references/dora/`.
`how-to/` holds task-oriented guides. `explanation/` holds the explanation articles: each narrates one diagram of how cats works and why, in
a subfolder per decision-record domain. These four are **markdown-only**; their subfolders are author-organized topic buckets. The
dot-prefixed `.assets/` holds the binary diagram assets (`*.drawio.png`) the markdown embeds — the one non-markdown content under `docs/`,
set apart by the dot-prefix convention (ADR-REPO-FOLDERS-DOTMEANSTOOLING). A diagram is a pair of files in the `.assets/` beside the page
that embeds it, so moving the diagram moves the pair and the page finds it by locality: `<name>.drawio.yml`, its declaration, the one source
its words and cells live in, and `<name>.drawio.png`, put from it. A projection's reasons travel in its computed data and in the diagram's
declaration.

**`infrastructure/`** splits into `modules/` (reusable Bicep modules — flat `*.bicep`, _not_ discovered as templates) and
`templates/<name>/` (deployable units: `main.bicep`, `options.yml`, optional `PrePost.psm1`). A template's
`configuration/[<customer>/]<env>[-<slot>].yml` tree is the resource-group inventory — one config file is one resource group; a config at
the configuration root is the shared platform's, and a subfolder is always a customer key. The folder name is the readable label; the Azure
identity is a separate `short_name`, which the Azure domain's data model and naming standard govern.

**`.ado/pipelines/`** is flat: ado pipelines are named `<type>-<name>.yaml` (`cron`/`ci`/`cd`/`cde`/`deploy`/`input`) directly in the
folder, the runner `Invoke-AdoScript.ps1` sits at the root, and reusable fragments live in per-kind folders whose fixed names are the
include kinds — `steps/`, `jobs/`, `stages/`, `variables/`, `extends/`; the ado domain names and places each pipeline.

**`contracts/`** holds the repository's contracts — the binding interfaces at its boundary, proven by tests, in both directions: provided
(what we promise the world) and depended-on (what a vendor, such as GitHub or Azure DevOps, promised us). It has at most four levels. The
first is the root, who made the promise: `contracts/catzc/` for ours, `contracts/<vendor>/` for a vendor's. The second is the version:
`0.1.0`, the current contracts, edited in place; the rest of the `0.1` range is reserved, `0.0.0` is never a folder, and a version from
`1.0.0` up is a frozen `catzc` release. The `contracts/` root carries a checked-in `.gitkeep`, so it stays tracked before any contract
exists. The third, optional, is one group folder. The fourth is the asset itself; the files it binds are named in its version's
`contract.yml`, not by a mirrored path. A pinned release folder is the one place the repo deliberately carries backwards compatibility,
because here, unlike the internal code, external consumers genuinely exist (see
[one-living-version](../principles/one-living-version.md#rule-pdr-onelive-pinnedversionnotlegacy)).

**`go/`** is the Go root: the repository's Go code, which is black-box tests of the engine and never ships
([go-test-artifacts](../automation/go/go-test-artifacts.md)). It holds `tests/<module>/`, one Go test module per catzc module, named for
that module in kebab case; `go.work` sits at the repository root, beside it. Every file Go needs besides the `*_test.go` files is generated
and gitignored. A repository with no `go/` folder keeps the same layout under the dot-prefixed `.go/`, and `go.yml`'s `root` places the Go
root elsewhere when declared; the two names are the sensible defaults of that one setting
([sensible-defaults](../automation/sensible-defaults.md)), and the code that reads them is `GoConfig.ResolveRoot`.

**`python/`** is the Python root: the repository's Python tests, which are black-box tests of the engine and never ship
([python-test-artifacts](../automation/python/python-test-artifacts.md)). It holds `tests/<module>/`, one Python test folder per catzc
module, named for that module in kebab case, and the generated uv workspace — the root `pyproject.toml`, one member `pyproject.toml` per
test folder, and the one environment and lock uv makes from them — all gitignored. Its root resolves like Go's
([ADR-REPO-FOLDERS-NAMESARESETTINGS](#rule-adr-repo-folders-namesaresettings)).

**`bash/`** is the Bash root: the repository's Bash tests, which are black-box tests of the engine through `importer.sh` and `cats`, and
never ship ([bash-test-artifacts](../automation/bash/bash-test-artifacts.md)). It holds `tests/<module>/`, one Bash test folder per catzc
module, named for that module in kebab case, and the vendored bats-core runner under `.vendor/bats-core/`, committed. Its root resolves like
Go's ([ADR-REPO-FOLDERS-NAMESARESETTINGS](#rule-adr-repo-folders-namesaresettings)).

**`out/`** is the `output` track: the single home for all generated and transient files, gitignored except `.gitkeep`, and operated on like
any track — the tools write their reports, renders and builds there and read them back. Its build destination is none, so it ships nothing.
The track's place is the conventional part (`Get-OutputRoot`); the subfolders inside are ad-hoc workspaces with no conventional names.
Nothing under `out/` is source. See [dedicated-output-directory](dedicated-output-directory.md).

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

- **Dot-prefixed directory**
  - Meaning: Infrastructure — invisible to module discovery
  - Examples: `.internal/`, `.vendor/`, `.scriptanalyzer/`, `.compiled/`
- **Non-dot directory**
  - Meaning: Module — auto-discovered by `Import-AllModules`
  - Examples: `Catzc.Base.Asserts/`, `Catzc.Base.Writers/`, `Catzc.Tooling.Core/`

`Import-AllModules` filters with `$_.Name -notmatch '^\.'`. This is the entire module discovery mechanism: if the folder name starts with a
dot, it is infrastructure; otherwise, it is a module. No registration, no manifest, no list of module names.

**Why dot-prefix:** The dot-prefix convention is borrowed from Unix (dotfiles are hidden by default) and from this repository's own
`.github/` and `.vscode/` patterns. It communicates "infrastructure, not content" at a glance. It also sorts infrastructure to the top of
directory listings, visually separating it from modules.

### Level 3: Module internals

Every module directory follows the same internal layout:

- **`*.ps1` (root)**
  - Meaning: Public exported functions — file name = function name
  - Programmed against by: `New-DynamicManifest` (derives `FunctionsToExport`)
- **`private/`**
  - Meaning: Private helper functions — loaded, not exported
  - Programmed against by: `New-DynamicManifest` (lists the files the loader dot-sources)
- **`tests/`**
  - Meaning: Pester test files (`*.Tests.ps1`) plus their fixtures in `tests/assets/`
  - Programmed against by: `Test-Automation` (discovers test paths)
- **`assets/`**
  - Meaning: Consumable assets the module ships — templates, scripts, schemas (not test fixtures, not the module's own config)
  - Programmed against by: Module functions via `Get-CatzcModuleRoot`
- **`configs/`**
  - Meaning: The module's own internal config (flat kebab-case `.yml`) the module loads to configure itself
  - Programmed against by: `Get-Config` (via `Get-CatzcModuleRoot`)
- **`types/`**
  - Meaning: Native C# sources (`*.cs`) autoloaded as .NET types
  - Programmed against by: `Import-CSharpTypes` (one combined assembly, loaded at import)

**`private/`** contains `.ps1` files that follow the same one-function-per-file convention as root files. They are loaded into the module's
session state by the module's loader but excluded from `FunctionsToExport`. The folder name `private/` means "non-exported" everywhere, in
every module, without exception.

**`types/`** contains C# source files (`*.cs`) compiled and loaded as .NET types at import time by the bootstrap module's
`Import-CSharpTypes`, before any module's functions. **The filename is the bare type name** the file must produce, and **the file declares a
file-scoped `namespace <module>;`** — derived from its `types/` folder, written and repaired by `Format-Types` and checked by
`Test-Formatting`, so the fully-qualified type is `<module>.<filename>` (`types/CliRunner.cs` in `Catzc.Base.Execution` →
`Catzc.Base.Execution.CliRunner`). The loader identifies the type from the filename with no source parsing — one type per file (the analogue
of one-function-per-file) — and rejects a dotted filename or a missing, mismatched, or block-scoped namespace. Every module's sources
compile together into **one** assembly for the whole repository, `Catzc.Types.<hash>.dll`, built on each machine into the per-user shadow
root and keyed by the source hash; git keeps no file under `pwsh/.compiled`, and the types surface is the provided contract under
`contracts/catzc/0.1.0/catzc.internal.types/`. A module with no native types has no `types/` folder. The full rule set — the single combined
assembly, `namespace = module`, the cross-module references governed by the dependency graph, the cache-state behaviour, the fail-fast on
edit, and the one shared `DictionaryRecord` data-record base — lives in its own ADR,
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
([internal-asset-dependencies](../automation/internal-asset-dependencies.md)). Module authors may create subdirectories inside `assets/` to
organize content — the internal structure is freeform. The module's own configuration does **not** belong here; it lives in `configs/`.

**`configs/`** holds the module's own internal configuration — the checked-in YAML a module loads to configure its own behaviour. Each entry
is a flat, kebab-case `.yml` file (`<kebab-name>.yml`, never `.yaml`); the folder is flat, with no subdirectories. Module functions read
these files through `Get-Config`, which locates them under the module's folder in the active code root (in source mode,
`Get-CatzcModuleRoot -ChildPath 'configs/tools.yml'` in `Catzc.Base.Execution` resolves to `pwsh/Base.Execution/configs/tools.yml`), the one
shared reader rather than bespoke per-reader loaders — see [module-config-loading](../configuration/module-config-loading.md).

Not every module needs every folder. A module with no private helpers has no `private/`. A module with no assets has no `assets/`, and a
module that loads no internal config has no `configs/`. The convention defines what the name means when the folder exists, not that every
folder must exist.

### Violation patterns

- **Private helpers in `internal/`, `helpers/`, or `util/`**
  - Problem: Bootstrap does not scan these — functions are invisible
  - Fix: Rename to `private/`
- **Tests in `test/`, `spec/`, or the module root**
  - Problem: Test runner does not find them — they never execute
  - Fix: Move to `tests/` with `*.Tests.ps1` naming
- **The module's own config in the module root alongside `.ps1` files**
  - Problem: Config files could collide with function naming; unclear boundaries
  - Fix: Move to `configs/` as a kebab-case `.yml`
- **Standalone scripts in the module root**
  - Problem: Bootstrap treats them as public functions
  - Fix: Move to `assets/`
- **Using `config/` or `scripts/` as module subdirectories**
  - Problem: Not a conventional folder — tooling ignores them, convention test fails
  - Fix: Module config → `configs/`; scripts → `assets/`
- **The module's own config under `assets/config/` or bare in `assets/`**
  - Problem: Internal config belongs in `configs/`, not `assets/`; the convention test fails on `assets/config/`
  - Fix: Move to `configs/` as a flat kebab-case `.yml`
- **Test fixtures under `assets/test/`**
  - Problem: Fixtures and the tests that use them drift apart; the convention test fails on `assets/test/`
  - Fix: Move to `tests/assets/` (packaged with the tests)
- **A non-dot folder under `pwsh/` that is not a module**
  - Problem: `Import-AllModules` discovers it and tries to build a manifest
  - Fix: Dot-prefix it (infrastructure) or make it a module
- **A dot-prefixed module that should be discovered**
  - Problem: `Import-AllModules` skips it — module is invisible
  - Fix: Remove the dot prefix
- **Passing `-PrivatePath` or similar parameters to Bootstrap**
  - Problem: A per-call name lets one caller disagree with the repository's setting
  - Fix: Read the setting through its resolver; remove the parameter
- **A `module.yml` mapping folder names to meanings**
  - Problem: Second source of truth that drifts from the actual structure
  - Fix: Remove the mapping; use the convention directly
- **Putting output files in `assets/`**
  - Problem: Mixes transient output with source — see [dedicated-output-directory](dedicated-output-directory.md)
  - Fix: Write to `out/`

### Stable locators

A name that carries a rank, `01-first.md` or `plan-A-urgent.md`, is wrong the moment the order changes, and every link to it breaks with the
rename. A name that says what the file is stays true for the file's whole life, and the order a reader wants today is a view: a table that
sorts by value, an index, a head key a tool reads. The folders of this repository therefore sort by name, and the name means the thing. The
task files of the plans folder hold to it too: each is named by its topic, and the execution order is the master plan's list
([plans](plans.md#rule-adr-repo-plans-masterandtasks)), so reordering the list renames nothing.

### How this is enforced

- **`New-DynamicManifest`** — scans `private/` for non-exported functions (a literal today, the setting's default). Files not in `private/`
  or the module root are not included in the manifest. A file in `helpers/` is structurally invisible.

- **`Import-AllModules`** — applies the dot-prefix filter (`$_.Name -notmatch '^\.'`). Dot-prefixed folders are infrastructure. Non-dot
  folders are modules.

- **`Test-Automation`** — discovers test paths under `tests/` (a literal today, the setting's default). Test files outside `tests/` are
  never executed.

- **`Test-Automation.Tests.ps1`** — validates that every `.ps1` file in a module follows the one-function-per-file convention. It scans only
  the module root and `private/` — files in `assets/` or other folders are not subject to this validation.

- **`importer.ps1`** and its **`Invoke-Importer`** overlay — hardcode `pwsh/`, `.internal/`, and `.vendor/`. These are the bootstrapping
  paths. They do not come from configuration.

- **`Test-FolderConventions.Tests.ps1`** — enforces the module-internal layout: every module subdirectory must be one of `private/`,
  `tests/`, `assets/`, `configs/`, or `types/`; every entry in `configs/` must be a flat, kebab-case `.yml` file (no subdirectories, never
  `.yaml`); no module may have an `assets/config/` directory; and no module may have an `assets/test/` directory — test fixtures live in
  `tests/assets/`.

- **Repo-wide conventions** — the closed root set (ADR-REPO-FOLDERS-CLOSEDROOTSET), the dot-prefixed roots
  (ADR-REPO-FOLDERS-DOTMEANSTOOLING), the markdown-only rule for `docs/` (ADR-REPO-FOLDERS-DOCSMARKDOWNONLY), and the
  `contracts/<root>/<version>/[<group>/]` layout with its root `.gitkeep` (ADR-REPO-FOLDERS-CONTRACTSFOLDER) — are enforced by **code
  review** against this ADR; the deep `pwsh/` conventions above are additionally enforced mechanically by the tooling listed here.

- **Code review.** Structural conventions that tooling cannot enforce (e.g., "this YAML file belongs in `configs/`, not the module root")
  are caught in review. The uniform structure makes deviations visually obvious.

## Consequences

- One place to learn what any folder means and where new content belongs — for the whole repository, not just `pwsh/`. No per-folder README,
  no mapping file.
- The declared/free distinction tells a contributor whether a folder name is load-bearing — a track's configuration, renamed at the layer
  that declares it — or a free label (renaming it is harmless).
- The folder structure is self-documenting. Opening any module reveals the same layout. `private/` is private, `tests/` is tests, `assets/`
  is everything else — no per-module learning curve.
- Tooling is simple and stable. Each folder name is read through its one resolver, so no tool takes a per-call path; only the importer and
  the bootstrap module spell their bootstrapping paths.
- New modules are created by copying the folder layout. There is no registration, no configuration file to update, no "folder structure"
  section in a setup guide. The layout is the same everywhere because the names are the same everywhere.
- Adding a new folder role to the conventional layout is a deliberate, documented decision. It adds a setting to a track's default
  configuration, so it goes through an ADR amendment; renaming an existing folder is an override of its setting.
- Non-conforming content is structurally invisible, not an error. A module with helpers in `internal/` does not crash the bootstrap module —
  it just has no private functions. This is poka-yoke: the wrong name does not cause a confusing failure, it causes a predictable absence
  that is easy to diagnose.
- The tradeoff is uniformity over local taste. A repository may call its test folder `spec/` by overriding the setting, and then every
  module's tests are in `spec/`; no single module may call its own `spec/` or `internal/`. The platform's consistency is worth more than one
  module's naming preference.

[r1]: ../design/track-types.md#rule-ddr-tracktype-typesdeclaredonce
[r2]: repository-kinds.md#rule-adr-repo-repokind-threerepokinds
