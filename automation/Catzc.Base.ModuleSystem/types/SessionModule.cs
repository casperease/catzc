// A module loaded into the current PowerShell session, mapped by how it came into play (its ModuleBase
// location): Kind 'imported' (our automation module, under automation/), 'vendored' (under automation/.vendor/),
// 'builtin' (shipped with PowerShell, under $PSHOME), or 'residue' (genuinely foreign — user profile, the
// PowerShell Gallery, or a manual import). The runtime facet — introspection and collision reporting, not copying.

namespace Catzc.Base.ModuleSystem;

public sealed class SessionModule : BaseModule
{
    // The loaded module's base directory.
    public string ModuleBase { get; }

    // The loaded module's version, as a string.
    public string Version { get; }

    public SessionModule(string name, string kind, string moduleBase, string version)
        : base(name, kind)
    {
        ModuleBase = moduleBase;
        Version = version;
    }
}
