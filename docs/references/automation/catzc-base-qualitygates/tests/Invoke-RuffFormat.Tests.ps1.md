---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Invoke-RuffFormat.Tests.ps1.md
    kind: test-asset
    body_sha: c254bb041fc6
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#6
---

# automation/Catzc.Base.QualityGates/tests/Invoke-RuffFormat.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Invoke-RuffFormat' -Tag 'L0', 'logic' {`.

```text
The ruff engine with its seams mocked ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)):
ruff run from the Python workspace (Invoke-PythonWorkspaceTool) and the python.yml root. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
