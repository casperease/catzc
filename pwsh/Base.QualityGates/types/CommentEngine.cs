// Pure functions over text, so the move and its inverse are provable on fixtures and each comment keeps one living copy.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using static Catzc.Base.QualityGates.CommentPageText;

namespace Catzc.Base.QualityGates;

// Rests on [PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](/docs/drs/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig), [PDR-ONELIVE-ONEVERSION](/docs/drs/principles/one-living-version.md#rule-pdr-onelive-oneversion) and [ADR-REPO-FORMAT-GENERATEDFORMATTED](/docs/drs/repository/uniform-formatting.md#rule-adr-repo-format-generatedformatted).
public static class CommentEngine
{
    static readonly Regex CodeSpanText = new Regex(@"(`+)[^`\r\n]+?\1", RegexOptions.Compiled);
    internal static readonly Regex Whitespace = new Regex(@"\s+", RegexOptions.Compiled);
    static readonly Regex IgnoreDirective = new Regex(@"cspell:ignore[ \t]+(?<words>[^\r\n]*)", RegexOptions.Compiled);
    static readonly Regex IgnoreWord = new Regex(@"^[A-Za-z0-9][A-Za-z0-9'_-]*$", RegexOptions.Compiled);
    internal const string FenceOpen = "```text";
    internal const string FenceClose = "```";
    const int ContextLength = 80;
    const string Ellipsis = "...";

    // ---- finding ----------------------------------------------------------------------------------------------

    public static IReadOnlyList<CommentBlock> FindBlocks(string text, string extension, string language, CommentsConfig config)
    {
        if (config == null) { throw new ArgumentNullException(nameof(config)); }
        if (string.IsNullOrEmpty(text)) { return Array.Empty<CommentBlock>(); }

        Lines lines = Lines.Of(text);
        var blocks = new List<CommentBlock>();
        var run = new List<(int line, string indent, string marker, string prose)>();
        int keptRunEnd = -2;
        string keptRunIndent = null;
        string keptRunMarker = null;

        void FlushRun()
        {
            if (run.Count == 0) { return; }
            var first = run[0];
            blocks.Add(new CommentBlock(CommentBlockKind.LineRun, first.line, run[run.Count - 1].line, first.indent, first.marker,
                run.Select(r => r.prose).ToList()));
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
                if (IsMetaHead(lines, startLine, endLine, extension, language, config))
                {
                    continue;   // the meta head is a front matter document in a comment, never prose
                }
                CommentBlock block = DelimitedBlock(lines, startLine, endLine, before);
                if (block != null) { blocks.Add(block); }
                continue;
            }

            string marker = MarkerOf(comment);
            bool continuesRun = run.Count > 0 && run[run.Count - 1].line == startLine - 1 && run[run.Count - 1].indent == before
                && run[run.Count - 1].marker == marker;
            if ((config.IsKeptRun(language, comment) || OpensFencedHead(lines, startLine, before, marker, comment, language, config)) && !continuesRun)
            {
                // A head that keeps its run (the meta head) stays with the lines directly under it, so they never read as prose.
                FlushRun();
                keptRunEnd = startLine;
                keptRunIndent = before;
                keptRunMarker = marker;
                continue;
            }
            if (keptRunEnd == startLine - 1 && keptRunIndent == before && keptRunMarker == marker)
            {
                keptRunEnd = startLine;
                continue;
            }
            if (config.IsKept(language, comment))
            {
                // A kept line (a spell-checker directive, #Requires, #region) stays where it is and splits the run around it.
                FlushRun();
                continue;
            }
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
        // A delimited block that holds a kept head is the comment-based help the help system reads, so it stays whole.
        if (block.Kind == CommentBlockKind.Block && block.Lines.Any(line => config.IsKept(language, line))) { return false; }
        return !config.IsKept(language, lines[block.StartLine].Trim());
    }

