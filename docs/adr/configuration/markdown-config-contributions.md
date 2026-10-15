---
catzc:
  derived:
    path: docs/adr/configuration/markdown-config-contributions.md
    kind: adr
    body_sha: e8192d50ae2b
    defines:
      - ADR-CONF-MDCONTRIB#{1-7}
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-EXTEND#3
      - ADR-AUTO-OVERLAY#{4,7}
      - ADR-CONF-ADDRESSING#3
      - ADR-CONF-LOADING#{1,3-5}
    links:
      - docs/adr/automation/consumer-overlay.md#rule-adr-auto-overlay4
      - docs/adr/automation/consumer-overlay.md#rule-adr-auto-overlay7
      - docs/adr/automation/open-closed-architecture.md#rule-adr-auto-extend3
      - docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6
      - docs/adr/configuration/config-value-addressing.md#rule-adr-conf-addressing3
      - docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading1
      - docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading3
      - docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading4
      - docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading5
---

# ADR: Markdown config contributions — config values stated in a source-controlled Markdown file

## Rules: ADR-CONF-MDCONTRIB

### Rule ADR-CONF-MDCONTRIB:1

A **config contribution** is one config value, a key path and its value, that an author states in the `config` part of a tracked Markdown
file's meta block and that `Get-Config` gathers into the named config. A contribution is authored and source-controlled; a derived value is
never a contribution. The value lives beside the prose it describes, and the config is the one place a reader looks it up.

