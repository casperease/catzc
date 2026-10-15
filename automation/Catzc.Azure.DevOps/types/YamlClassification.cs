/*
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/types/YamlClassification.cs
    kind: type
    module: Catzc.Azure.DevOps
---
*/

// Only the coarse kind lives here; a Template is refined further by YamlTemplateType.
// [comment:1](/docs/references/automation/catzc-azure-devops/types/YamlClassification.cs.md#comment1)

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
