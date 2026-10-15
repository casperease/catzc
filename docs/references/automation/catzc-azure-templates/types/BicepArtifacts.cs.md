---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/types/BicepArtifacts.cs.md
    kind: comment-page
    body_sha: "442985107c83"
    adrs: []
---

# automation/Catzc.Azure.Templates/types/BicepArtifacts.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The build-artifacts concern of a deployment: the concrete files a Bicep deploy hands to az. Paths are
stored repo-root-relative where possible. One of the three concerns nested in BicepDeploymentContext.
```
