/*
---
catzc:
  immutable:
    with_body_sha: f1fdf976480f
  edges:
    test: pwsh/Catzc.Base.Contracts/tests/types/ContractManifest.Tests.ps1
    docs: "[ContractManifest.cs.md](docs/references/pwsh/catzc-base-contracts/types/ContractManifest.cs.md)"
    cites:
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
      - ADR-REPO-CONTRACT-DIRECTIONBYCONVENTION
---
*/

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
