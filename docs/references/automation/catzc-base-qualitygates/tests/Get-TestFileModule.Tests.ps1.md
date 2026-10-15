---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-TestFileModule.Tests.ps1.md
    kind: test-asset
    body_sha: "6f80c8579f2d"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/tests/Get-TestFileModule.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-TestFileModule' -Tag 'L0', 'logic' {`.

```text
Get-TestFileModule with Get-RepositoryRoot and Get-LanguageTestFolders mocked: a run file maps to its unit for
per-module protection. Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
