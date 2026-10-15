/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/CommentBlock.cs
    kind: csharp-type
    module: Catzc.Base.QualityGates
    adrs:
      - ADR-AUTO-TYPES#9
---
*/

// Every property is fixed at construction and the engine is pure over text, so a block is a value the caller can keep.
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/CommentBlock.cs.md#comment1)

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
        Keyword != null ? HelpContext(Keyword)
        : NextCodeLine != null ? string.Format(CultureInfo.InvariantCulture, "Above {0}.", CodeSpan(NextCodeLine))
        : "At the end of the file.";

    // The page's context line for a help section; it is also the key that pairs a help residue without a link.
    public static string HelpContext(string keyword) =>
        string.Format(CultureInfo.InvariantCulture, "Section {0} of the comment-based help.", CodeSpan(keyword));

    // The fence is one backtick longer than any run inside, so text that holds backticks still renders verbatim.
    // [comment:2](/docs/references/automation/catzc-base-qualitygates/types/CommentBlock.cs.md#comment2)
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
