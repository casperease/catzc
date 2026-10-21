/*
---
catzc:
  immutable:
    with_body_sha: "4f01da30bff6"
  edges:
    docs: "[ModuleDependencyFormat.cs.md](../../../docs/references/pwsh/catzc-base-module-system/types/ModuleDependencyFormat.cs.md)"
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
