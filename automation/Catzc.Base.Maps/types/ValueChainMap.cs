// The value-chain map: the rows of the value-chain stack crossed with the value-chain concerns, every cell of that grid,
// and the ADRs each cell holds ([ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16)). An ADR sits on
// its ADR domain's row (AdrRuleSet.Stack, [ADR-DSGN-TRACK#14](/docs/adr/design/tracks.md#rule-adr-dsgn-track14)) in the
// column of each of its value-chain concerns (AdrRuleSet.Concerns, an override or its ADR domain's default,
// [ADR-DSGN-TRACK#15](/docs/adr/design/tracks.md#rule-adr-dsgn-track15)), so it sits in one or more cells of one row.
//
// Build takes the axes and the ADRs (Get-ValueChainMap passes AdrsConfig.Stacks, AdrsConfig.Concerns and the adrs.yml
// rule-sets). The AdrsConfig load rejects an unknown row or value-chain concern, so on the registry every ADR sits in a
// cell; the map still records what it cannot place instead of dropping it: Strays names each row or value-chain concern
// an ADR declares that the axes lack, and Unplaced each ADR that sits in no cell. Test-ValueChainMap reports both.
//
// The order is deterministic: rows and columns as given, cells row by row, the ADRs of a cell in the given order. ToJson
// is its data form ([ADR-THES-ONETRUTH#3](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)).

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Management.Automation;
using System.Text;
using System.Text.Json;

namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Stacks), nameof(Concerns), nameof(AdrCount))]
public sealed class ValueChainMap
{
    private readonly Dictionary<string, ValueChainCell> cellByKey = new Dictionary<string, ValueChainCell>(StringComparer.Ordinal);
    private readonly Dictionary<string, ValueChainCell[]> cellsByAdr = new Dictionary<string, ValueChainCell[]>(StringComparer.Ordinal);
    private readonly Dictionary<string, Catzc.Base.Docs.AdrRuleSet> ruleSetByAdr;

    // The rows: the rows of the value-chain stack, top to bottom.
    public IReadOnlyList<string> Stacks { get; }

    // The columns: the value-chain concerns, in value-chain order.
    public IReadOnlyList<string> Concerns { get; }

    // Every cell of the grid, row by row, empty cells included.
    public IReadOnlyList<ValueChainCell> Cells { get; }

    // Every ADR code the map was built from, in the given order.
    public IReadOnlyList<string> Adrs { get; }

    // The ADR codes that sit in no cell, in the given order.
    public IReadOnlyList<string> Unplaced { get; }

    // One finding per row or value-chain concern an ADR declares that the axes lack, in the given order.
    public IReadOnlyList<string> Strays { get; }

    // The number of ADRs the map was built from.
    public int AdrCount => Adrs.Count;

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private ValueChainMap(string[] stacks, string[] concerns, ValueChainCell[] cells, string[] adrs, string[] unplaced, string[] strays,
        Dictionary<string, List<string>> keysByAdr, Dictionary<string, Catzc.Base.Docs.AdrRuleSet> ruleSets)
    {
        ruleSetByAdr = ruleSets;
        Stacks = stacks;
        Concerns = concerns;
        Cells = cells;
        Adrs = adrs;
        Unplaced = unplaced;
        Strays = strays;
        foreach (ValueChainCell cell in cells) { cellByKey[Key(cell.Stack, cell.Concern)] = cell; }
        foreach (string adr in adrs)
        {
            List<ValueChainCell> sitsIn = new List<ValueChainCell>();
            foreach (ValueChainCell cell in cells)
            {
                if (keysByAdr[adr].Contains(Key(cell.Stack, cell.Concern))) { sitsIn.Add(cell); }
            }
            cellsByAdr[adr] = sitsIn.ToArray();
        }
    }

