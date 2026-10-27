using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.Execution;

// The registry of every call site that can reach the network, keyed '<file>#<function or step>' ([ADR-AUTO-NET-SITEREGISTRY](/docs/drs/automation/network-calls.md#rule-adr-auto-net-siteregistry)), so one
// file can hold sites of different classes, and the network patterns Test-NetworkCalls searches the code for ([ADR-AUTO-NET-REGISTRYGATE](/docs/drs/automation/network-calls.md#rule-adr-auto-net-registrygate)).
public sealed class NetworkCallsConfig
{
    static readonly string[] Keys = { "sites", "patterns", "skip" };

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public IReadOnlyDictionary<string, NetworkCallSite> sites { get; }

    // Each network-call shape by name, a regular expression matched against one line of code.
    public IReadOnlyDictionary<string, string> patterns { get; } = new Dictionary<string, string>(StringComparer.Ordinal);

    // Repository-relative path patterns, as PowerShell -like reads them, whose files the gate never searches: the tests mock their calls,
    // and docs, configs and contracts name a call without making it.
    public IReadOnlyList<string> skip { get; } = new[]
    {
        "*/tests/*", "*.md", "docs/*", "contracts/*", ".claude/*", ".unordered/*", "*/.vendor/*", "*/configs/*",
    };

    readonly List<KeyValuePair<string, Regex>> compiled = new List<KeyValuePair<string, Regex>>();

    public NetworkCallsConfig(IDictionary raw)
    {
        var parsed = new SortedDictionary<string, NetworkCallSite>(StringComparer.Ordinal);
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (Array.IndexOf(Keys, name) < 0)
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "network-calls config: unknown key '{0}' (allowed: {1})", name, string.Join(", ", Keys)));
                }
            }
            if (raw.Contains("sites") && raw["sites"] != null)
            {
                var section = raw["sites"] as IDictionary ?? throw new ArgumentException(
                    "network-calls config: sites must be a map of '<file>#<function or step>' to site");
                foreach (object key in section.Keys)
                {
                    string site = Convert.ToString(key, CultureInfo.InvariantCulture);
                    parsed[site] = new NetworkCallSite(site, section[key] as IDictionary);
                }
            }
            if (raw.Contains("patterns") && raw["patterns"] != null)
            {
                patterns = Patterns(raw["patterns"]);
            }
            if (raw.Contains("skip") && raw["skip"] != null)
            {
                skip = Skip(raw["skip"]);
            }
        }
        sites = parsed;
        foreach (KeyValuePair<string, string> pattern in patterns)
        {
            try
            {
                compiled.Add(new KeyValuePair<string, Regex>(pattern.Key, new Regex(pattern.Value, RegexOptions.CultureInvariant)));
            }
            catch (ArgumentException e)
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    "network-calls config: patterns '{0}' is not a regular expression: {1}", pattern.Key, e.Message));
            }
        }
    }

    // The name of each pattern one line matches, in declaration order; empty when the line makes no network call.
    public string[] Matches(string line)
    {
        var names = new List<string>();
        if (string.IsNullOrEmpty(line))
        {
            return names.ToArray();
        }
        foreach (KeyValuePair<string, Regex> pattern in compiled)
        {
            if (pattern.Value.IsMatch(line))
            {
                names.Add(pattern.Key);
            }
        }
        return names.ToArray();
    }

    static IReadOnlyDictionary<string, string> Patterns(object value)
    {
        var map = value as IDictionary ?? throw new ArgumentException(
            "network-calls config: patterns must be a map of a name to a regular expression");
        var named = new Dictionary<string, string>(StringComparer.Ordinal);
        foreach (object key in map.Keys)
        {
            string name = Convert.ToString(key, CultureInfo.InvariantCulture);
            string expression = Convert.ToString(map[key], CultureInfo.InvariantCulture);
            if (string.IsNullOrWhiteSpace(expression))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    "network-calls config: patterns '{0}' is empty", name));
            }
            named[name] = expression;
        }
        return named;
    }

    static IReadOnlyList<string> Skip(object value)
    {
        var paths = new List<string>();
        if (value is string one)
        {
            paths.Add(one);
        }
        else if (value is IEnumerable list && !(value is IDictionary))
        {
            foreach (object item in list)
            {
                paths.Add(Convert.ToString(item, CultureInfo.InvariantCulture));
            }
        }
        else
        {
            paths.Add(null);
        }
        if (paths.Exists(string.IsNullOrWhiteSpace))
        {
            throw new ArgumentException("network-calls config: skip must be a list of repository-relative path patterns");
        }
        return paths.ToArray();
    }
}
