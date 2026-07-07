# ADR: Module config loading — one reader (`Get-Config`), owner-scoped validation

## Rules: ADR-MODCFG

### Rule ADR-MODCFG:1

All config reads go through `Get-Config -Config <name>` (public, in `Catzc.Base.Config`) — no function re-reads a `configs/*.yml` file
directly or keeps its own `$script:` config cache.

- [Decision](#decision)

### Rule ADR-MODCFG:2

Existence is discovered, not declared — a private seam (`Resolve-ConfigEntry`) scans `automation/*/configs/` for `<name>.yml` and resolves
it to its owning module. A name is global; `-Module` is only for disambiguating the same name in two modules.

- [Discovery, not per-module wrappers](#discovery-not-per-module-wrappers)

### Rule ADR-MODCFG:3

Parse ordered, cache by resolved file path (`$script:configCache`), and invalidate only by re-import — the path key means a fixture path and
the real path never collide.

- [Decision](#decision)

### Rule ADR-MODCFG:4

Validation is resolved **in the owning module's scope** (`& (Get-Module $owner) { … }`), caller-independent. The default is convention: a
private `Assert-<TitleCase(name)>Config` in the owner module (e.g. `Assert-AdoConfig`), run once on the cache miss.

- [Validation runs in the owner's scope, by convention](#validation-runs-in-the-owners-scope-by-convention)

### Rule ADR-MODCFG:5

A `configs/configs.yml` registry overrides the convention per name: `<name>: { pwsh: <Fn> }` runs a custom-named validator in the owner's
scope, or `<name>: { type: <C# FQN> }` constructs `[type]::new($dict)` (the C# type both maps and validates). The registry is advanced;
raw + convention cover the common cases.

- [The registry override](#the-registry-override)

### Rule ADR-MODCFG:6

Reading a config is global access — never dependency-gated. The validators that shape it stay **private** to their owning module; only
`Get-Config` is public.

- [Decision](#decision)

## Context

A module's internal config lives in `<module>/configs/<name>.yml` (see [conventional-folders](../repository/conventional-folders.md)).
Reading one is always the same job: find the file, assert it exists, parse the YAML, optionally validate (or map) it, and cache the result
so the file is read once per session (see [caching](caching.md)).

Copy-pasted load/cache/validate boilerplate, and one wrapper per config, is exactly the kind of drift this codebase avoids: a per-module
reader wrapper would force callers to know which wrapper owns which config and to wire validation by passing in the owning module's closure.

## Decision

There is **one** public reader: **`Get-Config -Config <name> [-Module]`** (in `Catzc.Base.Config`). Every config read goes through it; no
other function reads a config file or keeps its own config cache. It:

1. resolves the name to its owning module and file path via the private seam `Resolve-ConfigEntry`, which scans `automation/*/configs/` for
   `<name>.yml`;
2. returns the cached object if `$script:configCache` already has the resolved path (same reference every call);
3. asserts the file exists and parses it as an ordered dictionary (`ConvertFrom-Yaml -Ordered`);
4. validates (or maps) the raw dict **in the owning module's scope**, once, on the cache miss;
5. caches the result keyed on the resolved file path. Re-running the importer is the only invalidation (see [caching](caching.md)).

Reading a config is **global access** — any function in any module calls `Get-Config -Config ado` and gets the same validated object. There
are no per-module reader wrappers and no dependency gating. The validators stay **private** to the module that owns the config; only
`Get-Config` is public.

### Discovery, not per-module wrappers

A config name is **global**. `Resolve-ConfigEntry` builds a one-time `name → entries` index by scanning every
`automation/<module>/configs/*.yml`, then resolves the requested name to a single `@{ Name; Module; Path }`. The owning module is
_discovered_ from where the file lives — not declared by a wrapper and not passed by the caller. `-Module` exists only to disambiguate the
rare case of the same config name in two modules; the seam throws on an **unknown** name and on an **ambiguous** name (asking for
`-Module`). This is also the test seam: mock `Resolve-ConfigEntry` to return a fixture entry and the read redirects to a fixture file (see
[test-automation](test-automation.md)).

### Validation runs in the owner's scope, by convention

A config's validator is a **private** function of its owning module, and a function in `Catzc.Base.Config` cannot see another module's
private functions from its own scope. The caller is not in the loop: `Get-Config` resolves validation against the owner it discovered, by
running in that module's session state — `& (Get-Module $owner) { … }`. From inside the owner's scope, its private functions resolve
normally.

The default is **convention**: `Get-Config` looks for a private `Assert-<TitleCase(name)>Config` in the owner (so `ado` →
`Assert-AdoConfig`, `pipeline-env` → `Assert-PipelineEnvConfig`) and, if it exists, runs it on the parsed dict. No file has to register
anything; dropping the validator next to the config is enough. If no such function exists, the config is returned **raw** — the unvalidated
ordered dictionary, which is the sensible default for a config that needs no shape checks.

### The registry override

A module may override the convention per config via `configs/configs.yml` in the owning module, mapping a name to one of two advanced
shapes:

- `<name>: { pwsh: <Fn> }` — run a **custom-named** validator (when the `Assert-<TitleCase(name)>Config` convention name does not fit) in
  the owner's scope.
- `<name>: { type: <C# FQN> }` — construct `[type]::new($dict)`; the C# type's constructor **both maps and validates** the ordered dict into
  a typed object. This is the advanced path for configs that warrant a strongly-typed model (see
  [native-csharp-types](BCL/native-csharp-types.md)).

The registry is for the cases convention cannot express. Most configs need neither — raw or a convention `Assert-…Config` covers them.

### Poka-yoke

| Situation                                         | What `Get-Config` does                                                                         |
| ------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| No validator, no registry entry                   | Returns the **raw** ordered dict — the sensible, zero-ceremony default                         |
| Private `Assert-<TitleCase(name)>Config` in owner | **Convention** — run it in the owner's scope, once, on the cache miss                          |
| `configs.yml` entry (`pwsh:` / `type:`)           | **Registry override** — custom validator, or C# `[type]::new($dict)` (map + validate)          |
| Validator exists but no matching config name      | Orphan validator is simply never invoked — config-driven, so a stray `Assert-…Config` is inert |
| Unknown name (no `<name>.yml` anywhere)           | `Resolve-ConfigEntry` **throws** — fail-fast, no silent empty read                             |
| Ambiguous name (same `<name>.yml` in two modules) | `Resolve-ConfigEntry` **throws**, asking for `-Module` — no accidental wrong file              |

## Consequences

- **Name once, read anywhere.** `Get-Config -Config ado` works from any module — no wrapper to find, no owner to remember, no closure to
  hand-pass.
- **Fail loud.** Unknown and ambiguous names throw at resolution; a missing file throws at read. There is no silent fall-through to an empty
  or wrong config.
- **Pluggable.** Adding a config is: drop `configs/<name>.yml`, and optionally either a private `Assert-<TitleCase(name)>Config`
  (convention) or a `configs.yml` entry (custom validator / C# type). No edits to `Get-Config`, no new wrapper.
- **Validation is uniform and caller-independent.** It runs exactly once per file per session, in the owner's scope, no matter which module
  called `Get-Config` — and the validators stay private.
- One implementation of config I/O, caching, and validation; readers can't drift, and every read of a file shares the one
  `$script:configCache`.
- Test isolation is simple: mock the discovery seam (`Resolve-ConfigEntry`) or the whole boundary (`Get-Config`) — see
  [test-automation](test-automation.md).

## Dora explains

A single config reader eliminates drift and ensures consistent validation, both core to reliable system behavior. This pattern reduces
variability in configuration handling across modules, lowering defect rates and deployment risk.

- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — one reader eliminates boilerplate and drift across modules.
- [Version control](https://dora.dev/capabilities/version-control/) — configs flow through a single validation gate, making their state
  auditable and consistent.
- [Pervasive security](https://dora.dev/capabilities/pervasive-security/) — validation is owner-scoped and centralized, reducing the surface
  for misconfiguration.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
