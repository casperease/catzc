---
catzc:
  derived:
    path: docs/references/automation/catzc-base-reports/types/OutputFormatsConfig.cs.md
    kind: comment-page
    body_sha: ee93cd6f3639
    adrs:
      - ADR-AUTO-TYPES#8
      - ADR-REPO-OUTFMT#1
---

# automation/Catzc.Base.Reports/types/OutputFormatsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The output-format catalogue, configs/output-formats.yml: every kind of file a producer writes under the output
root, declared once ([ADR-REPO-OUTFMT#1](/docs/adr/repository/output-formats.md#rule-adr-repo-outfmt1)).
Constructing an instance MAPS and VALIDATES the parsed YAML, collecting every violation into one throw.
Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Reports.OutputFormatsConfig), so
Get-Config -Config output-formats returns this typed model. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Load-time rules:
  - only the top-level key 'formats' (required, a non-empty map of id -> OutputFormat);
  - each entry well-formed (OutputFormat);
  - no path can match patterns of two formats (OutputPattern.Overlaps), so every file has at most one format
    and it never depends on declaration order or on which pattern is more specific.
Which format a file on disk belongs to, and whether it is whole, is Test-OutputFormats' job, not load's.
```
