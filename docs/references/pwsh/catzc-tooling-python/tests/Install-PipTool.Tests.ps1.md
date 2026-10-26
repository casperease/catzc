# pwsh/Tooling.Python/tests/Install-PipTool.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-ToolConfig { [pscustomobject]@{ command = 'widget'; pip_package =...`, written with `#`.

```text
Neutral fixture tool ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)) — a
pip_package library, like PySpark but not a live identity.
```

## comment:2

Above `Mock Get-ToolConfig { [pscustomobject]@{ command = 'widget'; pip_package =...`, written with `#`.

```text
A neutral library-shaped tool, so the case covers a package with no launcher of its own without naming a real
one.
```
