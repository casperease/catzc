/*
---
catzc:
  immutable:
    with_body_sha: bdd6681bd742
  edges:
    docs: "[AdrCitationRewrite.cs.md](docs/references/pwsh/catzc-base-docs/types/AdrCitationRewrite.cs.md)"
    cites:
      - ADR-BCL-TYPES-NATIVETYPEDMODEL
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
