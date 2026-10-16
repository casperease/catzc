/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Vendor/types/VendorConfig.cs
    kind: type
    language: csharp
    filetype: cs
    track: automation
    module: Catzc.Base.Vendor
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-vendor/types/VendorConfig.cs.md
      test: automation/Catzc.Base.Vendor/tests/types/VendorConfig.Tests.ps1
    adrs:
      - ADR-AUTO-TYPES#8
      - ADR-PWSH-VENDOR
---
*/

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Vendor;

public sealed class VendorConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "source", "sourceUrl" };

    // The registered PSResourceRepository to download from and validate against (PSGallery by default).
    public string source { get; }

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
