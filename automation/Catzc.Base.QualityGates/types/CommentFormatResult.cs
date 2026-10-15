// What CommentFormatter.Format decided for one file: the file's new text (null when nothing changes) and every
// finding, fixed or not. The formatter never writes; the caller does
// ([ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)).

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Catzc.Base.QualityGates;

public sealed class CommentFormatResult
{
    public string File { get; }
    public string Text { get; }
    public IReadOnlyList<CommentFinding> Findings { get; }

    public bool Changed => Text != null;
    public int FixedCount => Findings.Count(finding => finding.IsFixable);
    public int UnfixableCount => Findings.Count(finding => !finding.IsFixable);

    public CommentFormatResult(string file, string text, IReadOnlyList<CommentFinding> findings)
    {
        File = file ?? throw new ArgumentNullException(nameof(file));
        Text = text;
        Findings = findings ?? Array.Empty<CommentFinding>();
    }

    public override string ToString() =>
        string.Format(CultureInfo.InvariantCulture, "{0}: {1} fixed, {2} need a person", File, FixedCount, UnfixableCount);
}
