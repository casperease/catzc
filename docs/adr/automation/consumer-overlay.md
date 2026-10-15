# docs/adr/automation/consumer-overlay.md

`ADR: Consumer overlay — a consumer changes a built bundle only through .catzc/`

## Rules: ADR-AUTO-OVERLAY

### Rule ADR-AUTO-OVERLAY:1

A consumer's **overlay** is the `.catzc/` folder at its `RepositoryRoot`: the only place a consumer changes what a built bundle does. The
bundle it runs is read-only and never edited. The overlay is optional, and so is every file in it; with none, the bundle runs exactly as
built. The overlay is the consumer's source — committed and reviewed by the consumer, and never written by catzc.

- [The overlay](#the-overlay)

### Rule ADR-AUTO-OVERLAY:2

A file under `.catzc/automation/` sits at the same relative path as the thing it changes under the bundle's code root. The path alone says
what is changed; there is no list of overrides to keep in step with the files.

- [The location is the meaning](#the-location-is-the-meaning)

### Rule ADR-AUTO-OVERLAY:3

Under `.catzc/automation/<Module>/`, where `<Module>` is a bundled module, the only entries are a public function override (a public
function file at the folder's root, named for its function), a private function override (a private function file under `private/`), a
config fragment (`configs/<config>.yml`), an asset override (`assets/<path>`), and local tests (`tests/<path>`). Anything else there is
rejected. A folder that names no bundled module is a local module ([ADR-AUTO-OVERLAY#9](#rule-adr-auto-overlay9)).

- [Override points](#override-points)

### Rule ADR-AUTO-OVERLAY:4

A config fragment states only the keys that differ, and is merged onto the bundled config before the config's own type validates the result:
a map merges key by key, a scalar or a list replaces the bundled value, and an explicit `null` removes the key so the type's declared
default applies. In build mode a setting therefore resolves the caller's explicit value, then the overlay fragment, then the config
contributions gathered from Markdown files, then the bundled config, then
the type's default ([sensible-defaults](sensible-defaults.md#rule-adr-auto-default6)). A fragment merges only onto a config the module
ships.

- [Config fragments](#config-fragments)

### Rule ADR-AUTO-OVERLAY:5

A function override is one function named for its file, under the shape rules every function file loaded away from its folder follows. It
replaces a function the bundled module has, with the same visibility, inside that module: every caller — the session, the module itself,
every other module, a test's module mock — reaches the override. It keeps the original's contract: every parameter the original declares,
with the same type; no new mandatory parameter; the same declared output type. A new function belongs in a local module.

- [Function overrides](#function-overrides)

### Rule ADR-AUTO-OVERLAY:6

An asset override replaces an asset the bundled module ships: the one lookup of a module's content returns the overlay's file for that asset
path. A new asset belongs in a local module.

- [Asset overrides](#asset-overrides)

### Rule ADR-AUTO-OVERLAY:7

The engine-intrinsic configs are sealed — the config registry, the dependency graph, the profiles, the export config, and the glossary
sources — declared once in the config registry (`overridable: false`). A fragment of a sealed config is rejected. Sealing more is a reviewed
edit to the registry, never code.

- [Sealed configs](#sealed-configs)

### Rule ADR-AUTO-OVERLAY:8

The overlay is checked as a whole before any of it applies, and every violation is reported in one failure. It applies in build mode only:
in source mode the catzc tree is changed directly, and a `.catzc/` folder there is not read.

- [Checked as a whole](#checked-as-a-whole)

### Rule ADR-AUTO-OVERLAY:9

A **local module** is a folder under `.catzc/automation/` that names no bundled module: the consumer's own module, following catzc's module
conventions — folder = module, a public function per root function file, private function files under `private/`, `configs/` found by
`Get-Config`, `assets/` found by the one content lookup. It never takes the reserved `Catzc.` prefix, carries no `types/`, and has no public
function that takes the name of a command already loaded. It loads after the bundled modules and their overrides, so it calls the bundle as
overridden, and nothing is written to load it.

- [Local modules](#local-modules)

## Context

A built bundle carries catzc out of the mono repo into a consumer's own repository ([platform-bundle](platform-bundle.md)). A consumer needs
to change some of what it does — its own customers and subscriptions in a config, a different template, a function that behaves differently
in its environment — without forking the bundle. A fork is a second living version of every behaviour it copies
([one-living-version](../principles/one-living-version.md)); editing the installed bundle is lost on the next install and breaks its content
hash. The change has to live beside the consumer's own code, apply to the bundle as it loads, and be visible as a change.

## Decision

A consumer changes a built bundle only through an overlay in its own working root, laid out as the bundle's code root is laid out, checked
as a whole and applied as the bundle loads. Catzc's own folder conventions are the overlay's conventions, so a consumer learns no second
set.

### The overlay

The consumer runs catzc in its own repository: that repository is the working root, and the bundle under `.vendor/Catzc/<version>/` is the
code root. The consumer's changes live in `.catzc/` at the working root. Nothing catzc derives from the overlay is written there; derived
output goes to the working root's `out/`, like every other output.

### The location is the meaning

`.catzc/automation/` mirrors the bundle's code root, path for path. `.catzc/automation/Catzc.Azure/configs/azure.yml` changes the bundled
`Catzc.Azure/configs/azure.yml`; `.catzc/automation/Catzc.Azure.Cli/Invoke-AzCli.ps1` replaces the public function `Invoke-AzCli` of
`Catzc.Azure.Cli`. Because the path is the declaration, there is nothing to register and nothing that can disagree with the files.
`Get-CatzcOverlay` lists what the overlay holds, each entry classified by where it sits.

### Override points

The override points are a closed set, so an entry that is no override point — a stray file, a `types/` folder, a manifest — fails instead of
silently doing nothing. Local tests sit beside the overrides they test. A folder that names no bundled module is a local module's place; the
`Catzc.` prefix is reserved for bundled modules, so a `Catzc.*` folder the bundle lacks is a missing module or a typo, and a bundle compiles
no C#, so a local module ships none.

### Config fragments

A fragment is the smallest statement of a difference. A consumer that changes one value writes one key; everything else stays as bundled,
and a key it does not know is still rejected by the config's own type, which validates the merged result exactly as it validates a shipped
config. Lists replace rather than append, because an appended list is hard to read back. The merge happens in `Get-Config`, where every
config is read, so no caller knows an overlay exists.

### Function overrides

The bundle's own code keeps calling a replaced function the way it always has, so an override keeps the original's contract, and it replaces
a function the module already has — never adds one, which would be a new module hidden inside a bundled one. The replacement reaches every
caller. In pwsh that takes two steps: the override file is loaded inside the module's own scope, which reaches the module's callers, its
state, and module-scoped mocks; and a public override is published to the session, where the import had put the original, which reaches the
session and every other module. Its script block stays bound to the module, so it runs in the module's scope wherever it is called from.

### Asset overrides

A module finds its own content through one lookup ([internal-asset-dependencies](internal-asset-dependencies.md#rule-adr-auto-assetdep1)),
so an asset override needs no step of its own: that lookup returns the overlay's file when the overlay replaces the asset. Only assets are
looked up there; configs merge through `Get-Config`, and nothing else a module ships is replaced wholesale.

### Sealed configs

Some configs describe the engine rather than the consumer's environment: which configs exist, which modules may depend on which, which
modules a profile holds, how the bundle exports itself, and the vocabulary. Changing one in a consumer would describe an engine that does
not exist, so they are sealed in the one place every config is registered.

### Checked as a whole

`Assert-CatzcOverlay` checks every entry against these rules and reports every violation at once; `Import-CatzcOverlay` runs it before it
applies anything, so an overlay applies whole or not at all, and a consumer's pipeline can run it alone to fail early. In source mode there
is no bundle to change — the catzc tree is `automation/` itself — so the overlay is not read.

### Local modules

What a consumer adds rather than changes — a new function, a new config, a new asset — goes in a module of its own, written the way catzc's
own modules are written, so a consumer learns no second convention. It loads last, after the bundle and the overrides, and calls the bundle
like any module does. It is built in the session from its files — private functions, then public ones, the order a built module's merge uses
— so nothing is written to load it; `Get-Config` finds its configs and `Get-CatzcModuleRoot` its folder, in the overlay. A local public
function may not take a loaded command's name, because that would replace a bundled function behind the contract check's back; replacing one
is what an override is for.

### How this is enforced

- **`Catzc.Base.Repository`** derives the overlay root (`Get-CatzcOverlayRoot`, build mode only), returns an overlay asset from
  `Get-CatzcModuleRoot`, and resolves a local module's folder in the overlay.
- **`Catzc.Base.Config`** merges a fragment in `Get-Config` (`Merge-ConfigFragment`), validates the result with the config's type, refuses a
  fragment of a config the registry seals (`ConfigsConfig.sealedConfigs`), and discovers a local module's configs.
- **`Catzc.Base.Overlay`** inventories the overlay (`Get-CatzcOverlay`), checks it (`Assert-CatzcOverlay`, with the shared function-file
  check `Get-FunctionFileViolation`, the contract check, and the local-module check), and applies function overrides and loads local modules
  (`Import-CatzcOverlay`), which the importer runs at the end of a bundle load.
- **Tests** prove the merge, the sealing, the asset lookup, every check, a function override reaching every caller, and a local module
  loading with its configs, in a built bundle.

## Consequences

- A consumer changes a bundle without forking it, and upgrades by installing the next bundle; its overlay carries over, and a contract break
  in an override fails at load instead of at run time.
- What a consumer changed is a folder to read, not a diff to reconstruct.
- A sealed config cannot be changed by a consumer at all; a consumer that needs one changed asks for a different bundle.
- The cost is one more folder convention, the same one catzc's own modules use, and a check that runs on every bundle load with an overlay.

## Related

- [platform-bundle](platform-bundle.md) — the built bundle the overlay changes.
- [sensible-defaults](sensible-defaults.md) — the resolution order a config fragment extends.
- [internal-asset-dependencies](internal-asset-dependencies.md) — the one lookup of a module's content an asset override goes through.
- [one-living-version](../principles/one-living-version.md) — why a consumer overlays rather than forks.
- [run-modes](../design/run-modes.md) — source and build mode; the overlay applies in build mode only.
