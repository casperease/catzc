/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-objects/types/ConsoleDisplayAttribute.cs.md"
  header: "generated"
---
*/

using System;

namespace Catzc.Base.Objects;

// Names the identity properties of the type it decorates, the few that tell one instance from another at a glance.
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
