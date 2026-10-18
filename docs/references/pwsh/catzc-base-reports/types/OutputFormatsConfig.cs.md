# pwsh/Catzc.Base.Reports/types/OutputFormatsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The output-format catalogue, configs/output-formats.yml: every kind of file a producer writes under the output
root, declared once ([ADR-REPO-OUTFMT-OUTPUTFORMAT](/docs/adr/repository/output-formats.md#rule-adr-repo-outfmt-outputformat)).
Constructing an instance MAPS and VALIDATES the parsed YAML, collecting every violation into one throw.
Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Reports.OutputFormatsConfig), so
Get-Config -Config output-formats returns this typed model. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types-snakecasemirrorsyaml)).

Load-time rules:
  - only the top-level key 'formats' (required, a non-empty map of id -> OutputFormat);
  - each entry well-formed (OutputFormat);
  - no path can match patterns of two formats (OutputPattern.Overlaps), so every file has at most one format
    and it never depends on declaration order or on which pattern is more specific.
Which format a file on disk belongs to, and whether it is whole, is Test-OutputFormats' job, not load's.
```
