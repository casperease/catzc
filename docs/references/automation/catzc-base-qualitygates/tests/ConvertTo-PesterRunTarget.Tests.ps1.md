# automation/Catzc.Base.QualityGates/tests/ConvertTo-PesterRunTarget.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'ConvertTo-PesterRunTarget' -Tag 'L0', 'logic' {`, written with `#`.

```text
ConvertTo-PesterRunTarget over a fixture repository in $TestDrive (Get-RepositoryRoot and Get-LanguageTestFolders
mocked): language test folders become language bridge containers, everything else stays a Pester path. Neutral
fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
