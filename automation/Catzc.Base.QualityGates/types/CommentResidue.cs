// One residue CommentEngine found in a file: the lines that stand where a comment block was moved to the file's
// comment page — the insight line, any mechanical lines (citations and links only), and the docs-link line
// `[comment:N](/<page>#commentN)` that closes it. Lines are 0-based and inclusive; the engine is pure over text
// ([ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)).

using System;
using System.Globalization;

namespace Catzc.Base.QualityGates;

public sealed class CommentResidue
{
    public int Number { get; }
    public string Page { get; }
    public int StartLine { get; }
    public int EndLine { get; }
    public string Indent { get; }
    public string Marker { get; }
    // The insight line's text with indent and marker stripped; empty when the residue has no insight line.
    public string Insight { get; }

    public int LineCount => EndLine - StartLine + 1;

    public CommentResidue(int number, string page, int startLine, int endLine, string indent, string marker, string insight)
    {
        if (number <= 0) { throw new ArgumentException("comment residue: the number must be positive"); }
        if (startLine < 0 || endLine < startLine)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "comment residue: lines {0}..{1} are not a range", startLine, endLine));
        }
        Number = number;
        Page = page ?? throw new ArgumentNullException(nameof(page));
        StartLine = startLine;
        EndLine = endLine;
        Indent = indent ?? string.Empty;
        Marker = marker ?? string.Empty;
        Insight = insight ?? string.Empty;
    }

    public override string ToString() =>
        string.Format(CultureInfo.InvariantCulture, "comment:{0} lines {1}-{2} -> {3}", Number, StartLine + 1, EndLine + 1, Page);
}
