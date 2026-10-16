/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.ModuleSystem/types/ArtifactsTarget.cs
    folder: types
    name: artifacts-target
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-modulesystem/types/ArtifactsTarget.cs.md
    cites:
      - ADR-AUTO-TYPES#8
---
*/

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.ModuleSystem;

public abstract class ArtifactsTarget : Catzc.Base.Objects.DictionaryRecord
{
    private readonly IDictionary entry;

    // Whether the build publishes to this target.
    public bool enabled { get; }

    protected ArtifactsTarget(string target, object raw, string[] coordinateKeys)
    {
        entry = raw as IDictionary;
        if (entry == null) { throw new ArgumentException(string.Format("'{0}' must be a mapping", target)); }

        List<string> errors = new List<string>();
        List<string> allowed = new List<string> { "enabled" };
        allowed.AddRange(coordinateKeys);
        foreach (object k in entry.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (!allowed.Contains(key))
            {
                errors.Add(string.Format("'{0}' has unknown key '{1}' (allowed: {2})", target, key, string.Join(", ", allowed)));
            }
        }
        foreach (string key in allowed)
        {
            if (!entry.Contains(key)) { errors.Add(string.Format("'{0}' is missing required key '{1}'", target, key)); }
        }

        object flag = entry.Contains("enabled") ? entry["enabled"] : null;
        if (flag is bool) { enabled = (bool)flag; }
        else if (entry.Contains("enabled")) { errors.Add(string.Format("'{0}.enabled' must be true or false", target)); }

        foreach (string key in coordinateKeys)
        {
            if (!entry.Contains(key)) { continue; }
            object value = entry[key];
            if (value != null && !(value is string))
            {
                errors.Add(string.Format("'{0}.{1}' must be a string", target, key));
            }
            else if (enabled && string.IsNullOrWhiteSpace((string)value))
            {
                errors.Add(string.Format("'{0}.{1}' must be non-empty while '{0}' is enabled", target, key));
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
    }

    // A coordinate's validated value ('' when the YAML leaves it empty).
    protected string Coordinate(string key)
    {
        object value = entry[key];
        return value == null ? "" : (string)value;
    }
}
