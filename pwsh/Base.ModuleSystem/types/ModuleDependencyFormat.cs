/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-module-system/types/ModuleDependencyFormat.cs.md"
  header: "generated"
---
*/

namespace Catzc.Base.ModuleSystem;

[Catzc.Base.Objects.PSTypeAlias("Catzc.Module.Depm")]
public enum ModuleDependencyFormat
{
    Json,
    Yaml,
    Markdown,
    Puml
}
