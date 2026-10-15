---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/tests/Resolve-EngineExecutable.Tests.ps1.md
    kind: test-asset
    body_sha: d257ffc8e359
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Execution/tests/Resolve-EngineExecutable.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Resolve-EngineExecutable' -Tag 'L0', 'logic' {`.

```text
Resolve-EngineExecutable with the tool probe mocked for the tool-located engines; pwsh is located beside the running
PowerShell for real, which needs nothing but the session itself. Neutral fixture paths
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
