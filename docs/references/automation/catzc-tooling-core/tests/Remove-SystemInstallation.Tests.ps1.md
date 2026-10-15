---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/tests/Remove-SystemInstallation.Tests.ps1.md
    kind: test-asset
    body_sha: "5d84e5d256d1"
    adrs:
      - ADR-AUTO-TEST#33
---

# automation/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Remove-SystemInstallation' -Tag 'L1', 'logic', 'ADR-AUTO-TEST#33' {`.

```text
Hermetic logic (L1): every boundary that touches state outside the repository is mocked — the install directory
delete (Remove-Item), the Machine PATH (Get-/Set-EnvironmentPath) and the Machine variables
(Set-PermanentEnvironmentVariable). The seams' real registry round trips are their own L3 system tests.
```
