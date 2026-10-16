---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Get-BicepDeploymentName.Tests.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e81d54812190
---

# automation/Catzc.Azure.Templates/tests/Get-BicepDeploymentName.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Context 'pipeline (Azure DevOps)' {`, written with `#`.

```text
Get-BicepDeploymentName picks the platform by which run-id DATA var is present (GITHUB_RUN_ID → GitHub
Actions, else Azure DevOps). Each case sets its own vars and clears the other's run-id — important
because these tests themselves run on a GitHub Actions runner where $env:GITHUB_RUN_ID is already set.
```
