/*
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/types/YamlTemplateType.cs
    folder: types
    name: yaml-template-type
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Azure.DevOps
    moduletype: pwsh-folder
    catzc_bundle: azure
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
