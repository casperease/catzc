# pwsh/Base.Drs/types/DrsDoraCheck.cs

The settings of the DORA-coverage check (`configs/drs-checks.yml`, `dora_coverage`), read by `Test-DrsRegistry`: every rule set of a domain
has exactly one section linking its record in the domain's DORA file. `DrsChecksConfig` builds and validates it.

## Keys

It mirrors the YAML mapping, so its properties are snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

- **`mode`** — `report` or `gate`. The default is `CheckMode`'s default, `gate`.
- **`file`** — the DORA file's name inside each domain folder. The default is `DefaultFile`.
- **`exempt`** — a map of domain name to the reason it keeps no DORA file
  ([PDR-CONFIG-EXCEPTIONISCONFIGENTRY](../../../../drs/principles/configure-not-program.md#rule-pdr-config-exceptionisconfigentry)). The
  default is none.
- **`exempt_folders`** — a map of a folder under `docs/drs/` (`external/azure/caf`) to the reason its records take no section in their
  domain's DORA file. They answer a vendor's checklist, grounded in the vendor's reference, not in DORA. The default is none.
