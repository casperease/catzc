---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/tests/New-PythonProject.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "82b1ba3eb0fd"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Languages/tests/New-PythonProject.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'New-PythonProject' -Tag 'L0', 'logic' {`, written with `#`.

```text
New-PythonProject over a fixture repository in $TestDrive, with its two declared configs mocked: python.yml (Get-Config)
and the python pin in tools.yml (Get-ConfigValue). Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
