/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.ModuleSystem/types/DependenciesConfig.cs
    folder: types
    name: dependencies-config
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: pwsh/Catzc.Base.ModuleSystem/tests/types/DependenciesConfig.Tests.ps1
    docs: "[DependenciesConfig.cs.md](docs/references/pwsh/catzc-base-modulesystem/types/DependenciesConfig.cs.md)"
    cites:
      - ADR-AUTO-DEPM
      - ADR-AUTO-TYPES-SNAKECASEMIRRORSYAML
---
*/

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
