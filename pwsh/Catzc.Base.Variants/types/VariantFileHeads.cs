/*
---
catzc:
  immutable:
    with_body_sha: df578bf1549f
  edges:
    docs: "[VariantFileHeads.cs.md](../../../docs/references/pwsh/catzc-base-variants/types/VariantFileHeads.cs.md)"
    cites:
      - ADR-REPO-VARIANT-FILEHEADS
---
*/

namespace Catzc.Base.Variants;

public sealed class VariantFileHeads
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // Whether an authored code or config file carries the navigation head: 'minimal' or 'none'.
    public string code { get; }

    public VariantFileHeads(string code)
    {
        this.code = code;
    }
}
