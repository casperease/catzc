# pwsh/Base.Maps/types/MapsHighlight.cs

The `highlight` section of `configs/maps.yml`: the reviewed pins, which light a cell for an ADR, the reviewed exceptions, which keep one
dark, and the globs of the files whose citations light nothing (`citation_exclude`). `MapsConfig` validates the section and builds one.

## Defaults

The pin and exception lists default to empty, so the highlight follows the derived order alone. `citation_exclude` defaults to
`DefaultCitationExclude`: the session logs and plans under `.claude/`, every asset under `docs/**/.assets/` (the generated slide
descriptions), the explanation articles the slides illustrate under `docs/explanation/`, and the drawing tooling under `python/diagrams/`. A
slide's minimap then lights the repository's citations of its ADRs, never the slide's own words or the tool that drew it
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).

## Excluded files

An excluded file still sits in its world-map cell. Only its citations are ignored.

## Shape

The properties mirror the YAML keys, so they are snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
