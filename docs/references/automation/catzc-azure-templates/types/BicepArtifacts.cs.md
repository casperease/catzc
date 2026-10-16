---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/types/BicepArtifacts.cs.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "524efb7c6a2a"
---

# automation/Catzc.Azure.Templates/types/BicepArtifacts.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The build-artifacts concern of a deployment: the concrete files a Bicep deploy hands to az. Paths are
stored repo-root-relative where possible. One of the three concerns nested in BicepDeploymentContext.
```
