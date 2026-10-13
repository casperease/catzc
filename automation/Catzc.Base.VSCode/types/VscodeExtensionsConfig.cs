// The VS Code extension-recommendation registry, configs/vscode-extensions.yml — the single authored source that
// New-VSCodeExtensions renders to the managed .vscode/extensions.json
// ([ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)). Constructing an instance MAPS and VALIDATES
// the parsed YAML, collecting every violation into one throw. Registered in Catzc.Base.Config/configs/configs.yml
// (type: Catzc.Base.VSCode.VscodeExtensionsConfig), so Get-Config -Config vscode-extensions returns this typed
// model. Mirrors the YAML mapping (snake_case keys,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Load-time rules:
//   - only the top-level key 'recommendations', a non-empty list;
//   - each entry is a publisher.name extension id (id characters around a single dot), unique case-insensitively.

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
