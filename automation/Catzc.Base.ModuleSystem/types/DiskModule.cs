/*
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/types/DiskModule.cs
    folder: types
    name: disk-module
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-modulesystem/types/DiskModule.cs.md
---
*/

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
