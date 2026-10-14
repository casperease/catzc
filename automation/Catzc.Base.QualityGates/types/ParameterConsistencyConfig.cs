// The parameter names Test-ParameterConsistency lets carry more than one type across the public functions
// (configs/parameter-consistency.yml, [ADR-PWSH-PARAM](/docs/adr/pwsh/parameter-design.md)), and the single declaration of
// its sensible default ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)):
//   exempt — parameter name (without the dash) -> why the same name means a different thing in different functions.
//            Omitted: no parameter is exempt. A name is matched case-insensitively; every reason is non-empty.
// Property names mirror the YAML keys (snake_case,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

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
