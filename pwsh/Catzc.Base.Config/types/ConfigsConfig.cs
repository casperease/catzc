/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-config/types/ConfigsConfig.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace Catzc.Base.Config;

// The registry's shape is enforced at construction, so a malformed registry can never yield an instance for any config to resolve through.
public sealed class ConfigsConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly IReadOnlyDictionary<string, string> Empty =
        new ReadOnlyDictionary<string, string>(new Dictionary<string, string>());

    public IReadOnlyDictionary<string, string> configs { get; } = Empty;

    // The configs a consumer overlay may not change (registered with overridable: false), in file order.
    public IReadOnlyList<string> sealedConfigs { get; } = Array.Empty<string>();

    // Per config, the top-level keys whose shipped value may differ from the type's default, each with its one-sentence reason.
    public IReadOnlyDictionary<string, IReadOnlyDictionary<string, string>> differs { get; } =
        new ReadOnlyDictionary<string, IReadOnlyDictionary<string, string>>(new Dictionary<string, IReadOnlyDictionary<string, string>>());

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
        var reasons = new Dictionary<string, IReadOnlyDictionary<string, string>>(StringComparer.Ordinal);
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
                if (keyName != "type" && keyName != "overridable" && keyName != "differs")
                {
                    errors.Add(string.Format("config '{0}': unknown key '{1}' (allowed: type, overridable, differs)", name, keyName));
                }
            }
            if (entry.Contains("differs") && entry["differs"] != null)
            {
                var map = entry["differs"] as IDictionary;
                var keyReasons = new Dictionary<string, string>(StringComparer.Ordinal);
                if (map == null)
                {
                    errors.Add(string.Format("config '{0}': differs must be a map of key -> the reason its shipped value differs from the type's default", name));
                }
                else
                {
                    foreach (DictionaryEntry reason in map)
                    {
                        var differing = reason.Key == null ? string.Empty : reason.Key.ToString();
                        if (IsBlank(reason.Value))
                        {
                            errors.Add(string.Format("config '{0}': differs '{1}' needs its reason, one sentence", name, differing));
                            continue;
                        }
                        keyReasons[differing] = reason.Value.ToString().Trim();
                    }
                }
                reasons[name] = new ReadOnlyDictionary<string, string>(keyReasons);
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
        differs = new ReadOnlyDictionary<string, IReadOnlyDictionary<string, string>>(reasons);
    }

    private static bool IsBlank(object value)
    {
        return value == null || string.IsNullOrWhiteSpace(value.ToString());
    }
}
