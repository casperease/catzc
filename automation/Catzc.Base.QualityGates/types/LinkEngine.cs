// The link engine behind Format-Links and Test-Links
// ([ADR-REPO-LINK#8](/docs/adr/repository/markdown-links.md#rule-adr-repo-link8)): runs over a list of repository files in
// parallel and, per file, by kind ([ADR-REPO-LINK#1](/docs/adr/repository/markdown-links.md#rule-adr-repo-link1)):
//   Code      — every comment span (CommentLexer) is rewritten into canonical code links (CodeLinkRewriter); a
//               comment line that outgrows its limit is wrapped per the configured LinkWrap; a PowerShell string
//               naming a docs/adr path that does not exist is reported (strings are data,
// [ADR-REPO-LINK#6](/docs/adr/repository/markdown-links.md#rule-adr-repo-link6)).
//   Markdown  — the file's links are checked and aligned (MarkdownLinkScanner).
// It reads files and never writes them: the result carries each changed file's new text. Findings carry real
// 1-based line and column numbers of the original text.

using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Catzc.Base.Docs;

namespace Catzc.Base.QualityGates;

public sealed class LinkEngine
{
    static readonly Regex StringDocPath = new Regex(@"(?<![\w/.\-])docs/adr/[A-Za-z0-9_\-./]+?\.md(?![\w/])", RegexOptions.Compiled);
    static readonly Regex InsertedLink = new Regex(@"\[[^\]\r\n]+\]\(/docs/adr/[^)\s]+\)", RegexOptions.Compiled);

    readonly string root;
    readonly AdrCitationMap map;
    readonly LinkWrap wrap;
    readonly IReadOnlyDictionary<string, int> lineLimits;
    readonly int defaultLineLimit;
    readonly ConcurrentDictionary<string, IReadOnlyCollection<string>> anchorCache =
        new ConcurrentDictionary<string, IReadOnlyCollection<string>>(StringComparer.OrdinalIgnoreCase);
    readonly CodeLinkRewriter rewriter;
    readonly MarkdownLinkScanner scanner;

    // lineLimits: extension ('.ps1') -> line limit; an extension not listed takes defaultLineLimit.
    // selfUrlPrefix: this repository's web URL, or null to skip the self-URL check.
    public LinkEngine(string repositoryRoot, AdrCitationMap map, LinkWrap wrap, IDictionary<string, int> lineLimits, int defaultLineLimit, string selfUrlPrefix)
    {
        root = Path.GetFullPath(repositoryRoot ?? throw new ArgumentNullException(nameof(repositoryRoot)));
        this.map = map ?? throw new ArgumentNullException(nameof(map));
        this.wrap = wrap;
        this.lineLimits = new Dictionary<string, int>(lineLimits ?? new Dictionary<string, int>(), StringComparer.OrdinalIgnoreCase);
        this.defaultLineLimit = defaultLineLimit;
        rewriter = new CodeLinkRewriter(map, AnchorsOf);
        scanner = new MarkdownLinkScanner(root, AnchorsOf, selfUrlPrefix);
    }

    public LinkEngineResult Run(IEnumerable<string> files, LinkKind kind)
    {
        var findings = new ConcurrentBag<LinkFinding>();
        var changed = new ConcurrentDictionary<string, string>(StringComparer.Ordinal);
        string[] list = (files ?? Enumerable.Empty<string>()).Select(f => f.Replace('\\', '/')).Distinct(StringComparer.Ordinal).ToArray();

        Parallel.ForEach(list, file =>
        {
            string extension = CommentLexer.ExtensionOf(file);
            bool isMarkdown = extension == ".md";
            bool isCode = CommentLexer.IsCodeExtension(extension);
            if ((isMarkdown && !kind.HasFlag(LinkKind.Markdown)) || (isCode && !kind.HasFlag(LinkKind.Code)) || (!isMarkdown && !isCode))
            {
                return;
            }

            string full = Path.Combine(root, file);
            if (!File.Exists(full)) { return; }
            string text = File.ReadAllText(full);
            var hits = new List<CodeLinkRewriter.Hit>();
            string aligned = isMarkdown ? scanner.Scan(text, file, hits) : AlignCode(text, file, extension, hits);

            int[] lineStarts = LineStarts(text);
            foreach (CodeLinkRewriter.Hit hit in hits)
            {
                (int line, int column) = Position(lineStarts, hit.Offset);
                findings.Add(new LinkFinding(file, line, column, isMarkdown ? LinkKind.Markdown : LinkKind.Code, hit.Type, hit.Message, hit.Fix));
            }
            if (!string.Equals(aligned, text, StringComparison.Ordinal))
            {
                changed[file] = aligned;
            }
        });

        List<LinkFinding> ordered = findings
            .OrderBy(f => f.File, StringComparer.Ordinal).ThenBy(f => f.Line).ThenBy(f => f.Column).ThenBy(f => f.Type)
            .ToList();
        return new LinkEngineResult(ordered, new Dictionary<string, string>(changed, StringComparer.Ordinal), list.Length);
    }

