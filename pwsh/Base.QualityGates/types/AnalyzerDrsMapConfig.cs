using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Text.RegularExpressions;

namespace Catzc.Base.QualityGates;

// Each enabled analyzer rule that enforces a DRS rule, mapped to the rule ids it enforces.
public sealed class AnalyzerDrsMapConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "analyzer-drs-map configuration validation failed:\n";
    private static readonly Regex Citation = new Regex("^" + Catzc.Base.Drs.DrsCodeForm.AnyKind.Rule + "$");

    // Analyzer rule name -> the DRS rule ids it enforces (string[], '#' form), in declaration order; read-only.
    public OrderedDictionary analyzers { get; }

    // The analyzer's settings, the one file every analyzer run and the formatter read: the internal assets' PSScriptAnalyzerSettings.psd1.
    public static string SettingsPath(string modulesRoot)
    {
        if (string.IsNullOrEmpty(modulesRoot)) { throw new ArgumentException("modulesRoot must not be empty", "modulesRoot"); }
        return new Catzc.Base.Folders.PathSet().AddFile(modulesRoot, ".internal/assets/PSScriptAnalyzerSettings.psd1").ToArray()[0];
    }

    // The custom rule modules the settings list: every .scriptanalyzer/*.psm1 under the modules root, in ordinal order.
    public static string[] RuleFiles(string modulesRoot)
    {
        if (string.IsNullOrEmpty(modulesRoot)) { throw new ArgumentException("modulesRoot must not be empty", "modulesRoot"); }
        return new Catzc.Base.Folders.PathSet().AddPattern(System.IO.Path.Combine(modulesRoot, ".scriptanalyzer"), "*.psm1", 1).ToArray();
    }

    public AnalyzerDrsMapConfig(IDictionary raw)
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
                errors.Add("'analyzers' must be a map of <analyzer rule>: [ <rule code>, ... ], e.g. ADR-PWSH-ERROR-THROWNOTWRITEERROR");
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
                        errors.Add(string.Format("analyzer '{0}' maps to no rule (want a non-empty list of rule codes, e.g. ADR-PWSH-ERROR-THROWNOTWRITEERROR)", rule));
                        continue;
                    }
                    foreach (string id in ids)
                    {
                        if (!Citation.IsMatch(id))
                        {
                            errors.Add(string.Format("analyzer '{0}' has a malformed citation '{1}' (want a rule's code, e.g. ADR-PWSH-ERROR-THROWNOTWRITEERROR)", rule, id));
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
