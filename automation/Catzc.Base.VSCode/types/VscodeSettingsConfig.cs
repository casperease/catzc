// The VS Code workspace-settings registry, configs/vscode-settings.yml — the single authored source that
// New-VSCodeSettings renders to the managed .vscode/settings.json
// ([ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)). The settings are VS Code's own keys (dotted,
// camelCase — 'markdown.preview.fontSize', '[powershell]'), data passed through to the editor as-is, so the type
// keeps them as an ordered passthrough map (`settings`) rather than typing each key. Constructing an instance MAPS
// and VALIDATES the parsed YAML, collecting every violation into one throw. Registered in
// Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.VSCode.VscodeSettingsConfig), so
// Get-Config -Config vscode-settings returns this typed model. Mirrors the YAML mapping (snake_case keys,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Load-time rules:
//   - only the top-level key 'settings', a required, non-empty map;
//   - a language-override key ('[markdown]') maps to a map of that language's settings, as VS Code requires;
//   - 'search.exclude', when authored, is a map of glob -> true/false — the map New-VSCodeSettings completes with
//     the managed root-config targets (an authored false un-excludes past a broader glob).

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
