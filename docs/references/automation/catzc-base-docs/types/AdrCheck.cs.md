---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/types/AdrCheck.cs.md
    kind: comment-page
    body_sha: "0f8a46d89d05"
    adrs:
      - ADR-AUTO-TYPES#8
    links: []
---

# automation/Catzc.Base.Docs/types/AdrCheck.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System.Collections;`.

```text
One ADR check's settings in configs/adr-checks.yml that need nothing beyond their mode: the citation graph of the rule
summaries, checked by Test-AdrRegistry. Mirrors the YAML mapping (snake_case,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)); built and validated by AdrChecksConfig.
  mode — report | gate; default CheckMode's default, gate
```
