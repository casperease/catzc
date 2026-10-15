// The internal model type for an automation "module" — one concept with four kinds (native C# per, because the platform's own logic...
// [ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)
// [comment:1](/docs/references/automation/catzc-base-modulesystem/types/BaseModule.cs.md#comment1)

using System;

namespace Catzc.Base.ModuleSystem;

public abstract class BaseModule
{
    // Once here for every kind (DiskModule, SessionModule, …): the rendering names the derived kind.
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The module name.
    // [comment:2](/docs/references/automation/catzc-base-modulesystem/types/BaseModule.cs.md#comment2)
    public string Name { get; }

    // On disk: named | hidden. In session (by provenance): imported | vendored | builtin | residue.
    public string Kind { get; }

    protected BaseModule(string name, string kind)
    {
        if (string.IsNullOrWhiteSpace(name)) { throw new ArgumentException("BaseModule requires a name"); }
        if (string.IsNullOrWhiteSpace(kind)) { throw new ArgumentException("BaseModule requires a kind"); }
        Name = name;
        Kind = kind;
    }
}
