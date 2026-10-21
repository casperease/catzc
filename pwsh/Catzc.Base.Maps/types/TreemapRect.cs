/*
---
catzc:
  immutable:
    with_body_sha: "4ecc4ce7ca4a"
  edges:
    docs: "[TreemapRect.cs.md](../../../docs/references/pwsh/catzc-base-maps/types/TreemapRect.cs.md)"
    cites:
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
---
*/

namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Key), nameof(Weight), nameof(X), nameof(Y), nameof(Width), nameof(Height))]
public sealed class TreemapRect
{
    // The item's key, as given to the layout.
    public string Key { get; }

    // The item's weight, as given to the layout; the area is proportional to it.
    public double Weight { get; }

    // The left edge, in points.
    public double X { get; }

    // The bottom edge, in points.
    public double Y { get; }

    // The width, in points.
    public double Width { get; }

    // The height, in points.
    public double Height { get; }

    // Width times height.
    public double Area => Width * Height;

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public TreemapRect(string key, double weight, double x, double y, double width, double height)
    {
        Key = key;
        Weight = weight;
        X = x;
        Y = y;
        Width = width;
        Height = height;
    }
}
