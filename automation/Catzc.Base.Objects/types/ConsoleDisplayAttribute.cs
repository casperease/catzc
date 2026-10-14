// Names the identity properties of the type it decorates: the few that tell one instance from another at a
// glance. One declaration drives both console surfaces of a catzc object held in pwsh:
//
//   1. its text — ConsoleText.ToConsoleString renders only these properties, so "$x", [string]$x, -join and
//      a nested table cell read `SubscriptionContext { Id = 1f2e…, Name = Contoso Prod }`;
//   2. its prompt display — Import-CSharpTypes registers them as the type's DefaultDisplayPropertySet, so
//      typing `$x` (or a command returning one) shows these columns instead of every property.
//
// Without the attribute both surfaces show every public property. The names are checked when the type is
// rendered: an unknown name throws, naming the type and the property. BCL only; declares its module
// namespace (file-scoped), per the type loader.

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
