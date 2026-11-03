using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Exporter;

// One named bundle of exporter.yml, a release identity of its own: its modules, its own version line and its vendored packages.
public sealed class ExporterBundle : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "profile", "version", "max_files", "max_bytes", "platforms" };

    // The platforms a bundle builds binaries for when it states none; rests on [ADR-AUTO-BUNDLE-EVERYLANGUAGE](/docs/drs/automation/platform-bundle.md#rule-adr-auto-bundle-everylanguage).
    private static readonly string[] DefaultPlatforms = { "windows/amd64", "linux/amd64", "darwin/arm64" };

    // The bundle's name — its key under bundles:, and the folder its builds land in.
    public string name { get; }

    // The module set (a profiles.yml key), closure-expanded by the build.
    public string profile { get; }

    // The numeric MAJOR.MINOR of a pipeline build of this bundle; PATCH is the first-parent commit count.
    public string version { get; }

    // The most files a build may hold; null when the bundle states no limit.
    public long? max_files { get; }

    // The most bytes a build may hold; null when the bundle states no limit.
    public long? max_bytes { get; }

    // The <os>/<arch> pairs a packaged binary is built for; the default set when the bundle states none.
    public IReadOnlyList<string> platforms { get; }

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
        max_files = Limit(d, "max_files", label, errors);
        max_bytes = Limit(d, "max_bytes", label, errors);
        platforms = Platforms(d, label, errors);

        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
    }

    // The declared <os>/<arch> list, or the default set when the key is absent; an entry off that form is an error.
    private static string[] Platforms(IDictionary d, string label, List<string> errors)
    {
        if (!d.Contains("platforms") || d["platforms"] == null) { return (string[])DefaultPlatforms.Clone(); }
        IList list = d["platforms"] as IList;
        if (list == null || list.Count == 0)
        {
            errors.Add(label + ": platforms must be a non-empty list of <os>/<arch> entries");
            return Array.Empty<string>();
        }
        List<string> result = new List<string>();
        foreach (object item in list)
        {
            string value = item == null ? "" : item.ToString();
            if (!Regex.IsMatch(value, "^[a-z0-9]+/[a-z0-9]+$"))
            {
                errors.Add(string.Format("{0}: invalid platforms entry '{1}' (<os>/<arch>, lowercase, e.g. linux/amd64)", label, value));
            }
            else if (result.Contains(value))
            {
                errors.Add(string.Format("{0}: duplicate platforms entry '{1}'", label, value));
            }
            else
            {
                result.Add(value);
            }
        }
        return result.ToArray();
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
