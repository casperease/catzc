/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Objects/types/ConsoleDisplayAttribute.cs
    folder: types
    name: console-display-attribute
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.Objects
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-objects/types/ConsoleDisplayAttribute.cs.md
---
*/

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
