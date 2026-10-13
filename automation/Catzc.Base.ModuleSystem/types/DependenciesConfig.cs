// The declared (ALLOWED) module dependency graph, configs/dependencies.yml
// ([ADR-AUTO-DEPM](/docs/adr/automation/controlling-module-dependencies.md)). Constructing an instance MAPS and
// VALIDATES the parsed YAML, collecting every violation into one throw. Registered in
// Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.ModuleSystem.DependenciesConfig), so
// Get-Config -Config dependencies returns this typed model. Mirrors the YAML mapping (snake_case keys,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Load-time rules are self-contained — this one file only, no filesystem reads (a declared module that is missing
// on disk is a Test-ModuleDependency finding, not load's):
//   - only the top-level keys 'groups' (optional map of ModuleGroup) and 'modules' (required map);
//   - every group is well-formed (ModuleGroup: closed, no self-dependency, acyclic);
//   - each module maps to a list of names (not a single string), never itself, and each target is a declared
//     module OR a declared group, so the declared graph is closed;
//   - the module graph (edges between declared modules) is acyclic — the first cycle found is reported.
// A module absent from `modules:` is unconstrained. Names match case-insensitively, like the PowerShell ordered
// dictionary the YAML parses into, so a name declared twice in different case is a violation.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Catzc.Base.ModuleSystem;

public sealed class DependenciesConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "module dependency configuration validation failed:\n";

    // Group name -> ModuleGroup, in declaration order; read-only (empty when the file declares no groups).
    public OrderedDictionary groups { get; }

    // Consumer module -> the names it may depend on (string[]: each a group or a module), in declaration
    // order; read-only.
    public OrderedDictionary modules { get; }

    public DependenciesConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the configuration must be a mapping"); }

        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "groups" && key != "modules")
            {
                errors.Add(string.Format("unknown top-level key '{0}' (allowed: groups, modules)", key));
            }
        }

        // --- groups: each a ModuleGroup (shape, closed-within-group, no internal cycle) ---------------------
        OrderedDictionary groupMap = new OrderedDictionary(StringComparer.OrdinalIgnoreCase);
        object groupsRaw = raw.Contains("groups") ? raw["groups"] : null;
        if (groupsRaw != null && !(groupsRaw is IDictionary)) { errors.Add("'groups' must be a map of group name -> member map"); }
        IDictionary groupSource = groupsRaw as IDictionary;
        if (groupSource != null)
        {
            foreach (object k in groupSource.Keys)
            {
                string groupName = k == null ? "" : k.ToString();
                if (groupMap.Contains(groupName))
                {
                    errors.Add(string.Format("group '{0}' is declared twice", groupName));
                    continue;
                }
                try { groupMap.Add(groupName, new ModuleGroup(groupName, groupSource[k])); }
                catch (ArgumentException ex) { errors.Add(ex.Message); groupMap.Add(groupName, null); }
            }
        }

        // --- modules: shape, self-dependency, target-is-declared (module or group) --------------------------
        OrderedDictionary moduleMap = new OrderedDictionary(StringComparer.OrdinalIgnoreCase);
        if (!raw.Contains("modules") || raw["modules"] == null)
        {
            errors.Add("Missing required top-level key: 'modules'");
        }
        else if (!(raw["modules"] is IDictionary))
        {
            errors.Add("'modules' must be a map of module name -> list of names");
        }
        else
        {
            IDictionary moduleSource = (IDictionary)raw["modules"];
            foreach (object k in moduleSource.Keys)
            {
                string module = k == null ? "" : k.ToString();
                string[] dependencies = DependencyGraph.ReadNames(moduleSource[k], string.Format("module '{0}'", module), "names", errors);
                if (moduleMap.Contains(module))
                {
                    errors.Add(string.Format("module '{0}' is declared twice", module));
                    continue;
                }
                moduleMap.Add(module, dependencies);
            }

            foreach (DictionaryEntry entry in moduleMap)
            {
                string module = (string)entry.Key;
                foreach (string target in (string[])entry.Value)
                {
                    if (string.Equals(target, module, StringComparison.OrdinalIgnoreCase))
                    {
                        errors.Add(string.Format("module '{0}' declares a dependency on itself", module));
                    }
                    else if (!moduleMap.Contains(target) && !groupMap.Contains(target))
                    {
                        errors.Add(string.Format(
                            "module '{0}' depends on '{1}', which is not declared in configuration (add a '{1}' module or group entry so it exists in configuration)",
                            module, target));
                    }
                }
            }

            // Acyclic over declared MODULE edges only (targets that are themselves declared modules, never a
            // group or self). Group references are a lower layer and cannot form a module-level cycle.
            OrderedDictionary adjacency = new OrderedDictionary(StringComparer.OrdinalIgnoreCase);
            foreach (DictionaryEntry entry in moduleMap)
            {
                List<string> declared = new List<string>();
                foreach (string target in (string[])entry.Value)
                {
                    if (moduleMap.Contains(target) && !string.Equals(target, (string)entry.Key, StringComparison.OrdinalIgnoreCase)) { declared.Add(target); }
                }
                adjacency.Add(entry.Key, declared.ToArray());
            }
            string cycle = DependencyGraph.FindCycle(adjacency);
            if (cycle != null) { errors.Add("dependency cycle: " + cycle); }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }

        groups = groupMap.AsReadOnly();
        modules = moduleMap.AsReadOnly();
    }
}
