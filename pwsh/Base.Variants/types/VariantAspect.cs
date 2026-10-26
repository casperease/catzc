/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-variants/types/VariantAspect.cs.md"
  header: "generated"
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
