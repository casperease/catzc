---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Measure-QualityGates.ps1.md
    kind: comment-page
    body_sha: "35266fda2b57"
    adrs:
      - ADR-AUTO-CONSOLE#10
---

# automation/Catzc.Base.QualityGates/Measure-QualityGates.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `Write-Message 'Loading PSScriptAnalyzer (first use this session)...'`.

```text
First use this session pays the vendored-module import (several seconds) — announce it
([ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)).
```
