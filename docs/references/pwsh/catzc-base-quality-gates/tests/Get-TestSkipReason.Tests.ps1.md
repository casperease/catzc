# pwsh/Base.QualityGates/tests/Get-TestSkipReason.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function New-FakeSkip {`, written with `#`.

```text
A Pester test-result object carries .ErrorRecord (a collection of records each exposing
.Exception.Message). A discovery `It -Skip` records nothing; pass -NoRecord for that shape.
```
