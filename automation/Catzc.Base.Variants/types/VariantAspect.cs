/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/types/VariantAspect.cs
    kind: type
    module: Catzc.Base.Variants
---
*/

// The YAML key is the aspect's name (data, not a fixed field), so the record keeps .NET PascalCase, not snake_case.
// [ADR-DSGN-ASPECT](/docs/adr/design/module-aspects.md),
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-base-variants/types/VariantAspect.cs.md#comment1)

namespace Catzc.Base.Variants;

public sealed class VariantAspect
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The aspect's kebab-case name (e.g. live, tests).
    public string Name { get; }

    // The last aspect of a track holds the bare '**' catch-all remainder.
    // [comment:2](/docs/references/automation/catzc-base-variants/types/VariantAspect.cs.md#comment2)
    public string[] Patterns { get; }

    public VariantAspect(string name, string[] patterns)
    {
        Name = name;
        Patterns = patterns;
    }
}
