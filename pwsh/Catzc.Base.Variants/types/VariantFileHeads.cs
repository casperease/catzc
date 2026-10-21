/*
---
catzc:
  immutable:
    with_body_sha: "2ec1f8bf078c"
  edges:
    cites:
      - ADR-REPO-VARIANT-FILEHEADS
---
*/

namespace Catzc.Base.Variants;

// The `file_heads` variant: which files carry a head, by the kind of file (ADR-REPO-VARIANT-FILEHEADS).
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
