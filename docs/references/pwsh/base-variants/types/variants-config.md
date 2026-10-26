# pwsh/Base.Variants/types/VariantsConfig.cs

The typed record for `configs/variants.yml`, the repo-wide variants ([ADR-REPO-VARIANT](../../../../drs/repository/repo-variants.md)):
settings fixed for the importer session. It is registered in `Catzc.Base.Config/configs/configs.yml`, so `Get-Config -Config variants`
returns it; the private `Get-Variant` reads one key off it, and the named getters (`Get-AdoNaming`, `Get-EnabledCustomers`, `Get-Track`, …)
build on that. The properties mirror the YAML keys, so they are snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Keys

Every key is optional, and an unknown key throws, so a typo fails at load.

- **`ado_naming`** — `standard` or `classic`, the Azure resource-name order. The two values are spelled here as literals because this Base
  type must not depend up into the Azure layer that owns the name-order sets.
- **`git_workspace`** — `main-direct` or `main-via-pr`.
- **`have_customers`** — a bool (false for none, true for all), the literal `all`, or a list of unique customer names. It is kept as
  written; `Get-EnabledCustomers` is its single interpreter. Whether a listed name is a defined customer is checked one layer up, in the
  Azure layer.
- **`aspects`** — per track, an ordered list of single-key `{name: [patterns]}` entries
  ([DDR-ASPECT](../../../../drs/design/module-aspects.md)), each one a VariantAspect. Only the structure is checked here; glob syntax is the
  Globs aspect engine's check.
- **`tracks`** — per track, in declared order, its `members`, `type`, `vendor`, `languages`, `execution_engines`,
  `module_execution_engines`, `kinds`, `namespace`, `join` and `namespace_exempt` ([DDR-TRACK](../../../../drs/design/tracks.md)); each
  entry becomes a VariantTrack. Whether each language is a registered file language is an integrity test in `Catzc.Base.Languages`.

## Validation and defaults

Constructing the record validates the whole file and gathers every violation into one `ArgumentException`. The defaults are declared once,
on this type
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)); a getter
reads the typed property and never restates them. A track's name is checked in the repository normal form by `Test-TrackDeclaration`, not
here: this type holds no naming policy.
