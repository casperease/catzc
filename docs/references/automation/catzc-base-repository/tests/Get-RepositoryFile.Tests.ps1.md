---
catzc:
  derived:
    path: docs/references/automation/catzc-base-repository/tests/Get-RepositoryFile.Tests.ps1.md
    kind: test-asset
    body_sha: "3f84a2ef3bd6"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-RepositoryFile' -Tag 'L0', 'logic' {`.

```text
Get-RepositoryFile over a $TestDrive root (Get-RepositoryRoot mocked): path normalization against the root, never
$PWD. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
