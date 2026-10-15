---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/types/BicepDeploymentContext.cs.md
    kind: comment-page
    body_sha: "65120533b0b2"
---

# automation/Catzc.Azure.Templates/types/BicepDeploymentContext.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
Everything one Bicep deploy needs, gathered into three concerns: the plan (what/where to deploy), the
artifacts (which files), and the resolved environment identity (which subscription/tenant). The deploy
of a DoNotRun template yields no context at all (the producer returns null instead of this).
```
