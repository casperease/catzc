/*
---
catzc:
  immutable:
    path: automation/Catzc.Azure/types/AzureEnvironmentRecord.cs
    folder: types
    name: azure-environment-record
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Azure
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md
    cites:
      - ADR-AUTO-TYPES#8
      - ADR-AZ-DATAMOD
      - ADR-AZ-NAMING
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Azure;

public sealed class AzureEnvironmentRecord : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "shortcode", "region", "region_code", "per_subscription" };

    // The environment's readable name (the map key).
    public string name { get; }

    // The unique 2-letter code. Null when missing or invalid (a violation is recorded).
    public string shortcode { get; }

    // The Azure deployment location (e.g. westeurope). Null when missing or empty.
    public string region { get; }

    // The 3-letter region name component (e.g. weu). Null when missing or invalid.
    public string region_code { get; }

    // True marks a once-per-subscription identity environment (nsub/psub); absent means false.
    public bool per_subscription { get; }

    // Builds the record and throws one ArgumentException listing every violation.
    public AzureEnvironmentRecord(string name, IDictionary d) : this(name, d, null) { }

    // Builds the record best-effort, appending every violation to `errors` (throws only when `errors` is null).
    internal AzureEnvironmentRecord(string name, IDictionary d, List<string> errors)
    {
        List<string> own = errors ?? new List<string>();
        int before = own.Count;
        this.name = name;

        if (name == null || !Regex.IsMatch(name, "^[a-z][a-z0-9]+$"))
        {
            own.Add(string.Format("environment name '{0}' is invalid (must be 2+ lowercase alphanumeric chars, leading letter)", name));
        }
        if (d == null)
        {
            own.Add(string.Format("environment '{0}' must be a mapping with shortcode, region, region_code", name));
        }
        else
        {
            AzureConfig.UnknownKeys(d, AllowedKeys, string.Format("environment '{0}'", name), own);

            if (!d.Contains("shortcode")) { own.Add(string.Format("environment '{0}' is missing 'shortcode'", name)); }
            else
            {
                string value = AzureConfig.Text(d["shortcode"]);
                if (Regex.IsMatch(value, "^[a-z]{2}$")) { shortcode = value; }
                else { own.Add(string.Format("environment '{0}' has invalid shortcode '{1}' (must be 2 lowercase letters)", name, value)); }
            }

            if (!d.Contains("region")) { own.Add(string.Format("environment '{0}' is missing 'region'", name)); }
            else
            {
                region = OptStr(d, "region");
                if (region == null) { own.Add(string.Format("environment '{0}' has empty 'region'", name)); }
            }

            if (!d.Contains("region_code")) { own.Add(string.Format("environment '{0}' is missing 'region_code'", name)); }
            else
            {
                string value = AzureConfig.Text(d["region_code"]);
                if (Regex.IsMatch(value, "^[a-z]{3}$")) { region_code = value; }
                else { own.Add(string.Format("environment '{0}' has invalid region_code '{1}' (must be 3 lowercase letters, e.g. weu)", name, value)); }
            }

            if (d.Contains("per_subscription"))
            {
                if (d["per_subscription"] is bool) { per_subscription = (bool)d["per_subscription"]; }
                else
                {
                    own.Add(string.Format("environment '{0}' has invalid per_subscription '{1}' (must be a boolean: true or false)", name, AzureConfig.Text(d["per_subscription"])));
                }
            }
        }

        if (errors == null && own.Count > before) { throw new ArgumentException(string.Join("\n", own)); }
    }
}
