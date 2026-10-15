/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Reports/types/OutputPattern.cs
    kind: type
    module: Catzc.Base.Reports
    adrs:
      - ADR-AUTO-TYPES#14
      - ADR-REPO-OUTFMT#1
---
*/

// A stamp segment against a wildcard segment counts as overlapping, so an accepted catalogue is always overlap-free.
// [ADR-REPO-OUTFMT#1](/docs/adr/repository/output-formats.md#rule-adr-repo-outfmt1)
// [comment:1](/docs/references/automation/catzc-base-reports/types/OutputPattern.cs.md#comment1)

using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Reports;

public sealed class OutputPattern
{
    private const string AnySegments = "**";
    private const string Stamp = "{stamp}";
    private static readonly Regex StampSegment = new Regex("^[0-9]{8}-[0-9]{6}(-[0-9a-f]+)?$");

    private readonly string[] segments;

    // The pattern as written.
    public string Text { get; }

    private OutputPattern(string text, string[] parsed)
    {
        Text = text;
        segments = parsed;
    }

    // Parses a pattern; throws ArgumentException naming every syntax error.
    public static OutputPattern Parse(string text)
    {
        List<string> errors = new List<string>();
        if (string.IsNullOrWhiteSpace(text)) { throw new ArgumentException("a pattern must not be empty"); }
        if (text.StartsWith("/") || text.Contains("\\") || text.Contains("..") || text.Contains(":"))
        {
            errors.Add(string.Format("pattern '{0}' must be relative to the output root ('/' separated, no '\\', '..', or ':')", text));
        }

        string[] parsed = text.Split('/');
        foreach (string segment in parsed)
        {
            if (segment.Length == 0) { errors.Add(string.Format("pattern '{0}' has an empty segment", text)); continue; }
            if (segment != AnySegments && segment.Contains(AnySegments))
            {
                errors.Add(string.Format("pattern '{0}': '**' must be a whole segment", text));
            }
            if (segment != Stamp && (segment.Contains("{") || segment.Contains("}")))
            {
                errors.Add(string.Format("pattern '{0}': braces appear only in a whole '{{stamp}}' segment", text));
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
        return new OutputPattern(text, parsed);
    }

    // Console-ready text ([ADR-AUTO-TYPES#14](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types14)).
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // True when the output-root-relative path (with '/' or '\' separators) matches this pattern.
    public bool Matches(string relativePath)
    {
        if (string.IsNullOrEmpty(relativePath)) { return false; }
        string[] path = relativePath.Replace('\\', '/').Split('/');
        Dictionary<long, bool> memo = new Dictionary<long, bool>();
        return MatchSegments(segments, 0, path, 0, memo);
    }

    // True when some path matches both this pattern and the other.
    public bool Overlaps(OutputPattern other)
    {
        Dictionary<long, bool> memo = new Dictionary<long, bool>();
        return OverlapSegments(segments, 0, other.segments, 0, memo);
    }

    private static bool MatchSegments(string[] p, int i, string[] path, int j, Dictionary<long, bool> memo)
    {
        long key = ((long)i << 32) | (uint)j;
        bool cached;
        if (memo.TryGetValue(key, out cached)) { return cached; }

        bool result;
        if (i == p.Length) { result = j == path.Length; }
        else if (p[i] == AnySegments)
        {
            result = MatchSegments(p, i + 1, path, j, memo) || (j < path.Length && MatchSegments(p, i, path, j + 1, memo));
        }
        else
        {
            result = j < path.Length && SegmentMatches(p[i], path[j]) && MatchSegments(p, i + 1, path, j + 1, memo);
        }
        memo[key] = result;
        return result;
    }

    private static bool OverlapSegments(string[] a, int i, string[] b, int j, Dictionary<long, bool> memo)
    {
        long key = ((long)i << 32) | (uint)j;
        bool cached;
        if (memo.TryGetValue(key, out cached)) { return cached; }

        bool result;
        bool aEnd = i == a.Length;
        bool bEnd = j == b.Length;
        if (aEnd && bEnd) { result = true; }
        else if (!aEnd && a[i] == AnySegments)
        {
            result = OverlapSegments(a, i + 1, b, j, memo) || (!bEnd && OverlapSegments(a, i, b, j + 1, memo));
        }
        else if (!bEnd && b[j] == AnySegments)
        {
            result = OverlapSegments(a, i, b, j + 1, memo) || (!aEnd && OverlapSegments(a, i + 1, b, j, memo));
        }
        else if (aEnd || bEnd) { result = false; }
        else { result = SegmentsOverlap(a[i], b[j]) && OverlapSegments(a, i + 1, b, j + 1, memo); }

        memo[key] = result;
        return result;
    }

    private static bool SegmentMatches(string pattern, string segment)
    {
        if (pattern == Stamp) { return StampSegment.IsMatch(segment); }
        return CharsOverlap(pattern, 0, segment, 0, true, new Dictionary<long, bool>());
    }

    private static bool SegmentsOverlap(string a, string b)
    {
        bool aStamp = a == Stamp;
        bool bStamp = b == Stamp;
        if (aStamp && bStamp) { return true; }
        if (aStamp) { return HasWildcard(b) || StampSegment.IsMatch(b); }
        if (bStamp) { return HasWildcard(a) || StampSegment.IsMatch(a); }
        return CharsOverlap(a, 0, b, 0, false, new Dictionary<long, bool>());
    }

    private static bool HasWildcard(string segment) => segment.IndexOf('*') >= 0 || segment.IndexOf('?') >= 0;

    // Can some string match both a and b? When bLiteral, b is a plain string (its '*' and '?' are characters).
    private static bool CharsOverlap(string a, int i, string b, int j, bool bLiteral, Dictionary<long, bool> memo)
    {
        long key = ((long)i << 32) | (uint)j;
        bool cached;
        if (memo.TryGetValue(key, out cached)) { return cached; }

        bool aEnd = i == a.Length;
        bool bEnd = j == b.Length;
        bool aStar = !aEnd && a[i] == '*';
        bool bStar = !bEnd && !bLiteral && b[j] == '*';
        bool result;
        if (aEnd && bEnd) { result = true; }
        else if (aStar && (CharsOverlap(a, i + 1, b, j, bLiteral, memo) || (!bEnd && CharsOverlap(a, i, b, j + 1, bLiteral, memo)))) { result = true; }
        else if (bStar && (CharsOverlap(a, i, b, j + 1, bLiteral, memo) || (!aEnd && CharsOverlap(a, i + 1, b, j, bLiteral, memo)))) { result = true; }
        else if (aEnd || bEnd || aStar || bStar) { result = false; }
        else
        {
            bool aAny = a[i] == '?';
            bool bAny = !bLiteral && b[j] == '?';
            result = (aAny || bAny || a[i] == b[j]) && CharsOverlap(a, i + 1, b, j + 1, bLiteral, memo);
        }
        memo[key] = result;
        return result;
    }
}
