/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Contracts/types/ContractManifest.cs
    folder: types
    name: contract-manifest
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-contracts/types/ContractManifest.cs.md
    test: automation/Catzc.Base.Contracts/tests/types/ContractManifest.Tests.ps1
    cites:
      - ADR-AUTO-TYPES#8
      - ADR-REPO-CONTRACT#7
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
