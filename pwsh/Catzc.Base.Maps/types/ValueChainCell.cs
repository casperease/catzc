/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Maps/types/ValueChainCell.cs
    folder: types
    name: value-chain-cell
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[ValueChainCell.cs.md](docs/references/pwsh/catzc-base-maps/types/ValueChainCell.cs.md)"
    cites:
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
      - ADR-DSGN-TRACK-CELL
      - ADR-DSGN-TRACK-VALUECHAINSTACK
      - ADR-DSGN-TRACK-VALUECHAINCONCERN
      - ADR-DSGN-TRACK-VALUECHAINMAP
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Stack), nameof(Concern), nameof(AdrCount))]
public sealed class ValueChainCell
{
    // The row: a row of the value-chain stack ([ADR-DSGN-TRACK-VALUECHAINSTACK](/docs/adr/design/tracks.md#rule-adr-dsgn-track-valuechainstack)).
    public string Stack { get; }

    // The column: a value-chain concern ([ADR-DSGN-TRACK-VALUECHAINCONCERN](/docs/adr/design/tracks.md#rule-adr-dsgn-track-valuechainconcern)).
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
