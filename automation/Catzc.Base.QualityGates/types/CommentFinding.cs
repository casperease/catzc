// One finding of CommentFormatter: where (repository-relative file, 1-based line), what kind, a human message, and
// whether Format-Comments fixes it. Every property is fixed at construction; the formatter is pure over text
// ([ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)).

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
        Kind == CommentFindingKind.Empty || Kind == CommentFindingKind.LinkInInsight || Kind == CommentFindingKind.Overlong;

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
