/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.ModuleSystem/types/ModulePackage.cs
    folder: types
    name: module-package
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-modulesystem/types/ModulePackage.cs.md
---
*/

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
