---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Get-BicepDeploymentName.Tests.ps1.md
    kind: test-asset
    body_sha: "55f6b6d88e54"
---

# automation/Catzc.Azure.Templates/tests/Get-BicepDeploymentName.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Context 'pipeline (Azure DevOps)' {`.

```text
Get-BicepDeploymentName picks the platform by which run-id DATA var is present (GITHUB_RUN_ID → GitHub
Actions, else Azure DevOps). Each case sets its own vars and clears the other's run-id — important
because these tests themselves run on a GitHub Actions runner where $env:GITHUB_RUN_ID is already set.
```
