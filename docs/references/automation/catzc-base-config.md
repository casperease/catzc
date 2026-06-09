# Catzc.Base.Config

The single config reader for the platform. It owns `Get-Config` — the one public function every module calls to find, parse, validate, and
cache a named config file — `Get-ConfigValue`, the by-reference addressing layer that resolves a `global.<config>.<key.path>` address to a
value on top of that reader, and the `configs.yml` override registry that lets a module substitute a custom validator or a C# type for the
default convention. It does **not** own the validators themselves (those are private to each owning module), the config files those
validators guard, or the object-shaping helpers that manipulate already-loaded config objects (those live in
[Catzc.Base.Objects](catzc-base-objects.md)). The design is governed by
[module-config-loading](../../adr/automation/module-config-loading.md).

## Domains

| Domain   | Area       | Name                                                               |
| -------- | ---------- | ------------------------------------------------------------------ |
| domain:1 | loading    | [Config loading and caching](#domain1--config-loading-and-caching) |
| domain:2 | registry   | [Override registry](#domain2--override-registry)                   |
| domain:3 | addressing | [Config value addressing](#domain3--config-value-addressing)       |

### domain:1 — Config loading and caching

The unified path from a config name to a validated, cached object. `Get-Config` discovers the file by scanning
`automation/*/configs/<name>.yml` (via the private `Resolve-ConfigEntry` seam), parses it as an ordered dictionary, runs validation in the
owning module's scope — so private validators resolve without any dependency on the caller — and stores the result keyed by resolved file
path. Every subsequent call for the same name returns the cached reference; the file is read once per session. Unknown and ambiguous names
throw immediately; there is no silent fall-through. The full design — discovery, owner-scope validation, poka-yoke table — is in
[module-config-loading](../../adr/automation/module-config-loading.md).

### domain:2 — Override registry

A `configs.yml` file that maps a config name to a non-default validator. The default convention (`Assert-<TitleCase(name)>Config` as a
private function in the owning module) covers most configs without any registration. The registry is for the cases it cannot express: a
`pwsh:` entry runs a custom-named validator in the owner's scope; a `type:` entry constructs `[type]::new($dict)` so a C# class both maps
and validates the ordered dict into a strongly-typed object. `ConfigsConfig` (`Catzc.Base.Config.ConfigsConfig`) is the C# type that
validates this registry file itself. See [native-csharp-types](../../adr/automation/BCL/native-csharp-types.md) for the type-entry
mechanism.

### domain:3 — Config value addressing

A global config address `global.<config>.<key.path>` names one node — a leaf value or a subtree — inside a named config, resolved by
`Get-ConfigValue` on top of `Get-Config`, so there is still one reader and one cache. The first segment after `global.` is the global config
name (the owning module is discovered, not part of the address); each following segment is a key walked into the parsed config, over a raw
ordered dictionary or a typed object alike. The key path is optional — `global.<config>` addresses the whole config as a subtree. An address
is the by-reference form of a config value: committable as data, dereferenced wherever a value is wanted without re-reading a file, and
always read-only. Because an address only ever reaches version-controlled config, nothing addressable is a secret. The design is in
[config-value-addressing](../../adr/automation/config-value-addressing.md).

## What the module does

This module is a single-function reader with a pluggable validation back-end. Domain 1 is the invariant: `Get-Config` is the one place in
the platform where a config file is opened, parsed, and cached. No other module keeps its own cache, re-reads a file, or re-implements
parse-and-validate. Because validation runs in the owning module's scope (not the caller's), it is caller-independent — the same validated
object comes back no matter who asked, and the owning module's private validators never need to be exposed.

Domain 2 is the escape hatch. Convention handles the common case for free; the registry is the mechanism for the unusual cases. When a
config's validation logic has a name that does not follow the `Assert-<TitleCase(name)>Config` pattern, or when the config warrants a
strongly-typed C# model, a single entry in `configs.yml` redirects `Get-Config` without any change to the reader itself. The registry file
is validated by `ConfigsConfig`, which is itself loaded through `Get-Config` — the mechanism eats its own cooking.

Domain 3 is a thin read on top of domain 1. `Get-ConfigValue` adds a grammar and a key-path walk over the object `Get-Config` already loaded
and cached — it opens no file and keeps no cache of its own, so the one-reader invariant holds. An address is how a config value earns a
written-down name: a `global.<config>.<key.path>` string is data a caller can commit and dereference at the point of use, and its hard line
at secrets (everything reachable is in git, so nothing addressable is secret) is what lets a consumer treat an address-sourced value as
non-secret.

The module is a member of the `Base` group and depends on [Catzc.Base.Repository](catzc-base-repository.md) for file-path resolution and on
[Catzc.Base.Asserts](catzc-base-asserts.md) for fail-fast assertions.

## Division

The module's public function and configuration file, sorted into the domains above.

| Domain                                | Function          |
| ------------------------------------- | ----------------- |
| domain:1 — Config loading and caching | `Get-Config`      |
| domain:2 — Override registry          | `configs.yml`     |
| domain:3 — Config value addressing    | `Get-ConfigValue` |
