---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Invoke-PSScriptAnalyzerFormat.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: invoke-ps-script-analyzer-format-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: ef90cd38beeb
    adrs:
      - ADR-AUTO-CONSOLE#10
---

# automation/Catzc.Base.QualityGates/private/Invoke-PSScriptAnalyzerFormat.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$shardCount = [Math]::Min([Math]::Max(1,...`, written with `#`.

```text
A cold pass spends about 40 ms a file resolving command names it has not seen, so a large batch is sharded
across a few processes (the analyzer's initialization is not thread-safe, as in Get-ScriptAnalyzerDiagnostics);
a small batch, the usual warm-cache one, stays in this session.
```

## comment:2

Above `Write-Message 'Loading PSScriptAnalyzer (first use this session)...'`, written with `#`.

```text
First use this session pays the vendored-module import (several seconds) — announce it
([ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)).
```
