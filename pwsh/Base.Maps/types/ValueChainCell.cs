using System;
using System.Collections.Generic;

namespace Catzc.Base.Maps;

// One value-chain cell: a stack row crossed with a concern, and the records that sit in it.
[Catzc.Base.Objects.ConsoleDisplay(nameof(Stack), nameof(Concern), nameof(AdrCount))]
public sealed class ValueChainCell
{
    // The row: a row of the value-chain stack ([ADR-REPO-VALUECHAIN-STACK](/docs/drs/repository/drs-value-chain.md#rule-adr-repo-valuechain-stack)).
    public string Stack { get; }

    // The column: a value-chain concern ([ADR-REPO-VALUECHAIN-CONCERN](/docs/drs/repository/drs-value-chain.md#rule-adr-repo-valuechain-concern)).
    public string Concern { get; }

    // On the map in drs.yml order, on a highlight in request order; empty for an empty cell.
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
