using System;
using System.Collections.Generic;

namespace Catzc.Base.Maps;

// The axis minimap's re-cut of the value chain: each row a top domain and its stacks, the columns its delivery concerns.
[Catzc.Base.Objects.ConsoleDisplay(nameof(rows), nameof(columns))]
public sealed class MapsMinimapAxis
{
    public static readonly IReadOnlyList<KeyValuePair<string, IReadOnlyList<string>>> DefaultRows = Array.AsReadOnly(new[]
    {
        Row("DSGN", "PRIN", "DSGN"),
        Row("FLOW", "PIPE"),
        Row("AUTO", "AUTO"),
        Row("CLOUD", "CLOUD"),
    });

    public static readonly IReadOnlyList<string> DefaultColumns = Array.AsReadOnly(new[] { "build", "quality-control", "release", "deploy", "access" });

    // The rows, in order: a row's name and the value-chain stacks whose ADRs it gathers.
    public IReadOnlyList<KeyValuePair<string, IReadOnlyList<string>>> rows { get; }

    // The delivery concerns across, in order.
    public IReadOnlyList<string> columns { get; }

    public MapsMinimapAxis(IReadOnlyList<KeyValuePair<string, IReadOnlyList<string>>> rows, IReadOnlyList<string> columns)
    {
        this.rows = rows ?? throw new ArgumentNullException(nameof(rows));
        this.columns = columns ?? throw new ArgumentNullException(nameof(columns));
    }

    // The row a value-chain stack falls in, or null when no row gathers it.
    public string RowOf(string stack)
    {
        foreach (KeyValuePair<string, IReadOnlyList<string>> row in rows)
        {
            foreach (string gathered in row.Value)
            {
                if (string.Equals(gathered, stack, StringComparison.Ordinal)) { return row.Key; }
            }
        }
        return null;
    }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static KeyValuePair<string, IReadOnlyList<string>> Row(string name, params string[] stacks) =>
        new KeyValuePair<string, IReadOnlyList<string>>(name, Array.AsReadOnly(stacks));
}
