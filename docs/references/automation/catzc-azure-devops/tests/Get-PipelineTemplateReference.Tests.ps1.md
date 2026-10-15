---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/tests/Get-PipelineTemplateReference.Tests.ps1.md
    kind: test-asset
    body_sha: b7ed406e24c1
    adrs:
      - ADR-PWSH-PESTER#4
---

# automation/Catzc.Azure.DevOps/tests/Get-PipelineTemplateReference.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
Get-PipelineTemplateReference is private, so it is exercised through the module
([ADR-PWSH-PESTER#4](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester4)).
```
