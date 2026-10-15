---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-ManagedGuids.Tests.ps1.md
    kind: test-asset
    body_sha: "318bb453c236"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Test-ManagedGuids.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-ManagedGuids' -Tag 'L0', 'logic' {`.

```text
Test-ManagedGuids over a mocked scan, registry, and 'repository' globset, so each test pins one rule. Neutral
fixture names and test-shaped guids ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
