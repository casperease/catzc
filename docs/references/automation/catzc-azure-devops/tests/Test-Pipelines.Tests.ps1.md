---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/tests/Test-Pipelines.Tests.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "618fc4ca8cbe"
    adrs:
      - ADR-PWSH-PESTER#2
---

# automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-AdoYamlFiles -ModuleName Catzc.Azure.DevOps { $script:records }`, written with `#`.

```text
Isolate through the classifier + reference-scan seams
([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)).
```
