using System;
using System.Collections.Generic;

namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Name), nameof(Values))]
public sealed class MinimapAxis
{
    // What the axis runs over, such as track or file_language.
    public string Name { get; }

    // The axis values in drawing order.
    public IReadOnlyList<string> Values { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public MinimapAxis(string name, string[] values)
    {
        if (string.IsNullOrEmpty(name)) { throw new ArgumentException("a minimap axis needs a name", nameof(name)); }
        Name = name;
        Values = values ?? Array.Empty<string>();
    }
}
