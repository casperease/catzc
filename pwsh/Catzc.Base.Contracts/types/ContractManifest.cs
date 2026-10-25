/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-contracts/types/ContractManifest.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Contracts;

public sealed class ContractManifest
{
    public IReadOnlyDictionary<string, ContractDirection> direction { get; }

    public IReadOnlyDictionary<string, string[]> applies_to { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public ContractManifest(IDictionary raw)
    {
        var overrides = new Dictionary<string, ContractDirection>(StringComparer.Ordinal);
        var globs = new Dictionary<string, string[]>(StringComparer.Ordinal);
        var errors = new List<string>();

        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (name != "direction" && name != "applies_to")
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: direction, applies_to)", name));
                }
            }

            if (raw.Contains("applies_to") && raw["applies_to"] != null)
            {
                if (raw["applies_to"] is IDictionary targets)
                {
                    foreach (DictionaryEntry entry in targets)
                    {
                        ReadGlobs(entry, globs, errors);
                    }
                }
                else
                {
                    errors.Add("applies_to must be a map of <module>/<path> to a list of globs");
                }
            }

            if (raw.Contains("direction") && raw["direction"] != null)
            {
                if (raw["direction"] is IDictionary map)
                {
                    foreach (DictionaryEntry entry in map)
                    {
                        Read(entry, overrides, errors);
                    }
                }
                else
                {
                    errors.Add("direction must be a map of <module>/<path> to provided or depended-on");
                }
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("contract.yml validation failed:\n" + string.Join("\n", errors));
        }
        direction = overrides;
        applies_to = globs;
    }

    private static void ReadGlobs(DictionaryEntry entry, Dictionary<string, string[]> globs, List<string> errors)
    {
        string asset = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
        if (string.IsNullOrEmpty(asset) || asset.Contains('\\') || asset.StartsWith("/", StringComparison.Ordinal) || !asset.Contains('/'))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "applies_to key '{0}' is not a '/'-separated <module>/<path>", asset));
            return;
        }
        var patterns = new List<string>();
        if (entry.Value is IList list && !(entry.Value is string))
        {
            foreach (object item in list)
            {
                string glob = Convert.ToString(item, CultureInfo.InvariantCulture);
                if (string.IsNullOrWhiteSpace(glob) || glob.Contains('\\') || glob.StartsWith("/", StringComparison.Ordinal))
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "applies_to of '{0}': '{1}' is not a relative '/'-separated glob", asset, glob));
                }
                else
                {
                    patterns.Add(glob);
                }
            }
        }
        if (patterns.Count == 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "applies_to of '{0}' must be a non-empty list of globs", asset));
            return;
        }
        globs[asset] = patterns.ToArray();
    }

    private static void Read(DictionaryEntry entry, Dictionary<string, ContractDirection> overrides, List<string> errors)
    {
        string asset = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
        string value = Convert.ToString(entry.Value, CultureInfo.InvariantCulture);
        if (string.IsNullOrEmpty(asset) || asset.Contains('\\') || asset.StartsWith("/", StringComparison.Ordinal) || !asset.Contains('/'))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "direction key '{0}' is not a '/'-separated <module>/<path>", asset));
            return;
        }
        if (value == "provided")
        {
            overrides[asset] = ContractDirection.Provided;
        }
        else if (value == "depended-on")
        {
            overrides[asset] = ContractDirection.DependedOn;
        }
        else
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture,
                "direction of '{0}' is '{1}' (valid: provided, depended-on)", asset, value));
        }
    }
}
