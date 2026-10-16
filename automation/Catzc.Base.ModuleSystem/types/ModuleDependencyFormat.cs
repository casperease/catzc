/*
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/types/ModuleDependencyFormat.cs
    kind: csharp-type
    language: csharp
    track: automation
    module: Catzc.Base.ModuleSystem
    relatives:
      page: docs/references/automation/catzc-base-modulesystem/types/ModuleDependencyFormat.cs.md
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
