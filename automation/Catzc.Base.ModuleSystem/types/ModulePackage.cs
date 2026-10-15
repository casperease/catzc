// A named group of repository-root-relative file artifacts a DiskModule owns beyond its own folder, declared in configs/files.yml.
// [comment:1](/docs/references/automation/catzc-base-modulesystem/types/ModulePackage.cs.md#comment1)

using System;
using System.Collections.Generic;

namespace Catzc.Base.ModuleSystem;

public sealed class ModulePackage
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string Name { get; }
    public IReadOnlyList<string> Paths { get; }

    public ModulePackage(string name, IReadOnlyList<string> paths)
    {
        if (string.IsNullOrWhiteSpace(name)) { throw new ArgumentException("ModulePackage requires a name"); }
        Name = name;
        Paths = paths ?? new List<string>();
    }
}
