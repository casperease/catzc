# pwsh/Base.Maps/types/MapsPin.cs

One reviewed highlight entry of `configs/maps.yml`, an item of `highlight.pins` or `highlight.exceptions`: an ADR code (optionally one rule
of it, the code followed by `#n`), the cell it names (a track and a file language), and why it was reviewed.

## Pin and exception

A pin lights the cell for the ADR. An exception keeps the cell dark although the ADR's citations would light it, which is a passing mention.

## Validation

`MapsConfig` validates the shape. Whether the track and the file language exist is checked against their registries where the map is built.
The properties mirror the YAML keys, so they are snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
