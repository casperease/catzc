// catzc:
//   path: automation/Catzc.Base.QualityGates/types/AnalyzerAdrMapConfig.cs
//   module: Catzc.Base.QualityGates

// Load checks only shape and citation grammar; that each id names a real rule is the integrity test's job, keeping load hermetic.
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8),
// [ADR-AZ-CUSTOMER#3](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer3)
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/AnalyzerAdrMapConfig.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Text.RegularExpressions;

namespace Catzc.Base.QualityGates;

public sealed class AnalyzerAdrMapConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "analyzer-adr-map configuration validation failed:\n";
    private static readonly Regex Citation = new Regex(@"^ADR-[A-Z]+(?:-[A-Z]+)*#\d+$");

    // Analyzer rule name -> the ADR rule ids it enforces (string[], '#' form), in declaration order; read-only.
    public OrderedDictionary analyzers { get; }

    public AnalyzerAdrMapConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the configuration must be a mapping"); }

        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "analyzers") { errors.Add(string.Format("unknown top-level key '{0}' (allowed: analyzers)", key)); }
        }

        OrderedDictionary map = new OrderedDictionary(StringComparer.OrdinalIgnoreCase);
        if (!raw.Contains("analyzers"))
        {
            errors.Add("Missing required top-level key: 'analyzers'");
        }
        else
        {
            object analyzersRaw = raw["analyzers"];
            IDictionary source = analyzersRaw as IDictionary;
            if (analyzersRaw != null && source == null)
            {
                errors.Add("'analyzers' must be a map of <analyzer rule>: [ ADR-<CODE>#<n>, ... ]");
            }
            else if (source == null || source.Count == 0)
            {
                errors.Add("analyzers is empty");
            }
            else
            {
                foreach (object k in source.Keys)
                {
                    string rule = k == null ? "" : k.ToString();
                    if (string.IsNullOrWhiteSpace(rule))
                    {
                        errors.Add("an analyzer rule name is empty");
                        continue;
                    }
                    string[] ids = ReadIds(source[k]);
                    if (ids.Length == 0)
                    {
                        errors.Add(string.Format("analyzer '{0}' maps to no ADR rule (want a non-empty list of ADR-<CODE>#<n>)", rule));
                        continue;
                    }
                    foreach (string id in ids)
                    {
                        if (!Citation.IsMatch(id))
                        {
                            errors.Add(string.Format("analyzer '{0}' has a malformed citation '{1}' (want ADR-<CODE>#<n>, e.g. ADR-PWSH-ERROR#3)", rule, id));
                        }
                    }
                    map[rule] = ids;
                }
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        analyzers = map.AsReadOnly();
    }

    // The ids an analyzer maps to: a list, or a single scalar id (one-element).
    private static string[] ReadIds(object value)
    {
        if (value == null) { return new string[0]; }
        if (value is string) { return new[] { (string)value }; }
        List<string> ids = new List<string>();
        IEnumerable list = value as IEnumerable;
        if (list == null || value is IDictionary) { return new[] { value.ToString() }; }
        foreach (object item in list) { ids.Add(item == null ? "" : item.ToString()); }
        return ids.ToArray();
    }
}
