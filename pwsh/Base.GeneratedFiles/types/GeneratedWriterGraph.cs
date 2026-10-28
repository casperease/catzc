// The input and output graph of the writer registry: the order its writers render in, sorted from what each reads and writes.

using System;
using System.Collections.Generic;
using System.Linq;

namespace Catzc.Base.GeneratedFiles;

public static class GeneratedWriterGraph
{
    // How deep the walk for a writer's '**' input glob goes below the glob's literal folder.
    public const int InputDepth = 16;

    // The globs a writer reads: its own inputs and those of each of its outputs, each once.
    public static string[] Inputs(Catzc.Base.Variants.GeneratedWriterRow row)
    {
        if (row == null) { return new string[0]; }
        List<string> inputs = new List<string>(row.inputs);
        foreach (Catzc.Base.Variants.GeneratedOutput output in row.outputs) { inputs.AddRange(output.inputs); }
        return inputs.Where(glob => !string.IsNullOrWhiteSpace(glob)).Distinct(StringComparer.Ordinal).ToArray();
    }

    public static IReadOnlyList<Catzc.Base.Variants.GeneratedWriterRow> RenderOrder(Catzc.Base.Variants.GeneratedWriterRow[] rows)
    {
        SortedDictionary<string, Catzc.Base.Variants.GeneratedWriterRow> byName = new SortedDictionary<string, Catzc.Base.Variants.GeneratedWriterRow>(StringComparer.Ordinal);
        Dictionary<string, List<Catzc.Base.Reports.OutputPattern>> reads = new Dictionary<string, List<Catzc.Base.Reports.OutputPattern>>(StringComparer.Ordinal);
        Dictionary<string, List<Catzc.Base.Reports.OutputPattern>> writes = new Dictionary<string, List<Catzc.Base.Reports.OutputPattern>>(StringComparer.Ordinal);
        foreach (Catzc.Base.Variants.GeneratedWriterRow row in rows ?? new Catzc.Base.Variants.GeneratedWriterRow[0])
        {
            if (row == null) { continue; }
            if (byName.ContainsKey(row.name)) { throw new ArgumentException(string.Format("the writer registry declares the writer '{0}' twice", row.name)); }
            byName[row.name] = row;
            reads[row.name] = Patterns(row.name, Inputs(row));
            writes[row.name] = Patterns(row.name, row.outputs.Select(output => output.path));
        }

        Dictionary<string, SortedSet<string>> before = new Dictionary<string, SortedSet<string>>(StringComparer.Ordinal);
        Dictionary<string, SortedSet<string>> after = new Dictionary<string, SortedSet<string>>(StringComparer.Ordinal);
        foreach (string name in byName.Keys)
        {
            before[name] = new SortedSet<string>(StringComparer.Ordinal);
            after[name] = new SortedSet<string>(StringComparer.Ordinal);
        }
        foreach (string writer in byName.Keys)
        {
            foreach (string reader in byName.Keys)
            {
                if (writer == reader) { continue; }
                if (writes[writer].Any(output => reads[reader].Any(input => output.Overlaps(input))))
                {
                    after[writer].Add(reader);
                    before[reader].Add(writer);
                }
            }
        }

        Dictionary<string, int> waiting = byName.Keys.ToDictionary(name => name, name => before[name].Count, StringComparer.Ordinal);
        SortedSet<string> ready = new SortedSet<string>(byName.Keys.Where(name => waiting[name] == 0), StringComparer.Ordinal);
        List<Catzc.Base.Variants.GeneratedWriterRow> order = new List<Catzc.Base.Variants.GeneratedWriterRow>();
        while (ready.Count > 0)
        {
            string next = ready.Min;
            ready.Remove(next);
            order.Add(byName[next]);
            foreach (string reader in after[next])
            {
                waiting[reader]--;
                if (waiting[reader] == 0) { ready.Add(reader); }
            }
        }
        if (order.Count < byName.Count) { throw new ArgumentException(CycleMessage(waiting, before)); }
        return order.AsReadOnly();
    }

    private static List<Catzc.Base.Reports.OutputPattern> Patterns(string writer, IEnumerable<string> globs)
    {
        List<Catzc.Base.Reports.OutputPattern> list = new List<Catzc.Base.Reports.OutputPattern>();
        foreach (string glob in globs.Distinct(StringComparer.Ordinal))
        {
            try { list.Add(Catzc.Base.Reports.OutputPattern.Parse(glob)); }
            catch (ArgumentException ex) { throw new ArgumentException(string.Format("writer '{0}': {1}", writer, ex.Message)); }
        }
        return list;
    }

    private static string CycleMessage(Dictionary<string, int> waiting, Dictionary<string, SortedSet<string>> before)
    {
        List<string> walk = new List<string>();
        string current = waiting.Keys.Where(name => waiting[name] > 0).OrderBy(name => name, StringComparer.Ordinal).First();
        while (!walk.Contains(current))
        {
            walk.Add(current);
            current = before[current].First(name => waiting[name] > 0);
        }
        List<string> cycle = walk.GetRange(walk.IndexOf(current), walk.Count - walk.IndexOf(current));
        cycle.Reverse();
        int start = cycle.IndexOf(cycle.OrderBy(name => name, StringComparer.Ordinal).First());
        List<string> named = cycle.Skip(start).Concat(cycle.Take(start)).ToList();
        named.Add(named[0]);
        return string.Format("the writer registry has a cycle: {0}; each reads an output of the writer before it (ADR-REPO-ROOTCFG-DERIVEDRENDERORDER)",
            string.Join(" -> ", named));
    }
}
