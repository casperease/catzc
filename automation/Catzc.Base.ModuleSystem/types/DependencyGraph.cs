/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.ModuleSystem/types/DependencyGraph.cs
    folder: types
    name: dependency-graph
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-modulesystem/types/DependencyGraph.cs.md
    cites:
      - ADR-AUTO-DEPM#4
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Catzc.Base.ModuleSystem;

public static class DependencyGraph
{
    public static string[] ReadNames(object value, string owner, string what, List<string> errors)
    {
        if (value == null) { return new string[0]; }
        if (value is string || !(value is IEnumerable) || value is IDictionary)
        {
            string shape = value is IDictionary ? "a map" : "a single string";
            errors.Add(string.Format("{0} must map to a list of {1}, not {2}", owner, what, shape));
            return new string[0];
        }

        List<string> names = new List<string>();
        foreach (object item in (IEnumerable)value)
        {
            if (item == null || item is IDictionary || (item is IEnumerable && !(item is string)) || string.IsNullOrWhiteSpace(item.ToString()))
            {
                errors.Add(string.Format("{0} lists an entry that is not a name (each entry is one module or group name)", owner));
                continue;
            }
            names.Add(item.ToString());
        }
        return names.ToArray();
    }

    public static string FindCycle(OrderedDictionary adjacency)
    {
        Dictionary<string, int> color = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
        foreach (object node in adjacency.Keys) { color[node.ToString()] = 0; }
        List<string> path = new List<string>();

        foreach (object node in adjacency.Keys)
        {
            if (color[node.ToString()] != 0) { continue; }
            string cycle = Visit(node.ToString(), adjacency, color, path);
            if (cycle != null) { return cycle; }
        }
        return null;
    }

    private static string Visit(string node, OrderedDictionary adjacency, Dictionary<string, int> color, List<string> path)
    {
        color[node] = 1;
        path.Add(node);
        foreach (string next in (string[])adjacency[node])
        {
            int state;
            if (!color.TryGetValue(next, out state)) { continue; }
            if (state == 1)
            {
                int index = path.FindIndex(p => string.Equals(p, next, StringComparison.OrdinalIgnoreCase));
                List<string> loop = path.GetRange(index, path.Count - index);
                loop.Add(next);
                return string.Join(" -> ", loop);
            }
            if (state == 0)
            {
                string cycle = Visit(next, adjacency, color, path);
                if (cycle != null) { return cycle; }
            }
        }
        path.RemoveAt(path.Count - 1);
        color[node] = 2;
        return null;
    }
}
