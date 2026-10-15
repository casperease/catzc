// One comment block CommentEngine found in a file and may move to the file's comment page: where it is (whole
// lines, 0-based, inclusive), how it is written (kind, indent, marker), its prose with the comment prefix stripped,
// and the context the page names so a reader knows what it annotated. Every property is fixed at construction; the
// engine is pure over text ([ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)).

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Catzc.Base.QualityGates;

public sealed class CommentBlock
{
    public CommentBlockKind Kind { get; }
    // The first and last line the block occupies (its body lines for a help section), 0-based, inclusive.
    public int StartLine { get; }
    public int EndLine { get; }
    // The leading whitespace every prose line carries in the file (the body indent of a help section).
    public string Indent { get; }
    // The line marker of a line run ('#', '//', '///'); empty for a block or a help section.
    public string Marker { get; }
    // The `.KEYWORD …` line a help section belongs to (`.DESCRIPTION`, `.PARAMETER Path`); null otherwise.
    public string Keyword { get; }
    // The prose lines with indent and marker stripped, otherwise verbatim; a blank comment line is "".
    public IReadOnlyList<string> Lines { get; }
    // The trimmed code line right after the block, or null at the end of the file (a help section names its keyword).
    public string NextCodeLine { get; }

    public int LineCount => Lines.Count;
    public int ProseLineCount => Lines.Count(line => line.Trim().Length > 0);
    // The prose as one line, whitespace collapsed: what the residue's provisional insight is cut from.
    public string Text => string.Join(" ", Lines.Select(line => line.Trim()).Where(line => line.Length > 0));

    public CommentBlock(CommentBlockKind kind, int startLine, int endLine, string indent, string marker, string keyword, IReadOnlyList<string> lines, string nextCodeLine)
    {
        if (startLine < 0 || endLine < startLine)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "comment block: lines {0}..{1} are not a range", startLine, endLine));
        }
        Kind = kind;
        StartLine = startLine;
        EndLine = endLine;
        Indent = indent ?? string.Empty;
        Marker = marker ?? string.Empty;
        Keyword = keyword;
        Lines = lines ?? throw new ArgumentNullException(nameof(lines));
        NextCodeLine = nextCodeLine;
    }

    // What the page says the block annotated: its help keyword, or the code line it sat above.
    public string Context =>
        Keyword != null ? string.Format(CultureInfo.InvariantCulture, "Section {0} of the comment-based help.", CodeSpan(Keyword))
        : NextCodeLine != null ? string.Format(CultureInfo.InvariantCulture, "Above {0}.", CodeSpan(NextCodeLine))
        : "At the end of the file.";

    // A Markdown code span that holds the text verbatim, backticks included: its fence is one backtick longer than the
    // longest run inside, and it is padded with a space only when the text starts or ends with a backtick.
    public static string CodeSpan(string text)
    {
        int longest = 0;
        int run = 0;
        foreach (char c in text ?? string.Empty)
        {
            run = c == '`' ? run + 1 : 0;
            longest = Math.Max(longest, run);
        }
        string fence = new string('`', longest + 1);
        bool pad = !string.IsNullOrEmpty(text) && (text[0] == '`' || text[text.Length - 1] == '`');
        string inner = pad ? " " + text + " " : text;
        return fence + inner + fence;
    }

    public override string ToString() =>
        string.Format(CultureInfo.InvariantCulture, "{0} lines {1}-{2} ({3} prose line(s)){4}", Kind, StartLine + 1, EndLine + 1, ProseLineCount,
            Keyword != null ? " " + Keyword : string.Empty);
}
