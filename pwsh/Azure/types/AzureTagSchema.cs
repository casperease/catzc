using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Azure;

// The tags section of azure.yml: the CAF tag keys every taggable resource carries, the closed value set of those that have one, and the
// lowercase provenance tag names a deploy writes. Declared once; the compliance gate and every config check read it.
public sealed class AzureTagSchema
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // A tag key or value: lowercase, digits and single hyphens between words.
    internal const string LowercasePattern = "^[a-z0-9]+(-[a-z0-9]+)*$";

    private static readonly string[] AllowedKeys = { "keys", "provenance" };
    private static readonly string[] ProvenanceKeys = { "commit", "build_id", "branch" };

    // The CAF keys, each to its closed value set; an empty set takes any lowercase value.
    public static IReadOnlyDictionary<string, IReadOnlyList<string>> DefaultKeys { get; } = new Dictionary<string, IReadOnlyList<string>>(StringComparer.Ordinal)
    {
        { "workload", new string[0] },
        { "environment", new[] { "dev", "test", "nonprod", "preprod", "prod" } },
        { "owner", new string[0] },
        { "cost-center", new string[0] },
        { "criticality", new[] { "low", "medium", "high" } },
        { "data-classification", new[] { "public", "internal", "confidential", "restricted" } },
    };

    // The provenance tags a deploy writes: what each records to its tag name.
    public static IReadOnlyDictionary<string, string> DefaultProvenance { get; } = new Dictionary<string, string>(StringComparer.Ordinal)
    {
        { "commit", "deployed-from-commit" },
        { "build_id", "deployed-from-buildid" },
        { "branch", "deployed-from-branch" },
    };

    public IReadOnlyDictionary<string, IReadOnlyList<string>> keys { get; }

    public IReadOnlyDictionary<string, string> provenance { get; }

    public AzureTagSchema(object raw, List<string> errors)
    {
        keys = DefaultKeys;
        provenance = DefaultProvenance;
        if (raw == null) { return; }
        IDictionary d = raw as IDictionary;
        if (d == null) { errors.Add("tags must be a mapping of keys and provenance"); return; }
        foreach (object k in d.Keys)
        {
            if (Array.IndexOf(AllowedKeys, k == null ? null : k.ToString()) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "tags: unknown key '{0}' (allowed: {1})", k, string.Join(", ", AllowedKeys)));
            }
        }
        if (d.Contains("keys")) { keys = ReadKeys(d["keys"], errors) ?? keys; }
        if (d.Contains("provenance")) { provenance = ReadProvenance(d["provenance"], errors) ?? provenance; }
    }

    // Every way the given tags break the schema: a dropped key, a value outside its set, a key or value that is not lowercase.
    public string[] TagErrors(IDictionary tags)
    {
        var found = new List<string>();
        if (tags == null) { return new[] { "carries no tags" }; }
        var missing = new List<string>();
        foreach (string key in keys.Keys)
        {
            if (!tags.Contains(key)) { missing.Add(key); }
        }
        if (missing.Count > 0) { found.Add("misses the CAF tag(s) " + string.Join(", ", missing)); }
        foreach (object k in tags.Keys)
        {
            string key = k == null ? string.Empty : k.ToString();
            string value = tags[k] == null ? string.Empty : tags[k].ToString();
            if (IsProvenance(key)) { continue; }
            if (!Regex.IsMatch(key, LowercasePattern)) { found.Add(string.Format(CultureInfo.InvariantCulture, "tag key '{0}' is not lowercase", key)); }
            IReadOnlyList<string> allowed;
            if (keys.TryGetValue(key, out allowed) && allowed.Count > 0 && !Contains(allowed, value))
            {
                found.Add(string.Format(CultureInfo.InvariantCulture, "tag {0} '{1}' is not one of {2}", key, value, string.Join(", ", allowed)));
            }
            else if (!Regex.IsMatch(value, LowercasePattern))
            {
                found.Add(string.Format(CultureInfo.InvariantCulture, "tag {0} '{1}' is not lowercase", key, value));
            }
        }
        return found.ToArray();
    }

    // A provenance tag, of any template prefix: its value is a commit, build id or branch, not a schema value.
    private bool IsProvenance(string key)
    {
        foreach (string name in provenance.Values)
        {
            if (key == name || key.EndsWith("-" + name, StringComparison.Ordinal)) { return true; }
        }
        return false;
    }

    private static bool Contains(IReadOnlyList<string> list, string value)
    {
        foreach (string item in list)
        {
            if (string.Equals(item, value, StringComparison.Ordinal)) { return true; }
        }
        return false;
    }

    private static IReadOnlyDictionary<string, IReadOnlyList<string>> ReadKeys(object raw, List<string> errors)
    {
        IDictionary d = raw as IDictionary;
        if (d == null || d.Count == 0) { errors.Add("tags.keys must be a non-empty mapping of tag key to its allowed values"); return null; }
        var map = new Dictionary<string, IReadOnlyList<string>>(StringComparer.Ordinal);
        foreach (object k in d.Keys)
        {
            string key = k == null ? string.Empty : k.ToString();
            if (!Regex.IsMatch(key, LowercasePattern)) { errors.Add(string.Format(CultureInfo.InvariantCulture, "tags.keys: '{0}' is not lowercase", key)); }
            var values = new List<string>();
            object value = d[k];
            if (value is IEnumerable list && !(value is string) && !(value is IDictionary))
            {
                foreach (object item in list) { values.Add(item == null ? string.Empty : item.ToString()); }
            }
            else if (value != null) { errors.Add(string.Format(CultureInfo.InvariantCulture, "tags.keys['{0}'] must be a list of allowed values, empty for any", key)); }
            foreach (string v in values)
            {
                if (!Regex.IsMatch(v, LowercasePattern)) { errors.Add(string.Format(CultureInfo.InvariantCulture, "tags.keys['{0}']: value '{1}' is not lowercase", key, v)); }
            }
            map[key] = values.ToArray();
        }
        return map;
    }

    private static IReadOnlyDictionary<string, string> ReadProvenance(object raw, List<string> errors)
    {
        IDictionary d = raw as IDictionary;
        if (d == null) { errors.Add("tags.provenance must be a mapping of commit, build_id and branch to a tag name"); return null; }
        var map = new Dictionary<string, string>(StringComparer.Ordinal);
        foreach (string key in ProvenanceKeys)
        {
            string name = d.Contains(key) && d[key] != null ? d[key].ToString() : null;
            if (name == null) { errors.Add(string.Format(CultureInfo.InvariantCulture, "tags.provenance misses '{0}'", key)); continue; }
            if (!Regex.IsMatch(name, LowercasePattern)) { errors.Add(string.Format(CultureInfo.InvariantCulture, "tags.provenance['{0}']: '{1}' is not lowercase", key, name)); }
            map[key] = name;
        }
        foreach (object k in d.Keys)
        {
            if (Array.IndexOf(ProvenanceKeys, k == null ? null : k.ToString()) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "tags.provenance: unknown key '{0}' (allowed: {1})", k, string.Join(", ", ProvenanceKeys)));
            }
        }
        return map;
    }
}
