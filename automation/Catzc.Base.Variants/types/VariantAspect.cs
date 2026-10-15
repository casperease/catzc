// One aspect of a track's ordered classification in the `aspects` variant (configs/variants.yml, ): a single-key `{name: [patterns]}`...
// [ADR-DSGN-ASPECT](/docs/adr/design/module-aspects.md),
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-base-variants/types/VariantAspect.cs.md#comment1)

namespace Catzc.Base.Variants;

public sealed class VariantAspect
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The aspect's kebab-case name (e.g. live, tests).
    public string Name { get; }

    // The aspect's glob patterns, relative to the unit root.
    // [comment:2](/docs/references/automation/catzc-base-variants/types/VariantAspect.cs.md#comment2)
    public string[] Patterns { get; }

    public VariantAspect(string name, string[] patterns)
    {
        Name = name;
        Patterns = patterns;
    }
}
