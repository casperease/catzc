/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Variants/types/VariantAspect.cs
    folder: types
    name: variant-aspect
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
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
