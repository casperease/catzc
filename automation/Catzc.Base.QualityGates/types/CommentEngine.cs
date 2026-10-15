// cspell:ignore EXTERNALHELP FORWARDHELPTARGETNAME FORWARDHELPCATEGORY REMOTEHELPRUNSPACE  -- PowerShell help keywords
// The comment engine behind Export-Comments, Build-CommentView, Format-Comments and Test-Comments: pure functions over a file's text, so...
// [ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1),
// [ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1),
// [ADR-REPO-FORMAT#5](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format5)
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/CommentEngine.cs.md#comment1)

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace Catzc.Base.QualityGates;

public static class CommentEngine
{
    static readonly Regex HelpKeyword = new Regex(
        @"^\s*\.(?<keyword>SYNOPSIS|DESCRIPTION|PARAMETER|EXAMPLE|INPUTS|OUTPUTS|NOTES|LINK|COMPONENT|ROLE|FUNCTIONALITY|EXTERNALHELP|FORWARDHELPTARGETNAME|FORWARDHELPCATEGORY|REMOTEHELPRUNSPACE)\b",
        RegexOptions.Compiled | RegexOptions.IgnoreCase);
    static readonly Regex DocsLink = new Regex(@"\[comment:(?<number>\d+)\]\((?<page>/[^)\s#]+)#comment(?<anchor>\d+)\)", RegexOptions.Compiled);
    static readonly Regex CodeSpanText = new Regex(@"(`+)[^`\r\n]+?\1", RegexOptions.Compiled);
    static readonly Regex Citation = new Regex(@"(?<!\w)(?<code>ADR-[A-Z]+(?:-[A-Z]+)*)(?:[:#](?<rule>\d+))?(?![\w-])", RegexOptions.Compiled);
    static readonly Regex MarkdownLink = new Regex(@"\[[^\]\r\n]*\]\([^)\s]+\)", RegexOptions.Compiled);
    static readonly Regex SectionHeading = new Regex(@"^## comment:(?<number>\d+)[ \t]*$", RegexOptions.Compiled | RegexOptions.Multiline);
    static readonly Regex Whitespace = new Regex(@"\s+", RegexOptions.Compiled);
    static readonly Regex EmptyParentheses = new Regex(@"\s*\((?:[\s,;]*)\)", RegexOptions.Compiled);
    static readonly Regex IgnoreDirective = new Regex(@"cspell:ignore[ \t]+(?<words>[^\r\n]*)", RegexOptions.Compiled);
    static readonly Regex IgnoreWord = new Regex(@"^[A-Za-z0-9][A-Za-z0-9'_-]*$", RegexOptions.Compiled);
    static readonly Regex PageIgnoreLine = new Regex(@"^<!-- cspell:ignore (?<words>[^\r\n]*?) -->[ \t]*$", RegexOptions.Compiled | RegexOptions.Multiline);
    static readonly Regex SpaceBeforePunctuation = new Regex(@"\s+([.,;:])", RegexOptions.Compiled);
    const string FenceOpen = "```text";
    const string FenceClose = "```";
    const int ContextLength = 80;
    // The Markdown line limit a page's generated lines stay within (.editorconfig [*.md] max_line_length).
    const int PageLineLimit = 140;
    const string Ellipsis = "...";

    // ---- finding ----------------------------------------------------------------------------------------------

