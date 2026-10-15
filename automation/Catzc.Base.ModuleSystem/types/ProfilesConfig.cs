/*
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/types/ProfilesConfig.cs
    kind: type
    module: Catzc.Base.ModuleSystem
    adrs:
      - ADR-AUTO-TYPES#8
---
*/

// Module-name existence is not checked at load; that is left to Get-ModuleProfile, which expands the seed.
// [comment:1](/docs/references/automation/catzc-base-modulesystem/types/ProfilesConfig.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Text.RegularExpressions;

namespace Catzc.Base.ModuleSystem;

public sealed class ProfilesConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "profiles configuration validation failed:\n";
    private static readonly Regex SnakeCase = new Regex("^[a-z][a-z0-9_]*$");

    // Profile name -> its seed module names (string[], possibly empty), in declaration order; read-only.
    public OrderedDictionary profiles { get; }

    public ProfilesConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the configuration must be a mapping"); }

        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "profiles") { errors.Add(string.Format("unknown top-level key '{0}' (allowed: profiles)", key)); }
        }

        OrderedDictionary map = new OrderedDictionary(StringComparer.OrdinalIgnoreCase);
        if (!raw.Contains("profiles"))
        {
            errors.Add("Missing required top-level key: 'profiles'");
        }
        else
        {
            IDictionary source = raw["profiles"] as IDictionary;
            if (source == null || source.Count == 0)
            {
                errors.Add("'profiles' must be a non-empty map of <name>: [ <module>, ... ]");
            }
            else
            {
                foreach (object k in source.Keys)
                {
                    string name = k == null ? "" : k.ToString();
                    if (!SnakeCase.IsMatch(name))
                    {
                        errors.Add(string.Format("profile '{0}' is not snake_case (must match ^[a-z][a-z0-9_]*$)", name));
                    }
                    map[name] = ReadSeed(name, source[k], errors);
                }
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        profiles = map.AsReadOnly();
    }

    // A list (including empty, or a bare 'name:' with no value) is a seed; a single string or a map is not.
    private static string[] ReadSeed(string name, object value, List<string> errors)
    {
        if (value == null) { return new string[0]; }
        IList list = value as IList;
        if (list == null)
        {
            errors.Add(string.Format("profile '{0}' must be a list of module names (possibly empty), not a single value", name));
            return new string[0];
        }

        List<string> modules = new List<string>();
        foreach (object item in list)
        {
            if (item == null || item is IDictionary || item is IList || string.IsNullOrWhiteSpace(item.ToString()))
            {
                errors.Add(string.Format("profile '{0}' lists an entry that is not a module name", name));
                continue;
            }
            modules.Add(item.ToString());
        }
        return modules.ToArray();
    }
}
