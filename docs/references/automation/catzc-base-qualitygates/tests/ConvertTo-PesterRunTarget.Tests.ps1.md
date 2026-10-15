---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/ConvertTo-PesterRunTarget.Tests.ps1.md
    kind: test-asset
    body_sha: ac2eb612b210
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/ConvertTo-PesterRunTarget.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'ConvertTo-PesterRunTarget' -Tag 'L0', 'logic' {`.

```text
ConvertTo-PesterRunTarget over a fixture repository in $TestDrive (Get-RepositoryRoot and Get-LanguageTestFolders
mocked): language test folders become language bridge containers, everything else stays a Pester path. Neutral
fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
