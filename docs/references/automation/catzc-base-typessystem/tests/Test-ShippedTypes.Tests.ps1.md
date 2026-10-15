---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/tests/Test-ShippedTypes.Tests.ps1.md
    kind: test-asset
    body_sha: b2348c6a056d
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.TypesSystem/tests/Test-ShippedTypes.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Test-ShippedTypes' -Tag 'L0', 'logic' {`.

```text
Test-ShippedTypes over a fixture code root in $TestDrive: one file named for a type the session has (System.String
under a 'System' module folder), one named for a type that never loaded. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
