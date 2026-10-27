using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Azure;

// The Azure built-in roles the templates assign, by name, each with its fixed role definition id.
public sealed class RolesConfig : Catzc.Base.Objects.DictionaryRecord
{
    static readonly Regex Name = new Regex("^[a-z][a-z0-9]*(_[a-z0-9]+)*$", RegexOptions.Compiled);
    static readonly Regex CanonicalGuid = new Regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", RegexOptions.Compiled);

    // Role name -> its id and description, in file order; never mutated after construction.
    public IReadOnlyDictionary<string, AzureRole> roles { get; }

    public RolesConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException("roles configuration validation failed:\nthe configuration must be a mapping"); }
        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "roles") { errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown top-level key '{0}' (allowed: roles)", key)); }
        }

        Dictionary<string, AzureRole> map = new Dictionary<string, AzureRole>(StringComparer.Ordinal);
        HashSet<string> ids = new HashSet<string>(StringComparer.Ordinal);
        IDictionary source = raw.Contains("roles") ? raw["roles"] as IDictionary : null;
        if (raw.Contains("roles") && raw["roles"] != null && source == null) { errors.Add("'roles' must be a map of <snake_case_name>: { id, description }"); }
        if (source != null)
        {
            foreach (DictionaryEntry entry in source)
            {
                string name = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
                string where = "role '" + name + "'";
                if (name == null || !Name.IsMatch(name)) { errors.Add(where + ": the name must be snake_case"); continue; }
                IDictionary body = entry.Value as IDictionary;
                if (body == null) { errors.Add(where + " must be a map with an id and a description"); continue; }
                foreach (object k in body.Keys)
                {
                    string key = Convert.ToString(k, CultureInfo.InvariantCulture);
                    if (key != "id" && key != "description") { errors.Add(where + ": unknown key '" + key + "' (allowed: id, description)"); }
                }
                string id = body.Contains("id") ? Convert.ToString(body["id"], CultureInfo.InvariantCulture) : null;
                string description = body.Contains("description") ? Convert.ToString(body["description"], CultureInfo.InvariantCulture) : null;
                if (id == null || !CanonicalGuid.IsMatch(id)) { errors.Add(where + ": the id must be the role definition GUID, lowercase and hyphenated"); continue; }
                if (string.IsNullOrWhiteSpace(description)) { errors.Add(where + " needs a description naming the role and what it grants"); continue; }
                if (!ids.Add(id)) { errors.Add(where + ": id '" + id + "' is declared twice"); continue; }
                map[name] = new AzureRole(name, id, description.Trim());
            }
        }

        if (errors.Count > 0) { throw new ArgumentException("roles configuration validation failed:\n" + string.Join("\n", errors)); }
        roles = map;
    }
}

// One built-in role: the name a template uses, its fixed definition id, and what it grants.
public sealed class AzureRole : Catzc.Base.Objects.DictionaryRecord
{
    public string name { get; }
    public string id { get; }
    public string description { get; }

    public AzureRole(string name, string id, string description)
    {
        this.name = name;
        this.id = id;
        this.description = description;
    }
}
