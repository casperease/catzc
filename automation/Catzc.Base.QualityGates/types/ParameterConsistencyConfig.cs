/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/ParameterConsistencyConfig.cs
    kind: type
    language: csharp
    filekind: cs
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/types/ParameterConsistencyConfig.cs.md
      test: automation/Catzc.Base.QualityGates/tests/types/ParameterConsistencyConfig.Tests.ps1
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
      - ADR-PWSH-PARAM
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.QualityGates;

public sealed class ParameterConsistencyConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly Regex ParameterName = new Regex("^[A-Za-z][A-Za-z0-9]*$");

    public IReadOnlyDictionary<string, string> exempt { get; }

    public ParameterConsistencyConfig(IDictionary raw)
    {
        var exemptions = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        var errors = new List<string>();
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (name != "exempt")
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: exempt)", name));
                }
            }
            if (raw.Contains("exempt") && raw["exempt"] != null)
            {
                if (!(raw["exempt"] is IDictionary map))
                {
                    errors.Add("exempt must be a map of parameter name to reason");
                }
                else
                {
                    foreach (DictionaryEntry entry in map)
                    {
                        string name = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
                        string reason = Convert.ToString(entry.Value, CultureInfo.InvariantCulture)?.Trim() ?? "";
                        if (!ParameterName.IsMatch(name))
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture, "exempt: invalid parameter name '{0}' (no dash, e.g. Kind)", name));
                        }
                        else if (reason.Length == 0)
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture, "exempt.{0} needs the reason the name carries more than one type", name));
                        }
                        else if (exemptions.ContainsKey(name))
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture, "exempt: duplicate parameter name '{0}'", name));
                        }
                        else
                        {
                            exemptions[name] = reason;
                        }
                    }
                }
            }
        }
        if (errors.Count > 0)
        {
            throw new ArgumentException("parameter-consistency config validation failed:\n  - " + string.Join("\n  - ", errors));
        }
        exempt = exemptions;
    }

    // Whether a parameter name (without the dash) is exempt.
    public bool IsExempt(string name) => name != null && exempt.ContainsKey(name);
}
