// Pure helpers of the citation rewriter: the map rows' cells, line offsets, and the path segments a link resolves through.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.Drs;

public static class DrsCitationText
{
    internal static Dictionary<string, string> Cells(object row, string[] columns, string map)
    {
        if (!(row is IDictionary values)) { throw Invalid(map, "a row is not a dictionary"); }
        var cells = new Dictionary<string, string>(StringComparer.Ordinal);
        foreach (string column in columns)
        {
            string value = values.Contains(column) ? Convert.ToString(values[column], CultureInfo.InvariantCulture) : null;
            if (string.IsNullOrWhiteSpace(value)) { throw Invalid(map, "a row has no '" + column + "'"); }
            cells[column] = value.Trim();
        }
        return cells;
    }

    internal static ArgumentException Invalid(string map, string reason) =>
        new ArgumentException(string.Format(CultureInfo.InvariantCulture, "{0}: {1}", map, reason));

    internal static string Fragment(Group anchor) => anchor.Success ? anchor.Value : null;

    internal static List<int> LineStarts(string text)
    {
        var starts = new List<int> { 0 };
        for (int index = text.IndexOf('\n'); index >= 0; index = text.IndexOf('\n', index + 1)) { starts.Add(index + 1); }
        return starts;
    }

    internal static int LineOf(List<int> lineStarts, int offset)
    {
        int found = lineStarts.BinarySearch(offset);
        return found >= 0 ? found + 1 : ~found;
    }

    // folder + a relative path, with '.' and '..' applied; null when it climbs above the repository root.
    internal static List<string> Resolve(List<string> folder, string relativePath)
    {
        var result = new List<string>(folder);
        foreach (string segment in relativePath.Split('/'))
        {
            if (segment.Length == 0 || segment == ".") { continue; }
            if (segment == "..")
            {
                if (result.Count == 0) { return null; }
                result.RemoveAt(result.Count - 1);
                continue;
            }
            result.Add(segment);
        }
        return result;
    }

    internal static string Join(List<string> segments) => segments == null ? null : string.Join("/", segments);

    internal static string ParentOf(string repoPath)
    {
        int slash = repoPath.LastIndexOf('/');
        return slash < 0 ? string.Empty : repoPath.Substring(0, slash);
    }

    internal static List<string> Segments(string repoPath)
    {
        var segments = new List<string>();
        foreach (string segment in repoPath.Split('/'))
        {
            if (segment.Length > 0 && segment != ".") { segments.Add(segment); }
        }
        return segments;
    }

    internal static string Normalize(string path) => (path ?? string.Empty).Replace('\\', '/').Trim('/');
}