    string AlignCode(string text, string file, string extension, List<CodeLinkRewriter.Hit> hits)
    {
        bool isTestFile = file.EndsWith(".Tests.ps1", StringComparison.OrdinalIgnoreCase);
        string newline = text.Contains("\r\n") ? "\r\n" : "\n";
        int limit = lineLimits.TryGetValue(extension, out int configured) ? configured : defaultLineLimit;

        if (CommentLexer.IsPowerShell(extension) && !isTestFile)
        {
            foreach ((int start, int length) in CommentLexer.PowerShellStrings(text))
            {
                foreach (Match path in StringDocPath.Matches(text.Substring(start, length)))
                {
                    if (!map.IsDocument(path.Value) && !File.Exists(Path.Combine(root, path.Value)))
                    {
                        hits.Add(new CodeLinkRewriter.Hit(start + path.Index, LinkFindingType.StringPathMissing,
                            "string names '" + path.Value + "', which does not exist (strings are data: fix the path by hand)", string.Empty));
                    }
                }
            }
        }

        IReadOnlyList<(int Start, int Length)> comments = CommentLexer.Comments(text, extension);
        if (comments.Count == 0) { return text; }

        var output = new StringBuilder(text.Length + 256);
        int copied = 0;
        foreach ((int start, int length) in comments)
        {
            string comment = text.Substring(start, length);
            var local = new List<CodeLinkRewriter.Hit>();
            var inserted = new List<string>();
            string rewritten = rewriter.Rewrite(comment, isTestFile, local, inserted);
            foreach (CodeLinkRewriter.Hit hit in local)
            {
                hits.Add(new CodeLinkRewriter.Hit(start + hit.Offset, hit.Type, hit.Message, hit.Fix));
            }
            if (ReferenceEquals(rewritten, comment) || string.Equals(rewritten, comment, StringComparison.Ordinal)) { continue; }

            int column = start - (text.LastIndexOf('\n', Math.Max(0, start - 1)) + 1);
            if (start == 0) { column = 0; }
            rewritten = Wrap(rewritten, column, CommentLexer.LineMarker(comment), newline, limit, start, hits);

            output.Append(text, copied, start - copied).Append(rewritten);
            copied = start + length;
        }
        if (copied == 0) { return text; }
        output.Append(text, copied, text.Length - copied);
        return output.ToString();
    }

    // Wraps the lines of a rewritten comment that carry an inserted code link and outgrow the limit: the line is broken
    // before the link's word (never inside the link), and the continuation repeats the comment prefix and indent.
    // A line that still cannot fit is reported Overlong. With LinkWrap.Off every overlong line is reported, none broken.
    string Wrap(string comment, int column, string marker, string newline, int limit, int commentOffset, List<CodeLinkRewriter.Hit> hits)
    {
        string[] lines = comment.Split('\n');
        var result = new List<string>(lines.Length + 4);
        for (int index = 0; index < lines.Length; index++)
        {
            string line = lines[index];
            bool carriage = line.EndsWith("\r", StringComparison.Ordinal);
            string body = carriage ? line.Substring(0, line.Length - 1) : line;
            int offset = index == 0 ? column : 0;

            if (!InsertedLink.IsMatch(body) || offset + body.Length <= limit)
            {
                result.Add(line);
                continue;
            }
            if (wrap == LinkWrap.Off)
            {
                hits.Add(new CodeLinkRewriter.Hit(commentOffset, LinkFindingType.Overlong,
                    string.Format(System.Globalization.CultureInfo.InvariantCulture, "comment line is {0} characters (limit {1}) after aligning its links", offset + body.Length, limit), string.Empty));
                result.Add(line);
                continue;
            }

            string prefix = ContinuationPrefix(body, index, column, marker, lines);
            string current = body;
            int currentOffset = offset;
            while (currentOffset + current.Length > limit)
            {
                int breakAt = BreakPoint(current, limit - currentOffset, limit - prefix.Length);
                if (breakAt <= 0) { break; }
                string head = current.Substring(0, breakAt).TrimEnd();
                string tail = prefix + current.Substring(breakAt).TrimStart();
                result.Add(head + (carriage ? "\r" : string.Empty));
                current = tail;
                currentOffset = 0;
            }
            if (currentOffset + current.Length > limit)
            {
                hits.Add(new CodeLinkRewriter.Hit(commentOffset, LinkFindingType.Overlong,
                    string.Format(System.Globalization.CultureInfo.InvariantCulture, "a comment line stays over its {0}-character limit: a code link is longer than the room left", limit), string.Empty));
            }
            result.Add(current + (carriage ? "\r" : string.Empty));
        }
        return string.Join("\n", result);
    }

