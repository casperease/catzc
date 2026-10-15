// catzc:
//   path: automation/Catzc.Base.ModuleSystem/types/BaseModule.cs
//   module: Catzc.Base.ModuleSystem

// The platform's own logic selects on the kind and pins it at call sites, which is why this is a native C# type.
// [ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)
// [comment:1](/docs/references/automation/catzc-base-modulesystem/types/BaseModule.cs.md#comment1)

using System;

namespace Catzc.Base.ModuleSystem;

public abstract class BaseModule
{
    // Once here for every kind (DiskModule, SessionModule, …): the rendering names the derived kind.
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The folder name for a disk module, dot included for hidden ones; the loaded module name for a session module.
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
