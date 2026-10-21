/*
---
catzc:
  immutable:
    with_body_sha: f4e4a321c280
  edges:
    docs: "[YamlTemplateType.cs.md](../../../docs/references/pwsh/catzc-azure-dev-ops/types/YamlTemplateType.cs.md)"
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
