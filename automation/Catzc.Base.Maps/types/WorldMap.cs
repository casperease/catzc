/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/types/WorldMap.cs
    kind: csharp-type
    module: Catzc.Base.Maps
    relatives:
      page: docs/references/automation/catzc-base-maps/types/WorldMap.cs.md
    adrs:
      - ADR-DSGN-TRACK#{1,6}
      - ADR-THES-ONETRUTH#3
---
*/

using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text;
using System.Text.Json;

namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Tracks), nameof(FileLanguages), nameof(FileCount))]
public sealed class WorldMap
{
    // The row of the files under no track.
    public const string NoTrack = "(no track)";

    // The column of the files no file language names.
    public const string NoFileLanguage = "(other)";

    private readonly Dictionary<string, MapCell> cellByKey = new Dictionary<string, MapCell>(StringComparer.Ordinal);
    private readonly Dictionary<string, MapPlacement> placementByPath = new Dictionary<string, MapPlacement>(StringComparer.Ordinal);

    // The rows: the declared tracks in ordinal order, then NoTrack.
    public IReadOnlyList<string> Tracks { get; }

    // The columns: the registered file languages in ordinal order, then NoFileLanguage.
    public IReadOnlyList<string> FileLanguages { get; }

    // Every cell of the grid, row by row, empty cells included.
    public IReadOnlyList<MapCell> Cells { get; }

    // Every tracked file's placement, in ordinal path order.
    public IReadOnlyList<MapPlacement> Placements { get; }

    // The placed files that break their track's tech-stack, in ordinal path order.
    public IReadOnlyList<MapPlacement> StackViolations { get; }

    // The adrs index the citations were resolved against: ADR code -> domain.
    public IReadOnlyDictionary<string, string> AdrIndex { get; }

