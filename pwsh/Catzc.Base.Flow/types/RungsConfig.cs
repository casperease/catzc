/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-flow/types/RungsConfig.cs.md"
  warning: "Generated Header"
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.Flow;

// The promotion ladder's rungs, in climbing order ([FDR-CD-RUNGSREGISTRY](/docs/drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-rungsregistry)).
public sealed class RungsConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const string GateNone = "none";
    public const string GateRc = "rc";
    public const string GateRbc = "rbc";
    public const string GateProdApproval = "prod-approval";

    // The gates a rung may name: none (CD deploys on merge), the two release gates, and the prod approval gate.
    public static readonly IReadOnlyList<string> Gates = Array.AsReadOnly(new[] { GateNone, GateRc, GateRbc, GateProdApproval });

    public static readonly IReadOnlyList<Rung> DefaultRungs = Array.AsReadOnly(new[]
    {
        new Rung("main-uat", "dev", GateNone, new[] { "FDR-CD-CDSTAYSINNONPROD" }),
        new Rung("release-uat", "test", GateRc, new[] { "FDR-CD-TWORELEASEGATES" }),
        new Rung("pre-prod", "preprod", GateRbc, new[] { "FDR-CD-PREPRODRUNG", "FDR-CD-CERTIFYINGRECORD" }),
        new Rung("prod", "prod", GateProdApproval, new[] { "FDR-CD-PRODAPPROVALGATE", "FDR-CD-TWOENVIRONMENTACTIVATION" }),
    });

    private static readonly string[] AllowedKeys = { "rungs" };
    private static readonly string[] AllowedRungKeys = { "environment", "gate", "rules" };
    private static readonly Regex RuleCode = new Regex("^" + Catzc.Base.Drs.DrsCodeForm.AnyKind.Cited + "$");
    private static readonly Regex KebabCase = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$");

    // The rungs in climbing order.
    public IReadOnlyList<Rung> rungs { get; }

    public RungsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        IReadOnlyList<Rung> value = DefaultRungs;

        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (Array.IndexOf(AllowedKeys, name) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: {1})", name, string.Join(", ", AllowedKeys)));
                }
            }
            if (raw.Contains("rungs") && raw["rungs"] != null)
            {
                value = ReadRungs(raw["rungs"], errors);
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("rungs configuration validation failed:\n" + string.Join("\n", errors));
        }
        rungs = value;
    }

    // The rungs whose entry gate is one of the given gates, in climbing order.
    public IReadOnlyList<Rung> GatedBy(params string[] gates)
    {
        List<Rung> found = new List<Rung>();
        foreach (Rung rung in rungs)
        {
            if (Array.IndexOf(gates, rung.gate) >= 0) { found.Add(rung); }
        }
        return found.AsReadOnly();
    }

    private static IReadOnlyList<Rung> ReadRungs(object value, List<string> errors)
    {
        IDictionary map = value as IDictionary;
        if (map == null || map.Count == 0)
        {
            errors.Add("rungs must be a non-empty map of <rung>: { environment, gate }, in climbing order");
            return Array.Empty<Rung>();
        }

        List<Rung> found = new List<Rung>();
        HashSet<string> environments = new HashSet<string>(StringComparer.Ordinal);
        foreach (DictionaryEntry entry in map)
        {
            string name = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
            if (!KebabCase.IsMatch(name))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "rung '{0}' is not kebab-case", name));
            }
            IDictionary fields = entry.Value as IDictionary;
            if (fields == null)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "rung '{0}' must be a map of environment and gate", name));
                continue;
            }
            foreach (object key in fields.Keys)
            {
                string field = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (Array.IndexOf(AllowedRungKeys, field) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "rung '{0}': unknown key '{1}' (allowed: {2})", name, field, string.Join(", ", AllowedRungKeys)));
                }
            }
            string environment = fields["environment"] as string;
            if (string.IsNullOrWhiteSpace(environment))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "rung '{0}' names no environment", name));
            }
            else if (!environments.Add(environment))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "rung '{0}' maps to the environment '{1}', which another rung maps to", name, environment));
            }
            string gate = fields["gate"] as string;
            if (gate == null || !Contains(Gates, gate))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "rung '{0}': gate '{1}' is not one of: {2}", name, gate, string.Join(", ", Gates)));
            }
            List<string> rules = new List<string>();
            if (fields.Contains("rules") && fields["rules"] != null)
            {
                IList listed = fields["rules"] as IList;
                if (listed == null)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "rung '{0}': rules must be a list of ADR rule codes", name));
                }
                else
                {
                    foreach (object item in listed)
                    {
                        string code = Convert.ToString(item, CultureInfo.InvariantCulture);
                        if (code == null || !RuleCode.IsMatch(code))
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture, "rung '{0}': '{1}' is not an ADR rule code", name, code));
                            continue;
                        }
                        rules.Add(code);
                    }
                }
            }
            found.Add(new Rung(name, environment, gate, rules.ToArray()));
        }
        return found.AsReadOnly();
    }

    private static bool Contains(IReadOnlyList<string> items, string item)
    {
        foreach (string candidate in items)
        {
            if (string.Equals(candidate, item, StringComparison.Ordinal)) { return true; }
        }
        return false;
    }
}
