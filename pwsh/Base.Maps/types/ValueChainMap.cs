using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text;
using System.Text.Json;

namespace Catzc.Base.Maps;

// The value-chain map: the stack rows crossed with the concerns, every cell, and the records each holds.
[Catzc.Base.Objects.ConsoleDisplay(nameof(Stacks), nameof(Concerns), nameof(RecordCount))]
public sealed class ValueChainMap
{
    private readonly Dictionary<string, ValueChainCell> cellByKey = new Dictionary<string, ValueChainCell>(StringComparer.Ordinal);
    private readonly Dictionary<string, ValueChainCell[]> cellsByRecord = new Dictionary<string, ValueChainCell[]>(StringComparer.Ordinal);
    private readonly Dictionary<string, Catzc.Base.Drs.DrsRuleSet> ruleSetByRecord;

    // The rows: the rows of the value-chain stack, top to bottom.
    public IReadOnlyList<string> Stacks { get; }

    // The columns: the value-chain concerns, in value-chain order.
    public IReadOnlyList<string> Concerns { get; }

    // Every cell of the grid, row by row, empty cells included.
    public IReadOnlyList<ValueChainCell> Cells { get; }

    // Every record code the map was built from, in the given order.
    public IReadOnlyList<string> Records { get; }

    // The record codes that sit in no cell, in the given order.
    public IReadOnlyList<string> Unplaced { get; }

    // One finding per row or value-chain concern a record declares that the axes lack, in the given order.
    public IReadOnlyList<string> Strays { get; }

    // The number of records the map was built from.
    public int RecordCount => Records.Count;

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private ValueChainMap(string[] stacks, string[] concerns, ValueChainCell[] cells, string[] records, string[] unplaced, string[] strays,
        Dictionary<string, List<string>> keysByRecord, Dictionary<string, Catzc.Base.Drs.DrsRuleSet> ruleSets)
    {
        ruleSetByRecord = ruleSets;
        Stacks = stacks;
        Concerns = concerns;
        Cells = cells;
        Records = records;
        Unplaced = unplaced;
        Strays = strays;
        foreach (ValueChainCell cell in cells) { cellByKey[Key(cell.Stack, cell.Concern)] = cell; }
        foreach (string record in records)
        {
            List<ValueChainCell> sitsIn = new List<ValueChainCell>();
            foreach (ValueChainCell cell in cells)
            {
                if (keysByRecord[record].Contains(Key(cell.Stack, cell.Concern))) { sitsIn.Add(cell); }
            }
            cellsByRecord[record] = sitsIn.ToArray();
        }
    }

    // An empty or repeated axis name, an item that is no DrsRuleSet, or a repeated code throws.
    public static ValueChainMap Build(IEnumerable stacks, IEnumerable concerns, IEnumerable ruleSets)
    {
        string[] rows = Axis(stacks, "row of the value-chain stack");
        string[] columns = Axis(concerns, "value-chain concern");
        HashSet<string> rowSet = new HashSet<string>(rows, StringComparer.Ordinal);
        HashSet<string> columnSet = new HashSet<string>(columns, StringComparer.Ordinal);

        List<string> records = new List<string>();
        List<string> unplaced = new List<string>();
        List<string> strays = new List<string>();
        Dictionary<string, List<string>> keysByRecord = new Dictionary<string, List<string>>(StringComparer.Ordinal);
        Dictionary<string, List<string>> recordsByKey = new Dictionary<string, List<string>>(StringComparer.Ordinal);
        Dictionary<string, Catzc.Base.Drs.DrsRuleSet> ruleSetByRecord = new Dictionary<string, Catzc.Base.Drs.DrsRuleSet>(StringComparer.Ordinal);
        foreach (object item in ruleSets ?? Array.Empty<object>())
        {
            Catzc.Base.Drs.DrsRuleSet ruleSet = item as Catzc.Base.Drs.DrsRuleSet;
            if (ruleSet == null)
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "value-chain map: a record is not a {0}",
                    typeof(Catzc.Base.Drs.DrsRuleSet).FullName));
            }
            string record = ruleSet.External;
            if (string.IsNullOrEmpty(record) || keysByRecord.ContainsKey(record))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "value-chain map: the record code '{0}' is empty or repeated", record));
            }
            records.Add(record);
            ruleSetByRecord[record] = ruleSet;
            List<string> keys = new List<string>();
            keysByRecord[record] = keys;
            bool onRow = rowSet.Contains(ruleSet.Stack ?? "");
            if (!onRow)
            {
                strays.Add(string.Format(CultureInfo.InvariantCulture, "{0}: '{1}' is not a row of the value-chain stack ({2})", record, ruleSet.Stack,
                    string.Join(", ", rows)));
            }
            foreach (string concern in ruleSet.Concerns ?? Array.Empty<string>())
            {
                if (!columnSet.Contains(concern ?? ""))
                {
                    strays.Add(string.Format(CultureInfo.InvariantCulture, "{0}: '{1}' is not a value-chain concern ({2})", record, concern,
                        string.Join(", ", columns)));
                    continue;
                }
                string key = Key(ruleSet.Stack, concern);
                if (!onRow || keys.Contains(key)) { continue; }
                keys.Add(key);
                if (!recordsByKey.ContainsKey(key)) { recordsByKey[key] = new List<string>(); }
                recordsByKey[key].Add(record);
            }
            if (keys.Count == 0) { unplaced.Add(record); }
        }

        List<ValueChainCell> cells = new List<ValueChainCell>();
        foreach (string row in rows)
        {
            foreach (string column in columns)
            {
                List<string> inCell;
                recordsByKey.TryGetValue(Key(row, column), out inCell);
                cells.Add(new ValueChainCell(row, column, inCell == null ? Array.Empty<string>() : inCell.ToArray()));
            }
        }
        return new ValueChainMap(rows, columns, cells.ToArray(), records.ToArray(), unplaced.ToArray(), strays.ToArray(), keysByRecord, ruleSetByRecord);
    }

    // The registry entry a record code was placed from (its DRS domain, row and value-chain concerns), or null.
    public Catzc.Base.Drs.DrsRuleSet RuleSetOf(string record)
    {
        Catzc.Base.Drs.DrsRuleSet ruleSet;
        return record != null && ruleSetByRecord.TryGetValue(record, out ruleSet) ? ruleSet : null;
    }

    // The cell of a row and a column, or null when the map has none.
    public ValueChainCell Cell(string stack, string concern)
    {
        ValueChainCell cell;
        return cellByKey.TryGetValue(Key(stack, concern), out cell) ? cell : null;
    }

    // The cells a record code sits in, in the map's order; null when the map was not built from that code.
    public IReadOnlyList<ValueChainCell> CellsOf(string record)
    {
        ValueChainCell[] cells;
        return record != null && cellsByRecord.TryGetValue(record, out cells) ? cells : null;
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

    // One cell as a JSON object { stack, concern, record_count, records }; shared with ValueChainHighlight.ToJson.
    internal static void WriteCell(Utf8JsonWriter writer, ValueChainCell cell)
    {
        writer.WriteStartObject();
        writer.WriteString("stack", cell.Stack);
        writer.WriteString("concern", cell.Concern);
        writer.WriteNumber("record_count", cell.RecordCount);
        WriteStrings(writer, "records", cell.Records);
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
            string name = Convert.ToString(item, CultureInfo.InvariantCulture);
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
