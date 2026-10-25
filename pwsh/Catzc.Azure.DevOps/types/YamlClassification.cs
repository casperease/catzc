/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-azure-dev-ops/types/YamlClassification.cs.md"
  header: "generated"
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