    public static IReadOnlyList<CommentBlock> FindBlocks(string text, string extension, string language, CommentsConfig config)
    {
        if (config == null) { throw new ArgumentNullException(nameof(config)); }
        if (string.IsNullOrEmpty(text)) { return Array.Empty<CommentBlock>(); }

        Lines lines = Lines.Of(text);
        var blocks = new List<CommentBlock>();
        var run = new List<(int line, string indent, string marker, string prose)>();

        void FlushRun()
        {
            if (run.Count == 0) { return; }
            var first = run[0];
            blocks.Add(new CommentBlock(CommentBlockKind.LineRun, first.line, run[run.Count - 1].line, first.indent, first.marker, null,
                run.Select(r => r.prose).ToList(), lines.NextCodeLine(run[run.Count - 1].line)));
            run.Clear();
        }

        foreach ((int start, int length) in CommentLexer.Comments(text, extension))
        {
            int startLine = lines.LineOf(start);
            int endLine = lines.LineOf(start + length - 1);
            string before = lines[startLine].Substring(0, start - lines.StartOf(startLine));
            if (before.Trim().Length > 0)
            {
                // A trailing comment shares its line with code: one line by definition, and it ends a run.
                FlushRun();
                continue;
            }
            string comment = text.Substring(start, length);
            bool delimited = comment.StartsWith("<#", StringComparison.Ordinal) || comment.StartsWith("/*", StringComparison.Ordinal)
                || comment.StartsWith("<!--", StringComparison.Ordinal);
            if (delimited)
            {
                FlushRun();
                int endOffset = start + length - lines.StartOf(endLine);
                if (lines[endLine].Substring(Math.Min(endOffset, lines[endLine].Length)).Trim().Length > 0)
                {
                    continue;   // code after the closer on its line: left as written
                }
                if (comment.StartsWith("<#", StringComparison.Ordinal) && IsHelpBlock(lines, startLine, endLine))
                {
                    blocks.AddRange(HelpSections(lines, startLine, endLine));
                }
                else
                {
                    CommentBlock block = DelimitedBlock(lines, startLine, endLine, before);
                    if (block != null) { blocks.Add(block); }
                }
                continue;
            }

            if (config.IsKept(language, comment))
            {
                // A kept line (a spell-checker directive, #Requires, #region) stays where it is and splits the run around it.
                FlushRun();
                continue;
            }
            string marker = MarkerOf(comment);
            string prose = comment.Substring(marker.Length);
            if (prose.StartsWith(" ", StringComparison.Ordinal)) { prose = prose.Substring(1); }
            prose = prose.TrimEnd();
            if (run.Count > 0)
            {
                var last = run[run.Count - 1];
                if (last.line != startLine - 1 || last.indent != before || last.marker != marker) { FlushRun(); }
            }
            run.Add((startLine, before, marker, prose));
        }
        FlushRun();

        return blocks.Where(block => Moves(block, lines, language, config)).OrderBy(block => block.StartLine).ToList();
    }

    static bool Moves(CommentBlock block, Lines lines, string language, CommentsConfig config)
    {
        if (block.ProseLineCount < config.min_lines) { return false; }
        if (block.Lines.Any(line => DocsLink.IsMatch(line))) { return false; }   // a residue: exported already
        string head = block.Keyword ?? lines[block.StartLine].Trim();
        return !config.IsKept(language, head);
    }

    static bool IsHelpBlock(Lines lines, int startLine, int endLine)
    {
        for (int i = startLine; i <= endLine; i++)
        {
            if (HelpKeyword.IsMatch(lines[i])) { return true; }
        }
        return false;
    }

    // One block per `.KEYWORD` section body: the lines after the keyword line up to the next keyword line or the closing `#>` line,...
    // [comment:2](/docs/references/automation/catzc-base-qualitygates/types/CommentEngine.cs.md#comment2)
    static IEnumerable<CommentBlock> HelpSections(Lines lines, int startLine, int endLine)
    {
        if (!lines[endLine].Trim().StartsWith("#>", StringComparison.Ordinal)) { yield break; }
        var keywordLines = new List<int>();
        for (int i = startLine; i < endLine; i++)
        {
            if (HelpKeyword.IsMatch(lines[i])) { keywordLines.Add(i); }
        }
        for (int k = 0; k < keywordLines.Count; k++)
        {
            int keywordLine = keywordLines[k];
            int bodyStart = keywordLine + 1;
            int bodyEnd = (k + 1 < keywordLines.Count ? keywordLines[k + 1] : endLine) - 1;
            while (bodyEnd >= bodyStart && lines[bodyEnd].Trim().Length == 0) { bodyEnd--; }
            if (bodyEnd < bodyStart) { continue; }
            string indent = CommonIndent(lines, bodyStart, bodyEnd);
            var prose = new List<string>();
            for (int i = bodyStart; i <= bodyEnd; i++) { prose.Add(StripIndent(lines[i], indent)); }
            yield return new CommentBlock(CommentBlockKind.HelpSection, bodyStart, bodyEnd, indent, string.Empty, lines[keywordLine].Trim(), prose, null);
        }
    }