    // A block whose inner lines open with a front matter fence and then a listed head (catzc:), in the language's own line marker.
    static bool IsMetaHead(Lines lines, int startLine, int endLine, string extension, string language, CommentsConfig config)
    {
        if (endLine - startLine < 3 || lines[startLine + 1].Trim() != "---") { return false; }
        return config.IsKeptRun(language, FamilyMarker(extension) + " " + lines[startLine + 2].Trim());
    }

    // A line-comment fence (# ---) directly over a listed head in the same marker and indent: the meta head's first line.
    static bool OpensFencedHead(Lines lines, int startLine, string indent, string marker, string comment, string language, CommentsConfig config)
    {
        if (comment.Substring(marker.Length).Trim() != "---" || startLine + 1 >= lines.Count) { return false; }
        string next = lines[startLine + 1];
        return next.StartsWith(indent + marker, StringComparison.Ordinal) && config.IsKeptRun(language, next.Trim());
    }

    // A `<# … #>` or `/* … */` block: its inner lines, plus any text beside the delimiters.
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
        return new CommentBlock(CommentBlockKind.Block, startLine, endLine, indent, string.Empty, prose);
    }

    static string MarkerOf(string comment)
    {
        if (comment.StartsWith("///", StringComparison.Ordinal)) { return "///"; }
        if (comment.StartsWith("//", StringComparison.Ordinal)) { return "//"; }
        return "#";
    }

    // The line marker a delimited block is written back with: the family's line comment.
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

    // A moved comment leaves nothing in the file: its page section names the code line it sat above, and the view puts it back there.
    public static CommentFileResult Export(string text, string extension, string language, string repoRelativePath, string pagePath,
        string existingPageText, CommentsConfig config, int pageWidth)
    {
        if (string.IsNullOrEmpty(repoRelativePath)) { throw new ArgumentException("comment engine: the file path is required"); }
        if (string.IsNullOrEmpty(pagePath)) { throw new ArgumentException("comment engine: the page path is required"); }
        IReadOnlyList<CommentBlock> blocks = FindBlocks(text, extension, language, config);
        if (blocks.Count == 0) { return new CommentFileResult(repoRelativePath, pagePath, null, null, Array.Empty<CommentBlock>()); }

        Lines lines = Lines.Of(text);
        Page page = Page.Parse(existingPageText);
        var output = new List<string>();
        var removedAt = new List<int>();
        int next = 0;
        foreach (CommentBlock block in blocks)
        {
            for (int i = next; i < block.StartLine; i++) { output.Add(lines[i]); }
            removedAt.Add(output.Count);
            next = block.EndLine + 1;
            // Taking the comment out must not leave two blank lines where one stood on each side of it.
            bool blankBefore = output.Count == 0 || output[output.Count - 1].Trim().Length == 0;
            if (blankBefore && next < lines.Count && lines[next].Trim().Length == 0) { next++; }
        }
        for (int i = next; i < lines.Count; i++) { output.Add(lines[i]); }

        int number = page.HighestNumber;
        var sections = new List<string>();
        for (int b = 0; b < blocks.Count; b++)
        {
            number++;
            CommentBlock block = blocks[b];
            int anchorLine = Lines.NextCodeIndex(output, removedAt[b]);
            string anchor = anchorLine < 0 ? null : AnchorOf(output[anchorLine]);
            int occurrence = 1;
            if (anchor != null)
            {
                for (int i = 0; i < anchorLine; i++) { if (AnchorOf(output[i]) == anchor) { occurrence++; } }
            }
            string marker = block.Kind == CommentBlockKind.Block ? FamilyMarker(extension) : block.Marker;
            sections.Add(Section(block, number, Context(anchor, occurrence, marker)));
        }

        string newText = lines.Join(output);
        string newPage = page.With(sections, repoRelativePath, IgnoredWords(text, extension), pageWidth);
        return new CommentFileResult(repoRelativePath, pagePath, newText, newPage, blocks);
    }

    // A new page is born formatted: its title and what it holds, wrapped at the markdown width.
    public static string FreshPage(string repoRelativePath, int width) =>
        "# " + repoRelativePath + "\n\n"
        + Wrap("The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its"
            + " comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the"
            + " first section survives every later export.", width);

    // Prose filled greedily to the width, as prettier's proseWrap fills it; a word longer than the width stands on its own line.
    static string Wrap(string prose, int width)
    {
        if (width < 1) { throw new ArgumentException("comment engine: the page width must be positive"); }
        var builder = new StringBuilder();
        int column = 0;
        foreach (string word in prose.Split(' ', StringSplitOptions.RemoveEmptyEntries))
        {
            if (column > 0 && column + 1 + word.Length > width) { builder.Append('\n'); column = 0; }
            else if (column > 0) { builder.Append(' '); column++; }
            builder.Append(word);
            column += word.Length;
        }
        return builder.Append('\n').ToString();
    }

    // The page ignores these words too, or moved prose would fail a spell check the file itself passed.
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

    static string Section(CommentBlock block, int number, string context)
    {
        var builder = new StringBuilder();
        builder.Append("## comment:").Append(number.ToString(CultureInfo.InvariantCulture)).Append("\n\n");
        builder.Append(context).Append("\n\n");
        builder.Append(FenceOpen).Append('\n');
        foreach (string line in block.Lines) { builder.Append(line).Append('\n'); }
        builder.Append(FenceClose).Append('\n');
        return builder.ToString();
    }

    // ---- anchors, the view and the orphans --------------------------------------------------------------------

    // A Describe line anchors on its name, before its first -Tag, so a re-tier leaves the section in step.
    static readonly Regex DescribeTags = new Regex(@"^(?<name>Describe\s+.+?)\s+-Tag\b", RegexOptions.Compiled);

    // The trimmed code line, cut at a word to the context length: what a page section names and what the view looks for.
    static string AnchorOf(string line)
    {
        Match describe = DescribeTags.Match(line.Trim());
        string trimmed = describe.Success ? describe.Groups["name"].Value : line.Trim();
        if (trimmed.Length <= ContextLength) { return trimmed; }
        int cut = trimmed.LastIndexOf(' ', ContextLength - Ellipsis.Length);
        if (cut <= 0) { cut = ContextLength - Ellipsis.Length; }
        return trimmed.Substring(0, cut).TrimEnd() + Ellipsis;
    }

    // What the page says the comment annotated: the code line it sat above (and which of equal lines), and how it was written.
    static string Context(string anchor, int occurrence, string marker)
    {
        string written = ", written with " + CommentBlock.CodeSpan(marker) + ".";
        if (anchor == null) { return "At the end of the file" + written; }
        string which = occurrence > 1 ? string.Format(CultureInfo.InvariantCulture, " (occurrence {0})", occurrence) : string.Empty;
        return "Above " + CommentBlock.CodeSpan(anchor) + which + written;
    }

    sealed class Placement
    {
        public int Number { get; set; }
        public string Anchor { get; set; }   // null: the end of the file
        public int Occurrence { get; set; }
        public string Marker { get; set; }
        public IReadOnlyList<string> Lines { get; set; }
    }

    static readonly Regex ContextPattern = new Regex(@"^(?:Above (?<span>`.+`)(?: \(occurrence (?<occurrence>\d+)\))?|At the end of the file), written with (?<marker>`+[^`]+`+)\.$", RegexOptions.Compiled);

    // The section's placement, or null when its context line is no placement (a page written by hand).
    static Placement PlacementOf(int number, PageSection section)
    {
        if (section.Context == null) { return null; }
        Match match = ContextPattern.Match(section.Context);
        if (!match.Success) { return null; }
        return new Placement
        {
            Number = number,
            Anchor = match.Groups["span"].Success ? StripSpan(match.Groups["span"].Value) : null,
            Occurrence = match.Groups["occurrence"].Success ? int.Parse(match.Groups["occurrence"].Value, CultureInfo.InvariantCulture) : 1,
            Marker = StripSpan(match.Groups["marker"].Value),
            Lines = section.Lines,
        };
    }

    // The inverse of CommentBlock.CodeSpan: the text inside the fence, less the pad a leading or trailing backtick needed.
    static string StripSpan(string span)
    {
        int fence = 0;
        while (fence < span.Length && span[fence] == '`') { fence++; }
        string inner = span.Substring(fence, span.Length - 2 * fence);
        if (inner.Length >= 2 && inner[0] == ' ' && inner[inner.Length - 1] == ' ' && (inner[1] == '`' || inner[inner.Length - 2] == '`'))
        {
            inner = inner.Substring(1, inner.Length - 2);
        }
        return inner;
    }

    // The line a section goes above: the nth line equal to its anchor, or the end of the file; -1 when the code no longer has it.
    static int Place(IReadOnlyList<string> lines, Placement placement)
    {
        if (placement.Anchor == null) { return lines.Count; }
        int seen = 0;
        for (int i = 0; i < lines.Count; i++)
        {
            if (AnchorOf(lines[i]) != placement.Anchor) { continue; }
            seen++;
            if (seen == placement.Occurrence) { return i; }
        }
        return -1;
    }

    static List<Placement> Placements(string pageText)
    {
        Page page = Page.Parse(pageText);
        var placements = new List<Placement>();
        foreach (KeyValuePair<int, PageSection> section in page.Sections)
        {
            Placement placement = PlacementOf(section.Key, section.Value);
            if (placement != null) { placements.Add(placement); }
        }
        return placements;
    }

    // The annotated copy: every section the code still has a line for goes back above that line, as line comments.
    public static string View(string text, string extension, string pageText)
    {
        if (string.IsNullOrEmpty(text)) { return text ?? string.Empty; }
        Lines source = Lines.Of(text);
        var lines = new List<string>(source.Count);
        for (int i = 0; i < source.Count; i++) { lines.Add(source[i]); }
        var back = new SortedDictionary<int, List<Placement>>();
        foreach (Placement placement in Placements(pageText))
        {
            int at = Place(lines, placement);
            if (at < 0) { continue; }
            if (!back.TryGetValue(at, out List<Placement> list)) { back[at] = list = new List<Placement>(); }
            list.Add(placement);
        }
        if (back.Count == 0) { return text; }
        var output = new List<string>();
        for (int i = 0; i <= lines.Count; i++)
        {
            if (back.TryGetValue(i, out List<Placement> here))
            {
                string indent = i < lines.Count ? lines[i].Substring(0, lines[i].Length - lines[i].TrimStart().Length) : string.Empty;
                foreach (Placement placement in here)
                {
                    foreach (string line in placement.Lines)
                    {
                        output.Add(line.Length == 0 ? (indent + placement.Marker).TrimEnd() : indent + placement.Marker + " " + line);
                    }
                }
            }
            if (i < lines.Count) { output.Add(lines[i]); }
        }
        return source.Join(output);
    }

    // The numbers of the page's sections whose code line the file no longer has: their prose belongs to nothing.
    public static IReadOnlyList<int> Orphans(string text, string pageText)
    {
        Lines source = Lines.Of(text ?? string.Empty);
        var lines = new List<string>(source.Count);
        for (int i = 0; i < source.Count; i++) { lines.Add(source[i]); }
        var orphans = new List<int>();
        Page page = Page.Parse(pageText);
        foreach (KeyValuePair<int, PageSection> section in page.Sections)
        {
            Placement placement = PlacementOf(section.Key, section.Value);
            if (placement == null || Place(lines, placement) < 0) { orphans.Add(section.Key); }
        }
        return orphans;
    }
}
