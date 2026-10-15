/*
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/types/ModuleDependencyEdge.cs
    kind: csharp-type
    module: Catzc.Base.ModuleSystem
    relatives:
      page: docs/references/automation/catzc-base-modulesystem/types/ModuleDependencyEdge.cs.md
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
