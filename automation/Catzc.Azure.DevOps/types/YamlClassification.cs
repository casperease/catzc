// How a YAML file in an Azure DevOps repo is classified by its top-level keys.
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
