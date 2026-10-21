/*
---
catzc:
  immutable:
    with_body_sha: "316b2cc3f5c6"
  edges:
    docs: "[LinkEngine.cs.md](docs/references/pwsh/catzc-base-quality-gates/types/LinkEngine.cs.md)"
    cites:
      - ADR-REPO-LINK-KINDBYFILE
      - ADR-REPO-LINK-ONECITATIONSPELLING
      - ADR-REPO-LINK-STRINGSAREDATA
      - ADR-REPO-LINK-ALIGNEDBYTOOL
---
*/

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
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // A path under the decision records' root in a string, and a code link this engine inserts into one.
    readonly Regex StringDocPath;
    readonly Regex InsertedLink;
    // A meta head written as line comments (a YAML or shell head): every comment in it is skipped, as a block-comment head is whole.
    static readonly Regex LineCommentHead = new Regex(
        @"\A[ \t]*(?<m>#|//)[ \t]*---[ \t]*\r?\n(?=[ \t]*\k<m>[ \t]*catzc:)(?:[ \t]*\k<m>[^\r\n]*\r?\n)*?[ \t]*\k<m>[ \t]*---[ \t]*(?:\r?\n|\z)",
        RegexOptions.Compiled);
    // A number written out, or one composed at runtime after the `#` or `:`: an interpolated variable or a format placeholder.
    readonly Regex StringNumberedCitation;

    readonly string root;
    readonly AdrCitationMap map;
    readonly SourceCheck stringCitations;
    readonly LinkWrap wrap;
    readonly IReadOnlyDictionary<string, int> lineLimits;
    readonly int defaultLineLimit;
    readonly ConcurrentDictionary<string, IReadOnlyCollection<string>> anchorCache =
        new ConcurrentDictionary<string, IReadOnlyCollection<string>>(StringComparer.OrdinalIgnoreCase);
    readonly CodeLinkRewriter rewriter;
    readonly MarkdownLinkScanner scanner;

    public LinkEngine(string repositoryRoot, AdrCitationMap map, AdrsConfig adrs, LinkWrap wrap, IDictionary<string, int> lineLimits,
        int defaultLineLimit, string selfUrlPrefix, IEnumerable<string> trackedFiles, SourceCheck stringCitations)
    {
        root = Path.GetFullPath(repositoryRoot ?? throw new ArgumentNullException(nameof(repositoryRoot)));
        this.map = map ?? throw new ArgumentNullException(nameof(map));
        if (adrs == null) { throw new ArgumentNullException(nameof(adrs)); }
        AdrCodeForm codeForm = adrs.CodeForm;
        string records = Regex.Escape(adrs.Root + "/");
        StringNumberedCitation = new Regex(@"(?<![\w\-])" + codeForm.Cited + @"[:#](?:\d+|\$|\{(?:\d+\}|[A-Za-z_]))", RegexOptions.Compiled);
        StringDocPath = new Regex(@"(?<![\w/.\-])" + records + @"[A-Za-z0-9_\-./]+?\.md(?![\w/])", RegexOptions.Compiled);
        InsertedLink = new Regex(@"\[[^\]\r\n]+\]\(/" + records + @"[^)\s]+\)", RegexOptions.Compiled);
        this.stringCitations = stringCitations ?? throw new ArgumentNullException(nameof(stringCitations));
        this.wrap = wrap;
        this.lineLimits = new Dictionary<string, int>(lineLimits ?? new Dictionary<string, int>(), StringComparer.OrdinalIgnoreCase);
        this.defaultLineLimit = defaultLineLimit;
        rewriter = new CodeLinkRewriter(map, adrs, AnchorsOf);
        scanner = new MarkdownLinkScanner(root, codeForm, AnchorsOf, selfUrlPrefix, trackedFiles);
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
        // A test is a .Tests.ps1 file or any file in a tests folder, its fixture helpers included.
        bool isTestFile = file.EndsWith(".Tests.ps1", StringComparison.OrdinalIgnoreCase)
            || file.StartsWith("tests/", StringComparison.Ordinal) || file.Contains("/tests/", StringComparison.Ordinal);
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

        // A string citation's fix replaces one character with one, so every offset below holds for the fixed text.
        text = AlignStringCitations(text, file, extension, hits);

        IReadOnlyList<(int Start, int Length)> comments = CommentLexer.Comments(text, extension);
        if (comments.Count == 0) { return text; }

        var output = new StringBuilder(text.Length + 256);
        int copied = 0;
        bool changed = false;
        Match lineHead = LineCommentHead.Match(text);
        int headEnd = lineHead.Success ? lineHead.Length : 0;
        for (int index = 0; index < comments.Count; index++)
        {
            (int start, int length) = comments[index];
            if (start < headEnd) { continue; }
            string comment = text.Substring(start, length);
            string marker = CommentLexer.LineMarker(comment);
            int lineStart = start == 0 ? 0 : text.LastIndexOf('\n', start - 1) + 1;
            int column = start - lineStart;
            string codeBefore = text.Substring(lineStart, column);
            bool trailing = marker != null && codeBefore.Trim().Length > 0;

            int end = start + length;
            string logical = comment;
            int continuations = 0;
            while (trailing && index + continuations + 1 < comments.Count)
            {
                (int nextStart, int nextLength) = comments[index + continuations + 1];
                string nextComment = text.Substring(nextStart, nextLength);
                int nextLineStart = text.LastIndexOf('\n', nextStart - 1) + 1;
                bool onNextLine = text.Substring(end, nextLineStart - end).Trim().Length == 0 && text.IndexOf('\n', end) == nextLineStart - 1;
                bool alignedUnder = nextStart - nextLineStart == column && text.Substring(nextLineStart, column).Trim().Length == 0;
                if (!onNextLine || !alignedUnder || CommentLexer.LineMarker(nextComment) != marker) { break; }
                logical = logical.TrimEnd() + " " + nextComment.Substring(marker.Length).Trim();
                end = nextStart + nextLength;
                continuations++;
            }

            var local = new List<CodeLinkRewriter.Hit>();
            string rewritten = rewriter.Rewrite(logical, isTestFile, local, new List<string>());

            if (continuations > 0 && !InsertedLink.IsMatch(rewritten))
            {
                continuations = 0;
                logical = comment;
                end = start + length;
                local.Clear();
                rewritten = rewriter.Rewrite(logical, isTestFile, local, new List<string>());
            }
            foreach (CodeLinkRewriter.Hit hit in local)
            {
                hits.Add(new CodeLinkRewriter.Hit(start + Math.Min(hit.Offset, length), hit.Type, hit.Message, hit.Fix));
            }
            bool rewrote = !string.Equals(rewritten, logical, StringComparison.Ordinal);

            if (trailing && (continuations > 0 || (rewrote && column + rewritten.Length > limit)))
            {
                string indent = codeBefore.Substring(0, codeBefore.Length - codeBefore.TrimStart().Length);
                string above = Wrap(rewritten, indent.Length, marker, newline, limit, start, hits);
                output.Append(text, copied, lineStart - copied)
                    .Append(indent).Append(above).Append(newline)
                    .Append(codeBefore.TrimEnd());
                hits.Add(new CodeLinkRewriter.Hit(start, LinkFindingType.NonCanonical,
                    "trailing comment too long for its line: moved above the statement", "(moved above the statement)"));
                copied = end;
                changed = true;
                index += continuations;
                continue;
            }
            if (!rewrote) { continue; }

            rewritten = Wrap(rewritten, column, marker, newline, limit, start, hits);
            output.Append(text, copied, start - copied).Append(rewritten);
            copied = end;
            changed = true;
        }
        if (!changed) { return text; }
        output.Append(text, copied, text.Length - copied);
        return output.ToString();
    }

    string AlignStringCitations(string text, string file, string extension, List<CodeLinkRewriter.Hit> hits)
    {
        if (stringCitations.IsExempt(file)) { return text; }

        foreach ((int start, int length) in CommentLexer.Strings(text, extension))
        {
            string literal = text.Substring(start, length);
            foreach (Match citation in StringNumberedCitation.Matches(literal))
            {
                hits.Add(new CodeLinkRewriter.Hit(start + citation.Index, LinkFindingType.StringNumbered,
                    "'" + citation.Value + "' in a string is a numbered citation; cite the rule by its name", string.Empty));
            }
        }
        return text;
    }

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
                result.Add(head + (newline == "\r\n" ? "\r" : string.Empty));   // an inserted break uses the file's own line ending
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

    int BreakPoint(string line, int room, int tailRoom)
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
        return 0;
    }

    static readonly Regex AnyLink = new Regex(@"\[[^\]\r\n]*\]\([^)\s]*\)", RegexOptions.Compiled);
    static readonly Regex CodeSpan = new Regex(@"`[^`\r\n]*`", RegexOptions.Compiled);
    static readonly Regex CommentLead = new Regex(@"^\s*(?:<#|<!--|///|//|/\*|\*|#)?\s*", RegexOptions.Compiled);

    // Index of the first content character after the indent and comment marker.
    static int ContentStart(string line) => CommentLead.Match(line).Length;

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
