# Configuration: Module config loading — one reader (Get-Config), typed configs

## Rules: ADR-CONF-LOADING

### Rule ADR-CONF-LOADING-CONFIGONEREADER

All config reads go through one public reader, asked by the config's global name — no function re-reads a `configs/*.yml` file directly or
keeps its own config cache.

- [Decision](#decision)

### Rule ADR-CONF-LOADING-EXISTENCEDISCOVERED

Existence is discovered, not declared — a private seam (`Resolve-ConfigEntry`) scans `pwsh/*/configs/` for `<name>.yml` and resolves it to
its owning module. A name is global; `-Module` is only for disambiguating the same name in several modules, and
`Get-Config -Config <name> -ListOwners` lists those modules — for a config that modules opt into by shipping it.

- [Discovery](#discovery)

### Rule ADR-CONF-LOADING-CACHEBYPATH

Parse ordered, cache by resolved file path (`$script:configCache`), and invalidate only by re-import — the path key means a fixture path and
the real path never collide.

- [Decision](#decision)

### Rule ADR-CONF-LOADING-CSHARPCONFIGTYPE

Every shipped config has a **C# config type**, registered in `Catzc.Base.Config/configs/configs.yml` as `<name>: { type: <C# FQN> }`.
`Get-Config` constructs `[type]::new($dict)` once, on the cache miss; the constructor both maps and validates, and reports every violation
in one exception. `Test-ShippedConfigs` is the gate: every shipped config has an entry, every entry names a shipped config and a type that
resolves, and every shipped config loads.

- [Typed configs](#typed-configs)

### Rule ADR-CONF-LOADING-POWERSHELLVALIDATOR

A config that cannot ship a C# type validates with a **PowerShell validator**: an engine function found by a naming convention, or named
explicitly, run in the owning module's scope. This is the extension point for the tracks and deployable-units that carry their own
configuration; core configs never use it. A gate checks that every validator maps to a shipped config of its module.

- [The PowerShell extension point](#the-powershell-extension-point)

### Rule ADR-CONF-LOADING-READINGISGLOBAL

Reading a config is global access — never guarded by dependencies. Only `Get-Config` is public; the config types live in the owning module's
`types/`, and a PowerShell validator stays **private** to its owning module.

- [Decision](#decision)

### Rule ADR-CONF-LOADING-THREESCOPES

Every registered config has a `scope`, declared once in its `configs.yml` entry with `module` as the default: `engine` (sealed, no fragment
reaches it), `module` (overridable by a `.catzc/` fragment merged key by key), or `working-root` (describes the repository rather than the
engine). The registry is the only place a scope is declared.

- [Declared scopes](#declared-scopes)

### Rule ADR-CONF-LOADING-WORKINGROOTREADWHOLE

In build mode a `working-root` config is read whole from the working root's `.catzc/configs/<name>.yml`, never merged onto the bundled file,
and takes its type's default when that file is absent. In source mode catzc is its own working root, so the read is the module's own file,
unchanged.

- [The working-root read](#the-working-root-read)

## Context

A module's internal config lives in `<module>/configs/<name>.yml`, the module's conventional configs folder. Reading one is always the same
job: find the file, assert it exists, parse the YAML, optionally validate (or map) it, and cache the result so the file is read once per
session (see [caching](../automation/caching.md)).

Copy-pasted load/cache/validate boilerplate, and one wrapper per config, is exactly the kind of drift this codebase avoids: a per-module
reader wrapper would force callers to know which wrapper owns which config and to wire validation by passing in the owning module's closure.

## Decision

There is **one** public reader: **`Get-Config -Config <name> [-Module]`** (in `Catzc.Base.Config`). Every config read goes through it; no
other function reads a config file or keeps its own config cache. It:

1. resolves the name to its owning module and file path via the private seam `Resolve-ConfigEntry`, which scans `pwsh/*/configs/` for
   `<name>.yml`;
2. returns the cached object if `$script:configCache` already has the resolved path (same reference every call);
3. asserts the file exists and parses it as an ordered dictionary (`ConvertFrom-Yaml -Ordered`);
4. constructs the registered C# config type from the raw dict, once, on the cache miss — or returns the raw dict when no type is registered;
5. caches the result keyed on the resolved file path. Re-running the importer is the only invalidation (see
   [caching](../automation/caching.md)).

### Discovery

`Discovery, not per-module wrappers`

A config name is **global**. `Resolve-ConfigEntry` builds a one-time `name → entries` index by scanning every `pwsh/<module>/configs/*.yml`,
then resolves the requested name to a single `@{ Name; Module; Path }`. The owning module is _discovered_ from where the file lives — not
declared by a wrapper and not passed by the caller. `-Module` exists only to disambiguate the rare case of the same config name in two
modules; the seam throws on an **unknown** name and on an **ambiguous** name (asking for `-Module`).

A few configs are shipped by several modules on purpose: each module opts in by shipping its own file, and a reader wants all of them — a
module's `configs/glossary.yml`, its part of the controlled vocabulary, is one. `Get-Config -Config <name> -ListOwners` lists every owner's
entry, sorted by module name (ordinal) and empty when no module ships the name, without loading anything; the reader then loads each with
`-Module`, so every file still goes through the one cached, validated read.

`Resolve-ConfigEntry` is also the test seam: mock `Resolve-ConfigEntry` to return a fixture entry and the read redirects to a fixture file
(see [test-automation](../automation/test-automation.md)).

### Typed configs

`Every shipped config is a C# type`

A config's shape is a **C# config type** in its owning module's `types/` — a YAML mirror with snake_case properties that derives
`DictionaryRecord` (see [native-csharp-types](../automation/BCL/native-csharp-types.md)). The registry,
`Catzc.Base.Config/configs/configs.yml`, binds each config name to its type, and `Get-Config` constructs `[type]::new($dict)`: the
constructor maps the ordered dict into a typed object and validates it, collecting every violation into one `ArgumentException`. A malformed
config therefore never produces an instance, and every consumer reads typed properties.

The registry validates itself through its own type, `Catzc.Base.Config.ConfigsConfig`: each entry holds exactly one non-blank `type`. An
unregistered config — a test fixture, or a config checked through the PowerShell extension point — is returned **raw**, as the ordered dict.
`Test-ShippedConfigs` keeps the registry and the shipped configs in step: a shipped config without a type, an entry without a shipped
config, a type that does not resolve, and a shipped config that does not load are each an issue.

### Declared scopes

`Three scopes, declared once per entry`

A registry entry reads `<name>: { type: <C# FQN>, scope: <scope> }`, and `scope` is optional: an entry without it is `module`. The three
values say who may change a config and where its file comes from ([ADR-CONF-LOADING-THREESCOPES](#rule-adr-conf-loading-threescopes)):

| `scope`        | What the config is                                           | What a consumer's `.catzc/` may do                        |
| -------------- | ------------------------------------------------------------ | --------------------------------------------------------- |
| `engine`       | Intrinsic to the engine: the registry, the dependency graph  | Nothing; a fragment of it is rejected                     |
| `module`       | A module's setting (the default)                             | A fragment states the keys that differ, merged key by key |
| `working-root` | Describes the repository: its tracks, DRS, plans, links, ... | Replace the whole config with `.catzc/configs/<name>.yml` |

Which entries are `engine` and which `working-root` is decided in the registry, entry by entry; code never branches on a config name. A
config with the `working-root` value is `variants`, `drs`, `plans`, `links`, `file-limits`, `go` or `python`, for example: each describes
the repository the tools run over, not the engine that runs them. Sealing more, or reading more from the working root, is a reviewed edit to
the registry, never code ([consumer-overlay](../automation/consumer-overlay.md#rule-adr-auto-overlay-sealedengineconfigs)).

### The working-root read

`Whole file, or the type's default`

A repository-describing config merged onto catzc's own would leave a consumer with catzc's tracks and DRS domains and only the power to add
to them. In build mode `Get-Config` therefore reads a `working-root` config from `.catzc/configs/<name>.yml` of the working root alone
([ADR-CONF-LOADING-WORKINGROOTREADWHOLE](#rule-adr-conf-loading-workingrootreadwhole)): the bundled file is not read and no key is merged.
When the working root has no such file, the constructor receives an empty dict and the type's declared default applies
([sensible-defaults](../automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)), so an absent file is a valid, default
config, and a present file is validated by the same type as any other. The result is cached under the path actually read, as for every
config ([ADR-CONF-LOADING-CACHEBYPATH](#rule-adr-conf-loading-cachebypath)).

In source mode the working root is the repository the modules live in, so the config is read from the module's own `configs/` folder and
nothing differs from a `module` config without a fragment.

### The PowerShell extension point

`Invoke-ConfigValidator, for owners without a C# type`

Not every owner of a config can ship a C# type: types compile only from `pwsh/<module>/types/`, and a track or deployable-unit that carries
its own configuration rests on PowerShell extension points instead, one tech stack per track. For those, `Catzc.Base.ConfigExtensions` keeps
the PowerShell validator form. `Invoke-ConfigValidator -Config <dict> -Name <name> -Module <owner>` finds the validator by convention
(`Assert-<TitleCase(name)>Config`, so `widget-parts` → `Assert-WidgetPartsConfig`) or by `-Validator`, and runs it **in the owning module's
scope** — `& (Get-Module $owner) { … }` — so a private validator resolves. A conventional validator that does not exist is a no-op; a named
one that does not exist throws.

The extension point sits outside `Get-Config`, so the core reader stays one path (typed, or raw). `Test-ConfigValidators` guards the
convention: a validator whose name maps to no shipped config of its module is never called, so each one is an issue.

### Poka-yoke

| Situation                                     | What `Get-Config` does                                                                  |
| --------------------------------------------- | --------------------------------------------------------------------------------------- |
| `configs.yml` entry (`type:`)                 | Constructs the C# type — maps and validates, every violation in one exception           |
| No registry entry                             | Returns the **raw** ordered dict; `Test-ShippedConfigs` flags a typeless shipped config |
| Registry entry with no shipped config         | `Test-ShippedConfigs` flags it                                                          |
| `Assert-…Config` with no matching config name | Never invoked by `Invoke-ConfigValidator`; `Test-ConfigValidators` flags it             |
| Unknown name (no `<name>.yml` anywhere)       | `Resolve-ConfigEntry` **throws** — fail-fast, no silent empty read                      |
| Ambiguous name (`<name>.yml` in two modules)  | `Resolve-ConfigEntry` **throws**, asking for `-Module` — no accidental wrong file       |

## Consequences

- **Name once, read anywhere.** `Get-Config -Config ado` works from any module — no wrapper to find, no owner to remember, no closure to
  hand-pass.
- **Fail loud.** Unknown and ambiguous names throw at resolution; a missing file throws at read. There is no silent fall-through to an empty
  or wrong config.
- **Pluggable.** Adding a config is: drop `configs/<name>.yml`, write its C# config type in the module's `types/`, and add one `configs.yml`
  line. No edits to `Get-Config`, no new wrapper.
- **Validation is uniform and caller-independent.** It runs exactly once per file per session, at construction, no matter which module
  called `Get-Config` — and every consumer reads a typed object.
- One implementation of config I/O, caching, and validation; readers can't drift, and every read of a file shares the one
  `$script:configCache`.
- Test isolation is simple: mock the discovery seam (`Resolve-ConfigEntry`) or the whole boundary (`Get-Config`) — see
  [test-automation](../automation/test-automation.md).
