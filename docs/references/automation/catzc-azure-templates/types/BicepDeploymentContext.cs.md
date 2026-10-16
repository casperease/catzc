---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/types/BicepDeploymentContext.cs.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: f58589966a00
---

# automation/Catzc.Azure.Templates/types/BicepDeploymentContext.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Everything one Bicep deploy needs, gathered into three concerns: the plan (what/where to deploy), the
artifacts (which files), and the resolved environment identity (which subscription/tenant). The deploy
of a DoNotRun template yields no context at all (the producer returns null instead of this).
```
