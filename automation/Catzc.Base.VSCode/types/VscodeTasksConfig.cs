/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.VSCode/types/VscodeTasksConfig.cs
    folder: types
    name: vscode-tasks-config
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-vscode/types/VscodeTasksConfig.cs.md
    test: automation/Catzc.Base.VSCode/tests/types/VscodeTasksConfig.Tests.ps1
    cites:
      - ADR-AUTO-TYPES#8
      - ADR-REPO-ROOTCFG
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Catzc.Base.VSCode;

public sealed class VscodeTasksConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "vscode-tasks config validation failed:\n";

    // The VS Code tasks schema version.
    public string version { get; }

    // Every task, each a read-only map of its keys in authored order, in registry order.
    public IReadOnlyList<OrderedDictionary> tasks { get; }

    // The prompt inputs the tasks refer to as ${input:id}, in registry order; empty when none.
    public IReadOnlyList<OrderedDictionary> inputs { get; }

    public VscodeTasksConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the registry must be a mapping"); }

        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "version" && key != "tasks" && key != "inputs")
            {
                errors.Add(string.Format("unknown top-level key '{0}' (allowed: version, tasks, inputs)", key));
            }
        }

        version = raw.Contains("version") ? raw["version"] as string : null;
        if (string.IsNullOrWhiteSpace(version))
        {
            errors.Add("'version' must be a non-empty string (VS Code tasks schema version, e.g. '2.0.0')");
        }

        // An absent key and an empty (null) value are both an empty list; a single mapping is a one-item list.
        List<object> items = new List<object>();
        object value = raw.Contains("tasks") ? raw["tasks"] : null;
        if (value is IDictionary || value is string || (value != null && !(value is IEnumerable))) { items.Add(value); }
        else if (value != null) { foreach (object item in (IEnumerable)value) { items.Add(item); } }
        if (items.Count == 0) { errors.Add("'tasks' must be a non-empty list of tasks"); }

        List<OrderedDictionary> entries = new List<OrderedDictionary>();
        HashSet<string> seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        foreach (object item in items)
        {
            IDictionary entry = item as IDictionary;
            if (entry == null) { errors.Add("each tasks entry must be a mapping"); continue; }

            string label = entry.Contains("label") ? entry["label"] as string : null;
            if (string.IsNullOrWhiteSpace(label)) { errors.Add("a tasks entry is missing a non-empty 'label'"); }
            else if (!seen.Add(label)) { errors.Add(string.Format("duplicate task label '{0}'", label)); }

            OrderedDictionary map = new OrderedDictionary(StringComparer.OrdinalIgnoreCase);
            foreach (object k in entry.Keys) { map[k == null ? "" : k.ToString()] = entry[k]; }
            entries.Add(map.AsReadOnly());
        }

        List<OrderedDictionary> inputEntries = new List<OrderedDictionary>();
        HashSet<string> seenIds = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        object inputValue = raw.Contains("inputs") ? raw["inputs"] : null;
        List<object> inputItems = new List<object>();
        if (inputValue is IDictionary || inputValue is string || (inputValue != null && !(inputValue is IEnumerable))) { inputItems.Add(inputValue); }
        else if (inputValue != null) { foreach (object item in (IEnumerable)inputValue) { inputItems.Add(item); } }
        foreach (object item in inputItems)
        {
            IDictionary entry = item as IDictionary;
            if (entry == null) { errors.Add("each inputs entry must be a mapping"); continue; }

            string id = entry.Contains("id") ? entry["id"] as string : null;
            if (string.IsNullOrWhiteSpace(id)) { errors.Add("an inputs entry is missing a non-empty 'id'"); }
            else if (!seenIds.Add(id)) { errors.Add(string.Format("duplicate input id '{0}'", id)); }

            OrderedDictionary map = new OrderedDictionary(StringComparer.OrdinalIgnoreCase);
            foreach (object k in entry.Keys) { map[k == null ? "" : k.ToString()] = entry[k]; }
            inputEntries.Add(map.AsReadOnly());
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        tasks = entries.AsReadOnly();
        inputs = inputEntries.AsReadOnly();
    }
}