    // A `<# … #>` or `/* … */` block that is not help: its inner lines, plus any text beside the delimiters.
    static CommentBlock DelimitedBlock(Lines lines, int startLine, int endLine, string indent)
    {
        string opener = lines[startLine].TrimStart().StartsWith("<!--", StringComparison.Ordinal) ? "<!--" : lines[startLine].TrimStart().Substring(0, 2);
        string closer = opener == "<#" ? "#>" : opener == "/*" ? "*/" : "-->";
        var prose = new List<string>();
        if (startLine == endLine)
        {
            string inner = lines[startLine].Trim();
            inner = inner.Substring(opener.Length);
            int closeAt = inner.LastIndexOf(closer, StringComparison.Ordinal);
            if (closeAt >= 0) { inner = inner.Substring(0, closeAt); }
            prose.Add(inner.Trim());
        }
        else
        {
            string firstText = lines[startLine].TrimStart().Substring(opener.Length).Trim();
            if (firstText.Length > 0) { prose.Add(firstText); }
            int innerStart = startLine + 1;
            int innerEnd = endLine - 1;
            string innerIndent = innerEnd >= innerStart ? CommonIndent(lines, innerStart, innerEnd) : string.Empty;
            for (int i = innerStart; i <= innerEnd; i++) { prose.Add(StripIndent(lines[i], innerIndent)); }
            string lastLine = lines[endLine];
            int closeAt = lastLine.LastIndexOf(closer, StringComparison.Ordinal);
            string lastText = (closeAt >= 0 ? lastLine.Substring(0, closeAt) : lastLine).Trim();
            if (lastText.Length > 0) { prose.Add(lastText); }
        }
        if (prose.Count == 0) { return null; }
        return new CommentBlock(CommentBlockKind.Block, startLine, endLine, indent, string.Empty, null, prose, lines.NextCodeLine(endLine));
    }

    static string MarkerOf(string comment)
    {
        if (comment.StartsWith("///", StringComparison.Ordinal)) { return "///"; }
        if (comment.StartsWith("//", StringComparison.Ordinal)) { return "//"; }
        return "#";
    }

    // The line marker a delimited block's residue is written with: the family's line comment.
    static string FamilyMarker(string extension) =>
        string.Equals(extension, ".cs", StringComparison.OrdinalIgnoreCase) || string.Equals(extension, ".bicep", StringComparison.OrdinalIgnoreCase) ? "//" : "#";

    static string CommonIndent(Lines lines, int from, int to)
    {
        string common = null;
        for (int i = from; i <= to; i++)
        {
            string line = lines[i];
            if (line.Trim().Length == 0) { continue; }
            string indent = line.Substring(0, line.Length - line.TrimStart().Length);
            if (common == null || indent.Length < common.Length) { common = indent; }
        }
        return common ?? string.Empty;
    }

    static string StripIndent(string line, string indent)
    {
        if (line.Trim().Length == 0) { return string.Empty; }
        return (line.StartsWith(indent, StringComparison.Ordinal) ? line.Substring(indent.Length) : line.TrimStart()).TrimEnd();
    }

    // ---- exporting --------------------------------------------------------------------------------------------

    // text: the file; pagePath: its page, repository-relative; existingPageText: the page as it is, or null.
    // [comment:3](/docs/references/automation/catzc-base-qualitygates/types/CommentEngine.cs.md#comment3)
    public static CommentFileResult Export(string text, string extension, string language, string repoRelativePath, string pagePath,
        string existingPageText, CommentsConfig config, int lineLimit)
    {
        if (string.IsNullOrEmpty(repoRelativePath)) { throw new ArgumentException("comment engine: the file path is required"); }
        if (string.IsNullOrEmpty(pagePath)) { throw new ArgumentException("comment engine: the page path is required"); }
        IReadOnlyList<CommentBlock> blocks = FindBlocks(text, extension, language, config);
        if (blocks.Count == 0) { return new CommentFileResult(repoRelativePath, pagePath, null, null, Array.Empty<CommentBlock>()); }

        Lines lines = Lines.Of(text);
        Page page = Page.Parse(existingPageText);
        int number = page.HighestNumber;
        var output = new List<string>();
        var sections = new List<string>();
        int next = 0;
        foreach (CommentBlock block in blocks)
        {
            number++;
            for (int i = next; i < block.StartLine; i++) { output.Add(lines[i]); }
            output.AddRange(Residue(block, number, pagePath, extension, lineLimit));
            sections.Add(Section(block, number));
            next = block.EndLine + 1;
        }
        for (int i = next; i < lines.Count; i++) { output.Add(lines[i]); }

        string newText = lines.Join(output);
        string newPage = page.With(sections, pagePath, repoRelativePath, IgnoredWords(text, extension));
        return new CommentFileResult(repoRelativePath, pagePath, newText, newPage, blocks);
    }

