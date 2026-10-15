// Declares a PowerShell type-accelerator alias for the type it decorates.
// [comment:1](/docs/references/automation/catzc-base-objects/types/PSTypeAliasAttribute.cs.md#comment1)

using System;

namespace Catzc.Base.Objects;

[AttributeUsage(
    AttributeTargets.Class | AttributeTargets.Struct | AttributeTargets.Enum | AttributeTargets.Interface,
    AllowMultiple = true,
    Inherited = false)]
public sealed class PSTypeAliasAttribute : Attribute
{
    // The accelerator name to register, e.g.
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
