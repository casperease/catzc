/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Config/types/ConfigsConfig.cs
    folder: types
    name: configs-config
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.Config
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-config/types/ConfigsConfig.cs.md
    adrs:
      - ADR-AUTO-OVERLAY
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace Catzc.Base.Config;

public sealed class ConfigsConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly IReadOnlyDictionary<string, string> Empty =
        new ReadOnlyDictionary<string, string>(new Dictionary<string, string>());

    public IReadOnlyDictionary<string, string> configs { get; } = Empty;

    // The configs a consumer overlay may not change (registered with overridable: false), in file order.
    public IReadOnlyList<string> sealedConfigs { get; } = Array.Empty<string>();

    public ConfigsConfig(IDictionary registry)
    {
        if (registry == null) { return; }

        var errors = new List<string>();
        foreach (var key in registry.Keys)
        {
            var topKey = key == null ? string.Empty : key.ToString();
            if (topKey != "configs")
            {
                errors.Add(string.Format("unknown top-level key '{0}' (allowed: configs)", topKey));
            }
        }

        var entries = registry.Contains("configs") ? registry["configs"] as IDictionary : null;
        var types = new Dictionary<string, string>(StringComparer.Ordinal);
        var sealedNames = new List<string>();
        if (entries == null)
        {
            if (registry.Contains("configs") && registry["configs"] != null)
            {
                errors.Add("'configs' must be a map of config name -> { type }");
            }
            entries = new Hashtable();
        }

        foreach (var key in entries.Keys)
        {
            var name = key == null ? string.Empty : key.ToString();
            var entry = entries[key] as IDictionary;
            if (entry == null || !entry.Contains("type") || IsBlank(entry["type"]))
            {
                errors.Add(string.Format("config '{0}': an entry must specify a 'type' (a C# type FQN)", name));
                continue;
            }

            foreach (var entryKey in entry.Keys)
            {
                var keyName = entryKey == null ? string.Empty : entryKey.ToString();
                if (keyName != "type" && keyName != "overridable")
                {
                    errors.Add(string.Format("config '{0}': unknown key '{1}' (allowed: type, overridable)", name, keyName));
                }
            }
            types[name] = entry["type"].ToString().Trim();
            if (entry.Contains("overridable"))
            {
                if (!(entry["overridable"] is bool))
                {
                    errors.Add(string.Format("config '{0}': overridable must be true or false", name));
                }
                else if (!(bool)entry["overridable"])
                {
                    sealedNames.Add(name);
                }
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("config registry validation failed:\n" + string.Join("\n", errors));
        }

        configs = new ReadOnlyDictionary<string, string>(types);
        sealedConfigs = sealedNames;
    }

    private static bool IsBlank(object value)
    {
        return value == null || string.IsNullOrWhiteSpace(value.ToString());
    }
}
