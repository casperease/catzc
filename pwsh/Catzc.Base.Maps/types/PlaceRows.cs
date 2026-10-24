using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;

namespace Catzc.Base.Maps;

// The rows of the "Where does it live?" minimap: each lit place in its one minimised form, grouped in the configured order, within the
// row budget, and the counters line under them (ADR-AUTO-IDIOM-PLACENORMALFORM). A place is the triple [track, module, folder] of the
// code-locations minimap; its path is normalised by RepoRelativePath (ADR-AUTO-PATH) before it is minimised.
[Catzc.Base.Objects.ConsoleDisplay(nameof(Rows), nameof(Counters))]
public sealed class PlaceRows
{
    public const string Separator = " / ";
    private const string NoModule = "-";
    private const string ModuleRoot = ".";
    private const string Fold = "+";

    // The rows, in order, each at most the configured characters unless one segment is longer than that.
    public IReadOnlyList<string> Rows { get; }

    // The line under the rows: the overflow count when places did not fit, and how many places there are.
    public string Counters { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public PlaceRows(IReadOnlyList<string> rows, string counters)
    {
        Rows = rows ?? Array.Empty<string>();
        Counters = counters ?? "";
    }

    private sealed class Entry
    {
        public string Track;
        public string Module;
        public string Folder;
        public string Text;
        public int Group;
        public int Places = 1;
    }

    // The rows for the lit places of a code-locations minimap: one row a place; while the places are more than the budget, the rows of
    // the module with the most rows fold into one `track / Module / +k` row; then the first rows that fit, and a count of the rest.
    public static PlaceRows From(IReadOnlyList<MinimapCell> lit, MapsMinimapPlaces places)
    {
        if (lit == null) { throw new ArgumentNullException(nameof(lit)); }
        if (places == null) { throw new ArgumentNullException(nameof(places)); }
        List<Entry> entries = new List<Entry>();
        HashSet<string> seen = new HashSet<string>(StringComparer.Ordinal);
        foreach (MinimapCell cell in lit)
        {
            if (cell.At.Count != 3) { throw new ArgumentException("a place has three parts: track, module, folder"); }
            if (!seen.Add(Identity(cell.At[0], cell.At[1], cell.At[2]))) { continue; }
            Entry entry = new Entry { Track = cell.At[0], Module = cell.At[1], Folder = cell.At[2] };
            entry.Group = GroupIndex(entry, places);
            entry.Text = Form(entry.Track, entry.Module, entry.Folder, places);
            entries.Add(entry);
        }
        int total = entries.Count;
        Sort(entries);
        while (entries.Count > places.rows && FoldMostCrowdedModule(entries, places)) { }
        int hidden = 0;
        if (entries.Count > places.rows)
        {
            for (int i = places.rows; i < entries.Count; i++) { hidden += entries[i].Places; }
            entries.RemoveRange(places.rows, entries.Count - places.rows);
        }
        List<string> rows = new List<string>();
        foreach (Entry entry in entries) { rows.Add(entry.Text); }
        string counters = "";
        if (places.counter_rows > 0)
        {
            counters = (hidden > 0 ? "+" + hidden.ToString(CultureInfo.InvariantCulture) + " more · " : "")
                + total.ToString(CultureInfo.InvariantCulture) + (total == 1 ? " place" : " places");
        }
        return new PlaceRows(rows.AsReadOnly(), counters);
    }

    // The one minimised form of a place: track / module (prefix dropped) / folder, a placeholder part (no module, the module's own root)
    // left out, and the middle of the module elided at a segment boundary when the row is longer than the budget.
    public static string Form(string track, string module, string folder, MapsMinimapPlaces places)
    {
        if (places == null) { throw new ArgumentNullException(nameof(places)); }
        string[] segments = Identity(track, module, folder).Split('/');
        string shown = module == NoModule ? "" : WithoutPrefix(module, places);
        string tail = folder == ModuleRoot ? "" : new Catzc.Base.Objects.RepoRelativePath(folder).Relative;
        return Fit(segments[0], shown, tail, places);
    }

    // The place a row names, back from its minimised form with the module's prefix restored. A row that elided its middle or folded
    // places names no one place and throws.
    public static string[] Recover(string row, MapsMinimapPlaces places)
    {
        if (row == null) { throw new ArgumentNullException(nameof(row)); }
        if (places == null) { throw new ArgumentNullException(nameof(places)); }
        if (row.Contains(places.elision)) { throw new ArgumentException("row '" + row + "' elides its middle and names no one place"); }
        string[] parts = row.Split(new[] { Separator }, StringSplitOptions.None);
        if (parts.Length > 1 && parts[parts.Length - 1].StartsWith(Fold, StringComparison.Ordinal))
        {
            throw new ArgumentException("row '" + row + "' folds places and names no one place");
        }
        if (parts.Length == 1) { return new[] { parts[0], NoModule, ModuleRoot }; }
        if (parts.Length == 2) { return new[] { parts[0], places.drop_prefix + parts[1], ModuleRoot }; }
        if (parts.Length == 3) { return new[] { parts[0], places.drop_prefix + parts[1], parts[2] }; }
        throw new ArgumentException("row '" + row + "' has more than three parts");
    }

    // Whether a row is already in the one minimised form: three parts at most, no kept module prefix, and within the budget unless a
    // single part is itself longer than it.
    public static bool IsNormal(string row, MapsMinimapPlaces places)
    {
        if (row == null || places == null) { return false; }
        string[] parts = row.Split(new[] { Separator }, StringSplitOptions.None);
        if (parts.Length > 3) { return false; }
        if (places.drop_prefix.Length > 0 && parts.Length > 1 && parts[1].StartsWith(places.drop_prefix, StringComparison.Ordinal)) { return false; }
        if (row.Length <= places.row_chars) { return true; }
        foreach (string part in parts) { if (part.Length > places.row_chars) { return true; } }
        return false;
    }

    private static bool FoldMostCrowdedModule(List<Entry> entries, MapsMinimapPlaces places)
    {
        Dictionary<string, int> perModule = new Dictionary<string, int>(StringComparer.Ordinal);
        foreach (Entry entry in entries)
        {
            if (entry.Module == NoModule) { continue; }
            string key = entry.Track + "\t" + entry.Module;
            perModule[key] = perModule.GetValueOrDefault(key) + 1;
        }
        string best = null;
        int most = 1;
        foreach (KeyValuePair<string, int> pair in perModule)
        {
            if (pair.Value > most || (pair.Value == most && best != null && string.CompareOrdinal(pair.Key, best) > 0))
            {
                best = pair.Key;
                most = pair.Value;
            }
        }
        if (best == null) { return false; }
        string[] parts = best.Split('\t');
        int count = 0;
        int first = entries.Count;
        for (int i = entries.Count - 1; i >= 0; i--)
        {
            if (entries[i].Track == parts[0] && entries[i].Module == parts[1])
            {
                count += entries[i].Places;
                first = i;
                entries.RemoveAt(i);
            }
        }
        string folded = Fold + count.ToString(CultureInfo.InvariantCulture);
        Entry row = new Entry { Track = parts[0], Module = parts[1], Folder = folded, Places = count };
        row.Group = places.group_order.Count == 0 ? 0 : IndexOf(places.group_order, "sub-folders");
        row.Text = Fit(parts[0], WithoutPrefix(parts[1], places), folded, places);
        entries.Insert(Math.Min(first, entries.Count), row);
        Sort(entries);
        return true;
    }

    private static string Identity(string track, string module, string folder)
    {
        StringBuilder text = new StringBuilder(track);
        if (module != NoModule) { text.Append('/').Append(module); }
        if (folder != ModuleRoot) { text.Append('/').Append(folder); }
        return new Catzc.Base.Objects.RepoRelativePath(text.ToString()).Relative;
    }

    private static string WithoutPrefix(string module, MapsMinimapPlaces places) =>
        places.drop_prefix.Length > 0 && module.StartsWith(places.drop_prefix, StringComparison.Ordinal) ? module.Substring(places.drop_prefix.Length) : module;

    // The row of its parts within the budget. When too long, the module keeps its first segment and as many of its last as fit, the
    // middle replaced by the elision; then only its last segments. The cut is always between two dotted segments.
    private static string Fit(string track, string module, string tail, MapsMinimapPlaces places)
    {
        string row = Join(track, module, tail);
        if (row.Length <= places.row_chars || module.Length == 0) { return row; }
        string[] segments = module.Split('.');
        for (int head = 1; head >= 0; head--)
        {
            for (int keep = segments.Length - 1; keep >= 1; keep--)
            {
                if (head + keep >= segments.Length) { continue; }
                string elided = string.Join(".", segments, 0, head) + places.elision + string.Join(".", segments, segments.Length - keep, keep);
                string candidate = Join(track, elided, tail);
                if (candidate.Length <= places.row_chars) { return candidate; }
            }
        }
        return Join(track, places.elision + segments[segments.Length - 1], tail);
    }

    private static string Join(string track, string module, string tail)
    {
        StringBuilder text = new StringBuilder(track);
        if (module.Length > 0) { text.Append(Separator).Append(module); }
        if (tail.Length > 0) { text.Append(Separator).Append(tail); }
        return text.ToString();
    }

    private static int IndexOf(IReadOnlyList<string> list, string value)
    {
        for (int i = 0; i < list.Count; i++) { if (string.Equals(list[i], value, StringComparison.Ordinal)) { return i; } }
        return list.Count;
    }

    private static int GroupIndex(Entry entry, MapsMinimapPlaces places)
    {
        string group = entry.Track == "docs" ? "docs" : entry.Module == NoModule ? "rest" : entry.Folder == ModuleRoot ? "modules" : "sub-folders";
        return IndexOf(places.group_order, group);
    }

    private static void Sort(List<Entry> entries) =>
        entries.Sort((a, b) =>
        {
            int by = a.Group.CompareTo(b.Group);
            if (by != 0) { return by; }
            by = string.CompareOrdinal(a.Track, b.Track);
            if (by != 0) { return by; }
            by = string.CompareOrdinal(a.Module, b.Module);
            return by != 0 ? by : string.CompareOrdinal(a.Folder, b.Folder);
        });
}