    // The tracked files placed: the sum of every cell's FileCount.
    public int FileCount => Placements.Count;

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public WorldMap(string[] tracks, string[] fileLanguages, MapPlacement[] placements, IReadOnlyDictionary<string, string> adrIndex)
    {
        Tracks = Axis(tracks, NoTrack, "track");
        FileLanguages = Axis(fileLanguages, NoFileLanguage, "file language");
        AdrIndex = adrIndex ?? new Dictionary<string, string>(StringComparer.Ordinal);

        HashSet<string> rows = new HashSet<string>(Tracks, StringComparer.Ordinal);
        HashSet<string> columns = new HashSet<string>(FileLanguages, StringComparer.Ordinal);
        List<MapPlacement> sorted = new List<MapPlacement>();
        Dictionary<string, int> counts = new Dictionary<string, int>(StringComparer.Ordinal);
        HashSet<string> flagged = new HashSet<string>(StringComparer.Ordinal);
        foreach (MapPlacement placement in placements ?? Array.Empty<MapPlacement>())
        {
            if (placement == null) { throw new ArgumentException("world map: a placement is null"); }
            if (!rows.Contains(placement.Track ?? ""))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "world map: '{0}' is placed in the unknown track '{1}'",
                    placement.Path, placement.Track));
            }
            if (!columns.Contains(placement.FileLanguage ?? ""))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    "world map: '{0}' is placed in the unknown file language '{1}'", placement.Path, placement.FileLanguage));
            }
            if (placementByPath.ContainsKey(placement.Path ?? ""))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "world map: '{0}' is placed twice", placement.Path));
            }
            placementByPath[placement.Path ?? ""] = placement;
            sorted.Add(placement);
            string key = Key(placement.Track, placement.FileLanguage);
            int count;
            counts[key] = counts.TryGetValue(key, out count) ? count + 1 : 1;
            if (placement.StackViolation) { flagged.Add(key); }
        }
        sorted.Sort((a, b) => string.CompareOrdinal(a.Path, b.Path));
        Placements = sorted.ToArray();
        StackViolations = sorted.FindAll(p => p.StackViolation).ToArray();

        List<MapCell> cells = new List<MapCell>();
        foreach (string track in Tracks)
        {
            foreach (string fileLanguage in FileLanguages)
            {
                string key = Key(track, fileLanguage);
                int count;
                MapCell cell = new MapCell(track, fileLanguage, counts.TryGetValue(key, out count) ? count : 0, flagged.Contains(key));
                cells.Add(cell);
                cellByKey[key] = cell;
            }
        }
        Cells = cells.ToArray();
    }

    // The cell of a track and a file language, or null when the grid has no such row or column.
    public MapCell Cell(string track, string fileLanguage)
    {
        MapCell cell;
        return cellByKey.TryGetValue(Key(track, fileLanguage), out cell) ? cell : null;
    }

    // The placement of a tracked file ('\' accepted as '/'), or null when the map does not hold it.
    public MapPlacement Placement(string path)
    {
        MapPlacement placement;
        return placementByPath.TryGetValue((path ?? "").Replace('\\', '/'), out placement) ? placement : null;
    }

    // The map as indented JSON with '\n' line ends: the axes, the cells, and the files with their placement.
    public string ToJson()
    {
        using (MemoryStream stream = new MemoryStream())
        {
            using (Utf8JsonWriter writer = new Utf8JsonWriter(stream, new JsonWriterOptions { Indented = true }))
            {
                writer.WriteStartObject();
                writer.WriteStartArray("tracks");
                foreach (string track in Tracks) { writer.WriteStringValue(track); }
                writer.WriteEndArray();
                writer.WriteStartArray("file_languages");
                foreach (string fileLanguage in FileLanguages) { writer.WriteStringValue(fileLanguage); }
                writer.WriteEndArray();
                writer.WriteNumber("file_count", FileCount);
                writer.WriteStartArray("cells");
                foreach (MapCell cell in Cells)
                {
                    writer.WriteStartObject();
                    writer.WriteString("track", cell.Track);
                    writer.WriteString("file_language", cell.FileLanguage);
                    writer.WriteNumber("file_count", cell.FileCount);
                    writer.WriteBoolean("stack_violation", cell.StackViolation);
                    writer.WriteEndObject();
                }
                writer.WriteEndArray();
                writer.WriteStartArray("files");
                foreach (MapPlacement placement in Placements)
                {
                    writer.WriteStartObject();
                    writer.WriteString("path", placement.Path);
                    writer.WriteString("track", placement.Track);
                    writer.WriteString("file_language", placement.FileLanguage);
                    writer.WriteBoolean("live", placement.Live);
                    writer.WriteBoolean("stack_violation", placement.StackViolation);
                    writer.WriteString("basis", placement.Basis);
                    if (placement.Adr == null) { writer.WriteNull("adr"); } else { writer.WriteString("adr", placement.Adr); }
                    writer.WriteStartArray("citations");
                    foreach (string citation in placement.Citations) { writer.WriteStringValue(citation); }
                    writer.WriteEndArray();
                    writer.WriteEndObject();
                }
                writer.WriteEndArray();
                writer.WriteEndObject();
            }
            return Encoding.UTF8.GetString(stream.ToArray()).Replace("\r\n", "\n");
        }
    }

    private static string Key(string track, string fileLanguage) => (track ?? "") + "\u0000" + (fileLanguage ?? "");

    private static string[] Axis(string[] names, string bucket, string what)
    {
        SortedSet<string> sorted = new SortedSet<string>(StringComparer.Ordinal);
        foreach (string name in names ?? Array.Empty<string>())
        {
            if (string.IsNullOrEmpty(name) || string.Equals(name, bucket, StringComparison.Ordinal))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "world map: invalid {0} name '{1}'", what, name));
            }
            if (!sorted.Add(name))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "world map: the {0} '{1}' is listed twice", what, name));
            }
        }
        List<string> axis = new List<string>(sorted);
        axis.Add(bucket);
        return axis.ToArray();
    }
}
