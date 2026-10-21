/*
---
catzc:
  immutable:
    with_body_sha: c086c6cccbef
  edges:
    docs: "[CodeLinkRewriter.cs.md](docs/references/pwsh/catzc-base-quality-gates/types/CodeLinkRewriter.cs.md)"
    cites:
      - ADR-REPO-LINK-CODELINKS
---
*/

using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using Catzc.Base.Docs;

namespace Catzc.Base.QualityGates;

public sealed class CodeLinkRewriter
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // One reference in a comment. Alternation order matters: an existing link swallows the citation in its text.
    static readonly Regex Reference = new Regex(
        @"(?<link>\[(?<text>[^\]\r\n]*)\]\((?<dest>[^)\s]+)\))" +
        @"|(?<path>(?<![^\s(\[{,;:'""*])(?:\.{1,2}/)*/?docs/adr/[A-Za-z0-9_\-./]+?\.md)(?<frag>#[A-Za-z0-9_\-]+)?(?![\w/])" +
        @"|(?<numbered>(?<![\w-])ADR(?:-[A-Z][A-Z0-9]*)+[:#]\d+)" +
        @"|(?<cite>(?<!\w)(?<!(?:^|\D)-)(?<code>ADR(?:-[A-Z][A-Z0-9]*)+)(?![\w*]|-[A-Z0-9*<]))" +
        @"|(?<slug>(?<![^\s(\[{,;:'""*])(?<name>[a-z0-9]+(?:-[a-z0-9]+)*)\.md(?![\w/]))",
        RegexOptions.Compiled);

    // A meta head is derived front matter: its adrs list holds the file's codes as plain codes, never as links.
    static readonly Regex MetaHead = new Regex(@"\A(?:/\*|<#|//|#)?[ \t]*\r?\n?[ \t]*(?://|#)?[ \t]*---[ \t]*\r?\n[ \t]*(?://|#)?[ \t]*catzc:", RegexOptions.Compiled);
    static readonly Regex CitationOnly = new Regex(@"^(?<code>ADR(?:-[A-Z][A-Z0-9]*)+)$", RegexOptions.Compiled);
    static readonly Regex AdjacentCitation = new Regex(
        @"\G(?<sep>[ \t]*[,;:]?[ \t]*\(?(?:[Rr]ule[ \t]+)?|[ \t]+[—–-][ \t]+)(?<code>ADR(?:-[A-Z][A-Z0-9]*)+)(?![\w\-:#])(?<close>\))?",
        RegexOptions.Compiled);
    static readonly Regex HelpKeyword = new Regex(@"^\s*\.(?<keyword>[A-Za-z]+)\b", RegexOptions.Compiled);

    readonly AdrCitationMap map;
    readonly Func<string, IReadOnlyCollection<string>> anchorsOf;

    // anchorsOf: repository-relative .md path -> its GitHub anchors (null when the file does not exist).
    public CodeLinkRewriter(AdrCitationMap map, Func<string, IReadOnlyCollection<string>> anchorsOf)
    {
        this.map = map ?? throw new ArgumentNullException(nameof(map));
        this.anchorsOf = anchorsOf ?? throw new ArgumentNullException(nameof(anchorsOf));
    }

    // One finding inside the comment, at a comment-relative offset.
    public readonly struct Hit
    {
        public readonly int Offset;
        public readonly LinkFindingType Type;
        public readonly string Message;
        public readonly string Fix;

        public Hit(int offset, LinkFindingType type, string message, string fix)
        {
            Offset = offset;
            Type = type;
            Message = message;
            Fix = fix;
        }
    }

    public string Rewrite(string comment, bool tolerateUnknownCodes, List<Hit> hits, List<string> inserted)
    {
        if (string.IsNullOrEmpty(comment) || MetaHead.IsMatch(comment)) { return comment; }

        bool[] literal = LiteralMask(comment);
        var output = new StringBuilder(comment.Length + 64);
        int copied = 0;
        int position = 0;
        while (position < comment.Length)
        {
            Match match = Reference.Match(comment, position);
            if (!match.Success) { break; }
            if (literal[match.Index])
            {
                position = match.Index + 1;
                continue;
            }

            int consumed = match.Length;
            string replacement = null;
            LinkFindingType type = LinkFindingType.Bare;
            string problem = null;
            LinkFindingType problemType = LinkFindingType.Dangling;

            if (match.Groups["link"].Success)
            {
                replacement = RewriteLink(match.Groups["text"].Value, match.Groups["dest"].Value, out type, out problemType, out problem);
            }
            else if (match.Groups["path"].Success)
            {
                consumed += Adjacent(comment, match.Index + match.Length, literal, out string citedCode);
                replacement = RewritePath(match.Groups["path"].Value, match.Groups["frag"].Value, citedCode, out type, out problemType, out problem);
            }
            else if ((match.Groups["cite"].Success || match.Groups["numbered"].Success) && IsQuoted(comment, match.Index, match.Length))
            {
                // A quoted citation ('ADR-X-NAME') is a literal example of the spelling, not a reference.
            }
            else if (match.Groups["numbered"].Success)
            {
                problemType = LinkFindingType.Numbered;
                problem = string.Format(CultureInfo.InvariantCulture, "'{0}' is a numbered citation; cite the rule by its name", match.Value);
            }
            else if (match.Groups["cite"].Success)
            {
                string code = match.Groups["code"].Value;
                if (!map.HasCode(code))
                {
                    if (!map.IsDomainCode(code) && !tolerateUnknownCodes)
                    {
                        problem = Unknown(code, out problemType);
                    }
                }
                else
                {
                    replacement = Canonical(code, null);
                    type = LinkFindingType.Citation;
                    consumed += RepeatedLink(comment, match.Index + match.Length, literal, replacement);
                }
            }
            else if (match.Groups["slug"].Success)
            {
                string path = map.PathOfSlug(match.Groups["name"].Value);
                if (path != null)
                {
                    int extra = Adjacent(comment, match.Index + match.Length, literal, out string citedCode);
                    if (citedCode != null)
                    {
                        consumed += extra;
                        replacement = RewritePath(path, string.Empty, citedCode, out type, out problemType, out problem);
                    }
                    else
                    {
                        replacement = CanonicalForPath(path, null);
                        type = LinkFindingType.SlugOnly;
                    }
                }
            }

            string original = comment.Substring(match.Index, consumed);
            if (problem != null)
            {
                hits.Add(new Hit(match.Index, problemType, problem, string.Empty));
            }
            if (replacement != null && !string.Equals(replacement, original, StringComparison.Ordinal))
            {
                hits.Add(new Hit(match.Index, type, Describe(type, original, replacement), replacement));
                output.Append(comment, copied, match.Index - copied);
                output.Append(replacement);
                inserted.Add(replacement);
                copied = match.Index + consumed;
            }
            position = match.Index + Math.Max(consumed, 1);
        }

        if (copied == 0) { return comment; }
        output.Append(comment, copied, comment.Length - copied);
        return output.ToString();
    }

    // An unregistered code: a rule its ADR does not declare, or no code of the index at all.
    string Unknown(string code, out LinkFindingType problemType)
    {
        string parent = map.ParentAdr(code);
        if (parent != null)
        {
            problemType = LinkFindingType.UnknownRule;
            return string.Format(CultureInfo.InvariantCulture, "{0} declares no rule {1}", parent, code);
        }
        problemType = LinkFindingType.UnknownCode;
        return string.Format(CultureInfo.InvariantCulture, "'{0}' is not a citation code in the ADR index", code);
    }

    int Adjacent(string comment, int at, bool[] literal, out string code)
    {
        code = null;
        if (at >= comment.Length) { return 0; }
        Match adjacent = AdjacentCitation.Match(comment, at);
        if (!adjacent.Success || literal[adjacent.Groups["code"].Index] || !map.HasCode(adjacent.Groups["code"].Value)) { return 0; }

        bool opened = adjacent.Groups["sep"].Value.Contains("(");
        bool closed = adjacent.Groups["close"].Success;
        if (opened && !closed) { return 0; }

        code = adjacent.Groups["code"].Value;
        return closed && !opened ? adjacent.Length - 1 : adjacent.Length;
    }

    int RepeatedLink(string comment, int at, bool[] literal, string canonical)
    {
        if (at >= comment.Length) { return 0; }
        Match repeated = RepeatedLinkPattern.Match(comment, at);
        if (!repeated.Success || literal[repeated.Groups["link"].Index]) { return 0; }
        string rewritten = RewriteLink(repeated.Groups["text"].Value, repeated.Groups["dest"].Value, out _, out _, out string problem);
        string same = rewritten ?? repeated.Groups["link"].Value;
        return problem == null && string.Equals(same, canonical, StringComparison.Ordinal) ? repeated.Length : 0;
    }

    static readonly Regex RepeatedLinkPattern = new Regex(
        @"\G\s*\((?<link>\[(?<text>[^\]\r\n]*)\]\((?<dest>[^)\s]+)\))\)", RegexOptions.Compiled);

    static bool IsQuoted(string comment, int index, int length)
    {
        if (index == 0 || index + length >= comment.Length) { return false; }
        char before = comment[index - 1];
        char after = comment[index + length];
        return (before == '\'' || before == '"') && after == before;
    }

    string RewriteLink(string text, string destination, out LinkFindingType type, out LinkFindingType problemType, out string problem)
    {
        type = LinkFindingType.NonCanonical;
        problemType = LinkFindingType.Dangling;
        problem = null;

        if (Regex.IsMatch(destination, @"^[a-zA-Z][a-zA-Z0-9+.\-]*:") || destination.StartsWith("#", StringComparison.Ordinal))
        {
            return null;   // a URL or an in-file anchor: not an ADR reference
        }

        int hash = destination.IndexOf('#');
        string pathPart = hash >= 0 ? destination.Substring(0, hash) : destination;
        string fragment = hash >= 0 ? destination.Substring(hash) : string.Empty;

        string repoPath = ToRepositoryPath(pathPart);
        Match citation = CitationOnly.Match(text);

        if (repoPath == null && !citation.Success) { return null; }   // a link to something other than an ADR

        string code = null;
        if (citation.Success && map.HasCode(citation.Groups["code"].Value))
        {
            code = citation.Groups["code"].Value;
            if (repoPath != null && !string.Equals(map.PathOf(code), repoPath, StringComparison.OrdinalIgnoreCase))
            {
                type = map.IsDocument(repoPath) ? LinkFindingType.TextMismatch : LinkFindingType.Stale;
            }
        }
        else if (citation.Success)
        {
            problem = Unknown(citation.Groups["code"].Value, out problemType);
            return null;
        }

        if (code == null)
        {
            // The text is not a citation (a slug, a title): the path decides, and the link is re-spelled canonically.
            string fixedLink = RewritePath(repoPath, fragment, null, out type, out problemType, out problem);
            if (type == LinkFindingType.Bare || type == LinkFindingType.Relative) { type = LinkFindingType.NonCanonical; }
            return fixedLink;
        }

        if (map.IsRule(code))
        {
            fragment = string.Empty;
        }
        else if (fragment.Length > 0)
        {
            string rule = map.RuleOfAnchor(code, fragment);
            if (rule != null)
            {
                code = rule;
                fragment = string.Empty;
            }
        }

        if (fragment.Length > 0 && !HasAnchor(map.PathOf(code), fragment))
        {
            problemType = LinkFindingType.BadAnchor;
            problem = string.Format(CultureInfo.InvariantCulture, "{0} has no heading or anchor '{1}'", map.PathOf(code), fragment);
        }
        return Canonical(code, fragment);
    }

    string RewritePath(string rawPath, string fragment, string citedCode, out LinkFindingType type, out LinkFindingType problemType, out string problem)
    {
        problemType = LinkFindingType.Dangling;
        problem = null;
        string repoPath = ToRepositoryPath(rawPath) ?? rawPath;
        bool plain = rawPath.StartsWith("docs/adr/", StringComparison.Ordinal);
        type = plain ? LinkFindingType.Bare : LinkFindingType.Relative;

        if (citedCode != null)
        {
            type = LinkFindingType.Adjacent;
            string rule = map.IsRule(citedCode) ? null : map.RuleOfAnchor(citedCode, fragment);
            return Canonical(rule ?? citedCode, null);
        }

        if (!map.IsDocument(repoPath))
        {
            string moved = map.PathOfSlug(Path.GetFileNameWithoutExtension(repoPath));
            if (moved == null)
            {
                problem = string.Format(CultureInfo.InvariantCulture, "{0} does not exist{1}", repoPath,
                    map.IsAmbiguousSlug(Path.GetFileNameWithoutExtension(repoPath)) ? " (its file name is ambiguous, so it cannot be re-pointed)" : string.Empty);
                return null;
            }
            repoPath = moved;
            type = LinkFindingType.Stale;
        }

        string code = map.CodeOf(repoPath);
        string keptFragment = fragment ?? string.Empty;
        if (code != null && keptFragment.Length > 0)
        {
            string rule = map.RuleOfAnchor(code, keptFragment);
            if (rule != null)
            {
                code = rule;
                keptFragment = string.Empty;
            }
        }
        if (keptFragment.Length > 0 && !HasAnchor(repoPath, keptFragment))
        {
            problemType = LinkFindingType.BadAnchor;
            problem = string.Format(CultureInfo.InvariantCulture, "{0} has no heading or anchor '{1}'", repoPath, keptFragment);
        }
        return code != null ? Canonical(code, keptFragment) : CanonicalForPath(repoPath, keptFragment);
    }

    string Canonical(string code, string fragment) =>
        "[" + code + "](" + map.Destination(code) + (map.IsRule(code) ? string.Empty : fragment ?? string.Empty) + ")";

    // A link to an ADR-folder document with no citation code of its own (index.md, a dora-explains.md): text is the file slug.
    string CanonicalForPath(string repoPath, string fragment)
    {
        string code = map.CodeOf(repoPath);
        if (code != null) { return Canonical(code, fragment); }
        return "[" + Path.GetFileNameWithoutExtension(repoPath) + "](/" + repoPath + (fragment ?? string.Empty) + ")";
    }

    bool HasAnchor(string repoPath, string fragment)
    {
        IReadOnlyCollection<string> anchors = anchorsOf(repoPath);
        if (anchors == null) { return false; }
        string anchor = fragment.TrimStart('#');
        foreach (string known in anchors)
        {
            if (string.Equals(known, anchor, StringComparison.Ordinal)) { return true; }
        }
        return false;
    }

    // The repository-relative docs/adr path a written path points at, or null when it does not point into docs/adr.
    static string ToRepositoryPath(string written)
    {
        if (string.IsNullOrEmpty(written)) { return null; }
        string path = written.Replace('\\', '/');
        int at = path.IndexOf("docs/adr/", StringComparison.Ordinal);
        if (at < 0) { return null; }
        string prefix = path.Substring(0, at);
        foreach (string segment in prefix.Split('/'))
        {
            if (segment.Length > 0 && segment != "." && segment != "..") { return null; }   // some other folder's docs/adr
        }
        return path.Substring(at);
    }

    static string Describe(LinkFindingType type, string original, string replacement)
    {
        string what;
        switch (type)
        {
            case LinkFindingType.Bare: what = "bare docs path"; break;
            case LinkFindingType.Relative: what = "relative docs path"; break;
            case LinkFindingType.SlugOnly: what = "ADR file name"; break;
            case LinkFindingType.Adjacent: what = "docs path with its citation"; break;
            case LinkFindingType.Citation: what = "bare citation"; break;
            case LinkFindingType.Stale: what = "path to a moved ADR"; break;
            case LinkFindingType.TextMismatch: what = "link whose destination disagrees with its citation"; break;
            default: what = "non-canonical code link"; break;
        }
        return string.Format(CultureInfo.InvariantCulture, "{0} '{1}' -> {2}", what, original, replacement);
    }

    // Marks the characters that are literal: inline code spans, and a PowerShell help block's .EXAMPLE sections.
    static bool[] LiteralMask(string comment)
    {
        var mask = new bool[comment.Length + 1];
        bool helpBlock = comment.StartsWith("<#", StringComparison.Ordinal);
        bool inExample = false;
        int lineStart = 0;
        while (lineStart <= comment.Length)
        {
            int lineEnd = comment.IndexOf('\n', lineStart);
            if (lineEnd < 0) { lineEnd = comment.Length; }
            string line = comment.Substring(lineStart, lineEnd - lineStart);

            if (helpBlock)
            {
                Match keyword = HelpKeyword.Match(line);
                if (keyword.Success)
                {
                    inExample = string.Equals(keyword.Groups["keyword"].Value, "EXAMPLE", StringComparison.OrdinalIgnoreCase);
                }
                if (inExample)
                {
                    for (int k = lineStart; k < lineEnd; k++) { mask[k] = true; }
                }
            }

            int open = -1;
            for (int k = 0; k < line.Length; k++)
            {
                if (line[k] != '`') { continue; }
                if (open < 0)
                {
                    open = k;
                }
                else
                {
                    for (int m = open; m <= k; m++) { mask[lineStart + m] = true; }
                    open = -1;
                }
            }
            lineStart = lineEnd + 1;
        }
        return mask;
    }
}
