/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.DevOps/types/YamlTemplateType.cs
    folder: types
    name: yaml-template-type
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.DevOps
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[YamlTemplateType.cs.md](docs/references/pwsh/catzc-azure-devops/types/YamlTemplateType.cs.md)"
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
