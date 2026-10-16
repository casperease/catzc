/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.Objects/types/PSTypeAliasAttribute.cs
    folder: types
    name: ps-type-alias-attribute
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.Objects
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
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
