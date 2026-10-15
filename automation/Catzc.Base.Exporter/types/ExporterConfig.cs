/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Exporter/types/ExporterConfig.cs
    kind: type
    module: Catzc.Base.Exporter
---
*/

// Every key is required and an unknown key throws, so a typo fails fast at load instead of falling to a default.
// [ADR-AUTO-BUNDLE](/docs/adr/automation/platform-bundle.md),
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-base-exporter/types/ExporterConfig.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Exporter;

public sealed class ExporterConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys =
        { "direct_install_version", "bundles", "default_bundle", "module_guid", "package" };

    private static readonly Regex BundleName = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$");

    // The numeric MAJOR.MINOR.PATCH placeholder every devbox build carries.
    public string direct_install_version { get; }

    // The named bundles, keyed by name, in file order.
    public IReadOnlyDictionary<string, ExporterBundle> bundles { get; }

    // The bundle built when none is named (a key of bundles).
    public string default_bundle { get; }

    // The module's stable identity across versions (a GUID string).
    public string module_guid { get; }

    // The package identity and metadata written into the build's Catzc.psd1.
    public ExporterPackage package { get; }

    public ExporterConfig(IDictionary d)
    {
        List<string> errors = new List<string>();
        if (d != null)
        {
            foreach (object k in d.Keys)
            {
                string key = k == null ? null : k.ToString();
                if (Array.IndexOf(AllowedKeys, key) < 0)
                {
                    errors.Add(string.Format("unknown key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
                }
            }
        }

        direct_install_version = Checked(d, "direct_install_version", "^[0-9]+\\.[0-9]+\\.[0-9]+$",
            "must be numeric MAJOR.MINOR.PATCH", errors);

        Dictionary<string, ExporterBundle> bundleMap = new Dictionary<string, ExporterBundle>(StringComparer.Ordinal);
        IDictionary rawBundles = Present(d, "bundles") ? d["bundles"] as IDictionary : null;
        if (rawBundles == null || rawBundles.Count == 0)
        {
            errors.Add("bundles is required and must be a non-empty map of bundle name -> { profile, version, vendor_policy }");
        }
        else
        {
            foreach (object k in rawBundles.Keys)
            {
                string bundleName = k == null ? "" : k.ToString();
                if (!BundleName.IsMatch(bundleName))
                {
                    errors.Add(string.Format("invalid bundle name '{0}' (a lowercase token)", bundleName));
                    continue;
                }
                try { bundleMap[bundleName] = new ExporterBundle(bundleName, rawBundles[k] as IDictionary); }
                catch (ArgumentException ex) { errors.Add(ex.Message); }
            }
        }
        bundles = bundleMap;

        default_bundle = Checked(d, "default_bundle", "^[a-z][a-z0-9]*(-[a-z0-9]+)*$", "a lowercase bundle name", errors);
        if (default_bundle != null && rawBundles != null && !rawBundles.Contains(default_bundle))
        {
            errors.Add(string.Format("default_bundle '{0}' is not one of the bundles", default_bundle));
        }

        if (!Present(d, "module_guid")) { errors.Add("missing required key 'module_guid'"); }
        else
        {
            string guid = d["module_guid"] == null ? "" : d["module_guid"].ToString();
            Guid parsed;
            if (Guid.TryParse(guid, out parsed)) { module_guid = guid; }
            else { errors.Add(string.Format("invalid module_guid '{0}' (must be a GUID)", guid)); }
        }

        if (!Present(d, "package")) { errors.Add("missing required key 'package'"); }
        else
        {
            try { package = new ExporterPackage(d["package"] as IDictionary); }
            catch (ArgumentException ex) { errors.Add(ex.Message); }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("exporter configuration validation failed:\n" + string.Join("\n", errors));
        }
    }

    private static bool Present(IDictionary d, string key) => d != null && d.Contains(key);

    // A required key whose text must match the pattern (case-sensitive); null when missing or invalid.
    private static string Checked(IDictionary d, string key, string pattern, string hint, List<string> errors)
    {
        if (!Present(d, key))
        {
            errors.Add(string.Format("missing required key '{0}'", key));
            return null;
        }
        string value = d[key] == null ? "" : d[key].ToString();
        if (!Regex.IsMatch(value, pattern))
        {
            errors.Add(string.Format("invalid {0} '{1}' ({2})", key, value, hint));
            return null;
        }
        return value;
    }
}
