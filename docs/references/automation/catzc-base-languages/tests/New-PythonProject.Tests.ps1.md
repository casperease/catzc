---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/tests/New-PythonProject.Tests.ps1.md
    kind: test-asset
    body_sha: a572d47c679e
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Languages/tests/New-PythonProject.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'New-PythonProject' -Tag 'L0', 'logic' {`.

```text
New-PythonProject over a fixture repository in $TestDrive, with its two declared configs mocked: python.yml (Get-Config)
and the python pin in tools.yml (Get-ConfigValue). Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
