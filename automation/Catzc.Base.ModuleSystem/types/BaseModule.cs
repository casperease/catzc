// The internal domain model for an automation "module" — one concept with four kinds (native C# per
// ADR-TYPES:9, because the platform's own logic selects on it and pins it at call sites). Two facets:
// on-disk (kinds 'named'/'hidden', see DiskModule) and in-session (kinds 'imported'/'residue', see
// SessionModule). Get-BaseModule returns these; Copy-Automation and module introspection act on them.

using System;

namespace Catzc.Base.ModuleSystem;

public abstract class BaseModule
{
    // The module name. For a disk module the folder name (e.g. 'Catzc.Base.Config', '.vendor'); for a session
    // module the loaded module name.
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