    static IEnumerable<string> Residue(CommentBlock block, int number, string pagePath, string extension, int lineLimit)
    {
        string marker = block.Kind == CommentBlockKind.Block ? FamilyMarker(extension) : block.Marker;
        string prefix = block.Indent + (marker.Length > 0 ? marker + " " : string.Empty);
        string insight = Insight(block.Text, Math.Max(16, lineLimit - prefix.Length));
        string link = string.Format(CultureInfo.InvariantCulture, "[comment:{0}](/{1}#comment{0})", number, pagePath);
        IReadOnlyList<string> cites = Citations(block.Text);
        yield return prefix + insight;
        yield return prefix + (cites.Count > 0 ? string.Join(", ", cites) + " " : string.Empty) + link;
    }

    // The provisional insight: the block's first sentence without its links and citations (those go on the link line), cut at a word to...
    // [comment:4](/docs/references/automation/catzc-base-qualitygates/types/CommentEngine.cs.md#comment4)
    public static string Insight(string text, int maxLength)
    {
        string withoutLinks = MarkdownLink.Replace(text ?? string.Empty, string.Empty);
        // Citations leave the insight for the link line; an example inside a code span stays, it is part of the sentence.
        var spans = CodeSpanText.Matches(withoutLinks).Cast<Match>().ToList();
        string plain = Citation.Replace(withoutLinks, match => spans.Any(span => match.Index >= span.Index && match.Index < span.Index + span.Length) ? match.Value : string.Empty);
        plain = EmptyParentheses.Replace(plain, string.Empty);
        string sentence = SpaceBeforePunctuation.Replace(Whitespace.Replace(plain, " "), "$1").Trim();
        int end = sentence.IndexOf(". ", StringComparison.Ordinal);
        if (end >= 0) { sentence = sentence.Substring(0, end + 1); }
        if (sentence.Length <= maxLength) { return sentence; }
        int cut = sentence.LastIndexOf(' ', Math.Max(0, maxLength - Ellipsis.Length));
        if (cut <= 0) { cut = maxLength - Ellipsis.Length; }
        return sentence.Substring(0, cut).TrimEnd() + Ellipsis;
    }

    // The words a file's spell-checker directives ignore (`cspell:ignore w1 w2 -- why`), each once, in order: the page that receives the...
    // [comment:5](/docs/references/automation/catzc-base-qualitygates/types/CommentEngine.cs.md#comment5)
    public static IReadOnlyList<string> IgnoredWords(string text, string extension)
    {
        var words = new List<string>();
        if (string.IsNullOrEmpty(text)) { return words; }
        foreach ((int start, int length) in CommentLexer.Comments(text, extension))
        {
            foreach (Match directive in IgnoreDirective.Matches(text.Substring(start, length)))
            {
                string list = directive.Groups["words"].Value;
                int reason = list.IndexOf(" --", StringComparison.Ordinal);
                if (reason >= 0) { list = list.Substring(0, reason); }
                foreach (string word in Whitespace.Split(list.Trim()))
                {
                    if (IgnoreWord.IsMatch(word) && !words.Contains(word)) { words.Add(word); }
                }
            }
        }
        return words;
    }

    // The ADR citations a text carries, spelled ADR-<CODE>#<n>, each once, in order of appearance.
    public static IReadOnlyList<string> Citations(string text)
    {
        var cites = new List<string>();
        // A citation inside a code span (`ADR-X#8`) is an example of the spelling, not a citation.
        foreach (Match match in Citation.Matches(CodeSpanText.Replace(text ?? string.Empty, string.Empty)))
        {
            string cite = match.Groups["code"].Value + (match.Groups["rule"].Success ? "#" + match.Groups["rule"].Value : string.Empty);
            if (!cites.Contains(cite)) { cites.Add(cite); }
        }
        return cites;
    }

    static string Section(CommentBlock block, int number)
    {
        var builder = new StringBuilder();
        builder.Append("## comment:").Append(number.ToString(CultureInfo.InvariantCulture)).Append("\n\n");
        builder.Append(block.Context).Append("\n\n");
        builder.Append(FenceOpen).Append('\n');
        foreach (string line in block.Lines) { builder.Append(line).Append('\n'); }
        builder.Append(FenceClose).Append('\n');
        return builder.ToString();
    }

