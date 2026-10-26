# pwsh/Base.Maps/types/MapsPalette.cs

The `palette` section of `configs/maps.yml`: the page background, the fill colours of the track rows, the file-language columns, an empty
cell and the fullest cell, the grid lines, the text, a stack-violation mark and a lit cell's outline, each a `#` and six hex digits.
`MapsConfig` validates the section and builds one.

## Defaults

The defaults are declared here, once
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)), and
they are the dark-theme tokens of the diagram kit (`python/diagrams/assets/STYLE.md`), which the slide minimaps share: the dark page, light
text, an idle cell in the band fill, a scale that rises from the idle fill to the light ink, the kit's only red for a violation mark, and
the light ink as the lit colour.

## Shape

The properties mirror the YAML keys, so they are snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
