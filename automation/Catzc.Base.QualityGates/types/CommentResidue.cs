/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/CommentResidue.cs
    kind: csharp-type
    module: Catzc.Base.QualityGates
    adrs:
      - ADR-AUTO-TYPES#9
---
*/

// Lines are 0-based and inclusive; any mechanical lines between insight and docs link hold citations and links only.
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/CommentResidue.cs.md#comment1)

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
    // The help section the residue stands in (`.PARAMETER Path`), or null outside a help block.
    public string HelpKeyword { get; }
    // False for a help residue its page pairs by section name: the residue is the insight line alone, with no docs link.
    public bool Linked { get; }

    public int LineCount => EndLine - StartLine + 1;

    public CommentResidue(int number, string page, int startLine, int endLine, string indent, string marker, string insight,
        string helpKeyword = null, bool linked = true)
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
        HelpKeyword = helpKeyword;
        Linked = linked;
        if (!linked && helpKeyword == null) { throw new ArgumentException("comment residue: only a help residue is paired without a link"); }
    }

    public override string ToString() =>
        string.Format(CultureInfo.InvariantCulture, "comment:{0} lines {1}-{2} -> {3}", Number, StartLine + 1, EndLine + 1, Page);
}
