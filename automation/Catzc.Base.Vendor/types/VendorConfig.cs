// The vendor module source (configs/vendor.yml) — where Install-VendorModule downloads vendored modules from and
// Remove-VendorModules validates them against ([ADR-AUTO-VENDOR](/docs/adr/automation/powershell/vendor-toolset-dependencies.md)).
// Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Vendor.VendorConfig), so
// Get-Config -Config vendor returns this typed record. Mirrors the YAML keys verbatim (the file's own `sourceUrl`
// spelling, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Constructing an instance validates the file, collecting every violation into one ArgumentException:
//   - only the known keys ('source', 'sourceUrl') — an unknown key (a typo) fails fast at load;
//   - 'source' is required and non-empty (the registered PSResourceRepository name, e.g. PSGallery);
//   - 'sourceUrl', when present, is an absolute URI (a custom Artifactory / proxy feed).

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Vendor;

public sealed class VendorConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "source", "sourceUrl" };

    // The registered PSResourceRepository to download from and validate against (PSGallery by default).
    public string source { get; }

    // A custom repository url, registered under the `source` name on first use. Null when the source is a
    // built-in repository that needs no url.
    public string sourceUrl { get; }

    public VendorConfig(IDictionary d)
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

        source = OptStr(d, "source");
        if (source == null)
        {
            errors.Add("missing required key 'source' (the PSResourceRepository name, e.g. PSGallery)");
        }

        if (d != null && d.Contains("sourceUrl"))
        {
            string url = d["sourceUrl"] == null ? "" : d["sourceUrl"].ToString();
            if (string.IsNullOrWhiteSpace(url) || !Uri.IsWellFormedUriString(url, UriKind.Absolute))
            {
                errors.Add(string.Format("invalid sourceUrl '{0}' (must be an absolute URI)", url));
            }
            else { sourceUrl = url; }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("vendor configuration validation failed:\n" + string.Join("\n", errors));
        }
    }
}
