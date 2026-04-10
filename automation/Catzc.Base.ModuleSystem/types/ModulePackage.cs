// A named group of repository-root-relative file artifacts a DiskModule owns beyond its own folder, declared
// in configs/files.yml. The unit Copy-Automation excludes by name (-ExcludePackages); package names are
// globally unique across modules.

using System;
using System.Collections.Generic;

namespace Catzc.Base.ModuleSystem;

public sealed class ModulePackage
{
    public string Name { get; }
    public IReadOnlyList<string> Paths { get; }

    public ModulePackage(string name, IReadOnlyList<string> paths)
    {
        if (string.IsNullOrWhiteSpace(name)) { throw new ArgumentException("ModulePackage requires a name"); }
        Name = name;
        Paths = paths ?? new List<string>();
    }
}
