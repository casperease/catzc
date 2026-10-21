/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.VSCode/types/VscodeLaunchConfig.cs
    folder: types
    name: vscode-launch-config
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: pwsh/Catzc.Base.VSCode/tests/types/VscodeLaunchConfig.Tests.ps1
    docs: "[VscodeLaunchConfig.cs.md](docs/references/pwsh/catzc-base-vscode/types/VscodeLaunchConfig.cs.md)"
    cites:
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
      - ADR-REPO-ROOTCFG
---
*/

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.VSCode;

public sealed class VscodeLaunchConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "vscode-launch config validation failed:\n";

    // The VS Code launch schema version.
    public string version { get; }

    // The launch profiles, in registry order.
    public IReadOnlyList<VscodeLaunchProfile> configurations { get; }

    public VscodeLaunchConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the registry must be a mapping"); }

        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "version" && key != "configurations")
            {
                errors.Add(string.Format("unknown top-level key '{0}' (allowed: version, configurations)", key));
            }
        }

        version = raw.Contains("version") ? raw["version"] as string : null;
        if (string.IsNullOrWhiteSpace(version))
        {
            errors.Add("'version' must be a non-empty string (VS Code launch schema version, e.g. '0.2.0')");
        }

        // An absent key and an empty (null) value are both an empty list; a single mapping is a one-item list.
        List<object> items = new List<object>();
        object value = raw.Contains("configurations") ? raw["configurations"] : null;
        if (value is IDictionary || value is string || (value != null && !(value is IEnumerable))) { items.Add(value); }
        else if (value != null) { foreach (object item in (IEnumerable)value) { items.Add(item); } }
        if (items.Count == 0) { errors.Add("'configurations' must be a non-empty list of launch profiles"); }

        List<VscodeLaunchProfile> profiles = new List<VscodeLaunchProfile>();
        HashSet<string> seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        foreach (object item in items)
        {
            VscodeLaunchProfile profile;
            try { profile = new VscodeLaunchProfile(item); }
            catch (ArgumentException ex)
            {
                errors.Add(ex.Message);
                IDictionary entry = item as IDictionary;
                string partialName = entry != null && entry.Contains("name") ? entry["name"] as string : null;
                if (!string.IsNullOrWhiteSpace(partialName) && !seen.Add(partialName))
                {
                    errors.Add(string.Format("duplicate configuration name '{0}'", partialName));
                }
                continue;
            }
            if (!seen.Add(profile.name)) { errors.Add(string.Format("duplicate configuration name '{0}'", profile.name)); }
            profiles.Add(profile);
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        configurations = profiles.AsReadOnly();
    }
}
