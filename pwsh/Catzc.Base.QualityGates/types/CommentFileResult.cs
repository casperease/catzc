/*
---
catzc:
  immutable:
    with_body_sha: da7228167aa2
  edges:
    docs: "[CommentFileResult.cs.md](docs/references/pwsh/catzc-base-quality-gates/types/CommentFileResult.cs.md)"
    cites:
      - ADR-BCL-TYPES-NATIVETYPEDMODEL
---
*/

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
