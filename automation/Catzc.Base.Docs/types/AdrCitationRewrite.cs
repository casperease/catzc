// The result of rewriting one file's ADR references (AdrCitationRewriter.Rewrite): the new text and every change made, in text order.
// [ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)
// [comment:1](/docs/references/automation/catzc-base-docs/types/AdrCitationRewrite.cs.md#comment1)

using System;
using System.Collections.Generic;

namespace Catzc.Base.Docs;

public sealed class AdrCitationRewrite
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string Text { get; }
    public bool Changed { get; }
    public IReadOnlyList<AdrCitationChange> Changes { get; }

    public AdrCitationRewrite(string text, bool changed, IReadOnlyList<AdrCitationChange> changes)
    {
        Text = text ?? throw new ArgumentNullException(nameof(text));
        Changed = changed;
        Changes = changes ?? throw new ArgumentNullException(nameof(changes));
    }
}
