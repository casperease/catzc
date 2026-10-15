/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Objects/types/PSTypeAliasAttribute.cs
    kind: type
    module: Catzc.Base.Objects
    adrs: []
---
*/

// The alias literal lives in the C# source so a search for the alias lands on the declaring type; a type may carry several.
// [comment:1](/docs/references/automation/catzc-base-objects/types/PSTypeAliasAttribute.cs.md#comment1)

using System;

namespace Catzc.Base.Objects;

[AttributeUsage(
    AttributeTargets.Class | AttributeTargets.Struct | AttributeTargets.Enum | AttributeTargets.Interface,
    AllowMultiple = true,
    Inherited = false)]
public sealed class PSTypeAliasAttribute : Attribute
{
    // Keep the Catzc. prefix so the alias never reclaims another module's accelerator.
    // [comment:2](/docs/references/automation/catzc-base-objects/types/PSTypeAliasAttribute.cs.md#comment2)
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
