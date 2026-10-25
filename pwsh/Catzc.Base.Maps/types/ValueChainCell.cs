/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-maps/types/ValueChainCell.cs.md"
  warning: "Generated Header"
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Stack), nameof(Concern), nameof(AdrCount))]
public sealed class ValueChainCell
{
    // The row: a row of the value-chain stack ([DDR-TRACK-VALUECHAINSTACK](/docs/drs/design/tracks.md#rule-ddr-track-valuechainstack)).
    public string Stack { get; }

    // The column: a value-chain concern ([DDR-TRACK-VALUECHAINCONCERN](/docs/drs/design/tracks.md#rule-ddr-track-valuechainconcern)).
    public string Concern { get; }

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
