# automation/Catzc.Base.Docs/tests/Get-AdrFileIndex.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-AdrFileIndex' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-AdrFileIndex — every docs/adr/**/*.md keyed by "<domain folder>/<slug>", and each rule set mapped to its one file. A fixture
tree in $TestDrive and a fixture registry; neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
