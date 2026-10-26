# pwsh/Base.Maps/types/MapsLimits.cs

The `limits` section of `configs/maps.yml`: the page size in PDF points, the smallest font size a label may shrink to, and the longest
track and file-language name a row or column header prints before it is shortened. `MapsConfig` validates the section (every value
positive) and builds one.

## Defaults

The defaults are declared here, once
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)): an A4
landscape page of 842 by 595 points, a minimum font size of 6, 24 characters for a track name and 16 for a file-language name. The
properties mirror the YAML keys, so they are snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
