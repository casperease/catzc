# ADR: Config value addressing — a by-reference handle into a named config

## Rules: ADR-CFGADDR

### Rule ADR-CFGADDR:1

A _global config address_ has the form `global.<config>.<key>[.<key>…]` and names exactly one node inside a named config — a leaf value or a
subtree. It is resolved by `Get-ConfigValue` (public, `Catzc.Base.Config`), which is built on `Get-Config`, so there is still one config
reader and one config cache (ADR-MODCFG:1) — addressing is a walk over an already-loaded config, never a second reader.

- [Decision](#decision)
- [One reader underneath](#one-reader-underneath)

### Rule ADR-CFGADDR:2

The first segment after `global.` is the config's global name (ADR-MODCFG:2 — the name is global and the owning module is discovered, not
part of the address); each following segment is a key walked into the parsed config. Traversal works uniformly over a raw ordered dictionary
and a typed (C#/`Assert-…`-validated) object: each segment resolves as a dictionary key first, then as a property.

- [The address grammar](#the-address-grammar)
- [Traversal is uniform over dict and typed object](#traversal-is-uniform-over-dict-and-typed-object)

### Rule ADR-CFGADDR:3

An address references **only** version-controlled config (ADR-ASCODE): everything reachable by an address lives in a `configs/*.yml` file in
git, so anything addressable is non-secret by definition. Secrets never have addresses — they travel out-of-band as `[SecureString]`, handed
to an external consumer through the one sanctioned seam (ADR-ENVVAR:7).

- [Addresses are for committed config only](#addresses-are-for-committed-config-only)

### Rule ADR-CFGADDR:4

Resolution fails fast. An unknown or ambiguous config name (surfaced from `Get-Config`) throws, and a segment that resolves at neither a
dictionary key nor a property throws, naming the full address and the failing segment. A malformed address is rejected at parameter binding
by a `ValidatePattern`. There is no silent `$null` for a wrong path.

- [Fail fast, never silent null](#fail-fast-never-silent-null)

### Rule ADR-CFGADDR:5

A resolved node is a **read**. The returned value may be a live reference into the config cache (ADR-MODCFG:3) and must never be mutated —
mutating it would corrupt the shared cached config for every later reader. An address is the by-reference form of a config value: usable
anywhere a value is wanted without re-reading a file, and read-only like every other view of the cache.

- [A resolved node is a read, not a copy](#a-resolved-node-is-a-read-not-a-copy)

## Context

Configuration in this repo lives in `configs/*.yml`, read once through `Get-Config` and cached (ADR-MODCFG:1, ADR-MODCFG:3). A caller that
wants one value out of a config already has a way to get it: call `Get-Config -Config <name>` and index into the result. That is fine inside
a function, but it does not give a config value a _name that can be written down_ — a stable, committable reference that says "this env
var's value is that config node" without embedding the value itself.

Several jobs want exactly that written-down reference. Preparing an environment for a container or CLI (see
[environment-variables](environment-variables.md)) wants to say "`APP_NAME` comes from `global.myproperty.name`" and "expose the whole
`database` subtree as `DB_*`" — a reference to a config node, carried as data, resolved at the point of use. The alternative — copying the
literal value into the call — duplicates a value that already has a single source of truth in git, and drifts the moment the config changes.

So the need is a small, uniform grammar for "the value at this path in this config," resolved through the one reader, that a human can
commit and a tool can dereference.

## Decision

A global config address `global.<config>.<key>[.<key>…]` is a by-reference handle to one node inside a named config, resolved by
`Get-ConfigValue -Address <address> [-Module <module>]`. The address is data: it can live in a checked-in config, be passed as a string, and
be dereferenced anywhere a value is wanted.

### The address grammar

- The literal prefix `global.` marks the string as an address (and lets a consumer such as `Write-EnvironmentSet` distinguish an address
  from a bare literal).
- The next segment is the **config name** — the same global lowercase name `Get-Config` takes (kebab-case, ADR-MODCFG:2). The owning module
  is discovered, never written into the address; `-Module` on `Get-ConfigValue` is a passthrough to `Get-Config` for the rare name that
  exists in two modules.
- Each remaining segment is a **key** walked into the parsed config, in order. The key path is optional: `global.<config>` with no keys
  addresses the whole config as a subtree (its root node).

The grammar is fixed by a `ValidatePattern` on `Get-ConfigValue` so a malformed address is rejected at the call site, not deep in traversal.

### The address grammar, concretely

```powershell
Get-ConfigValue -Address 'global.myproperty.name'     # scalar leaf → the value at myproperty → name
Get-ConfigValue -Address 'global.database'            # subtree     → the whole database config node
Get-ConfigValue -Address 'global.azure.customers.contoso.shortname'   # deep leaf
```

### One reader underneath

`Get-ConfigValue` strips `global.`, splits the rest into `<config>` plus a key path, calls `Get-Config -Config <config> -Module <module>`,
and walks the key path with the private `Resolve-ConfigKeyPath`. It does not open a file or keep a cache of its own — it is a view over what
`Get-Config` already loaded and validated (ADR-MODCFG:1). The traversal lives in `Resolve-ConfigKeyPath` alone so `Get-ConfigValue` stays a
thin strip-split-walk and the walk is unit-testable in isolation.

### Traversal is uniform over dict and typed object

A config is either a raw ordered dictionary (no validator) or a typed object (a C# type or an `Assert-…`-validated shape) — see
[module-config-loading](module-config-loading.md). `Resolve-ConfigKeyPath` handles both with one rule per segment: resolve the segment as a
**dictionary key** when the current node is an `IDictionary` that contains it, otherwise as a **property** on the node. This keeps an
address agnostic to how its config happens to be modelled; the same `global.<config>.<key>` works whether the owner validates into a typed
object or leaves the config raw.

### Addresses are for committed config only

An address only ever reaches into a `configs/*.yml` file, which is version-controlled (ADR-ASCODE). It follows that nothing an address can
name is a secret: if it were addressable it would be sitting in git. This is deliberate and load-bearing — it is why a consumer can treat an
address-sourced value as non-secret and loggable, and why the secret channel is a wholly separate mechanism. Secrets have no address; they
are handed to an external process as `[SecureString]` through `Write-EnvironmentSet` (ADR-ENVVAR:7), never referenced by a `global.…`
string.

### Fail fast, never silent null

Every failure mode throws rather than returning `$null`, so a mistyped address surfaces at the call that made it:

- unknown or ambiguous config name — thrown by `Get-Config`/`Resolve-ConfigEntry` (an ambiguous name asks for `-Module`);
- a key segment that matches neither a dictionary key nor a property on the current node — thrown by `Resolve-ConfigKeyPath`, naming the
  full address and the segment that failed;
- a syntactically malformed address — rejected by the `ValidatePattern` at parameter binding.

A silent `$null` would let a wrong address flow downstream as an empty value and fail somewhere far from its cause; addressing never does
that.

### A resolved node is a read, not a copy

`Get-Config` returns the _same reference_ on every call (ADR-MODCFG:3), and `Get-ConfigValue` walks into that reference — so a resolved
subtree (or a leaf that is itself an object) may be a live view into the shared config cache. Callers treat a resolved node as read-only,
exactly as they must treat any value handed back by `Get-Config`. Mutating it would silently rewrite the config that every later reader
sees. An address is a _reference_ to a config value, with the same discipline a reference implies: read it, do not write through it.

## Consequences

- A config value has a written-down, committable name. "This env var's value is `global.database.host`" is expressible as data, resolved at
  the point of use, with the config file as the single source of truth — no copied literals to drift.
- There is still exactly one reader and one cache. `Get-ConfigValue` adds a grammar and a walk on top of `Get-Config`; it never re-reads a
  file or caches anything (ADR-MODCFG:1).
- Addressing draws a hard line at secrets: everything addressable is in git and non-secret, so a consumer can log an address-sourced value
  freely, and secrets stay entirely off the addressing channel (ADR-ENVVAR:7).
- Mistakes fail loudly at the call site — a wrong name or a wrong key throws with the offending address — instead of leaking a `$null`
  downstream.

## Dora explains:

DORA's research links version-controlled configuration and single source of truth to reliable, maintainable delivery. Providing a uniform
addressing grammar for config values ensures every reference points to a canonical, committed source and fails fast on mistakes.

- [Version control](https://dora.dev/capabilities/version-control/) — all addressable config lives in version-controlled files, making every
  reference traceable and auditable.
- [Code maintainability](https://dora.dev/capabilities/code-maintainability/) — a fixed address grammar and fail-fast validation make
  configuration handling clear and mistakes obvious.
- [Trunk-based development](https://dora.dev/capabilities/trunk-based-development/) — addressing enforces single source of truth for every
  config value, eliminating drift from copied literals.
- [DORA research program](https://dora.dev/research/) — the overview these findings sit within.
