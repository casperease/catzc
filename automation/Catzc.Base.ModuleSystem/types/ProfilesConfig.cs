// The named module sets of configs/profiles.yml, for Copy-Automation -ModuleProfile, Test-InIsolation and the
// exporter: each profile is a SEED list of module names that Get-ModuleProfile expands to its declared-dependency
// closure plus the fixed infrastructure; an EMPTY seed means the full repository. Constructing an instance MAPS
// and VALIDATES the parsed YAML, collecting every violation into one throw. Registered in
// Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.ModuleSystem.ProfilesConfig), so
// Get-Config -Config profiles returns this typed model. Mirrors the YAML mapping (snake_case keys,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Load-time rules:
//   - only the top-level key 'profiles', a required, non-empty map;
//   - each profile name is snake_case;
//   - each profile is a list (possibly empty) of non-empty module names — never a single string or a map.
// Module-name existence is not checked here: it is Get-ModuleProfile's concern.

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
