// The secret shapes Test-SecretScan looks for and the paths it leaves alone; every default is declared once here ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).
using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.QualityGates;

public sealed class SecretPatternsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "secret-patterns configuration validation failed:\n";
    private static readonly string[] AllowedKeys = { "patterns", "skip" };

    // Each secret shape by name; a placeholder such as <password> or $(secret) never matches, so a documented example passes.
    public IReadOnlyDictionary<string, string> patterns { get; } = new Dictionary<string, string>(StringComparer.Ordinal)
    {
        { "private-key", "-----BEGIN (RSA |EC |DSA |OPENSSH |ENCRYPTED )?PRIVATE KEY-----" },
        { "aws-access-key", "\\bAKIA[0-9A-Z]{16}\\b" },
        { "github-token", "\\bgh[pousr]_[A-Za-z0-9]{36,}\\b" },
        { "azure-storage-key", "AccountKey=[A-Za-z0-9+/]{80,}={0,2}" },
        { "sas-signature", "[?&]sig=[A-Za-z0-9%]{40,}" },
        { "connection-string-password", "(?i)\\b(?:password|pwd)=(?![<$({'\"])[^;'\"\\s<>]{8,}" },
    };

    // Repository-relative path patterns, as PowerShell -like reads them, whose files are never scanned.
    public IReadOnlyList<string> skip { get; } = new[] { "*/tests/*/assets/*", ".vendor/*", "*/.vendor/*" };

    private readonly List<KeyValuePair<string, Regex>> compiled = new List<KeyValuePair<string, Regex>>();

    public SecretPatternsConfig(IDictionary raw)
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
        if (raw.Contains("patterns"))
        {
            IDictionary map = raw["patterns"] as IDictionary;
            if (map == null || map.Count == 0) { errors.Add("patterns must be a non-empty mapping of a name to a regular expression"); }
            else
            {
                var named = new Dictionary<string, string>(StringComparer.Ordinal);
                foreach (object k in map.Keys)
                {
                    string name = k == null ? string.Empty : k.ToString();
                    string expression = map[k] == null ? string.Empty : map[k].ToString();
                    if (expression.Length == 0) { errors.Add(string.Format(CultureInfo.InvariantCulture, "patterns['{0}'] is empty", name)); }
                    named[name] = expression;
                }
                patterns = named;
            }
        }
        if (raw.Contains("skip"))
        {
            var paths = new List<string>();
            object value = raw["skip"];
            if (value is string one) { paths.Add(one); }
            else if (value is IEnumerable list && !(value is IDictionary))
            {
                foreach (object item in list) { paths.Add(item == null ? string.Empty : item.ToString()); }
            }
            if (paths.Exists(string.IsNullOrWhiteSpace)) { errors.Add("skip must be a list of repository-relative path patterns"); }
            else { skip = paths.ToArray(); }
        }
        foreach (KeyValuePair<string, string> pattern in patterns)
        {
            try { compiled.Add(new KeyValuePair<string, Regex>(pattern.Key, new Regex(pattern.Value, RegexOptions.CultureInvariant))); }
            catch (ArgumentException e) { errors.Add(string.Format(CultureInfo.InvariantCulture, "patterns['{0}'] is not a regular expression: {1}", pattern.Key, e.Message)); }
        }
        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
    }

    // The name of each pattern one line matches, in declaration order; empty when the line carries no secret shape.
    public string[] Matches(string line)
    {
        var names = new List<string>();
        foreach (KeyValuePair<string, Regex> pattern in compiled)
        {
            if (pattern.Value.IsMatch(line)) { names.Add(pattern.Key); }
        }
        return names.ToArray();
    }
}
