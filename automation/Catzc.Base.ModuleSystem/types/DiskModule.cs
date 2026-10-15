// An on-disk automation module — a folder under automation/.
// [comment:1](/docs/references/automation/catzc-base-modulesystem/types/DiskModule.cs.md#comment1)

using System.Collections.Generic;

namespace Catzc.Base.ModuleSystem;

public sealed class DiskModule : BaseModule
{
    // Repository-root-relative folder, e.g. 'automation/Catzc.Base.Config'.
    public string RelativePath { get; }

    // Dot-prefixed infrastructure folder.
    public bool Hidden { get; }

    // Named artifact groups this module owns beyond its folder (files.yml).
    public IReadOnlyList<ModulePackage> Packages { get; }

    public DiskModule(string name, string relativePath, bool hidden, ModulePackage[] packages)
        : base(name, hidden ? "hidden" : "named")
    {
        RelativePath = relativePath;
        Hidden = hidden;
        Packages = packages ?? System.Array.Empty<ModulePackage>();
    }
}
