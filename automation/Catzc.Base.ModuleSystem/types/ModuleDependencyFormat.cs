// Output formats for ConvertTo-ModuleDependencyDiagram. Used as a typed parameter, so the format choice
// auto-validates and tab-completes (`-As <TAB>`).
//
// BCL only. Declares its module namespace (file-scoped), per the type loader.

namespace Catzc.Base.ModuleSystem;

[Catzc.Base.Objects.PSTypeAlias("Catzc.Module.Depm")]
public enum ModuleDependencyFormat
{
    Json,
    Yaml,
    Markdown,
    Puml
}
