// Checks and aligns the markdown links of one .md file (ADR-REPO-LINK#2, #5, #7). A markdown link is relative to its
// own file: a repository-rooted link is rewritten relative, and a rule citation spelled `ADR-X:n` in prose becomes
// `ADR-X#n` (the ':' form lives only in a rule's own '### Rule' heading). Reported, not fixable: a target that does
// not exist, a #fragment naming no heading or anchor of its target, a relative link that climbs above the
// repository root, and an absolute URL into this repository outside .github/. Fenced code blocks and inline code
// spans are literal. Pure apart from the existence checks it makes against the repository on disk.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

namespace Catzc.Base.QualityGates;

public sealed class MarkdownLinkScanner
{
    static readonly Regex InlineLink = new Regex(
        @"(?<!\\)!?\[(?<text>(?:[^\[\]\r\n]|\[[^\]\r\n]*\])*)\]\((?<dest><[^>\r\n]*>|[^)\s]+)(?:\s+(?:""[^""\r\n]*""|'[^'\r\n]*'))?\)",
        RegexOptions.Compiled);
    static readonly Regex ReferenceDefinition = new Regex(@"^ {0,3}\[[^\]]+\]:[ \t]*(?<dest><[^>]*>|\S+)", RegexOptions.Compiled);
    static readonly Regex ColonCitation = new Regex(@"(?<![\w\-])ADR-[A-Z]+(?:-[A-Z]+)*(?<colon>:)(?=\d)", RegexOptions.Compiled);
    static readonly Regex RuleHeading = new Regex(@"^ {0,3}#{1,6}[ \t]+Rule[ \t]+ADR-", RegexOptions.Compiled);
    static readonly Regex Fence = new Regex(@"^ {0,3}(`{3,}|~{3,})", RegexOptions.Compiled);
    static readonly Regex Scheme = new Regex(@"^[a-zA-Z][a-zA-Z0-9+.\-]*:", RegexOptions.Compiled);

    readonly string root;
    readonly Func<string, IReadOnlyCollection<string>> anchorsOf;
    readonly string selfUrlPrefix;

    // selfUrlPrefix: this repository's web URL (https://github.com/<owner>/<repo>), or null to skip that check.
    public MarkdownLinkScanner(string repositoryRoot, Func<string, IReadOnlyCollection<string>> anchorsOf, string selfUrlPrefix)
    {
        root = Path.GetFullPath(repositoryRoot ?? throw new ArgumentNullException(nameof(repositoryRoot)));
        this.anchorsOf = anchorsOf ?? throw new ArgumentNullException(nameof(anchorsOf));
        this.selfUrlPrefix = string.IsNullOrEmpty(selfUrlPrefix) ? null : selfUrlPrefix.TrimEnd('/');
    }

    // Scans one markdown file (repoPath is repository-relative, '/'-separated). Returns the aligned text; hits are
    // appended at absolute offsets into the original text.
    public string Scan(string text, string repoPath, List<CodeLinkRewriter.Hit> hits)
    {
        if (string.IsNullOrEmpty(text)) { return text; }

        var edits = new List<(int Start, int Length, string Replacement)>();
        string directory = Path.GetDirectoryName(repoPath.Replace('/', Path.DirectorySeparatorChar)) ?? string.Empty;
        bool underGitHub = repoPath.StartsWith(".github/", StringComparison.Ordinal);

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
                Group dest = link.Groups["dest"];
                CheckDestination(dest.Value, lineStart + dest.Index, dest.Length, directory, repoPath, underGitHub, hits, edits);
            }
            Match definition = ReferenceDefinition.Match(line);
            if (definition.Success)
            {
                Group dest = definition.Groups["dest"];
                CheckDestination(dest.Value, lineStart + dest.Index, dest.Length, directory, repoPath, underGitHub, hits, edits);
            }

            if (!RuleHeading.IsMatch(line))
            {
                foreach (Match citation in ColonCitation.Matches(line))
                {
                    if (literal[citation.Index]) { continue; }
                    int at = lineStart + citation.Groups["colon"].Index;
                    string cited = citation.Value + ReadDigits(line, citation.Index + citation.Length);
                    string fixedCitation = cited.Replace(':', '#');
                    hits.Add(new CodeLinkRewriter.Hit(lineStart + citation.Index, LinkFindingType.Colon,
                        string.Format(CultureInfo.InvariantCulture, "rule citation '{0}' -> {1}", cited, fixedCitation), fixedCitation));
                    edits.Add((at, 1, "#"));
                }
            }
            lineStart = lineEnd + 1;
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

    void CheckDestination(string written, int offset, int length, string directory, string repoPath, bool underGitHub,
        List<CodeLinkRewriter.Hit> hits, List<(int, int, string)> edits)
    {
        string destination = written.StartsWith("<", StringComparison.Ordinal) ? written.Trim('<', '>') : written;
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

    static string ReadDigits(string line, int index)
    {
        int end = index;
        while (end < line.Length && char.IsDigit(line[end])) { end++; }
        return line.Substring(index, end - index);
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
