/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/types/WorldMapHighlight.cs
    kind: type
    module: Catzc.Base.Maps
    adrs:
      - ADR-DSGN-TRACK#1
      - ADR-THES-ONETRUTH#3
---
*/

// A pin wins over an exception, and an ADR's domain never lights a file: it only picks the value-chain row.
// [ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1),
// [ADR-THES-ONETRUTH#3](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)
// [comment:1](/docs/references/automation/catzc-base-maps/types/WorldMapHighlight.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Management.Automation;
using System.Text;
using System.Text.Json;

namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Kind), nameof(Requested), nameof(Cells))]
public sealed class WorldMapHighlight
{
    // The kind of a request of ADR references.
    public const string KindAdr = "adr";

    // The kind of a request of files.
    public const string KindPath = "path";

    // KindAdr or KindPath.
    public string Kind { get; }

    // The request: canonical ADR citations (ADR-<CODE> or ADR-<CODE>#n), or repository-relative paths, in given order.
    public IReadOnlyList<string> Requested { get; }

    // The lit cells, in the map's order.
    public IReadOnlyList<HighlightedCell> Cells { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public WorldMapHighlight(string kind, string[] requested, HighlightedCell[] cells)
    {
        Kind = kind;
        Requested = requested == null ? Array.Empty<string>() : (string[])requested.Clone();
        Cells = cells == null ? Array.Empty<HighlightedCell>() : (HighlightedCell[])cells.Clone();
    }

    // An unlisted ADR code throws, and so does a pin or exception naming a cell the map lacks, so a stale pin fails loudly.
    // [comment:2](/docs/references/automation/catzc-base-maps/types/WorldMapHighlight.cs.md#comment2)
    public static WorldMapHighlight ForAdr(WorldMap map, IEnumerable references, IEnumerable pins, IEnumerable exceptions)
    {
        if (map == null) { throw new ArgumentNullException(nameof(map)); }
        List<string> errors = new List<string>();
        List<string> requested = new List<string>();
        foreach (string reference in Strings(references))
        {
            string canonical = CitationScanner.Canonical(reference);
            string domain = CitationScanner.DomainOf(canonical, map.AdrIndex);
            if (canonical == null || domain == null)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "'{0}' is not an ADR code of the adrs index", reference));
                continue;
            }
            if (!requested.Contains(canonical)) { requested.Add(canonical); }
        }
        List<MapsPin> pinList = Pins(pins, "pin", map, errors);
        List<MapsPin> exceptionList = Pins(exceptions, "exception", map, errors);
        if (errors.Count > 0) { throw new ArgumentException("world-map highlight: " + string.Join("; ", errors)); }

        Lit lit = new Lit();
        foreach (MapPlacement placement in map.Placements)
        {
            if (placement.Adr != null)
            {
                foreach (string request in requested)
                {
                    if (!string.Equals(CitationScanner.CodeOf(request), placement.Adr, StringComparison.Ordinal)) { continue; }
                    lit.Add(placement.Track, placement.FileLanguage, placement.Path, placement.Basis,
                        new HighlightReason(placement.Path, placement.Basis, request, null, null));
                }
                continue;
            }
            foreach (string request in requested)
            {
                List<CitationSite> sites = new List<CitationSite>();
                bool covered = false;
                foreach (string citation in placement.Citations) { covered |= CitationScanner.Covers(request, citation); }
                if (!covered) { continue; }
                foreach (CitationSite site in placement.Sites)
                {
                    if (CitationScanner.Covers(request, site.Citation)) { sites.Add(site); }
                }
                lit.Add(placement.Track, placement.FileLanguage, placement.Path, placement.Basis,
                    new HighlightReason(placement.Path, placement.Basis, request, sites.ToArray(), null));
            }
        }
        foreach (MapsPin exception in exceptionList)
        {
            if (AnyCovers(requested, CitationScanner.Canonical(exception.adr))) { lit.Remove(exception.track, exception.file_language); }
        }
        foreach (MapsPin pin in pinList)
        {
            string canonical = CitationScanner.Canonical(pin.adr);
            if (AnyCovers(requested, canonical))
            {
                lit.Add(pin.track, pin.file_language, null, HighlightedCell.SourcePin,
                    new HighlightReason(null, HighlightedCell.SourcePin, canonical, null, pin.reason));
            }
        }
        return new WorldMapHighlight(KindAdr, requested.ToArray(), lit.InOrderOf(map));
    }

    // The cells files sit in. A path the map does not hold throws.
    public static WorldMapHighlight ForPaths(WorldMap map, IEnumerable paths)
    {
        if (map == null) { throw new ArgumentNullException(nameof(map)); }
        List<string> errors = new List<string>();
        List<string> requested = new List<string>();
        Lit lit = new Lit();
        foreach (string path in Strings(paths))
        {
            MapPlacement placement = map.Placement(path);
            if (placement == null)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "'{0}' is not a tracked file of the map", path));
                continue;
            }
            if (!requested.Contains(placement.Path)) { requested.Add(placement.Path); }
            lit.Add(placement.Track, placement.FileLanguage, placement.Path, HighlightedCell.SourcePath,
                new HighlightReason(placement.Path, HighlightedCell.SourcePath, null, null, null));
        }
        if (errors.Count > 0) { throw new ArgumentException("world-map highlight: " + string.Join("; ", errors)); }
        return new WorldMapHighlight(KindPath, requested.ToArray(), lit.InOrderOf(map));
    }

    // The highlight as indented JSON with '\n' line ends.
    public string ToJson()
    {
        using (MemoryStream stream = new MemoryStream())
        {
            using (Utf8JsonWriter writer = new Utf8JsonWriter(stream, new JsonWriterOptions { Indented = true }))
            {
                writer.WriteStartObject();
                writer.WriteString("kind", Kind);
                writer.WriteStartArray("requested");
                foreach (string item in Requested) { writer.WriteStringValue(item); }
                writer.WriteEndArray();
                writer.WriteStartArray("cells");
                foreach (HighlightedCell cell in Cells)
                {
                    writer.WriteStartObject();
                    writer.WriteString("track", cell.Track);
                    writer.WriteString("file_language", cell.FileLanguage);
                    writer.WriteNumber("file_count", cell.FileCount);
                    writer.WriteStartArray("sources");
                    foreach (string source in cell.Sources) { writer.WriteStringValue(source); }
                    writer.WriteEndArray();
                    writer.WriteStartArray("files");
                    foreach (string file in cell.Files) { writer.WriteStringValue(file); }
                    writer.WriteEndArray();
                    writer.WriteBoolean("touched", cell.Touched);
                    writer.WriteStartArray("reasons");
                    foreach (HighlightReason reason in cell.Reasons) { WriteReason(writer, reason); }
                    writer.WriteEndArray();
                    writer.WriteEndObject();
                }
                writer.WriteEndArray();
                writer.WriteEndObject();
            }
            return Encoding.UTF8.GetString(stream.ToArray()).Replace("\r\n", "\n");
        }
    }

    private static void WriteReason(Utf8JsonWriter writer, HighlightReason reason)
    {
        writer.WriteStartObject();
        WriteNullable(writer, "path", reason.Path);
        writer.WriteString("basis", reason.Basis);
        WriteNullable(writer, "requested", reason.Requested);
        WriteNullable(writer, "note", reason.Note);
        writer.WriteBoolean("mention", reason.Mention);
        writer.WriteStartArray("sites");
        foreach (CitationSite site in reason.Sites)
        {
            writer.WriteStartObject();
            writer.WriteString("path", site.Path);
            writer.WriteNumber("line", site.Line);
            writer.WriteString("kind", site.Kind);
            writer.WriteString("citation", site.Citation);
            writer.WriteEndObject();
        }
        writer.WriteEndArray();
        writer.WriteEndObject();
    }

    private static void WriteNullable(Utf8JsonWriter writer, string name, string value)
    {
        if (value == null) { writer.WriteNull(name); } else { writer.WriteString(name, value); }
    }

    private static bool AnyCovers(List<string> requested, string cited)
    {
        foreach (string request in requested)
        {
            if (CitationScanner.Covers(request, cited)) { return true; }
        }
        return false;
    }

    private static List<MapsPin> Pins(IEnumerable raw, string what, WorldMap map, List<string> errors)
    {
        List<MapsPin> pins = new List<MapsPin>();
        if (raw == null) { return pins; }
        foreach (object item in raw)
        {
            object value = item is PSObject wrapped ? wrapped.BaseObject : item;
            MapsPin pin = value as MapsPin;
            if (pin == null)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "a {0} is not a {1}", what, typeof(MapsPin).FullName));
                continue;
            }
            if (map.Cell(pin.track, pin.file_language) == null)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "the {0} for '{1}' names the cell '{2}' x '{3}', which the map does not have", what,
                    pin.adr, pin.track, pin.file_language));
                continue;
            }
            if (CitationScanner.DomainOf(CitationScanner.Canonical(pin.adr), map.AdrIndex) == null)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "the {0} names '{1}', which is not an ADR code of the adrs index", what, pin.adr));
                continue;
            }
            pins.Add(pin);
        }
        return pins;
    }

    private static List<string> Strings(IEnumerable raw)
    {
        List<string> items = new List<string>();
        if (raw == null) { return items; }
        if (raw is string single)
        {
            items.Add(single);
            return items;
        }
        foreach (object item in raw)
        {
            object value = item is PSObject wrapped ? wrapped.BaseObject : item;
            string text = Convert.ToString(value, CultureInfo.InvariantCulture);
            if (!string.IsNullOrEmpty(text)) { items.Add(text); }
        }
        return items;
    }

    // The lit cells while a highlight is computed: per cell, its lit files, sources and reasons.
    private sealed class Lit
    {
        private readonly Dictionary<string, SortedSet<string>> files = new Dictionary<string, SortedSet<string>>(StringComparer.Ordinal);
        private readonly Dictionary<string, SortedSet<string>> sources = new Dictionary<string, SortedSet<string>>(StringComparer.Ordinal);
        private readonly Dictionary<string, List<HighlightReason>> reasons = new Dictionary<string, List<HighlightReason>>(StringComparer.Ordinal);

        public void Add(string track, string fileLanguage, string path, string source, HighlightReason reason)
        {
            string key = Key(track, fileLanguage);
            if (!files.ContainsKey(key))
            {
                files[key] = new SortedSet<string>(StringComparer.Ordinal);
                sources[key] = new SortedSet<string>(StringComparer.Ordinal);
                reasons[key] = new List<HighlightReason>();
            }
            if (path != null) { files[key].Add(path); }
            sources[key].Add(source);
            reasons[key].Add(reason);
        }

        public void Remove(string track, string fileLanguage)
        {
            string key = Key(track, fileLanguage);
            files.Remove(key);
            sources.Remove(key);
            reasons.Remove(key);
        }

        public HighlightedCell[] InOrderOf(WorldMap map)
        {
            List<HighlightedCell> cells = new List<HighlightedCell>();
            foreach (MapCell cell in map.Cells)
            {
                string key = Key(cell.Track, cell.FileLanguage);
                if (!files.ContainsKey(key)) { continue; }
                cells.Add(new HighlightedCell(cell.Track, cell.FileLanguage, ToArray(files[key]), ToArray(sources[key]), InFileOrder(reasons[key])));
            }
            return cells.ToArray();
        }

        // The reasons by file (ordinal; a pin's, with no file, last), keeping the request order within a file.
        private static HighlightReason[] InFileOrder(List<HighlightReason> list)
        {
            List<KeyValuePair<int, HighlightReason>> indexed = new List<KeyValuePair<int, HighlightReason>>();
            for (int i = 0; i < list.Count; i++) { indexed.Add(new KeyValuePair<int, HighlightReason>(i, list[i])); }
            indexed.Sort((a, b) =>
            {
                if (a.Value.Path == null || b.Value.Path == null)
                {
                    int byPin = (a.Value.Path == null).CompareTo(b.Value.Path == null);
                    if (byPin != 0) { return byPin; }
                    return a.Key.CompareTo(b.Key);
                }
                int byPath = string.CompareOrdinal(a.Value.Path, b.Value.Path);
                return byPath != 0 ? byPath : a.Key.CompareTo(b.Key);
            });
            HighlightReason[] result = new HighlightReason[indexed.Count];
            for (int i = 0; i < indexed.Count; i++) { result[i] = indexed[i].Value; }
            return result;
        }

        public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

        private static string Key(string track, string fileLanguage) => (track ?? "") + "\u0000" + (fileLanguage ?? "");

        private static string[] ToArray(SortedSet<string> set)
        {
            string[] array = new string[set.Count];
            set.CopyTo(array);
            return array;
        }
    }
}
