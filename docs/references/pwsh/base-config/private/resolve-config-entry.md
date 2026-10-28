# pwsh/Base.Config/private/Resolve-ConfigEntry.ps1

The private discovery seam of `Get-Config`: it indexes the configs shipped by the loaded modules and resolves a name to its owning module
and file.

## help

### synopsis

Resolves a config name to its owning module and file path (the discovery seam).

### description

Scans `<module>/configs/*.yml` under the loaded code root (Get-CatzcModulesRoot — the source tree's automation/ or a built package) once
(cached) into a name -> entries index, and resolves a requested name to a single @{ Name; Module; Path }. -Module disambiguates a name
present in more than one module. In build mode the scan also covers a consumer overlay's local modules — the folders under
.catzc/automation/ that name no bundled module ([ADR-AUTO-OVERLAY](../../../../drs/automation/consumer-overlay.md)) — so a local module's
configs are found like any module's. Throws when the name is unknown or ambiguous. -All instead returns every entry of the name, one per
owning module sorted by module name (ordinal), and nothing when no module has it — the listing for a config several modules opt into by
shipping it. Mock this to redirect a config to a fixture in logic tests (see the test-automation record).

### parameter `Config`

The config name (without the .yml extension).

### parameter `Module`

Disambiguates a name present in multiple modules.

### parameter `All`

Returns every module's entry for the name instead of resolving a single one.

## Cache probe

The index entry is probed strict-clean
([ADR-PWSH-CACHE-STRICTSAFEPROBE](../../../../drs/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe)).

## Split configs

A config is one file, or a folder of disjoint parts (`configs/<name>/*.yml`) when one file would pass the length cap.

## A registered type with no shipped file

Such a type is a config too: its type's namespace names the module, and it builds from an empty map plus the repository's fragment, so every
key takes the default the type declares.
