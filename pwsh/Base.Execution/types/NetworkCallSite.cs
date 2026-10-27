using System;
using System.Collections;
using System.Globalization;

namespace Catzc.Base.Execution;

// One function that can reach the network, with its class, its trigger and what keeps it off a default path (ADR-AUTO-NET-REGISTRY).
public sealed class NetworkCallSite
{
    static readonly string[] Classes = { "package-install", "price-data", "ado-api", "azure-control-plane", "git-remote" };
    // offline-guarded: on a default path, with the tool held offline by a generated guard (ADR-AUTO-NET-GENERATEDGUARD).
    static readonly string[] Triggers = { "on-request", "pipeline-only", "offline-guarded", "default-path" };
    static readonly string[] Keys = { "function", "class", "trigger", "gated_by" };

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string function { get; }
    public string @class { get; }
    public string trigger { get; }
    public string gated_by { get; }

    // A default-path site breaks ADR-AUTO-NET-NODEFAULTPATH; it stays registered as it is until its plan step lands.
    public bool IsViolation => trigger == "default-path";

    public NetworkCallSite(string path, IDictionary raw)
    {
        if (raw == null)
        {
            throw new ArgumentException(Message(path, "must be a map (function, class, trigger, gated_by)"));
        }
        foreach (object key in raw.Keys)
        {
            string name = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (Array.IndexOf(Keys, name) < 0)
            {
                throw new ArgumentException(Message(path, "unknown key '" + name + "' (allowed: " + string.Join(", ", Keys) + ")"));
            }
        }
        function = Required(path, raw, "function");
        @class = OneOf(path, raw, "class", Classes);
        trigger = OneOf(path, raw, "trigger", Triggers);
        gated_by = Required(path, raw, "gated_by");
    }

    static string Required(string path, IDictionary raw, string key)
    {
        string value = raw.Contains(key) ? Convert.ToString(raw[key], CultureInfo.InvariantCulture) : null;
        if (string.IsNullOrWhiteSpace(value))
        {
            throw new ArgumentException(Message(path, key + " is required"));
        }
        return value;
    }

    static string OneOf(string path, IDictionary raw, string key, string[] allowed)
    {
        string value = Required(path, raw, key);
        if (Array.IndexOf(allowed, value) < 0)
        {
            throw new ArgumentException(Message(path, key + " '" + value + "' is not one of " + string.Join(", ", allowed)));
        }
        return value;
    }

    static string Message(string path, string text) =>
        string.Format(CultureInfo.InvariantCulture, "network-calls config: site '{0}' {1}", path, text);
}
