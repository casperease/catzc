/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/types/ValueChainCell.cs
    kind: csharp-type
    module: Catzc.Base.Maps
    adrs:
      - ADR-AUTO-TYPES#8
      - ADR-DSGN-TRACK#10
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
---
*/

// On the map Adrs holds every ADR of the cell; on a highlight only the requested ADRs that light it.
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

    // The order differs by use, adrs.yml order on the map and request order on a highlight; an empty grid cell holds none.
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
