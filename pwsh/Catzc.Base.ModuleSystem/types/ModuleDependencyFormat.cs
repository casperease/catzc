/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-module-system/types/ModuleDependencyFormat.cs.md"
  warning: "Generated Header"
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
