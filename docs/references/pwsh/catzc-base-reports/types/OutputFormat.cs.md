# pwsh/Base.Reports/types/OutputFormat.cs

One entry of `configs/output-formats.yml`: a declared kind of file a producer writes under the output root
([ADR-REPO-OUTFMT-OUTPUTFORMAT](../../../../drs/repository/output-formats.md#rule-adr-repo-outfmt-outputformat)). It mirrors the YAML mapping
(snake_case keys,
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing one maps and validates the entry, collecting every violation into one throw:

- the id (its map key) is kebab-case;
- only the keys `patterns`, `target`, `producer`, `audience`, `validator`, `limits`;
- `patterns` is a non-empty list of output-root-relative globs in the `OutputPattern` grammar (`*` and `?` inside one segment, `**` any depth,
  `{stamp}` one stamped folder);
- `target` is `file` (the default) or `folder` (the pattern names a folder, checked as one unit);
- `producer` (the function or script that writes it) and `audience` (who opens it, with what) are required;
- `validator` is a map with a known `kind` and only that kind's parameters, its required ones present
  ([ADR-REPO-OUTFMT-VALIDATORISCODE](../../../../drs/repository/output-formats.md#rule-adr-repo-outfmt-validatoriscode));
- `limits` holds only known limit names, each a positive whole number
  ([ADR-REPO-OUTFMT-LIMITSINCATALOGUE](../../../../drs/repository/output-formats.md#rule-adr-repo-outfmt-limitsincatalogue)).

That no two formats' patterns overlap spans entries, so `OutputFormatsConfig` checks it.
