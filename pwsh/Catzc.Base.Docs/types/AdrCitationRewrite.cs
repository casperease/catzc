/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/types/AdrCitationRewrite.cs
    folder: types
    name: adr-citation-rewrite
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[AdrCitationRewrite.cs.md](docs/references/pwsh/catzc-base-docs/types/AdrCitationRewrite.cs.md)"
    cites:
      - ADR-AUTO-TYPES-NATIVETYPEDMODEL
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
