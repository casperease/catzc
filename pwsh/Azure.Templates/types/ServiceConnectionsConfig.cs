// The deployment identities the service connections are derived from; every default is declared once here ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).
using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Azure.Templates;

// Workload identity federation is the only scheme: the type has no key that could name another, so no identity can carry a stored secret.
public sealed class ServiceConnectionsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "service-connections configuration validation failed:\n";
    private static readonly string[] AllowedKeys = { "identities", "short_name" };
    private static readonly string[] IdentityKeys = { "role", "templates", "azure_role", "description" };
    private static readonly Regex Name = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", RegexOptions.Compiled);
    private static readonly Regex Role = new Regex("^[a-z][a-z0-9]{1,2}$", RegexOptions.Compiled);
    private static readonly Regex ShortName = new Regex("^[a-z][a-z0-9]{1,4}$", RegexOptions.Compiled);

    // Identity name -> its entry, in file order; never mutated after construction.
    public IReadOnlyDictionary<string, ServiceIdentity> identities { get; }

    // The short-name segment of every connection name, the namer's two to five characters.
    public string short_name { get; } = "ado";

    public ServiceConnectionsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the configuration must be a mapping with an identities map"); }
        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown top-level key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
            }
        }
        if (raw.Contains("short_name"))
        {
            string shortName = Convert.ToString(raw["short_name"], CultureInfo.InvariantCulture);
            if (shortName == null || !ShortName.IsMatch(shortName)) { errors.Add("short_name must be 2-5 lowercase alphanumerics with a leading letter"); }
            else { short_name = shortName; }
        }
        identities = Identities(raw.Contains("identities") ? raw["identities"] : null, errors);
        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
    }

    private static IReadOnlyDictionary<string, ServiceIdentity> Identities(object raw, List<string> errors)
    {
        Dictionary<string, ServiceIdentity> map = new Dictionary<string, ServiceIdentity>(StringComparer.Ordinal);
        IDictionary source = raw as IDictionary;
        if (source == null || source.Count == 0)
        {
            errors.Add("'identities' must be a non-empty map of <name>: { role, templates, azure_role, description }");
            return map;
        }
        HashSet<string> roles = new HashSet<string>(StringComparer.Ordinal);
        foreach (DictionaryEntry entry in source)
        {
            string name = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
            string where = "identity '" + name + "'";
            if (name == null || !Name.IsMatch(name)) { errors.Add(where + ": the name must be lowercase words joined by '-'"); continue; }
            ServiceIdentity identity = Identity(name, entry.Value as IDictionary, where, errors);
            if (identity == null) { continue; }
            if (!roles.Add(identity.role)) { errors.Add(where + ": role '" + identity.role + "' is another identity's, and a connection name must tell them apart"); continue; }
            map[name] = identity;
        }
        return map;
    }

    private static ServiceIdentity Identity(string name, IDictionary body, string where, List<string> errors)
    {
        if (body == null) { errors.Add(where + " must be a map of role, templates, azure_role and description"); return null; }
        int before = errors.Count;
        foreach (object k in body.Keys)
        {
            string key = Convert.ToString(k, CultureInfo.InvariantCulture);
            if (Array.IndexOf(IdentityKeys, key) < 0)
            {
                // A scheme or a secret has no key: workload identity federation is the only way a connection authenticates.
                errors.Add(where + ": unknown key '" + key + "' (allowed: " + string.Join(", ", IdentityKeys) + "; every connection uses WorkloadIdentityFederation, so no scheme or secret is configurable)");
            }
        }
        string role = Text(body, "role");
        string azureRole = Text(body, "azure_role");
        string description = Text(body, "description");
        List<string> templates = new List<string>();
        object rawTemplates = body.Contains("templates") ? body["templates"] : null;
        if (rawTemplates is IEnumerable list && !(rawTemplates is string) && !(rawTemplates is IDictionary))
        {
            foreach (object item in list)
            {
                string template = Convert.ToString(item, CultureInfo.InvariantCulture);
                if (string.IsNullOrWhiteSpace(template)) { errors.Add(where + ": a template name is empty"); }
                else { templates.Add(template.Trim()); }
            }
        }
        if (templates.Count == 0) { errors.Add(where + " needs templates, the non-empty list of templates it deploys"); }
        if (role == null || !Role.IsMatch(role)) { errors.Add(where + ": role must be 2-3 lowercase alphanumerics with a leading letter, the role segment of its connection names"); }
        if (string.IsNullOrWhiteSpace(azureRole)) { errors.Add(where + " needs azure_role, the roles.yml name of the role it holds"); }
        if (string.IsNullOrWhiteSpace(description)) { errors.Add(where + " needs a description, one sentence naming what it deploys"); }
        if (errors.Count > before) { return null; }
        return new ServiceIdentity(name, role, templates.ToArray(), azureRole.Trim(), description.Trim());
    }

    private static string Text(IDictionary body, string key)
    {
        return body.Contains(key) ? Convert.ToString(body[key], CultureInfo.InvariantCulture) : null;
    }
}
