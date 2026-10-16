/*
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/types/YamlClassification.cs
    kind: type
    language: csharp
    filetype: cs
    track: automation
    module: Catzc.Azure.DevOps
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-azure-devops/types/YamlClassification.cs.md
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
