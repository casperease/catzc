/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/types/PathModule.cs
    kind: type
    relatives:
      test: automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1
    adrs:
      - ADR-DSGN-TRACK#3
---
*/

namespace Catzc.Base.Variants;

// The module a path is placed in, and the module type that says what sort of module it is.
public sealed class PathModule
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The module's name.
    public string name { get; }

    // The id of the module type of the module-types registry.
    public string type { get; }

    public PathModule(string name, string type)
    {
        this.name = name;
        this.type = type;
    }
}
