// A version folder's contract.yml, at contracts/<unit>/<version>/contract.yml
// ([ADR-REPO-CONTRACT#7](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract7)): the exceptions to the direction
// convention. It mirrors the YAML mapping, so the property is snake_case
// ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//   direction  a map of an asset's path under the version folder (<module>/<path>, '/'-separated) to its direction,
//              provided or depended-on. Optional; absent means no override.
// Construction validates the file and collects every violation into one ArgumentException; an unknown key throws.
// That every named asset exists is Get-Contract's check, since only the enumeration knows the assets.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Contracts;

public sealed class ContractManifest
{
    public IReadOnlyDictionary<string, ContractDirection> direction { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public ContractManifest(IDictionary raw)
    {
        var overrides = new Dictionary<string, ContractDirection>(StringComparer.Ordinal);
        var errors = new List<string>();

        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (name != "direction")
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: direction)", name));
                }
            }

            if (raw.Contains("direction") && raw["direction"] != null)
            {
                if (raw["direction"] is IDictionary map)
                {
                    foreach (DictionaryEntry entry in map)
                    {
                        Read(entry, overrides, errors);
                    }
                }
                else
                {
                    errors.Add("direction must be a map of <module>/<path> to provided or depended-on");
                }
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("contract.yml validation failed:\n" + string.Join("\n", errors));
        }
        direction = overrides;
    }

    private static void Read(DictionaryEntry entry, Dictionary<string, ContractDirection> overrides, List<string> errors)
    {
        string asset = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
        string value = Convert.ToString(entry.Value, CultureInfo.InvariantCulture);
        if (string.IsNullOrEmpty(asset) || asset.Contains('\\') || asset.StartsWith("/", StringComparison.Ordinal) || !asset.Contains('/'))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "direction key '{0}' is not a '/'-separated <module>/<path>", asset));
            return;
        }
        if (value == "provided")
        {
            overrides[asset] = ContractDirection.Provided;
        }
        else if (value == "depended-on")
        {
            overrides[asset] = ContractDirection.DependedOn;
        }
        else
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture,
                "direction of '{0}' is '{1}' (valid: provided, depended-on)", asset, value));
        }
    }
}
