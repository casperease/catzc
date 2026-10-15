// One cell of the value-chain map: a row of the value-chain stack crossed with a value-chain concern, and the ADRs that sit in it.
// [ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16),
// [ADR-DSGN-TRACK#10](/docs/adr/design/tracks.md#rule-adr-dsgn-track10),
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-base-maps/types/ValueChainCell.cs.md#comment1)

using System;
using System.Collections.Generic;

namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Stack), nameof(Concern), nameof(AdrCount))]
public sealed class ValueChainCell
{
    // The row: a row of the value-chain stack ([ADR-DSGN-TRACK#14](/docs/adr/design/tracks.md#rule-adr-dsgn-track14)).
    public string Stack { get; }

    // The column: a value-chain concern ([ADR-DSGN-TRACK#15](/docs/adr/design/tracks.md#rule-adr-dsgn-track15)).
    public string Concern { get; }

    // The ADR codes (ADR-<CODE>) in the cell: on the map in adrs.yml order, on a highlight in request order.
    // [comment:2](/docs/references/automation/catzc-base-maps/types/ValueChainCell.cs.md#comment2)
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
