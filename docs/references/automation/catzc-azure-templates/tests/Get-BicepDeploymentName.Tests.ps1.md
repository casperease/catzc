---
catzc:
  immutable:
    with_body_sha: e81d54812190
    repo_status: locked
    path: docs/references/automation/catzc-azure-templates/tests/Get-BicepDeploymentName.Tests.ps1.md
    folder: docs/references/automation/catzc-azure-templates/tests
    name: get-bicep-deployment-name-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
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
