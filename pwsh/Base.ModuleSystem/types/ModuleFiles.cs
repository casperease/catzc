/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-module-system/types/ModuleFiles.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Text.RegularExpressions;

namespace Catzc.Base.ModuleSystem;

// One module's files.yml entry: the named packages of root-relative file artifacts the module owns.
public sealed class ModuleFiles : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly Regex SnakeCase = new Regex("^[a-z][a-z0-9_]*$");

    // Package name -> its repository-root-relative paths (string[]), in declaration order; read-only.
    public OrderedDictionary packages { get; }

    public ModuleFiles(string moduleName, object raw)
    {
        List<string> errors = new List<string>();
        OrderedDictionary map = new OrderedDictionary(StringComparer.OrdinalIgnoreCase);

        IDictionary entry = raw as IDictionary;
        if (entry == null || !entry.Contains("packages"))
        {
            errors.Add(string.Format("module '{0}' must be a map with a 'packages' key", moduleName));
        }
        else
        {
            foreach (object k in entry.Keys)
            {
                string key = k == null ? null : k.ToString();
                if (key != "packages") { errors.Add(string.Format("module '{0}' has unknown key '{1}' (allowed: packages)", moduleName, key)); }
            }

            IDictionary source = entry["packages"] as IDictionary;
            if (source == null || source.Count == 0)
            {
                errors.Add(string.Format("module '{0}' 'packages' must be a non-empty map", moduleName));
            }
            else
            {
                foreach (object pk in source.Keys)
                {
                    string packageName = pk == null ? "" : pk.ToString();
                    if (!SnakeCase.IsMatch(packageName))
                    {
                        errors.Add(string.Format("package '{0}' (module '{1}') must be snake_case", packageName, moduleName));
                    }
                    map[packageName] = ReadPaths(packageName, source[pk], errors);
                }
            }
        }

        packages = map.AsReadOnly();
        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
    }

    private static string[] ReadPaths(string packageName, object value, List<string> errors)
    {
        IList list = value as IList;
        if (value is string || list == null || list.Count == 0)
        {
            errors.Add(string.Format("package '{0}' must be a non-empty list of paths", packageName));
            return new string[0];
        }

        List<string> paths = new List<string>();
        foreach (object item in list)
        {
            string path = item == null ? "" : item.ToString();
            if (string.IsNullOrWhiteSpace(path))
            {
                errors.Add(string.Format("package '{0}' has an empty path entry", packageName));
                continue;
            }
            if (path.Contains("\\") || path.StartsWith("/") || path.Contains(":") || Array.IndexOf(path.Split('/'), "..") >= 0)
            {
                errors.Add(string.Format(
                    "package '{0}' path '{1}' must be repository-root-relative and forward-slashed (no '\\', no leading '/', no ':', no '..')",
                    packageName, path));
            }
            paths.Add(path);
        }
        return paths.ToArray();
    }
}
