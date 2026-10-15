/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/types/AdrCitationRewrite.cs
    kind: type
    module: Catzc.Base.Docs
    adrs:
      - ADR-AUTO-TYPES#9
---
*/

// Changed is false exactly when the text is the input unchanged, so a caller writes the file only when it is true.
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
