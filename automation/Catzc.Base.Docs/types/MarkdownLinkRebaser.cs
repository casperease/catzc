// Pure and repository-relative, so the result never depends on OS or disk; code, URLs, anchors and rooted links stay as written.
// [ADR-REPO-README#6](/docs/adr/repository/generated-readmes.md#rule-adr-repo-readme6)
// [comment:1](/docs/references/automation/catzc-base-docs/types/MarkdownLinkRebaser.cs.md#comment1)

using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

namespace Catzc.Base.Docs;

public static class MarkdownLinkRebaser
{
    static readonly Regex InlineLink = new Regex(
        @"(?<!\\)!?\[(?<text>(?:[^\[\]\r\n]|\[[^\]\r\n]*\])*)\]\((?<dest><[^>\r\n]*>|[^)\s]+)(?:\s+(?:""[^""\r\n]*""|'[^'\r\n]*'))?\)",
        RegexOptions.Compiled);
    static readonly Regex ReferenceDefinition = new Regex(@"^ {0,3}\[[^\]]+\]:[ \t]*(?<dest><[^>]*>|\S+)", RegexOptions.Compiled);
    static readonly Regex Fence = new Regex(@"^ {0,3}(`{3,}|~{3,})", RegexOptions.Compiled);
    static readonly Regex Scheme = new Regex(@"^[a-zA-Z][a-zA-Z0-9+.\-]*:", RegexOptions.Compiled);

    // An empty folderRepoPath is the repository root, and a null or empty text comes back unchanged.
    // [comment:2](/docs/references/automation/catzc-base-docs/types/MarkdownLinkRebaser.cs.md#comment2)
    public static string Rebase(string text, string sourceRepoPath, string folderRepoPath)
    {
        if (string.IsNullOrEmpty(text)) { return text; }
        List<string> sourceFolder = Segments(ParentOf(sourceRepoPath));
        List<string> copyFolder = Segments(folderRepoPath);

        var edits = new List<(int Start, int Length, string Replacement)>();
        string fence = null;
        int lineStart = 0;
        while (lineStart < text.Length)
        {
            int lineEnd = text.IndexOf('\n', lineStart);
            if (lineEnd < 0) { lineEnd = text.Length; }
            string line = text.Substring(lineStart, lineEnd - lineStart).TrimEnd('\r');

            Match fenceMatch = Fence.Match(line);
            if (fence != null)
            {
                if (fenceMatch.Success && fenceMatch.Groups[1].Value[0] == fence[0] && fenceMatch.Groups[1].Value.Length >= fence.Length) { fence = null; }
                lineStart = lineEnd + 1;
                continue;
            }
            if (fenceMatch.Success)
            {
                fence = fenceMatch.Groups[1].Value;
                lineStart = lineEnd + 1;
                continue;
            }

            bool[] literal = CodeSpans(line);
            foreach (Match link in InlineLink.Matches(line))
            {
                if (literal[link.Index]) { continue; }
                AddEdit(link.Groups["dest"], lineStart, sourceFolder, copyFolder, edits);
            }
            Match definition = ReferenceDefinition.Match(line);
            if (definition.Success)
            {
                AddEdit(definition.Groups["dest"], lineStart, sourceFolder, copyFolder, edits);
            }
            lineStart = lineEnd + 1;
        }

        if (edits.Count == 0) { return text; }
        var output = new StringBuilder(text.Length);
        int copied = 0;
        foreach ((int start, int length, string replacement) in edits)
        {
            output.Append(text, copied, start - copied).Append(replacement);
            copied = start + length;
        }
        output.Append(text, copied, text.Length - copied);
        return output.ToString();
    }

    // The relative link from a file in folderRepoPath to targetRepoPath (both repository-relative, '/'-separated).
    public static string RelativeLink(string folderRepoPath, string targetRepoPath)
    {
        return Relative(Segments(folderRepoPath), Segments(targetRepoPath), false);
    }

    static void AddEdit(Group dest, int lineStart, List<string> sourceFolder, List<string> copyFolder, List<(int, int, string)> edits)
    {
        string written = dest.Value;
        bool angle = written.StartsWith("<", StringComparison.Ordinal);
        string destination = angle ? written.Trim('<', '>') : written;
        if (destination.Length == 0 || destination[0] == '#' || destination[0] == '/' || Scheme.IsMatch(destination)) { return; }

        int suffixAt = destination.IndexOfAny(new[] { '#', '?' });
        string pathPart = suffixAt >= 0 ? destination.Substring(0, suffixAt) : destination;
        string suffix = suffixAt >= 0 ? destination.Substring(suffixAt) : string.Empty;

        List<string> resolved = Resolve(sourceFolder, pathPart);
        if (resolved == null) { return; }
        string rebased = Relative(copyFolder, resolved, pathPart.EndsWith("/", StringComparison.Ordinal)) + suffix;
        if (angle) { rebased = "<" + rebased + ">"; }
        if (rebased != written) { edits.Add((lineStart + dest.Index, dest.Length, rebased)); }
    }

    // folder + a relative path, with '.' and '..' applied; null when it climbs above the repository root.
    static List<string> Resolve(List<string> folder, string relativePath)
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

    static string Relative(List<string> from, List<string> to, bool trailingSlash)
    {
        int common = 0;
        while (common < from.Count && common < to.Count && string.Equals(from[common], to[common], StringComparison.Ordinal)) { common++; }
        var parts = new List<string>();
        for (int i = common; i < from.Count; i++) { parts.Add(".."); }
        for (int i = common; i < to.Count; i++) { parts.Add(to[i]); }
        if (parts.Count == 0) { return "./"; }
        string joined = string.Join("/", parts);
        return trailingSlash ? joined + "/" : joined;
    }

    static string ParentOf(string repoPath)
    {
        int slash = (repoPath ?? string.Empty).LastIndexOf('/');
        return slash < 0 ? string.Empty : repoPath.Substring(0, slash);
    }

    static List<string> Segments(string repoPath)
    {
        var segments = new List<string>();
        foreach (string segment in (repoPath ?? string.Empty).Replace('\\', '/').Split('/'))
        {
            if (segment.Length > 0 && segment != ".") { segments.Add(segment); }
        }
        return segments;
    }

    static bool[] CodeSpans(string line)
    {
        var mask = new bool[line.Length + 1];
        int k = 0;
        while (k < line.Length)
        {
            if (line[k] != '`') { k++; continue; }
            int run = 0;
            while (k + run < line.Length && line[k + run] == '`') { run++; }
            int close = line.IndexOf(new string('`', run), k + run, StringComparison.Ordinal);
            if (close < 0) { k += run; continue; }
            for (int m = k; m < close + run; m++) { mask[m] = true; }
            k = close + run;
        }
        return mask;
    }
}
