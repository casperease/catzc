// The single export config (configs/exporter.yml): how this repository exports itself as the installable,
// versioned Catzc build ([ADR-AUTO-BUNDLE](/docs/adr/automation/platform-bundle.md)). Registered in
// Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Exporter.ExporterConfig), so Get-Config -Config exporter
// returns this typed record. Mirrors the YAML mapping (snake_case keys,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Constructing an instance validates the file, collecting every violation into one ArgumentException. Every key
// is required, and an unknown key throws (a typo fails fast at load):
//   direct_install_version  numeric MAJOR.MINOR.PATCH (a valid module version) — the devbox build placeholder
//   version                 numeric MAJOR.MINOR — a pipeline build's version prefix (PATCH is calculated)
//   default_profile         a lowercase profile token (a profiles.yml key; not cross-checked here, so loading
//                           stays self-contained)
//   vendor_policy           'runtime' or 'full'
//   module_guid             a GUID — the Catzc module's stable identity (a registered managed GUID)
//   package                 a well-formed ExporterPackage

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Exporter;

public sealed class ExporterConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys =
        { "direct_install_version", "version", "default_profile", "vendor_policy", "module_guid", "package" };

    // The numeric MAJOR.MINOR.PATCH placeholder every devbox build carries.
    public string direct_install_version { get; }

    // The numeric MAJOR.MINOR of a pipeline build; PATCH is the first-parent commit count of the built commit.
    public string version { get; }

    // The module set built when neither -Module nor -ModuleProfile is given (a profiles.yml key).
    public string default_profile { get; }

    // 'runtime' ships only the runtime-required vendored module; 'full' also ships the test toolset.
    public string vendor_policy { get; }

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
        version = Checked(d, "version", "^[0-9]+\\.[0-9]+$",
            "must be numeric MAJOR.MINOR, quoted; PATCH is calculated by the pipeline", errors);
        default_profile = Checked(d, "default_profile", "^[a-z][a-z0-9]*(-[a-z0-9]+)*$", "a lowercase profile token", errors);
        vendor_policy = Checked(d, "vendor_policy", "^(runtime|full)$", "valid: runtime, full", errors);

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
