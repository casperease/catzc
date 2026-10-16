/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Objects/types/PSTypeAliasAttribute.cs
    kind: type
    language: csharp
    filetype: cs
    track: automation
    module: Catzc.Base.Objects
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-objects/types/PSTypeAliasAttribute.cs.md
---
*/

using System;

namespace Catzc.Base.Objects;

[AttributeUsage(
    AttributeTargets.Class | AttributeTargets.Struct | AttributeTargets.Enum | AttributeTargets.Interface,
    AllowMultiple = true,
    Inherited = false)]
public sealed class PSTypeAliasAttribute : Attribute
{
    public string Name { get; }

    public PSTypeAliasAttribute(string name)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException("a PSTypeAlias name is required");
        }
        Name = name;
    }
}
