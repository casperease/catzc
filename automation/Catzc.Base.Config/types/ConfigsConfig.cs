// The config registry (configs/configs.yml) and its validity rules. The registry binds each shipped config
// name to the C# config type Get-Config constructs it as; this type's only job is to enforce that shape at
// construction time, so a malformed registry can never produce an instance.
//
// The data model it guards: under the top-level `configs` map, each entry is a map holding exactly one key,
// `type` (a non-blank C# type FQN); `configs` is the only top-level key. An absent or empty `configs` map is
// valid. `configs` exposes the registry as config name -> type FQN, in file order.

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
                if (keyName != "type")
                {
                    errors.Add(string.Format("config '{0}': unknown key '{1}' (allowed: type)", name, keyName));
                }
            }
            types[name] = entry["type"].ToString().Trim();
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("config registry validation failed:\n" + string.Join("\n", errors));
        }

        configs = new ReadOnlyDictionary<string, string>(types);
    }

    private static bool IsBlank(object value)
    {
        return value == null || string.IsNullOrWhiteSpace(value.ToString());
    }
}
