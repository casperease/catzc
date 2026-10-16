/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.Exporter/types/ExporterBundle.cs
    folder: types
    name: exporter-bundle
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.Exporter
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-exporter/types/ExporterBundle.cs.md
    cites:
      - ADR-AUTO-BUNDLE
      - ADR-AUTO-TYPES#8
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Exporter;

public sealed class ExporterBundle : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "profile", "version", "vendor_policy", "max_files", "max_bytes" };

    // The bundle's name — its key under bundles:, and the folder its builds land in.
    public string name { get; }

    // The module set (a profiles.yml key), closure-expanded by the build.
    public string profile { get; }

    // The numeric MAJOR.MINOR of a pipeline build of this bundle; PATCH is the first-parent commit count.
    public string version { get; }

    // 'runtime' or 'full'; 'runtime' when the bundle does not say.
    public string vendor_policy { get; }

    // The most files a build may hold; null when the bundle states no limit.
    public long? max_files { get; }

    // The most bytes a build may hold; null when the bundle states no limit.
    public long? max_bytes { get; }

    public ExporterBundle(string bundleName, IDictionary d)
    {
        string label = string.Format("bundles.{0}", bundleName);
        if (d == null) { throw new ArgumentException(label + " must be a map"); }
        List<string> errors = new List<string>();
        foreach (object k in d.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format("{0}: unknown key '{1}' (allowed: {2})", label, key, string.Join(", ", AllowedKeys)));
            }
        }

        name = bundleName;
        profile = Matching(d, "profile", "^[a-z][a-z0-9]*(-[a-z0-9]+)*$", "a lowercase profile token", label, errors, true);
        version = Matching(d, "version", "^[0-9]+\\.[0-9]+$", "numeric MAJOR.MINOR, quoted; PATCH is calculated by the pipeline", label, errors, true);
        vendor_policy = Matching(d, "vendor_policy", "^(runtime|full)$", "valid: runtime, full", label, errors, false) ?? "runtime";
        max_files = Limit(d, "max_files", label, errors);
        max_bytes = Limit(d, "max_bytes", label, errors);

        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
    }

    // An optional positive whole-number limit; null when absent or invalid (an invalid one is an error).
    private static long? Limit(IDictionary d, string key, string label, List<string> errors)
    {
        string value = OptStr(d, key);
        if (value == null) { return null; }
        long parsed;
        if (!long.TryParse(value, System.Globalization.NumberStyles.None, System.Globalization.CultureInfo.InvariantCulture, out parsed) || parsed <= 0)
        {
            errors.Add(string.Format("{0}: invalid {1} '{2}' (a positive whole number)", label, key, value));
            return null;
        }
        return parsed;
    }

    // The key's text when it matches the pattern; null when it is missing (an error only when required) or invalid.
    private static string Matching(IDictionary d, string key, string pattern, string hint, string label, List<string> errors, bool required)
    {
        string value = OptStr(d, key);
        if (value == null)
        {
            if (required) { errors.Add(string.Format("{0}: missing required key '{1}'", label, key)); }
            return null;
        }
        if (!Regex.IsMatch(value, pattern))
        {
            errors.Add(string.Format("{0}: invalid {1} '{2}' ({3})", label, key, value, hint));
            return null;
        }
        return value;
    }
}
