/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.ModuleSystem/types/ModuleDependencyEdge.cs
    folder: types
    name: module-dependency-edge
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[ModuleDependencyEdge.cs.md](docs/references/pwsh/catzc-base-modulesystem/types/ModuleDependencyEdge.cs.md)"
---
*/

using System;

namespace Catzc.Base.ModuleSystem;

public sealed class ModuleDependencyEdge
{
    public string From { get; }
    public string To { get; }
    public string Kind { get; }        // "actual" | "declared"
    public int CallCount { get; }      // actual: real cross-module call count; declared: 0
    public string[] Functions { get; } // actual: "Caller->Target:line" entries; declared: empty

    public ModuleDependencyEdge(string from, string to, string kind, int callCount, string[] functions)
    {
        if (string.IsNullOrWhiteSpace(from)) { throw new ArgumentException("ModuleDependencyEdge.From is required"); }
        if (string.IsNullOrWhiteSpace(to)) { throw new ArgumentException("ModuleDependencyEdge.To is required"); }
        From = from;
        To = to;
        Kind = string.IsNullOrWhiteSpace(kind) ? "actual" : kind;
        CallCount = callCount;
        Functions = functions ?? new string[0];
    }

    public override string ToString()
    {
        string calls = CallCount > 0 ? ", " + CallCount + " calls" : string.Empty;
        return From + " -> " + To + " (" + Kind + calls + ")";
    }
}
