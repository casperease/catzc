// The module -> packages bindings of configs/files.yml, for Copy-Automation: per module, the named packages of
// repository-root-relative file artifacts it owns beyond its own folder. Constructing an instance MAPS and
// VALIDATES the parsed YAML, collecting every violation into one throw. Registered in
// Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.ModuleSystem.FilesConfig), so
// Get-Config -Config files returns this typed model. Mirrors the YAML mapping (snake_case keys,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Load-time rules:
//   - only the top-level key 'modules', a required, non-empty map;
//   - every module entry is well-formed (ModuleFiles);
//   - each package name is globally unique across all modules (it is the -ExcludePackages unit).
// Module keys are module folder names ('Catzc.Base.Repository', '.internal'), so they are not snake_case-checked.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Catzc.Base.ModuleSystem;

public sealed class FilesConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "files configuration validation failed:\n";

    // Module folder name -> ModuleFiles, in declaration order; read-only.
    public OrderedDictionary modules { get; }

    public FilesConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the configuration must be a mapping"); }

        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "modules") { errors.Add(string.Format("unknown top-level key '{0}' (allowed: modules)", key)); }
        }

        OrderedDictionary map = new OrderedDictionary(StringComparer.OrdinalIgnoreCase);
        if (!raw.Contains("modules"))
        {
            errors.Add("Missing required top-level key: 'modules'");
        }
        else
        {
            IDictionary source = raw["modules"] as IDictionary;
            if (source == null || source.Count == 0)
            {
                errors.Add("'modules' must be a non-empty map of <module>: { packages: ... }");
            }
            else
            {
                Dictionary<string, string> packageOwner = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
                foreach (object k in source.Keys)
                {
                    string moduleName = k == null ? "" : k.ToString();
                    ModuleFiles entry;
                    try { entry = new ModuleFiles(moduleName, source[k]); }
                    catch (ArgumentException ex) { errors.Add(ex.Message); continue; }
                    map[moduleName] = entry;

                    foreach (object pk in entry.packages.Keys)
                    {
                        string packageName = pk.ToString();
                        string owner;
                        if (packageOwner.TryGetValue(packageName, out owner))
                        {
                            errors.Add(string.Format("duplicate package name '{0}' (in '{1}' and '{2}')", packageName, moduleName, owner));
                        }
                        else { packageOwner[packageName] = moduleName; }
                    }
                }
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        modules = map.AsReadOnly();
    }
}
