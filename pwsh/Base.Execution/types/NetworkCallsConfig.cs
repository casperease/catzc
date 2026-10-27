using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Execution;

// The registry of every call site that can reach the network, keyed by its repository-relative file (ADR-AUTO-NET-SITEREGISTRY).
public sealed class NetworkCallsConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public IReadOnlyDictionary<string, NetworkCallSite> sites { get; }

    public NetworkCallsConfig(IDictionary raw)
    {
        var parsed = new SortedDictionary<string, NetworkCallSite>(StringComparer.Ordinal);
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (name != "sites")
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "network-calls config: unknown key '{0}' (allowed: sites)", name));
                }
            }
            if (raw.Contains("sites") && raw["sites"] != null)
            {
                var section = raw["sites"] as IDictionary ?? throw new ArgumentException(
                    "network-calls config: sites must be a map of repository-relative file to site");
                foreach (object key in section.Keys)
                {
                    string path = Convert.ToString(key, CultureInfo.InvariantCulture);
                    parsed[path] = new NetworkCallSite(path, section[key] as IDictionary);
                }
            }
        }
        sites = parsed;
    }
}
