/*
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/types/SessionModule.cs
    kind: type
    language: csharp
    filekind: cs
    track: automation
    module: Catzc.Base.ModuleSystem
    relatives:
      page: docs/references/automation/catzc-base-modulesystem/types/SessionModule.cs.md
---
*/

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
