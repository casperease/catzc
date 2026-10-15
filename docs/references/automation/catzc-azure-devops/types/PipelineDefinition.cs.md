---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/types/PipelineDefinition.cs.md
    kind: comment-page
    body_sha: "3ddc71e0a02a"
    adrs: []
---

# automation/Catzc.Azure.DevOps/types/PipelineDefinition.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One pipeline (build definition) registered in Azure DevOps. The registration-side view of a pipeline:
its identity and folder placement, and — for YAML pipelines — which file in which repo backs it.
```
