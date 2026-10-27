// The settings Test-BicepApiVersions holds the Bicep modules to; every default is declared once here ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).
using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.QualityGates;

public sealed class BicepApiVersionsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "bicep-api-versions configuration validation failed:\n";
    private static readonly string[] AllowedKeys = { "folders", "max_age_months", "allowed" };
    private static readonly Regex Version = new Regex("^[0-9]{4}-[0-9]{2}-[0-9]{2}(-preview)?$");

    // The repository-relative folders whose .bicep files the gate scans, each walked to the folder-walk depth: the shared modules and the templates.
    public IReadOnlyList<string> folders { get; } = new[] { "infrastructure/modules", "infrastructure/templates" };

    // The oldest a stable API version may be, in months before the run's date; an older one is outdated.
    public int max_age_months { get; } = 36;

    // A deliberate pin per resource type: these versions pass whatever their age or preview state.
    public IReadOnlyDictionary<string, IReadOnlyList<string>> allowed { get; } = new Dictionary<string, IReadOnlyList<string>>(StringComparer.OrdinalIgnoreCase);

    public BicepApiVersionsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { raw = new Hashtable(); }
        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown top-level key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
            }
        }
        if (raw.Contains("folders"))
        {
            var paths = new List<string>();
            object value = raw["folders"];
            if (value is string one) { paths.Add(one); }
            else if (value is IEnumerable list && !(value is IDictionary))
            {
                foreach (object item in list) { paths.Add(item == null ? string.Empty : item.ToString()); }
            }
            if (paths.Count == 0 || paths.Exists(string.IsNullOrWhiteSpace)) { errors.Add("folders must be a non-empty list of repository-relative folders"); }
            else { folders = paths.ConvertAll(p => p.Replace('\\', '/').TrimEnd('/')).ToArray(); }
        }
        if (raw.Contains("max_age_months"))
        {
            int months;
            if (raw["max_age_months"] != null && int.TryParse(raw["max_age_months"].ToString(), NumberStyles.Integer, CultureInfo.InvariantCulture, out months) && months > 0 && months < 1000) { max_age_months = months; }
            else { errors.Add("max_age_months must be a positive integer below 1000"); }
        }
        if (raw.Contains("allowed") && raw["allowed"] != null)
        {
            IDictionary map = raw["allowed"] as IDictionary;
            if (map == null) { errors.Add("allowed must be a mapping of resource type to a list of API versions"); }
            else
            {
                var pins = new Dictionary<string, IReadOnlyList<string>>(StringComparer.OrdinalIgnoreCase);
                foreach (object k in map.Keys)
                {
                    string type = k == null ? string.Empty : k.ToString();
                    var versions = new List<string>();
                    object value = map[k];
                    if (value is string single) { versions.Add(single); }
                    else if (value is IEnumerable list && !(value is IDictionary))
                    {
                        foreach (object item in list) { versions.Add(item == null ? string.Empty : item.ToString()); }
                    }
                    foreach (string version in versions)
                    {
                        if (!Version.IsMatch(version))
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture, "allowed['{0}']: '{1}' is not an API version (yyyy-MM-dd, optionally -preview)", type, version));
                        }
                    }
                    if (versions.Count == 0) { errors.Add(string.Format(CultureInfo.InvariantCulture, "allowed['{0}'] must be a non-empty list of API versions", type)); }
                    pins[type] = versions.ToArray();
                }
                allowed = pins;
            }
        }
        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
    }

    // The finding for one resource type and API version on the given date, or null when the version passes.
    public string Verdict(string type, string version, DateTime today)
    {
        IReadOnlyList<string> pins;
        if (allowed.TryGetValue(type, out pins))
        {
            foreach (string pin in pins)
            {
                if (string.Equals(pin, version, StringComparison.OrdinalIgnoreCase)) { return null; }
            }
        }
        if (version.EndsWith("-preview", StringComparison.OrdinalIgnoreCase)) { return "a preview API version"; }
        DateTime released;
        if (!DateTime.TryParseExact(version, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out released)) { return "not an API version"; }
        if (released < today.Date.AddMonths(-max_age_months))
        {
            return string.Format(CultureInfo.InvariantCulture, "an outdated API version, older than {0} months", max_age_months);
        }
        return null;
    }
}
