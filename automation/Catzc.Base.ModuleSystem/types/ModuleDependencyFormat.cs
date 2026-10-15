/*
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/types/ModuleDependencyFormat.cs
    kind: csharp-type
    module: Catzc.Base.ModuleSystem
---
*/

// Used as a typed parameter, so the format choice validates and tab-completes without a ValidateSet.
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
