---
catzc:
  immutable:
    with_body_sha: "4963c5eed1a0"
    path: docs/references/automation/catzc-azure-devops/types/PipelineDefinition.cs.md
    folder: docs/references/automation/catzc-azure-devops/types
    name: pipeline-definition-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.DevOps/types/PipelineDefinition.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One pipeline (build definition) registered in Azure DevOps. The registration-side view of a pipeline:
its identity and folder placement, and — for YAML pipelines — which file in which repo backs it.
```
