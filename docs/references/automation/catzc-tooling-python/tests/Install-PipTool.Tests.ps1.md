---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-python/tests/Install-PipTool.Tests.ps1.md
    kind: test-asset
    body_sha: b11d32ad7bc7
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Tooling.Python/tests/Install-PipTool.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Mock Get-ToolConfig { [pscustomobject]@{ command = 'widget'; pip_package =...`.

```text
Neutral fixture tool ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)) — a
pip_package library, like PySpark but not a live identity.
```
