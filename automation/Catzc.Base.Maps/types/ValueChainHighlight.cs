// A value-chain highlight: the lit cells of the value-chain map for ADR references
// ([ADR-DSGN-TRACK#16](/docs/adr/design/tracks.md#rule-adr-dsgn-track16),
// [ADR-DSGN-TRACK#12](/docs/adr/design/tracks.md#rule-adr-dsgn-track12)). A reference is ADR-<CODE>, or one rule as
// ADR-<CODE>#n or ADR-<CODE>:n; a rule sits where its ADR sits, so it lights its ADR's cells. Each lit cell lists the
// requested ADRs that light it, and the cells keep the map's order (rows, then columns), so the result is
// deterministic; ToJson is its data form
// ([ADR-THES-ONETRUTH#3](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)).

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Management.Automation;
using System.Text;
using System.Text.Json;

namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Requested), nameof(Cells))]
public sealed class ValueChainHighlight
{
    // The request: canonical ADR citations (ADR-<CODE> or ADR-<CODE>#n), distinct, in given order.
    public IReadOnlyList<string> Requested { get; }

    // The lit cells, in the map's order; each lists the requested ADR codes that light it.
    public IReadOnlyList<ValueChainCell> Cells { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public ValueChainHighlight(string[] requested, ValueChainCell[] cells)
    {
        Requested = requested == null ? Array.Empty<string>() : (string[])requested.Clone();
        Cells = cells == null ? Array.Empty<ValueChainCell>() : (ValueChainCell[])cells.Clone();
    }

    // The cells the ADR references light. A reference that is not an ADR code of the map throws, listing every one.
    public static ValueChainHighlight ForAdr(ValueChainMap map, IEnumerable references)
    {
        if (map == null) { throw new ArgumentNullException(nameof(map)); }
        List<string> errors = new List<string>();
        List<string> requested = new List<string>();
        Dictionary<ValueChainCell, List<string>> lit = new Dictionary<ValueChainCell, List<string>>();
        foreach (string reference in Strings(references))
        {
            string canonical = CitationScanner.Canonical(reference);
            string adr = CitationScanner.CodeOf(canonical);
            IReadOnlyList<ValueChainCell> cells = map.CellsOf(adr);
            if (cells == null)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "'{0}' is not an ADR code of the adrs registry", reference));
                continue;
            }
            if (requested.Contains(canonical)) { continue; }
            requested.Add(canonical);
            foreach (ValueChainCell cell in cells)
            {
                if (!lit.ContainsKey(cell)) { lit[cell] = new List<string>(); }
                if (!lit[cell].Contains(adr)) { lit[cell].Add(adr); }
            }
        }
        if (errors.Count > 0) { throw new ArgumentException("value-chain highlight: " + string.Join("; ", errors)); }

        List<ValueChainCell> inOrder = new List<ValueChainCell>();
        foreach (ValueChainCell cell in map.Cells)
        {
            List<string> adrs;
            if (lit.TryGetValue(cell, out adrs)) { inOrder.Add(new ValueChainCell(cell.Stack, cell.Concern, adrs.ToArray())); }
        }
        return new ValueChainHighlight(requested.ToArray(), inOrder.ToArray());
    }

    // The highlight as indented JSON with '\n' line ends.
    public string ToJson()
    {
        using (MemoryStream stream = new MemoryStream())
        {
            using (Utf8JsonWriter writer = new Utf8JsonWriter(stream, new JsonWriterOptions { Indented = true }))
            {
                writer.WriteStartObject();
                ValueChainMap.WriteStrings(writer, "requested", Requested);
                writer.WriteStartArray("cells");
                foreach (ValueChainCell cell in Cells) { ValueChainMap.WriteCell(writer, cell); }
                writer.WriteEndArray();
                writer.WriteEndObject();
            }
            return Encoding.UTF8.GetString(stream.ToArray()).Replace("\r\n", "\n");
        }
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
}
