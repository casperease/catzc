// Names the identity properties of the type it decorates: the few that tell one instance from another at a glance.
// [comment:1](/docs/references/automation/catzc-base-objects/types/ConsoleDisplayAttribute.cs.md#comment1)

using System;

namespace Catzc.Base.Objects;

[AttributeUsage(AttributeTargets.Class | AttributeTargets.Struct, AllowMultiple = false, Inherited = true)]
public sealed class ConsoleDisplayAttribute : Attribute
{
    // The identity property names, in display order. Callers pass nameof(...) so a rename follows.
    public string[] Properties { get; }

    public ConsoleDisplayAttribute(params string[] properties)
    {
        if (properties == null || properties.Length == 0)
        {
            throw new ArgumentException("a ConsoleDisplay attribute names at least one property");
        }
        Properties = properties;
    }
}
