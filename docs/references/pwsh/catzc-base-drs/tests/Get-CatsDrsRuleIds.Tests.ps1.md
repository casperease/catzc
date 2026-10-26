# pwsh/Base.Drs/tests/Get-CatsDrsRuleIds.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:adrRoot = Join-Path $TestDrive 'adr'`, written with `#`.

```text
A fixture ADR tree: an index beside two ADR files it lists (paths relative to the index folder),
plus a third ADR the index does NOT list — so we can assert only listed ADRs contribute.
```
