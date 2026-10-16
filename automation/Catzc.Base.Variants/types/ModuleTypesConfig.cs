/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/types/ModuleTypesConfig.cs
    folder: types
    name: module-types-config
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-variants/types/ModuleTypesConfig.cs.md
      test: automation/Catzc.Base.Variants/tests/types/ModuleTypesConfig.Tests.ps1
    adrs:
      - ADR-DSGN-TRACK#3
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Base.Variants;

public sealed class ModuleTypesConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    static readonly Regex Name = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", RegexOptions.Compiled);

    // Every module type in precedence order: the first whose places match a path names its module.
    public IReadOnlyList<ModuleTypeEntry> types { get; }

    public ModuleTypesConfig(IDictionary raw)
    {
        if (raw == null) { throw new ArgumentException("module-types config: the configuration must be a mapping"); }
        foreach (object key in raw.Keys)
        {
            string name = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (name != "module_types") { throw new ArgumentException("module-types config: unknown key '" + name + "' (allowed: module_types)"); }
        }
        var list = new List<ModuleTypeEntry>();
        if (raw.Contains("module_types") && raw["module_types"] != null)
        {
            if (!(raw["module_types"] is IDictionary map)) { throw new ArgumentException("module-types config: module_types must be a map of module type to its entry"); }
            foreach (DictionaryEntry entry in map)
            {
                string id = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
                if (id == null || !Name.IsMatch(id)) { throw new ArgumentException("module-types config: module type '" + id + "' must be lowercase words joined by '-'"); }
                list.Add(Parse(id, entry.Value as IDictionary));
            }
        }
        types = list;
    }

    static ModuleTypeEntry Parse(string id, IDictionary entry)
    {
        string where = "module-types config: module type '" + id + "'";
        if (entry == null) { throw new ArgumentException(where + " must be a map with a definition and places"); }
        foreach (object key in entry.Keys)
        {
            string name = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (name != "definition" && name != "places") { throw new ArgumentException(where + ": unknown key '" + name + "' (allowed: definition, places)"); }
        }
        string definition = entry.Contains("definition") ? Convert.ToString(entry["definition"], CultureInfo.InvariantCulture) : null;
        if (string.IsNullOrWhiteSpace(definition)) { throw new ArgumentException(where + " needs a definition, one sentence that says what the module type is"); }
        var places = new List<ModulePlace>();
        if (entry.Contains("places") && entry["places"] is IEnumerable items && !(entry["places"] is string))
        {
            foreach (object item in items) { places.Add(ParsePlace(where, item as IDictionary)); }
        }
        if (places.Count == 0) { throw new ArgumentException(where + " needs at least one place"); }
        return new ModuleTypeEntry(id, definition.Trim(), places);
    }

    static ModulePlace ParsePlace(string where, IDictionary place)
    {
        if (place == null) { throw new ArgumentException(where + ": a place must be a map of root, name, and optionally extension and prefix"); }
        foreach (object key in place.Keys)
        {
            string name = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (name != "root" && name != "name" && name != "extension" && name != "prefix")
            {
                throw new ArgumentException(where + ": unknown place key '" + name + "' (allowed: root, name, extension, prefix)");
            }
        }
        string root = place.Contains("root") ? Convert.ToString(place["root"], CultureInfo.InvariantCulture) : null;
        if (string.IsNullOrWhiteSpace(root) || root.Contains('\\') || root.StartsWith("/", StringComparison.Ordinal) || root.EndsWith("/", StringComparison.Ordinal))
        {
            throw new ArgumentException(where + ": a place's root is a repository-relative folder with '/' separators and no leading or trailing '/', not '" + root + "'");
        }
        string naming = place.Contains("name") ? Convert.ToString(place["name"], CultureInfo.InvariantCulture) : null;
        if (naming != "folder" && naming != "file" && naming != "root")
        {
            throw new ArgumentException(where + ": a place's name is folder, file or root, not '" + naming + "'");
        }
        string extension = place.Contains("extension") ? Convert.ToString(place["extension"], CultureInfo.InvariantCulture) : null;
        if (naming == "file" && (string.IsNullOrWhiteSpace(extension) || extension.StartsWith(".", StringComparison.Ordinal)))
        {
            throw new ArgumentException(where + ": a file place names the extension, without its dot");
        }
        if (naming != "file" && extension != null) { throw new ArgumentException(where + ": only a file place has an extension"); }
        string prefix = place.Contains("prefix") ? Convert.ToString(place["prefix"], CultureInfo.InvariantCulture) : null;
        if (naming != "folder" && prefix != null) { throw new ArgumentException(where + ": only a folder place has a prefix"); }
        return new ModulePlace(root, naming, extension, prefix);
    }

    // The module a repository-relative path is placed in, or null when no module type places it.
    public PathModule Resolve(string path)
    {
        if (path == null) { return null; }
        string normalized = path.Replace('\\', '/');
        foreach (ModuleTypeEntry type in types)
        {
            foreach (ModulePlace place in type.places)
            {
                string name = place.NameOf(normalized);
                if (name != null) { return new PathModule(name, type.id, place.TailOf(normalized)); }
            }
        }
        return null;
    }
}
