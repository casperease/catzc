---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/tests/Install-BicepStandalone.Tests.ps1.md
    kind: test-asset
    body_sha: "741c0c53b624"
    adrs:
      - ADR-AUTO-TEST#6
---

# automation/Catzc.Tooling.Toolchain/tests/Install-BicepStandalone.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Install-BicepStandalone' -Tag 'L0', 'logic' {`.

```text
Install-BicepStandalone (the Linux path of Install-Bicep) with its seams mocked
([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)): the GitHub releases API
(Invoke-RestMethod), the verified download (Save-VerifiedDownload, which writes the file), and chmod
(Invoke-Executable). $env:HOME points into $TestDrive, so ~/.local/bin is a scratch folder.
```
