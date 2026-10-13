// The graph helpers behind the declared module dependency graph (configs/dependencies.yml): reading one
// node's dependency list from the parsed YAML, and finding a cycle in a node -> dependencies adjacency map.
// Shared by DependenciesConfig (the module graph) and ModuleGroup (each group's internal member graph), so
// both graphs read and cycle-check the same way
// ([ADR-AUTO-DEPM#4](/docs/adr/automation/controlling-module-dependencies.md#rule-adr-auto-depm4)).

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Catzc.Base.ModuleSystem;

public static class DependencyGraph
{
    // Reads one node's dependency list: null (declared, depends on nothing) is empty; a list of non-empty
    // names is the list; a single string, a map, or a non-name item is a violation ('owner' prefixes it, and
    // 'what' names the expected entries, e.g. "names" or "member modules").
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

    // The first cycle (as "A -> B -> A") in a node -> string[] adjacency, visiting nodes and edges in
    // declaration order; null when the graph is acyclic. Edges to nodes outside the map are ignored.
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
