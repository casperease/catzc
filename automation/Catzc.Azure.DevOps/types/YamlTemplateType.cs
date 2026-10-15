/*
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/types/YamlTemplateType.cs
    kind: csharp-type
    module: Catzc.Azure.DevOps
    relatives:
      page: docs/references/automation/catzc-azure-devops/types/YamlTemplateType.cs.md
---
*/

namespace Catzc.Azure.DevOps;

public enum YamlTemplateType
{
    // Body key `stages:` — a stage-level template.
    Stages,

    // Body key `jobs:` — a job-level template.
    Jobs,

    // Body key `steps:` — a step-level template.
    Steps,

    // Body key `variables:` — a variables template.
    Variables
}
