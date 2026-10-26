# pwsh/Catzc.Base.Repository/tests/types/SyntaxSearch.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'SyntaxSearch'`, written with `#`.

```text
The compiled searches return what a PowerShell predicate over FindAll returned. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:2

Above `Describe 'SyntaxSearch'`, written with `#`.

```text
Each compiled search must return exactly what a PowerShell predicate over FindAll returns, so swapping one for the
other changes nothing.
```
