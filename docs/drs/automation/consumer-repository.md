# Automation: Consumer repository — a working root with a bundle installed is a catzc-shaped repository of its own

## Rules: ADR-AUTO-CONSUMER

### Rule ADR-AUTO-CONSUMER-OWNTRACKS

A consumer's own code lives in its own tracks, declared in the consumer's working-root `variants`
([DDR-TRACK-ISPLACEDCLUSTER](../design/tracks.md#rule-ddr-track-isplacedcluster)), each language track laid out like every other
([ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE](module-model.md#rule-adr-auto-module-everylanguagetrackalike)). A consumer track's module
namespace is its own and is never `Catzc`: the `Catzc` token is the system's
([PDR-CATS-CATZCISSOURCENAME](../principles/cats-and-catzc.md#rule-pdr-cats-catzcissourcename)), and a consumer that declares it is refused.

- [Own tracks](#own-tracks)

### Rule ADR-AUTO-CONSUMER-SOURCEMODULES

A consumer's pwsh modules are named `<Namespace>.<Folder>` and load from source through the same loader catzc's modules use, never a second
path ([PDR-ONELIVE](../principles/one-living-version.md)). Their order is the topological order of the consumer's own `dependencies.yml`
([ADR-AUTO-MODULE-TOPOLOGICALORDER](module-model.md#rule-adr-auto-module-topologicalorder)), which may name catzc's modules. They load after
the bundle and its `.catzc/` overrides, nothing is written to load them, and an edited file is live after the next import.

- [Modules from source](#modules-from-source)

### Rule ADR-AUTO-CONSUMER-OWNCONFIGS

A consumer registers its own configs in its own registry, `configs.yml` in a consumer module's `configs/`, read beside catzc's sealed
registry and never merged into it. A config's identity is its namespace and its name, so a consumer's `azure` and catzc's `azure` are two
configs. A bare name resolves in the namespace of the module that calls the reader, so catzc's call sites keep reading catzc's configs and a
consumer's read its own; `-Namespace` names another one. Only catzc's own configs are closed to a consumer, and a `.catzc/` fragment reaches
the module config scope only ([ADR-AUTO-OVERLAY-CONFIGFRAGMENT](consumer-overlay.md#rule-adr-auto-overlay-configfragment)).

- [Own configs](#own-configs)

### Rule ADR-AUTO-CONSUMER-OWNTYPES

A consumer's C# types compile in-process, from the consumer's module `types/*.cs`, into one `<Namespace>.Types.<hash>.dll` under the working
root's `out/`, against the catzc assembly already loaded, and are reused while the hash holds. Catzc's own types never compile in a bundle:
that assembly is prebuilt. A consumer's C# source declaring a `Catzc.` namespace is refused.

- [Own types](#own-types)

### Rule ADR-AUTO-CONSUMER-OWNDRS

A consumer's decision records are its own: the DRS tooling reads the working root's `drs.yml`, a working-root config read whole from the
working root, so its kinds, domains and records are its own, and catzc's records are never in a consumer's index.

- [Own decision records](#own-decision-records)

### Rule ADR-AUTO-CONSUMER-CATZCGATES

Catzc's quality gates are the consumer's CI: `Test-QualityGates`, then `Test-Automation`. The gates that need nothing of catzc's tree scan
the working root's tracks, in a consumer exactly as in the catzc repository; only the tools that exist to build catzc itself stay
catzc-source tools.

- [Gates as CI](#gates-as-ci)

## Context

A **consumer repository** is a working root with a bundle installed
([ADR-AUTO-BUNDLE-ISBUILD](platform-bundle.md#rule-adr-auto-bundle-isbuild)), in a git repository or in a plain folder, and catzc-shaped on
top of the bundle: it holds its own code in its own modules, its own configs, types and decision records, and runs catzc's quality gates
over them. It changes catzc itself only through its overlay
([ADR-AUTO-OVERLAY-OVERLAYFOLDER](consumer-overlay.md#rule-adr-auto-overlay-overlayfolder)).

A consumer session has three roots, named here once:

- **The working root** — the consumer's own folder, `RepositoryRoot`: its tracks, its `.catzc/` overlay, its `drs.yml`, and the `out/` that
  every output goes to ([ADR-AUTO-BUNDLE-TWOROOTS](platform-bundle.md#rule-adr-auto-bundle-tworoots)).
- **The catzc code root** — where the loaded bundle lives, `CatzcModulesRoot`: read-only, and the root the run mode derives from
  ([DDR-RUNMODE-MODEISDERIVED](../design/run-modes.md#rule-ddr-runmode-modeisderived)).
- **The consumer tracks** — the tracks the working root's `variants` declares: where the consumer's own modules live.

The bundle alone lets a consumer run catzc's commands and, through the overlay, change what they do. It gives a consumer no place of its
own: an overlay folder that names no bundled module is not a module, and a bundle's registry and its tracks describe catzc, not the
consumer. The value of catzc to another team is the tooling — tracks, modules, configs, gates, decision records — applied to that team's
code, so the consumer needs each of those as its own, built from the same mechanisms, not copies of them
([PDR-ONELIVE](../principles/one-living-version.md)).

## Decision

A consumer is a catzc-shaped repository on top of the bundle. Each part of the shape uses the mechanism catzc's own repository uses, keyed
by the consumer's namespace instead of the `Catzc` token, so a consumer learns no second convention and the tooling holds one living version
of each behaviour. The run mode stays derived from catzc's code root, and the exclusion of the two modes
([DDR-RUNMODE-NEVERCOEXIST](../design/run-modes.md#rule-ddr-runmode-nevercoexist)) is about catzc's modules, not the consumer's.

### Own tracks

The consumer's `variants` is a working-root config: it is read whole from the working root, never merged onto catzc's, so a consumer
declares exactly the tracks it has. A track's module namespace is joined to each module folder's name, which keeps the folders short. The
`Catzc` token is refused because a module with it would be taken for one of the system's, which `Catzc.*` names alone say
([PDR-CATS-OUTSIDEMODULESUSECATS](../principles/cats-and-catzc.md#rule-pdr-cats-outsidemodulesusecats)).

### Modules from source

A bundle's modules are merged files; a consumer's modules are read from their folders by the loader the importer runs for catzc's own
modules, with a generated manifest, so a consumer function is one file and a diff touches one function. The consumer's `dependencies.yml` is
a module config of the consumer, so the order of its modules is derived like catzc's, and it may name catzc's modules as needs.

### Own configs

Existence is discovered in the consumer's tracks as it is in catzc's, and the consumer's registry types its configs. The namespace in a
config's identity is what removes the collision a bare, global name has: a consumer config named like a catzc config is a different config.
Catzc's configs stay closed except through a fragment, and a fragment cannot reach an engine config or a working-root config, which are read
whole ([ADR-AUTO-OVERLAY-SEALEDENGINECONFIGS](consumer-overlay.md#rule-adr-auto-overlay-sealedengineconfigs)).

### Own types

The compile is the in-process compile that source mode already uses, so it needs no SDK on the consumer's machine. The assembly name carries
the consumer's namespace, and its type accelerators carry the consumer's prefix, so they cannot meet catzc's. The `Catzc.` refusal keeps one
assembly's names from being taken by another's.

### Own decision records

A consumer decides for its own code in records of its own, and the tooling that registers, indexes and checks records is catzc's. Reading
the registry from the working root is what keeps the two sets of records apart.

### Gates as CI

`Test-QualityGates` runs every check the language registry declares over the working root's tracks and fails on any issue; `Test-Automation`
runs the tests. A consumer's pipeline is those two calls. A gate whose tool a consumer has not installed names the install command to run.

## Consequences

- A consumer gets tracks, modules in every catzc language, configs, types, decision records and CI that behave as catzc's do, without a fork
  and without a second loader.
- A consumer's namespace and catzc's cannot collide: not in module names, not in config identities, not in C# namespaces, not in
  accelerators.
- The cost is a namespace to carry in every consumer config read from another namespace, the in-process compile of a consumer's types, and
  the checks that keep a consumer from claiming `Catzc`.

## Related

- [consumer-overlay](consumer-overlay.md) — how a consumer changes the bundle itself, through `.catzc/`.
- [platform-bundle](platform-bundle.md) — the bundle and the two roots.
- [module-model](module-model.md) — how modules are found, shaped and ordered, for every language track.
- [run-modes](../design/run-modes.md) — source and build mode; the mode is derived from catzc's code root.
- [tracks](../design/tracks.md) — tracks and their module namespace.
- [cats-and-catzc](../principles/cats-and-catzc.md) — why the `Catzc` token is the system's.
- [one-living-version](../principles/one-living-version.md) — why a consumer uses the same mechanisms rather than copies.
