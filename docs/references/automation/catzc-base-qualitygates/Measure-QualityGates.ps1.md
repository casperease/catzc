---
catzc:
  immutable:
    with_body_sha: "780f53b3104e"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/Measure-QualityGates.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates
    name: measure-quality-gates-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-CONSOLE#10
---

# automation/Catzc.Base.QualityGates/Measure-QualityGates.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Write-Message 'Loading PSScriptAnalyzer (first use this session)...'`, written with `#`.

```text
First use this session pays the vendored-module import (several seconds) — announce it
([ADR-AUTO-CONSOLE#10](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console10)).
```
