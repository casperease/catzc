# pwsh/Base.Config/private/Resolve-ConfigEntry.ps1

The private discovery seam of `Get-Config`: it indexes the configs shipped by the loaded modules and resolves a name to its owning module
and file.

## help

### synopsis

Resolves a config name to its owning module and file path (the discovery seam).

### description

Scans `<module>/configs/*.yml` under the loaded code root (Get-CatzcModulesRoot — the source tree's pwsh/ or a built package) once (cached)
into a (namespace, name) -> entries index, and resolves a requested name in one namespace to a single @{ Namespace; Name; Module; Path }. A
config's identity is its namespace and its name
([ADR-AUTO-CONSUMER-OWNCONFIGS](../../../../drs/automation/consumer-repository.md#rule-adr-auto-consumer-ownconfigs)), so catzc's `gadget`
and a consumer's `gadget` are two entries. -Module disambiguates a name present in more than one module of the namespace. Throws when the
name is unknown in the namespace or ambiguous within it. -All instead returns every entry of the name in the namespace, one per owning
module sorted by module name (ordinal), and nothing when no module has it — the listing for a config several modules opt into by shipping
it. Mock this to redirect a config to a fixture in logic tests (see the test-automation record).

### parameter `Config`

The config name (without the .yml extension). Also bound as `-Name`.

### parameter `Module`

Disambiguates a name present in multiple modules of the namespace.

### parameter `Namespace`

The namespace the name resolves in; `Catzc` by default. A consumer's namespace is its track's `namespace`.

### parameter `All`

Returns every module's entry for the name instead of resolving a single one.

## Cache probe

The index entry is probed strict-clean
([ADR-PWSH-CACHE-STRICTSAFEPROBE](../../../../drs/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe)).

## Split configs

A config is one file, or a folder of disjoint parts (`configs/<name>/*.yml`) when one file would pass the length cap.

## Consumer namespaces

Once the `Catzc` index is whole, the consumer modules the importer registered (`Register-ConsumerConfigModule`, one call per module the
importer found by layout in a consumer track) are walked: each module's `configs/` indexes under its namespace, with the module's name and
folder on each entry. The resolver reads no track itself: the tracks are `Catzc.Base.Variants`'s, which depends on this module, so a build
that leaves it out still closes
([ADR-AUTO-BUNDLE-IMMUTABLEBUILD](../../../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild)). A source run
registers no module, so it indexes no consumer namespace.

A consumer module's `configs/configs.yml` is its registry, not a config: the registries of one namespace merge key by key, a name two of
them register is refused, and a type in the `Catzc.` namespace that catzc does not ship is refused (a consumer may register a type catzc
ships; one that resolves is the system's, a consumer's own would need a compiled type of its namespace). Each registry entry rides on the
index entry as `Registry`, and a registered name with no file is an entry with no path under its registering module. The registry is read
beside catzc's sealed one and is never merged into it. A failure while indexing the consumer part drops the whole index, so the next call
reads a fresh one. The folders are walked one level with `[System.IO.Directory]`, since `Get-ChildPath` sits in a module that depends on
this one.

## A registered type with no shipped file

Such a type is a config too: its type's namespace names the module, and it builds from an empty map plus the repository's fragment, so every
key takes the default the type declares.
