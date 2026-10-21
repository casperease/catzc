/*
---
catzc:
  immutable:
    with_body_sha: "4455395292ef"
  edges:
    cites:
      - ADR-REPO-VARIANT-FILEHEADS
---
*/

namespace Catzc.Base.Variants;

// The `file_heads` variant: which files carry a head, by the kind of file
// ([ADR-REPO-VARIANT-FILEHEADS](/docs/adr/repository/repo-variants.md#rule-adr-repo-variant-fileheads)).
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
