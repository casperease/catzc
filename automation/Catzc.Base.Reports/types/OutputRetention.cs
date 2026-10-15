/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Reports/types/OutputRetention.cs
    kind: csharp-type
    module: Catzc.Base.Reports
---
*/

// Pure: it reads no disk and no clock, so which stamps and files a retention pass removes is provable on fixtures.

using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;

namespace Catzc.Base.Reports;

// One file under the output root, as the caller listed it.
public sealed class OutputFile
{
    public string Path { get; }
    public DateTime LastWriteUtc { get; }

    public OutputFile(string path, DateTime lastWriteUtc)
    {
        if (string.IsNullOrEmpty(path)) { throw new ArgumentException("output file: the path is required"); }
        Path = path.Replace('\\', '/');
        LastWriteUtc = lastWriteUtc;
    }
}

// What a retention pass removes (whole stamp folders, folder targets, or files) and the files no format covers.
public sealed class OutputRetentionPlan
{
    public ReadOnlyCollection<string> Remove { get; }
    public ReadOnlyCollection<string> Uncovered { get; }
    public int UnitCount { get; }

    public OutputRetentionPlan(IList<string> remove, IList<string> uncovered, int unitCount)
    {
        Remove = new ReadOnlyCollection<string>(remove);
        Uncovered = new ReadOnlyCollection<string>(uncovered);
        UnitCount = unitCount;
    }
}

public static class OutputRetention
{
    const string Stamp = "{stamp}";

    sealed class Unit
    {
        public string Path;
        public string Group;
        public string SortKey;
        public DateTime Time;
        public bool KeepAll;          // some format of the unit keeps all
        public int Keep;              // the largest keep among its formats
        public bool NeverAges;        // some format of the unit never ages out
        public TimeSpan MaxAge;       // the largest max_age among its formats
        public bool Protected;        // in a pipeline, a format that does not apply there
    }

    // A stamped pattern keeps the newest stamps per run folder; any other keeps the newest files (or folders) per parent folder.
    public static OutputRetentionPlan Plan(IEnumerable<OutputFile> files, OutputFormatsConfig config, DateTime nowUtc, bool pipeline)
    {
        if (config == null) { throw new ArgumentNullException(nameof(config)); }
        var parsed = new List<Tuple<OutputFormat, string, OutputPattern>>();
        foreach (OutputFormat format in config.formats.Values)
        {
            foreach (string text in format.patterns) { parsed.Add(Tuple.Create(format, text, OutputPattern.Parse(text))); }
        }

        var units = new Dictionary<string, Unit>(StringComparer.Ordinal);
        var uncovered = new List<string>();
        foreach (OutputFile file in files ?? Enumerable.Empty<OutputFile>())
        {
            string[] segments = file.Path.Split('/');
            Tuple<OutputFormat, string, OutputPattern> hit = null;
            string unitPath = null;
            foreach (var entry in parsed)
            {
                if (entry.Item1.target == "folder")
                {
                    for (int length = segments.Length - 1; length >= 1 && hit == null; length--)
                    {
                        string prefix = string.Join("/", segments, 0, length);
                        if (entry.Item3.Matches(prefix)) { hit = entry; unitPath = prefix; }
                    }
                }
                else if (entry.Item3.Matches(file.Path)) { hit = entry; unitPath = file.Path; }
                if (hit != null) { break; }
            }
            if (hit == null) { uncovered.Add(file.Path); continue; }

            OutputFormat format = hit.Item1;
            string group;
            string sortKey;
            int stampAt = Array.IndexOf(hit.Item2.Split('/'), Stamp);
            if (stampAt >= 0 && stampAt < segments.Length)
            {
                unitPath = string.Join("/", segments, 0, stampAt + 1);
                group = "stamp|" + string.Join("/", segments, 0, stampAt);
                sortKey = segments[stampAt];
            }
            else
            {
                int slash = unitPath.LastIndexOf('/');
                group = format.id + "|" + (slash < 0 ? string.Empty : unitPath.Substring(0, slash));
                sortKey = null;
            }

            Unit unit;
            if (!units.TryGetValue(unitPath, out unit))
            {
                unit = new Unit { Path = unitPath, Group = group, SortKey = sortKey, Time = file.LastWriteUtc, Keep = 0, MaxAge = TimeSpan.Zero };
                units[unitPath] = unit;
            }
            if (file.LastWriteUtc > unit.Time) { unit.Time = file.LastWriteUtc; }
            if (format.keep == null) { unit.KeepAll = true; } else if (format.keep.Value > unit.Keep) { unit.Keep = format.keep.Value; }
            if (format.max_age == null) { unit.NeverAges = true; } else if (format.max_age.Value > unit.MaxAge) { unit.MaxAge = format.max_age.Value; }
            if (pipeline && !format.in_pipeline) { unit.Protected = true; }
        }

        var remove = new List<string>();
        foreach (var group in units.Values.GroupBy(u => u.Group, StringComparer.Ordinal))
        {
            // Newest first: a stamp sorts by its text (yyyyMMdd-HHmmss), anything else by its newest write.
            List<Unit> ordered = group
                .OrderByDescending(u => u.SortKey ?? string.Empty, StringComparer.Ordinal)
                .ThenByDescending(u => u.Time)
                .ToList();
            for (int i = 0; i < ordered.Count; i++)
            {
                Unit unit = ordered[i];
                if (unit.Protected) { continue; }
                bool overCount = !unit.KeepAll && i >= unit.Keep;
                bool tooOld = !unit.NeverAges && nowUtc - unit.Time > unit.MaxAge;
                if (overCount || tooOld) { remove.Add(unit.Path); }
            }
        }
        remove.Sort(StringComparer.Ordinal);
        uncovered.Sort(StringComparer.Ordinal);
        return new OutputRetentionPlan(remove, uncovered, units.Count);
    }
}
