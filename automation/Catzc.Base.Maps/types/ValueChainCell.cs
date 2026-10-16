/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.Maps/types/ValueChainCell.cs
    folder: types
    name: value-chain-cell
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-maps/types/ValueChainCell.cs.md
    cites:
      - ADR-AUTO-TYPES#8
      - ADR-DSGN-TRACK#{10,14-16}
---
*/

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
