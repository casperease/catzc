# pwsh/Base.ModuleSystem/types/ProfilesConfig.cs

The typed record for `profiles.yml`, the named module sets used by `Copy-CatzcModule -ModuleProfile`, `Test-InIsolation` and the exporter. Each
profile is a seed list of module names that `Get-ModuleProfile` expands to its declared-dependency closure plus the fixed infrastructure; an
empty seed means the full repository. The record is registered in `Catzc.Base.Config/configs/configs.yml`, so `Get-Config -Config profiles`
returns it. Its properties mirror the YAML keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing the record maps and validates the parsed YAML and gathers every violation into one `ArgumentException`:

- only the top-level key `profiles` is allowed, and it is a required, non-empty map;
- each profile name is snake_case;
- each profile is a list, possibly empty, of non-empty module names, never a single string or a map.

Module-name existence is not checked here. That is `Get-ModuleProfile`'s concern.

## Properties

- **`profiles`** — profile name to its seed module names (`string[]`, possibly empty), in declaration order, read-only.
