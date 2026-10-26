/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-module-system/types/ModuleDependencyFormat.cs.md"
  header: "generated"
---
*/

namespace Catzc.Base.ModuleSystem;

// The output formats of ConvertTo-ModuleDependencyDiagram, a typed parameter, so the choice validates and tab-completes.
[Catzc.Base.Objects.PSTypeAlias("Catzc.Module.Depm")]
public enum ModuleDependencyFormat
{
    Json,
    Yaml,
    Markdown,
    Puml
}