- [Decision](#decision)
- [What a contribution is](#what-a-contribution-is)

### Rule ADR-CONF-MDCONTRIB:2

Contributions are gathered inside the one reader, never beside it ([ADR-CONF-LOADING#1](module-config-loading.md#rule-adr-conf-loading1)).
`Get-Config` merges them key by key with the same merge an overlay fragment uses, so one mechanism joins every source. A setting resolves in
this order: the caller's explicit value; the consumer overlay fragment; the contributions, in ordinal order of their file paths; the bundled
`configs/<name>.yml`; the setting's declared default ([ADR-AUTO-DEFAULT#6](../automation/sensible-defaults.md#rule-adr-auto-default6)).

- [One reader, one order](#one-reader-one-order)

### Rule ADR-CONF-MDCONTRIB:3

A config takes contributions only when it opts in. Its entry in the config registry (`configs.yml`) lists the `markdown_sources` globs it
gathers from, and a contribution outside those globs is rejected. A sealed config
([ADR-AUTO-OVERLAY#7](../automation/consumer-overlay.md#rule-adr-auto-overlay7)) never opts in, so the registry itself cannot be changed by
prose and the reader never gathers while it loads its own registry.

- [Opt in, by glob](#opt-in-by-glob)

### Rule ADR-CONF-MDCONTRIB:4

Two contributions never state the same key path. The load fails and names both files and the key path; it never keeps the last one. A list
is replaced whole and never appended to, as for an overlay fragment
([ADR-AUTO-OVERLAY#4](../automation/consumer-overlay.md#rule-adr-auto-overlay4)), so a list stated by one file is the whole list.

- [Conflicts fail](#conflicts-fail)

### Rule ADR-CONF-MDCONTRIB:5

The config's own type validates the merged result, exactly as for a config without contributions
([ADR-CONF-LOADING#4](module-config-loading.md#rule-adr-conf-loading4)). A rejected value reports the file, the line and the key path of the
contribution that carries it. A contribution never bypasses the type.

- [Validated by the config's type](#validated-by-the-configs-type)

### Rule ADR-CONF-MDCONTRIB:6

The cache key of a config with contributions carries the stamp of every contributing file, so an edited file is never served from a stale
merge ([ADR-CONF-LOADING#3](module-config-loading.md#rule-adr-conf-loading3)). Contributions are tracked content, so nothing a contribution
states is a secret ([ADR-CONF-ADDRESSING#3](config-value-addressing.md#rule-adr-conf-addressing3)).

- [Cached and committed](#cached-and-committed)

### Rule ADR-CONF-MDCONTRIB:7

A contribution belongs to a gather meta kind, and the kind names the config it feeds. A module subscribes a reader for a kind by shipping a
function named for it, found by convention, as a config validator is
([ADR-CONF-LOADING#5](module-config-loading.md#rule-adr-conf-loading5)). `Get-Config` names no kind and no module.

- [Kinds and readers](#kinds-and-readers)

## Context

Several configs are lists of things that have a Markdown file of their own. An agent definition is a file, and the agent registry lists the
same agent a second time. An ADR is a file, and a few of its settings sit in `adrs.yml`. Two files that state one fact drift: the registry
gains an entry the file does not have, or the file changes and the registry keeps the old line. A gate can report the drift, but the cheaper
fix is one statement, made where the thing is.

A Markdown file carries structured front matter for other tools, so the statement has a natural home. What it lacks is a way into the config
system that keeps the rules of that system: one reader, one resolution order, typed validation, a cache that never serves a stale value, and
nothing secret.

## Decision

A tracked Markdown file states a config contribution in the `config` part of its meta block, and `Get-Config` gathers it into the config
that opted in to it.

### What a contribution is

`A contribution is a key path and a value`

A contribution names a config, a key path inside it, and a value. It is data an author wrote, in a file a reviewer reads with the prose it
belongs to. It is not a command and carries no logic. The meta block, its two parts, and the kinds that shape a contribution are the
meta-block decision's to define; this decision defines only what happens to a contribution once it is gathered.

### One reader, one order

`Contributions join the existing merge`

The overlay fragment merges onto the bundled config key by key before the config's type validates the result
([consumer-overlay](../automation/consumer-overlay.md#rule-adr-auto-overlay4)). Contributions use the same merge, placed between the bundled
file and the overlay, so a consumer's overlay has the last word and the bundled file is the base. The order is fixed and written once, so a
value never depends on which file the reader happened to open first: contributions apply in the ordinal order of their repository paths.

### Opt in, by glob

`A config chooses its sources`

Gathering every Markdown file for every config would make each `Get-Config` call scan the repository, and would let any prose change any
config. A config instead lists the globs it gathers from in the registry, so the scan is bounded and a reviewer sees, in one place, which
files can change which config. The registry is validated by its own type, and a sealed config cannot list globs.

### Conflicts fail

`Two statements of one value are an error`

When two files state the same key path, neither is right by position. The load fails and names both, so the authors decide. A silent
last-wins would make a value depend on file ordering, and a silent first-wins would hide the second file's intent.

### Validated by the config's type

`The type is the gate`

Every config has a C# type that maps and validates it. A contribution reaches that type like any other value, after the merge, so a wrong
shape, an unknown key or a value outside its range fails with the same message it would give in the bundled file, plus the contribution's
file and line.

### Cached and committed

`The stamp of each file is part of the key`

The reader caches a config per resolved file. With contributions, the key adds each contributing file's stamp, as it adds the overlay
fragment's, so editing a Markdown file is seen by the next read. Contributions are tracked files, which is why the same hard line holds as
for addresses: nothing a contribution states is secret.

### Kinds and readers

`The reader for a kind is a function a module ships`

A kind is declared in the meta-kind registry, and its reader is a function found by convention, so a new kind is a registry entry and a
function file, with no edit to `Get-Config`. The loader stays content-agnostic
([ADR-AUTO-EXTEND#3](../automation/open-closed-architecture.md#rule-adr-auto-extend3)).

### How this is enforced

- **`Get-Config`** gathers the contributions of an opted-in config and merges them in the order of Rule 2.
- **`Test-ShippedConfigs`** fails a `markdown_sources` entry on a sealed config, and a glob that matches no tracked Markdown file.
- **`Test-FileMeta`** fails two contributions to one key path and a contribution outside its config's globs.
- **`Test-FileMetaProcessors`** fails a gather kind whose reader function is missing, and a reader no kind names.

## Consequences

- A fact about a thing is stated once, in the file of the thing, and the config that needs it reads it from there. A registry that mirrors a
  set of files needs no gate to keep it in step.
- The resolution order of a setting has a named step for contributions, written in one place. A consumer's overlay overrides it.
- A Markdown file can change a config, so the set of files that may do so is declared per config and bounded by globs. A reviewer reads the
  glob list, not the repository.
- A contribution is only as safe as the config's type: a config whose type accepts anything accepts anything from prose too, which is why
  the registry requires a typed config to opt in.
