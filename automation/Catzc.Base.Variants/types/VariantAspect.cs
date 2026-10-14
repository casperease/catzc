// One aspect of a track's ordered classification in the `aspects` variant (configs/variants.yml,
// [ADR-DSGN-ASPECT](/docs/adr/design/module-aspects.md)): a single-key `{name: [patterns]}` entry, patterns relative
// to the unit root. The YAML key is the aspect's name (data, not a fixed field), so the record is not a key mirror
// and keeps .NET PascalCase ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
// VariantsConfig validates the entry in its track's context (name, order, catch-all) and builds one; Get-Aspect
// returns them.

namespace Catzc.Base.Variants;

public sealed class VariantAspect
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The aspect's kebab-case name (e.g. live, tests).
    public string Name { get; }

    // The aspect's glob patterns, relative to the unit root. The last aspect of a track is the bare '**'
    // catch-all remainder.
    public string[] Patterns { get; }

    public VariantAspect(string name, string[] patterns)
    {
        Name = name;
        Patterns = patterns;
    }
}
