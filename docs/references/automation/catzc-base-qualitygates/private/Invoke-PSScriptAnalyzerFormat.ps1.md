---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Invoke-PSScriptAnalyzerFormat.ps1.md
    kind: comment-page
    body_sha: "4f6e46e8f803"
    adrs:
      - ADR-AUTO-CONSOLE#10
---

# automation/Catzc.Base.QualityGates/private/Invoke-PSScriptAnalyzerFormat.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$shardCount = [Math]::Min([Math]::Max(1,...`.

```text
A cold pass spends about 40 ms a file resolving command names it has not seen, so a large batch is sharded
across a few processes (the analyzer's initialization is not thread-safe, as in Get-ScriptAnalyzerDiagnostics);
a small batch, the usual warm-cache one, stays in this session.
```

## comment:5

Above `Write-Message 'Loading PSScriptAnalyzer (first use this session)...'`.

```text
First use this session pays the vendored-module import (several seconds) — announce it
([ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)).
```
