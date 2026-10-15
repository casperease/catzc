// catzc:
//   path: automation/Catzc.Base.QualityGates/types/CommentFormatResult.cs
//   module: Catzc.Base.QualityGates

// A null text means nothing changes, and findings include the unfixed ones, so the caller sees what was left.
// [ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/CommentFormatResult.cs.md#comment1)

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
