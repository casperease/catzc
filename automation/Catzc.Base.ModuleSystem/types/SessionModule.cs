// The runtime facet, for introspection and collision reporting rather than copying; residue means genuinely foreign.
// [comment:1](/docs/references/automation/catzc-base-modulesystem/types/SessionModule.cs.md#comment1)

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
