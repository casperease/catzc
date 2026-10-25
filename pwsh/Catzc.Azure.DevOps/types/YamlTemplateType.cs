/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-azure-dev-ops/types/YamlTemplateType.cs.md"
  warning: "Generated Header"
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