    // ---- residues and the view --------------------------------------------------------------------------------

    public static IReadOnlyList<CommentResidue> FindResidues(string text, string extension)
    {
        if (string.IsNullOrEmpty(text)) { return Array.Empty<CommentResidue>(); }
        Lines lines = Lines.Of(text);
        var residues = new List<CommentResidue>();
        var seen = new HashSet<int>();
        foreach ((int start, int length) in CommentLexer.Comments(text, extension))
        {
            string comment = text.Substring(start, length);
            foreach (Match match in DocsLink.Matches(comment))
            {
                int linkLine = lines.LineOf(start + match.Index);
                if (!seen.Add(linkLine)) { continue; }
                string line = lines[linkLine];
                string indent = line.Substring(0, line.Length - line.TrimStart().Length);
                string marker = LineMarker(line.TrimStart());
                string prefix = indent + marker;
                int first = linkLine;
                while (first - 1 >= 0 && HasPrefix(lines[first - 1], prefix, marker) && IsMechanical(Body(lines[first - 1], prefix)) && !DocsLink.IsMatch(lines[first - 1]))
                {
                    first--;
                }
                string insight = string.Empty;
                if (first - 1 >= 0 && HasPrefix(lines[first - 1], prefix, marker))
                {
                    string candidate = Body(lines[first - 1], prefix);
                    if (candidate.Trim().Length > 0 && !IsMechanical(candidate) && !DocsLink.IsMatch(candidate) && !HelpKeyword.IsMatch(candidate))
                    {
                        first--;
                        insight = candidate.Trim();
                    }
                }
                int number = int.Parse(match.Groups["number"].Value, CultureInfo.InvariantCulture);
                residues.Add(new CommentResidue(number, match.Groups["page"].Value.TrimStart('/'), first, linkLine, indent, marker, insight));
            }
        }
        return residues.OrderBy(r => r.StartLine).ToList();
    }

    // The annotated copy: every residue whose section the page holds is replaced by the section's lines.
    public static string View(string text, string extension, string pageText)
    {
        if (string.IsNullOrEmpty(text)) { return text ?? string.Empty; }
        Page page = Page.Parse(pageText);
        IReadOnlyList<CommentResidue> residues = FindResidues(text, extension);
        if (residues.Count == 0) { return text; }
        Lines lines = Lines.Of(text);
        var output = new List<string>();
        int next = 0;
        foreach (CommentResidue residue in residues)
        {
            if (!page.Sections.TryGetValue(residue.Number, out PageSection section)) { continue; }
            for (int i = next; i < residue.StartLine; i++) { output.Add(lines[i]); }
            foreach (string line in section.Lines)
            {
                output.Add(line.Length == 0
                    ? (residue.Indent + residue.Marker).TrimEnd()
                    : residue.Indent + (residue.Marker.Length > 0 ? residue.Marker + " " : string.Empty) + line);
            }
            next = residue.EndLine + 1;
        }
        for (int i = next; i < lines.Count; i++) { output.Add(lines[i]); }
        return lines.Join(output);
    }

    // The section numbers a page holds, for the pairing checks.
    public static IReadOnlyCollection<int> SectionNumbers(string pageText) => Page.Parse(pageText).Sections.Keys;

    // The fenced prose lines of a page's section, or empty when the page does not hold it.
    public static IReadOnlyList<string> SectionLines(string pageText, int number) =>
        Page.Parse(pageText).Sections.TryGetValue(number, out PageSection section) ? section.Lines : Array.Empty<string>();

    static string LineMarker(string trimmedLine)
    {
        if (trimmedLine.StartsWith("///", StringComparison.Ordinal)) { return "///"; }
        if (trimmedLine.StartsWith("//", StringComparison.Ordinal)) { return "//"; }
        if (trimmedLine.StartsWith("#", StringComparison.Ordinal) && !trimmedLine.StartsWith("#>", StringComparison.Ordinal)) { return "#"; }
        return string.Empty;
    }

    static bool HasPrefix(string line, string prefix, string marker)
    {
        if (!line.StartsWith(prefix, StringComparison.Ordinal)) { return false; }
        if (marker.Length > 0) { return true; }
        // Inside a help block the marker is the indent alone: the line must be indented exactly that far.
        return line.Length == prefix.Length || line[prefix.Length] != ' ';
    }

