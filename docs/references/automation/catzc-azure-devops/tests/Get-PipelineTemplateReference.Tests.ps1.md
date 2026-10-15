---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/tests/Get-PipelineTemplateReference.Tests.ps1.md
    kind: comment-page
    body_sha: ace32f65632c
    adrs:
      - ADR-PWSH-PESTER#4
---

# automation/Catzc.Azure.DevOps/tests/Get-PipelineTemplateReference.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
Get-PipelineTemplateReference is private, so it is exercised through the module
([ADR-PWSH-PESTER#4](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester4)).
```
