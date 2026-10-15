---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/tests/Test-Pipelines.Tests.ps1.md
    kind: test-asset
    body_sha: "5c9407c30a0b"
    adrs:
      - ADR-PWSH-PESTER#2
---

# automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Mock Get-AdoYamlFiles -ModuleName Catzc.Azure.DevOps { $script:records }`.

```text
Isolate through the classifier + reference-scan seams
([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)).
```
