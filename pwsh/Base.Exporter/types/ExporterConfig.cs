using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Exporter;

// exporter.yml, the single export config: how this repository exports itself as the installable, versioned build.
public sealed class ExporterConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys =
        { "direct_install_version", "bundles", "default_bundle", "module_guid", "package", "runtime_internal_files",
          "full_internal_files" };

    private static readonly string[] DefaultRuntimeInternalFiles =
    {
        "Catzc.Internal.Bootstrap.psm1", "Catzc.Internal.Importer.psm1", "Catzc.Internal.Loader.psm1",
        "Catzc.Internal.Types.psm1", "Catzc.Internal.Vendor.psm1", "assets/ErrorView.format.ps1xml",
        "assets/Wait-CatzcRunLock.ps1", "assets/types-load.yml", "assets/bootstrap/**", "assets/importer/**", "assets/types/**"
    };

    private static readonly string[] DefaultFullInternalFiles =
        { "Catzc.Internal.TestKit.psm1", "assets/PSScriptAnalyzerSettings.psd1" };

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

    // The .internal files every bundle ships, as globs relative to .internal; a file ships only when a glob names it.
    public string[] runtime_internal_files { get; }

    // The .internal files only a full-policy bundle adds, as globs relative to .internal.
    public string[] full_internal_files { get; }

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

        runtime_internal_files = Globs(d, "runtime_internal_files", DefaultRuntimeInternalFiles, errors);
        full_internal_files = Globs(d, "full_internal_files", DefaultFullInternalFiles, errors);

        if (errors.Count > 0)
        {
            throw new ArgumentException("exporter configuration validation failed:\n" + string.Join("\n", errors));
        }
    }

    private static bool Present(IDictionary d, string key) => d != null && d.Contains(key);

    // An optional list of globs, the default when absent; each glob must parse.
    private static string[] Globs(IDictionary d, string key, string[] fallback, List<string> errors)
    {
        if (!Present(d, key)) { return fallback; }
        IEnumerable raw = d[key] as IEnumerable;
        if (raw == null || d[key] is string)
        {
            errors.Add(string.Format("{0} must be a list of globs", key));
            return fallback;
        }
        List<string> globs = new List<string>();
        foreach (object item in raw)
        {
            string glob = item == null ? "" : item.ToString();
            try { new Catzc.Base.Objects.GlobPattern(glob); globs.Add(glob); }
            catch (ArgumentException ex) { errors.Add(string.Format("invalid glob '{0}' in {1}: {2}", glob, key, ex.Message)); }
        }
        return globs.ToArray();
    }

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
