// catzc:
//   path: automation/Catzc.Azure.DevOps/types/YamlTemplateType.cs
//   module: Catzc.Azure.DevOps

// Callers carry it as Nullable, where null means the file is not a Template but a Pipeline or Unknown.
// [comment:1](/docs/references/automation/catzc-azure-devops/types/YamlTemplateType.cs.md#comment1)

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
