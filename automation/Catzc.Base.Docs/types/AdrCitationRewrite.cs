/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/types/AdrCitationRewrite.cs
    kind: type
    language: csharp
    filekind: cs
    track: automation
    module: Catzc.Base.Docs
    relatives:
      page: docs/references/automation/catzc-base-docs/types/AdrCitationRewrite.cs.md
    adrs:
      - ADR-AUTO-TYPES#9
---
*/

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
