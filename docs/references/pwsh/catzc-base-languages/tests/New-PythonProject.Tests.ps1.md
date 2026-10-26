# pwsh/Base.Languages/tests/New-PythonProject.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'New-PythonProject'`, written with `#`.

```text
New-PythonProject over a fixture repository in $TestDrive, with its two declared configs mocked: python.yml (Get-Config)
and the python pin in tools.yml (Get-ConfigValue). Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
