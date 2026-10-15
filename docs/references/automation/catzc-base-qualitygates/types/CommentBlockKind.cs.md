---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/CommentBlockKind.cs.md
    kind: comment-page
    body_sha: "461883bfdeb0"
    adrs:
      - ADR-PRIN-ONELIVE#1
---

# automation/Catzc.Base.QualityGates/types/CommentBlockKind.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `namespace Catzc.Base.QualityGates;`.

```text
The shapes of a comment block CommentEngine can move out of a file into its comment page
([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)):
  LineRun     consecutive own-line comments with one marker and indent (`# …`, `// …`, `/// …`)
  Block       one delimited comment (`<# … #>`, `/* … */`) that is not comment-based help
  HelpSection the body of one `.KEYWORD` section inside a PowerShell comment-based help block
```