    // Where to break an overlong line. Preferred: before the word holding an inserted code link, so the link and the
    // rest of its sentence move down together (the latest such break whose remainder fits tailRoom). Otherwise the
    // last space that fits within room, outside any link and inline code span, after the line's first word. 0 when no
    // break helps.
    static int BreakPoint(string line, int room, int tailRoom)
    {
        int bestBeforeLink = 0;
        int firstContent = ContentStart(line);
        foreach (Match link in InsertedLink.Matches(line))
        {
            int wordStart = link.Index;
            while (wordStart > 0 && !char.IsWhiteSpace(line[wordStart - 1])) { wordStart--; }
            if (wordStart <= firstContent || wordStart > room + 1) { continue; }
            if (line.Length - wordStart <= tailRoom) { bestBeforeLink = wordStart; }
        }
        if (bestBeforeLink > 0) { return bestBeforeLink; }

        bool[] unbreakable = new bool[line.Length + 1];
        foreach (Match link in AnyLink.Matches(line))
        {
            for (int k = link.Index; k < link.Index + link.Length; k++) { unbreakable[k] = true; }
        }
        foreach (Match code in CodeSpan.Matches(line))
        {
            for (int k = code.Index; k < code.Index + code.Length; k++) { unbreakable[k] = true; }
        }

        int contentStart = ContentStart(line);
        int firstWordEnd = contentStart;
        while (firstWordEnd < line.Length && (unbreakable[firstWordEnd] || !char.IsWhiteSpace(line[firstWordEnd]))) { firstWordEnd++; }

        for (int k = Math.Min(room, line.Length - 1); k >= firstWordEnd; k--)
        {
            if (char.IsWhiteSpace(line[k]) && !unbreakable[k]) { return k; }
        }
        // The first word (a link longer than the room left) crosses the limit by itself: moving the rest down would
        // only strand a few words on their own line, so the line stays long and is reported Overlong.
        return 0;
    }

    static readonly Regex AnyLink = new Regex(@"\[[^\]\r\n]*\]\([^)\s]*\)", RegexOptions.Compiled);
    static readonly Regex CodeSpan = new Regex(@"`[^`\r\n]*`", RegexOptions.Compiled);
    static readonly Regex CommentLead = new Regex(@"^\s*(?:<#|<!--|///|//|/\*|\*|#)?\s*", RegexOptions.Compiled);

    // Index of the first content character after the indent and comment marker.
    static int ContentStart(string line) => CommentLead.Match(line).Length;

    // The text a continuation line starts with: a line comment repeats its marker at the comment's column; a block
    // comment line repeats its own indent (and a leading '* ' in a C-style block).
    static string ContinuationPrefix(string body, int index, int column, string marker, string[] lines)
    {
        if (marker != null)
        {
            return new string(' ', column) + marker + " ";
        }
        string source = body;
        if (index == 0)
        {
            source = lines.Length > 1 ? lines[1].TrimEnd('\r') : new string(' ', column + 4);
        }
        int indent = 0;
        while (indent < source.Length && (source[indent] == ' ' || source[indent] == '\t')) { indent++; }
        string prefix = source.Substring(0, indent);
        if (indent < source.Length && source[indent] == '*' && (indent + 1 >= source.Length || source[indent + 1] == ' '))
        {
            prefix += "* ";
        }
        return prefix;
    }

    IReadOnlyCollection<string> AnchorsOf(string repoPath)
    {
        return anchorCache.GetOrAdd(repoPath, path =>
        {
            string full = Path.Combine(root, path);
            return File.Exists(full) ? GitHubAnchor.Anchors(File.ReadAllText(full)) : null;
        });
    }

    static int[] LineStarts(string text)
    {
        var starts = new List<int> { 0 };
        for (int i = 0; i < text.Length; i++)
        {
            if (text[i] == '\n') { starts.Add(i + 1); }
        }
        return starts.ToArray();
    }

    static (int Line, int Column) Position(int[] lineStarts, int offset)
    {
        int index = Array.BinarySearch(lineStarts, offset);
        if (index < 0) { index = ~index - 1; }
        return (index + 1, offset - lineStarts[index] + 1);
    }
}
