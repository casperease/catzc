/*
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/types/ModuleDependencyFormat.cs
    folder: types
    name: module-dependency-format
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
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
