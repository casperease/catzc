# pwsh/Catzc.Base.QualityGates/tests/Test-LinkDirections.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-LinkDirections'`, written with `#`.

```text
Test-LinkDirections judges every relation the link walk reads against the rows, in a TestDrive tree with its endpoints and rows
mocked: an allowed relation passes, a denied one names its row and rule, one no row allows is denied, an exempt file is skipped.
```
