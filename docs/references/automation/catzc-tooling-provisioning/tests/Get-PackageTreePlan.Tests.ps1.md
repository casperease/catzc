---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/tests/Get-PackageTreePlan.Tests.ps1.md
    kind: test-asset
    body_sha: df5b65ff827a
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Tooling.Provisioning/tests/Get-PackageTreePlan.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-PackageTreePlan' -Tag 'L0', 'logic' {`.

```text
Get-PackageTreePlan over two fixture trees in $TestDrive. It reads the filesystem only. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
