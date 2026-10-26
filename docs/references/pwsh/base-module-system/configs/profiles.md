# pwsh/Base.ModuleSystem/configs/profiles.yml

The named module sets that `Copy-CatzcModule -ModuleProfile` and `Test-InIsolation` start from.

## Seeds and expansion

Each profile is a seed list of module names. `Get-ModuleProfile` expands a seed to its declared-dependency closure (from `dependencies.yml`)
and adds the fixed infrastructure needed to load and test (`.internal`, `.compiled`, `.vendor`), so a profile pulls in everything it needs.
An empty seed means everything, the full repository.

## Validation

The file loads through `Get-Config -Config profiles` into the typed record ([ProfilesConfig](../types/profiles-config.md)): profile names
are snake_case, and each profile is a list of module names, possibly empty.
