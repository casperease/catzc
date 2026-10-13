// One declared module group of configs/dependencies.yml (`groups: <name>: <member>: [members]`): a named set of
// on-disk modules with its own internal member -> member DAG — a concept, not a disk module
// ([ADR-AUTO-DEPM#3](/docs/adr/automation/controlling-module-dependencies.md#rule-adr-auto-depm3)). Constructing
// one MAPS and VALIDATES the group's member map, collecting every violation into one throw:
//   - the group maps to a map of member modules (not a list or string);
//   - each member maps to a list of member names (not a single string);
//   - no member depends on itself, and every dependency is a member of the SAME group (the group is closed);
//   - the internal member graph is acyclic.
// Members are matched case-insensitively, like the PowerShell ordered dictionary the YAML parses into.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Catzc.Base.ModuleSystem;

public sealed class ModuleGroup
{
    // The group's name (its key under `groups:`).
    public string name { get; }

    // Member module -> the members it may depend on (string[]), in declaration order; read-only.
    public OrderedDictionary members { get; }

    public ModuleGroup(string groupName, object raw)
    {
        name = groupName;
        List<string> errors = new List<string>();
        OrderedDictionary map = new OrderedDictionary(StringComparer.OrdinalIgnoreCase);

        IDictionary source = raw as IDictionary;
        if (source == null)
        {
            errors.Add(string.Format("group '{0}' must map to a map of member modules, not a list or string", groupName));
        }
        else
        {
            foreach (object k in source.Keys)
            {
                string member = k == null ? "" : k.ToString();
                string owner = string.Format("group '{0}' member '{1}'", groupName, member);
                string[] dependencies = DependencyGraph.ReadNames(source[k], owner, "member modules", errors);
                if (map.Contains(member))
                {
                    errors.Add(string.Format("{0} is declared twice", owner));
                    continue;
                }
                map.Add(member, dependencies);
            }

            foreach (DictionaryEntry entry in map)
            {
                string member = (string)entry.Key;
                foreach (string target in (string[])entry.Value)
                {
                    if (string.Equals(target, member, StringComparison.OrdinalIgnoreCase))
                    {
                        errors.Add(string.Format("group '{0}' member '{1}' declares a dependency on itself", groupName, member));
                    }
                    else if (!map.Contains(target))
                    {
                        errors.Add(string.Format("group '{0}' member '{1}' depends on '{2}', which is not a member of group '{0}'", groupName, member, target));
                    }
                }
            }

            OrderedDictionary adjacency = new OrderedDictionary(StringComparer.OrdinalIgnoreCase);
            foreach (DictionaryEntry entry in map)
            {
                List<string> inside = new List<string>();
                foreach (string target in (string[])entry.Value)
                {
                    if (map.Contains(target) && !string.Equals(target, (string)entry.Key, StringComparison.OrdinalIgnoreCase)) { inside.Add(target); }
                }
                adjacency.Add(entry.Key, inside.ToArray());
            }
            string cycle = DependencyGraph.FindCycle(adjacency);
            if (cycle != null) { errors.Add(string.Format("group '{0}' dependency cycle: {1}", groupName, cycle)); }
        }

        members = map.AsReadOnly();
        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
    }
}
