using System;
using System.Collections;
using System.Collections.Generic;
using Catzc.Base.Languages;

namespace Catzc.Base.Vendor;

// Every violation is reported at once on construction, so a typo in vendor.yml fails at load, not at download.
public sealed class VendorConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { PackageSource.Key };

    // The PSResource repository to download from and validate against: its name is the registered repository, its url the feed (PSGallery by default).
    public PackageSource package_source { get; }

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

        package_source = PackageSource.Read(d != null && d.Contains(PackageSource.Key) ? d[PackageSource.Key] : null, PackageSource.PSGallery, errors);

        if (errors.Count > 0)
        {
            throw new ArgumentException("vendor configuration validation failed:\n" + string.Join("\n", errors));
        }
    }
}
