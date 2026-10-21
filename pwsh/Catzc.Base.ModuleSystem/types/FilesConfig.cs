/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.ModuleSystem/types/FilesConfig.cs
    folder: types
    name: files-config
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: pwsh/Catzc.Base.ModuleSystem/tests/types/FilesConfig.Tests.ps1
    docs: "[FilesConfig.cs.md](docs/references/pwsh/catzc-base-modulesystem/types/FilesConfig.cs.md)"
    cites:
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
---
*/

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
