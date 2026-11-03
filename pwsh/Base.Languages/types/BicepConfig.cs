using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Globalization;

namespace Catzc.Base.Languages;

public sealed class BicepConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "bicep config validation failed:\n";
    private const string AnalyzersKey = "analyzers";
    private static readonly string[] AllowedKeys = { PackageSource.Key, AnalyzersKey };

    // The module registry a br: reference resolves from; the public registry unless declared.
    public PackageSource package_source { get; }

    // The linter settings rendered as bicepconfig.json's analyzers: analyzer name to its settings map; the core analyzer, enabled and quiet, unless declared.
    public IDictionary analyzers { get; }

    public BicepConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw != null)
        {
            foreach (object k in raw.Keys)
            {
                string key = Convert.ToString(k, CultureInfo.InvariantCulture);
                if (Array.IndexOf(AllowedKeys, key) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
                }
            }
        }

        package_source = PackageSource.Read(raw != null && raw.Contains(PackageSource.Key) ? raw[PackageSource.Key] : null, PackageSource.BicepRegistry, errors);
        analyzers = ReadAnalyzers(raw != null && raw.Contains(AnalyzersKey) ? raw[AnalyzersKey] : null, errors);

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
    }

    private static IDictionary ReadAnalyzers(object value, List<string> errors)
    {
        OrderedDictionary result = new OrderedDictionary();
        if (value == null)
        {
            OrderedDictionary core = new OrderedDictionary();
            core["enabled"] = true;
            core["verbose"] = false;
            result["core"] = core;
            return result;
        }

        IDictionary map = value as IDictionary;
        if (map == null)
        {
            errors.Add("invalid analyzers (must be a map of analyzer name to its settings map)");
            return result;
        }
        foreach (DictionaryEntry entry in map)
        {
            string name = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
            if (!(entry.Value is IDictionary))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "invalid analyzers.{0} (must be a map of settings)", name));
                continue;
            }
            result[name] = entry.Value;
        }
        return result;
    }
}
