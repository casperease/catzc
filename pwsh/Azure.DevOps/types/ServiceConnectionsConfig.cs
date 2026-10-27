using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Azure.DevOps;

// The project's Azure service connections. Workload identity federation is the only scheme: the type has no key that could name another,
// so a connection with a stored secret cannot be written here.
public sealed class ServiceConnectionsConfig : Catzc.Base.Objects.DictionaryRecord
{
    // The scheme every connection authenticates with.
    public const string Scheme = "WorkloadIdentityFederation";

    static readonly Regex Name = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", RegexOptions.Compiled);

    // Connection name -> its entry, in file order; never mutated after construction.
    public IReadOnlyDictionary<string, ServiceConnectionEntry> connections { get; }

    public ServiceConnectionsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException("service-connections configuration validation failed:\nthe configuration must be a mapping"); }
        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "connections") { errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown top-level key '{0}' (allowed: connections)", key)); }
        }

        Dictionary<string, ServiceConnectionEntry> map = new Dictionary<string, ServiceConnectionEntry>(StringComparer.Ordinal);
        IDictionary source = raw.Contains("connections") ? raw["connections"] as IDictionary : null;
        if (raw.Contains("connections") && raw["connections"] != null && source == null) { errors.Add("'connections' must be a map of <name>: { subscription, description }"); }
        if (source != null)
        {
            foreach (DictionaryEntry entry in source)
            {
                string name = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
                string where = "connection '" + name + "'";
                if (name == null || !Name.IsMatch(name)) { errors.Add(where + ": the name must be lowercase words joined by '-'"); continue; }
                IDictionary body = entry.Value as IDictionary;
                if (body == null) { errors.Add(where + " must be a map with a subscription and a description"); continue; }
                foreach (object k in body.Keys)
                {
                    string key = Convert.ToString(k, CultureInfo.InvariantCulture);
                    if (key != "subscription" && key != "description")
                    {
                        // A scheme or a secret has no key: workload identity federation is the only way a connection authenticates.
                        errors.Add(where + ": unknown key '" + key + "' (allowed: subscription, description; every connection uses " + Scheme + ", so no scheme or secret is configurable)");
                    }
                }
                string subscription = body.Contains("subscription") ? Convert.ToString(body["subscription"], CultureInfo.InvariantCulture) : null;
                string description = body.Contains("description") ? Convert.ToString(body["description"], CultureInfo.InvariantCulture) : null;
                if (string.IsNullOrWhiteSpace(subscription)) { errors.Add(where + " needs the azure.yml subscription it connects to"); continue; }
                if (string.IsNullOrWhiteSpace(description)) { errors.Add(where + " needs a description, one sentence naming what it reaches"); continue; }
                map[name] = new ServiceConnectionEntry(name, subscription.Trim(), description.Trim());
            }
        }

        if (errors.Count > 0) { throw new ArgumentException("service-connections configuration validation failed:\n" + string.Join("\n", errors)); }
        connections = map;
    }
}

// One service connection: its name, the azure.yml subscription it reaches, and what it is for.
public sealed class ServiceConnectionEntry : Catzc.Base.Objects.DictionaryRecord
{
    public string name { get; }
    public string subscription { get; }
    public string description { get; }

    public ServiceConnectionEntry(string name, string subscription, string description)
    {
        this.name = name;
        this.subscription = subscription;
        this.description = description;
    }
}
