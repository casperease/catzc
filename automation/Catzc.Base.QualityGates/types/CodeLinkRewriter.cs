/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/CodeLinkRewriter.cs
    kind: type
    module: Catzc.Base.QualityGates
---
*/

// The citation code is the source of truth: the destination is derived from it, so a stale path is re-pointed.
// [ADR-REPO-LINK#3](/docs/adr/repository/markdown-links.md#rule-adr-repo-link3)
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/CodeLinkRewriter.cs.md#comment1)

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
        // A path starts a word, so a placeholder like root/docs/adr/index.md, glued to other characters, is not a reference.
        // [comment:2](/docs/references/automation/catzc-base-qualitygates/types/CodeLinkRewriter.cs.md#comment2)
        @"|(?<path>(?<![^\s(\[{,;:'""*])(?:\.{1,2}/)*/?docs/adr/[A-Za-z0-9_\-./]+?\.md)(?<frag>#[A-Za-z0-9_\-]+)?(?![\w/])" +
        // A dash before a citation is allowed only in a rule range, so any other glued dash joins a word.
        // [comment:3](/docs/references/automation/catzc-base-qualitygates/types/CodeLinkRewriter.cs.md#comment3)
        @"|(?<cite>(?<!\w)(?<!(?:^|\D)-)(?<code>ADR-[A-Z]+(?:-[A-Z]+)*)(?:(?<sep>[:#])(?<rule>\d+))?(?(rule)(?!\d)|(?![\w*]|-[A-Z*<])))" +
        @"|(?<slug>(?<![^\s(\[{,;:'""*])(?<name>[a-z0-9]+(?:-[a-z0-9]+)*)\.md(?![\w/]))",
        RegexOptions.Compiled);

    // DocsLinkText matches only the bare comment number; CitationOnly matches a lone citation as a link's whole text.
    // [comment:4](/docs/references/automation/catzc-base-qualitygates/types/CodeLinkRewriter.cs.md#comment4)
    static readonly Regex DocsLinkText = new Regex(@"^comment:(?<number>\d+)$", RegexOptions.Compiled);
    static readonly Regex CitationOnly = new Regex(@"^(?<code>ADR-[A-Z]+(?:-[A-Z]+)*)(?:[:#](?<rule>\d+))?$", RegexOptions.Compiled);
    static readonly Regex AdjacentCitation = new Regex(
        @"\G(?<sep>[ \t]*[,;:]?[ \t]*\(?(?:[Rr]ule[ \t]+)?|[ \t]+[—–-][ \t]+)(?<code>ADR-[A-Z]+(?:-[A-Z]+)*)(?:[:#](?<rule>\d+))?(?![\w\-:#])(?<close>\))?",
        RegexOptions.Compiled);
    static readonly Regex RuleFragment = new Regex(@"^#rule-(?<code>adr(?:-[a-z]+)+?)(?<rule>\d+)$", RegexOptions.Compiled);
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

    // Unregistered codes are skipped when tolerated, because test comments name fixture ADRs on purpose.
    // [comment:5](/docs/references/automation/catzc-base-qualitygates/types/CodeLinkRewriter.cs.md#comment5)
    public string Rewrite(string comment, bool tolerateUnknownCodes, List<Hit> hits, List<string> inserted)
    {
        if (string.IsNullOrEmpty(comment)) { return comment; }

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
                consumed += Adjacent(comment, match.Index + match.Length, literal, out string citedCode, out int? citedRule);
                replacement = RewritePath(match.Groups["path"].Value, match.Groups["frag"].Value, citedCode, citedRule, out type, out problemType, out problem);
            }
            else if (match.Groups["cite"].Success && IsQuoted(comment, match.Index, match.Length))
            {
                // A quoted citation ('ADR-X:3') is a literal example of the spelling, not a reference.
            }
            else if (match.Groups["cite"].Success)
            {
                string code = match.Groups["code"].Value;
                if (!map.HasCode(code))
                {
                    if (!map.IsDomainCode(code) && !tolerateUnknownCodes)
                    {
                        problemType = LinkFindingType.UnknownCode;
                        problem = string.Format(CultureInfo.InvariantCulture, "'{0}' is not a citation code in the ADR index", code);
                    }
                }
                else
                {
                    int? rule = match.Groups["rule"].Success ? int.Parse(match.Groups["rule"].Value, CultureInfo.InvariantCulture) : (int?)null;
                    if (rule.HasValue && !map.HasRule(code, rule.Value))
                    {
                        problemType = LinkFindingType.UnknownRule;
                        problem = string.Format(CultureInfo.InvariantCulture, "{0} declares no rule {1}", code, rule.Value);
                    }
                    else
                    {
                        replacement = Canonical(code, rule, null);
                        type = LinkFindingType.Citation;
                        consumed += RepeatedLink(comment, match.Index + match.Length, literal, replacement);
                    }
                }
            }
            else if (match.Groups["slug"].Success)
            {
                string path = map.PathOfSlug(match.Groups["name"].Value);
                if (path != null)
                {
                    int extra = Adjacent(comment, match.Index + match.Length, literal, out string citedCode, out int? citedRule);
                    if (citedCode != null)
                    {
                        consumed += extra;
                        replacement = RewritePath(path, string.Empty, citedCode, citedRule, out type, out problemType, out problem);
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

    // A closing parenthesis is taken only when the separator opened it; zero means no citation follows the path.
    // [comment:6](/docs/references/automation/catzc-base-qualitygates/types/CodeLinkRewriter.cs.md#comment6)
    int Adjacent(string comment, int at, bool[] literal, out string code, out int? rule)
    {
        code = null;
        rule = null;
        if (at >= comment.Length) { return 0; }
        Match adjacent = AdjacentCitation.Match(comment, at);
        if (!adjacent.Success || literal[adjacent.Groups["code"].Index] || !map.HasCode(adjacent.Groups["code"].Value)) { return 0; }

        bool opened = adjacent.Groups["sep"].Value.Contains("(");
        bool closed = adjacent.Groups["close"].Success;
        if (opened && !closed) { return 0; }

        code = adjacent.Groups["code"].Value;
        rule = adjacent.Groups["rule"].Success ? int.Parse(adjacent.Groups["rule"].Value, CultureInfo.InvariantCulture) : (int?)null;
        return closed && !opened ? adjacent.Length - 1 : adjacent.Length;
    }

    // The same reference spelled twice merges into one canonical link; zero when the link points elsewhere.
    // [comment:7](/docs/references/automation/catzc-base-qualitygates/types/CodeLinkRewriter.cs.md#comment7)
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

        Match docsLink = DocsLinkText.Match(text);
        if (docsLink.Success)
        {
            CheckDocsLink(docsLink.Groups["number"].Value, pathPart, fragment, out problemType, out problem);
            return null;
        }

        string repoPath = ToRepositoryPath(pathPart);
        Match citation = CitationOnly.Match(text);

        if (repoPath == null && !citation.Success) { return null; }   // a link to something other than an ADR

        string code = null;
        int? rule = null;
        if (citation.Success && map.HasCode(citation.Groups["code"].Value))
        {
            code = citation.Groups["code"].Value;
            rule = citation.Groups["rule"].Success ? int.Parse(citation.Groups["rule"].Value, CultureInfo.InvariantCulture) : (int?)null;
            if (repoPath != null && !string.Equals(map.PathOf(code), repoPath, StringComparison.OrdinalIgnoreCase))
            {
                type = map.IsDocument(repoPath) ? LinkFindingType.TextMismatch : LinkFindingType.Stale;
            }
        }
        else if (citation.Success)
        {
            problemType = LinkFindingType.UnknownCode;
            problem = string.Format(CultureInfo.InvariantCulture, "'{0}' is not a citation code in the ADR index", citation.Groups["code"].Value);
            return null;
        }

        if (code == null)
        {
            // The text is not a citation (a slug, a title): the path decides, and the link is re-spelled canonically.
            string fixedLink = RewritePath(repoPath, fragment, null, null, out type, out problemType, out problem);
            if (type == LinkFindingType.Bare || type == LinkFindingType.Relative) { type = LinkFindingType.NonCanonical; }
            return fixedLink;
        }

        if (!rule.HasValue && fragment.Length > 0)
        {
            Match ruleFragment = RuleFragment.Match(fragment);
            if (ruleFragment.Success && ruleFragment.Groups["code"].Value == code.ToLowerInvariant())
            {
                rule = int.Parse(ruleFragment.Groups["rule"].Value, CultureInfo.InvariantCulture);
                fragment = string.Empty;
            }
        }
        else if (rule.HasValue)
        {
            fragment = string.Empty;
        }

        if (rule.HasValue && !map.HasRule(code, rule.Value))
        {
            problemType = LinkFindingType.UnknownRule;
            problem = string.Format(CultureInfo.InvariantCulture, "{0} declares no rule {1}", code, rule.Value);
            return null;
        }
        if (fragment.Length > 0 && !HasAnchor(map.PathOf(code), fragment))
        {
            problemType = LinkFindingType.BadAnchor;
            problem = string.Format(CultureInfo.InvariantCulture, "{0} has no heading or anchor '{1}'", map.PathOf(code), fragment);
        }
        return Canonical(code, rule, fragment);
    }

    string RewritePath(string rawPath, string fragment, string citedCode, int? citedRule, out LinkFindingType type, out LinkFindingType problemType, out string problem)
    {
        problemType = LinkFindingType.Dangling;
        problem = null;
        string repoPath = ToRepositoryPath(rawPath) ?? rawPath;
        bool plain = rawPath.StartsWith("docs/adr/", StringComparison.Ordinal);
        type = plain ? LinkFindingType.Bare : LinkFindingType.Relative;

        if (citedCode != null)
        {
            type = LinkFindingType.Adjacent;
            if (!citedRule.HasValue)
            {
                Match ruleFragment = RuleFragment.Match(fragment ?? string.Empty);
                if (ruleFragment.Success && ruleFragment.Groups["code"].Value == citedCode.ToLowerInvariant())
                {
                    citedRule = int.Parse(ruleFragment.Groups["rule"].Value, CultureInfo.InvariantCulture);
                }
            }
            if (citedRule.HasValue && !map.HasRule(citedCode, citedRule.Value))
            {
                problemType = LinkFindingType.UnknownRule;
                problem = string.Format(CultureInfo.InvariantCulture, "{0} declares no rule {1}", citedCode, citedRule.Value);
                return null;
            }
            return Canonical(citedCode, citedRule, null);
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
        int? rule = null;
        string keptFragment = fragment ?? string.Empty;
        if (code != null && keptFragment.Length > 0)
        {
            Match ruleFragment = RuleFragment.Match(keptFragment);
            if (ruleFragment.Success && ruleFragment.Groups["code"].Value == code.ToLowerInvariant())
            {
                rule = int.Parse(ruleFragment.Groups["rule"].Value, CultureInfo.InvariantCulture);
                keptFragment = string.Empty;
                if (!map.HasRule(code, rule.Value))
                {
                    problemType = LinkFindingType.UnknownRule;
                    problem = string.Format(CultureInfo.InvariantCulture, "{0} declares no rule {1}", code, rule.Value);
                    return null;
                }
            }
        }
        if (keptFragment.Length > 0 && !HasAnchor(repoPath, keptFragment))
        {
            problemType = LinkFindingType.BadAnchor;
            problem = string.Format(CultureInfo.InvariantCulture, "{0} has no heading or anchor '{1}'", repoPath, keptFragment);
        }
        return code != null ? Canonical(code, rule, keptFragment) : CanonicalForPath(repoPath, keptFragment);
    }

    string Canonical(string code, int? rule, string fragment)
    {
        string text = rule.HasValue ? code + "#" + rule.Value.ToString(CultureInfo.InvariantCulture) : code;
        return "[" + text + "](" + map.Destination(code, rule) + (rule.HasValue ? string.Empty : fragment ?? string.Empty) + ")";
    }

    // A link to an ADR-folder document with no citation code of its own (index.md, a dora-explains.md): text is the file slug.
    string CanonicalForPath(string repoPath, string fragment)
    {
        string code = map.CodeOf(repoPath);
        if (code != null) { return Canonical(code, null, fragment); }
        return "[" + Path.GetFileNameWithoutExtension(repoPath) + "](/" + repoPath + (fragment ?? string.Empty) + ")";
    }

    // A docs link has one spelling, so it is checked and never rewritten: rooted under docs, page exists, own anchor.
    // [ADR-REPO-LINK#9](/docs/adr/repository/markdown-links.md#rule-adr-repo-link9)
    // [comment:8](/docs/references/automation/catzc-base-qualitygates/types/CodeLinkRewriter.cs.md#comment8)
    void CheckDocsLink(string number, string pathPart, string fragment, out LinkFindingType problemType, out string problem)
    {
        problemType = LinkFindingType.Dangling;
        problem = null;
        if (!pathPart.StartsWith("/docs/", StringComparison.Ordinal) || !pathPart.EndsWith(".md", StringComparison.Ordinal))
        {
            problem = string.Format(CultureInfo.InvariantCulture, "docs link comment:{0} must point at a repository-rooted page under /docs/, not '{1}'", number, pathPart);
            return;
        }
        string page = pathPart.Substring(1);
        if (anchorsOf(page) == null)
        {
            problem = string.Format(CultureInfo.InvariantCulture, "docs link comment:{0} points at {1}, which does not exist", number, page);
            return;
        }
        string expected = "#comment" + number;
        if (!string.Equals(fragment, expected, StringComparison.Ordinal) || !HasAnchor(page, fragment))
        {
            problemType = LinkFindingType.BadAnchor;
            problem = string.Format(CultureInfo.InvariantCulture, "docs link comment:{0} needs the anchor {1}, and {2} must hold its section", number, expected, page);
        }
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