    static string Body(string line, string prefix)
    {
        string body = line.Substring(prefix.Length);
        return body.StartsWith(" ", StringComparison.Ordinal) ? body.Substring(1) : body;
    }

    // True when a line holds only links, citations and separators — the mechanical part of a residue.
    public static bool IsMechanical(string body)
    {
        if (string.IsNullOrWhiteSpace(body)) { return false; }
        string rest = Citation.Replace(MarkdownLink.Replace(body, string.Empty), string.Empty);
        return rest.All(c => c == ' ' || c == ',' || c == ';' || c == '(' || c == ')' || c == '\t');
    }

    // ---- helpers ----------------------------------------------------------------------------------------------

    sealed class Lines
    {
        readonly List<string> lines = new List<string>();
        readonly List<int> starts = new List<int>();
        readonly string eol;
        readonly bool trailingNewline;

        Lines(string text)
        {
            eol = text.Contains("\r\n") ? "\r\n" : "\n";
            int position = 0;
            while (position <= text.Length)
            {
                int newline = text.IndexOf('\n', position);
                starts.Add(position);
                if (newline < 0)
                {
                    lines.Add(text.Substring(position));
                    break;
                }
                lines.Add(text.Substring(position, newline - position).TrimEnd('\r'));
                position = newline + 1;
            }
            trailingNewline = text.EndsWith("\n", StringComparison.Ordinal);
            if (trailingNewline)
            {
                lines.RemoveAt(lines.Count - 1);
                starts.RemoveAt(starts.Count - 1);
            }
        }

        public static Lines Of(string text) => new Lines(text);

        public int Count => lines.Count;
        public string this[int index] => lines[index];
        public int StartOf(int line) => starts[line];

        public int LineOf(int offset)
        {
            int index = starts.BinarySearch(offset);
            return index >= 0 ? index : ~index - 1;
        }

        // The trimmed, cut-to-length code line after the given line, or null when only comments or blanks follow.
        public string NextCodeLine(int afterLine)
        {
            for (int i = afterLine + 1; i < lines.Count; i++)
            {
                string trimmed = lines[i].Trim();
                if (trimmed.Length == 0) { continue; }
                if (trimmed.StartsWith("#", StringComparison.Ordinal) || trimmed.StartsWith("//", StringComparison.Ordinal)
                    || trimmed.StartsWith("<#", StringComparison.Ordinal) || trimmed.StartsWith("/*", StringComparison.Ordinal)
                    || trimmed.StartsWith("*/", StringComparison.Ordinal) || trimmed.StartsWith("<!--", StringComparison.Ordinal))
                {
                    continue;
                }
                if (trimmed.Length <= ContextLength) { return trimmed; }
                // Cut at the last space that fits, so no word is broken (a half word reads as a misspelling).
                int cut = trimmed.LastIndexOf(' ', ContextLength - Ellipsis.Length);
                if (cut <= 0) { cut = ContextLength - Ellipsis.Length; }
                return trimmed.Substring(0, cut).TrimEnd() + Ellipsis;
            }
            return null;
        }

        public string Join(IEnumerable<string> output) => string.Join(eol, output) + (trailingNewline ? eol : string.Empty);
    }

    sealed class PageSection
    {
        public string Raw { get; set; }
        public IReadOnlyList<string> Lines { get; set; }
    }

    sealed class Page
    {
        public string Prefix { get; private set; }
        public SortedDictionary<int, PageSection> Sections { get; } = new SortedDictionary<int, PageSection>();
        public int HighestNumber => Sections.Count == 0 ? 0 : Sections.Keys.Max();

        public static Page Parse(string pageText)
        {
            var page = new Page();
            string text = (pageText ?? string.Empty).Replace("\r\n", "\n");
            MatchCollection headings = SectionHeading.Matches(text);
            page.Prefix = headings.Count == 0 ? text : text.Substring(0, headings[0].Index);
            for (int h = 0; h < headings.Count; h++)
            {
                int start = headings[h].Index;
                int end = h + 1 < headings.Count ? headings[h + 1].Index : text.Length;
                string raw = text.Substring(start, end - start);
                int number = int.Parse(headings[h].Groups["number"].Value, CultureInfo.InvariantCulture);
                page.Sections[number] = new PageSection { Raw = raw, Lines = FencedLines(raw) };
            }
            return page;
        }

