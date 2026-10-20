/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Objects/types/PSTypeAliasAttribute.cs
    folder: types
    name: ps-type-alias-attribute
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Objects
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[PSTypeAliasAttribute.cs.md](docs/references/pwsh/catzc-base-objects/types/PSTypeAliasAttribute.cs.md)"
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
