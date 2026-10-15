/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/CommentFileResult.cs
    kind: type
    module: Catzc.Base.QualityGates
    adrs:
      - ADR-AUTO-TYPES#9
---
*/

// The engine never writes: a null text means nothing changes, and the caller decides whether to touch file or page.
// [ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/CommentFileResult.cs.md#comment1)

using System;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.QualityGates;

public sealed class CommentFileResult
{
    public string File { get; }
    public string Page { get; }
    public string Text { get; }
    public string PageText { get; }
    public IReadOnlyList<CommentBlock> Moved { get; }

    public bool Changed => Text != null;
    public int MovedCount => Moved.Count;

    public CommentFileResult(string file, string page, string text, string pageText, IReadOnlyList<CommentBlock> moved)
    {
        File = file ?? throw new ArgumentNullException(nameof(file));
        Page = page;
        Text = text;
        PageText = pageText;
        Moved = moved ?? Array.Empty<CommentBlock>();
    }

    public override string ToString() =>
        Changed
            ? string.Format(CultureInfo.InvariantCulture, "{0}: {1} comment(s) -> {2}", File, MovedCount, Page)
            : string.Format(CultureInfo.InvariantCulture, "{0}: nothing to move", File);
}
