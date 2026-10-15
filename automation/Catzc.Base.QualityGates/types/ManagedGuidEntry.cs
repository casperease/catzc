// catzc:
//   path: automation/Catzc.Base.QualityGates/types/ManagedGuidEntry.cs
//   module: Catzc.Base.QualityGates

// Value uniqueness spans both sections, so GuidsConfig checks it; an entry validates only its own name, keys and fields.
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/ManagedGuidEntry.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.QualityGates;

public sealed class ManagedGuidEntry : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly Regex SnakeCase = new Regex("^[a-z][a-z0-9_]*$");
    private static readonly Regex Canonical = new Regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$");

    // The canonical lowercase hyphenated GUID.
    public string guid { get; }

    // What the GUID identifies.
    public string description { get; }

    // The ConvertTo-Guid source sentence of a minted placeholder; null when the GUID was not minted.
    public string sentence { get; }

    public ManagedGuidEntry(string section, string name, object raw)
    {
        List<string> errors = new List<string>();
        bool denied = section == "denied";
        string[] allowedKeys = denied ? new[] { "guid", "description" } : new[] { "guid", "description", "sentence" };

        if (name == null || !SnakeCase.IsMatch(name))
        {
            errors.Add(string.Format(
                "{0} entry name '{1}' is invalid (must be snake_case: leading lowercase letter, then lowercase alphanumerics/underscores)",
                section, name));
        }

        IDictionary entry = raw as IDictionary;
        if (entry == null)
        {
            errors.Add(string.Format("{0} entry '{1}' must be a map with keys: {2}", section, name, string.Join(", ", allowedKeys)));
            throw new ArgumentException(string.Join("\n", errors));
        }

        foreach (object k in entry.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(allowedKeys, key) < 0)
            {
                errors.Add(string.Format("{0} entry '{1}' carries unknown key '{2}' (allowed: {3})", section, name, key, string.Join(", ", allowedKeys)));
            }
        }

        if (!entry.Contains("guid"))
        {
            errors.Add(string.Format("{0} entry '{1}' is missing 'guid'", section, name));
        }
        else
        {
            guid = entry["guid"] == null ? "" : entry["guid"].ToString();
            if (!Canonical.IsMatch(guid))
            {
                errors.Add(string.Format("{0} entry '{1}' has invalid guid '{2}' (must be the canonical lowercase hyphenated form)", section, name, guid));
            }
        }

        description = OptStr(entry, "description");
        if (description == null) { errors.Add(string.Format("{0} entry '{1}' is missing a non-empty 'description'", section, name)); }

        if (entry.Contains("sentence"))
        {
            sentence = OptStr(entry, "sentence");
            if (sentence == null)
            {
                errors.Add(string.Format("{0} entry '{1}' has an empty 'sentence' (omit the key, or give the ConvertTo-Guid source sentence)", section, name));
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
    }
}
