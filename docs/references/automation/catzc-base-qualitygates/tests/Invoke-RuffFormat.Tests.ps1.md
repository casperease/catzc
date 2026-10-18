# automation/Catzc.Base.QualityGates/tests/Invoke-RuffFormat.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Invoke-RuffFormat' -Tag 'L0', 'logic' {`, written with `#`.

```text
The ruff engine with its seams mocked ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)):
ruff run from the Python workspace (Invoke-PythonWorkspaceTool) and the python.yml root. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
