/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-objects/types/PSTypeAliasAttribute.cs.md"
  header: "generated"
---
*/

using System;

namespace Catzc.Base.Objects;

[AttributeUsage(
    AttributeTargets.Class | AttributeTargets.Struct | AttributeTargets.Enum | AttributeTargets.Interface,
    AllowMultiple = true,
    Inherited = false)]
// A type-accelerator alias for the decorated type, registered by the type loader after the combined assembly loads.
public sealed class PSTypeAliasAttribute : Attribute
{
    // The accelerator name, prefixed Catzc. so it never reclaims another module's accelerator.
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
