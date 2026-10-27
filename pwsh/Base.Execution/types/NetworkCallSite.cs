using System;
using System.Collections;
using System.Globalization;

namespace Catzc.Base.Execution;

// One function or pipeline step that can reach the network, keyed '<file>#<function or step>', with its class, its trigger and what keeps
// it off a default path (ADR-AUTO-NET-SITEREGISTRY).
public sealed class NetworkCallSite
{
    static readonly string[] Classes = { "package-install", "price-data", "ado-api", "azure-control-plane", "git-remote" };
    // offline-guarded: on a default path, with the tool held offline by a generated guard (ADR-AUTO-NET-GENERATEDGUARD).
    static readonly string[] Triggers = { "on-request", "pipeline-only", "offline-guarded", "default-path" };
    static readonly string[] Keys = { "class", "trigger", "gated_by" };

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The repository-relative file, the part of the key before '#'.
    public string path { get; }
    // The function or pipeline job in that file, the part of the key after '#'.
    public string name { get; }
    public string @class { get; }
    public string trigger { get; }
    public string gated_by { get; }

    // A default-path site breaks ADR-AUTO-NET-NODEFAULTPATH; it stays registered as it is until its plan step lands.
    public bool IsViolation => trigger == "default-path";

    public NetworkCallSite(string key, IDictionary raw)
    {
        int hash = key == null ? -1 : key.IndexOf('#');
        if (hash <= 0 || hash == key.Length - 1)
        {
            throw new ArgumentException(Message(key, "must be keyed '<file>#<function or step>'"));
        }
        path = key.Substring(0, hash);
        name = key.Substring(hash + 1);
        if (raw == null)
        {
            throw new ArgumentException(Message(key, "must be a map (class, trigger, gated_by)"));
        }
        foreach (object entry in raw.Keys)
        {
            string field = Convert.ToString(entry, CultureInfo.InvariantCulture);
            if (Array.IndexOf(Keys, field) < 0)
            {
                throw new ArgumentException(Message(key, "unknown key '" + field + "' (allowed: " + string.Join(", ", Keys) + ")"));
            }
        }
        @class = OneOf(key, raw, "class", Classes);
        trigger = OneOf(key, raw, "trigger", Triggers);
        gated_by = Required(key, raw, "gated_by");
    }

    static string Required(string key, IDictionary raw, string field)
    {
        string value = raw.Contains(field) ? Convert.ToString(raw[field], CultureInfo.InvariantCulture) : null;
        if (string.IsNullOrWhiteSpace(value))
        {
            throw new ArgumentException(Message(key, field + " is required"));
        }
        return value;
    }

    static string OneOf(string key, IDictionary raw, string field, string[] allowed)
    {
        string value = Required(key, raw, field);
        if (Array.IndexOf(allowed, value) < 0)
        {
            throw new ArgumentException(Message(key, field + " '" + value + "' is not one of " + string.Join(", ", allowed)));
        }
        return value;
    }

    static string Message(string key, string text) =>
        string.Format(CultureInfo.InvariantCulture, "network-calls config: site '{0}' {1}", key, text);
}
