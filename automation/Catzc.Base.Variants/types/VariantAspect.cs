/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/types/VariantAspect.cs
    kind: csharp-type
    module: Catzc.Base.Variants
    relatives:
      page: docs/references/automation/catzc-base-variants/types/VariantAspect.cs.md
    adrs:
      - ADR-AUTO-TYPES#8
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
