# pwsh/Catzc.Tooling.Core/tests/Test-ToolRequiresElevation.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `function New-TestToolConfig {`, written with `#`.

```text
The production input is the typed record Get-ToolConfig returns, so the tests build one: a flag the record
does not map would be absent here exactly as in production.
```
