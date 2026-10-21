/*
---
catzc:
  immutable:
    with_body_sha: ce069e76c48b
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(At), nameof(Count))]
public sealed class MinimapCell
{
    // The cell's place: one value per axis, in the minimap's axis order.
    public IReadOnlyList<string> At { get; }

    // What the cell holds, such as files or ADRs; zero for an empty cell.
    public int Count { get; }

    // Why the cell is lit; empty for a cell that is not.
    public IReadOnlyList<MinimapReason> Reasons { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public MinimapCell(string[] at, int count, MinimapReason[] reasons = null)
    {
        At = at ?? Array.Empty<string>();
        Count = count;
        Reasons = reasons ?? Array.Empty<MinimapReason>();
    }
}
