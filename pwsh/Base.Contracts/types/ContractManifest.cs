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

// A version folder's contract.yml: applies_to, each asset's globs, is its only key.
public sealed class ContractManifest
{
    // Each asset's globs; it constrains every tracked file they match.
    public IReadOnlyDictionary<string, string[]> applies_to { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public ContractManifest(IDictionary raw)
    {
        var globs = new Dictionary<string, string[]>(StringComparer.Ordinal);
        var errors = new List<string>();

        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (name != "applies_to")
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: applies_to)", name));
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
                    errors.Add("applies_to must be a map of an asset's path in the version folder to a list of globs");
                }
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("contract.yml validation failed:\n" + string.Join("\n", errors));
        }
        applies_to = globs;
    }

    // An asset's key: its path below the version folder, <file>, <group>/<file> or <group>/<folder>/<file>; never deeper.
    private static bool IsKey(string asset)
    {
        if (string.IsNullOrEmpty(asset) || asset.Contains('\\') || asset.StartsWith("/", StringComparison.Ordinal))
        {
            return false;
        }
        string[] segments = asset.Split('/');
        if (segments.Length > 3)
        {
            return false;
        }
        foreach (string segment in segments)
        {
            if (segment.Length == 0 || segment == "." || segment == "..")
            {
                return false;
            }
        }
        return true;
    }

    private static void ReadGlobs(DictionaryEntry entry, Dictionary<string, string[]> globs, List<string> errors)
    {
        string asset = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
        if (!IsKey(asset))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "applies_to key '{0}' is not an asset's <file>, <group>/<file> or <group>/<folder>/<file> in the version folder", asset));
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
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "applies_to of '{0}': '{1}' is not a repository-relative '/'-separated glob", asset, glob));
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
}
