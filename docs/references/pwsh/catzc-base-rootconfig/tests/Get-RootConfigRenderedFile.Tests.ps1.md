# pwsh/Catzc.Base.RootConfig/tests/Get-RootConfigRenderedFile.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-RootConfigRenderedFile' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-RootConfigRenderedFile over a mocked generator dispatch: a single-file generator's string and a multi-file
generator's { Target; Content } records normalise to the same records, and every shape that would write a file the
entry does not name throws. Neutral fixture names ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
