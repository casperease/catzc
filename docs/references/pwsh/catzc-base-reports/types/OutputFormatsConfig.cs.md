# pwsh/Base.Reports/types/OutputFormatsConfig.cs

The output-format catalogue, `configs/output-formats.yml`: every kind of file a producer writes under the output root, declared once
([ADR-REPO-OUTFMT-OUTPUTFORMAT](../../../../drs/repository/output-formats.md#rule-adr-repo-outfmt-outputformat)).

## Registration

Constructing an instance maps and validates the parsed YAML, collecting every violation into one throw. It is registered in
`Catzc.Base.Config/configs/configs.yml` (type `Catzc.Base.Reports.OutputFormatsConfig`), so `Get-Config -Config output-formats` returns this
typed model. It mirrors the YAML mapping (snake_case keys,
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Load-time rules

- only the top-level key `formats` (required, a non-empty map of id to `OutputFormat`);
- each entry well-formed (`OutputFormat`);
- no path can match patterns of two formats (`OutputPattern.Overlaps`), so every file has at most one format and it never depends on
  declaration order or on which pattern is more specific.

Which format a file on disk belongs to, and whether it is whole, is `Test-OutputFormats`' job, not load's.