    // The map of the given rows, columns and ADRs (Catzc.Base.Docs.AdrRuleSet items). An empty or repeated axis name, an
    // item that is not an AdrRuleSet, or a repeated ADR code throws.
    public static ValueChainMap Build(IEnumerable stacks, IEnumerable concerns, IEnumerable ruleSets)
    {
        string[] rows = Axis(stacks, "row of the value-chain stack");
        string[] columns = Axis(concerns, "value-chain concern");
        HashSet<string> rowSet = new HashSet<string>(rows, StringComparer.Ordinal);
        HashSet<string> columnSet = new HashSet<string>(columns, StringComparer.Ordinal);

        List<string> adrs = new List<string>();
        List<string> unplaced = new List<string>();
        List<string> strays = new List<string>();
        Dictionary<string, List<string>> keysByAdr = new Dictionary<string, List<string>>(StringComparer.Ordinal);
        Dictionary<string, List<string>> adrsByKey = new Dictionary<string, List<string>>(StringComparer.Ordinal);
        Dictionary<string, Catzc.Base.Docs.AdrRuleSet> ruleSetByAdr = new Dictionary<string, Catzc.Base.Docs.AdrRuleSet>(StringComparer.Ordinal);
        foreach (object item in ruleSets ?? Array.Empty<object>())
        {
            object value = item is PSObject wrapped ? wrapped.BaseObject : item;
            Catzc.Base.Docs.AdrRuleSet ruleSet = value as Catzc.Base.Docs.AdrRuleSet;
            if (ruleSet == null)
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "value-chain map: an ADR is not a {0}",
                    typeof(Catzc.Base.Docs.AdrRuleSet).FullName));
            }
            string adr = ruleSet.External;
            if (string.IsNullOrEmpty(adr) || keysByAdr.ContainsKey(adr))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "value-chain map: the ADR code '{0}' is empty or repeated", adr));
            }
            adrs.Add(adr);
            ruleSetByAdr[adr] = ruleSet;
            List<string> keys = new List<string>();
            keysByAdr[adr] = keys;
            bool onRow = rowSet.Contains(ruleSet.Stack ?? "");
            if (!onRow)
            {
                strays.Add(string.Format(CultureInfo.InvariantCulture, "{0}: '{1}' is not a row of the value-chain stack ({2})", adr, ruleSet.Stack,
                    string.Join(", ", rows)));
            }
            foreach (string concern in ruleSet.Concerns ?? Array.Empty<string>())
            {
                if (!columnSet.Contains(concern ?? ""))
                {
                    strays.Add(string.Format(CultureInfo.InvariantCulture, "{0}: '{1}' is not a value-chain concern ({2})", adr, concern,
                        string.Join(", ", columns)));
                    continue;
                }
                string key = Key(ruleSet.Stack, concern);
                if (!onRow || keys.Contains(key)) { continue; }
                keys.Add(key);
                if (!adrsByKey.ContainsKey(key)) { adrsByKey[key] = new List<string>(); }
                adrsByKey[key].Add(adr);
            }
            if (keys.Count == 0) { unplaced.Add(adr); }
        }

        List<ValueChainCell> cells = new List<ValueChainCell>();
        foreach (string row in rows)
        {
            foreach (string column in columns)
            {
                List<string> inCell;
                adrsByKey.TryGetValue(Key(row, column), out inCell);
                cells.Add(new ValueChainCell(row, column, inCell == null ? Array.Empty<string>() : inCell.ToArray()));
            }
        }
        return new ValueChainMap(rows, columns, cells.ToArray(), adrs.ToArray(), unplaced.ToArray(), strays.ToArray(), keysByAdr, ruleSetByAdr);
    }

    // The registry entry an ADR code was placed from (its ADR domain, row and value-chain concerns), or null.
    public Catzc.Base.Docs.AdrRuleSet RuleSetOf(string adr)
    {
        Catzc.Base.Docs.AdrRuleSet ruleSet;
        return adr != null && ruleSetByAdr.TryGetValue(adr, out ruleSet) ? ruleSet : null;
    }

    // The cell of a row and a column, or null when the map has none.
    public ValueChainCell Cell(string stack, string concern)
    {
        ValueChainCell cell;
        return cellByKey.TryGetValue(Key(stack, concern), out cell) ? cell : null;
    }

    // The cells an ADR code sits in, in the map's order; null when the map was not built from that code.
    public IReadOnlyList<ValueChainCell> CellsOf(string adr)
    {
        ValueChainCell[] cells;
        return adr != null && cellsByAdr.TryGetValue(adr, out cells) ? cells : null;
    }

    // The map as indented JSON with '\n' line ends.
    public string ToJson()
    {
        using (MemoryStream stream = new MemoryStream())
        {
            using (Utf8JsonWriter writer = new Utf8JsonWriter(stream, new JsonWriterOptions { Indented = true }))
            {
                writer.WriteStartObject();
                WriteStrings(writer, "stacks", Stacks);
                WriteStrings(writer, "concerns", Concerns);
                writer.WriteStartArray("cells");
                foreach (ValueChainCell cell in Cells) { WriteCell(writer, cell); }
                writer.WriteEndArray();
                WriteStrings(writer, "unplaced", Unplaced);
                WriteStrings(writer, "strays", Strays);
                writer.WriteEndObject();
            }
            return Encoding.UTF8.GetString(stream.ToArray()).Replace("\r\n", "\n");
        }
    }

    // One cell as a JSON object { stack, concern, adr_count, adrs }; shared with ValueChainHighlight.ToJson.
    internal static void WriteCell(Utf8JsonWriter writer, ValueChainCell cell)
    {
        writer.WriteStartObject();
        writer.WriteString("stack", cell.Stack);
        writer.WriteString("concern", cell.Concern);
        writer.WriteNumber("adr_count", cell.AdrCount);
        WriteStrings(writer, "adrs", cell.Adrs);
        writer.WriteEndObject();
    }

    internal static void WriteStrings(Utf8JsonWriter writer, string name, IEnumerable<string> values)
    {
        writer.WriteStartArray(name);
        foreach (string value in values) { writer.WriteStringValue(value); }
        writer.WriteEndArray();
    }

    private static string Key(string stack, string concern) => (stack ?? "") + "\u0000" + (concern ?? "");

    private static string[] Axis(IEnumerable raw, string what)
    {
        List<string> names = new List<string>();
        HashSet<string> seen = new HashSet<string>(StringComparer.Ordinal);
        foreach (object item in raw ?? Array.Empty<object>())
        {
            object value = item is PSObject wrapped ? wrapped.BaseObject : item;
            string name = Convert.ToString(value, CultureInfo.InvariantCulture);
            if (string.IsNullOrEmpty(name) || !seen.Add(name))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "value-chain map: the {0} '{1}' is empty or repeated", what, name));
            }
            names.Add(name);
        }
        if (names.Count == 0) { throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "value-chain map: no {0} is given", what)); }
        return names.ToArray();
    }
}
