// The config registry (configs/configs.yml) and its validity rules. The registry binds each shipped config
// name to the C# config type Get-Config constructs it as; this type's only job is to enforce that shape at
// construction time, so a malformed registry can never produce an instance.
//
// The data model it guards: under the top-level `configs` map, each entry is a map holding `type` (a non-blank
// C# type FQN) and, optionally, `overridable` (a boolean; absent means true); `configs` is the only top-level
// key. An absent or empty `configs` map is valid. `configs` exposes the registry as config name -> type FQN, in
// file order; `sealedConfigs` names the entries a consumer overlay may not change (overridable: false — the
// engine-intrinsic configs, [ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)).

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
