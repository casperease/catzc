---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-TestRunContext.Tests.ps1.md
    kind: test-asset
    body_sha: de0d732d13b1
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-TestRunContext.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-TestRunContext' -Tag 'L0', 'logic' {`.

```text
Get-TestRunContext over fixture locations; the session actor and the tool lookup are mocked, so no real process or
PATH state decides the outcome ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
