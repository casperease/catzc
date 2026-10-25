/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-objects/types/PSTypeAliasAttribute.cs.md"
  warning: "Generated Header"
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
