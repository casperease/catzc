/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.VSCode/types/VscodeOwnExtension.cs
    folder: types
    name: vscode-own-extension
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: automation/Catzc.Base.VSCode/tests/types/VscodeExtensionsConfig.Tests.ps1
    cites:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Text.RegularExpressions;

namespace Catzc.Base.VSCode;

public sealed class VscodeOwnExtension : Catzc.Base.Objects.DictionaryRecord
{
    public const string DefaultPublisher = "catzc";
    public const string DefaultVersion = "0.1.0";
    public const string DefaultEngine = "^1.90.0";

    private static readonly Regex ExtensionName = new Regex(@"^[a-z0-9][a-z0-9-]*$");
    private static readonly string[] AllowedKeys = { "displayName", "description", "version", "publisher", "engine", "activationEvents", "contributes" };

    // The extension's name: its package name and the name of its script under assets/extensions/<name>.js.
    public string name { get; }

    public string displayName { get; }

    public string description { get; }

    public string version { get; }

    public string publisher { get; }

    // The editor engine range the extension needs (package.json engines.vscode).
    public string engine { get; }

    public string[] activationEvents { get; }

    // The package.json contributes block, in authored order; empty when the extension contributes nothing.
    public OrderedDictionary contributes { get; }

    public VscodeOwnExtension(string name, object raw)
    {
        List<string> errors = new List<string>();
        this.name = name;
        if (name == null || !ExtensionName.IsMatch(name))
        {
            errors.Add(string.Format("extension name '{0}' must be lower-case letters, digits and hyphens", name));
        }

        IDictionary entry = raw as IDictionary;
        if (entry == null) { throw new ArgumentException(string.Format("extension '{0}' must be a mapping", name)); }

        foreach (object k in entry.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format("extension '{0}': unknown key '{1}' (allowed: {2})", name, key, string.Join(", ", AllowedKeys)));
            }
        }

        displayName = Text(entry, "displayName", null, errors);
        description = Text(entry, "description", null, errors);
        version = Text(entry, "version", DefaultVersion, errors);
        publisher = Text(entry, "publisher", DefaultPublisher, errors);
        engine = Text(entry, "engine", DefaultEngine, errors);

        List<string> events = new List<string>();
        object value = entry.Contains("activationEvents") ? entry["activationEvents"] : null;
        if (value is string) { events.Add((string)value); }
        else if (value is IEnumerable && !(value is IDictionary)) { foreach (object item in (IEnumerable)value) { if (item is string) { events.Add((string)item); } else { errors.Add(string.Format("extension '{0}': activation event '{1}' is not a string", name, item)); } } }
        if (events.Count == 0) { errors.Add(string.Format("extension '{0}': 'activationEvents' must be a non-empty list", name)); }
        activationEvents = events.ToArray();

        OrderedDictionary map = new OrderedDictionary(StringComparer.Ordinal);
        object block = entry.Contains("contributes") ? entry["contributes"] : null;
        if (block is IDictionary) { foreach (DictionaryEntry pair in (IDictionary)block) { map[pair.Key.ToString()] = pair.Value; } }
        else if (block != null) { errors.Add(string.Format("extension '{0}': 'contributes' must be a mapping", name)); }
        contributes = map.AsReadOnly();

        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
    }

    private string Text(IDictionary entry, string key, string fallback, List<string> errors)
    {
        if (!entry.Contains(key) || entry[key] == null)
        {
            if (fallback == null) { errors.Add(string.Format("extension '{0}' is missing a non-empty '{1}'", name, key)); }
            return fallback;
        }
        string value = entry[key] as string;
        if (string.IsNullOrWhiteSpace(value))
        {
            errors.Add(string.Format("extension '{0}': '{1}' must be a non-empty string", name, key));
            return fallback;
        }
        return value;
    }
}
