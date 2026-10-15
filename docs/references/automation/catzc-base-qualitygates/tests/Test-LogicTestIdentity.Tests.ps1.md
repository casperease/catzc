---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-LogicTestIdentity.Tests.ps1.md
    kind: test-asset
    body_sha: "37635a5728b7"
    adrs:
      - ADR-AUTO-TEST#1
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-LogicTestIdentity' -Tag 'L1', 'integrity', 'source-only' {`.

```text
The integrity block binds the REAL shipped config (the live-identity set is derived from it), so it also names
live identities (e.g. 'apex') as fixture data; the integrity tag is both correct
([ADR-AUTO-TEST#1](/docs/adr/automation/test-automation.md#rule-adr-auto-test1))
and what exempts that block from the gate's own self-scan. source-only: it scans the repository's test files,
which give the same answer in both run modes. The logic block mocks the live set with neutral tokens
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)) and pins the gate's uniform
shape ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
```
