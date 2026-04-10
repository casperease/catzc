// An on-disk automation module — a folder under automation/. Kind 'named' for a non-dot folder (Catzc.*),
// 'hidden' for a dot-prefixed infrastructure folder (.internal, .vendor, .compiled, .scriptanalyzer). Carries
// its repository-root-relative folder path and the named packages (extra file artifacts) it owns via
// configs/files.yml. This is the facet Copy-Automation copies.

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