        static IReadOnlyList<string> FencedLines(string section)
        {
            var lines = section.Split('\n');
            var body = new List<string>();
            bool inside = false;
            foreach (string line in lines)
            {
                if (!inside && line.TrimEnd() == FenceOpen) { inside = true; continue; }
                if (inside && line.TrimEnd() == FenceClose) { break; }
                if (inside) { body.Add(line.TrimEnd()); }
            }
            return body;
        }

        // The page text with the new sections appended: an existing page keeps its text as written.
        public string With(IEnumerable<string> newSections, string pagePath, string repoRelativePath, IReadOnlyList<string> ignoredWords)
        {
            var builder = new StringBuilder();
            bool fresh = Sections.Count == 0 && Prefix.Trim().Length == 0;
            string prefix = fresh
                ? "# " + pagePath + "\n\n`" + repoRelativePath + "`\n\n"
                    + "The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per\n"
                    + "section (Export-Comments), and Build-CommentView puts them back for reading.\n"
                : Prefix.TrimEnd('\n') + "\n";
            builder.Append(WithIgnoreLine(prefix, repoRelativePath, ignoredWords).TrimEnd('\n')).Append("\n\n");
            if (!fresh)
            {
                foreach (PageSection section in Sections.Values) { builder.Append(section.Raw.TrimEnd('\n')).Append("\n\n"); }
            }
            foreach (string section in newSections) { builder.Append(section.TrimEnd('\n')).Append("\n\n"); }
            return builder.ToString().TrimEnd('\n') + "\n";
        }

        // The page head with one `<!-- cspell:ignore … -->` line holding its own words plus the file's, below the source path; unchanged...
        // [comment:6](/docs/references/automation/catzc-base-qualitygates/types/CommentEngine.cs.md#comment6)
        static string WithIgnoreLine(string prefix, string repoRelativePath, IReadOnlyList<string> ignoredWords)
        {
            if (ignoredWords == null || ignoredWords.Count == 0) { return prefix; }
            MatchCollection existing = PageIgnoreLine.Matches(prefix);
            var words = new List<string>();
            foreach (Match match in existing)
            {
                foreach (string word in Whitespace.Split(match.Groups["words"].Value.Trim()))
                {
                    if (word.Length > 0 && !words.Contains(word)) { words.Add(word); }
                }
            }
            int before = words.Count;
            foreach (string word in ignoredWords) { if (!words.Contains(word)) { words.Add(word); } }
            if (existing.Count > 0 && words.Count == before) { return prefix; }
            string block = IgnoreLines(words);
            if (existing.Count > 0)
            {
                // The existing lines are one block: the first is replaced by the merged block, the rest are removed.
                var builder = new StringBuilder(prefix.Substring(0, existing[0].Index)).Append(block);
                int copied = existing[0].Index + existing[0].Length;
                for (int m = 1; m < existing.Count; m++)
                {
                    builder.Append(prefix, copied, existing[m].Index - copied);
                    copied = existing[m].Index + existing[m].Length;
                    if (copied < prefix.Length && prefix[copied] == '\n') { copied++; }
                }
                builder.Append(prefix, copied, prefix.Length - copied);
                return Regex.Replace(builder.ToString(), @"\n{3,}", "\n\n");
            }
            string pathLine = "`" + repoRelativePath + "`\n";
            int at = prefix.IndexOf(pathLine, StringComparison.Ordinal);
            if (at < 0) { return prefix.TrimEnd('\n') + "\n\n" + block + "\n"; }
            int after = at + pathLine.Length;
            return prefix.Substring(0, after) + "\n" + block + "\n" + prefix.Substring(after);
        }

        // The words as `<!-- cspell:ignore … -->` lines, each within the Markdown line limit; the spell checker reads them all.
        static string IgnoreLines(IReadOnlyList<string> words)
        {
            const string open = "<!-- cspell:ignore";
            const string close = " -->";
            var lines = new List<string>();
            var current = new StringBuilder(open);
            int count = 0;
            foreach (string word in words)
            {
                if (count > 0 && current.Length + 1 + word.Length + close.Length > PageLineLimit)
                {
                    lines.Add(current.Append(close).ToString());
                    current = new StringBuilder(open);
                    count = 0;
                }
                current.Append(' ').Append(word);
                count++;
            }
            lines.Add(current.Append(close).ToString());
            return string.Join("\n", lines);
        }
    }
}
