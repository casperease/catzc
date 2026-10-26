/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-azure-dev-ops/types/YamlTemplateType.cs.md"
  header: "generated"
---
*/

namespace Catzc.Azure.DevOps;

// Callers carry it as Nullable<YamlTemplateType>; null means not a Template, so the file is a Pipeline or Unknown.
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
