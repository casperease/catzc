/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.DevOps/types/YamlClassification.cs
    folder: types
    name: yaml-classification
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.DevOps
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[YamlClassification.cs.md](docs/references/pwsh/catzc-azure-devops/types/YamlClassification.cs.md)"
---
*/

namespace Catzc.Azure.DevOps;

public enum YamlClassification
{
    // Has a pipeline entry-point shape (e.g. trigger / stages at the root of a runnable pipeline).
    Pipeline,

    // A reusable fragment included by other YAML (refined by YamlTemplateType).
    Template,

    // Neither shape was recognised.
    Unknown
}
