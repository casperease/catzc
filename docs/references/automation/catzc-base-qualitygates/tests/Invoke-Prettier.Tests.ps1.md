---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Invoke-Prettier.Tests.ps1.md
    kind: test-asset
    body_sha: "87f4d2613d58"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#6
---

# automation/Catzc.Base.QualityGates/tests/Invoke-Prettier.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Invoke-Prettier' -Tag 'L0', 'logic' {`.

```text
The prettier engine with the tool boundary mocked ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)):
never launch a real process in a unit test. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
