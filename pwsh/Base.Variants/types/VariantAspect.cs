/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-variants/types/VariantAspect.cs.md"
  header: "generated"
---
*/

namespace Catzc.Base.Variants;

// One aspect: a single-key {name: [patterns]} entry, patterns relative to the unit root.
public sealed class VariantAspect
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The aspect's kebab-case name (e.g. live, tests).
    public string Name { get; }

    // A track's last aspect is the bare '**' catch-all.
    public string[] Patterns { get; }

    public VariantAspect(string name, string[] patterns)
    {
        Name = name;
        Patterns = patterns;
    }
}
