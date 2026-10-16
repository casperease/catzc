/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.VSCode/types/VscodeExtensionsConfig.cs
    folder: types
    name: vscode-extensions-config
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-vscode/types/VscodeExtensionsConfig.cs.md
    test: automation/Catzc.Base.VSCode/tests/types/VscodeExtensionsConfig.Tests.ps1
    cites:
      - ADR-AUTO-TYPES#8
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

    public VscodeExtensionsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the registry must be a mapping"); }

        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "recommendations") { errors.Add(string.Format("unknown top-level key '{0}' (allowed: recommendations)", key)); }
        }

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
