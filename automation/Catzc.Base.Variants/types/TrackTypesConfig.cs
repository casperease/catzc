/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Variants/types/TrackTypesConfig.cs
    folder: types
    name: track-types-config
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: automation/Catzc.Base.Variants/tests/types/TrackTypesConfig.Tests.ps1
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Base.Variants;

public sealed class TrackTypesConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    static readonly Regex Name = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", RegexOptions.Compiled);

    // The closed set of roles a track type has.
    public static readonly string[] Roles = { "deployable", "holder" };

    // Every track type, in declared order.
    public IReadOnlyList<TrackTypeEntry> types { get; }

    // Every vendor, in declared order.
    public IReadOnlyList<VendorEntry> vendors { get; }

    public TrackTypesConfig(IDictionary raw)
    {
        if (raw == null) { throw new ArgumentException("track-types config: the configuration must be a mapping"); }
        foreach (object key in raw.Keys)
        {
            string name = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (name != "track_types" && name != "vendors")
            {
                throw new ArgumentException("track-types config: unknown key '" + name + "' (allowed: track_types, vendors)");
            }
        }
        var typeList = new List<TrackTypeEntry>();
        if (raw.Contains("track_types") && raw["track_types"] != null)
        {
            if (!(raw["track_types"] is IDictionary map)) { throw new ArgumentException("track-types config: track_types must be a map of track type to its entry"); }
            foreach (DictionaryEntry entry in map)
            {
                string id = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
                CheckName("track type", id);
                typeList.Add(ParseType(id, entry.Value as IDictionary));
            }
        }
        var vendorList = new List<VendorEntry>();
        if (raw.Contains("vendors") && raw["vendors"] != null)
        {
            if (!(raw["vendors"] is IDictionary map)) { throw new ArgumentException("track-types config: vendors must be a map of vendor to its entry"); }
            foreach (DictionaryEntry entry in map)
            {
                string id = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
                CheckName("vendor", id);
                vendorList.Add(ParseVendor(id, entry.Value as IDictionary));
            }
        }
        types = typeList;
        vendors = vendorList;
    }

    static void CheckName(string what, string id)
    {
        if (id == null || !Name.IsMatch(id)) { throw new ArgumentException("track-types config: " + what + " '" + id + "' must be lowercase words joined by '-'"); }
    }

    static string Definition(string where, IDictionary entry)
    {
        string definition = entry.Contains("definition") ? Convert.ToString(entry["definition"], CultureInfo.InvariantCulture) : null;
        if (string.IsNullOrWhiteSpace(definition)) { throw new ArgumentException(where + " needs a definition, one sentence that says what it is"); }
        return definition.Trim();
    }

    static TrackTypeEntry ParseType(string id, IDictionary entry)
    {
        string where = "track-types config: track type '" + id + "'";
        if (entry == null) { throw new ArgumentException(where + " must be a map with a definition, a role and admits"); }
        foreach (object key in entry.Keys)
        {
            string name = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (name != "definition" && name != "role" && name != "admits")
            {
                throw new ArgumentException(where + ": unknown key '" + name + "' (allowed: definition, role, admits)");
            }
        }
        string definition = Definition(where, entry);
        string role = entry.Contains("role") ? Convert.ToString(entry["role"], CultureInfo.InvariantCulture) : null;
        if (Array.IndexOf(Roles, role) < 0) { throw new ArgumentException(where + ": invalid role '" + role + "' (valid: " + string.Join(", ", Roles) + ")"); }
        var admits = new List<string>();
        if (entry.Contains("admits") && entry["admits"] != null)
        {
            if (!(entry["admits"] is IEnumerable items) || entry["admits"] is string) { throw new ArgumentException(where + ": admits must be a list of module types"); }
            foreach (object item in items)
            {
                string moduleType = Convert.ToString(item, CultureInfo.InvariantCulture);
                CheckName("admitted module type", moduleType);
                if (admits.Contains(moduleType)) { throw new ArgumentException(where + ": module type '" + moduleType + "' is admitted twice"); }
                admits.Add(moduleType);
            }
        }
        return new TrackTypeEntry(id, definition, role, admits);
    }

    static VendorEntry ParseVendor(string id, IDictionary entry)
    {
        string where = "track-types config: vendor '" + id + "'";
        if (entry == null) { throw new ArgumentException(where + " must be a map with a definition"); }
        foreach (object key in entry.Keys)
        {
            string name = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (name != "definition") { throw new ArgumentException(where + ": unknown key '" + name + "' (allowed: definition)"); }
        }
        return new VendorEntry(id, Definition(where, entry));
    }

    // The track type with this id, or null when none is declared.
    public TrackTypeEntry TypeOf(string id) => types.FirstOrDefault(t => string.Equals(t.id, id, StringComparison.Ordinal));

    // The vendor with this id, or null when none is declared.
    public VendorEntry VendorOf(string id) => vendors.FirstOrDefault(v => string.Equals(v.id, id, StringComparison.Ordinal));
}
