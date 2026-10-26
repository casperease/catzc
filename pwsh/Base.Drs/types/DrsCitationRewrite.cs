/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-drs/types/DrsCitationRewrite.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Drs;

public sealed class DrsCitationRewrite
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string Text { get; }
    public bool Changed { get; }
    public IReadOnlyList<DrsCitationChange> Changes { get; }

    public DrsCitationRewrite(string text, bool changed, IReadOnlyList<DrsCitationChange> changes)
    {
        Text = text ?? throw new ArgumentNullException(nameof(text));
        Changed = changed;
        Changes = changes ?? throw new ArgumentNullException(nameof(changes));
    }
}
