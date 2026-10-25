# pwsh/Catzc.Base.QualityGates/tests/Invoke-RuffFormat.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Invoke-RuffFormat'`, written with `#`.

```text
The ruff engine with its seams mocked ([ADR-AUTO-TEST-NOOVERMOCKING](/docs/drs/automation/test-automation.md#rule-adr-auto-test-noovermocking)):
ruff run from the Python workspace (Invoke-PythonWorkspaceTool) and the python.yml root. Neutral fixture names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```
