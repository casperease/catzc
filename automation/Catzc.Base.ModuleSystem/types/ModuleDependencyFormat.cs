// Output formats for ConvertTo-ModuleDependencyDiagram.
// [comment:1](/docs/references/automation/catzc-base-modulesystem/types/ModuleDependencyFormat.cs.md#comment1)

namespace Catzc.Base.ModuleSystem;

[Catzc.Base.Objects.PSTypeAlias("Catzc.Module.Depm")]
public enum ModuleDependencyFormat
{
    Json,
    Yaml,
    Markdown,
    Puml
}
