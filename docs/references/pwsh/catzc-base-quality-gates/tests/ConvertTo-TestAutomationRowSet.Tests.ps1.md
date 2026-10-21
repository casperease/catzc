# pwsh/Catzc.Base.QualityGates/tests/ConvertTo-TestAutomationRowSet.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function New-FakeTest {`, written with `#`.

```text
Build a Pester-shaped test-result object without running Pester — just the members the reducer
reads (Result, Duration, ExpandedPath/Name, ErrorRecord, the Block tag chain, ScriptBlock file/line).
```
