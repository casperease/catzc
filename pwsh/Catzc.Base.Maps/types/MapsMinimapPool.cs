/*
---
catzc:
  immutable:
    with_body_sha: bb0ed74885f5
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Maps;

// The minimaps one kind of diagram may show, and the three it shows when its declaration names none.
[Catzc.Base.Objects.ConsoleDisplay(nameof(pool), nameof(defaults))]
public sealed class MapsMinimapPool
{
    // How many minimaps a diagram shows.
    public const int Shown = 3;

    public static readonly IReadOnlyList<string> DefaultExplanationPool = Array.AsReadOnly(new[]
    {
        MinimapData.Axis, MinimapData.LifecyclePosition, MinimapData.LayerStack, MinimapData.Grid,
    });

    public static readonly IReadOnlyList<string> DefaultExplanationDefaults = Array.AsReadOnly(new[]
    {
        MinimapData.Axis, MinimapData.LifecyclePosition, MinimapData.LayerStack,
    });

    public static readonly IReadOnlyList<string> DefaultReferencePool = Array.AsReadOnly(new[]
    {
        MinimapData.CodeLocations, MinimapData.TrackPlacement, MinimapData.EngineStrip, MinimapData.ModuleNeighbourhood, MinimapData.Grid,
    });

    public static readonly IReadOnlyList<string> DefaultReferenceDefaults = Array.AsReadOnly(new[]
    {
        MinimapData.TrackPlacement, MinimapData.EngineStrip, MinimapData.ModuleNeighbourhood,
    });

    // The minimap ids the kind may pick from.
    public IReadOnlyList<string> pool { get; }

    // The three minimaps the kind shows by default, each in the pool.
    public IReadOnlyList<string> defaults { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public MapsMinimapPool(IReadOnlyList<string> pool, IReadOnlyList<string> defaults)
    {
        this.pool = pool ?? Array.Empty<string>();
        this.defaults = defaults ?? Array.Empty<string>();
    }
}
