/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs
    folder: types
    name: vscode-extensions-config
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: pwsh/Catzc.Base.VSCode/tests/types/VscodeExtensionsConfig.Tests.ps1
    docs: "[VscodeExtensionsConfig.cs.md](docs/references/pwsh/catzc-base-vscode/types/VscodeExtensionsConfig.cs.md)"
    cites:
      - ADR-AUTO-TYPES-SNAKECASEMIRRORSYAML
      - ADR-REPO-ROOTCFG
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.VSCode;

public sealed class VscodeExtensionsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "vscode-extensions config validation failed:\n";
    private static readonly Regex ExtensionId = new Regex(@"^[A-Za-z0-9][\w-]*\.[A-Za-z0-9][\w-]*$");

    // The recommended extension ids, in registry order.
    public string[] recommendations { get; }

    // The repository's own extensions, in registry order; New-VSCodeExtensionFolder renders each one.
    public IReadOnlyList<VscodeOwnExtension> extensions { get; }

    public VscodeExtensionsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the registry must be a mapping"); }

        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "recommendations" && key != "extensions") { errors.Add(string.Format("unknown top-level key '{0}' (allowed: recommendations, extensions)", key)); }
        }

        List<VscodeOwnExtension> own = new List<VscodeOwnExtension>();
        object block = raw.Contains("extensions") ? raw["extensions"] : null;
        if (block is IDictionary)
        {
            foreach (DictionaryEntry pair in (IDictionary)block)
            {
                try { own.Add(new VscodeOwnExtension(pair.Key == null ? null : pair.Key.ToString(), pair.Value)); }
                catch (ArgumentException ex) { errors.Add(ex.Message); }
            }
        }
        else if (block != null) { errors.Add("'extensions' must be a mapping of extension name to its manifest"); }
        extensions = own.AsReadOnly();

        // An absent key and an empty (null) value are both an empty list; a single scalar is a one-item list.
        List<object> items = new List<object>();
        object value = raw.Contains("recommendations") ? raw["recommendations"] : null;
        if (value is string || (value != null && !(value is IEnumerable))) { items.Add(value); }
        else if (value is IDictionary) { items.Add(value); }
        else if (value != null) { foreach (object item in (IEnumerable)value) { items.Add(item); } }
        if (items.Count == 0) { errors.Add("'recommendations' must be a non-empty list of extension ids"); }

        List<string> ids = new List<string>();
        HashSet<string> seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        foreach (object item in items)
        {
            string id = item as string;
            if (id == null || !ExtensionId.IsMatch(id))
            {
                errors.Add(string.Format("'{0}' is not a publisher.name extension id", item));
                continue;
            }
            if (!seen.Add(id))
            {
                errors.Add(string.Format("duplicate recommendation '{0}'", id));
                continue;
            }
            ids.Add(id);
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        recommendations = ids.ToArray();
    }
}
