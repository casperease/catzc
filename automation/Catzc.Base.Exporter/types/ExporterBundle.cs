// One named bundle of configs/exporter.yml (`bundles.<name>`): a release identity of its own — which modules it
// carries, its own version line, and which vendored modules travel with it
// ([ADR-AUTO-BUNDLE](/docs/adr/automation/platform-bundle.md)). The repository is a mono repo, so every bundle
// versions on its own; no bundle's version moves another's. Mirrors the YAML mapping (snake_case keys,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Constructing an instance validates the block, collecting every violation into one ArgumentException:
//   profile        required; the module set (a profiles.yml key; not cross-checked here, so loading stays
//                  self-contained)
//   version        required; numeric MAJOR.MINOR of a pipeline build of this bundle (PATCH is calculated)
//   vendor_policy  'runtime' (the default) ships only the runtime-required vendored module; 'full' also ships the
//                  test toolset

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Exporter;

public sealed class ExporterBundle : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "profile", "version", "vendor_policy" };

    // The bundle's name — its key under bundles:, and the folder its builds land in.
    public string name { get; }

    // The module set (a profiles.yml key), closure-expanded by the build.
    public string profile { get; }

    // The numeric MAJOR.MINOR of a pipeline build of this bundle; PATCH is the first-parent commit count.
    public string version { get; }

    // 'runtime' or 'full'; 'runtime' when the bundle does not say.
    public string vendor_policy { get; }

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

        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
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
