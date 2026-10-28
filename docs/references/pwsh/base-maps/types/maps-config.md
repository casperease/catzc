# pwsh/Base.Maps/types/MapsConfig.cs

The typed record of `configs/maps.yml`: the palette, the limits, the printed labels of the world map and the value-chain map, the reviewed
highlight pins and exceptions, the minimaps, and the output folder the PDFs land in under `Get-OutputRoot`
([ADR-REPO-OUTDIR-SUBDIRECTORYPERPRODUCER](../../../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-subdirectoryperproducer)).
It is registered in the config module's `configs.yml`, so `Get-Config -Config maps` returns it.

## Defaults

Every key has a sensible default, declared once on the type that holds it (`MapsPalette`, `MapsLimits`, `MapsLabels`, `MapsHighlight`, the
minimap types, and here the output folder)
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). An empty
file means the defaults, and a file sets a key only to change it. The properties mirror the YAML keys, so they are snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing an instance validates the file and collects every violation into one `ArgumentException`:

- only the known keys, at the top (`palette`, `limits`, `labels`, `highlight`, `output_folder`, `minimaps`) and in each section; an unknown
  key, such as a typo, fails at load;
- a section is a mapping, and `highlight.pins` and `highlight.exceptions` are lists of `{ rule, track, file_language, reason }`;
- a colour is `#` and six hex digits;
- a size is a positive number, and a label length a positive whole number;
- a label is one non-empty line of WinAnsi text, the only text the base-14 PDF fonts show, and a row or column header of the world map fits
  its limit (`row_axis` and `root_files` within `max_row_label`, `column_axis` and `unlisted_files` within `max_column_label`); the
  `value_chain_` labels have no length limit;
- `output_folder` is one path segment;
- a pin names a record or rule code (optionally `#n`), a track name, a kebab-case file language and a reason;
- `highlight.citation_exclude` is a list of repository-relative, `/`-separated globs.
