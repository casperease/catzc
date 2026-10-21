/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.VSCode/types/VscodeSettingsConfig.cs
    folder: types
    name: vscode-settings-config
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: pwsh/Catzc.Base.VSCode/tests/types/VscodeSettingsConfig.Tests.ps1
    docs: "[VscodeSettingsConfig.cs.md](docs/references/pwsh/catzc-base-vscode/types/VscodeSettingsConfig.cs.md)"
    cites:
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
      - ADR-REPO-ROOTCFG
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Catzc.Base.VSCode;

public sealed class VscodeSettingsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "vscode-settings config validation failed:\n";

    // Every VS Code setting key -> its value, in authored order — what settings.json receives; read-only.
    public OrderedDictionary settings { get; }

    public VscodeSettingsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the registry must be a mapping"); }

        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "settings") { errors.Add(string.Format("unknown top-level key '{0}' (allowed: settings)", key)); }
        }

        OrderedDictionary map = new OrderedDictionary(StringComparer.OrdinalIgnoreCase);
        IDictionary source = raw.Contains("settings") ? raw["settings"] as IDictionary : null;
        if (source == null || source.Count == 0)
        {
            errors.Add("'settings' must be a non-empty map of VS Code setting keys");
        }
        else
        {
            foreach (object k in source.Keys)
            {
                string key = k == null ? "" : k.ToString();
                object value = source[k];
                if (key.StartsWith("[") && key.EndsWith("]") && !(value is IDictionary))
                {
                    errors.Add(string.Format("language override '{0}' must be a map of settings", key));
                }
                if (key == "search.exclude") { CheckExclude(value, errors); }
                map[key] = value;
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        settings = map.AsReadOnly();
    }

    private static void CheckExclude(object value, List<string> errors)
    {
        IDictionary exclude = value as IDictionary;
        if (exclude == null)
        {
            errors.Add("'search.exclude' must be a map of glob -> true/false");
            return;
        }
        foreach (object k in exclude.Keys)
        {
            if (!(exclude[k] is bool))
            {
                errors.Add(string.Format("'search.exclude' entry '{0}' must be true or false", k));
            }
        }
    }
}
