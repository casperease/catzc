using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Text.Json;

namespace Catzc.Base.Maps;

// The data one minimap draws, in the shape of the minimap contract (contracts/catzc/0.0.0/Catzc.Base.Maps/minimap.schema.json).
[Catzc.Base.Objects.ConsoleDisplay(nameof(Id), nameof(Axes))]
public sealed class MinimapData
{
    public const string Grid = "grid";
    public const string CodeLocations = "code-locations";
    public const string Axis = "axis";
    public const string LayerStack = "layer-stack";
    public const string LifecyclePosition = "lifecycle-position";
    public const string TrackPlacement = "track-placement";
    public const string EngineStrip = "engine-strip";
    public const string ModuleNeighbourhood = "module-neighbourhood";

    // The eight minimaps a diagram may show.
    public static readonly System.Collections.ObjectModel.ReadOnlyCollection<string> Ids = Array.AsReadOnly(new[]
    {
        Grid, CodeLocations, Axis, LayerStack, LifecyclePosition, TrackPlacement, EngineStrip, ModuleNeighbourhood,
    });

    public string Id { get; }

    // The axes, outermost first: a cell's At holds one value per axis, in this order.
    public IReadOnlyList<MinimapAxis> Axes { get; }

    // Every cell of the minimap with what it holds.
    public IReadOnlyList<MinimapCell> Cells { get; }

    // The lit cells, each with its reasons.
    public IReadOnlyList<MinimapCell> Lit { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public MinimapData(string id, MinimapAxis[] axes, MinimapCell[] cells, MinimapCell[] lit)
    {
        if (!Ids.Contains(id))
        {
            throw new ArgumentException("minimap id '" + id + "' is not one of: " + string.Join(", ", Ids), nameof(id));
        }
        Id = id;
        Axes = axes ?? Array.Empty<MinimapAxis>();
        Cells = cells ?? Array.Empty<MinimapCell>();
        Lit = lit ?? Array.Empty<MinimapCell>();
        List<string> errors = new List<string>();
        foreach (MinimapCell cell in Cells) { CheckPlace(cell, errors); }
        foreach (MinimapCell cell in Lit)
        {
            CheckPlace(cell, errors);
            if (cell.Reasons.Count == 0) { errors.Add("lit cell [" + string.Join(", ", cell.At) + "] has no reason"); }
        }
        if (errors.Count > 0) { throw new ArgumentException("minimap '" + id + "': " + string.Join("; ", errors)); }
    }

    // The grid: tracks down, file languages across, lit by the highlight's cells and their reasons.
    public static MinimapData FromWorldMap(WorldMap map, WorldMapHighlight highlight)
    {
        if (map == null) { throw new ArgumentNullException(nameof(map)); }
        if (highlight == null) { throw new ArgumentNullException(nameof(highlight)); }
        List<MinimapCell> cells = new List<MinimapCell>();
        foreach (MapCell cell in map.Cells) { cells.Add(new MinimapCell(new[] { cell.Track, cell.FileLanguage }, cell.FileCount)); }
        List<MinimapCell> lit = new List<MinimapCell>();
        foreach (HighlightedCell cell in highlight.Cells)
        {
            List<MinimapReason> reasons = new List<MinimapReason>();
            foreach (HighlightReason reason in cell.Reasons) { reasons.Add(new MinimapReason(reason.Path, reason.Basis, reason.Requested, reason.Note)); }
            lit.Add(new MinimapCell(new[] { cell.Track, cell.FileLanguage }, cell.FileCount, reasons.ToArray()));
        }
        MinimapAxis[] axes = { new MinimapAxis("track", new List<string>(map.Tracks).ToArray()), new MinimapAxis("file_language", new List<string>(map.FileLanguages).ToArray()) };
        return new MinimapData(Grid, axes, cells.ToArray(), lit.ToArray());
    }

    // The axis: value-chain stacks down, concerns across, lit by the ADRs the highlight places.
    public static MinimapData FromValueChain(ValueChainMap map, ValueChainHighlight highlight)
    {
        if (map == null) { throw new ArgumentNullException(nameof(map)); }
        if (highlight == null) { throw new ArgumentNullException(nameof(highlight)); }
        List<MinimapCell> cells = new List<MinimapCell>();
        foreach (ValueChainCell cell in map.Cells) { cells.Add(new MinimapCell(new[] { cell.Stack, cell.Concern }, cell.AdrCount)); }
        List<MinimapCell> lit = new List<MinimapCell>();
        foreach (ValueChainCell cell in highlight.Cells)
        {
            List<MinimapReason> reasons = new List<MinimapReason>();
            foreach (ValueChainReason reason in highlight.ReasonsOf(cell.Stack, cell.Concern))
            {
                reasons.Add(new MinimapReason(reason.Adr, reason.Override ? "concern" : "domain", reason.Requested, reason.Domain));
            }
            lit.Add(new MinimapCell(new[] { cell.Stack, cell.Concern }, cell.AdrCount, reasons.ToArray()));
        }
        MinimapAxis[] axes = { new MinimapAxis("stack", new List<string>(map.Stacks).ToArray()), new MinimapAxis("concern", new List<string>(map.Concerns).ToArray()) };
        return new MinimapData(Axis, axes, cells.ToArray(), lit.ToArray());
    }

    // The data as indented JSON with '\n' line ends, in the contract's shape.
    public string ToJson()
    {
        using (MemoryStream stream = new MemoryStream())
        {
            using (Utf8JsonWriter writer = new Utf8JsonWriter(stream, new JsonWriterOptions { Indented = true }))
            {
                writer.WriteStartObject();
                writer.WriteString("id", Id);
                writer.WriteStartArray("axes");
                foreach (MinimapAxis axis in Axes)
                {
                    writer.WriteStartObject();
                    writer.WriteString("name", axis.Name);
                    ValueChainMap.WriteStrings(writer, "values", axis.Values);
                    writer.WriteEndObject();
                }
                writer.WriteEndArray();
                writer.WriteStartArray("cells");
                foreach (MinimapCell cell in Cells) { WriteCell(writer, cell, false); }
                writer.WriteEndArray();
                writer.WriteStartArray("lit");
                foreach (MinimapCell cell in Lit) { WriteCell(writer, cell, true); }
                writer.WriteEndArray();
                writer.WriteEndObject();
            }
            return Encoding.UTF8.GetString(stream.ToArray()).Replace("\r\n", "\n");
        }
    }

    private void CheckPlace(MinimapCell cell, List<string> errors)
    {
        if (cell.At.Count != Axes.Count)
        {
            errors.Add("cell [" + string.Join(", ", cell.At) + "] names " + cell.At.Count + " axis values, but the minimap has " + Axes.Count + " axes");
        }
    }

    private static void WriteCell(Utf8JsonWriter writer, MinimapCell cell, bool lit)
    {
        writer.WriteStartObject();
        ValueChainMap.WriteStrings(writer, "at", cell.At);
        writer.WriteNumber("count", cell.Count);
        if (lit)
        {
            writer.WriteStartArray("reasons");
            foreach (MinimapReason reason in cell.Reasons)
            {
                writer.WriteStartObject();
                WriteNullable(writer, "subject", reason.Subject);
                writer.WriteString("basis", reason.Basis);
                WriteNullable(writer, "requested", reason.Requested);
                WriteNullable(writer, "note", reason.Note);
                writer.WriteEndObject();
            }
            writer.WriteEndArray();
        }
        writer.WriteEndObject();
    }

    private static void WriteNullable(Utf8JsonWriter writer, string name, string value)
    {
        if (value == null) { writer.WriteNull(name); } else { writer.WriteString(name, value); }
    }
}
