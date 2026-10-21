/*
---
catzc:
  immutable:
    with_body_sha: c0b0f64b39f8
  edges:
    docs: "[PSTypeAliasAttribute.cs.md](../../../docs/references/pwsh/catzc-base-objects/types/PSTypeAliasAttribute.cs.md)"
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
