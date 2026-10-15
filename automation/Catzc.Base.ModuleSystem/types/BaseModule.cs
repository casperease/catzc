/*
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/types/BaseModule.cs
    kind: csharp-type
    module: Catzc.Base.ModuleSystem
    relatives:
      page: docs/references/automation/catzc-base-modulesystem/types/BaseModule.cs.md
    adrs:
      - ADR-AUTO-TYPES#9
---
*/

using System;

namespace Catzc.Base.ModuleSystem;

public abstract class BaseModule
{
    // Once here for every kind (DiskModule, SessionModule, …): the rendering names the derived kind.
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

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
