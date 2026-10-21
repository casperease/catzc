/*
---
catzc:
  immutable:
    with_body_sha: "514f8b75ca30"
  edges:
    docs: "[MarkdownLinkScanner.cs.md](docs/references/pwsh/catzc-base-quality-gates/types/MarkdownLinkScanner.cs.md)"
    cites:
      - ADR-REPO-LINK-MARKDOWNRELATIVE
---
*/

using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

namespace Catzc.Base.QualityGates;

public sealed class MarkdownLinkScanner
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    static readonly Regex InlineLink = new Regex(
        @"(?<!\\)!?\[(?<text>(?:[^\[\]\r\n]|\[[^\]\r\n]*\])*)\]\((?<dest><[^>\r\n]*>|[^)\s]+)(?:\s+(?:""[^""\r\n]*""|'[^'\r\n]*'))?\)",
        RegexOptions.Compiled);
    static readonly Regex ReferenceDefinition = new Regex(@"^ {0,3}\[[^\]]+\]:[ \t]*(?<dest><[^>]*>|\S+)", RegexOptions.Compiled);
    static readonly Regex Autolink = new Regex(@"(?<!\\)<(?<dest>[a-zA-Z][a-zA-Z0-9+.\-]*:[^\s<>]+)>", RegexOptions.Compiled);
    static readonly Regex NumberedCitation = new Regex(@"(?<![\w\-])ADR(?:-[A-Z][A-Z0-9]*)+[:#]\d+", RegexOptions.Compiled);
    static readonly Regex Fence = new Regex(@"^ {0,3}(`{3,}|~{3,})", RegexOptions.Compiled);
    static readonly Regex Scheme = new Regex(@"^[a-zA-Z][a-zA-Z0-9+.\-]*:", RegexOptions.Compiled);

    readonly string root;
    readonly Func<string, IReadOnlyCollection<string>> anchorsOf;
    readonly string selfUrlPrefix;
    readonly HashSet<string> tracked;

    public MarkdownLinkScanner(string repositoryRoot, Func<string, IReadOnlyCollection<string>> anchorsOf, string selfUrlPrefix,
        IEnumerable<string> trackedFiles)
    {
        root = Path.GetFullPath(repositoryRoot ?? throw new ArgumentNullException(nameof(repositoryRoot)));
        this.anchorsOf = anchorsOf ?? throw new ArgumentNullException(nameof(anchorsOf));
        this.selfUrlPrefix = string.IsNullOrEmpty(selfUrlPrefix) ? null : selfUrlPrefix.TrimEnd('/');
        tracked = trackedFiles == null ? null : TrackedWithFolders(trackedFiles);
    }

    static HashSet<string> TrackedWithFolders(IEnumerable<string> trackedFiles)
    {
        var set = new HashSet<string>(StringComparer.Ordinal);
        foreach (string file in trackedFiles)
        {
            string path = file.Replace('\\', '/');
            set.Add(path);
            for (int slash = path.LastIndexOf('/'); slash > 0; slash = path.LastIndexOf('/', slash - 1))
            {
                if (!set.Add(path.Substring(0, slash))) { break; }
            }
        }
        return set;
    }

    public string Scan(string text, string repoPath, List<CodeLinkRewriter.Hit> hits)
    {
        if (string.IsNullOrEmpty(text)) { return text; }

        var edits = new List<(int Start, int Length, string Replacement)>();
        string directory = Path.GetDirectoryName(repoPath.Replace('/', Path.DirectorySeparatorChar)) ?? string.Empty;
        bool underGitHub = repoPath.StartsWith(".github/", StringComparison.Ordinal);

        foreach ((string line, int lineStart, bool[] literal) in ProseLines(text))
        {
            foreach (Match link in InlineLink.Matches(line))
            {
                if (literal[link.Index]) { continue; }
                Group dest = link.Groups["dest"];
                CheckDestination(dest.Value, lineStart + dest.Index, dest.Length, directory, repoPath, underGitHub, hits, edits);
            }
            Match definition = ReferenceDefinition.Match(line);
            if (definition.Success)
            {
                Group dest = definition.Groups["dest"];
                CheckDestination(dest.Value, lineStart + dest.Index, dest.Length, directory, repoPath, underGitHub, hits, edits);
            }

            foreach (Match citation in NumberedCitation.Matches(line))
            {
                if (literal[citation.Index]) { continue; }
                hits.Add(new CodeLinkRewriter.Hit(lineStart + citation.Index, LinkFindingType.Numbered,
                    string.Format(CultureInfo.InvariantCulture, "'{0}' is a numbered citation; cite the rule by its name", citation.Value), string.Empty));
            }
        }

        if (edits.Count == 0) { return text; }
        edits.Sort((a, b) => a.Start.CompareTo(b.Start));
        var output = new StringBuilder(text.Length);
        int copied = 0;
        foreach ((int start, int length, string replacement) in edits)
        {
            if (start < copied) { continue; }
            output.Append(text, copied, start - copied).Append(replacement);
            copied = start + length;
        }
        output.Append(text, copied, text.Length - copied);
        return output.ToString();
    }

    // The destination of every link, image, reference definition and autolink outside code, as written without angle brackets.
    public static IReadOnlyList<string> Destinations(string text)
    {
        var found = new List<string>();
        if (string.IsNullOrEmpty(text)) { return found; }
        foreach ((string line, int _, bool[] literal) in ProseLines(text))
        {
            foreach (Match link in InlineLink.Matches(line))
            {
                if (!literal[link.Index]) { found.Add(Bare(link.Groups["dest"].Value)); }
            }
            Match definition = ReferenceDefinition.Match(line);
            if (definition.Success) { found.Add(Bare(definition.Groups["dest"].Value)); }
            foreach (Match autolink in Autolink.Matches(line))
            {
                if (!literal[autolink.Index]) { found.Add(autolink.Groups["dest"].Value); }
            }
        }
        return found;
    }

    // The lines outside fenced blocks with their offsets and inline-code masks: the one walk Scan and Destinations share.
    static IEnumerable<(string Line, int Start, bool[] Literal)> ProseLines(string text)
    {
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
            }
            else if (fenceMatch.Success)
            {
                fence = fenceMatch.Groups[1].Value;
            }
            else
            {
                yield return (line, lineStart, CodeSpans(line));
            }
            lineStart = lineEnd + 1;
        }
    }

    static string Bare(string written) => written.StartsWith("<", StringComparison.Ordinal) ? written.Trim('<', '>') : written;

    void CheckDestination(string written, int offset, int length, string directory, string repoPath, bool underGitHub,
        List<CodeLinkRewriter.Hit> hits, List<(int, int, string)> edits)
    {
        string destination = Bare(written);
        if (destination.Length == 0) { return; }

        if (Scheme.IsMatch(destination))
        {
            if (selfUrlPrefix != null && !underGitHub && destination.StartsWith(selfUrlPrefix + "/", StringComparison.OrdinalIgnoreCase))
            {
                hits.Add(new CodeLinkRewriter.Hit(offset, LinkFindingType.SelfUrl,
                    string.Format(CultureInfo.InvariantCulture, "absolute URL into this repository '{0}': link the file relatively", destination), string.Empty));
            }
            return;
        }

        int hash = destination.IndexOf('#');
        string pathPart = Uri.UnescapeDataString(hash >= 0 ? destination.Substring(0, hash) : destination);
        string fragment = hash >= 0 ? destination.Substring(hash + 1) : string.Empty;

        string targetRepoPath;
        if (pathPart.Length == 0)
        {
            targetRepoPath = repoPath;   // an in-file anchor
        }
        else if (pathPart.StartsWith("/", StringComparison.Ordinal))
        {
            targetRepoPath = pathPart.TrimStart('/');
            string relative = Path.GetRelativePath(Path.Combine(root, directory), Path.Combine(root, targetRepoPath)).Replace('\\', '/');
            string fixedDestination = relative + (hash >= 0 ? "#" + fragment : string.Empty);
            hits.Add(new CodeLinkRewriter.Hit(offset, LinkFindingType.Rooted,
                string.Format(CultureInfo.InvariantCulture, "repository-rooted link '{0}' -> {1}", destination, fixedDestination), fixedDestination));
            edits.Add((offset, length, fixedDestination));
        }
        else
        {
            string full = Path.GetFullPath(Path.Combine(root, directory, pathPart));
            if (!full.StartsWith(root + Path.DirectorySeparatorChar, StringComparison.OrdinalIgnoreCase) && !string.Equals(full, root, StringComparison.OrdinalIgnoreCase))
            {
                hits.Add(new CodeLinkRewriter.Hit(offset, LinkFindingType.EscapesRoot,
                    string.Format(CultureInfo.InvariantCulture, "relative link '{0}' climbs above the repository root: use an absolute https:// URL", destination), string.Empty));
                return;
            }
            targetRepoPath = Path.GetRelativePath(root, full).Replace('\\', '/');
        }

        string targetFull = Path.Combine(root, targetRepoPath);
        if (!File.Exists(targetFull) && !Directory.Exists(targetFull))
        {
            hits.Add(new CodeLinkRewriter.Hit(offset, LinkFindingType.Dangling,
                string.Format(CultureInfo.InvariantCulture, "link target '{0}' does not exist", targetRepoPath), string.Empty));
            return;
        }
        // The file itself (an in-file anchor) and the repository root are never the problem.
        string trackedPath = targetRepoPath.TrimEnd('/');
        bool isSelfOrRoot = pathPart.Length == 0 || trackedPath.Length == 0 || trackedPath == ".";
        if (tracked != null && !isSelfOrRoot && !tracked.Contains(trackedPath))
        {
            hits.Add(new CodeLinkRewriter.Hit(offset, LinkFindingType.Untracked,
                string.Format(CultureInfo.InvariantCulture,
                    "link target '{0}' exists locally but is not committed, so GitHub cannot resolve it: commit it, or link its tracked source",
                    targetRepoPath), string.Empty));
            return;
        }
        if (fragment.Length > 0 && targetRepoPath.EndsWith(".md", StringComparison.OrdinalIgnoreCase) && File.Exists(targetFull))
        {
            IReadOnlyCollection<string> anchors = anchorsOf(targetRepoPath);
            bool found = false;
            if (anchors != null)
            {
                foreach (string anchor in anchors)
                {
                    if (string.Equals(anchor, fragment, StringComparison.Ordinal)) { found = true; break; }
                }
            }
            if (!found)
            {
                hits.Add(new CodeLinkRewriter.Hit(offset, LinkFindingType.BadAnchor,
                    string.Format(CultureInfo.InvariantCulture, "{0} has no heading or anchor '#{1}'", targetRepoPath, fragment), string.Empty));
            }
        }
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
