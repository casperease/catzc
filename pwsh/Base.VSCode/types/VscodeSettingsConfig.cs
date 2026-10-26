/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-vs-code/types/VscodeSettingsConfig.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Catzc.Base.VSCode;

public sealed class VscodeSettingsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "vscode-settings config validation failed:\n";

    // Every VS Code setting key -> its value, in authored order — what settings.json receives; read-only.
    public OrderedDictionary settings { get; }

    public IReadOnlyDictionary<string, string[]> hidden_actions { get; }

    public IReadOnlyDictionary<string, string> carried { get; }

    // Each .editorconfig section glob -> the VS Code language ids its properties render into; the [*] section needs no row.
    public IReadOnlyDictionary<string, string[]> editorconfig { get; }

    public VscodeSettingsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the registry must be a mapping"); }

        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "settings" && key != "hidden_actions" && key != "carried" && key != "editorconfig") { errors.Add(string.Format("unknown top-level key '{0}' (allowed: settings, hidden_actions, carried, editorconfig)", key)); }
        }

        Dictionary<string, string> carry = new Dictionary<string, string>(StringComparer.Ordinal);
        object carriedValue = raw.Contains("carried") ? raw["carried"] : null;
        if (carriedValue != null && !(carriedValue is IDictionary)) { errors.Add("'carried' must be a map of setting key -> owner key"); }
        else if (carriedValue != null)
        {
            foreach (DictionaryEntry entry in (IDictionary)carriedValue)
            {
                string owner = entry.Value as string;
                if (string.IsNullOrWhiteSpace(owner)) { errors.Add(string.Format("carried '{0}' must name the setting key that lists its owned rows", entry.Key)); continue; }
                carry[entry.Key.ToString()] = owner;
            }
        }
        carried = carry;

        Dictionary<string, string[]> sections = new Dictionary<string, string[]>(StringComparer.Ordinal);
        object sectionsValue = raw.Contains("editorconfig") ? raw["editorconfig"] : null;
        if (sectionsValue != null && !(sectionsValue is IDictionary)) { errors.Add("'editorconfig' must be a map of section glob -> language ids"); }
        else if (sectionsValue != null)
        {
            foreach (DictionaryEntry entry in (IDictionary)sectionsValue)
            {
                IList ids = entry.Value as IList;
                List<string> languages = new List<string>();
                if (ids != null && !(entry.Value is string))
                {
                    foreach (object id in ids) { if (id is string text && text.Length > 0) { languages.Add(text); } }
                }
                if (languages.Count == 0) { errors.Add(string.Format("editorconfig '{0}' must list the language ids it renders into", entry.Key)); continue; }
                sections[entry.Key.ToString()] = languages.ToArray();
            }
        }
        editorconfig = sections;

        Dictionary<string, string[]> hidden = new Dictionary<string, string[]>(StringComparer.Ordinal);
        object declared = raw.Contains("hidden_actions") ? raw["hidden_actions"] : null;
        if (declared != null && !(declared is IDictionary)) { errors.Add("'hidden_actions' must be a map of menu id -> command ids"); }
        else if (declared != null)
        {
            foreach (DictionaryEntry menu in (IDictionary)declared)
            {
                List<string> commands = new List<string>();
                IList list = menu.Value as IList;
                if (list == null || menu.Value is string) { errors.Add(string.Format("hidden_actions '{0}' must be a list of command ids", menu.Key)); continue; }
                foreach (object item in list)
                {
                    string command = item as string;
                    if (string.IsNullOrWhiteSpace(command)) { errors.Add(string.Format("hidden_actions '{0}': '{1}' is not a command id", menu.Key, item)); }
                    else { commands.Add(command); }
                }
                if (commands.Count == 0) { errors.Add(string.Format("hidden_actions '{0}' names no command", menu.Key)); }
                hidden[menu.Key.ToString()] = commands.ToArray();
            }
        }
        hidden_actions = hidden;

        OrderedDictionary map = new OrderedDictionary(StringComparer.OrdinalIgnoreCase);
        IDictionary source = raw.Contains("settings") ? raw["settings"] as IDictionary : null;
        if (source == null || source.Count == 0)
        {
            errors.Add("'settings' must be a non-empty map of VS Code setting keys");
        }
        else
        {
            foreach (object k in source.Keys)
            {
                string key = k == null ? "" : k.ToString();
                object value = source[k];
                if (key.StartsWith("[") && key.EndsWith("]") && !(value is IDictionary))
                {
                    errors.Add(string.Format("language override '{0}' must be a map of settings", key));
                }
                if (key == "search.exclude") { CheckExclude(value, errors); }
                map[key] = value;
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        settings = map.AsReadOnly();
    }

    private static void CheckExclude(object value, List<string> errors)
    {
        IDictionary exclude = value as IDictionary;
        if (exclude == null)
        {
            errors.Add("'search.exclude' must be a map of glob -> true/false");
            return;
        }
        foreach (object k in exclude.Keys)
        {
            if (!(exclude[k] is bool))
            {
                errors.Add(string.Format("'search.exclude' entry '{0}' must be true or false", k));
            }
        }
    }
}
