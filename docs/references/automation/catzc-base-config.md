---
catzc:
  derived:
    path: docs/references/automation/catzc-base-config.md
    kind: reference
    language: markdown
    filetype: md
    track: docs
    body_sha: "900ad440bd3c"
    links:
      - docs/.assets/references/automation/catzc-base-config/get-config-merge-seal-type.drawio.md
      - docs/.assets/references/automation/catzc-base-config/get-config-merge-seal-type.drawio.png
      - docs/adr/automation/BCL/native-csharp-types.md
      - docs/adr/configuration/config-value-addressing.md
      - docs/adr/configuration/module-config-loading.md
      - docs/references/automation/catzc-base-asserts.md
      - docs/references/automation/catzc-base-configextensions.md
      - docs/references/automation/catzc-base-objects.md
      - docs/references/automation/catzc-base-repository.md
---

# Catzc.Base.Config

The single config reader for the platform. It owns `Get-Config` — the one public function every module calls to find, parse, validate, and
cache a named config file — `Get-ConfigValue`, the by-reference addressing that resolves a `global.<config>.<key.path>` address to a value
on top of that reader, and the `configs.yml` registry that binds every shipped config to its C# config type. It does **not** own the config
types themselves (each lives in its owning module's `types/`), the config files they guard, the PowerShell validator extension point (that
is [Catzc.Base.ConfigExtensions](catzc-base-configextensions.md)), or the object-shaping helpers that manipulate already-loaded config
objects (those live in [Catzc.Base.Objects](catzc-base-objects.md)). The design is governed by
[module-config-loading](../../adr/configuration/module-config-loading.md).

## Responsibilities

| Responsibility   | Area       | Name                                                                       |
| ---------------- | ---------- | -------------------------------------------------------------------------- |
| responsibility:1 | loading    | [Config loading and caching](#responsibility1--config-loading-and-caching) |
| responsibility:2 | registry   | [Config type registry](#responsibility2--config-type-registry)             |
| responsibility:3 | addressing | [Config value addressing](#responsibility3--config-value-addressing)       |

### responsibility:1 — Config loading and caching

The unified path from a config name to a validated, cached object. `Get-Config` discovers the file by scanning
`automation/*/configs/<name>.yml` (via the private `Resolve-ConfigEntry` seam), parses it as an ordered dictionary, constructs its
registered C# config type — which maps and validates it — and stores the result keyed by resolved file path; a config with no registered
type comes back raw. Every subsequent call for the same name returns the cached reference; the file is read once per session. Unknown and
ambiguous names throw immediately; there is no silent fall-through. The full design — discovery, typed configs, poka-yoke table — is in
[module-config-loading](../../adr/configuration/module-config-loading.md).

### responsibility:2 — Config type registry

A `configs.yml` file that binds each shipped config name to its C# config type (`<name>: { type: <C# FQN> }`). `Get-Config` constructs
`[type]::new($dict)`, so the type both maps and validates the ordered dict into a typed object and reports every violation at once.
`ConfigsConfig` (`Catzc.Base.Config.ConfigsConfig`) is the C# type that validates this registry file itself and exposes its entries. The
quality gate `Test-ShippedConfigs` keeps the registry and the shipped configs in step. See
[native-csharp-types](../../adr/automation/BCL/native-csharp-types.md) for the type mechanism.

### responsibility:3 — Config value addressing

A global config address `global.<config>.<key.path>` names one node — a leaf value or a subtree — inside a named config, resolved by
`Get-ConfigValue` on top of `Get-Config`, so there is still one reader and one cache. The first segment after `global.` is the global config
name (the owning module is discovered, not part of the address); each following segment is a key walked into the parsed config, over a raw
ordered dictionary or a typed object alike. The key path is optional — `global.<config>` addresses the whole config as a subtree. An address
is the by-reference form of a config value: committable as data, dereferenced wherever a value is wanted without re-reading a file, and
always read-only. Because an address only ever reaches version-controlled config, nothing addressable is a secret. The design is in
[config-value-addressing](../../adr/configuration/config-value-addressing.md).

## What the module does

This module is a single-function reader with a typed back-end. Responsibility 1 is the invariant: `Get-Config` is the one place in the
platform where a config file is opened, parsed, and cached. No other module keeps its own cache, re-reads a file, or re-implements
parse-and-validate. Because validation is the config type's constructor, it is caller-independent — the same validated object comes back no
matter who asked.

Responsibility 2 is the binding between a config file and its shape. Adding a config is a file, a C# type in the owning module, and one
registry line — no change to the reader. The registry file is validated by `ConfigsConfig`, which is itself loaded through `Get-Config` —
the mechanism eats its own cooking.

Responsibility 3 is a thin read on top of responsibility 1. `Get-ConfigValue` adds a grammar and a key-path walk over the object
`Get-Config` already loaded and cached — it opens no file and keeps no cache of its own, so the one-reader invariant holds. An address is
how a config value earns a written-down name: a `global.<config>.<key.path>` string is data a caller can commit and dereference at the point
of use, and its hard line at secrets (everything reachable is in git, so nothing addressable is secret) is what lets a consumer treat an
address-sourced value as non-secret.

The module is a member of the `Base` group and depends on [Catzc.Base.Repository](catzc-base-repository.md) for file-path resolution and on
[Catzc.Base.Asserts](catzc-base-asserts.md) for fail-fast assertions.

The diagram below draws one configuration read from the source. The name resolves to its config file, an overlay fragment is merged unless
the configuration is sealed, and the registered type is built from the result. The cache key carries the fragment's timestamp, so an edited
fragment is read again. Its [description](../../.assets/references/automation/catzc-base-config/get-config-merge-seal-type.drawio.md) walks
it step by step.

![Overlay merges unless sealed; the registered type builds it](../../.assets/references/automation/catzc-base-config/get-config-merge-seal-type.drawio.png)

## Division

The module's public function and configuration file, sorted into the responsibilities above.

| Responsibility                                | Function          |
| --------------------------------------------- | ----------------- |
| responsibility:1 — Config loading and caching | `Get-Config`      |
| responsibility:2 — Config type registry       | `configs.yml`     |
| responsibility:3 — Config value addressing    | `Get-ConfigValue` |
