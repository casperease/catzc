// One rectangle of a SquarifiedTreemap layout: the item it stands for (its key and weight) and where it sits, in PDF
// user space (x and y are the bottom-left corner, in points). A result type, so the properties are PascalCase
// ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

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
