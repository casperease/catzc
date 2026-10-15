---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-ChangeCheckPlan.Tests.ps1.md
    kind: test-asset
    body_sha: "0af82d6e3518"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-ChangeCheckPlan.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-ChangeCheckPlan' -Tag 'L0', 'logic' {`.

```text
Get-ChangeCheckPlan over fixture files, with the file-language registry mocked to fixture languages. Neutral fixture
names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
