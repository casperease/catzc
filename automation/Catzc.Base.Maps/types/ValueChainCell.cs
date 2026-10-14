// One cell of the value-chain map: a row of the value-chain stack crossed with a value-chain concern, and the ADRs
// that sit in it ([ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16),
// [ADR-DSGN-TRACK#10](/docs/adr/design/tracks.md#rule-adr-dsgn-track10)). On the map, Adrs holds every ADR of the cell;
// on a highlight, the requested ADRs that light it. A result type, so the properties are PascalCase
// ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

using System;
using System.Collections.Generic;

namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Stack), nameof(Concern), nameof(AdrCount))]
public sealed class ValueChainCell
{
    // The row: a row of the value-chain stack (ADR-DSGN-TRACK#14).
    public string Stack { get; }

    // The column: a value-chain concern (ADR-DSGN-TRACK#15).
    public string Concern { get; }

    // The ADR codes (ADR-<CODE>) in the cell: on the map in adrs.yml order, on a highlight in request order. Empty for an
    // empty cell of the grid.
    public IReadOnlyList<string> Adrs { get; }

    // The number of ADRs in the cell.
    public int AdrCount => Adrs.Count;

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public ValueChainCell(string stack, string concern, string[] adrs)
    {
        Stack = stack;
        Concern = concern;
        Adrs = adrs == null ? Array.Empty<string>() : (string[])adrs.Clone();
    }
}
