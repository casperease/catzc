// A single module-to-module dependency edge, typed for rendering to JSON / YAML / Markdown / PlantUML.
//
// Kind is "actual" — a real cross-module call edge (from Get-ModuleDependency; CallCount and Functions
// populated) — or "declared" — an allowed edge from configs/dependencies.yml (CallCount 0, Functions
// empty; To may be a GROUP name rather than a module). Produced by Get-ModuleDependencyEdges and rendered
// by ConvertTo-ModuleDependencyDiagram.
//
// BCL only; declares its module namespace (file-scoped), per the type loader. PascalCase (a result
// shape, not a YAML-config mirror).

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
        if (string.IsNullOrWhiteSpace(to))   { throw new ArgumentException("ModuleDependencyEdge.To is required"); }
        From      = from;
        To        = to;
        Kind      = string.IsNullOrWhiteSpace(kind) ? "actual" : kind;
        CallCount = callCount;
        Functions = functions ?? new string[0];
    }

    public override string ToString()
    {
        string calls = CallCount > 0 ? ", " + CallCount + " calls" : string.Empty;
        return From + " -> " + To + " (" + Kind + calls + ")";
    }
}
