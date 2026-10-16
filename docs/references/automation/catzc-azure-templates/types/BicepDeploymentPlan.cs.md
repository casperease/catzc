---
catzc:
  immutable:
    with_body_sha: be996c2a037b
    repo_status: locked
    path: docs/references/automation/catzc-azure-templates/types/BicepDeploymentPlan.cs.md
    folder: docs/references/automation/catzc-azure-templates/types
    name: bicep-deployment-plan-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.Templates/types/BicepDeploymentPlan.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The deployment-plan concern of a deployment: what to deploy and where, independent of the files
(those are BicepArtifacts). One of the three concerns nested in BicepDeploymentContext.
```
