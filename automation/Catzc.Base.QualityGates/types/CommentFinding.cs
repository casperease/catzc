/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/CommentFinding.cs
    kind: type
    module: Catzc.Base.QualityGates
    adrs:
      - ADR-AUTO-TYPES#9
---
*/

// Fixable tells the caller whether Format-Comments rewrites this finding or a person must.
// [ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/CommentFinding.cs.md#comment1)

using System;
using System.Globalization;

namespace Catzc.Base.QualityGates;

public sealed class CommentFinding
{
    public string File { get; }
    public int Line { get; }
    public CommentFindingKind Kind { get; }
    public string Message { get; }

    // Fixable kinds are rewritten by Format-Comments; the rest need a person or Export-Comments.
    public bool IsFixable =>
        Kind == CommentFindingKind.Empty || Kind == CommentFindingKind.LinkInInsight || Kind == CommentFindingKind.Overlong
        || Kind == CommentFindingKind.CitationInResidue;

    public CommentFinding(string file, int line, CommentFindingKind kind, string message)
    {
        if (line <= 0) { throw new ArgumentException("comment finding: the line must be 1-based and positive"); }
        File = file ?? throw new ArgumentNullException(nameof(file));
        Line = line;
        Kind = kind;
        Message = message ?? string.Empty;
    }

    public override string ToString() =>
        string.Format(CultureInfo.InvariantCulture, "{0}:{1} [{2}] {3}", File, Line, Kind, Message);
}
