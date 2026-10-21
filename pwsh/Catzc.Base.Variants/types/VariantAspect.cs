/*
---
catzc:
  immutable:
    with_body_sha: "00143814f216"
  edges:
    docs: "[VariantAspect.cs.md](docs/references/pwsh/catzc-base-variants/types/VariantAspect.cs.md)"
    cites:
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
      - ADR-DSGN-ASPECT
---
*/

namespace Catzc.Base.Variants;

public sealed class VariantAspect
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The aspect's kebab-case name (e.g. live, tests).
    public string Name { get; }

    public string[] Patterns { get; }

    public VariantAspect(string name, string[] patterns)
    {
        Name = name;
        Patterns = patterns;
    }
}
