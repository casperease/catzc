// The config-override registry (configs/configs.yml) and its validity rules. The registry maps each
// overridden config name to exactly one validator handler; this type's only job is to enforce that shape
// at construction time, so a malformed registry can never produce an instance.
//
// The data model it guards: under the top-level `configs` map, each entry binds a config name to either a
// `type` (a C# type FQN) XOR a `pwsh` (a validator function name) — never both, never neither. An absent
// or empty `configs` map is valid, because overrides are opt-in. (An optional `module` pins the owning
// module when a `pwsh` name is ambiguous; it is not part of the type-vs-pwsh exclusivity rule.)

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Config;

public sealed class ConfigsConfig
{
    public ConfigsConfig(IDictionary registry)
    {
        if (registry == null || !registry.Contains("configs")) { return; }
        var entries = registry["configs"] as IDictionary;
        if (entries == null) { return; }

        var errors = new List<string>();
        foreach (var key in entries.Keys)
        {
            var name = key == null ? string.Empty : key.ToString();
            var entry = entries[key] as IDictionary;
            bool hasType = entry != null && entry.Contains("type") && !IsBlank(entry["type"]);
            bool hasPwsh = entry != null && entry.Contains("pwsh") && !IsBlank(entry["pwsh"]);

            if (hasType && hasPwsh)
            {
                errors.Add(string.Format("config '{0}': specify 'type' OR 'pwsh', not both", name));
            }
            else if (!hasType && !hasPwsh)
            {
                errors.Add(string.Format("config '{0}': an override entry must specify a 'type' or a 'pwsh' validator", name));
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("config registry validation failed:\n" + string.Join("\n", errors));
        }
    }

    private static bool IsBlank(object value)
    {
        return value == null || string.IsNullOrWhiteSpace(value.ToString());
    }
}
